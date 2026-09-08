package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 관리자 권한 확인 필터.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * ★ 이 필터가 없어서 생긴 문제
 *   employee 테이블에 auth_role(ADMIN / USER) 컬럼이 있고
 *   사원 등록 화면에도 권한 선택 항목이 있었지만,
 *   <b>그 값을 확인하는 코드가 어디에도 없었다.</b>
 *   즉 일반 사원도 로그인만 하면 관리자 화면을 전부 볼 수 있었다.
 *     - 전 사원 명부 조회 / 수정 / 퇴사 처리
 *     - 비밀번호 초기화
 *     - 시스템 현황
 *
 * url-pattern 을 "/pages/admin-*" 로 못 쓰는 이유
 *   서블릿 스펙의 경로 매핑은 "/prefix/*" 또는 "*.확장자" 두 가지뿐이다.
 *   "/pages/admin-*" 같은 형태는 유효하지 않다.
 *   → "/pages/*" 로 넓게 매핑하고, 관리자 경로인지는 이 안에서 판단한다.
 *
 * 실행 순서
 *   LoginFilter 다음에 실행된다. 따라서 여기 도달했다는 것은
 *   이미 로그인은 되어 있다는 뜻이다. 권한만 확인하면 된다.
 * </pre>
 */
public class AdminFilter implements Filter {

	/**
	 * 관리자만 접근할 수 있는 경로.
	 * <p>
	 * "/admin-" 으로 시작하지 않는 관리 기능도 있어서 목록으로 관리한다.
	 * </p>
	 */
	private static final Set<String> ADMIN_PATHS = new HashSet<>(Arrays.asList(
			// 사원 관리
			"/admin-employees.do",
			"/admin-employee-edit.do",
			"/employeeRegister.do",
			"/employeeUpdate.do",
			"/employeeIdPreview.do",
			"/employeeRetire.do",
			"/employeePasswordReset.do",
			// 관리자 화면
			"/admin-dashboard.do",
			"/admin-activity.do",
			"/admin-approval-rules.do",
			"/approval-rules.do",
			"/admin-rules.do",
			"/admin-rule-edit.do",
			"/admin-roles.do",
			"/admin-role-edit.do",
			// 시스템
			"/system-status.do"
	));

	@Override
	public void init(FilterConfig config) throws ServletException {
		System.out.println("[AdminFilter] 초기화 완료 (관리자 경로 " + ADMIN_PATHS.size() + "개)");
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		// -------------------------------------------------------------
		// 1. 관리자 전용 경로인지 판단
		//    이 필터는 "/pages/*" 전체에 걸려 있으므로
		//    관리자 경로가 아니면 그냥 흘려보낸다.
		// -------------------------------------------------------------
		String path = getActionPath(request);

		if (path == null || !ADMIN_PATHS.contains(path)) {
			chain.doFilter(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 2. 권한 확인
		//    세션의 auth_role 을 본다.
		//    (LoginFilter 를 지나왔으므로 loginUser 는 반드시 있다)
		// -------------------------------------------------------------
		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		if (loginUser != null && loginUser.isAdmin()) {
			chain.doFilter(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 3. 권한 없음
		// -------------------------------------------------------------
		String who = loginUser == null ? "(미상)" : loginUser.getEmployee_id();
		System.out.println("[AdminFilter] 관리자 권한 없음 : " + who + " → " + path);

		if (RequestUtil.isAjax(request)) {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
			response.setContentType("text/plain; charset=UTF-8");
			response.getWriter().write("no_permission");
			return;
		}

		// web.xml 의 error-page 설정에 따라 error-403.jsp 가 표시된다.
		response.sendError(HttpServletResponse.SC_FORBIDDEN);
	}

	@Override
	public void destroy() {
		// 정리할 자원 없음
	}

	/**
	 * "/pages/admin-employees.do" 에서 "/admin-employees.do" 부분을 얻는다.
	 *
	 * <p>
	 * 필터에서는 서블릿의 getPathInfo() 를 쓸 수 없으므로
	 * URI 에서 컨텍스트 경로와 "/pages" 를 직접 떼어낸다.
	 * </p>
	 */
	private String getActionPath(HttpServletRequest request) {

		String uri = request.getRequestURI();
		String prefix = request.getContextPath() + "/pages";

		if (!uri.startsWith(prefix)) {
			return null;
		}
		String path = uri.substring(prefix.length());

		return path.isEmpty() ? null : path;
	}
}
