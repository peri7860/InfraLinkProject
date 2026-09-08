package model;

/**
 * 자유게시판 게시글 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 board-list / board-view / board-write JSP 화면만 있고
 *   테이블·DTO·DAO·서비스가 전부 없었다. (board.js 도 alert 만 띄우는 더미)
 *   → board 테이블과 함께 새로 만들었다.
 * </pre>
 */
public class BoardDTO {

	private int board_no;
	private String employee_id;
	private String category; // 自由 / 質問 / 情報 / サークル
	private String title;
	private String content;
	private String file_path; // 저장된 파일명 (UUID_원본명)
	private String file_name; // 원본 파일명
	private int read_count;
	private String reg_date;
	private String upd_date;

	/** 작성자명 (employee 조인) */
	private String emp_name;

	/** 작성자 부서명 (department 조인) */
	private String dept_name;

	/** 댓글 수 (목록에서 "제목 (3)" 형태로 표시) */
	private int comment_count;

	// =================================================================
	// 화면 편의 메서드
	// =================================================================

	/** 첨부파일 보유 여부 */
	public boolean isHasFile() {
		return file_path != null && !file_path.trim().isEmpty();
	}

	/** 수정된 글인지 */
	public boolean isModified() {
		return upd_date != null && !upd_date.trim().isEmpty();
	}

	/** 다운로드 시 보여줄 파일명 */
	public String getDisplayFileName() {

		if (file_name != null && !file_name.trim().isEmpty()) {
			return file_name;
		}
		if (file_path == null) {
			return null;
		}
		int idx = file_path.indexOf('_');
		return idx >= 0 && idx < file_path.length() - 1
				? file_path.substring(idx + 1)
				: file_path;
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getBoard_no() {
		return board_no;
	}

	public void setBoard_no(int board_no) {
		this.board_no = board_no;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getFile_path() {
		return file_path;
	}

	public void setFile_path(String file_path) {
		this.file_path = file_path;
	}

	public String getFile_name() {
		return file_name;
	}

	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public int getRead_count() {
		return read_count;
	}

	public void setRead_count(int read_count) {
		this.read_count = read_count;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	public String getUpd_date() {
		return upd_date;
	}

	public void setUpd_date(String upd_date) {
		this.upd_date = upd_date;
	}

	public String getEmp_name() {
		return emp_name;
	}

	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}

	public String getDept_name() {
		return dept_name;
	}

	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}

	public int getComment_count() {
		return comment_count;
	}

	public void setComment_count(int comment_count) {
		this.comment_count = comment_count;
	}

	@Override
	public String toString() {
		return "BoardDTO[" + board_no + ", " + title + ", " + emp_name + "]";
	}
}
