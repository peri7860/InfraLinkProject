package service;

import java.io.IOException;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AttendanceDAO;
import util.RequestUtil;

/**
 * 근태 현황 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   attendance.jsp 화면만 있고 테이블·DTO·DAO·서비스가 전부 없었다.
 *   화면의 출퇴근 기록과 통계는 모두 하드코딩이었다.
 *
 * 화면에 넘기는 값
 *   today        : 오늘의 근태 기록 (없으면 null → 미출근 상태)
 *   attendanceList: 조회한 달의 기록 목록
 *   workDays / workHours / lateCount : 월간 통계
 *   yearMonth / prevMonth / nextMonth : 월 이동용
 * </pre>
 */
public class AttendanceService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		// -------------------------------------------------------------
		// 조회할 연월 (?ym=2026-09, 없으면 이번 달)
		// -------------------------------------------------------------
		YearMonth target;
		try {
			String ym = RequestUtil.getParam(request, "ym");
			target = ym == null ? YearMonth.now() : YearMonth.parse(ym);
		} catch (DateTimeParseException e) {
			target = YearMonth.now();
		}

		String yearMonth = target.toString();

		AttendanceDAO dao = new AttendanceDAO();

		// 오늘 기록 (출근/퇴근 버튼 상태를 결정한다)
		request.setAttribute("today", dao.selectToday(loginId));

		// 이번 달 목록
		request.setAttribute("attendanceList", dao.selectByMonth(loginId, yearMonth));

		// 월간 통계 [0]=근무일수 [1]=총 근무 분 [2]=지각 횟수
		int[] summary = dao.getMonthlySummary(loginId, yearMonth);
		request.setAttribute("workDays", summary[0]);
		request.setAttribute("workHours", summary[1] / 60);
		request.setAttribute("workMinutes", summary[1] % 60);
		request.setAttribute("lateCount", summary[2]);

		request.setAttribute("yearMonth", yearMonth);
		request.setAttribute("year", target.getYear());
		request.setAttribute("month", target.getMonthValue());
		request.setAttribute("prevMonth", target.minusMonths(1).toString());
		request.setAttribute("nextMonth", target.plusMonths(1).toString());

		request.getRequestDispatcher("/WEB-INF/pages/attendance.jsp")
				.forward(request, response);
	}
}
