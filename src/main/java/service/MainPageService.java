package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.AttendanceDAO;
import model.BoardDAO;
import model.EmployeeDTO;
import model.NoticeDAO;
import model.NotificationDAO;
import model.ScheduleDAO;
import util.RequestUtil;

/**
 * 메인 화면(index.jsp) 데이터.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   index.jsp 의 공지 목록·일정 위젯이 전부 하드코딩이었고,
 *   main.js 는 "추후 공지사항 Ajax ... 추가" 라는 주석만 있는 빈 파일이었다.
 *   라우트도 JSP 로 바로 forward 하고 있어 데이터를 넣을 자리가 없었다.
 *
 * 여기서 채우는 것
 *   latestNoticeList : 최신 공지 5건
 *   latestBoardList  : 최신 게시글 5건
 *   upcomingSchedule : 다가오는 내 일정 5건
 *   todayAttendance  : 오늘 출퇴근 상태 (출근 버튼 노출 판단)
 *   waitingApproval  : 내가 결재할 대기 건수
 *   unreadCount      : 미읽음 알림 수 (헤더 배지)
 * </pre>
 */
public class MainPageService implements Command {

	/** 위젯에 보여줄 건수 */
	private static final int WIDGET_SIZE = 5;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		// LoginFilter 가 막아주므로 보통은 여기 올 때 로그인 상태다.
		if (loginUser == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String loginId = loginUser.getEmployee_id();

		// -------------------------------------------------------------
		// 공지 / 게시판 최신글
		// -------------------------------------------------------------
		request.setAttribute("latestNoticeList",
				new NoticeDAO().selectLatestNotice(WIDGET_SIZE));

		request.setAttribute("latestBoardList",
				new BoardDAO().selectBoardPage(null, null, 1, WIDGET_SIZE));

		// -------------------------------------------------------------
		// 다가오는 일정 (공개 범위는 DAO 가 걸러준다)
		// -------------------------------------------------------------
		request.setAttribute("upcomingSchedule",
				new ScheduleDAO().selectUpcoming(loginId, loginUser.getDept_code(), WIDGET_SIZE));

		// -------------------------------------------------------------
		// 오늘 근태 / 결재 대기 / 알림
		// -------------------------------------------------------------
		request.setAttribute("todayAttendance", new AttendanceDAO().selectToday(loginId));
		request.setAttribute("waitingApproval",
				new ApprovalDAO().countWaitingForApprover(loginId));
		request.setAttribute("unreadCount", new NotificationDAO().countUnread(loginId));

		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}
}
