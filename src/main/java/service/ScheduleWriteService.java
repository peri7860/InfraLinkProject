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
 * 일정 등록 / 수정.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   schedule-write.jsp 는 폼만 있고 저장 로직이 전혀 없었다.
 *   등록 버튼조차 type="button" 이라 아무 동작도 하지 않았다.
 *
 * 동작
 *   GET  → 작성 폼 (?no= 가 있으면 기존 일정을 불러와 수정 모드)
 *   POST → 등록 또는 수정
 *
 * 입력 형식
 *   화면의 date + time 입력을 합쳐 "YYYY-MM-DD HH:MI" 로 만들어 DAO 에 넘긴다.
 *   DAO 가 TO_DATE 로 변환한다.
 * </pre>
 */
public class ScheduleWriteService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/schedule-write.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);
		if (loginUser == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		ScheduleDAO dao = new ScheduleDAO();
		int scheduleNo = RequestUtil.getIntParam(request, "no", 0);

		// -------------------------------------------------------------
		// GET : 폼 표시
		// -------------------------------------------------------------
		if (!"POST".equalsIgnoreCase(request.getMethod())) {

			if (scheduleNo > 0) {
				ScheduleDTO schedule = dao.selectByNo(
						scheduleNo, loginUser.getEmployee_id(), loginUser.getDept_code());

				// 남의 일정은 수정할 수 없다 (등록자 본인만)
				if (schedule == null
						|| !loginUser.getEmployee_id().equals(schedule.getEmployee_id())) {
					RequestUtil.redirect(request, response,
							"/pages/schedule.do?result=no_permission");
					return;
				}
				request.setAttribute("schedule", schedule);
				request.setAttribute("editMode", true);
			} else {
				request.setAttribute("editMode", false);
			}

			request.getRequestDispatcher(FORM_PAGE).forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// POST : 저장
		// -------------------------------------------------------------
		String title = RequestUtil.getParam(request, "title");
		String content = RequestUtil.getParam(request, "content");
		String location = RequestUtil.getParam(request, "location");
		String visibility = RequestUtil.getParam(request, "visibility", "PRIVATE");

		// 날짜 + 시각을 합친다
		String startTime = joinDateTime(
				RequestUtil.getParam(request, "start_date"),
				RequestUtil.getParam(request, "start_time"));
		String endTime = joinDateTime(
				RequestUtil.getParam(request, "end_date"),
				RequestUtil.getParam(request, "end_time"));

		// -------------------------------------------------------------
		// 입력값 검증
		// -------------------------------------------------------------
		if (title == null) {
			fail(request, response, "タイトルを入力してください。");
			return;
		}
		if (startTime == null) {
			fail(request, response, "開始日時を入力してください。");
			return;
		}
		// 종료가 시작보다 빠르면 DB 의 CHECK 제약에 걸린다. 미리 막는다.
		if (endTime != null && endTime.compareTo(startTime) < 0) {
			fail(request, response, "終了日時は開始日時より後にしてください。");
			return;
		}
		if (!"PRIVATE".equals(visibility) && !"DEPT".equals(visibility) && !"ALL".equals(visibility)) {
			visibility = "PRIVATE";
		}

		ScheduleDTO dto = new ScheduleDTO();
		dto.setEmployee_id(loginUser.getEmployee_id());
		dto.setTitle(title);
		dto.setContent(content);
		dto.setLocation(location);
		dto.setVisibility(visibility);
		dto.setStart_time(startTime);
		dto.setEnd_time(endTime);

		int result;

		if (scheduleNo > 0) {
			// 수정 (DAO 의 WHERE 에 employee_id 가 있어 본인 것만 갱신된다)
			dto.setSchedule_no(scheduleNo);
			result = dao.updateSchedule(dto);
		} else {
			result = dao.insertSchedule(dto);
		}

		if (result <= 0) {
			fail(request, response, "予定の保存に失敗しました。");
			return;
		}

		System.out.println("[ScheduleWriteService] 일정 저장 완료 : " + title);

		// 저장한 일정이 있는 달로 이동한다
		String yearMonth = startTime.substring(0, 7);
		RequestUtil.redirect(request, response,
				"/pages/schedule.do?ym=" + yearMonth + "&result=saved");
	}

	/**
	 * 날짜와 시각을 "YYYY-MM-DD HH:MI" 로 합친다.
	 * 날짜가 없으면 null, 시각이 없으면 00:00 으로 본다.
	 */
	private String joinDateTime(String date, String time) {

		if (date == null || date.isEmpty()) {
			return null;
		}
		return date + " " + (time == null || time.isEmpty() ? "00:00" : time);
	}

	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("editMode", RequestUtil.getIntParam(request, "no", 0) > 0);
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
