package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Year;

import util.DBManager;

/**
 * 관리자 기능 DAO (사번 채번 / 사원 등록).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) getNextEmpSequencePreview() 가 user_sequences.last_number 를 읽었다.
 *     → last_number 는 "다음에 나올 값"이 아니라
 *       캐시로 미리 선점한 최대값이다.
 *       시퀀스에 CACHE 20 이 걸려 있으면 실제 발급될 번호와 최대 20 이나
 *       어긋나서, 화면에 보여준 사번과 실제 저장되는 사번이 달라졌다.
 *     → 기존 사번(employee 테이블)에서 직접 최대값을 구하는 방식으로 변경.
 *
 *  2) 사번을 "부서-연도-일련번호" 로 만들면서 일련번호는 전역 시퀀스를 썼다.
 *     → DEV-2026-001 다음에 SAL-2026-002 가 나오는 구조.
 *       %03d 포맷(부서·연도별 001부터)의 의도와 맞지 않았다.
 *     → 부서 + 연도 조합별로 번호를 매기도록 변경.
 *
 *  3) 미리보기와 실제 등록 사이에 다른 관리자가 등록하면 번호가 겹칠 수 있었다.
 *     → insertEmployee 를 "채번 + INSERT" 한 트랜잭션으로 묶고,
 *       PK 중복(ORA-00001)이 나면 다음 번호로 최대 20회까지 재시도한다.
 *
 *  4) try-with-resources 미사용 / 예외를 삼킴
 * </pre>
 */
public class AdminDAO {

	/** 사번 채번 재시도 횟수 (동시 등록 충돌 대비) */
	private static final int MAX_RETRY = 20;

	/** 오라클 UNIQUE 제약 위반 에러 코드 */
	private static final int ORA_UNIQUE_VIOLATED = 1;

	// =================================================================
	// 사번 채번
	// =================================================================

	/**
	 * 다음 사번을 미리 계산한다. (화면 미리보기용, DB 를 변경하지 않음)
	 *
	 * <p>
	 * 형식 : {부서코드}-{연도}-{3자리 일련번호}, 예) DEV-2026-003
	 * </p>
	 *
	 * @param deptCode 부서 코드
	 * @return 다음에 발급될 사번
	 */
	public String previewNextEmployeeId(String deptCode) {

		if (deptCode == null || deptCode.trim().isEmpty()) {
			return null;
		}

		String year = String.valueOf(Year.now().getValue());
		int nextSeq = getNextSequence(deptCode.trim(), year);

		return buildEmployeeId(deptCode.trim(), year, nextSeq);
	}

	/**
	 * 해당 부서/연도의 다음 일련번호를 구한다.
	 *
	 * <p>
	 * 기존 사번의 마지막 3자리 중 최대값 + 1.
	 * 사번이 하나도 없으면 1 부터 시작한다.
	 * </p>
	 */
	private int getNextSequence(String deptCode, String year) {

		// employee_id 는 'DEV-2026-003' 형식.
		// 마지막 '-' 뒤 3자리를 숫자로 변환해 최대값을 구한다.
		String sql = "SELECT NVL(MAX(TO_NUMBER(SUBSTR(employee_id, INSTR(employee_id, '-', -1) + 1))), 0) + 1 "
				+ "FROM employee "
				+ "WHERE employee_id LIKE ? "
				// 마지막 구간이 숫자로만 되어 있는 행만 대상으로 한다.
				// (형식이 다른 사번이 섞여 있어도 TO_NUMBER 에서 터지지 않도록)
				+ "  AND REGEXP_LIKE(employee_id, '^' || ? || '-' || ? || '-[0-9]+$')";

		String prefix = deptCode + "-" + year + "-";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, prefix + "%");
			pstmt.setString(2, deptCode);
			pstmt.setString(3, year);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

		} catch (SQLException e) {
			System.err.println("[AdminDAO] getNextSequence 실패 : " + e.getMessage());
		}
		return 1;
	}

	/** 사번 문자열 조립 */
	private String buildEmployeeId(String deptCode, String year, int seq) {
		return deptCode + "-" + year + "-" + String.format("%03d", seq);
	}

	// =================================================================
	// 사원 등록
	// =================================================================

	/**
	 * 신규 사원을 등록하고, 실제로 발급된 사번을 반환한다.
	 *
	 * <pre>
	 * [변경] 기존에는 서비스가 사번을 먼저 만들고 DAO 는 INSERT 만 했다.
	 *        그 사이에 다른 관리자가 등록하면 사번이 충돌했다.
	 *        → 채번과 INSERT 를 이 메서드 안에서 함께 처리하고,
	 *          PK 충돌 시 다음 번호로 재시도한다.
	 *
	 * 주의 : employee.getPassword() 에는 <b>BCrypt 해시</b>가 들어있어야 한다.
	 * </pre>
	 *
	 * @return 발급된 사번. 실패하면 null
	 */
	public String insertEmployee(EmployeeDTO employee) {

		if (employee == null || employee.getDept_code() == null) {
			return null;
		}

		String deptCode = employee.getDept_code().trim();
		String year = String.valueOf(Year.now().getValue());

		String sql = "INSERT INTO employee "
				+ "(employee_id, password, emp_name, dept_code, position, "
				+ " email, ext_no, phone, hire_date, emp_status, auth_role, pwd_reset_yn) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?, ?, 'Y')";

		int seq = getNextSequence(deptCode, year);

		for (int attempt = 0; attempt < MAX_RETRY; attempt++) {

			String employeeId = buildEmployeeId(deptCode, year, seq + attempt);

			try (Connection conn = DBManager.getConnection();
					PreparedStatement pstmt = conn.prepareStatement(sql)) {

				pstmt.setString(1, employeeId);
				pstmt.setString(2, employee.getPassword());
				pstmt.setString(3, employee.getEmp_name());
				pstmt.setString(4, deptCode);
				pstmt.setString(5, employee.getPosition());
				pstmt.setString(6, employee.getEmail());
				pstmt.setString(7, employee.getExt_no());
				pstmt.setString(8, employee.getPhone());
				pstmt.setString(9,
						employee.getEmp_status() == null ? "在職" : employee.getEmp_status());
				pstmt.setString(10,
						employee.getAuth_role() == null ? "USER" : employee.getAuth_role());

				if (pstmt.executeUpdate() > 0) {
					System.out.println("[AdminDAO] 사원 등록 완료 : " + employeeId);
					return employeeId;
				}

			} catch (SQLException e) {

				if (e.getErrorCode() == ORA_UNIQUE_VIOLATED) {
					// 같은 사번을 다른 요청이 먼저 가져갔다 → 다음 번호로 재시도
					System.out.println("[AdminDAO] 사번 충돌, 재시도 : " + employeeId);
					continue;
				}
				System.err.println("[AdminDAO] insertEmployee 실패 : " + e.getMessage());
				return null;
			}
		}

		System.err.println("[AdminDAO] 사번 채번에 " + MAX_RETRY + "회 실패했습니다.");
		return null;
	}

	// =================================================================
	// 하위 호환 (기존 메서드 유지)
	// =================================================================

	/**
	 * @deprecated 전역 시퀀스라 부서/연도별 번호가 되지 않는다.
	 *             {@link #previewNextEmployeeId(String)} 를 쓸 것.
	 */
	@Deprecated
	public int getNextEmpSequence() {

		String sql = "SELECT emp_id_seq.NEXTVAL FROM dual";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			System.err.println("[AdminDAO] getNextEmpSequence 실패 : " + e.getMessage());
		}
		return 0;
	}

	/**
	 * @deprecated user_sequences.last_number 는 실제 발급값과 어긋난다.
	 *             {@link #previewNextEmployeeId(String)} 를 쓸 것.
	 */
	@Deprecated
	public int getNextEmpSequencePreview() {

		String sql = "SELECT last_number FROM user_sequences WHERE sequence_name = 'EMP_ID_SEQ'";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			if (rs.next()) {
				return rs.getInt("last_number");
			}

		} catch (SQLException e) {
			System.err.println("[AdminDAO] getNextEmpSequencePreview 실패 : " + e.getMessage());
		}
		return 1;
	}
}
