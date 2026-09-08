package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 일정(스케줄) DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 ScheduleDTO 만 있고 테이블·DAO·서비스가 없어서
 *   schedule / schedule-view / schedule-write 화면이 전부 더미였다.
 *   (schedule-write.jsp 의 등록 버튼은 type="button" 이라 아무 동작도 안 했다)
 *   → schedule 테이블과 함께 새로 구현했다.
 *
 * 공개 범위 규칙
 *   PRIVATE : 본인만
 *   DEPT    : 같은 부서 사원
 *   ALL     : 전 사원
 *   → 조회 SQL 에서 이 규칙을 그대로 WHERE 절로 표현한다.
 * </pre>
 */
public class ScheduleDAO {

	/** 날짜 포맷 (화면 입력값 "2026-09-08 10:00" 을 DATE 로 변환) */
	private static final String DT_FORMAT = "YYYY-MM-DD HH24:MI";

	private static final String SELECT_COLUMNS =
			"  s.schedule_no, s.employee_id, s.title, s.content, s.location, s.visibility, "
			+ "TO_CHAR(s.start_time, 'YYYY-MM-DD HH24:MI') AS start_time, "
			+ "TO_CHAR(s.end_time,   'YYYY-MM-DD HH24:MI') AS end_time, "
			+ "TO_CHAR(s.start_time, 'YYYY-MM-DD')         AS schedule_date, "
			+ "e.emp_name, d.dept_name ";

	private static final String FROM_JOIN =
			"FROM schedule s "
			+ "  LEFT JOIN employee   e ON s.employee_id = e.employee_id "
			+ "  LEFT JOIN department d ON e.dept_code   = d.dept_code ";

	/**
	 * 로그인 사용자가 볼 수 있는 일정인지 판정하는 WHERE 조건.
	 * <p>
	 * 바인딩 순서 : (1) 본인 사번, (2) 부서코드
	 * </p>
	 */
	private static final String VISIBILITY_CONDITION =
			" AND ( s.visibility = 'ALL' "
			+ "   OR s.employee_id = ? "
			+ "   OR ( s.visibility = 'DEPT' AND e.dept_code = ? ) ) ";

	private ScheduleDTO mapRow(ResultSet rs) throws SQLException {

		ScheduleDTO dto = new ScheduleDTO();

		dto.setSchedule_no(rs.getInt("schedule_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setTitle(rs.getString("title"));
		dto.setContent(rs.getString("content"));
		dto.setLocation(rs.getString("location"));
		dto.setVisibility(rs.getString("visibility"));
		dto.setStart_time(rs.getString("start_time"));
		dto.setEnd_time(rs.getString("end_time"));
		dto.setSchedule_date(rs.getString("schedule_date"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));

		return dto;
	}

	// =================================================================
	// 등록 / 수정 / 삭제
	// =================================================================

	/**
	 * 일정 등록.
	 *
	 * @param dto start_time / end_time 은 "YYYY-MM-DD HH:MI" 형식 문자열
	 */
	public int insertSchedule(ScheduleDTO dto) {

		String sql = "INSERT INTO schedule "
				+ "(schedule_no, employee_id, title, content, start_time, end_time, location, visibility, reg_date) "
				+ "VALUES (schedule_seq.NEXTVAL, ?, ?, ?, "
				+ "        TO_DATE(?, '" + DT_FORMAT + "'), "
				+ "        TO_DATE(?, '" + DT_FORMAT + "'), ?, ?, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getEmployee_id());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getStart_time());
			// 종료 시각을 비워두면 시작 시각과 같게 저장한다.
			pstmt.setString(5, dto.getEnd_time() == null || dto.getEnd_time().isEmpty()
					? dto.getStart_time()
					: dto.getEnd_time());
			pstmt.setString(6, dto.getLocation());
			pstmt.setString(7, dto.getVisibility() == null ? "PRIVATE" : dto.getVisibility());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] insertSchedule 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 일정 수정 (등록한 본인만).
	 * WHERE 에 employee_id 를 넣어 남의 일정을 고치지 못하게 한다.
	 */
	public int updateSchedule(ScheduleDTO dto) {

		String sql = "UPDATE schedule SET title = ?, content = ?, "
				+ "  start_time = TO_DATE(?, '" + DT_FORMAT + "'), "
				+ "  end_time   = TO_DATE(?, '" + DT_FORMAT + "'), "
				+ "  location = ?, visibility = ? "
				+ "WHERE schedule_no = ? AND employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setString(3, dto.getStart_time());
			pstmt.setString(4, dto.getEnd_time() == null || dto.getEnd_time().isEmpty()
					? dto.getStart_time()
					: dto.getEnd_time());
			pstmt.setString(5, dto.getLocation());
			pstmt.setString(6, dto.getVisibility());
			pstmt.setInt(7, dto.getSchedule_no());
			pstmt.setString(8, dto.getEmployee_id());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] updateSchedule 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 일정 삭제 (등록한 본인만) */
	public int deleteSchedule(int scheduleNo, String employeeId) {

		String sql = "DELETE FROM schedule WHERE schedule_no = ? AND employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, scheduleNo);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] deleteSchedule 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 조회
	// =================================================================

	/** 일정 1건 (공개 범위 확인 포함) */
	public ScheduleDTO selectByNo(int scheduleNo, String loginId, String deptCode) {

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "WHERE s.schedule_no = ? " + VISIBILITY_CONDITION;

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, scheduleNo);
			pstmt.setString(2, loginId);
			pstmt.setString(3, deptCode);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] selectByNo 실패 : " + e.getMessage());
		}
		return null;
	}

	/**
	 * 특정 월의 일정 목록 (캘린더 화면용).
	 *
	 * @param yearMonth "2026-09" 형식
	 */
	public List<ScheduleDTO> selectByMonth(String yearMonth, String loginId, String deptCode) {

		List<ScheduleDTO> list = new ArrayList<>();

		// 해당 월 1일 00:00 ~ 다음 달 1일 00:00 미만
		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "WHERE s.start_time >= TO_DATE(? || '-01', 'YYYY-MM-DD') "
				+ "  AND s.start_time <  ADD_MONTHS(TO_DATE(? || '-01', 'YYYY-MM-DD'), 1) "
				+ VISIBILITY_CONDITION
				+ "ORDER BY s.start_time";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, yearMonth);
			pstmt.setString(2, yearMonth);
			pstmt.setString(3, loginId);
			pstmt.setString(4, deptCode);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] selectByMonth 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 오늘 이후의 다가오는 일정 N건 (메인/사이드바 위젯용).
	 */
	public List<ScheduleDTO> selectUpcoming(String loginId, String deptCode, int count) {

		List<ScheduleDTO> list = new ArrayList<>();

		String sql = "SELECT * FROM ( "
				+ "  SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "  WHERE s.start_time >= TRUNC(SYSDATE) " + VISIBILITY_CONDITION
				+ "  ORDER BY s.start_time "
				+ ") WHERE ROWNUM <= ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, loginId);
			pstmt.setString(2, deptCode);
			pstmt.setInt(3, count);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] selectUpcoming 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 특정 날짜의 일정 (일간 보기) */
	public List<ScheduleDTO> selectByDate(String date, String loginId, String deptCode) {

		List<ScheduleDTO> list = new ArrayList<>();

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "WHERE TRUNC(s.start_time) = TO_DATE(?, 'YYYY-MM-DD') "
				+ VISIBILITY_CONDITION
				+ "ORDER BY s.start_time";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, date);
			pstmt.setString(2, loginId);
			pstmt.setString(3, deptCode);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[ScheduleDAO] selectByDate 실패 : " + e.getMessage());
		}
		return list;
	}
}
