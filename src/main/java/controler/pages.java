package controler;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import service.ApprovalListService;
import service.ApprovalProcessService;
import service.ApprovalViewService;
import service.ApprovalWriteService;
import service.BoardDeleteService;
import service.BoardInsertService;
import service.BoardListService;
import service.BoardUpdateService;
import service.BoardViewService;
import service.BoardWriteFormService;
import service.ChangePasswordService;
import service.Command;
import service.CommentService;
import service.EmpRegisterService;
import service.EmployeeDetailService;
import service.EmployeeEditService;
import service.EmployeeIdPreviewService;
import service.EmployeeListService;
import service.EmployeePasswordResetService;
import service.EmployeeRetireService;
import service.EmployeeSearchService;
import service.EmployeeUpdateService;
import service.FileDownloadService;
import service.LoginService;
import service.LogoutService;
import service.MyPageService;
import service.NoticeDeleteService;
import service.NoticeInsertService;
import service.NoticeListService;
import service.NoticeUpdateService;
import service.NoticeViewService;
import service.NoticeWriteFormService;
import service.ScheduleListService;
import service.ScheduleViewService;
import service.SystemStatusService;
import service.UpdateMyInfoService;

/**
 * 프론트 컨트롤러. 모든 <code>/pages/*.do</code> 요청을 받아 서비스로 넘긴다.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) getPathInfo() 가 null 일 때 방어가 없었다.
 *     "/pages" 또는 "/pages/" 로 들어오면 switch(null) 에서 NPE → 500.
 *  2) "/index.do" 가 "/webapp/index.jsp" 를 가리켰다.
 *     webapp 은 배포되면 사라지는 소스 폴더명이라 존재하지 않는 경로다.
 *  3) "/system-status.do" 라우트는 있는데 system-status.jsp 파일이 없었다.
 *  4) 화면에서 쓰는 "admin-approval-rules.do" 라우트가 없어 404 였다. (2곳)
 *  5) &#64;MultipartConfig 이 없어 NoticeInsertService 의 request.getPart() 가
 *     IllegalStateException 을 던졌다. → 첨부파일 업로드 자체가 불가능.
 *  6) 만들어 둔 서비스 중 절반이 라우트가 없어 호출될 수 없었다.
 *     (NoticeInsertService 등)
 *  7) import 가 중복되어 있었다. (EmployeeIdPreviewService, EmployeeEditService)
 *
 * 변경 후 — switch 대신 라우트 표(Map)를 쓴다
 *  - 라우트가 50개를 넘어가면 switch 문은 읽기도 고치기도 어려워진다.
 *  - COMMANDS : 비즈니스 로직이 있는 경로 → Command 구현체
 *  - VIEWS    : 단순 화면 이동 경로 → JSP 경로
 *  - 서비스 객체는 인스턴스 필드가 없는 무상태(stateless) 라
 *    요청마다 new 하지 않고 한 번 만들어 재사용해도 안전하다.
 *
 * 로그인/권한 검사는 여기서 하지 않는다.
 *  → filter.LoginFilter / filter.AdminFilter 가 먼저 처리한다.
 *    (web.xml 에 순서대로 선언되어 있다)
 * </pre>
 */
@WebServlet("/pages/*")
@MultipartConfig(
		// 이 크기를 넘는 부분부터 디스크에 임시 저장 (1MB)
		fileSizeThreshold = 1024 * 1024,
		// 파일 1건 최대 크기 (10MB)
		maxFileSize = 10L * 1024 * 1024,
		// 요청 전체 최대 크기 (50MB)
		maxRequestSize = 50L * 1024 * 1024)
public class pages extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/** JSP 가 모여 있는 경로 */
	private static final String VIEW_DIR = "/WEB-INF/pages/";

	/** 비즈니스 로직이 있는 라우트 : 경로 → 서비스 */
	private static final Map<String, Command> COMMANDS = new LinkedHashMap<>();

	/** 단순 화면 이동 라우트 : 경로 → JSP 파일명 */
	private static final Map<String, String> VIEWS = new LinkedHashMap<>();

	static {

		// =========================================================
		// 인증 / 마이페이지
		// =========================================================
		COMMANDS.put("/loginpro.do", new LoginService());
		COMMANDS.put("/logout.do", new LogoutService());
		COMMANDS.put("/mypage.do", new MyPageService());
		COMMANDS.put("/updateMyInfo.do", new UpdateMyInfoService());
		COMMANDS.put("/changePassword.do", new ChangePasswordService());

		// =========================================================
		// 사원 관리 (관리자)
		// =========================================================
		COMMANDS.put("/admin-employees.do", new EmployeeListService());
		COMMANDS.put("/admin-employee-edit.do", new EmployeeEditService());
		COMMANDS.put("/employeeRegister.do", new EmpRegisterService());
		COMMANDS.put("/employeeUpdate.do", new EmployeeUpdateService());
		COMMANDS.put("/employeeIdPreview.do", new EmployeeIdPreviewService());
		COMMANDS.put("/employeeRetire.do", new EmployeeRetireService());
		COMMANDS.put("/employeePasswordReset.do", new EmployeePasswordResetService());

		// =========================================================
		// 사원 조회 (일반)
		// =========================================================
		COMMANDS.put("/employee.do", new EmployeeSearchService());
		COMMANDS.put("/employee-detail.do", new EmployeeDetailService());

		// =========================================================
		// 공지사항
		// =========================================================
		COMMANDS.put("/notice.do", new NoticeListService());
		COMMANDS.put("/notice-view.do", new NoticeViewService());
		COMMANDS.put("/notice-write.do", new NoticeWriteFormService());
		COMMANDS.put("/noticeInsert.do", new NoticeInsertService());
		COMMANDS.put("/noticeUpdate.do", new NoticeUpdateService());
		COMMANDS.put("/noticeDelete.do", new NoticeDeleteService());

		// =========================================================
		// 자유게시판
		// =========================================================
		COMMANDS.put("/board.do", new BoardListService());
		COMMANDS.put("/board-view.do", new BoardViewService());
		COMMANDS.put("/board-write.do", new BoardWriteFormService());
		COMMANDS.put("/boardInsert.do", new BoardInsertService());
		COMMANDS.put("/boardUpdate.do", new BoardUpdateService());
		COMMANDS.put("/boardDelete.do", new BoardDeleteService());
		COMMANDS.put("/comment.do", new CommentService());

		// =========================================================
		// 전자결재
		// =========================================================
		COMMANDS.put("/approval.do", new ApprovalListService());
		COMMANDS.put("/approval-view.do", new ApprovalViewService());
		COMMANDS.put("/approval-write.do", new ApprovalWriteService());
		COMMANDS.put("/approvalProcess.do", new ApprovalProcessService());

		// =========================================================
		// 일정
		// =========================================================
		COMMANDS.put("/schedule.do", new ScheduleListService());
		COMMANDS.put("/schedule-view.do", new ScheduleViewService());

		// =========================================================
		// 공통
		// =========================================================
		COMMANDS.put("/download.do", new FileDownloadService());
		COMMANDS.put("/system-status.do", new SystemStatusService());

		// =========================================================
		// 단순 화면 이동
		//  아래 경로들은 아직 서비스가 없어 화면만 띄운다(더미 데이터).
		//  해당 모듈의 서비스가 완성되면 COMMANDS 로 옮기면 된다.
		// =========================================================
		VIEWS.put("/login.do", "login.jsp");
		VIEWS.put("/password-reset.do", "password-reset.jsp");

		// TODO: ScheduleWriteService 구현 후 COMMANDS 로 이동
		VIEWS.put("/schedule-write.do", "schedule-write.jsp");

		// TODO: 회의실 예약 서비스 4종 구현 후 COMMANDS 로 이동
		VIEWS.put("/room.do", "room-reserve.jsp");
		VIEWS.put("/room-view.do", "room-reserve-view.jsp");
		VIEWS.put("/room-write.do", "room-reserve-write.jsp");

		// TODO: AttendanceService 구현 후 COMMANDS 로 이동
		VIEWS.put("/attendance.do", "attendance.jsp");

		// TODO: NotificationListService 구현 후 COMMANDS 로 이동
		VIEWS.put("/notifications.do", "notifications.jsp");

		// TODO: AdminDashboardService 구현 후 COMMANDS 로 이동
		VIEWS.put("/admin-dashboard.do", "admin-dashboard.jsp");
		VIEWS.put("/admin-activity.do", "admin-activity.jsp");

		// 결재 규칙 / 역할 관리 화면
		//  [수정] 화면에서 "admin-approval-rules.do" 로 링크하는 곳이 2군데 있는데
		//         라우트가 없어 404 였다. 기존 이름 2개와 함께 모두 등록한다.
		VIEWS.put("/admin-approval-rules.do", "admin-approval-rules.jsp");
		VIEWS.put("/approval-rules.do", "admin-approval-rules.jsp");
		VIEWS.put("/admin-rules.do", "admin-approval-rules.jsp");
		VIEWS.put("/admin-rule-edit.do", "admin-approval-rule-edit.jsp");
		VIEWS.put("/admin-roles.do", "admin-roles.jsp");
		VIEWS.put("/admin-role-edit.do", "admin-role-edit.jsp");

		// TODO: 메신저는 실시간 통신(WebSocket)이 필요해 현재 범위 밖
		VIEWS.put("/messenger.do", "messenger.jsp");
	}

	/**
	 * 이 경로가 존재하는 라우트인지 확인한다.
	 * (LoginFilter 가 없는 경로를 미리 걸러낼 때 사용)
	 */
	public static boolean hasRoute(String path) {
		return COMMANDS.containsKey(path) || VIEWS.containsKey(path);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 인코딩은 EncodingFilter 가 이미 처리하지만,
		// 필터를 거치지 않고 직접 forward 되는 경우를 대비해 한 번 더 설정한다.
		request.setCharacterEncoding("UTF-8");

		String action = request.getPathInfo();

		// -------------------------------------------------------------
		// [수정] pathInfo null 방어
		//   "/pages" 또는 "/pages/" 로 들어오면 null 또는 "/" 가 된다.
		//   기존 코드는 그대로 switch(action) 에 넣어 NPE(500) 가 났다.
		//   → 메인 화면으로 돌려보낸다.
		// -------------------------------------------------------------
		if (action == null || "/".equals(action)) {
			response.sendRedirect(request.getContextPath() + "/index.do");
			return;
		}

		System.out.println("[pages] action : " + action);

		// -------------------------------------------------------------
		// 1. 비즈니스 로직이 있는 경로
		// -------------------------------------------------------------
		Command command = COMMANDS.get(action);
		if (command != null) {
			command.doCommand(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 2. 단순 화면 이동
		// -------------------------------------------------------------
		String view = VIEWS.get(action);
		if (view != null) {
			request.getRequestDispatcher(VIEW_DIR + view).forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 3. 메인 화면
		//   [수정] 기존에는 "/webapp/index.jsp" 를 가리켰다.
		//          webapp 은 배포 시 사라지는 소스 폴더명이라 존재하지 않는다.
		//          실제 배포 경로는 컨텍스트 루트 바로 아래의 /index.jsp 다.
		// -------------------------------------------------------------
		if ("/index.do".equals(action)) {
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 4. 등록되지 않은 경로
		//   web.xml 의 error-page 설정에 따라 error-404.jsp 가 표시된다.
		// -------------------------------------------------------------
		System.out.println("[pages] 등록되지 않은 경로 : " + action);
		response.sendError(HttpServletResponse.SC_NOT_FOUND);
	}
}
