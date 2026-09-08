package model;

/**
 * 회의실 마스터 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   room-reserve.jsp 의 회의실 목록이 HTML 하드코딩이었다.
 *   → room 테이블에서 읽어 채우도록 바꾸면서 DTO 를 만들었다.
 * </pre>
 */
public class RoomDTO {

	private String room_code;
	private String room_name;
	private int capacity; // 수용 인원
	private String location; // 층 / 위치
	private String equipment; // 비치 장비
	private String use_yn;

	/** 조회한 날짜의 예약 건수 (예약 현황 화면용) */
	private int reserve_count;

	/** 사용 가능한 회의실인지 */
	public boolean isAvailable() {
		return !"N".equalsIgnoreCase(use_yn);
	}

	/** "5F / 8名" 형태의 표시 문자열 */
	public String getSummary() {
		StringBuilder sb = new StringBuilder();
		if (location != null && !location.isEmpty()) {
			sb.append(location);
		}
		if (capacity > 0) {
			if (sb.length() > 0) {
				sb.append(" / ");
			}
			sb.append(capacity).append("名");
		}
		return sb.toString();
	}

	// =================================================================
	// getter / setter
	// =================================================================

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

	public String getEquipment() {
		return equipment;
	}

	public void setEquipment(String equipment) {
		this.equipment = equipment;
	}

	public String getUse_yn() {
		return use_yn;
	}

	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}

	public int getReserve_count() {
		return reserve_count;
	}

	public void setReserve_count(int reserve_count) {
		this.reserve_count = reserve_count;
	}

	@Override
	public String toString() {
		return "RoomDTO[" + room_code + ", " + room_name + ", " + capacity + "名]";
	}
}
