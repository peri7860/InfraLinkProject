package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BoardDAO;
import model.CommentDTO;
import util.RequestUtil;

/**
 * 게시판 댓글 등록 / 삭제.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-view.jsp 에 댓글 UI 는 있었지만
 *   board.js 가 alert("2단계에서 구현 예정") 만 띄우고 끝났다.
 *   → board_comment 테이블과 함께 실제 동작하도록 구현했다.
 *
 * 등록과 삭제를 한 클래스에서 처리하는 이유
 *   두 동작 모두 "댓글"이라는 같은 대상에 대한 짧은 처리라
 *   클래스를 나누면 오히려 찾기 어려워진다.
 *   mode 파라미터(add / delete)로 구분한다.
 *
 * 권한
 *   삭제는 DAO 의 WHERE 절에 employee_id 를 함께 넣어
 *   본인 댓글만 지워지도록 DB 레벨에서 보장한다.
 * </pre>
 */
public class CommentService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		int boardNo = RequestUtil.getIntParam(request, "no", 0);
		String mode = RequestUtil.getParam(request, "mode", "add");

		if (boardNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/board.do");
			return;
		}

		BoardDAO dao = new BoardDAO();

		if ("delete".equals(mode)) {
			// -------------------------------------------------------------
			// 댓글 삭제
			// -------------------------------------------------------------
			int commentNo = RequestUtil.getIntParam(request, "comment_no", 0);

			if (commentNo > 0) {
				// 본인 댓글만 삭제된다 (DAO 의 WHERE 에 employee_id 포함)
				int result = dao.deleteComment(commentNo, loginId);
				System.out.println("[CommentService] 댓글 삭제 : " + commentNo
						+ " (결과 " + result + ")");
			}

		} else {
			// -------------------------------------------------------------
			// 댓글 등록
			// -------------------------------------------------------------
			String content = RequestUtil.getParam(request, "content");

			if (content == null) {
				RequestUtil.redirect(request, response,
						"/pages/board-view.do?no=" + boardNo + "&result=empty_comment");
				return;
			}

			// 컬럼 길이(2000자)를 넘으면 DB 에서 예외가 나므로 미리 자른다.
			if (content.length() > 2000) {
				content = content.substring(0, 2000);
			}

			CommentDTO dto = new CommentDTO();
			dto.setBoard_no(boardNo);
			dto.setEmployee_id(loginId);
			dto.setContent(content);

			dao.insertComment(dto);
		}

		// 어느 쪽이든 원래 보던 글로 돌아간다.
		RequestUtil.redirect(request, response, "/pages/board-view.do?no=" + boardNo);
	}
}
