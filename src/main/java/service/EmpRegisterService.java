package service;

import java.io.IOException;
import java.time.Year;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AdminDAO;
import model.EmployeeDTO;
import util.PasswordUtil;

public class EmpRegisterService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");

		String empName = request.getParameter("emp_name");
		String deptCode = request.getParameter("dept_code");
		String position = request.getParameter("position");
		String email = request.getParameter("email");
		String authRole = request.getParameter("auth_role");

		AdminDAO dao = new AdminDAO();

		String currentYear = String.valueOf(Year.now().getValue());
		int seqNumber = dao.getNextEmpSequence();

		String newEmployeeId = deptCode + "-" + currentYear + "-" + String.format("%03d", seqNumber);

		String hashedPassword = PasswordUtil.hashPasswrod(newEmployeeId);

		EmployeeDTO emp = new EmployeeDTO();
		emp.setEmployee_id(newEmployeeId);
		emp.setPassword(hashedPassword);
		emp.setEmp_name(empName);
		emp.setDept_code(deptCode);
		emp.setPosition(position);
		emp.setEmail(email);
		emp.setAuth_role(authRole);

		int result = dao.insertEmployee(emp);

		response.setContentType("text/plain; charset=UTF-8");
		if (result > 0) {
			response.getWriter().write(newEmployeeId);
		} else {
			response.getWriter().write("fail");
		}
	}
}
