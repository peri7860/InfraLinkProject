package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NotificationDAO;
import util.RequestUtil;

/**
 * 알림 목록.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   notifications.jsp 의 알림이 전부 하드코딩이었고,
 *   헤더의 배지도 "3" 으로 고정이었다.
 *   common.js 의 읽음 처리는 DOM 만 바꿔서 새로고침하면 되돌아왔다.
 *   → notification 테이블 기반으로 새로 구현했다.
 * </pre>
 */
public class NotificationListService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		NotificationDAO dao = new NotificationDAO();

		request.setAttribute("notificationList", dao.selectByEmployee(loginId));
		request.setAttribute("unreadCount", dao.countUnread(loginId));

		request.getRequestDispatcher("/WEB-INF/pages/notifications.jsp")
				.forward(request, response);
	}
}
