package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBManager;

public class AdminDAO {
	
	// ----------------
	// 관리자용 기능
	// ----------------
	
	// 사번 끝자리 가져오기
	public int getNextEmpSequence() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int seq = 0;
		
		String sql = "select emp_id_seq.nextval from dual";
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				seq = rs.getInt(1);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(rs, pstmt, conn);
		}
		
		return seq;
		
	}
	
	// 신규 사원 등록
	public int insertEmployee(EmployeeDTO employee) {
		Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;
        
        String sql = "INSERT INTO employee (employee_id, password, emp_name, dept_code, position, email, auth_role) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try {
            conn = DBManager.getInstance();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employee.getEmployee_id());
            pstmt.setString(2, employee.getPassword());
            pstmt.setString(3, employee.getEmp_name());
            pstmt.setString(4, employee.getDept_code());
            pstmt.setString(5, employee.getPosition());
            pstmt.setString(6, employee.getEmail());
            pstmt.setString(7, employee.getAuth_role());
            
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager.close(pstmt, conn);
        }
        
        return result;
	}

}
