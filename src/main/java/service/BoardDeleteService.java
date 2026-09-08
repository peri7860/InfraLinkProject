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
 * 게시글 삭제.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   게시판에 삭제 기능이 없었다.
 *   댓글은 board_comment 의 FK 가 ON DELETE CASCADE 이므로
 *   게시글을 지우면 함께 삭제된다.
 * </pre>
 */
public class BoardDeleteService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int boardNo = RequestUtil.getIntParam(request, "no", 0);

		if (boardNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/board.do?result=no_target");
			return;
		}

		BoardDAO dao = new BoardDAO();
		BoardDTO board = dao.selectBoardByNo(boardNo);

		if (board == null) {
			RequestUtil.redirect(request, response, "/pages/board.do?result=not_found");
			return;
		}

		// 권한 확인
		String loginId = RequestUtil.getLoginId(request);
		boolean canDelete = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(board.getEmployee_id()));

		if (!canDelete) {
			RequestUtil.redirect(request, response,
					"/pages/board-view.do?no=" + boardNo + "&result=no_permission");
			return;
		}

		// DB 삭제 후 파일 삭제 (순서 주의)
		int result = dao.deleteBoard(boardNo);

		if (result > 0) {
			if (board.getFile_path() != null) {
				FileUtil.delete(board.getFile_path());
			}
			System.out.println("[BoardDeleteService] 게시글 삭제 완료 : " + boardNo);
			RequestUtil.redirect(request, response, "/pages/board.do?result=deleted");

		} else {
			RequestUtil.redirect(request, response,
					"/pages/board-view.do?no=" + boardNo + "&result=fail");
		}
	}
}
