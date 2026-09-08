package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * 문자 인코딩 필터.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   각 서블릿/서비스가 request.setCharacterEncoding("UTF-8") 을
 *   개별적으로 호출하고 있었다. 문제는 두 가지였다.
 *
 *   1) 빠뜨린 곳이 있으면 그 요청만 한글/일본어가 깨진다.
 *      (실제로 EmployeeEditService 등 몇 곳에 없었다)
 *   2) setCharacterEncoding() 은 <b>요청 본문을 읽기 전에</b> 호출해야만
 *      효과가 있다. 서비스에 도달했을 때 이미 파라미터를 한 번이라도
 *      읽었다면 그 호출은 무시된다.
 *      → 가장 앞단인 필터에서 한 번 설정하는 것이 확실하다.
 *
 * POST 본문에만 적용된다는 점에 주의
 *   GET 쿼리스트링의 인코딩은 이 설정이 아니라
 *   톰캣의 URIEncoding 이 결정한다.
 *   톰캣 8 이상은 기본값이 UTF-8 이므로 별도 설정이 필요 없다.
 *   (톰캣 7 이하를 쓴다면 server.xml 의 Connector 에
 *    URIEncoding="UTF-8" 을 추가해야 한다)
 *
 * 등록 위치
 *   &#64;WebFilter 애노테이션이 아니라 web.xml 에 선언한다.
 *   애노테이션은 <b>필터 실행 순서를 보장하지 않기 때문</b>이다.
 *   인코딩 → 로그인 → 권한 순서가 지켜져야 하므로
 *   web.xml 의 filter-mapping 순서로 제어한다.
 * </pre>
 */
public class EncodingFilter implements Filter {

	/** 적용할 인코딩 (web.xml 의 init-param 으로 바꿀 수 있다) */
	private String encoding = "UTF-8";

	@Override
	public void init(FilterConfig config) throws ServletException {

		String param = config.getInitParameter("encoding");
		if (param != null && !param.trim().isEmpty()) {
			encoding = param.trim();
		}
		System.out.println("[EncodingFilter] 초기화 완료 : " + encoding);
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		// -------------------------------------------------------------
		// 요청 본문 인코딩
		//   이미 지정되어 있으면 덮어쓰지 않는다.
		//   (multipart 요청 등에서 컨테이너가 먼저 정해둔 값을 존중)
		// -------------------------------------------------------------
		if (request.getCharacterEncoding() == null) {
			request.setCharacterEncoding(encoding);
		}

		// -------------------------------------------------------------
		// 응답 인코딩
		//   JSP 는 page 지시자의 contentType 이 우선하므로 화면에는
		//   영향이 없지만, 서비스가 직접 write() 하는 응답
		//   (AJAX 평문/JSON)에 필요하다.
		// -------------------------------------------------------------
		response.setCharacterEncoding(encoding);

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		// 정리할 자원 없음
	}
}
