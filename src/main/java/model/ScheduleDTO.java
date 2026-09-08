package model;

/**
 * 일정(스케줄) DTO.
 *
 * <pre>
 * [수정] 2026-09-07
 *   기존에는 DTO 만 있고 테이블·DAO·서비스가 없어서 일정 화면이 전부 더미였다.
 *   → schedule 테이블을 만들고 DAO 를 구현하면서 필드를 보강했다.
 *
 *   기존 필드 (유지)
 *     schedule_no / employee_id / title / schedule_date / location
 *   추가 필드
 *     + content     : 상세 내용
 *     + start_time  : 시작 일시 (YYYY-MM-DD HH24:MI)
 *     + end_time    : 종료 일시
 *     + visibility  : 공개 범위 PRIVATE / DEPT / ALL
 *     + emp_name    : 등록자명 (employee 조인)
 *     + dept_name   : 등록자 부서명
 *
 *   참고 : schedule_date 는 캘린더 표시용 "YYYY-MM-DD" 만 담는 필드로 유지하고,
 *          실제 시각은 start_time / end_time 을 쓴다.
 * </pre>
 */
public class ScheduleDTO {

	private int schedule_no;
	private String employee_id;
	private String title;
	private String schedule_date;
	private String location;

	/** [추가] 상세 내용 */
	private String content;

	/** [추가] 시작 일시 */
	private String start_time;

	/** [추가] 종료 일시 */
	private String end_time;

	/** [추가] 공개 범위 : PRIVATE / DEPT / ALL */
	private String visibility;

	/** [추가] 등록자명 */
	private String emp_name;

	/** [추가] 등록자 부서명 */
	private String dept_name;

	// =================================================================
	// 화면 편의 메서드
	// =================================================================

	/** "10:00 ~ 11:00" 형태의 시간대 문자열 */
	public String getTimeRange() {

		String s = extractTime(start_time);
		String e = extractTime(end_time);

		if (s == null) {
			return "";
		}
		return e == null ? s : s + " ~ " + e;
	}

	/** "YYYY-MM-DD HH:MI" 에서 시각 부분만 뽑는다 */
	private String extractTime(String datetime) {
		if (datetime == null || datetime.length() < 16) {
			return null;
		}
		return datetime.substring(11, 16);
	}

	/** 공개 범위 표시명 */
	public String getVisibilityLabel() {
		if ("ALL".equals(visibility)) {
			return "全社";
		}
		if ("DEPT".equals(visibility)) {
			return "部署";
		}
		return "個人";
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getSchedule_no() {
		return schedule_no;
	}

	public void setSchedule_no(int schedule_no) {
		this.schedule_no = schedule_no;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSchedule_date() {
		return schedule_date;
	}

	public void setSchedule_date(String schedule_date) {
		this.schedule_date = schedule_date;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
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
		return "ScheduleDTO[" + schedule_no + ", " + title + ", " + start_time + "]";
	}
}
