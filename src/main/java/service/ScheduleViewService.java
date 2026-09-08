package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDTO;
import model.ScheduleDAO;
import model.ScheduleDTO;
import util.RequestUtil;

/**
 * 일정 상세 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   schedule-view.jsp 가 하드코딩된 일정 하나를 보여주고 있었다.
 *
 * 공개 범위 확인
 *   DAO 의 selectByNo 가 WHERE 절에서 공개 범위를 검사하므로,
 *   볼 권한이 없으면 null 이 돌아온다.
 *   (PRIVATE 인 남의 일정은 조회 자체가 안 된다)
 * </pre>
 */
public class ScheduleViewService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);
		if (loginUser == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		int scheduleNo = RequestUtil.getIntParam(request, "no", 0);

		if (scheduleNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/schedule.do");
			return;
		}

		ScheduleDTO schedule = new ScheduleDAO()
				.selectByNo(scheduleNo, loginUser.getEmployee_id(), loginUser.getDept_code());

		if (schedule == null) {
			// 없는 일정이거나 볼 권한이 없는 일정
			request.setAttribute("errorMessage", "予定が見つからないか、閲覧権限がありません。");
			request.getRequestDispatcher("/WEB-INF/pages/schedule-view.jsp")
					.forward(request, response);
			return;
		}

		// 수정/삭제는 등록한 본인만
		boolean canEdit = loginUser.getEmployee_id().equals(schedule.getEmployee_id());

		request.setAttribute("schedule", schedule);
		request.setAttribute("canEdit", canEdit);

		request.getRequestDispatcher("/WEB-INF/pages/schedule-view.jsp")
				.forward(request, response);
	}
}
