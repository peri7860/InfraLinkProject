package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.RequestUtil;

/**
 * 로그인 확인 필터.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * ★ 이 필터가 없어서 생긴 문제
 *   로그인 여부를 확인하는 코드가 프로젝트 전체에 <b>한 줄도 없었다.</b>
 *   주소창에 아래를 직접 입력하면 누구나 그대로 열렸다.
 *     /pages/admin-dashboard.do   (관리자 대시보드)
 *     /pages/admin-employees.do   (전 사원 명부 — 이메일·전화번호 포함)
 *     /pages/mypage.do            (마이페이지)
 *   사내 인트라넷에서 가장 큰 구멍이었다.
 *
 * 처리 방식
 *   1) 정적 자원(css/js/이미지)과 공개 경로는 그냥 통과시킨다.
 *   2) 세션에 loginUser 가 있으면 통과.
 *   3) 없으면
 *      - AJAX 요청이면 401 을 돌려준다.
 *        (로그인 HTML 이 fetch 응답으로 오면 화면이 이상해지므로)
 *      - 일반 요청이면 <b>원래 가려던 주소를 세션에 저장한 뒤</b>
 *        로그인 화면으로 보낸다.
 *        로그인에 성공하면 LoginService 가 그 주소로 되돌려 보낸다.
 *
 * 등록 위치
 *   실행 순서(인코딩 → 로그인 → 권한)를 보장하기 위해
 *   &#64;WebFilter 가 아니라 web.xml 에 선언한다.
 * </pre>
 */
public class LoginFilter implements Filter {

	/**
	 * 로그인 없이 접근할 수 있는 경로.
	 * <p>
	 * 컨텍스트 경로를 제외한 값으로 비교한다.
	 * </p>
	 */
	private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
			"/pages/login.do", // 로그인 화면
			"/pages/loginpro.do", // 로그인 처리
			"/pages/logout.do", // 로그아웃 (세션이 이미 없어도 동작해야 함)
			"/pages/password-reset.do" // 비밀번호 찾기 안내 화면
	));

	/** 정적 자원 디렉터리 (로그인 없이 접근 허용) */
	private static final String[] STATIC_DIRS = {
			"/css/", "/js/", "/assets/", "/images/", "/fonts/"
	};

	/** 정적 자원 확장자 */
	private static final String[] STATIC_EXTENSIONS = {
			".css", ".js", ".map", ".png", ".jpg", ".jpeg", ".gif", ".svg",
			".webp", ".ico", ".woff", ".woff2", ".ttf", ".otf", ".webmanifest"
	};

	@Override
	public void init(FilterConfig config) throws ServletException {
		System.out.println("[LoginFilter] 초기화 완료 (공개 경로 " + PUBLIC_PATHS.size() + "개)");
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;

		// 컨텍스트 경로를 뺀 순수 경로
		String path = request.getRequestURI().substring(request.getContextPath().length());

		// -------------------------------------------------------------
		// 1. 검사하지 않아도 되는 요청
		// -------------------------------------------------------------
		if (isStaticResource(path) || PUBLIC_PATHS.contains(path)) {
			chain.doFilter(request, response);
			return;
		}

		// 에러 페이지는 로그인 여부와 무관하게 보여야 한다.
		// (로그인 안 한 상태에서 404 가 나면 무한 리다이렉트가 될 수 있다)
		if (path.startsWith("/WEB-INF/pages/error/")) {
			chain.doFilter(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 2. 로그인 확인
		// -------------------------------------------------------------
		if (RequestUtil.isLoggedIn(request)) {
			chain.doFilter(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 3. 미로그인 처리
		// -------------------------------------------------------------
		System.out.println("[LoginFilter] 미로그인 접근 차단 : " + path);

		// AJAX 요청에는 로그인 화면(HTML) 대신 상태 코드를 돌려준다.
		if (RequestUtil.isAjax(request)) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.setContentType("text/plain; charset=UTF-8");
			response.getWriter().write("session_expired");
			return;
		}

		// 원래 가려던 주소를 기억해 둔다 (로그인 후 그쪽으로 되돌려 보냄).
		// GET 요청만 저장한다. POST 는 본문을 재현할 수 없어 의미가 없다.
		if ("GET".equalsIgnoreCase(request.getMethod())) {

			String target = path;
			String query = request.getQueryString();
			if (query != null && !query.isEmpty()) {
				target = target + "?" + query;
			}

			HttpSession session = request.getSession(true);
			session.setAttribute(RequestUtil.SESSION_REDIRECT_URL, target);
		}

		response.sendRedirect(request.getContextPath() + "/pages/login.do?need=login");
	}

	@Override
	public void destroy() {
		// 정리할 자원 없음
	}

	/** 정적 자원 요청인지 판별 (대소문자 무시) */
	private boolean isStaticResource(String path) {

		String lower = path.toLowerCase(Locale.ROOT);

		for (String dir : STATIC_DIRS) {
			if (lower.startsWith(dir)) {
				return true;
			}
		}
		for (String ext : STATIC_EXTENSIONS) {
			if (lower.endsWith(ext)) {
				return true;
			}
		}
		return false;
	}
}
