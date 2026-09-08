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
 * 공지사항 삭제.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   NoticeDAO.deleteNotice() 는 있었지만 호출하는 곳이 없었고
 *   화면에도 삭제 버튼이 동작하지 않았다.
 *
 * 처리 순서가 중요하다
 *   1) 권한 확인
 *   2) DB 레코드 삭제
 *   3) 그 다음에 실제 파일 삭제
 *   파일을 먼저 지우면 DB 삭제가 실패했을 때
 *   "글은 있는데 첨부만 사라진" 상태가 된다.
 * </pre>
 */
public class NoticeDeleteService implements Command {

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
		NoticeDTO notice = dao.selectNoticeByNo(noticeNo);

		if (notice == null) {
			RequestUtil.redirect(request, response, "/pages/notice.do?result=not_found");
			return;
		}

		// -------------------------------------------------------------
		// 1. 권한 확인 (작성자 본인 또는 관리자)
		// -------------------------------------------------------------
		String loginId = RequestUtil.getLoginId(request);
		boolean canDelete = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(notice.getEmployee_id()));

		if (!canDelete) {
			RequestUtil.redirect(request, response,
					"/pages/notice-view.do?no=" + noticeNo + "&result=no_permission");
			return;
		}

		// -------------------------------------------------------------
		// 2. DB 삭제 → 3. 파일 삭제 (순서 주의)
		// -------------------------------------------------------------
		int result = dao.deleteNotice(noticeNo);

		if (result > 0) {

			if (notice.getFile_path() != null) {
				FileUtil.delete(notice.getFile_path());
			}
			System.out.println("[NoticeDeleteService] 공지 삭제 완료 : " + noticeNo);

			RequestUtil.redirect(request, response, "/pages/notice.do?result=deleted");

		} else {
			RequestUtil.redirect(request, response,
					"/pages/notice-view.do?no=" + noticeNo + "&result=fail");
		}
	}
}
