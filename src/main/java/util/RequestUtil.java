package util;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.EmployeeDTO;

/**
 * 요청 처리 공통 헬퍼.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 만든 이유
 *  - 기존 서비스들이 세션에서 로그인 정보를 꺼낼 때
 *      (EmployeeDTO) session.getAttribute("loginUser")
 *    를 각자 하고 null 체크를 안 해서 NPE 가 났다.
 *    (ChangePasswordService, UpdateMyInfoService)
 *  - 게다가 NoticeInsertService 는 세션 키를 "employee_id" 로 잘못 알고 있어
 *    (실제 저장 키는 "loginUser") 작성자가 항상 null 이었다.
 *  → 세션 키를 상수 한 곳에서 관리하고, 꺼내는 방법도 하나로 통일한다.
 *
 *  - 파라미터를 int 로 바꾸다 NumberFormatException 으로 500 이 나던 것도
 *    여기서 기본값 처리한다.
 * </pre>
 */
public class RequestUtil {

	/**
	 * 로그인 사용자 세션 키.
	 * <p>
	 * <b>이 값 하나만 쓴다.</b> 문자열을 각자 적으면 오타로 조용히 실패한다.
	 * </p>
	 */
	public static final String SESSION_LOGIN_USER = "loginUser";

	/** 로그인 후 원래 가려던 주소를 기억해 두는 세션 키 */
	public static final String SESSION_REDIRECT_URL = "redirectAfterLogin";

	private RequestUtil() {
	}

	// =================================================================
	// 로그인 정보
	// =================================================================

	/**
	 * 세션에서 로그인 사용자를 꺼낸다.
	 *
	 * @return 로그인하지 않았으면 null (세션을 새로 만들지 않는다)
	 */
	public static EmployeeDTO getLoginUser(HttpServletRequest request) {

		// getSession(false) : 세션이 없으면 새로 만들지 않고 null 을 반환.
		// 로그인 여부만 확인하는 자리에서 세션을 만들면 불필요한 세션이 쌓인다.
		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		Object user = session.getAttribute(SESSION_LOGIN_USER);

		return user instanceof EmployeeDTO ? (EmployeeDTO) user : null;
	}

	/** 로그인 사용자의 사번 (미로그인이면 null) */
	public static String getLoginId(HttpServletRequest request) {
		EmployeeDTO user = getLoginUser(request);
		return user == null ? null : user.getEmployee_id();
	}

	/** 로그인 여부 */
	public static boolean isLoggedIn(HttpServletRequest request) {
		return getLoginUser(request) != null;
	}

	/** 관리자 여부 */
	public static boolean isAdmin(HttpServletRequest request) {
		EmployeeDTO user = getLoginUser(request);
		return user != null && user.isAdmin();
	}

	/**
	 * 로그인 사용자를 세션에 저장한다.
	 *
	 * <pre>
	 * ★ 세션 고정 공격(Session Fixation) 방어
	 *   공격자가 미리 만들어 둔 세션 ID 를 피해자에게 심어두면,
	 *   피해자가 그 세션으로 로그인한 뒤 공격자가 같은 ID 로 접근할 수 있다.
	 *   → 로그인에 성공한 시점에 기존 세션을 버리고 새 세션을 만든다.
	 * </pre>
	 */
	public static void setLoginUser(HttpServletRequest request, EmployeeDTO user) {

		HttpSession oldSession = request.getSession(false);
		if (oldSession != null) {
			oldSession.invalidate();
		}

		HttpSession session = request.getSession(true);

		// 비밀번호 해시는 세션에 남기지 않는다.
		// (JSP 에서 실수로 ${loginUser.password} 를 출력하는 사고 방지)
		user.setPassword(null);

		session.setAttribute(SESSION_LOGIN_USER, user);
	}

	/** 로그아웃 (세션 폐기) */
	public static void logout(HttpServletRequest request) {

		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
	}

	// =================================================================
	// 파라미터
	// =================================================================

	/**
	 * 문자열 파라미터. 값이 없거나 공백뿐이면 기본값을 돌려준다.
	 */
	public static String getParam(HttpServletRequest request, String name, String defaultValue) {

		String value = request.getParameter(name);
		if (value == null || value.trim().isEmpty()) {
			return defaultValue;
		}
		return value.trim();
	}

	/** 문자열 파라미터 (없으면 null) */
	public static String getParam(HttpServletRequest request, String name) {
		return getParam(request, name, null);
	}

	/**
	 * 정수 파라미터.
	 * 값이 없거나 숫자가 아니면 기본값을 돌려준다. (NumberFormatException 방지)
	 */
	public static int getIntParam(HttpServletRequest request, String name, int defaultValue) {

		String value = request.getParameter(name);
		if (value == null || value.trim().isEmpty()) {
			return defaultValue;
		}
		try {
			return Integer.parseInt(value.trim());
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	// =================================================================
	// 응답
	// =================================================================

	/** AJAX(fetch/XHR) 요청인지 판별 */
	public static boolean isAjax(HttpServletRequest request) {

		String requestedWith = request.getHeader("X-Requested-With");
		if ("XMLHttpRequest".equals(requestedWith)) {
			return true;
		}
		// fetch() 는 위 헤더를 자동으로 붙이지 않으므로 Accept 도 함께 본다.
		String accept = request.getHeader("Accept");
		return accept != null && accept.contains("application/json");
	}

	/** 평문 응답 (AJAX 처리 결과 "success" / "fail" 등) */
	public static void writeText(HttpServletResponse response, String text) throws IOException {

		response.setContentType("text/plain; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(text);
	}

	/** JSON 응답 */
	public static void writeJson(HttpServletResponse response, String json) throws IOException {

		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json);
	}

	/**
	 * 컨텍스트 경로를 붙여 리다이렉트한다.
	 *
	 * <pre>
	 * [주의] 기존 NoticeInsertService 는
	 *          response.sendRedirect(contextPath + "/notice-write.do")
	 *        라고 썼는데, 실제 서블릿 매핑은 "/pages/*" 이므로
	 *        "/pages/" 가 빠져 404(또는 엉뚱한 index 화면)로 갔다.
	 *        → 이 메서드로 통일해서 같은 실수를 막는다.
	 * </pre>
	 *
	 * @param path "/pages/notice.do" 처럼 컨텍스트 경로를 뺀 경로
	 */
	public static void redirect(HttpServletRequest request, HttpServletResponse response, String path)
			throws IOException {

		response.sendRedirect(request.getContextPath() + path);
	}

	/**
	 * 오류 메시지를 담아 지정한 JSP 로 포워딩한다.
	 * (화면에서는 ${errorMessage} 로 출력)
	 */
	public static void forwardWithError(HttpServletRequest request, HttpServletResponse response,
			String jspPath, String message) throws javax.servlet.ServletException, IOException {

		request.setAttribute("errorMessage", message);
		request.getRequestDispatcher(jspPath).forward(request, response);
	}
}
