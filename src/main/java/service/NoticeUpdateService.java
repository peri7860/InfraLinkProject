package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.NoticeDAO;
import model.NoticeDTO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 공지사항 수정.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   NoticeDAO 에 updateNotice() 는 있었지만 호출하는 서비스도,
 *   수정 화면도 없었다. (게다가 그 DAO 메서드는 if/else 가 뒤바뀐
 *   버그 상태였다 → NoticeDAO 에서 수정 완료)
 *
 * 첨부파일 처리 규칙
 *   - 새 파일을 올리면 → 기존 파일을 지우고 새 파일로 교체
 *   - 아무것도 올리지 않으면 → 기존 파일 그대로 유지
 *   - "첨부 삭제" 체크 → 기존 파일 삭제 후 첨부 없음 상태로
 * </pre>
 */
public class NoticeUpdateService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int noticeNo = RequestUtil.getIntParam(request, "no", 0);

		if (noticeNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/notice.do?result=no_target");
			return;
		}

		NoticeDAO dao = new NoticeDAO();
		NoticeDTO origin = dao.selectNoticeByNo(noticeNo);

		if (origin == null) {
			RequestUtil.redirect(request, response, "/pages/notice.do?result=not_found");
			return;
		}

		// -------------------------------------------------------------
		// 1. 권한 확인 (작성자 본인 또는 관리자)
		//    화면에서 버튼을 숨기는 것만으로는 부족하다.
		//    POST 를 직접 보내는 경우까지 서버에서 막아야 한다.
		// -------------------------------------------------------------
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(origin.getEmployee_id()));

		if (!canEdit) {
			RequestUtil.redirect(request, response,
					"/pages/notice-view.do?no=" + noticeNo + "&result=no_permission");
			return;
		}

		String title = RequestUtil.getParam(request, "title");
		String content = RequestUtil.getParam(request, "content");
		String category = RequestUtil.getParam(request, "category", origin.getCategory());
		String visibility = RequestUtil.getParam(request, "visibility", origin.getVisibility());
		String pinYn = request.getParameter("pin_yn") != null ? "Y" : "N";
		boolean removeFile = request.getParameter("remove_file") != null;

		if (title == null || content == null) {
			fail(request, response, origin, "タイトルと内容は必須です。");
			return;
		}

		// -------------------------------------------------------------
		// 2. 첨부파일 처리
		// -------------------------------------------------------------
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
			System.out.println("[NoticeUpdateService] 첨부파일 없음 (multipart 아님)");
		}

		// -------------------------------------------------------------
		// 3. 수정
		// -------------------------------------------------------------
		NoticeDTO dto = new NoticeDTO();
		dto.setNotice_no(noticeNo);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setCategory(category);
		dto.setVisibility(visibility);
		dto.setPin_yn(pinYn);

		if (upload != null) {
			dto.setFile_path(upload.savedName);
			dto.setFile_name(upload.originalName);
		}
		// file_path 를 비워두면 DAO 가 첨부 컬럼을 건드리지 않는다(기존 유지).

		int result = dao.updateNotice(dto);

		if (result <= 0) {
			if (upload != null) {
				FileUtil.delete(upload.savedName);
			}
			fail(request, response, origin, "お知らせの更新に失敗しました。");
			return;
		}

		// -------------------------------------------------------------
		// 4. 기존 첨부파일 정리
		//    (새 파일로 교체했거나 삭제를 요청한 경우)
		// -------------------------------------------------------------
		if ((upload != null || removeFile) && origin.getFile_path() != null) {
			FileUtil.delete(origin.getFile_path());
		}

		System.out.println("[NoticeUpdateService] 공지 수정 완료 : " + noticeNo);

		RequestUtil.redirect(request, response,
				"/pages/notice-view.do?no=" + noticeNo + "&result=updated");
	}

	private void fail(HttpServletRequest request, HttpServletResponse response,
			NoticeDTO origin, String message) throws ServletException, IOException {

		request.setAttribute("notice", origin);
		request.setAttribute("editMode", true);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());
		RequestUtil.forwardWithError(request, response, "/WEB-INF/pages/notice-write.jsp", message);
	}
}
