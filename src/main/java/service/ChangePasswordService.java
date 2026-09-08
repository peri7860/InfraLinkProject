package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.EmployeeDAO;
import model.EmployeeDTO;
import util.PasswordUtil;
import util.RequestUtil;

/**
 * 비밀번호 변경.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 이 서비스를 호출하는 화면이 없었다. (mypage.jsp 폼에 action 없음)
 *  2) loginUser 를 null 체크 없이 getEmployee_id() 호출
 *     → 세션 만료 시 NPE(500 에러)
 *  3) 새 비밀번호 확인란 대조, 비밀번호 정책 검사가 전혀 없었다.
 *  4) 현재 비밀번호와 똑같은 값으로도 변경이 가능했다.
 *  5) 비밀번호를 바꿔도 pwd_reset_yn 이 Y 로 남아
 *     로그인할 때마다 변경 안내가 계속 떴다.
 *     → EmployeeDAO.updatePassword 에서 N 으로 함께 갱신하도록 수정.
 *  6) PasswordUtil.checkPasswrod 가 예외를 던질 수 있었다.
 *     → PasswordUtil 을 예외 없는 구조로 수정 (false 반환).
 * </pre>
 */
public class ChangePasswordService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		// [수정] null 체크 추가
		if (loginUser == null) {
			respond(request, response, "session_expired", "/pages/login.do");
			return;
		}

		// 비밀번호는 앞뒤 공백도 의미가 있으므로 trim 하지 않는다.
		String currentPassword = request.getParameter("current_password");
		String newPassword = request.getParameter("new_password");
		String confirmPassword = request.getParameter("confirm_password");

		// -------------------------------------------------------------
		// 1. 입력값 검증
		// -------------------------------------------------------------
		if (isEmpty(currentPassword) || isEmpty(newPassword)) {
			respond(request, response, "empty", "/pages/mypage.do?pwdResult=empty");
			return;
		}

		// 확인란이 화면에 있는 경우에만 대조한다.
		if (confirmPassword != null && !newPassword.equals(confirmPassword)) {
			respond(request, response, "fail_confirm", "/pages/mypage.do?pwdResult=fail_confirm");
			return;
		}

		// 비밀번호 정책 : 8자 이상 + 영문/숫자 포함
		if (!PasswordUtil.isValidPolicy(newPassword)) {
			respond(request, response, "fail_policy", "/pages/mypage.do?pwdResult=fail_policy");
			return;
		}

		// 현재 비밀번호와 동일하면 변경할 이유가 없다.
		if (currentPassword.equals(newPassword)) {
			respond(request, response, "fail_same", "/pages/mypage.do?pwdResult=fail_same");
			return;
		}

		// -------------------------------------------------------------
		// 2. 현재 비밀번호 검증
		//    세션 값이 아니라 DB 의 최신 해시로 확인한다.
		// -------------------------------------------------------------
		EmployeeDAO dao = new EmployeeDAO();
		EmployeeDTO dbUser = dao.getEmployeeById(loginUser.getEmployee_id());

		if (dbUser == null || !PasswordUtil.checkPassword(currentPassword, dbUser.getPassword())) {
			respond(request, response, "fail_mismatch", "/pages/mypage.do?pwdResult=fail_mismatch");
			return;
		}

		// -------------------------------------------------------------
		// 3. 변경 (반드시 해시로 저장)
		// -------------------------------------------------------------
		String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
		int result = dao.updatePassword(loginUser.getEmployee_id(), hashedNewPassword);

		if (result > 0) {
			// 초기 비밀번호 상태가 해제되었으므로 세션에도 반영한다.
			loginUser.setPwd_reset_yn("N");

			HttpSession session = request.getSession(false);
			if (session != null) {
				session.setAttribute(RequestUtil.SESSION_LOGIN_USER, loginUser);
			}
			System.out.println("[ChangePasswordService] 비밀번호 변경 완료 : "
					+ loginUser.getEmployee_id());

			respond(request, response, "success", "/pages/mypage.do?pwdResult=success");

		} else {
			respond(request, response, "error", "/pages/mypage.do?pwdResult=error");
		}
	}

	private boolean isEmpty(String value) {
		return value == null || value.isEmpty();
	}

	private void respond(HttpServletRequest request, HttpServletResponse response,
			String ajaxText, String redirectPath) throws IOException {

		if (RequestUtil.isAjax(request)) {
			RequestUtil.writeText(response, ajaxText);
		} else {
			RequestUtil.redirect(request, response, redirectPath);
		}
	}
}
