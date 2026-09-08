package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BoardDAO;
import model.BoardDTO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 게시글 작성 / 수정 폼 화면.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-write.jsp 는 작성 폼만 있고 수정 기능이 없었다.
 *   → ?no= 가 있으면 기존 글을 읽어 수정 모드로 띄운다.
 * </pre>
 */
public class BoardWriteFormService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int boardNo = RequestUtil.getIntParam(request, "no", 0);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());

		// 신규 작성 모드
		if (boardNo <= 0) {
			request.setAttribute("editMode", false);
			request.getRequestDispatcher("/WEB-INF/pages/board-write.jsp")
					.forward(request, response);
			return;
		}

		// 수정 모드
		BoardDTO board = new BoardDAO().selectBoardByNo(boardNo);

		if (board == null) {
			RequestUtil.redirect(request, response, "/pages/board.do?result=not_found");
			return;
		}

		// 작성자 본인 또는 관리자만 수정 화면을 열 수 있다.
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(board.getEmployee_id()));

		if (!canEdit) {
			RequestUtil.redirect(request, response,
					"/pages/board-view.do?no=" + boardNo + "&result=no_permission");
			return;
		}

		request.setAttribute("board", board);
		request.setAttribute("editMode", true);

		request.getRequestDispatcher("/WEB-INF/pages/board-write.jsp")
				.forward(request, response);
	}
}
