package model;

/**
 * 회의실 예약 DTO.
 *
 * <pre>
 * [수정] 2026-09-07
 *   기존에는 DTO 만 있고 테이블·DAO·서비스가 없어서 예약 화면이 더미였다.
 *   → room / room_reserve 테이블을 만들고 DAO 를 구현하면서 보강했다.
 *
 *   기존 필드 (유지)
 *     reserve_no / room_name / employee_id / meeting_title
 *     / start_time / end_time
 *   추가 필드
 *     + room_code : 회의실 코드 (실제 FK. room_name 은 조인 결과 표시용)
 *     + attendees : 참석자 메모
 *     + status    : 予約 / 取消
 *     + reg_date  : 예약 등록일
 *     + emp_name / dept_name : 예약자 표시용
 *     + capacity / location  : 회의실 정보 표시용
 * </pre>
 */
public class Room_ReserveDTO {

	private int reserve_no;
	private String room_name;
	private String employee_id;
	private String meeting_title;
	private String start_time;
	private String end_time;

	/** [추가] 회의실 코드 (FK) */
	private String room_code;

	/** [추가] 참석자 메모 */
	private String attendees;

	/** [추가] 상태 : 予約 / 取消 */
	private String status;

	/** [추가] 예약 등록일 */
	private String reg_date;

	/** [추가] 예약자명 */
	private String emp_name;

	/** [추가] 예약자 부서명 */
	private String dept_name;

	/** [추가] 회의실 수용 인원 (조인 표시용) */
	private int capacity;

	/** [추가] 회의실 위치 (조인 표시용) */
	private String location;

	// =================================================================
	// 화면 편의 메서드
	// =================================================================

	/** 취소된 예약인지 */
	public boolean isCanceled() {
		return "取消".equals(status);
	}

	/** "10:00 ~ 11:00" 형태 */
	public String getTimeRange() {

		String s = extractTime(start_time);
		String e = extractTime(end_time);

		if (s == null) {
			return "";
		}
		return e == null ? s : s + " ~ " + e;
	}

	/** 예약 날짜 부분만 ("YYYY-MM-DD") */
	public String getReserveDate() {
		if (start_time == null || start_time.length() < 10) {
			return start_time;
		}
		return start_time.substring(0, 10);
	}

	private String extractTime(String datetime) {
		if (datetime == null || datetime.length() < 16) {
			return null;
		}
		return datetime.substring(11, 16);
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getReserve_no() {
		return reserve_no;
	}

	public void setReserve_no(int reserve_no) {
		this.reserve_no = reserve_no;
	}

	public String getRoom_code() {
		return room_code;
	}

	public void setRoom_code(String room_code) {
		this.room_code = room_code;
	}

	public String getRoom_name() {
		return room_name;
	}

	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getMeeting_title() {
		return meeting_title;
	}

	public void setMeeting_title(String meeting_title) {
		this.meeting_title = meeting_title;
	}

	public String getAttendees() {
		return attendees;
	}

	public void setAttendees(String attendees) {
		this.attendees = attendees;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public int getCapacity() {
		return capacity;
	}

	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	@Override
	public String toString() {
		return "Room_ReserveDTO[" + reserve_no + ", " + room_name
				+ ", " + start_time + "~" + end_time + ", " + status + "]";
	}
}
