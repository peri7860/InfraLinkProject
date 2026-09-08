package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 공지사항 DAO.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * ★ 가장 중요한 버그 : updateNotice() 의 if / else 가 서로 뒤바뀌어 있었다.
 *
 *   변경 전
 *     if (file_path 가 비어있음) → file_path = ? 가 <b>포함된</b> SQL (7개 바인딩)
 *     else (파일이 있음)        → file_path 가 <b>빠진</b>   SQL (6개 바인딩)
 *
 *   결과
 *     - 새 파일을 첨부하고 수정하면 → file_path 가 갱신되지 않음
 *     - 파일 없이 내용만 수정하면   → 기존 첨부파일 경로가 null 로 지워짐
 *   두 경우 모두 의도와 정반대로 동작했다. (조건을 서로 맞바꿔 수정)
 *
 * 그 외 변경
 *  1) selectNoticeByNo() 가 content 컬럼을 SELECT 하지 않았다.
 *     → 상세 화면에서 본문을 절대 볼 수 없는 상태였다. 추가.
 *  2) 작성자를 employee_id(사번)로만 들고 있어 화면에 사번이 그대로 노출됐다.
 *     → employee / department 를 LEFT JOIN 해 이름·부서를 함께 가져온다.
 *  3) 날짜를 rs.getString 으로 읽어 형식이 NLS 설정에 따라 달라졌다.
 *     → TO_CHAR 로 고정.
 *  4) getSearchAndPaging() 의 keyword 가 null 이면 "%null%" 로 검색됐고,
 *     전체 건수를 세는 메서드가 없어 페이지 번호를 만들 수 없었다.
 *     → 검색어 없으면 조건 자체를 빼고, countNotice() 를 추가.
 *  5) try-with-resources 적용 (커넥션 누수 방지)
 *  6) insert / update / delete 가 void 라 성공 여부를 알 수 없었다.
 *     → 처리 건수(int) 를 반환하도록 변경.
 * </pre>
 */
public class NoticeDAO {

	// =================================================================
	// 공통 SELECT 절 (목록용 : content 제외 — CLOB 을 목록에서 읽을 필요 없음)
	// =================================================================
	private static final String LIST_COLUMNS =
			"  n.notice_no, n.category, n.employee_id, n.visibility, n.title, "
			+ "n.file_path, n.file_name, n.read_count, n.pin_yn, "
			+ "TO_CHAR(n.reg_date, 'YYYY-MM-DD') AS reg_date, "
			+ "TO_CHAR(n.upd_date, 'YYYY-MM-DD') AS upd_date, "
			+ "e.emp_name, d.dept_name ";

	private static final String FROM_JOIN =
			"FROM notice n "
			+ "  LEFT JOIN employee   e ON n.employee_id = e.employee_id "
			+ "  LEFT JOIN department d ON e.dept_code   = d.dept_code ";

	/** 목록용 행 변환 (content 제외) */
	private NoticeDTO mapListRow(ResultSet rs) throws SQLException {

		NoticeDTO dto = new NoticeDTO();

		dto.setNotice_no(rs.getInt("notice_no"));
		dto.setCategory(rs.getString("category"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setVisibility(rs.getString("visibility"));
		dto.setTitle(rs.getString("title"));
		dto.setFile_path(rs.getString("file_path"));
		dto.setFile_name(rs.getString("file_name"));
		dto.setRead_count(rs.getInt("read_count"));
		dto.setPin_yn(rs.getString("pin_yn"));
		dto.setReg_date(rs.getString("reg_date"));
		dto.setUpd_date(rs.getString("upd_date"));
		dto.setEmp_name(rs.getString("emp_name"));
		dto.setDept_name(rs.getString("dept_name"));

		return dto;
	}

	// =================================================================
	// 등록
	// =================================================================

	/**
	 * 공지 등록.
	 *
	 * @return 처리 건수 (1 이면 성공)
	 */
	public int insertNotice(NoticeDTO dto) {

		String sql = "INSERT INTO notice "
				+ "(notice_no, category, employee_id, visibility, title, content, "
				+ " file_path, file_name, pin_yn, read_count, reg_date) "
				+ "VALUES (notice_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, 0, SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, dto.getCategory());
			pstmt.setString(2, dto.getEmployee_id());
			pstmt.setString(3, dto.getVisibility());
			pstmt.setString(4, dto.getTitle());
			pstmt.setString(5, dto.getContent());
			pstmt.setString(6, dto.getFile_path());
			pstmt.setString(7, dto.getFile_name());
			pstmt.setString(8, dto.getPin_yn() == null ? "N" : dto.getPin_yn());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] insertNotice 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 조회
	// =================================================================

	/**
	 * 공지 1건 상세 조회.
	 *
	 * <pre>
	 * [수정] 기존에는 content 를 SELECT 하지 않아 상세 화면에서
	 *        본문이 항상 비어 있었다. content 를 추가했다.
	 *        또 ResultSet 이 비어 있어도 빈 DTO 를 반환해서
	 *        "글이 없음"과 "글이 있는데 내용이 비었음"을 구분할 수 없었다.
	 *        → 없으면 null 을 반환하도록 변경.
	 * </pre>
	 *
	 * @return 없으면 null
	 */
	public NoticeDTO selectNoticeByNo(int notice_no) {

		String sql = "SELECT " + LIST_COLUMNS + ", n.content " + FROM_JOIN
				+ "WHERE n.notice_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, notice_no);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					NoticeDTO dto = mapListRow(rs);
					dto.setContent(rs.getString("content"));
					return dto;
				}
			}

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] selectNoticeByNo 실패 : " + e.getMessage());
		}
		return null;
	}

	/** 전체 공지 목록 (고정글 우선, 최신순) */
	public List<NoticeDTO> selectAllNotice() {

		List<NoticeDTO> list = new ArrayList<>();

		String sql = "SELECT " + LIST_COLUMNS + FROM_JOIN
				+ "ORDER BY n.pin_yn DESC, n.notice_no DESC";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				list.add(mapListRow(rs));
			}

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] selectAllNotice 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 메인 화면 위젯용 최신 공지 N건.
	 * [신규] index.jsp 의 공지 목록이 하드코딩이었던 것을 대체한다.
	 */
	public List<NoticeDTO> selectLatestNotice(int count) {

		List<NoticeDTO> list = new ArrayList<>();

		String sql = "SELECT * FROM ( "
				+ "  SELECT " + LIST_COLUMNS + FROM_JOIN
				+ "  ORDER BY n.pin_yn DESC, n.notice_no DESC "
				+ ") WHERE ROWNUM <= ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, count);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapListRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] selectLatestNotice 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 검색 + 페이징 목록.
	 *
	 * <pre>
	 * [수정] 기존 getSearchAndPaging() 의 문제
	 *   - keyword 가 null 이어도 무조건 LIKE '%null%' 로 검색됐다.
	 *   - 전체 건수를 세는 메서드가 없어 페이지 번호를 만들 수 없었다.
	 *   - 호출하는 곳이 한 군데도 없었다(죽은 코드).
	 * 새 메서드는 검색어가 없으면 조건 자체를 빼고,
	 * countNotice() 와 짝을 이뤄 동작한다.
	 * </pre>
	 *
	 * @param keyword  제목/내용 검색어 (null 이면 전체)
	 * @param category 분류 (null 이면 전체)
	 * @param startRow 시작 행 (1부터)
	 * @param endRow   끝 행
	 */
	public List<NoticeDTO> selectNoticePage(String keyword, String category, int startRow, int endRow) {

		List<NoticeDTO> list = new ArrayList<>();
		List<Object> params = new ArrayList<>();
		String where = buildWhere(keyword, category, params);

		String sql = "SELECT * FROM ( "
				+ "  SELECT ROWNUM rn, a.* FROM ( "
				+ "    SELECT " + LIST_COLUMNS + FROM_JOIN + where
				+ "    ORDER BY n.pin_yn DESC, n.notice_no DESC "
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
			System.err.println("[NoticeDAO] selectNoticePage 실패 : " + e.getMessage());
		}
		return list;
	}

	/** selectNoticePage 와 같은 조건의 전체 건수 */
	public int countNotice(String keyword, String category) {

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
			System.err.println("[NoticeDAO] countNotice 실패 : " + e.getMessage());
		}
		return 0;
	}

	/** 검색 조건 WHERE 절을 조립한다. (params 에 바인딩 값이 순서대로 담긴다) */
	private String buildWhere(String keyword, String category, List<Object> params) {

		StringBuilder where = new StringBuilder(" WHERE 1 = 1 ");

		if (keyword != null && !keyword.trim().isEmpty()) {
			// CLOB(content) 도 LIKE 검색이 가능하다.
			where.append(" AND ( n.title LIKE ? OR n.content LIKE ? ) ");
			String like = "%" + keyword.trim() + "%";
			params.add(like);
			params.add(like);
		}
		if (category != null && !category.trim().isEmpty()) {
			where.append(" AND n.category = ? ");
			params.add(category.trim());
		}
		return where.toString();
	}

	// =================================================================
	// 이전 글 / 다음 글
	// =================================================================

	/** 이전 글 (번호가 더 작은 글 중 가장 큰 것) */
	public NoticeDTO preBno(int bno) {
		return selectAdjacent(bno, true);
	}

	/** 다음 글 (번호가 더 큰 글 중 가장 작은 것) */
	public NoticeDTO nextBno(int bno) {
		return selectAdjacent(bno, false);
	}

	/** preBno / nextBno 공통 처리 */
	private NoticeDTO selectAdjacent(int bno, boolean previous) {

		String sql = previous
				? "SELECT notice_no, title FROM notice "
						+ "WHERE notice_no = (SELECT MAX(notice_no) FROM notice WHERE notice_no < ?)"
				: "SELECT notice_no, title FROM notice "
						+ "WHERE notice_no = (SELECT MIN(notice_no) FROM notice WHERE notice_no > ?)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, bno);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					NoticeDTO dto = new NoticeDTO();
					dto.setNotice_no(rs.getInt("notice_no"));
					dto.setTitle(rs.getString("title"));
					return dto;
				}
			}

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] selectAdjacent 실패 : " + e.getMessage());
		}
		return null;
	}

	// =================================================================
	// 수정 / 삭제 / 조회수
	// =================================================================

	/**
	 * 공지 수정.
	 *
	 * <pre>
	 * ★ [핵심 수정] 기존 코드는 if / else 의 SQL 이 서로 뒤바뀌어 있었다.
	 *
	 *   올바른 규칙
	 *     - 새 첨부파일이 있다  → file_path, file_name 도 함께 UPDATE
	 *     - 새 첨부파일이 없다  → 첨부 관련 컬럼은 건드리지 않는다(기존 파일 유지)
	 * </pre>
	 */
	public int updateNotice(NoticeDTO dto) {

		// 새 파일이 첨부되었는지 판단
		boolean hasNewFile = dto.getFile_path() != null && !dto.getFile_path().trim().isEmpty();

		String sql = hasNewFile
				// 파일 있음 → 첨부 컬럼 포함
				? "UPDATE notice SET category = ?, visibility = ?, title = ?, content = ?, "
						+ "pin_yn = ?, file_path = ?, file_name = ?, upd_date = SYSDATE "
						+ "WHERE notice_no = ?"
				// 파일 없음 → 첨부 컬럼 제외 (기존 첨부 유지)
				: "UPDATE notice SET category = ?, visibility = ?, title = ?, content = ?, "
						+ "pin_yn = ?, upd_date = SYSDATE "
						+ "WHERE notice_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			int idx = 1;
			pstmt.setString(idx++, dto.getCategory());
			pstmt.setString(idx++, dto.getVisibility());
			pstmt.setString(idx++, dto.getTitle());
			pstmt.setString(idx++, dto.getContent());
			pstmt.setString(idx++, dto.getPin_yn() == null ? "N" : dto.getPin_yn());

			if (hasNewFile) {
				pstmt.setString(idx++, dto.getFile_path());
				pstmt.setString(idx++, dto.getFile_name());
			}
			pstmt.setInt(idx, dto.getNotice_no());

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] updateNotice 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 공지 삭제 */
	public int deleteNotice(int notice_no) {

		String sql = "DELETE FROM notice WHERE notice_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, notice_no);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] deleteNotice 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 조회수 +1 */
	public int readCount(int notice_no) {

		String sql = "UPDATE notice SET read_count = read_count + 1 WHERE notice_no = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, notice_no);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NoticeDAO] readCount 실패 : " + e.getMessage());
			return 0;
		}
	}

	// =================================================================
	// 하위 호환
	// =================================================================

	/**
	 * @deprecated 검색어가 null 이면 "%null%" 로 검색되고,
	 *             전체 건수를 알 수 없어 페이지 번호를 만들 수 없다.
	 *             {@link #selectNoticePage(String, String, int, int)} 를 쓸 것.
	 */
	@Deprecated
	public List<NoticeDTO> getSearchAndPaging(String keyword, int page, int pageSize) {

		int startRow = (page - 1) * pageSize + 1;
		int endRow = page * pageSize;

		return selectNoticePage(keyword, null, startRow, endRow);
	}

	// =================================================================
	// 내부 헬퍼
	// =================================================================

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
