package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BoardDAO;
import model.BoardDTO;
import util.RequestUtil;

/**
 * 게시글 상세 조회 (댓글 포함).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-view.jsp 의 본문과 댓글이 전부 하드코딩이었다.
 *   → DB 조회로 교체하고 댓글도 함께 읽어 넘긴다.
 *
 * 조회수는 세션 기준으로 한 번만 증가시킨다. (새로고침 어뷰징 방지)
 * </pre>
 */
public class BoardViewService implements Command {

	private static final String READ_FLAG_PREFIX = "boardRead_";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int boardNo = RequestUtil.getIntParam(request, "no", 0);

		if (boardNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/board.do");
			return;
		}

		BoardDAO dao = new BoardDAO();

		// 조회수 증가 (세션에 기록이 없을 때만)
		HttpSession session = request.getSession();
		String readFlag = READ_FLAG_PREFIX + boardNo;

		if (session.getAttribute(readFlag) == null) {
			dao.increaseReadCount(boardNo);
			session.setAttribute(readFlag, Boolean.TRUE);
		}

		BoardDTO board = dao.selectBoardByNo(boardNo);

		if (board == null) {
			request.setAttribute("errorMessage", "投稿が見つかりません。削除された可能性があります。");
			request.getRequestDispatcher("/WEB-INF/pages/board-view.jsp")
					.forward(request, response);
			return;
		}

		// 수정/삭제 버튼 노출 여부
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(board.getEmployee_id()));

		request.setAttribute("board", board);
		request.setAttribute("commentList", dao.selectComments(boardNo));
		request.setAttribute("canEdit", canEdit);
		request.setAttribute("loginId", loginId);

		request.getRequestDispatcher("/WEB-INF/pages/board-view.jsp")
				.forward(request, response);
	}
}
