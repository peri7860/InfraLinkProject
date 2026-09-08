package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.NoticeDAO;
import model.NoticeDTO;
import util.RequestUtil;

/**
 * 공지사항 상세 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *  1) notice-view.jsp 가 특정 공지 내용으로 하드코딩되어 있었다.
 *  2) 목록에서 상세로 가는 링크 15곳이 전부 파라미터 없이
 *     ".../pages/notice-view.do" 였다.
 *     → 어떤 글인지 알 수 없는 구조였다. (링크에 ?no= 를 붙이도록 수정)
 *  3) NoticeDAO.selectNoticeByNo() 가 content 를 SELECT 하지 않아
 *     본문을 가져올 수도 없었다. (DAO 수정 완료)
 *
 * 조회수 중복 증가 방지
 *   새로고침할 때마다 조회수가 오르는 것을 막기 위해
 *   세션에 "읽은 공지 번호"를 기록해 두고 한 번만 증가시킨다.
 * </pre>
 */
public class NoticeViewService implements Command {

	/** 세션에 읽은 글 번호를 기록할 때 쓰는 키 접두어 */
	private static final String READ_FLAG_PREFIX = "noticeRead_";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int noticeNo = RequestUtil.getIntParam(request, "no", 0);

		// -------------------------------------------------------------
		// 1. 파라미터 검증
		// -------------------------------------------------------------
		if (noticeNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/notice.do");
			return;
		}

		NoticeDAO dao = new NoticeDAO();

		// -------------------------------------------------------------
		// 2. 조회수 증가 (같은 세션에서 처음 읽는 경우만)
		// -------------------------------------------------------------
		HttpSession session = request.getSession();
		String readFlag = READ_FLAG_PREFIX + noticeNo;

		if (session.getAttribute(readFlag) == null) {
			dao.readCount(noticeNo);
			session.setAttribute(readFlag, Boolean.TRUE);
		}

		// -------------------------------------------------------------
		// 3. 본문 조회 (조회수 증가 후에 읽어야 최신 값이 나온다)
		// -------------------------------------------------------------
		NoticeDTO notice = dao.selectNoticeByNo(noticeNo);

		if (notice == null) {
			request.setAttribute("errorMessage", "お知らせが見つかりません。削除された可能性があります。");
			request.getRequestDispatcher("/WEB-INF/pages/notice-view.jsp")
					.forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 4. 이전 글 / 다음 글
		// -------------------------------------------------------------
		request.setAttribute("notice", notice);
		request.setAttribute("prevNotice", dao.preBno(noticeNo));
		request.setAttribute("nextNotice", dao.nextBno(noticeNo));

		// 수정/삭제 버튼 노출 여부 : 작성자 본인 또는 관리자
		String loginId = RequestUtil.getLoginId(request);
		boolean canEdit = RequestUtil.isAdmin(request)
				|| (loginId != null && loginId.equals(notice.getEmployee_id()));
		request.setAttribute("canEdit", canEdit);

		request.getRequestDispatcher("/WEB-INF/pages/notice-view.jsp")
				.forward(request, response);
	}
}
