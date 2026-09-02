package controler;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Frontend/*")
public class index extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public index() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String action = request.getPathInfo();
		System.out.println("action : " + action);

		String page = null;
		switch (action) {
		case "/main.do":
			page = "/webapp/index.jsp";// 프로젝트 폴더 구조에 맞게 경로 수정
			break;
		default:
			// 매핑되지 않은 경로로 들어왔을 때 처리
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
		if (page != null) {
			request.getRequestDispatcher(page).forward(request, response);
		}
	}
}