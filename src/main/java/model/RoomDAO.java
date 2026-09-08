package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 회의실 / 회의실 예약 DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 Room_ReserveDTO 만 있고 테이블·DAO·서비스가 없어서
 *   room-reserve 화면 3종이 전부 하드코딩이었다.
 *   → room / room_reserve 테이블과 함께 새로 구현했다.
 *
 * ★ 예약 중복 검사
 *   회의실 예약에서 가장 중요한 로직이다.
 *   "기존 예약의 시작 &lt; 새 예약의 종료" 이고
 *   "기존 예약의 종료 &gt; 새 예약의 시작" 이면 시간대가 겹친다.
 *   (경계가 딱 맞닿는 10:00~11:00 과 11:00~12:00 은 겹치지 않는다)
 * </pre>
 */
public class RoomDAO {

	private static final String DT_FORMAT = "YYYY-MM-DD HH24:MI";

	public static final String STATUS_RESERVED = "予約";
	public static final String STATUS_CANCELED = "取消";

	// =================================================================
	// 회의실 마스터
	// =================================================================

	/** 사용 가능한 회의실 목록 */
	public List<RoomDTO> getRoomList() {

		List<RoomDTO> list = new ArrayList<>();

		String sql = "SELECT room_code, room_name, capacity, location, equipment, use_yn "
				+ "FROM room WHERE use_yn = 'Y' ORDER BY room_code";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				list.add(mapRoom(rs));
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] getRoomList 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 특정 날짜의 회의실별 예약 건수를 포함한 목록 (예약 현황판용) */
	public List<RoomDTO> getRoomListWithCount(String date) {

		List<RoomDTO> list = new ArrayList<>();

		String sql = "SELECT r.room_code, r.room_name, r.capacity, r.location, r.equipment, r.use_yn, "
				+ "  (SELECT COUNT(*) FROM room_reserve rr "
				+ "    WHERE rr.room_code = r.room_code "
				+ "      AND rr.status = '" + STATUS_RESERVED + "' "
				+ "      AND TRUNC(rr.start_time) = TO_DATE(?, 'YYYY-MM-DD')) AS reserve_count "
				+ "FROM room r WHERE r.use_yn = 'Y' ORDER BY r.room_code";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, date);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					RoomDTO dto = mapRoom(rs);
					dto.setReserve_count(rs.getInt("reserve_count"));
					list.add(dto);
				}
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] getRoomListWithCount 실패 : " + e.getMessage());
		}
		return list;
	}

	private RoomDTO mapRoom(ResultSet rs) throws SQLException {

		RoomDTO dto = new RoomDTO();
		dto.setRoom_code(rs.getString("room_code"));
		dto.setRoom_name(rs.getString("room_name"));
		dto.setCapacity(rs.getInt("capacity"));
		dto.setLocation(rs.getString("location"));
		dto.setEquipment(rs.getString("equipment"));
		dto.setUse_yn(rs.getString("use_yn"));
		return dto;
	}

	// =================================================================
	// 예약
	// =================================================================

	private static final String RESERVE_COLUMNS =
			"  rr.reserve_no, rr.room_code, rr.employee_id, rr.meeting_title, rr.attendees, rr.status, "
			+ "TO_CHAR(rr.start_time, 'YYYY-MM-DD HH24:MI') AS start_time, "
			+ "TO_CHAR(rr.end_time,   'YYYY-MM-DD HH24:MI') AS end_time, "
			+ "TO_CHAR(rr.reg_date,   'YYYY-MM-DD')         AS reg_date, "
			+ "r.room_name, r.capacity, r.location, "
			+ "e.emp_name, d.dept_name ";

	private static final String RESERVE_FROM =
			"FROM room_reserve rr "
			+ "  LEFT JOIN room       r ON rr.room_code   = r.room_code "
			+ "  LEFT JOIN employee   e ON rr.employee_id = e.employee_id "
			+ "  LEFT JOIN department d ON e.dept_code    = d.dept_code ";

	private Room_ReserveDTO mapReserve(ResultSet rs) throws SQLException {

		Room_ReserveDTO dto = new Room_ReserveDTO();

		dto.setReserve_no(rs.getInt("reserve_no"));
		dto.setRoom_code(rs.getString("room_code"));
		dto.setRoom_name(rs.getString("room_name"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setMeeting_title(rs.getString("meeting_title"));
		dto.setAttendees(rs.getString("attendees"));
		dto.setStatus(rs.getString("status"));
		dto.setStart_time(rs.getString("start_time"));
		dto.setEnd_time(rs.getString("end_time"));
		dto.setReg_date(rs.getString("reg_date"));
		dto.setCapacity(rs.getInt("capacity"));
		dto.setLocation(rs.getString("location"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));

		return dto;
	}

	/**
	 * ★ 예약 시간 중복 여부 검사.
	 *
	 * @param excludeReserveNo 수정 시 자기 자신을 제외하기 위한 예약번호 (신규면 0)
	 * @return 겹치는 예약이 있으면 true
	 */
	public boolean isOverlapped(String roomCode, String startTime, String endTime, int excludeReserveNo) {

		String sql = "SELECT COUNT(*) FROM room_reserve "
				+ "WHERE room_code = ? "
				+ "  AND status = ? "
				+ "  AND reserve_no <> ? "
				// 시간대 겹침 판정
				+ "  AND start_time < TO_DATE(?, '" + DT_FORMAT + "') "
				+ "  AND end_time   > TO_DATE(?, '" + DT_FORMAT + "')";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, roomCode);
			pstmt.setString(2, STATUS_RESERVED);
			pstmt.setInt(3, excludeReserveNo);
			pstmt.setString(4, endTime); // 기존.start < 신규.end
			pstmt.setString(5, startTime); // 기존.end   > 신규.start

			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] isOverlapped 실패 : " + e.getMessage());
			// 확인이 안 되면 "겹친다"고 보아 예약을 막는 편이 안전하다
			return true;
		}
	}

	/**
	 * 예약 등록.
	 *
	 * <p>
	 * 호출 전에 반드시 {@link #isOverlapped} 로 중복을 확인할 것.
	 * </p>
	 */
	public int insertReserve(Room_ReserveDTO dto) {

		String sql = "INSERT INTO room_reserve "
				+ "(reserve_no, room_code, employee_id, meeting_title, attendees, start_time, end_time, status, reg_date) "
				+ "VALUES (reserve_seq.NEXTVAL, ?, ?, ?, ?, "
				+ "        TO_DATE(?, '" + DT_FORMAT + "'), "
				+ "        TO_DATE(?, '" + DT_FORMAT + "'), ?, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getRoom_code());
			pstmt.setString(2, dto.getEmployee_id());
			pstmt.setString(3, dto.getMeeting_title());
			pstmt.setString(4, dto.getAttendees());
			pstmt.setString(5, dto.getStart_time());
			pstmt.setString(6, dto.getEnd_time());
			pstmt.setString(7, STATUS_RESERVED);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[RoomDAO] insertReserve 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 예약 1건 조회 */
	public Room_ReserveDTO selectReserveByNo(int reserveNo) {

		String sql = "SELECT " + RESERVE_COLUMNS + RESERVE_FROM + "WHERE rr.reserve_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, reserveNo);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return mapReserve(rs);
				}
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] selectReserveByNo 실패 : " + e.getMessage());
		}
		return null;
	}

	/**
	 * 특정 날짜의 예약 목록.
	 *
	 * @param date     "YYYY-MM-DD"
	 * @param roomCode 회의실 코드 (null 이면 전체 회의실)
	 */
	public List<Room_ReserveDTO> selectReserveByDate(String date, String roomCode) {

		List<Room_ReserveDTO> list = new ArrayList<>();

		StringBuilder sql = new StringBuilder("SELECT " + RESERVE_COLUMNS + RESERVE_FROM
				+ "WHERE TRUNC(rr.start_time) = TO_DATE(?, 'YYYY-MM-DD') "
				+ "  AND rr.status = ? ");

		boolean filterRoom = roomCode != null && !roomCode.trim().isEmpty();
		if (filterRoom) {
			sql.append(" AND rr.room_code = ? ");
		}
		sql.append("ORDER BY rr.room_code, rr.start_time");

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			pstmt.setString(1, date);
			pstmt.setString(2, STATUS_RESERVED);
			if (filterRoom) {
				pstmt.setString(3, roomCode.trim());
			}

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapReserve(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] selectReserveByDate 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 내 예약 목록 (최신순) */
	public List<Room_ReserveDTO> selectMyReserve(String employeeId) {

		List<Room_ReserveDTO> list = new ArrayList<>();

		String sql = "SELECT " + RESERVE_COLUMNS + RESERVE_FROM
				+ "WHERE rr.employee_id = ? ORDER BY rr.start_time DESC";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapReserve(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[RoomDAO] selectMyReserve 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 예약 취소 (예약한 본인만).
	 * 이력을 남기기 위해 DELETE 가 아니라 status 를 '取消' 로 바꾼다.
	 */
	public int cancelReserve(int reserveNo, String employeeId) {

		String sql = "UPDATE room_reserve SET status = ? "
				+ "WHERE reserve_no = ? AND employee_id = ? AND status = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, STATUS_CANCELED);
			pstmt.setInt(2, reserveNo);
			pstmt.setString(3, employeeId);
			pstmt.setString(4, STATUS_RESERVED);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[RoomDAO] cancelReserve 실패 : " + e.getMessage());
			return 0;
		}
	}
}
