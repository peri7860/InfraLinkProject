package model;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class NoticeDAO {

	public void insertNotice(NoticeDTO dto) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		//구분,타이틀,작성자,등록일
		
		String sql = "insert into nptice (notice_no,title,employee_id,reg_date)"
				+ "values (notice_seq.nextval,?,?,sysdate)";
	}
}
