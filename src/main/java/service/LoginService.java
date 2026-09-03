package service;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.EmployeeDAO;
import model.EmployeeDTO;
import util.PasswordUtil;

public class LoginService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {

		request.setCharacterEncoding("utf-8");
		
		String employeeId = request.getParameter("employee_id");
		String password = request.getParameter("password");
		
		// 아이디로 DB에서 암호화된 비밀번호가 포함된 전체 사원 정보 가져오기
		EmployeeDTO employee = new EmployeeDAO().getEmployeeById(employeeId);
	
		// 사원이 존재하고 && 입력한 평문 비밀번호가 DB의 해시와 일치하는지 검증
		if(employee != null && PasswordUtil.checkPasswrod(password, employee.getPassword())) {
			
			// DTO 객체 전체를 세션에 저장
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", employee);
			
			response.getWriter().write("success");
		}else {
			response.getWriter().write("fail");
		}
	}
}