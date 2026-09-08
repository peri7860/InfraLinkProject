package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 모든 서비스(비즈니스 로직)가 구현하는 공통 인터페이스.
 *
 * <pre>
 * [수정] 2026-09-07 — 인터페이스 자체는 그대로 두고 설명만 보강했다.
 *
 * 기존 문제
 *   EmployeeListService 와 EmployeeIdPreviewService 만 이 인터페이스를
 *   구현하지 않아, 컨트롤러(pages.java)에서 이 둘만 다른 방식으로
 *   호출하고 있었다. (Command login = new LoginService() 형태가 안 됨)
 *   → 이번에 모든 서비스가 Command 를 구현하도록 통일했다.
 *
 * 구현 규칙
 *   1. 화면으로 이동해야 하면 forward, 처리 후 목록으로 가야 하면 redirect.
 *      (POST 후 새로고침 시 재전송 경고가 뜨지 않도록 PRG 패턴을 지킨다)
 *   2. 로그인이 필요한 서비스는 LoginFilter 가 이미 막아주므로
 *      서비스 안에서 다시 검사할 필요는 없다.
 *      단, 본인 소유 데이터인지(권한)는 각 서비스가 확인한다.
 * </pre>
 */
public interface Command {

	/**
	 * 요청을 처리한다.
	 *
	 * @param request  요청
	 * @param response 응답
	 */
	void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException;
}
