package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDAO;
import util.PasswordUtil;
import util.RequestUtil;

/**
 * 비밀번호 초기화 (관리자).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   password-reset.jsp 화면은 있었지만 처리하는 코드가 전혀 없었다.
 *   (폼에 action 도 없는 완전한 더미 화면)
 *
 * 처리 내용
 *   비밀번호를 사번과 같은 값으로 되돌리고 pwd_reset_yn 을 'Y' 로 만든다.
 *   → 해당 사원이 다음에 로그인하면 비밀번호 변경 화면으로 유도된다.
 *
 * 왜 임의의 문자열이 아니라 사번인가
 *   메일 발송 기능이 없는 사내 시스템이므로,
 *   관리자가 전화로 알려주기 쉬운 "사번과 동일" 규칙을 쓴다.
 *   (신규 등록 시의 초기 비밀번호 정책과 동일)
 * </pre>
 */
public class EmployeePasswordResetService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String targetId = RequestUtil.getParam(request, "id");

		if (targetId == null) {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=no_target");
			return;
		}

		EmployeeDAO dao = new EmployeeDAO();

		// 대상 사원이 실제로 있는지 확인
		if (dao.getEmployeeById(targetId) == null) {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=not_found");
			return;
		}

		// 초기 비밀번호 = 사번 (반드시 해시로 저장)
		int result = dao.resetPassword(targetId, PasswordUtil.hashPassword(targetId));

		if (result > 0) {
			System.out.println("[EmployeePasswordResetService] 비밀번호 초기화 : " + targetId);
			RequestUtil.redirect(request, response,
					"/pages/admin-employee-edit.do?id=" + targetId + "&result=pwd_reset");
		} else {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=fail");
		}
	}
}
