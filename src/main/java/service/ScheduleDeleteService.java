package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.RequestUtil;

/**
 * 일정 삭제.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   일정 삭제 기능이 없었다.
 *
 * 권한
 *   ScheduleDAO.deleteSchedule 의 WHERE 절에 employee_id 가 들어 있어
 *   등록한 본인의 일정만 삭제된다. 남의 일정 번호를 넣어도 0건이 된다.
 * </pre>
 */
public class ScheduleDeleteService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		int scheduleNo = RequestUtil.getIntParam(request, "no", 0);
		if (scheduleNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/schedule.do");
			return;
		}

		int result = new model.ScheduleDAO().deleteSchedule(scheduleNo, loginId);

		if (result > 0) {
			System.out.println("[ScheduleDeleteService] 일정 삭제 : " + scheduleNo);
			RequestUtil.redirect(request, response, "/pages/schedule.do?result=deleted");
		} else {
			// 없는 일정이거나 본인 것이 아님
			RequestUtil.redirect(request, response, "/pages/schedule.do?result=no_permission");
		}
	}
}
