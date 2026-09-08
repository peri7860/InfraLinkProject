package controler;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 루트("/") 요청 처리 서블릿.
 *
 * <pre>
 * 이 서블릿이 하는 일
 *   &#64;WebServlet("/") 는 톰캣의 <b>기본 서블릿(default servlet)</b> 매핑을
 *   덮어쓴다. 즉 다른 어떤 매핑에도 걸리지 않는 모든 요청이 여기로 온다.
 *   - 정적 자원(css/js/이미지) → 톰캣 기본 서블릿에 그대로 위임
 *   - 그 외                    → 메인 화면(index.jsp)
 *
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 정적 자원 판별이 .css / .js / .png / .jpg / /assets/ 뿐이었다.
 *     → .ico(파비콘), .svg, .woff2(폰트), .map, .webp 요청이
 *       전부 index.jsp 로 넘어가 HTML 이 응답됐다.
 *       (브라우저 콘솔에 깨진 리소스 오류가 계속 찍히는 원인)
 *  2) 확장자 비교가 대소문자를 구분했다. (.PNG 는 통과 못 함)
 *  3) 쿼리스트링이 붙은 요청(예: style.css?v=2)은 getRequestURI() 에는
 *     포함되지 않지만, 경로에 점이 없는 요청과 구분이 애매했다.
 *  4) 존재하지 않는 경로(/abcd)도 전부 index.jsp 를 보여줘서
 *     404 가 발생하지 않았다. → 오타 URL 을 눌러도 메인이 떠서
 *       "링크가 깨진 것"을 알아챌 수 없었다.
 *  5) doPost 가 doGet 을 그대로 호출했다.
 *
 * 변경 후
 *  - 정적 자원 확장자 목록을 넓히고 소문자로 비교
 *  - 루트("/", "/index.jsp") 만 메인 화면으로
 *  - 그 외 매칭되지 않는 경로는 404 (web.xml 의 error-404.jsp 가 표시됨)
 * </pre>
 */
@WebServlet("/")
public class Home extends HttpServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * 톰캣 기본 서블릿에 그대로 넘길 정적 자원 확장자.
	 * <p>
	 * 여기 없는 확장자는 애플리케이션 요청으로 간주한다.
	 * </p>
	 */
	private static final String[] STATIC_EXTENSIONS = {
			// 스타일 / 스크립트
			".css", ".js", ".map", ".mjs",
			// 이미지
			".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".bmp", ".ico",
			// 폰트
			".woff", ".woff2", ".ttf", ".otf", ".eot",
			// 문서 / 기타
			".pdf", ".txt", ".json", ".xml", ".webmanifest"
	};

	/** 정적 자원이 모여 있는 경로 (확장자와 무관하게 위임) */
	private static final String[] STATIC_DIRS = {
			"/css/", "/js/", "/assets/", "/images/", "/fonts/"
	};

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		handle(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		handle(request, response);
	}

	private void handle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 컨텍스트 경로를 뺀 순수 경로 (예: /InfraLinkProject/css/a.css → /css/a.css)
		String path = request.getRequestURI().substring(request.getContextPath().length());

		// -------------------------------------------------------------
		// 1. 정적 자원 → 톰캣 기본 서블릿에 위임
		//    (@WebServlet("/") 로 기본 서블릿을 덮어썼기 때문에
		//     직접 넘겨주지 않으면 css/js 가 전혀 로딩되지 않는다)
		// -------------------------------------------------------------
		if (isStaticResource(path)) {

			RequestDispatcher defaultServlet =
					request.getServletContext().getNamedDispatcher("default");

			if (defaultServlet != null) {
				defaultServlet.forward(request, response);
			} else {
				// 이름이 "default" 가 아닌 컨테이너에 대비한 방어
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
			return;
		}

		// -------------------------------------------------------------
		// 2. 루트 요청 → 메인 화면
		// -------------------------------------------------------------
		if (path.isEmpty() || "/".equals(path) || "/index.jsp".equals(path)) {
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 3. 예전 링크 호환
		//    화면 여기저기에 컨텍스트 경로 바로 뒤에 "/index.do" 를 붙인
		//    링크가 남아 있어(header.jsp, login.jsp 등) 그대로 받아준다.
		// -------------------------------------------------------------
		if ("/index.do".equals(path)) {
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 4. 그 외 → 404
		//    [수정] 기존에는 여기서도 index.jsp 를 보여줘서
		//           오타 URL 이나 끊어진 링크를 발견할 수 없었다.
		// -------------------------------------------------------------
		System.out.println("[Home] 존재하지 않는 경로 : " + path);
		response.sendError(HttpServletResponse.SC_NOT_FOUND);
	}

	/** 정적 자원 요청인지 판별한다 (대소문자 무시) */
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
