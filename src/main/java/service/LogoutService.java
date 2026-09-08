package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.RequestUtil;

/**
 * 로그아웃 처리.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   헤더의 "ログアウト" 링크가 그냥 로그인 화면으로 이동만 했다.
 *   session.invalidate() 를 호출하는 코드가 프로젝트 전체에 없어서
 *   로그아웃해도 세션이 그대로 살아 있었다.
 *   (뒤로가기 한 번이면 다시 로그인 상태)
 * </pre>
 */
public class LogoutService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String loginId = RequestUtil.getLoginId(request);

		// 세션 폐기 (담겨 있던 로그인 정보도 함께 사라진다)
		RequestUtil.logout(request);

		if (loginId != null) {
			System.out.println("[LogoutService] 로그아웃 : " + loginId);
		}

		// 로그인 화면으로 이동. logout=1 을 붙여 안내 메시지를 띄운다.
		RequestUtil.redirect(request, response, "/pages/login.do?logout=1");
	}
}
