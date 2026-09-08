package model;

/**
 * 사원 정보 DTO.
 *
 * <pre>
 * [수정] 2026-09-07
 *   기존 필드는 그대로 두고 아래 항목만 추가했다.
 *     + pwd_reset_yn : 초기 비밀번호 상태 여부 (Y 면 최초 로그인 시 변경 유도)
 *     + reg_date     : 계정 생성일
 *   그리고 화면에서 자주 쓰는 편의 메서드를 추가했다.
 *     + isAdmin()      : 관리자 여부 (JSP 에서 ${loginUser.admin} 으로 사용)
 *     + isPwdReset()   : 초기 비밀번호 여부 (${loginUser.pwdReset})
 *     + getMaskedPhone() : 개인정보 마스킹
 *
 *   ※ password 는 toString() 에 절대 넣지 않는다.
 *      (로그에 해시가 찍히는 것을 막기 위함)
 * </pre>
 */
public class EmployeeDTO {

	private String employee_id;
	private String password;
	private String emp_name;
	private String dept_code;
	private String dept_name;
	private String position;
	private String email;
	private String ext_no;
	private String phone;
	private String hire_date;
	private String emp_status;

	/** 관리자와 일반 사원 구분 : "ADMIN" or "USER" */
	private String auth_role;

	/** [추가] 초기 비밀번호 상태 여부 : "Y" / "N" */
	private String pwd_reset_yn;

	/** [추가] 계정 생성일 */
	private String reg_date;

	// =================================================================
	// 편의 메서드 (JSP EL 에서 사용)
	// =================================================================

	/**
	 * 관리자 여부.
	 * JSP 에서 {@code <c:if test="${loginUser.admin}">} 로 사용한다.
	 */
	public boolean isAdmin() {
		return "ADMIN".equalsIgnoreCase(auth_role);
	}

	/**
	 * 초기 비밀번호(사번과 동일) 상태인지.
	 * JSP 에서 {@code ${loginUser.pwdReset}} 로 사용한다.
	 */
	public boolean isPwdReset() {
		return "Y".equalsIgnoreCase(pwd_reset_yn);
	}

	/** 재직 중인지 */
	public boolean isActive() {
		return emp_status == null || "在職".equals(emp_status);
	}

	/**
	 * 전화번호 마스킹 (예: 090-1111-0002 → 090-****-0002).
	 * 사원 목록처럼 여러 사람의 정보가 한 화면에 나올 때 사용한다.
	 */
	public String getMaskedPhone() {

		if (phone == null || phone.length() < 7) {
			return phone;
		}
		String[] parts = phone.split("-");
		if (parts.length == 3) {
			return parts[0] + "-****-" + parts[2];
		}
		// 하이픈이 없는 형식은 가운데를 가린다
		int head = 3;
		int tail = 4;
		if (phone.length() <= head + tail) {
			return phone;
		}
		return phone.substring(0, head)
				+ "****"
				+ phone.substring(phone.length() - tail);
	}

	/** "開発部 / 課長" 형태의 표시용 문자열 */
	public String getDeptPosition() {
		String d = dept_name != null ? dept_name : "";
		String p = position != null ? position : "";
		if (d.isEmpty()) {
			return p;
		}
		if (p.isEmpty()) {
			return d;
		}
		return d + " / " + p;
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmp_name() {
		return emp_name;
	}

	public void setEmp_name(String emp_name) {
		this.emp_name = emp_name;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getExt_no() {
		return ext_no;
	}

	public void setExt_no(String ext_no) {
		this.ext_no = ext_no;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getHire_date() {
		return hire_date;
	}

	public void setHire_date(String hire_date) {
		this.hire_date = hire_date;
	}

	public String getEmp_status() {
		return emp_status;
	}

	public void setEmp_status(String emp_status) {
		this.emp_status = emp_status;
	}

	public String getAuth_role() {
		return auth_role;
	}

	public void setAuth_role(String auth_role) {
		this.auth_role = auth_role;
	}

	public String getPwd_reset_yn() {
		return pwd_reset_yn;
	}

	public void setPwd_reset_yn(String pwd_reset_yn) {
		this.pwd_reset_yn = pwd_reset_yn;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	/** 비밀번호는 절대 출력하지 않는다 */
	@Override
	public String toString() {
		return "EmployeeDTO[" + employee_id + ", " + emp_name
				+ ", " + dept_name + ", " + position + ", " + auth_role + "]";
	}
}
