package model;

/**
 * 전자결재 문서 DTO.
 *
 * <pre>
 * [수정] 2026-09-07
 *   기존에는 이 DTO 만 있고 테이블·DAO·서비스가 전혀 없어서
 *   전자결재 화면 전체가 하드코딩 더미였다.
 *   → approval 테이블을 만들고(db/01_schema.sql) DAO 를 새로 구현하면서
 *     아래 필드를 추가했다.
 *
 *   기존 필드 (그대로 유지)
 *     approval_no / employee_id / approval_id / doc_type / doc_title
 *     / status / req_date
 *   추가 필드
 *     + content       : 기안 내용
 *     + proc_date     : 결재 처리일
 *     + proc_comment  : 결재 의견
 *     + emp_name      : 기안자명   (employee 조인)
 *     + dept_name     : 기안자 부서 (department 조인)
 *     + approver_name : 결재자명   (employee 조인)
 *
 *   용어 정리
 *     employee_id = 기안자(신청한 사람)
 *     approval_id = 결재자(승인/반려하는 사람)  ← 기존 필드명을 그대로 살림
 * </pre>
 */
public class ApprovalDTO {

	private int approval_no;
	private String employee_id;
	private String approval_id;
	private String doc_type;
	private String doc_title;
	private String status;
	private String req_date;

	/** [추가] 기안 내용 */
	private String content;

	/** [추가] 결재 처리일 */
	private String proc_date;

	/** [추가] 결재 의견 */
	private String proc_comment;

	/** [추가] 기안자명 */
	private String emp_name;

	/** [추가] 기안자 부서명 */
	private String dept_name;

	/** [추가] 결재자명 */
	private String approver_name;

	// =================================================================
	// 상태 판별 (JSP 에서 배지 색상 분기에 사용)
	// =================================================================

	/** 대기 상태인지 (결재 가능 여부 판단) */
	public boolean isWaiting() {
		return "待機".equals(status);
	}

	public boolean isApproved() {
		return "承認".equals(status);
	}

	public boolean isRejected() {
		return "却下".equals(status);
	}

	/**
	 * 상태별 부트스트랩 배지 클래스.
	 * JSP 에서 {@code <span class="status-pill ${doc.statusClass}">} 로 사용한다.
	 */
	public String getStatusClass() {
		if (isApproved()) {
			return "status-done";
		}
		if (isRejected()) {
			return "status-reject";
		}
		return "status-wait";
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getApproval_no() {
		return approval_no;
	}

	public void setApproval_no(int approval_no) {
		this.approval_no = approval_no;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getApproval_id() {
		return approval_id;
	}

	public void setApproval_id(String approval_id) {
		this.approval_id = approval_id;
	}

	public String getDoc_type() {
		return doc_type;
	}

	public void setDoc_type(String doc_type) {
		this.doc_type = doc_type;
	}

	public String getDoc_title() {
		return doc_title;
	}

	public void setDoc_title(String doc_title) {
		this.doc_title = doc_title;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getReq_date() {
		return req_date;
	}

	public void setReq_date(String req_date) {
		this.req_date = req_date;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getProc_date() {
		return proc_date;
	}

	public void setProc_date(String proc_date) {
		this.proc_date = proc_date;
	}

	public String getProc_comment() {
		return proc_comment;
	}

	public void setProc_comment(String proc_comment) {
		this.proc_comment = proc_comment;
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

	public String getApprover_name() {
		return approver_name;
	}

	public void setApprover_name(String approver_name) {
		this.approver_name = approver_name;
	}

	@Override
	public String toString() {
		return "ApprovalDTO[" + approval_no + ", " + doc_type + ", " + doc_title + ", " + status + "]";
	}
}
