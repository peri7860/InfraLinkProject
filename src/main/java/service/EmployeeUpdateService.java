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
 * 사원 정보 수정 처리 (관리자).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * ★ 이 기능 자체가 없었다.
 *   admin-employee-edit.jsp 의 저장 버튼이
 *     action="${contextPath}/pages/employeeRegister.do"
 *   로 되어 있어서, 기존 사원을 "수정"하면 실제로는
 *   <b>새 사번으로 사원이 하나 더 등록</b>되고 있었다.
 *   EmployeeDAO 에도 사원 수정 메서드가 없었다.
 *   → DAO 에 updateEmployee 를 추가하고, 이 서비스를 새로 만들어
 *     JSP 의 폼이 수정 모드일 때 이쪽으로 전송되게 했다.
 *
 * 사번과 비밀번호는 여기서 바꾸지 않는다.
 *   - 사번은 PK 이자 로그인 ID 이며 다른 테이블이 FK 로 참조한다.
 *   - 비밀번호는 EmployeePasswordResetService 로만 초기화한다.
 * </pre>
 */
public class EmployeeUpdateService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/admin-employee-edit.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String employeeId = RequestUtil.getParam(request, "employee_id");
		String empName = RequestUtil.getParam(request, "emp_name");
		String deptCode = RequestUtil.getParam(request, "dept_code");
		String position = RequestUtil.getParam(request, "position");
		String email = RequestUtil.getParam(request, "email");
		String phone = RequestUtil.getParam(request, "phone");
		String extNo = RequestUtil.getParam(request, "ext_no");
		String empStatus = RequestUtil.getParam(request, "emp_status", "在職");
		String authRole = RequestUtil.getParam(request, "auth_role", "USER");

		// -------------------------------------------------------------
		// 1. 필수값 검증
		// -------------------------------------------------------------
		if (employeeId == null) {
			fail(request, response, "社員番号が指定されていません。");
			return;
		}
		if (empName == null || deptCode == null || position == null) {
			fail(request, response, "氏名・部署・職位は必須です。");
			return;
		}
		if (!new DepartmentDAO().exists(deptCode)) {
			fail(request, response, "存在しない部署コードです : " + deptCode);
			return;
		}

		// 허용값 이외는 안전한 기본값으로 되돌린다 (폼 조작 방어)
		if (!"ADMIN".equals(authRole) && !"USER".equals(authRole)) {
			authRole = "USER";
		}
		if (!"在職".equals(empStatus) && !"休職".equals(empStatus) && !"退職".equals(empStatus)) {
			empStatus = "在職";
		}

		// -------------------------------------------------------------
		// 2. 대상 사원이 실제로 있는지 확인
		// -------------------------------------------------------------
		EmployeeDAO dao = new EmployeeDAO();
		if (dao.getEmployeeById(employeeId) == null) {
			fail(request, response, "該当する社員が見つかりません : " + employeeId);
			return;
		}

		// -------------------------------------------------------------
		// 3. 수정
		// -------------------------------------------------------------
		EmployeeDTO emp = new EmployeeDTO();
		emp.setEmployee_id(employeeId);
		emp.setEmp_name(empName);
		emp.setDept_code(deptCode);
		emp.setPosition(position);
		emp.setEmail(email);
		emp.setPhone(phone);
		emp.setExt_no(extNo);
		emp.setEmp_status(empStatus);
		emp.setAuth_role(authRole);

		int result = dao.updateEmployee(emp);

		if (result > 0) {
			System.out.println("[EmployeeUpdateService] 사원 수정 완료 : " + employeeId);
			// PRG 패턴 : 처리 후 목록으로 리다이렉트
			RequestUtil.redirect(request, response, "/pages/admin-employees.do?result=updated");
		} else {
			fail(request, response, "社員情報の更新に失敗しました。");
		}
	}

	/** 실패 시 수정 폼으로 되돌린다 (입력값 유지) */
	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentList());
		request.setAttribute("editMode", true);

		String employeeId = RequestUtil.getParam(request, "employee_id");
		if (employeeId != null) {
			EmployeeDTO employee = new EmployeeDAO().getEmployeeById(employeeId);
			if (employee != null) {
				employee.setPassword(null);
				request.setAttribute("employee", employee);
			}
		}
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
