package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 자유게시판 DAO (게시글 + 댓글).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 board-list / board-view / board-write JSP 만 있고
 *   테이블·DAO·서비스가 전부 없었다.
 *   board.js 는 alert("2단계에서 구현 예정") 만 띄우고
 *   submit 을 preventDefault() 로 막아 두어 저장 자체가 불가능했다.
 *   → board / board_comment 테이블과 함께 새로 구현했다.
 * </pre>
 */
public class BoardDAO {

	// =================================================================
	// 공통 SELECT 절
	//  - 댓글 수는 스칼라 서브쿼리로 한 번에 가져온다.
	//    (목록 N건마다 댓글 수를 따로 조회하면 N+1 쿼리가 된다)
	// =================================================================
	private static final String LIST_COLUMNS =
			"  b.board_no, b.employee_id, b.category, b.title, "
			+ "b.file_path, b.file_name, b.read_count, "
			+ "TO_CHAR(b.reg_date, 'YYYY-MM-DD') AS reg_date, "
			+ "TO_CHAR(b.upd_date, 'YYYY-MM-DD') AS upd_date, "
			+ "e.emp_name, d.dept_name, "
			+ "(SELECT COUNT(*) FROM board_comment c WHERE c.board_no = b.board_no) AS comment_count ";

	private static final String FROM_JOIN =
			"FROM board b "
			+ "  LEFT JOIN employee   e ON b.employee_id = e.employee_id "
			+ "  LEFT JOIN department d ON e.dept_code   = d.dept_code ";

	private BoardDTO mapListRow(ResultSet rs) throws SQLException {

		BoardDTO dto = new BoardDTO();

		dto.setBoard_no(rs.getInt("board_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setCategory(rs.getString("category"));
		dto.setTitle(rs.getString("title"));
		dto.setFile_path(rs.getString("file_path"));
		dto.setFile_name(rs.getString("file_name"));
		dto.setRead_count(rs.getInt("read_count"));
		dto.setReg_date(rs.getString("reg_date"));
		dto.setUpd_date(rs.getString("upd_date"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));
		dto.setComment_count(rs.getInt("comment_count"));

		return dto;
	}

	// =================================================================
	// 게시글
	// =================================================================

	/** 게시글 등록 */
	public int insertBoard(BoardDTO dto) {

		String sql = "INSERT INTO board "
				+ "(board_no, employee_id, category, title, content, file_path, file_name, read_count, reg_date) "
				+ "VALUES (board_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, 0, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getEmployee_id());
			pstmt.setString(2, dto.getCategory());
			pstmt.setString(3, dto.getTitle());
			pstmt.setString(4, dto.getContent());
			pstmt.setString(5, dto.getFile_path());
			pstmt.setString(6, dto.getFile_name());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] insertBoard 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 게시글 1건 조회.
	 *
	 * @return 없으면 null
	 */
	public BoardDTO selectBoardByNo(int boardNo) {

		String sql = "SELECT " + LIST_COLUMNS + ", b.content " + FROM_JOIN + "WHERE b.board_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, boardNo);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					BoardDTO dto = mapListRow(rs);
					dto.setContent(rs.getString("content"));
					return dto;
				}
			}

		} catch (SQLException e) {
			System.err.println("[BoardDAO] selectBoardByNo 실패 : " + e.getMessage());
		}
		return null;
	}

	/**
	 * 검색 + 페이징 목록.
	 *
	 * @param keyword  제목/내용 검색어 (null 이면 전체)
	 * @param category 분류 (null 이면 전체)
	 */
	public List<BoardDTO> selectBoardPage(String keyword, String category, int startRow, int endRow) {

		List<BoardDTO> list = new ArrayList<>();
		List<Object> params = new ArrayList<>();
		String where = buildWhere(keyword, category, params);

		String sql = "SELECT * FROM ( "
				+ "  SELECT ROWNUM rn, a.* FROM ( "
				+ "    SELECT " + LIST_COLUMNS + FROM_JOIN + where
				+ "    ORDER BY b.board_no DESC "
				+ "  ) a WHERE ROWNUM <= ? "
				+ ") WHERE rn >= ?";

		params.add(endRow);
		params.add(startRow);

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			bind(pstmt, params);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapListRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[BoardDAO] selectBoardPage 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 목록 전체 건수 */
	public int countBoard(String keyword, String category) {

		List<Object> params = new ArrayList<>();
		String where = buildWhere(keyword, category, params);

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
			System.err.println("[BoardDAO] countBoard 실패 : " + e.getMessage());
		}
		return 0;
	}

	/** 게시글 수정. 새 첨부가 없으면 기존 첨부를 유지한다. */
	public int updateBoard(BoardDTO dto) {

		boolean hasNewFile = dto.getFile_path() != null && !dto.getFile_path().trim().isEmpty();

		String sql = hasNewFile
				? "UPDATE board SET category = ?, title = ?, content = ?, "
						+ "file_path = ?, file_name = ?, upd_date = SYSDATE WHERE board_no = ?"
				: "UPDATE board SET category = ?, title = ?, content = ?, "
						+ "upd_date = SYSDATE WHERE board_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			int idx = 1;
			pstmt.setString(idx++, dto.getCategory());
			pstmt.setString(idx++, dto.getTitle());
			pstmt.setString(idx++, dto.getContent());

			if (hasNewFile) {
				pstmt.setString(idx++, dto.getFile_path());
				pstmt.setString(idx++, dto.getFile_name());
			}
			pstmt.setInt(idx, dto.getBoard_no());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] updateBoard 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 게시글 삭제.
	 * 댓글은 FK 의 ON DELETE CASCADE 로 함께 지워진다.
	 */
	public int deleteBoard(int boardNo) {

		String sql = "DELETE FROM board WHERE board_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, boardNo);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] deleteBoard 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 조회수 +1 */
	public int increaseReadCount(int boardNo) {

		String sql = "UPDATE board SET read_count = read_count + 1 WHERE board_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, boardNo);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] increaseReadCount 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 댓글
	// =================================================================

	/** 게시글의 댓글 목록 (등록순) */
	public List<CommentDTO> selectComments(int boardNo) {

		List<CommentDTO> list = new ArrayList<>();

		String sql = "SELECT c.comment_no, c.board_no, c.employee_id, c.content, "
				+ "       TO_CHAR(c.reg_date, 'YYYY-MM-DD HH24:MI') AS reg_date, "
				+ "       e.emp_name, e.position, d.dept_name "
				+ "FROM board_comment c "
				+ "  LEFT JOIN employee   e ON c.employee_id = e.employee_id "
				+ "  LEFT JOIN department d ON e.dept_code   = d.dept_code "
				+ "WHERE c.board_no = ? "
				+ "ORDER BY c.comment_no ASC";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, boardNo);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					CommentDTO dto = new CommentDTO();
					dto.setComment_no(rs.getInt("comment_no"));
					dto.setBoard_no(rs.getInt("board_no"));
					dto.setEmployee_id(rs.getString("employee_id"));
					dto.setContent(rs.getString("content"));
					dto.setReg_date(rs.getString("reg_date"));
					dto.setEmp_name(rs.getString("emp_name"));
					dto.setPosition(rs.getString("position"));
					dto.setDept_name(rs.getString("dept_name"));
					list.add(dto);
				}
			}

		} catch (SQLException e) {
			System.err.println("[BoardDAO] selectComments 실패 : " + e.getMessage());
		}
		return list;
	}

	/** 댓글 등록 */
	public int insertComment(CommentDTO dto) {

		String sql = "INSERT INTO board_comment (comment_no, board_no, employee_id, content, reg_date) "
				+ "VALUES (comment_seq.NEXTVAL, ?, ?, ?, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, dto.getBoard_no());
			pstmt.setString(2, dto.getEmployee_id());
			pstmt.setString(3, dto.getContent());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] insertComment 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 댓글 삭제.
	 *
	 * <p>
	 * 작성자 본인만 지울 수 있도록 WHERE 절에 employee_id 를 함께 넣는다.
	 * (URL 의 comment_no 만 바꿔서 남의 댓글을 지우는 것을 DB 레벨에서 차단)
	 * </p>
	 */
	public int deleteComment(int commentNo, String employeeId) {

		String sql = "DELETE FROM board_comment WHERE comment_no = ? AND employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, commentNo);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[BoardDAO] deleteComment 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 내부 헬퍼
	// =================================================================

	private String buildWhere(String keyword, String category, List<Object> params) {

		StringBuilder where = new StringBuilder(" WHERE 1 = 1 ");

		if (keyword != null && !keyword.trim().isEmpty()) {
			where.append(" AND ( b.title LIKE ? OR b.content LIKE ? ) ");
			String like = "%" + keyword.trim() + "%";
			params.add(like);
			params.add(like);
		}
		if (category != null && !category.trim().isEmpty()) {
			where.append(" AND b.category = ? ");
			params.add(category.trim());
		}
		return where.toString();
	}

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
