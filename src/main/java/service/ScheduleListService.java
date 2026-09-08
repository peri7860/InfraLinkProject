package service;

import java.io.IOException;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDTO;
import model.ScheduleDAO;
import model.ScheduleDTO;
import util.RequestUtil;

/**
 * 일정 목록 (월간 캘린더).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   schedule.jsp 의 캘린더가 전부 하드코딩이었고
 *   테이블·DAO·서비스가 모두 없었다. → 새로 구현.
 *
 * 화면에 넘기는 값
 *   scheduleList : 해당 월의 일정 (공개 범위 필터 적용)
 *   yearMonth    : "2026-09"
 *   prevMonth / nextMonth : 이전달/다음달 이동용
 *   firstDayOfWeek / lastDay : 달력 그리기용 (일요일=0)
 * </pre>
 */
public class ScheduleListService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);
		if (loginUser == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		// -------------------------------------------------------------
		// 1. 조회할 연월 결정 (?ym=2026-09, 없으면 이번 달)
		//    잘못된 값이 와도 예외로 죽지 않게 처리한다.
		// -------------------------------------------------------------
		YearMonth target;
		try {
			String ym = RequestUtil.getParam(request, "ym");
			target = ym == null ? YearMonth.now() : YearMonth.parse(ym);
		} catch (DateTimeParseException e) {
			target = YearMonth.now();
		}

		String yearMonth = target.toString(); // "2026-09"

		// -------------------------------------------------------------
		// 2. 일정 조회 (공개 범위는 DAO 의 WHERE 절에서 처리)
		// -------------------------------------------------------------
		List<ScheduleDTO> scheduleList = new ScheduleDAO()
				.selectByMonth(yearMonth, loginUser.getEmployee_id(), loginUser.getDept_code());

		request.setAttribute("scheduleList", scheduleList);
		request.setAttribute("yearMonth", yearMonth);
		request.setAttribute("year", target.getYear());
		request.setAttribute("month", target.getMonthValue());
		request.setAttribute("prevMonth", target.minusMonths(1).toString());
		request.setAttribute("nextMonth", target.plusMonths(1).toString());

		// -------------------------------------------------------------
		// 3. 달력을 그리기 위한 값
		//    getDayOfWeek() 는 월=1 ... 일=7 이므로
		//    일요일 시작 달력에 맞게 0~6 으로 변환한다.
		// -------------------------------------------------------------
		int firstDayOfWeek = target.atDay(1).getDayOfWeek().getValue() % 7;

		request.setAttribute("firstDayOfWeek", firstDayOfWeek);
		request.setAttribute("lastDay", target.lengthOfMonth());
		request.setAttribute("today", java.time.LocalDate.now().toString());

		request.getRequestDispatcher("/WEB-INF/pages/schedule.jsp")
				.forward(request, response);
	}
}
