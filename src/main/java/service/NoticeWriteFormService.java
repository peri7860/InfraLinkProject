package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NoticeDAO;
import model.NoticeDTO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 공지 작성 / 수정 폼 화면.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   notice-write.jsp 는 작성 폼만 있고 수정 기능이 없었다.
 *   → ?no= 가 있으면 기존 글을 읽어와 수정 모드로 띄운다.
 *
 * 권한
 *   수정은 작성자 본인 또는 관리자만 가능하다.
 *   (여기서 막지 않으면 URL 로 남의 글 수정 화면을 열 수 있다)
 * </pre>
 */
public class NoticeWriteFormService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int noticeNo = RequestUtil.getIntParam(request, "no", 0);

		// 화면 안내용 : 허용 확장자와 최대 용량
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());

		// -------------------------------------------------------------
		// 신규 작성 모드
		// -------------------------------------------------------------
		if (noticeNo <= 0) {
			request.setAttribute("editMode", false);
			request.getRequestDispatcher("/WEB-INF/pages/notice-write.jsp")
					.forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 수정 모드
		// -------------------------------------------------------------
		NoticeDTO notice = new NoticeDAO().selectNoticeByNo(noticeNo);

		if (notice == null) {
			RequestUtil.redirect(request, response, "/pages/notice.do?result=not_found");
			return;
		}

		// 작성자 본인 또는 관리자만 수정 화면을 열 수 있다.
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(notice.getEmployee_id()));

		if (!canEdit) {
			RequestUtil.redirect(request, response,
					"/pages/notice-view.do?no=" + noticeNo + "&result=no_permission");
			return;
		}

		request.setAttribute("notice", notice);
		request.setAttribute("editMode", true);

		request.getRequestDispatcher("/WEB-INF/pages/notice-write.jsp")
				.forward(request, response);
	}
}
