package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDAO;
import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 퇴사 처리 (관리자).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   사원 삭제/퇴사 처리 기능이 아예 없었다.
 *
 * 물리 삭제(DELETE)를 하지 않는 이유
 *   공지·게시글·결재 문서가 employee_id 를 외래키로 참조하고 있어
 *   실제로 지우면 과거 문서의 작성자 정보가 통째로 깨진다.
 *   → emp_status 를 '退職' 으로 바꾸는 논리 삭제로 처리한다.
 *     (퇴직자는 LoginService 에서 로그인이 차단된다)
 *
 * 안전장치
 *   - 관리자 본인 계정은 퇴사 처리할 수 없다.
 *     (실수로 스스로를 잠가버리는 것을 막는다)
 * </pre>
 */
public class EmployeeRetireService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String targetId = RequestUtil.getParam(request, "id");
		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		// -------------------------------------------------------------
		// 1. 파라미터 검증
		// -------------------------------------------------------------
		if (targetId == null) {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=no_target");
			return;
		}

		// -------------------------------------------------------------
		// 2. 자기 자신은 퇴사 처리 불가
		// -------------------------------------------------------------
		if (loginUser != null && targetId.equals(loginUser.getEmployee_id())) {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=self_retire");
			return;
		}

		// -------------------------------------------------------------
		// 3. 처리
		// -------------------------------------------------------------
		int result = new EmployeeDAO().retireEmployee(targetId);

		if (result > 0) {
			System.out.println("[EmployeeRetireService] 퇴사 처리 : " + targetId
					+ " (처리자 : " + (loginUser == null ? "?" : loginUser.getEmployee_id()) + ")");
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=retired");
		} else {
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=fail");
		}
	}
}
