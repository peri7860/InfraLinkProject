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
 * 게시글 등록.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   board-write.jsp 는 폼만 있고 저장 로직이 없었다.
 *   board.js 가 submit 을 preventDefault() 로 막고
 *   alert("2단계에서 구현 예정") 만 띄우는 상태였다.
 *   → JSP/JS 를 고치고 이 서비스로 실제 저장한다.
 * </pre>
 */
public class BoardInsertService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/board-write.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String employeeId = RequestUtil.getLoginId(request);
		if (employeeId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String title = RequestUtil.getParam(request, "title");
		String content = RequestUtil.getParam(request, "content");
		String category = RequestUtil.getParam(request, "category", "自由");

		// -------------------------------------------------------------
		// 입력값 검증 (JS 검증은 우회될 수 있으므로 서버에서도 반드시 확인)
		// -------------------------------------------------------------
		if (title == null || content == null) {
			fail(request, response, "タイトルと内容をすべて入力してください。");
			return;
		}

		// -------------------------------------------------------------
		// 첨부파일
		// -------------------------------------------------------------
		FileUtil.UploadResult upload = null;
		try {
			Part filePart = request.getPart("file_path");
			upload = FileUtil.save(filePart);

		} catch (FileUtil.UploadException e) {
			fail(request, response, e.getMessage());
			return;
		} catch (IllegalStateException e) {
			fail(request, response, "添付ファイルのサイズが大きすぎます。");
			return;
		} catch (ServletException e) {
			System.out.println("[BoardInsertService] 첨부파일 없음 (multipart 아님)");
		}

		// -------------------------------------------------------------
		// 저장
		// -------------------------------------------------------------
		BoardDTO dto = new BoardDTO();
		dto.setEmployee_id(employeeId);
		dto.setCategory(category);
		dto.setTitle(title);
		dto.setContent(content);

		if (upload != null) {
			dto.setFile_path(upload.savedName);
			dto.setFile_name(upload.originalName);
		}

		int result = new BoardDAO().insertBoard(dto);

		if (result <= 0) {
			if (upload != null) {
				FileUtil.delete(upload.savedName);
			}
			fail(request, response, "投稿の登録に失敗しました。");
			return;
		}

		System.out.println("[BoardInsertService] 게시글 등록 완료 : " + title);

		RequestUtil.redirect(request, response, "/pages/board.do?result=created");
	}

	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("editMode", false);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
