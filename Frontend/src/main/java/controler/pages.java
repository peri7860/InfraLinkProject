package controler;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/pages/*")
public class pages extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public pages() {
        super();
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
        switch(action) {
            case "/approval.do":
                page = "/WEB-INF/pages/approval.jsp"; // 프로젝트 폴더 구조에 맞게 경로 수정
                break;
            case "/attendance.do":
                page = "/WEB-INF/pages/attendance.jsp";
                break;
            case "/board.do":
                page = "/WEB-INF/pages/board-list.jsp";
                break;
            case "/board-view.do":
                page = "/WEB-INF/pages/board-view.jsp";
                break;
            case "/board-write.do":
                page = "/WEB-INF/pages/board-write.jsp";
                break;
            case "/employee.do":
            	page = "/WEB-INF/pages/employee-list.jsp";
            	break;
            case "/employee-detail.do":
                page = "/WEB-INF/pages/employee-detail.jsp";
                break;
            case "/login.do":
                page = "/WEB-INF/pages/login.jsp";
                break;
            case "/messenger.do":
            	page = "/WEB-INF/pages/messenger.jsp";
            	break;
            case "/mypage.do":
            	page = "/WEB-INF/pages/mypage.jsp";
            	break;
            case "/notice.do":
                page = "/WEB-INF/pages/notice-list.jsp";
                break;
            case "/notice-view.do":
                page = "/WEB-INF/pages/notice-view.jsp";
                break;
            case "/notice-write.do":
                page = "/WEB-INF/pages/notice-write.jsp";
                break;
            case "/room.do":
                page = "/WEB-INF/pages/room-reserve.jsp";
                break;
            case "/schedule.do":
            	// 비즈니스 로직(DB 저장 등) 처리 후 목록으로 이동
            	page = "/WEB-INF/pages/schedule.jsp"; // 실제로는 DB 저장 후 목록 페이지로 리다이렉트
            	break;
            case "/index.do":
                page = "/webapp/index.jsp";
                break;
            default:
                // 매핑되지 않은 경로로 들어왔을 때 처리
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
        }
        
        // 2. page가 null이 아니면 포워딩
        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}