package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBManager;

public class EmployeeDAO {

	// ----------------
	// 일반 사원용 기능
	// ----------------

	// 아이디로 사원 정보 전체 조회
	public EmployeeDTO getEmployeeById(String employee_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from employee where employee_id = ?";

		EmployeeDTO employee = null;

		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, employee_id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				employee = new EmployeeDTO();
				employee.setEmployee_id(rs.getString("employee_id"));
				employee.setPassword(rs.getString("password"));
				employee.setEmp_name(rs.getString("emp_name"));
				employee.setDept_name(rs.getString("dept_name"));
				employee.setPosition(rs.getString("position"));
				employee.setEmail(rs.getString("email"));
				employee.setExt_no(rs.getString("ext_no"));
				employee.setHire_date(rs.getString("hire_date"));
				employee.setEmp_status(rs.getString("emp_status"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(rs, pstmt, conn);
		}
		return employee;
	}

//	// 마이페이지 정보 조회
//	public EmployeeDTO getEmployeeInfo(String employee_id) {
//		
//	}
//	
//	// 마이페이지 개인정보 수정
//	public int updateMyInfo(EmployeeDTO employee) {
//		
//	}
//	
//	// 사원 검색
//	public <List>EmployeeDTO searchEmployee() {
//		
//	}

}
