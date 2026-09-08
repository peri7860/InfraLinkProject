package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBManager;

/**
 * 알림 DAO.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   기존 문제
 *     - 헤더의 알림 개수가 HTML 에 "3" 으로 하드코딩되어 있었다.
 *     - common.js 의 읽음 처리는 DOM 만 바꿔서, 새로고침하면
 *       다시 미읽음 상태로 되돌아왔다.
 *   → notification 테이블을 만들고 DB 로 관리하도록 새로 구현했다.
 * </pre>
 */
public class NotificationDAO {

	private static final String SELECT_COLUMNS =
			"  noti_no, employee_id, noti_type, title, url, read_yn, "
			+ "TO_CHAR(reg_date, 'YYYY-MM-DD HH24:MI') AS reg_date ";

	private NotificationDTO mapRow(ResultSet rs) throws SQLException {

		NotificationDTO dto = new NotificationDTO();

		dto.setNoti_no(rs.getInt("noti_no"));
		dto.setEmployee_id(rs.getString("employee_id"));
		dto.setNoti_type(rs.getString("noti_type"));
		dto.setTitle(rs.getString("title"));
		dto.setUrl(rs.getString("url"));
		dto.setRead_yn(rs.getString("read_yn"));
		dto.setReg_date(rs.getString("reg_date"));

		return dto;
	}

	// =================================================================
	// 조회
	// =================================================================

	/** 내 알림 목록 (최신순) */
	public List<NotificationDTO> selectByEmployee(String employeeId) {

		List<NotificationDTO> list = new ArrayList<>();

		String sql = "SELECT " + SELECT_COLUMNS
				+ "FROM notification WHERE employee_id = ? ORDER BY noti_no DESC";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					list.add(mapRow(rs));
				}
			}

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] selectByEmployee 실패 : " + e.getMessage());
		}
		return list;
	}

	/**
	 * 미읽음 알림 개수.
	 * 헤더의 종 아이콘 배지에 표시한다.
	 */
	public int countUnread(String employeeId) {

		if (employeeId == null) {
			return 0;
		}

		String sql = "SELECT COUNT(*) FROM notification WHERE employee_id = ? AND read_yn = 'N'";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			}

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] countUnread 실패 : " + e.getMessage());
		}
		return 0;
	}

	// =================================================================
	// 등록 / 읽음 처리
	// =================================================================

	/**
	 * 알림 등록.
	 * 공지 등록, 결재 상신 등 다른 기능에서 호출한다.
	 */
	public int insert(String employeeId, String notiType, String title, String url) {

		String sql = "INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn, reg_date) "
				+ "VALUES (notification_seq.NEXTVAL, ?, ?, ?, ?, 'N', SYSDATE)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			pstmt.setString(2, notiType);
			pstmt.setString(3, title);
			pstmt.setString(4, url);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] insert 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 전 사원에게 알림 발송 (공지 등록 시 사용).
	 * <p>
	 * INSERT ... SELECT 로 한 번에 처리한다. (사원 수만큼 INSERT 하지 않는다)
	 * </p>
	 *
	 * @param excludeEmployeeId 본인에게는 보내지 않기 위해 제외할 사번 (null 이면 전체)
	 */
	public int insertToAll(String notiType, String title, String url, String excludeEmployeeId) {

		String sql = "INSERT INTO notification (noti_no, employee_id, noti_type, title, url, read_yn, reg_date) "
				+ "SELECT notification_seq.NEXTVAL, employee_id, ?, ?, ?, 'N', SYSDATE "
				+ "FROM employee "
				+ "WHERE emp_status = '在職' "
				+ "  AND (? IS NULL OR employee_id <> ?)";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, notiType);
			pstmt.setString(2, title);
			pstmt.setString(3, url);
			pstmt.setString(4, excludeEmployeeId);
			pstmt.setString(5, excludeEmployeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] insertToAll 실패 : " + e.getMessage());
			return 0;
		}
	}

	/**
	 * 알림 1건 읽음 처리.
	 * 본인의 알림만 처리되도록 employee_id 를 조건에 넣는다.
	 */
	public int markAsRead(int notiNo, String employeeId) {

		String sql = "UPDATE notification SET read_yn = 'Y' WHERE noti_no = ? AND employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, notiNo);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] markAsRead 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 내 알림 전체 읽음 처리 */
	public int markAllAsRead(String employeeId) {

		String sql = "UPDATE notification SET read_yn = 'Y' WHERE employee_id = ? AND read_yn = 'N'";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, employeeId);
			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] markAllAsRead 실패 : " + e.getMessage());
			return 0;
		}
	}

	/** 알림 삭제 (본인 것만) */
	public int delete(int notiNo, String employeeId) {

		String sql = "DELETE FROM notification WHERE noti_no = ? AND employee_id = ?";

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, notiNo);
			pstmt.setString(2, employeeId);

			return pstmt.executeUpdate();

		} catch (SQLException e) {
			System.err.println("[NotificationDAO] delete 실패 : " + e.getMessage());
			return 0;
		}
	}
}
