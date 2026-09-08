package model;

/**
 * 근태 기록 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   attendance.jsp 화면만 있고 테이블/DTO/DAO 가 전혀 없었다.
 *   → attendance 테이블과 함께 새로 만들었다.
 *
 *   규칙 : 사원 1명당 하루 1건 (employee_id + work_date UNIQUE)
 *          출근 시 INSERT, 퇴근 시 UPDATE 한다.
 * </pre>
 */
public class AttendanceDTO {

	private int att_no;
	private String employee_id;
	private String work_date; // YYYY-MM-DD
	private String in_time; // HH:MI (출근)
	private String out_time; // HH:MI (퇴근)
	private String work_type; // 出勤 / 在宅 / 出張 / 休暇
	private String note;

	/** 근무 시간(분). DAO 에서 계산해 채운다. */
	private int work_minutes;

	/** 사원명 (관리자 화면용 조인 결과) */
	private String emp_name;

	/** 부서명 */
	private String dept_name;

	// =================================================================
	// 화면 편의 메서드
	// =================================================================

	/** 출근 기록이 있는지 */
	public boolean isCheckedIn() {
		return in_time != null && !in_time.trim().isEmpty();
	}

	/** 퇴근 기록이 있는지 */
	public boolean isCheckedOut() {
		return out_time != null && !out_time.trim().isEmpty();
	}

	/** "8時間 30分" 형태의 근무시간 문자열 */
	public String getWorkTimeText() {

		if (work_minutes <= 0) {
			return "-";
		}
		int hours = work_minutes / 60;
		int minutes = work_minutes % 60;

		return hours + "時間 " + minutes + "分";
	}

	/**
	 * 지각 여부 (09:00 기준).
	 * 회사 규정이 바뀌면 이 상수만 고치면 된다.
	 */
	public boolean isLate() {

		if (!isCheckedIn() || in_time.length() < 5) {
			return false;
		}
		return in_time.compareTo("09:00") > 0;
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getAtt_no() {
		return att_no;
	}

	public void setAtt_no(int att_no) {
		this.att_no = att_no;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getWork_date() {
		return work_date;
	}

	public void setWork_date(String work_date) {
		this.work_date = work_date;
	}

	public String getIn_time() {
		return in_time;
	}

	public void setIn_time(String in_time) {
		this.in_time = in_time;
	}

	public String getOut_time() {
		return out_time;
	}

	public void setOut_time(String out_time) {
		this.out_time = out_time;
	}

	public String getWork_type() {
		return work_type;
	}

	public void setWork_type(String work_type) {
		this.work_type = work_type;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public int getWork_minutes() {
		return work_minutes;
	}

	public void setWork_minutes(int work_minutes) {
		this.work_minutes = work_minutes;
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
		return "AttendanceDTO[" + work_date + ", " + employee_id
				+ ", in=" + in_time + ", out=" + out_time + "]";
	}
}
