package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AdminDAO;
import model.DepartmentDAO;
import model.EmployeeDTO;
import util.PasswordUtil;
import util.RequestUtil;

/**
 * 신규 사원 등록 (관리자).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) 사번을 서비스에서 미리 만들고 DAO 는 INSERT 만 했다.
 *     그 사이에 다른 관리자가 등록하면 사번이 충돌해 등록이 실패했다.
 *     → 채번과 INSERT 를 AdminDAO.insertEmployee 안에서 함께 처리하고
 *       충돌 시 다음 번호로 재시도하도록 변경.
 *  2) 필수값 검증이 하나도 없었다.
 *     이름/부서 없이도 INSERT 를 시도해 DB 제약 위반으로 500 이 났다.
 *  3) 부서 코드가 실제 존재하는지 확인하지 않았다.
 *     (폼을 조작하면 FK 위반으로 500)
 *  4) 실패해도 "employee-register-success.jsp"(성공 화면)로 보냈다.
 *     성공/실패를 같은 화면에서 분기하도록 되어 있으나
 *     errorMessage 만 세팅하고 사번은 null 이라 화면이 깨졌다.
 *  5) 실패 메시지가 일본어 한 줄로 하드코딩되어 원인을 알 수 없었다.
 *
 * 초기 비밀번호 정책
 *   초기 비밀번호 = 사번 (BCrypt 해시로 저장)
 *   pwd_reset_yn = 'Y' 로 표시되어 최초 로그인 시 변경을 유도한다.
 * </pre>
 */
public class EmpRegisterService implements Command {

	/** 등록/수정 폼 화면 경로 */
	private static final String FORM_PAGE = "/WEB-INF/pages/admin-employee-edit.jsp";

	/** 결과 화면 경로 */
	private static final String RESULT_PAGE = "/WEB-INF/pages/employee-register-success.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String empName = RequestUtil.getParam(request, "emp_name");
		String deptCode = RequestUtil.getParam(request, "dept_code");
		String position = RequestUtil.getParam(request, "position");
		String email = RequestUtil.getParam(request, "email");
		String phone = RequestUtil.getParam(request, "phone");
		String extNo = RequestUtil.getParam(request, "ext_no");
		String authRole = RequestUtil.getParam(request, "auth_role", "USER");

		// -------------------------------------------------------------
		// 1. 필수값 검증
		// -------------------------------------------------------------
		if (empName == null) {
			fail(request, response, "氏名を入力してください。");
			return;
		}
		if (deptCode == null) {
			fail(request, response, "部署を選択してください。");
			return;
		}
		if (position == null) {
			fail(request, response, "職位を選択してください。");
			return;
		}

		// -------------------------------------------------------------
		// 2. 부서 코드가 실제로 존재하는지 확인 (FK 위반 방지)
		// -------------------------------------------------------------
		if (!new DepartmentDAO().exists(deptCode)) {
			fail(request, response, "存在しない部署コードです : " + deptCode);
			return;
		}

		// 권한 값은 화면에서 조작될 수 있으므로 허용값만 통과시킨다.
		if (!"ADMIN".equals(authRole) && !"USER".equals(authRole)) {
			authRole = "USER";
		}

		// -------------------------------------------------------------
		// 3. 등록
		//    비밀번호는 사번과 같게 만들어야 하는데, 사번은 DAO 안에서
		//    확정된다. → 일단 임시 해시로 INSERT 한 뒤,
		//      DAO 가 돌려준 실제 사번으로 비밀번호를 다시 설정한다.
		// -------------------------------------------------------------
		EmployeeDTO emp = new EmployeeDTO();
		emp.setEmp_name(empName);
		emp.setDept_code(deptCode);
		emp.setPosition(position);
		emp.setEmail(email);
		emp.setPhone(phone);
		emp.setExt_no(extNo);
		emp.setAuth_role(authRole);
		emp.setEmp_status("在職");
		// 임시값 (바로 아래에서 실제 사번 기반 해시로 덮어쓴다)
		emp.setPassword(PasswordUtil.hashPassword("TEMP-" + System.nanoTime()));

		AdminDAO dao = new AdminDAO();
		String newEmployeeId = dao.insertEmployee(emp);

		if (newEmployeeId == null) {
			fail(request, response, "社員登録に失敗しました。しばらくしてからもう一度お試しください。");
			return;
		}

		// 초기 비밀번호 = 사번 으로 설정
		new model.EmployeeDAO().resetPassword(
				newEmployeeId, PasswordUtil.hashPassword(newEmployeeId));

		System.out.println("[EmpRegisterService] 사원 등록 완료 : " + newEmployeeId);

		// -------------------------------------------------------------
		// 4. 결과 화면
		// -------------------------------------------------------------
		request.setAttribute("newEmployeeId", newEmployeeId);
		request.setAttribute("newEmployeeName", empName);
		request.getRequestDispatcher(RESULT_PAGE).forward(request, response);
	}

	/**
	 * 등록 실패 시 처리.
	 * 입력값을 잃지 않도록 등록 폼으로 되돌리고 부서 목록도 다시 채운다.
	 */
	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentList());
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
