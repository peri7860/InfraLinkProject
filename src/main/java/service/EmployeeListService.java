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
 * 관리자용 사원 목록 (검색 + 페이징).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) Command 인터페이스를 구현하지 않아 컨트롤러에서 다른 방식으로
 *     호출해야 했다. → implements Command 로 통일.
 *  2) 전체 사원을 한 번에 다 읽어 화면에 뿌렸다.
 *     사원이 늘어나면 그대로 느려지는 구조 + 페이지 번호는 HTML 하드코딩.
 *     → 검색 조건 + 페이징을 적용.
 *  3) 검색/필터 기능이 없었다. (화면의 검색창은 동작하지 않았다)
 * </pre>
 */
public class EmployeeListService implements Command {

	/** 한 페이지에 보여줄 사원 수 */
	private static final int PAGE_SIZE = 10;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// -------------------------------------------------------------
		// 1. 검색 조건
		// -------------------------------------------------------------
		String keyword = RequestUtil.getParam(request, "keyword");
		String deptCode = RequestUtil.getParam(request, "dept_code");
		String status = RequestUtil.getParam(request, "emp_status");
		int page = Paging.parsePage(request.getParameter("page"));

		EmployeeDAO dao = new EmployeeDAO();

		// -------------------------------------------------------------
		// 2. 전체 건수를 먼저 구해 페이징을 계산한다.
		//    (Paging 이 page 값을 유효 범위로 보정해 준다)
		// -------------------------------------------------------------
		int totalCount = dao.countEmployees(keyword, deptCode, status);
		Paging paging = new Paging(page, totalCount, PAGE_SIZE, Paging.DEFAULT_BLOCK_SIZE);

		List<EmployeeDTO> employeeList = dao.searchEmployees(
				keyword, deptCode, status, paging.getStartRow(), paging.getEndRow());

		// -------------------------------------------------------------
		// 3. 화면에 필요한 값들
		// -------------------------------------------------------------
		request.setAttribute("employeeList", employeeList);
		request.setAttribute("paging", paging);
		request.setAttribute("departmentList", new DepartmentDAO().getDepartmentList());

		// 검색어를 화면에 그대로 유지하기 위해 되돌려준다.
		request.setAttribute("keyword", keyword);
		request.setAttribute("deptCode", deptCode);
		request.setAttribute("empStatus", status);

		// 상단 통계
		request.setAttribute("totalEmployee", dao.countByStatus(null));
		request.setAttribute("activeEmployee", dao.countByStatus("在職"));
		request.setAttribute("leaveEmployee", dao.countByStatus("休職"));

		request.getRequestDispatcher("/WEB-INF/pages/admin-employees.jsp")
				.forward(request, response);
	}
}
