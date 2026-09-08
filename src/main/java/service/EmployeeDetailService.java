package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.EmployeeDAO;
import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 사원 상세 프로필 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   employee-detail.jsp 가 특정 인물 정보로 하드코딩되어 있었고
 *   (전화번호까지 tel:0312340212 로 고정),
 *   employee-list 에서 넘어와도 항상 같은 사람이 보였다.
 *   → 사번을 받아 DB 에서 읽어오도록 새로 구현했다.
 *
 * 개인정보 취급
 *   - 비밀번호 해시는 화면으로 넘기지 않는다.
 *   - 본인 또는 관리자가 아니면 전화번호를 마스킹해서 보여준다.
 *     (EmployeeDTO.getMaskedPhone())
 * </pre>
 */
public class EmployeeDetailService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String employeeId = RequestUtil.getParam(request, "id");

		if (employeeId == null) {
			RequestUtil.redirect(request, response, "/pages/employee.do");
			return;
		}

		EmployeeDTO employee = new EmployeeDAO().getEmployeeById(employeeId);

		if (employee == null) {
			request.setAttribute("errorMessage", "該当する社員が見つかりません : " + employeeId);
			request.getRequestDispatcher("/WEB-INF/pages/employee-detail.jsp")
					.forward(request, response);
			return;
		}

		// 비밀번호 해시 제거
		employee.setPassword(null);

		// 본인 또는 관리자만 전체 연락처를 볼 수 있다.
		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);
		boolean showFullContact = loginUser != null
				&& (loginUser.isAdmin() || employeeId.equals(loginUser.getEmployee_id()));

		request.setAttribute("employee", employee);
		request.setAttribute("showFullContact", showFullContact);

		request.getRequestDispatcher("/WEB-INF/pages/employee-detail.jsp")
				.forward(request, response);
	}
}
