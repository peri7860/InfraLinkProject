package service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NoticeDAO;
import model.NoticeDTO;
import util.Paging;
import util.RequestUtil;

/**
 * 공지사항 목록.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   notice-list.jsp 의 공지 8건이 전부 HTML 하드코딩이었고,
 *   페이지 번호(1 2 3 4 5)도 고정이었다.
 *   NoticeDAO 에는 조회 메서드가 있었지만 호출하는 곳이 한 곳도 없었다.
 *   → DB 조회 + 검색 + 페이징으로 새로 연결했다.
 * </pre>
 */
public class NoticeListService implements Command {

	private static final int PAGE_SIZE = 10;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String keyword = RequestUtil.getParam(request, "keyword");
		String category = RequestUtil.getParam(request, "category");
		int page = Paging.parsePage(request.getParameter("page"));

		NoticeDAO dao = new NoticeDAO();

		// 전체 건수를 먼저 구해 페이지를 계산한다.
		int totalCount = dao.countNotice(keyword, category);
		Paging paging = new Paging(page, totalCount, PAGE_SIZE, Paging.DEFAULT_BLOCK_SIZE);

		List<NoticeDTO> noticeList = dao.selectNoticePage(
				keyword, category, paging.getStartRow(), paging.getEndRow());

		request.setAttribute("noticeList", noticeList);
		request.setAttribute("paging", paging);

		// 검색 조건을 화면에 유지
		request.setAttribute("keyword", keyword);
		request.setAttribute("category", category);

		request.getRequestDispatcher("/WEB-INF/pages/notice-list.jsp")
				.forward(request, response);
	}
}
