package model;

/**
 * 공지사항 DTO.
 *
 * <pre>
 * [수정] 2026-09-07
 *   기존 필드는 유지하고 아래를 추가했다.
 *     + file_name : 사용자에게 보여줄 원본 파일명
 *                   (기존 file_path 에는 UUID 가 붙은 저장명만 있어서
 *                    다운로드하면 "a1b2c3..._資料.pdf" 로 받아졌다)
 *     + upd_date  : 수정일
 *     + emp_name / dept_name : 작성자 표시용 (employee 조인 결과)
 *   그리고 화면 편의 메서드(hasFile / isNew)를 추가했다.
 * </pre>
 */
public class NoticeDTO {

	private int notice_no;
	private String employee_id;
	private String category;
	private String title;
	private String content;
	private String file_path;
	private int read_count;
	private String pin_yn;
	private String reg_date;
	private String visibility;

	/** [추가] 원본 파일명 (다운로드 시 사용자에게 보여줄 이름) */
	private String file_name;

	/** [추가] 수정일 */
	private String upd_date;

	/** [추가] 작성자명 (employee 조인) */
	private String emp_name;

	/** [추가] 작성자 부서명 (department 조인) */
	private String dept_name;

	// =================================================================
	// 화면 편의 메서드
	// =================================================================

	/** 첨부파일이 있는지 (목록에서 클립 아이콘 표시용) */
	public boolean isHasFile() {
		return file_path != null && !file_path.trim().isEmpty();
	}

	/** 상단 고정글인지 */
	public boolean isPinned() {
		return "Y".equalsIgnoreCase(pin_yn);
	}

	/** 다운로드 시 보여줄 파일명. file_name 이 없으면 저장명에서 UUID 를 떼어 낸다. */
	public String getDisplayFileName() {

		if (file_name != null && !file_name.trim().isEmpty()) {
			return file_name;
		}
		if (file_path == null) {
			return null;
		}
		// "UUID_원본명" 형태이므로 첫 번째 '_' 뒤를 사용한다.
		int idx = file_path.indexOf('_');
		return idx >= 0 && idx < file_path.length() - 1
				? file_path.substring(idx + 1)
				: file_path;
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getNotice_no() {
		return notice_no;
	}

	public void setNotice_no(int notice_no) {
		this.notice_no = notice_no;
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

	public String getPin_yn() {
		return pin_yn;
	}

	public void setPin_yn(String pin_yn) {
		this.pin_yn = pin_yn;
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

	public String getVisibility() {
		return visibility;
	}

	public void setVisibility(String visibility) {
		this.visibility = visibility;
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

	@Override
	public String toString() {
		return "NoticeDTO[" + notice_no + ", " + title + ", " + emp_name + ", " + reg_date + "]";
	}
}
