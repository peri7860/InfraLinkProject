package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 부서 DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   사원 등록/수정 화면의 부서 &lt;select&gt; 옵션이 JSP 에 하드코딩되어 있었다.
 *   (부서가 늘어나면 화면 6곳을 전부 손봐야 하는 구조)
 *   → department 테이블에서 읽어 채우기 위해 새로 만들었다.
 * </pre>
 */
public class DepartmentDAO {

	/** 전체 부서 목록 (화면 정렬 순서대로) */
	public List<DepartmentDTO> getDepartmentList() {

		List<DepartmentDTO> list = new ArrayList<>();

		String sql = "SELECT dept_code, dept_name, sort_order "
				+ "FROM department ORDER BY sort_order, dept_code";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				DepartmentDTO dto = new DepartmentDTO();
				dto.setDept_code(rs.getString("dept_code"));
				dto.setDept_name(rs.getString("dept_name"));
				dto.setSort_order(rs.getInt("sort_order"));
				list.add(dto);
			}

		} catch (SQLException e) {
			System.err.println("[DepartmentDAO] getDepartmentList 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 부서별 재직 인원 수를 포함한 목록.
	 * 관리자 대시보드의 조직 현황 위젯에서 사용한다.
	 */
	public List<DepartmentDTO> getDepartmentListWithCount() {

		List<DepartmentDTO> list = new ArrayList<>();

		String sql = "SELECT d.dept_code, d.dept_name, d.sort_order, "
				+ "       COUNT(e.employee_id) AS emp_count "
				+ "FROM department d "
				// 재직자만 세기 위해 조인 조건에 상태를 넣는다.
				// (WHERE 에 넣으면 인원 0명인 부서가 목록에서 사라진다)
				+ "  LEFT JOIN employee e "
				+ "    ON d.dept_code = e.dept_code AND e.emp_status = '在職' "
				+ "GROUP BY d.dept_code, d.dept_name, d.sort_order "
				+ "ORDER BY d.sort_order, d.dept_code";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				DepartmentDTO dto = new DepartmentDTO();
				dto.setDept_code(rs.getString("dept_code"));
				dto.setDept_name(rs.getString("dept_name"));
				dto.setSort_order(rs.getInt("sort_order"));
				dto.setEmp_count(rs.getInt("emp_count"));
				list.add(dto);
			}

		} catch (SQLException e) {
			System.err.println("[DepartmentDAO] getDepartmentListWithCount 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 부서 코드로 1건 조회 */
	public DepartmentDTO getDepartmentByCode(String deptCode) {

		if (deptCode == null || deptCode.trim().isEmpty()) {
			return null;
		}

		String sql = "SELECT dept_code, dept_name, sort_order FROM department WHERE dept_code = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, deptCode.trim());

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					DepartmentDTO dto = new DepartmentDTO();
					dto.setDept_code(rs.getString("dept_code"));
					dto.setDept_name(rs.getString("dept_name"));
					dto.setSort_order(rs.getInt("sort_order"));
					return dto;
				}
			}

		} catch (SQLException e) {
			System.err.println("[DepartmentDAO] getDepartmentByCode 실패 : " + e.getMessage());
		}
		return null;
	}

	/** 부서 코드 존재 여부 (사원 등록 시 입력값 검증용) */
	public boolean exists(String deptCode) {
		return getDepartmentByCode(deptCode) != null;
	}
}
