package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.ApprovalDTO;
import util.RequestUtil;

/**
 * 결재 문서 상세 조회.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   approval-view.jsp 가 특정 문서 내용으로 하드코딩되어 있었다.
 *
 * 열람 권한
 *   기안자 본인 / 지정된 결재자 / 관리자만 볼 수 있다.
 *   (결재 문서에는 급여·휴가 같은 민감한 내용이 들어가므로
 *    URL 로 문서번호만 바꿔서 남의 문서를 보는 일이 없어야 한다)
 * </pre>
 */
public class ApprovalViewService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int approvalNo = RequestUtil.getIntParam(request, "no", 0);
		String loginId = RequestUtil.getLoginId(request);

		if (approvalNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/approval.do");
			return;
		}

		ApprovalDTO doc = new ApprovalDAO().selectByNo(approvalNo);

		if (doc == null) {
			request.setAttribute("errorMessage", "決裁文書が見つかりません。");
			request.getRequestDispatcher("/WEB-INF/pages/approval-view.jsp")
					.forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// 열람 권한 확인
		// -------------------------------------------------------------
		boolean isDrafter = loginId != null && loginId.equals(doc.getEmployee_id());
		boolean isApprover = loginId != null && loginId.equals(doc.getApproval_id());

		if (!isDrafter && !isApprover && !RequestUtil.isAdmin(request)) {
			RequestUtil.redirect(request, response, "/pages/approval.do?result=no_permission");
			return;
		}

		request.setAttribute("doc", doc);

		// 결재(승인/반려) 버튼은 대기 상태의 지정 결재자에게만 보여준다.
		request.setAttribute("canProcess", isApprover && doc.isWaiting());
		// 회수 버튼은 대기 상태의 기안자에게만
		request.setAttribute("canWithdraw", isDrafter && doc.isWaiting());

		request.getRequestDispatcher("/WEB-INF/pages/approval-view.jsp")
				.forward(request, response);
	}
}
