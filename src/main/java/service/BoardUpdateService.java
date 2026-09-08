package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.BoardDAO;
import model.BoardDTO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 게시글 수정.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   게시판에 수정 기능 자체가 없었다.
 *
 * 첨부파일 처리는 공지사항과 동일한 규칙을 따른다.
 *   - 새 파일 업로드 → 기존 파일 삭제 후 교체
 *   - 업로드 없음     → 기존 첨부 유지
 * </pre>
 */
public class BoardUpdateService implements Command {

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
		BoardDTO origin = dao.selectBoardByNo(boardNo);

		if (origin == null) {
			RequestUtil.redirect(request, response, "/pages/board.do?result=not_found");
			return;
		}

		// 권한 확인 (버튼을 숨기는 것만으로는 부족하다)
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(origin.getEmployee_id()));

		if (!canEdit) {
			RequestUtil.redirect(request, response,
					"/pages/board-view.do?no=" + boardNo + "&result=no_permission");
			return;
		}

		String title = RequestUtil.getParam(request, "title");
		String content = RequestUtil.getParam(request, "content");
		String category = RequestUtil.getParam(request, "category", origin.getCategory());
		boolean removeFile = request.getParameter("remove_file") != null;

		if (title == null || content == null) {
			fail(request, response, origin, "タイトルと内容は必須です。");
			return;
		}

		FileUtil.UploadResult upload = null;
		try {
			Part filePart = request.getPart("file_path");
			upload = FileUtil.save(filePart);

		} catch (FileUtil.UploadException e) {
			fail(request, response, origin, e.getMessage());
			return;
		} catch (IllegalStateException e) {
			fail(request, response, origin, "添付ファイルのサイズが大きすぎます。");
			return;
		} catch (ServletException e) {
			System.out.println("[BoardUpdateService] 첨부파일 없음 (multipart 아님)");
		}

		BoardDTO dto = new BoardDTO();
		dto.setBoard_no(boardNo);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setCategory(category);

		if (upload != null) {
			dto.setFile_path(upload.savedName);
			dto.setFile_name(upload.originalName);
		}

		int result = dao.updateBoard(dto);

		if (result <= 0) {
			if (upload != null) {
				FileUtil.delete(upload.savedName);
			}
			fail(request, response, origin, "投稿の更新に失敗しました。");
			return;
		}

		// 교체되었거나 삭제 요청된 기존 파일 정리
		if ((upload != null || removeFile) && origin.getFile_path() != null) {
			FileUtil.delete(origin.getFile_path());
		}

		System.out.println("[BoardUpdateService] 게시글 수정 완료 : " + boardNo);

		RequestUtil.redirect(request, response,
				"/pages/board-view.do?no=" + boardNo + "&result=updated");
	}

	private void fail(HttpServletRequest request, HttpServletResponse response,
			BoardDTO origin, String message) throws ServletException, IOException {

		request.setAttribute("board", origin);
		request.setAttribute("editMode", true);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());
		RequestUtil.forwardWithError(request, response, "/WEB-INF/pages/board-write.jsp", message);
	}
}
