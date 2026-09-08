package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 사원 정보 DAO.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) getEmployeeById 가 department 를 INNER JOIN 하고 있었다.
 *     → 부서가 없는(dept_code 가 null) 사원은 조회 자체가 안 되어
 *       로그인이 실패했다. LEFT JOIN 으로 변경.
 *  2) 날짜를 rs.getString("hire_date") 로 읽었다.
 *     → 오라클 DATE 를 문자열로 읽으면 세션 NLS 설정에 따라
 *       "26/09/07" 같은 형식이 나온다. TO_CHAR 로 형식을 고정.
 *  3) try-with-resources 미사용 + close() 가 하나의 try 로 묶여 있어
 *     rs.close() 가 실패하면 커넥션이 반납되지 않았다(누수).
 *  4) 예외를 e.printStackTrace() 로 삼켜서 호출부가 성공/실패를 구분 못 했다.
 *     → 조회는 빈 결과, 갱신은 0 을 반환하되 로그에 원인을 남긴다.
 *  5) 관리자용 수정/삭제(퇴사처리)/검색/페이징 메서드가 아예 없었다.
 *     → admin-employee-edit 화면이 "수정"인데 실제로는 신규 INSERT 를
 *       호출하고 있었던 원인. 아래에 새로 추가했다.
 * </pre>
 */
public class EmployeeDAO {

	// =================================================================
	// 공통 SELECT 절
	//  - 날짜 형식을 TO_CHAR 로 고정한다.
	//  - department 는 LEFT JOIN (부서 미지정 사원도 조회되어야 함)
	// =================================================================
	private static final String SELECT_COLUMNS =
			"  e.employee_id, e.password, e.emp_name, e.dept_code, d.dept_name, "
			+ "e.position, e.email, e.ext_no, e.phone, "
			+ "TO_CHAR(e.hire_date, 'YYYY-MM-DD') AS hire_date, "
			+ "TO_CHAR(e.reg_date,  'YYYY-MM-DD') AS reg_date, "
			+ "e.emp_status, e.auth_role, e.pwd_reset_yn ";

	private static final String FROM_JOIN =
			"FROM employee e LEFT JOIN department d ON e.dept_code = d.dept_code ";

	/** ResultSet 한 행을 DTO 로 변환한다. (중복 코드 제거) */
	private EmployeeDTO mapRow(ResultSet rs) throws SQLException {

		EmployeeDTO employee = new EmployeeDTO();

		employee.setEmployee_id(rs.getString("employee_id"));
		employee.setEmp_name(rs.getString("emp_name"));
		employee.setDept_code(rs.getString("dept_code"));
		employee.setDept_name(rs.getString("dept_name"));
		employee.setPosition(rs.getString("position"));
		employee.setEmail(rs.getString("email"));
		employee.setExt_no(rs.getString("ext_no"));
		employee.setPhone(rs.getString("phone"));
		employee.setHire_date(rs.getString("hire_date"));
		employee.setReg_date(rs.getString("reg_date"));
		employee.setEmp_status(rs.getString("emp_status"));
		employee.setAuth_role(rs.getString("auth_role"));
		employee.setPwd_reset_yn(rs.getString("pwd_reset_yn"));

		return employee;
	}

	// =================================================================
	// 조회
	// =================================================================

	/**
	 * 사번으로 사원 1명을 조회한다. (로그인 검증에도 사용)
	 *
	 * <p>
	 * <b>주의</b> : 비밀번호 해시가 포함된다. 화면으로 그대로 넘기지 말 것.
	 * </p>
	 *
	 * @return 없으면 null
	 */
	public EmployeeDTO getEmployeeById(String employee_id) {

		if (employee_id == null || employee_id.trim().isEmpty()) {
			return null; // 파라미터가 없는데 굳이 DB 를 다녀올 필요가 없다
		}

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN + "WHERE e.employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employee_id.trim());

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					EmployeeDTO employee = mapRow(rs);
					// 비밀번호는 로그인 검증에만 필요하므로 여기서만 채운다.
					employee.setPassword(rs.getString("password"));
					return employee;
				}
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] getEmployeeById 실패 : " + e.getMessage());
		}
		return null;
	}

	/** 사번 존재 여부 (사원등록 시 중복 확인용) */
	public boolean existsById(String employee_id) {

		if (employee_id == null || employee_id.trim().isEmpty()) {
			return false;
		}

		String sql = "SELECT COUNT(*) FROM employee WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employee_id.trim());

			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] existsById 실패 : " + e.getMessage());
			// 확인이 안 되면 "있다"고 보는 편이 안전하다(중복 INSERT 방지)
			return true;
		}
	}

	/**
	 * 전체 사원 목록. (기존 메서드 유지)
	 * 페이징이 필요한 화면은 {@link #searchEmployees} 를 사용할 것.
	 */
	public List<EmployeeDTO> getEmployeeList() {

		List<EmployeeDTO> list = new ArrayList<>();

		String sql = "SELECT " + SELECT_COLUMNS + FROM_JOIN + "ORDER BY e.employee_id";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				list.add(mapRow(rs));
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] getEmployeeList 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 검색 + 페이징 사원 목록.
	 *
	 * <pre>
	 * [신규] 사원 목록/사원 검색 화면이 하드코딩이었던 것을 DB 연동으로 바꾸며 추가.
	 *
	 * 오라클 페이징 : rownum 을 매긴 인라인 뷰를 한 번 더 감싸서 구간을 자른다.
	 *   SELECT * FROM ( SELECT ROWNUM rn, a.* FROM (정렬된 결과) a WHERE ROWNUM &lt;= endRow )
	 *   WHERE rn &gt;= startRow
	 * </pre>
	 *
	 * @param keyword  이름/사번/이메일 부분 일치 (null 이면 조건 제외)
	 * @param deptCode 부서 코드 (null/빈값이면 전체)
	 * @param status   재직 상태 (null/빈값이면 전체)
	 * @param startRow 시작 행 (1부터)
	 * @param endRow   끝 행
	 */
	public List<EmployeeDTO> searchEmployees(String keyword, String deptCode, String status,
			int startRow, int endRow) {

		List<EmployeeDTO> list = new ArrayList<>();

		StringBuilder where = new StringBuilder(" WHERE 1 = 1 ");
		List<Object> params = new ArrayList<>();

		// ---------------------------------------------------------
		// 검색 조건을 동적으로 조립한다.
		// 값은 전부 ? 바인딩 → SQL 인젝션 방지
		// ---------------------------------------------------------
		if (keyword != null && !keyword.trim().isEmpty()) {
			where.append(" AND ( UPPER(e.emp_name)    LIKE UPPER(?) ")
					.append("   OR UPPER(e.employee_id) LIKE UPPER(?) ")
					.append("   OR UPPER(e.email)       LIKE UPPER(?) ) ");
			String like = "%" + keyword.trim() + "%";
			params.add(like);
			params.add(like);
			params.add(like);
		}
		if (deptCode != null && !deptCode.trim().isEmpty()) {
			where.append(" AND e.dept_code = ? ");
			params.add(deptCode.trim());
		}
		if (status != null && !status.trim().isEmpty()) {
			where.append(" AND e.emp_status = ? ");
			params.add(status.trim());
		}

		String sql = "SELECT * FROM ( "
				+ "  SELECT ROWNUM rn, a.* FROM ( "
				+ "    SELECT " + SELECT_COLUMNS + FROM_JOIN + where
				+ "    ORDER BY e.dept_code, e.employee_id "
				+ "  ) a WHERE ROWNUM <= ? "
				+ ") WHERE rn >= ?";

		params.add(endRow);
		params.add(startRow);

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			bind(pstmt, params);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] searchEmployees 실패 : " + e.getMessage());
		}
		return list;
	}

	/** searchEmployees 와 같은 조건의 전체 건수 (페이징 계산용) */
	public int countEmployees(String keyword, String deptCode, String status) {

		StringBuilder where = new StringBuilder(" WHERE 1 = 1 ");
		List<Object> params = new ArrayList<>();

		if (keyword != null && !keyword.trim().isEmpty()) {
			where.append(" AND ( UPPER(e.emp_name)    LIKE UPPER(?) ")
					.append("   OR UPPER(e.employee_id) LIKE UPPER(?) ")
					.append("   OR UPPER(e.email)       LIKE UPPER(?) ) ");
			String like = "%" + keyword.trim() + "%";
			params.add(like);
			params.add(like);
			params.add(like);
		}
		if (deptCode != null && !deptCode.trim().isEmpty()) {
			where.append(" AND e.dept_code = ? ");
			params.add(deptCode.trim());
		}
		if (status != null && !status.trim().isEmpty()) {
			where.append(" AND e.emp_status = ? ");
			params.add(status.trim());
		}

		String sql = "SELECT COUNT(*) " + FROM_JOIN + where;

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			bind(pstmt, params);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] countEmployees 실패 : " + e.getMessage());
		}
		return 0;
	}

	/** 상태별 사원 수 (관리자 대시보드 통계) */
	public int countByStatus(String status) {

		String sql = (status == null || status.trim().isEmpty())
				? "SELECT COUNT(*) FROM employee"
				: "SELECT COUNT(*) FROM employee WHERE emp_status = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			if (status != null && !status.trim().isEmpty()) {
				pstmt.setString(1, status.trim());
			}

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] countByStatus 실패 : " + e.getMessage());
		}
		return 0;
	}

	// =================================================================
	// 갱신
	// =================================================================

	/** 마이페이지 개인정보 수정 (본인이 바꿀 수 있는 항목만) */
	public int updateMyInfo(EmployeeDTO employee) {

		String sql = "UPDATE employee SET email = ?, ext_no = ?, phone = ? WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employee.getEmail());
			pstmt.setString(2, employee.getExt_no());
			pstmt.setString(3, employee.getPhone());
			pstmt.setString(4, employee.getEmployee_id());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] updateMyInfo 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 비밀번호 변경.
	 * <p>
	 * 비밀번호를 바꾸면 "초기 비밀번호 상태"도 함께 해제한다(pwd_reset_yn = 'N').
	 * </p>
	 *
	 * @param newPassword <b>반드시 BCrypt 해시</b>. 평문을 넘기지 말 것.
	 */
	public int updatePassword(String employeeId, String newPassword) {

		String sql = "UPDATE employee SET password = ?, pwd_reset_yn = 'N' WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, newPassword);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] updatePassword 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 관리자용 사원 정보 수정.
	 *
	 * <pre>
	 * [신규] 이 메서드가 없어서 admin-employee-edit.jsp 의 "수정" 버튼이
	 *        employeeRegister.do (신규 INSERT) 로 연결되어 있었다.
	 *        → 수정할 때마다 새 사번으로 사원이 하나씩 늘어나는 상태였다.
	 *
	 * 사번(employee_id)과 비밀번호는 여기서 바꾸지 않는다.
	 *  - 사번은 PK 이자 로그인 ID 이므로 변경 대상이 아니다.
	 *  - 비밀번호는 updatePassword / resetPassword 로만 변경한다.
	 * </pre>
	 */
	public int updateEmployee(EmployeeDTO employee) {

		String sql = "UPDATE employee "
				+ "SET emp_name = ?, dept_code = ?, position = ?, "
				+ "    email = ?, ext_no = ?, phone = ?, "
				+ "    emp_status = ?, auth_role = ? "
				+ "WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employee.getEmp_name());
			pstmt.setString(2, employee.getDept_code());
			pstmt.setString(3, employee.getPosition());
			pstmt.setString(4, employee.getEmail());
			pstmt.setString(5, employee.getExt_no());
			pstmt.setString(6, employee.getPhone());
			pstmt.setString(7, employee.getEmp_status());
			pstmt.setString(8, employee.getAuth_role());
			pstmt.setString(9, employee.getEmployee_id());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] updateEmployee 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 퇴사 처리 (논리 삭제).
	 *
	 * <pre>
	 * [신규] 물리 삭제(DELETE)를 하지 않는 이유
	 *   공지/게시글/결재 문서가 employee_id 를 FK 로 참조하고 있어
	 *   실제로 지우면 과거 문서의 작성자 정보가 통째로 깨진다.
	 *   → emp_status 를 '退職' 으로 바꾸는 논리 삭제로 처리한다.
	 * </pre>
	 */
	public int retireEmployee(String employeeId) {

		String sql = "UPDATE employee SET emp_status = '退職' WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] retireEmployee 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 관리자에 의한 비밀번호 초기화.
	 * 비밀번호를 사번과 동일하게 되돌리고 pwd_reset_yn 을 'Y' 로 표시한다.
	 *
	 * @param hashedInitialPassword 사번을 BCrypt 로 해시한 값
	 */
	public int resetPassword(String employeeId, String hashedInitialPassword) {

		String sql = "UPDATE employee SET password = ?, pwd_reset_yn = 'Y' WHERE employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, hashedInitialPassword);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[EmployeeDAO] resetPassword 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 내부 헬퍼
	// =================================================================

	/** 동적 조건 파라미터를 순서대로 바인딩한다. */
	private void bind(PreparedStatement pstmt, List<Object> params) throws SQLException {

		for (int i = 0; i < params.size(); i++) {
			Object value = params.get(i);
			if (value instanceof Integer) {
				pstmt.setInt(i + 1, (Integer) value);
			} else {
				pstmt.setString(i + 1, String.valueOf(value));
			}
		}
	}
}
