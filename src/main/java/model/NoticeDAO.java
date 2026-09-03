package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

public class NoticeDAO {

	//입력
	public void insertNotice(NoticeDTO dto) {
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		//구분,타이틀,작성자,등록일
		
		String sql = "insert into notice (notice_no,category,employee_id,visibility,title,content,file_path)"
				+ "values (notice_seq.nextval,?,?,?,?,?)";
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getCategory());
			pstmt.setString(2, dto.getEmployee_id());
			pstmt.setString(3, dto.getVisibility());
			pstmt.setString(4, dto.getTitle());
			pstmt.setString(5, dto.getContent());
			pstmt.setString(6, dto.getFile_path());
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(pstmt,conn);
		}
	}
	
	//조회수
	public  void readCount(int notice_no) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql="update notice set read_count = read_count + 1 where notice_no = ?";
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notice_no);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(pstmt,conn);
		}
	}
	
	//전체조회
	public List<NoticeDTO> selectAllNotice() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select notice_no, category, employee_id, title, reg_date, read_count, file_path from notice order by notice_no desc";
		
		List<NoticeDTO> list = new ArrayList<NoticeDTO>();
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				NoticeDTO dto = new NoticeDTO();
				dto.setNotice_no(rs.getInt("notice_no"));
				dto.setCategory(rs.getString("category"));
				dto.setEmployee_id(rs.getString("employee_id"));
				dto.setTitle(rs.getString("title"));
				dto.setReg_date(rs.getString("reg_date"));
				dto.setRead_count(rs.getInt("read_count"));
				dto.setFile_path(rs.getString("file_path"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return list;
	}
	
	//번호별 조회
	public NoticeDTO selectNoticeByNo(int notice_no) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "select notice_no, title, employee_id, reg_date, read_count, file_path from notice where notice_no = ?";
		NoticeDTO dto = new NoticeDTO();
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notice_no);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				dto.setNotice_no(rs.getInt("notice_no"));
				dto.setTitle(rs.getString("title"));
				dto.setEmployee_id(rs.getString("employee_id"));
				dto.setReg_date(rs.getString("reg_date"));
				dto.setRead_count(rs.getInt("read_count"));
				dto.setFile_path(rs.getString("file_path"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(rs, pstmt, conn);
		}
		return dto;
	}
	
	//업데이트
	public void updateNotice(NoticeDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = null;
		
		if(dto.getFile_path() == null || dto.getFile_path().isEmpty()) {
			sql = "update notice set employee_id=?, category=?, visibility=?, title=?, content=?, file_path=? where notice_no=?";
		}else {
			sql = "update notice set employee_id=?, category=?, visibility=?, title=?, content=? where notice_no=?";
		}
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			if(dto.getFile_path() == null || dto.getFile_path().isEmpty()) {
				pstmt.setString(1, dto.getEmployee_id());
				pstmt.setString(2, dto.getCategory());
				pstmt.setString(3, dto.getVisibility());
				pstmt.setString(4, dto.getTitle());
				pstmt.setString(5, dto.getContent());
				pstmt.setString(6, dto.getFile_path());
				pstmt.setInt(7, dto.getNotice_no());
			}else {
				pstmt.setString(1, dto.getEmployee_id());
				pstmt.setString(2, dto.getCategory());
				pstmt.setString(3, dto.getVisibility());
				pstmt.setString(4, dto.getTitle());
				pstmt.setString(5, dto.getContent());
				pstmt.setInt(6, dto.getNotice_no());
			}
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(pstmt,conn);
		}
	}
	
	//삭제
	public void deleteNotice(int notice_no) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "delete from notice where notice_no=?";
		
		try {
			conn = DBManager.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notice_no);
			pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBManager.close(pstmt, conn);
		}
	}
	
	
	public List<NoticeDTO> getSearchAndPaging(String keyword, int page, int pageSize) {

		//keyword 는 검색어
		//page 현재 페이지 번호
		//pageSize 한 페이지에 보여줄 글 수

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from (\r\n"

		+ " select rownum rn, aaa.* from\r\n"

		+ " (select * from notice where title like ? or content like ? order by notice_no desc) aaa \r\n"

		+ " where rownum <= ? )\r\n"

		+ "where rn > ?";

		List<NoticeDTO> list = new ArrayList<NoticeDTO>();

		int offset = (page-1) * pageSize;

		//페이지 offset 가져올 행
		//1 0 1-10
		//2 10 11-20
		//3 20 21-30

		try {

		conn = DBManager.getInstance();
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, '%'+keyword+'%');
		pstmt.setString(2, '%'+keyword+'%');
		pstmt.setInt(3, offset+pageSize);
		pstmt.setInt(4, offset);
		rs = pstmt.executeQuery();
		while(rs.next()) {

		NoticeDTO dto = new NoticeDTO();

		dto.setNotice_no(rs.getInt("notice_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setTitle(rs.getString("title"));
		dto.setContent(rs.getString("content"));
		dto.setFile_path(rs.getString("file_path"));
		dto.setReg_date(rs.getString("reg_date"));
		dto.setRead_count(rs.getInt("read_count"));
		list.add(dto);

		}

		}catch(Exception e) {
		e.printStackTrace();
		}finally {
		DBManager.close(rs, pstmt, conn);
		}
		return list;
		}
	
	public NoticeDTO preBno(int bno) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      
	      String sql= "select notice_no,title from notice "
	            + "where notice_no = (select max(notice_no) from notice where notice_no < ?)";
	      
	      NoticeDTO dto = null;
	      
	      try {
	         conn = DBManager.getInstance();
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, bno);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	            dto = new NoticeDTO();
	            dto.setNotice_no(rs.getInt("notice_no"));
	            dto.setTitle(rs.getString("title"));
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         DBManager.close(rs, pstmt, conn);
	      }
	      return dto;
	   }
	
	
	//다음글
	   public NoticeDTO nextBno(int bno) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      
	      String sql= "select notice_no,title from notice "
	            + "where notice_no = (select min(notice_no) from notice where notice_no > ?)";
	      
	      NoticeDTO dto = null;
	      
	      try {
	         conn = DBManager.getInstance();
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, bno);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	            dto = new NoticeDTO();
	            dto.setNotice_no(rs.getInt("notice_no"));
	            dto.setTitle(rs.getString("title"));
	         }
	      }catch(Exception e) {
	         e.printStackTrace();
	      }finally {
	         DBManager.close(rs, pstmt, conn);
	      }
	      return dto;
	   }
	
	
	
	
	
	
	
}
