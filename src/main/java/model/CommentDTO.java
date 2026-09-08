package model;

/**
 * 게시판 댓글 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-view.jsp 에 댓글 UI 는 있었지만
 *   board.js 가 alert("2단계에서 구현 예정") 만 띄우는 상태였다.
 *   → board_comment 테이블과 함께 새로 만들었다.
 * </pre>
 */
public class CommentDTO {

	private int comment_no;
	private int board_no;
	private String employee_id;
	private String content;
	private String reg_date;

	/** 작성자명 (employee 조인) */
	private String emp_name;

	/** 작성자 부서명 */
	private String dept_name;

	/** 작성자 직위 */
	private String position;

	/**
	 * 로그인 사용자가 이 댓글의 작성자인지 판정한다.
	 * (삭제 버튼 노출 여부 결정용)
	 */
	public boolean isOwnedBy(String loginEmployeeId) {
		return employee_id != null && employee_id.equals(loginEmployeeId);
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getComment_no() {
		return comment_no;
	}

	public void setComment_no(int comment_no) {
		this.comment_no = comment_no;
	}

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

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
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

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	@Override
	public String toString() {
		return "CommentDTO[" + comment_no + ", board=" + board_no + ", " + emp_name + "]";
	}
}
