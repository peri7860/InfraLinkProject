package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.DepartmentDAO;
import model.EmployeeDAO;
import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 사원 등록/수정 폼 화면 표시 (관리자).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 조회한 사원 정보를 request 에 담아 넘기기는 했지만,
 *     admin-employee-edit.jsp 안에서 ${employee...} 를 쓰는 곳이
 *     <b>단 한 군데도 없었다.</b>
 *     → 수정 화면을 열어도 항상 빈 등록 폼이 떴다.
 *       (JSP 를 고쳐 값이 채워지도록 연결했다)
 *  2) id 파라미터가 없으면 dao.getEmployeeById(null) 을 호출했다.
 *     → 지금은 신규 등록 모드로 명확히 구분한다.
 *  3) 부서 select 옵션이 JSP 에 하드코딩되어 있었다.
 *     → department 테이블에서 읽어 넘긴다.
 *
 * 화면 모드
 *   editMode = true  : ?id=... 가 있으면 수정 모드 (기존 값 표시)
 *   editMode = false : id 가 없으면 신규 등록 모드
 * </pre>
 */
public class EmployeeEditService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String employeeId = RequestUtil.getParam(request, "id");

		// -------------------------------------------------------------
		// 1. 부서 목록 (등록/수정 공통으로 필요)
		// -------------------------------------------------------------
		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentList());

		// -------------------------------------------------------------
		// 2. 수정 모드면 기존 사원 정보를 읽어 넘긴다.
		// -------------------------------------------------------------
		if (employeeId == null) {
			// 신규 등록 모드
			request.setAttribute("editMode", false);

		} else {

			EmployeeDTO employee = new EmployeeDAO().getEmployeeById(employeeId);

			if (employee == null) {
				// 없는 사번으로 접근한 경우 (URL 직접 입력 등)
				request.setAttribute("editMode", false);
				request.setAttribute("errorMessage", "該当する社員が見つかりません : " + employeeId);
			} else {
				// 비밀번호 해시는 화면으로 넘기지 않는다.
				employee.setPassword(null);
				request.setAttribute("employee", employee);
				request.setAttribute("editMode", true);
			}
		}

		request.getRequestDispatcher("/WEB-INF/pages/admin-employee-edit.jsp")
				.forward(request, response);
	}
}
