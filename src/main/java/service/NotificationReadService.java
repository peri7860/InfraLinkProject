package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NotificationDAO;
import model.NotificationDTO;
import util.RequestUtil;

/**
 * 알림 읽음 처리 / 삭제.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   읽음 처리가 화면(DOM)에서만 이뤄져 새로고침하면 되돌아왔다.
 *   → DB 에 반영한다.
 *
 * mode
 *   read    : 알림 1건 읽음 처리 후, 알림에 연결된 화면으로 이동
 *   readAll : 내 알림 전체 읽음 처리
 *   delete  : 알림 1건 삭제
 *
 * 권한
 *   DAO 의 모든 쿼리 WHERE 절에 employee_id 가 들어 있어
 *   남의 알림은 건드릴 수 없다.
 * </pre>
 */
public class NotificationReadService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String mode = RequestUtil.getParam(request, "mode", "read");
		int notiNo = RequestUtil.getIntParam(request, "no", 0);

		NotificationDAO dao = new NotificationDAO();

		switch (mode) {

		case "readAll":
			int count = dao.markAllAsRead(loginId);
			System.out.println("[NotificationReadService] 전체 읽음 : " + count + "건");
			break;

		case "delete":
			if (notiNo > 0) {
				dao.delete(notiNo, loginId);
			}
			break;

		default: // read
			if (notiNo > 0) {

				// 이동할 주소를 먼저 읽어둔다 (읽음 처리 후에는 필요 없음)
				String target = findUrl(dao, loginId, notiNo);

				dao.markAsRead(notiNo, loginId);

				// 알림에 연결된 화면이 있으면 그쪽으로 보낸다
				if (target != null && target.startsWith("/")) {
					RequestUtil.redirect(request, response, target);
					return;
				}
			}
			break;
		}

		RequestUtil.redirect(request, response, "/pages/notifications.do");
	}

	/**
	 * 알림 번호로 이동 대상 URL 을 찾는다.
	 * <p>
	 * 목록에서 찾는 이유는 "본인 알림만" 이라는 조건을 그대로 쓰기 위해서다.
	 * 알림 건수가 많지 않아 성능 문제는 없다.
	 * </p>
	 */
	private String findUrl(NotificationDAO dao, String loginId, int notiNo) {

		for (NotificationDTO noti : dao.selectByEmployee(loginId)) {
			if (noti.getNoti_no() == notiNo) {
				return noti.getUrl();
			}
		}
		return null;
	}
}
