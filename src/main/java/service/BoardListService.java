package service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BoardDAO;
import model.BoardDTO;
import util.Paging;
import util.RequestUtil;

/**
 * 자유게시판 목록.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-list.jsp 의 게시글이 전부 하드코딩이었고,
 *   테이블도 DAO 도 없었다. → 새로 구현.
 * </pre>
 */
public class BoardListService implements Command {

	private static final int PAGE_SIZE = 10;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String keyword = RequestUtil.getParam(request, "keyword");
		String category = RequestUtil.getParam(request, "category");
		int page = Paging.parsePage(request.getParameter("page"));

		BoardDAO dao = new BoardDAO();

		int totalCount = dao.countBoard(keyword, category);
		Paging paging = new Paging(page, totalCount, PAGE_SIZE, Paging.DEFAULT_BLOCK_SIZE);

		List<BoardDTO> boardList = dao.selectBoardPage(
				keyword, category, paging.getStartRow(), paging.getEndRow());

		request.setAttribute("boardList", boardList);
		request.setAttribute("paging", paging);
		request.setAttribute("keyword", keyword);
		request.setAttribute("category", category);

		request.getRequestDispatcher("/WEB-INF/pages/board-list.jsp")
				.forward(request, response);
	}
}
