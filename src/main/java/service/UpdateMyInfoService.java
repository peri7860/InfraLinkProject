package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.EmployeeDAO;
import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 마이페이지 개인정보 수정 (이메일 / 내선번호 / 전화번호).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 이 서비스를 호출하는 화면이 한 곳도 없었다.
 *     mypage.jsp 의 폼에 action 속성이 없어 어디로도 전송되지 않았다.
 *     → mypage.jsp 폼을 이 서비스로 연결했다.
 *  2) session.getAttribute("loginUser") 결과를 null 체크 없이 사용했다.
 *     → 세션이 만료된 뒤 저장을 누르면 NPE(500 에러)가 났다.
 *  3) 입력값 검증이 전혀 없었다. (이메일 형식 등)
 *  4) 응답이 평문뿐이라 일반 폼 전송에서는 쓸 수 없었다.
 *     → AJAX 면 평문, 폼 전송이면 리다이렉트(PRG)로 분기.
 * </pre>
 */
public class UpdateMyInfoService implements Command {

	/** 단순 이메일 형식 검사용 정규식 */
	private static final String EMAIL_PATTERN = "^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		// [수정] null 체크 추가 : 세션 만료 시 NPE 대신 로그인 화면으로 보낸다.
		if (loginUser == null) {
			respond(request, response, "session_expired", "/pages/login.do");
			return;
		}

		String email = RequestUtil.getParam(request, "email");
		String extNo = RequestUtil.getParam(request, "ext_no");
		String phone = RequestUtil.getParam(request, "phone");

		// -------------------------------------------------------------
		// 입력값 검증
		// -------------------------------------------------------------
		if (email != null && !email.matches(EMAIL_PATTERN)) {
			respond(request, response, "invalid_email", "/pages/mypage.do?result=invalid_email");
			return;
		}

		EmployeeDTO updateDto = new EmployeeDTO();
		updateDto.setEmployee_id(loginUser.getEmployee_id());
		updateDto.setEmail(email);
		updateDto.setExt_no(extNo);
		updateDto.setPhone(phone);

		int result = new EmployeeDAO().updateMyInfo(updateDto);

		if (result > 0) {
			// DB 수정 후 세션 정보도 최신화해 화면에 즉시 반영한다.
			loginUser.setEmail(email);
			loginUser.setExt_no(extNo);
			loginUser.setPhone(phone);

			HttpSession session = request.getSession(false);
			if (session != null) {
				session.setAttribute(RequestUtil.SESSION_LOGIN_USER, loginUser);
			}
			respond(request, response, "success", "/pages/mypage.do?result=success");

		} else {
			respond(request, response, "fail", "/pages/mypage.do?result=fail");
		}
	}

	/**
	 * AJAX 면 평문, 일반 폼 전송이면 리다이렉트(PRG)로 응답한다.
	 * 리다이렉트를 쓰는 이유는 새로고침 시 같은 요청이 다시 전송되는 것을 막기 위해서다.
	 */
	private void respond(HttpServletRequest request, HttpServletResponse response,
			String ajaxText, String redirectPath) throws IOException {

		if (RequestUtil.isAjax(request)) {
			RequestUtil.writeText(response, ajaxText);
		} else {
			RequestUtil.redirect(request, response, redirectPath);
		}
	}
}
