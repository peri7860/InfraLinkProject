package model;

/**
 * 알림 DTO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   notifications.jsp 와 헤더의 알림 뱃지가 하드코딩("3")이었고,
 *   common.js 는 DOM 만 조작해 화면에서만 읽음 처리하고 있었다.
 *   (새로고침하면 다시 미읽음으로 돌아옴)
 *   → notification 테이블과 함께 새로 만들어 DB 로 관리한다.
 * </pre>
 */
public class NotificationDTO {

	private int noti_no;
	private String employee_id; // 수신자
	private String noti_type; // NOTICE / BOARD / APPROVAL / ROOM / SYSTEM
	private String title;
	private String url; // 클릭 시 이동할 경로 (컨텍스트 경로 제외)
	private String read_yn;
	private String reg_date;

	/** 미읽음 여부 */
	public boolean isUnread() {
		return !"Y".equalsIgnoreCase(read_yn);
	}

	/**
	 * 종류별 부트스트랩 아이콘 클래스.
	 * JSP 에서 {@code <i class="bi ${noti.iconClass}"></i>} 로 사용한다.
	 */
	public String getIconClass() {

		if (noti_type == null) {
			return "bi-bell";
		}
		switch (noti_type) {
		case "NOTICE":
			return "bi-megaphone";
		case "BOARD":
			return "bi-clipboard2-data";
		case "APPROVAL":
			return "bi-file-earmark-check";
		case "ROOM":
			return "bi-door-open";
		default:
			return "bi-bell";
		}
	}

	/** 종류 표시명 */
	public String getTypeLabel() {

		if (noti_type == null) {
			return "システム";
		}
		switch (noti_type) {
		case "NOTICE":
			return "お知らせ";
		case "BOARD":
			return "掲示板";
		case "APPROVAL":
			return "電子決裁";
		case "ROOM":
			return "会議室";
		default:
			return "システム";
		}
	}

	// =================================================================
	// getter / setter
	// =================================================================

	public int getNoti_no() {
		return noti_no;
	}

	public void setNoti_no(int noti_no) {
		this.noti_no = noti_no;
	}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getNoti_type() {
		return noti_type;
	}

	public void setNoti_type(String noti_type) {
		this.noti_type = noti_type;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getRead_yn() {
		return read_yn;
	}

	public void setRead_yn(String read_yn) {
		this.read_yn = read_yn;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}

	@Override
	public String toString() {
		return "NotificationDTO[" + noti_no + ", " + noti_type + ", " + title + ", read=" + read_yn + "]";
	}
}
