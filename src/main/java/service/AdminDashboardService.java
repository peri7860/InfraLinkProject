package service;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.AttendanceDAO;
import model.BoardDAO;
import model.DepartmentDAO;
import model.EmployeeDAO;
import model.NoticeDAO;
import model.RoomDAO;
import util.RequestUtil;

/**
 * 관리자 대시보드.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   admin-dashboard.jsp 의 통계 숫자가 전부 하드코딩이었다.
 *   → 각 DAO 의 집계 메서드로 실제 값을 채운다.
 *
 * 여기서 조회하는 것
 *   · 사원 : 전체 / 재직 / 휴직 / 부서별 인원
 *   · 근태 : 오늘 출근자 수
 *   · 결재 : 내가 결재할 대기 건수
 *   · 게시물 : 공지 / 게시글 총 건수
 *   · 회의실 : 오늘 예약 목록
 *
 * 쿼리가 여러 번 나가지만 관리자 1명이 가끔 보는 화면이라
 * 캐싱 없이 매번 조회해도 문제가 없다고 판단했다.
 * </pre>
 */
public class AdminDashboardService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		String today = LocalDate.now().toString();

		// -------------------------------------------------------------
		// 사원 통계
		// -------------------------------------------------------------
		EmployeeDAO employeeDAO = new EmployeeDAO();

		request.setAttribute("totalEmployee", employeeDAO.countByStatus(null));
		request.setAttribute("activeEmployee", employeeDAO.countByStatus("在職"));
		request.setAttribute("leaveEmployee", employeeDAO.countByStatus("休職"));
		request.setAttribute("retiredEmployee", employeeDAO.countByStatus("退職"));

		// 부서별 인원 (조직 현황 위젯)
		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentListWithCount());

		// -------------------------------------------------------------
		// 근태
		// -------------------------------------------------------------
		request.setAttribute("todayCheckIn", new AttendanceDAO().countTodayCheckIn());

		// -------------------------------------------------------------
		// 결재 (내가 결재해야 할 대기 건수)
		// -------------------------------------------------------------
		if (loginId != null) {
			request.setAttribute("waitingApproval",
					new ApprovalDAO().countWaitingForApprover(loginId));
		}

		// -------------------------------------------------------------
		// 게시물
		// -------------------------------------------------------------
		request.setAttribute("noticeCount", new NoticeDAO().countNotice(null, null));
		request.setAttribute("boardCount", new BoardDAO().countBoard(null, null));

		// 최근 공지 5건 (대시보드 위젯)
		request.setAttribute("recentNoticeList", new NoticeDAO().selectLatestNotice(5));

		// -------------------------------------------------------------
		// 오늘의 회의실 예약
		// -------------------------------------------------------------
		request.setAttribute("todayReserveList",
				new RoomDAO().selectReserveByDate(today, null));

		request.setAttribute("today", today);

		request.getRequestDispatcher("/WEB-INF/pages/admin-dashboard.jsp")
				.forward(request, response);
	}
}
