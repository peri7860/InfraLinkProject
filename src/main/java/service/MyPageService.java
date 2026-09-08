package service;

import java.io.IOException;
import java.time.YearMonth;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AttendanceDAO;
import model.EmployeeDAO;
import model.EmployeeDTO;
import util.RequestUtil;

/**
 * 마이페이지 화면 데이터 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   mypage.jsp 는 이름/부서/연락처가 전부 하드코딩("山田 太郎")이었고,
 *   세션의 로그인 정보를 참조하는 JSP 가 한 개도 없었다.
 *   → DB 에서 최신 정보를 읽어 화면에 넘긴다.
 *
 * 세션이 아니라 DB 를 다시 읽는 이유
 *   관리자가 부서/직위를 바꾼 경우 세션에는 옛 정보가 남아 있다.
 *   마이페이지는 "내 정보"를 확인하는 화면이므로 항상 최신값을 보여준다.
 * </pre>
 */
public class MyPageService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		EmployeeDTO loginUser = RequestUtil.getLoginUser(request);

		// LoginFilter 가 막아주므로 여기 올 때는 항상 로그인 상태지만,
		// 서비스를 직접 호출하는 경우까지 대비해 한 번 더 확인한다.
		if (loginUser == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		// -------------------------------------------------------------
		// 1. 최신 사원 정보
		// -------------------------------------------------------------
		EmployeeDTO employee = new EmployeeDAO().getEmployeeById(loginUser.getEmployee_id());

		if (employee != null) {
			// 비밀번호 해시가 화면으로 넘어가지 않도록 지운다.
			employee.setPassword(null);
			request.setAttribute("employee", employee);
		} else {
			request.setAttribute("employee", loginUser);
		}

		// -------------------------------------------------------------
		// 2. 이번 달 근태 요약 (근무일수 / 총 근무시간 / 지각 횟수)
		// -------------------------------------------------------------
		String yearMonth = YearMonth.now().toString(); // 예) 2026-09
		int[] summary = new AttendanceDAO().getMonthlySummary(loginUser.getEmployee_id(), yearMonth);

		request.setAttribute("workDays", summary[0]);
		request.setAttribute("workHours", summary[1] / 60);
		request.setAttribute("lateCount", summary[2]);

		// -------------------------------------------------------------
		// 3. 로그인 직후 비밀번호 변경을 유도해야 하는 경우
		//    (?pwdChange=1 로 들어오거나 초기 비밀번호 상태)
		// -------------------------------------------------------------
		boolean needPwdChange = "1".equals(request.getParameter("pwdChange"))
				|| (employee != null && employee.isPwdReset());

		request.setAttribute("needPwdChange", needPwdChange);

		request.getRequestDispatcher("/WEB-INF/pages/mypage.jsp").forward(request, response);
	}
}
