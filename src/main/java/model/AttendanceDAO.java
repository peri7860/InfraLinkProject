package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 근태 DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   attendance.jsp 화면만 있고 테이블·DTO·DAO 가 전혀 없었다.
 *   → attendance 테이블과 함께 새로 구현했다.
 *
 * 처리 규칙
 *   - 출근(checkIn)  : 오늘 기록이 없으면 INSERT. 이미 있으면 아무것도 안 함.
 *   - 퇴근(checkOut) : 오늘 기록의 out_time 을 UPDATE.
 *   - 사원 1명당 하루 1건 (DB 의 UNIQUE 제약으로 보장)
 * </pre>
 */
public class AttendanceDAO {

	/** 오라클 UNIQUE 제약 위반 에러 코드 */
	private static final int ORA_UNIQUE_VIOLATED = 1;

	private static final String SELECT_COLUMNS =
			"  a.att_no, a.employee_id, a.work_type, a.note, "
			+ "TO_CHAR(a.work_date, 'YYYY-MM-DD') AS work_date, "
			+ "TO_CHAR(a.in_time,   'HH24:MI')    AS in_time, "
			+ "TO_CHAR(a.out_time,  'HH24:MI')    AS out_time, "
			// 근무 시간을 분 단위로 계산 (오라클 DATE 뺄셈 결과는 '일' 단위)
			+ "NVL(ROUND((a.out_time - a.in_time) * 24 * 60), 0) AS work_minutes, "
			+ "e.emp_name, d.dept_name ";

	private static final String FROM_JOIN =
			"FROM attendance a "
			+ "  LEFT JOIN employee   e ON a.employee_id = e.employee_id "
			+ "  LEFT JOIN department d ON e.dept_code   = d.dept_code ";

	private AttendanceDTO mapRow(ResultSet rs) throws SQLException {

		AttendanceDTO dto = new AttendanceDTO();

		dto.setAtt_no(rs.getInt("att_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setWork_date(rs.getString("work_date"));
		dto.setIn_time(rs.getString("in_time"));
		dto.setOut_time(rs.getString("out_time"));
		dto.setWork_type(rs.getString("work_type"));
		dto.setNote(rs.getString("note"));
		dto.setWork_minutes(rs.getInt("work_minutes"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));

		return dto;
	}

	// =================================================================
	// 출근 / 퇴근
	// =================================================================

	/**
	 * 출근 등록.
	 *
	 * @return 1 = 등록됨, 0 = 이미 출근했거나 실패
	 */
	public int checkIn(String employeeId, String workType) {

		String sql = "INSERT INTO attendance (att_no, employee_id, work_date, in_time, work_type) "
				+ "VALUES (attendance_seq.NEXTVAL, ?, TRUNC(SYSDATE), SYSDATE, ?)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			pstmt.setString(2, workType == null || workType.isEmpty() ? "出勤" : workType);

			return pstmt.executeUpdate();

		} catch (SQLException e) {

			if (e.getErrorCode() == ORA_UNIQUE_VIOLATED) {
				// 오늘 이미 출근 기록이 있다 (중복 클릭 등)
				System.out.println("[AttendanceDAO] 이미 출근 처리됨 : " + employeeId);
				return 0;
			}
			System.err.println("[AttendanceDAO] checkIn 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 퇴근 등록.
	 * 오늘 출근 기록이 있고 아직 퇴근하지 않은 경우에만 갱신된다.
	 *
	 * @return 1 = 처리됨, 0 = 출근 기록이 없거나 이미 퇴근함
	 */
	public int checkOut(String employeeId) {

		String sql = "UPDATE attendance SET out_time = SYSDATE "
				+ "WHERE employee_id = ? AND work_date = TRUNC(SYSDATE) AND out_time IS NULL";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[AttendanceDAO] checkOut 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 조회
	// =================================================================

	/** 오늘의 내 근태 기록 (없으면 null) */
	public AttendanceDTO selectToday(String employeeId) {

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "WHERE a.employee_id = ? AND a.work_date = TRUNC(SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return mapRow(rs);
				}
			}

		} catch (SQLException e) {
			System.err.println("[AttendanceDAO] selectToday 실패 : " + e.getMessage());
		}
		return null;
	}

	/**
	 * 특정 월의 내 근태 목록.
	 *
	 * @param yearMonth "2026-09" 형식
	 */
	public List<AttendanceDTO> selectByMonth(String employeeId, String yearMonth) {

		List<AttendanceDTO> list = new ArrayList<>();

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN
				+ "WHERE a.employee_id = ? "
				+ "  AND a.work_date >= TO_DATE(? || '-01', 'YYYY-MM-DD') "
				+ "  AND a.work_date <  ADD_MONTHS(TO_DATE(? || '-01', 'YYYY-MM-DD'), 1) "
				+ "ORDER BY a.work_date DESC";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			pstmt.setString(2, yearMonth);
			pstmt.setString(3, yearMonth);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[AttendanceDAO] selectByMonth 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 특정 월의 근무 통계 (근무일수 / 총 근무시간(분) / 지각 횟수).
	 *
	 * @return [0]=근무일수, [1]=총 근무 분, [2]=지각 횟수
	 */
	public int[] getMonthlySummary(String employeeId, String yearMonth) {

		String sql = "SELECT COUNT(*) AS work_days, "
				+ "       NVL(SUM(ROUND((out_time - in_time) * 24 * 60)), 0) AS total_minutes, "
				// 09:00 이후 출근을 지각으로 센다
				+ "       SUM(CASE WHEN TO_CHAR(in_time, 'HH24MI') > '0900' THEN 1 ELSE 0 END) AS late_count "
				+ "FROM attendance "
				+ "WHERE employee_id = ? "
				+ "  AND work_date >= TO_DATE(? || '-01', 'YYYY-MM-DD') "
				+ "  AND work_date <  ADD_MONTHS(TO_DATE(? || '-01', 'YYYY-MM-DD'), 1)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			pstmt.setString(2, yearMonth);
			pstmt.setString(3, yearMonth);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return new int[] {
							rs.getInt("work_days"),
							rs.getInt("total_minutes"),
							rs.getInt("late_count")
					};
				}
			}

		} catch (SQLException e) {
			System.err.println("[AttendanceDAO] getMonthlySummary 실패 : " + e.getMessage());
		}
		return new int[] { 0, 0, 0 };
	}

	/** 오늘 출근한 전체 사원 수 (관리자 대시보드) */
	public int countTodayCheckIn() {

		String sql = "SELECT COUNT(*) FROM attendance WHERE work_date = TRUNC(SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			System.err.println("[AttendanceDAO] countTodayCheckIn 실패 : " + e.getMessage());
		}
		return 0;
	}
}
