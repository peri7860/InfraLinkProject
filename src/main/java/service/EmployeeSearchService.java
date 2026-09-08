package service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.DepartmentDAO;
import model.EmployeeDAO;
import model.EmployeeDTO;
import util.Paging;
import util.RequestUtil;

/**
 * 사원 검색 (일반 사원용 조직도 / 사원 찾기).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   employee-list.jsp 의 사원 목록이 전부 하드코딩이었고,
 *   employee.js 의 검색 폼은 alert("2단계에서 구현 예정") 만 띄웠다.
 *   index.jsp 의 검색 폼은 action="/pages/employee-list.html"
 *   (컨텍스트 경로도 없고 존재하지도 않는 파일)로 되어 있었다.
 *   → DB 검색 + 페이징으로 새로 구현했다.
 *
 * 관리자용 EmployeeListService 와 분리한 이유
 *   - 일반 사원 화면에서는 재직자만 보여준다.
 *   - 권한(auth_role) 이나 계정 상태 같은 관리 정보는 노출하지 않는다.
 * </pre>
 */
public class EmployeeSearchService implements Command {

	private static final int PAGE_SIZE = 12;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String keyword = RequestUtil.getParam(request, "keyword");
		String deptCode = RequestUtil.getParam(request, "dept_code");
		int page = Paging.parsePage(request.getParameter("page"));

		EmployeeDAO dao = new EmployeeDAO();

		// 일반 사원 화면에서는 재직자만 검색 대상으로 한다.
		final String status = "在職";

		int totalCount = dao.countEmployees(keyword, deptCode, status);
		Paging paging = new Paging(page, totalCount, PAGE_SIZE, Paging.DEFAULT_BLOCK_SIZE);

		List<EmployeeDTO> employeeList = dao.searchEmployees(
				keyword, deptCode, status, paging.getStartRow(), paging.getEndRow());

		request.setAttribute("employeeList", employeeList);
		request.setAttribute("paging", paging);
		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentListWithCount());
		request.setAttribute("keyword", keyword);
		request.setAttribute("deptCode", deptCode);

		request.getRequestDispatcher("/WEB-INF/pages/employee-list.jsp")
				.forward(request, response);
	}
}
