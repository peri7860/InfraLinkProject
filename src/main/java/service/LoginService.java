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
 * 로그인 처리.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 이 서비스를 호출하는 화면이 한 곳도 없었다.
 *     login.jsp 는 action="/index.do", method="get" 인 더미 폼이었고
 *     input 에 name 속성조차 없어 employee_id / password 가 전송되지 않았다.
 *     → login.jsp 를 실제 폼으로 고치면서 이 서비스와 연결했다.
 *  2) 아이디/비밀번호가 비어 있어도 그대로 DB 를 조회했다.
 *  3) DB 에 BCrypt 형식이 아닌 비밀번호가 있으면 checkpw 가 예외를 던져
 *     로그인 화면이 500 으로 죽었다. (PasswordUtil 에서 방어하도록 수정)
 *  4) 로그인 성공 시 기존 세션을 그대로 썼다 → 세션 고정 공격에 취약.
 *  5) 비밀번호 해시가 들어 있는 DTO 를 그대로 세션에 넣었다.
 *  6) 응답이 "success"/"fail" 평문뿐이라 일반 폼 전송에서는 쓸 수 없었다.
 *
 * 변경 후
 *  - 입력값 검증 → 조회 → BCrypt 검증 → 세션 재발급 순으로 처리
 *  - 일반 폼 전송이면 리다이렉트(PRG), AJAX 면 평문 응답
 *  - 로그인 전 가려던 주소가 있으면 그쪽으로 보내준다
 *  - 초기 비밀번호(pwd_reset_yn='Y') 사용자는 비밀번호 변경 화면으로 유도
 * </pre>
 */
public class LoginService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String employeeId = RequestUtil.getParam(request, "employee_id");
		String password = request.getParameter("password"); // 비밀번호는 trim 하지 않는다

		// -------------------------------------------------------------
		// 1. 입력값 검증 (DB 를 다녀올 필요도 없는 경우)
		// -------------------------------------------------------------
		if (employeeId == null || password == null || password.isEmpty()) {
			fail(request, response, "社員IDとパスワードを入力してください。");
			return;
		}

		// -------------------------------------------------------------
		// 2. 사원 조회 + 비밀번호 검증
		//    아이디가 틀렸는지 비밀번호가 틀렸는지 구분해서 알려주지 않는다.
		//    (존재하는 사번을 알아내는 것을 막기 위함)
		// -------------------------------------------------------------
		EmployeeDTO employee = new EmployeeDAO().getEmployeeById(employeeId);

		if (employee == null
				|| !PasswordUtil.checkPassword(password, employee.getPassword())) {
			fail(request, response, "社員IDまたはパスワードが正しくありません。");
			return;
		}

		// -------------------------------------------------------------
		// 3. 퇴직/휴직자는 로그인 차단
		// -------------------------------------------------------------
		if ("退職".equals(employee.getEmp_status())) {
			fail(request, response, "退職済みのアカウントです。IT支援部にお問い合わせください。");
			return;
		}

		// -------------------------------------------------------------
		// 4. 로그인 성공 : 세션을 새로 발급하고 사용자 정보를 담는다.
		//    (setLoginUser 안에서 기존 세션 폐기 + 비밀번호 제거까지 처리)
		// -------------------------------------------------------------
		String redirectUrl = takeRedirectUrl(request);
		RequestUtil.setLoginUser(request, employee);

		System.out.println("[LoginService] 로그인 성공 : " + employee.getEmployee_id());

		// 초기 비밀번호 상태면 변경을 유도한다.
		if (employee.isPwdReset()) {
			redirectUrl = "/pages/mypage.do?pwdChange=1";
		}
		if (redirectUrl == null) {
			redirectUrl = "/index.do";
		}

		if (RequestUtil.isAjax(request)) {
			RequestUtil.writeText(response, "success");
		} else {
			RequestUtil.redirect(request, response, redirectUrl);
		}
	}

	/**
	 * 로그인 전에 가려던 주소를 꺼내고 세션에서 지운다.
	 * (LoginFilter 가 저장해 둔 값)
	 */
	private String takeRedirectUrl(HttpServletRequest request) {

		HttpSession session = request.getSession(false);
		if (session == null) {
			return null;
		}
		Object url = session.getAttribute(RequestUtil.SESSION_REDIRECT_URL);
		session.removeAttribute(RequestUtil.SESSION_REDIRECT_URL);

		return url == null ? null : url.toString();
	}

	/** 로그인 실패 응답 */
	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		if (RequestUtil.isAjax(request)) {
			RequestUtil.writeText(response, "fail");
			return;
		}
		// 폼 전송이면 입력했던 사번을 유지한 채 로그인 화면으로 되돌린다.
		request.setAttribute("inputEmployeeId", request.getParameter("employee_id"));
		RequestUtil.forwardWithError(request, response, "/WEB-INF/pages/login.jsp", message);
	}
}
