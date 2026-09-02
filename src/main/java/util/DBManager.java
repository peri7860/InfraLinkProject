package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBManager {

	public static Connection getInstance() {
		Connection conn = null;
		
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String id = "infralink";
		String pw = "infra1234";
		
		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(url,id,pw);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(conn != null)conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return conn;
	}
	
	
	
	public static void close(Connection conn, PreparedStatement pstmt) {
		
		try {
			if(conn != null)conn.close();
			if(pstmt != null)pstmt.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		
		try {
			if(conn != null)conn.close();
			if(pstmt != null)pstmt.close();
			if(rs != null)rs.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
}
