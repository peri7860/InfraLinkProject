package model;

/**
 * 부서 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존에는 사원등록 화면(admin-employee-edit.jsp)의 부서 &lt;select&gt; 가
 *   HTML 에 하드코딩되어 있었다.
 *   → department 테이블에서 읽어 채우도록 바꾸면서 DTO 를 만들었다.
 * </pre>
 */
public class DepartmentDTO {

	private String dept_code;
	private String dept_name;
	private int sort_order;

	/** 해당 부서의 재직 인원 수 (관리자 대시보드 통계용) */
	private int emp_count;

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

	public int getSort_order() {
		return sort_order;
	}

	public void setSort_order(int sort_order) {
		this.sort_order = sort_order;
	}

	public int getEmp_count() {
		return emp_count;
	}

	public void setEmp_count(int emp_count) {
		this.emp_count = emp_count;
	}

	@Override
	public String toString() {
		return "DepartmentDTO[" + dept_code + ", " + dept_name + "]";
	}
}
