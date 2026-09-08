package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.ApprovalDTO;
import model.NotificationDAO;
import util.RequestUtil;

/**
 * 결재 처리 (승인 / 반려 / 회수).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   승인·반려 버튼이 화면에만 있고 처리 로직이 전혀 없었다.
 *
 * 권한과 중복 처리 방어
 *   DAO 의 UPDATE 문 WHERE 절에
 *     approval_id = ? AND status = '待機'
 *   를 넣어두었기 때문에,
 *     - 지정된 결재자가 아니면 → 0건 (처리 안 됨)
 *     - 이미 처리된 문서면    → 0건 (중복 클릭 방어)
 *   가 DB 레벨에서 보장된다. 여기서는 결과만 보고 안내하면 된다.
 * </pre>
 */
public class ApprovalProcessService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		int approvalNo = RequestUtil.getIntParam(request, "no", 0);
		String action = RequestUtil.getParam(request, "action"); // approve / reject / withdraw
		String comment = RequestUtil.getParam(request, "comment", "");

		if (approvalNo <= 0 || action == null) {
			RequestUtil.redirect(request, response, "/pages/approval.do?result=bad_request");
			return;
		}

		ApprovalDAO dao = new ApprovalDAO();

		// 알림을 보내려면 기안자를 알아야 하므로 미리 읽어 둔다.
		ApprovalDTO doc = dao.selectByNo(approvalNo);
		if (doc == null) {
			RequestUtil.redirect(request, response, "/pages/approval.do?result=not_found");
			return;
		}

		int result;
		String resultKey;

		switch (action) {

		case "approve":
			result = dao.processApproval(approvalNo, loginId, ApprovalDAO.STATUS_APPROVED, comment);
			resultKey = "approved";
			break;

		case "reject":
			// 반려는 사유를 반드시 남기게 한다.
			if (comment.isEmpty()) {
				RequestUtil.redirect(request, response,
						"/pages/approval-view.do?no=" + approvalNo + "&result=need_comment");
				return;
			}
			result = dao.processApproval(approvalNo, loginId, ApprovalDAO.STATUS_REJECTED, comment);
			resultKey = "rejected";
			break;

		case "withdraw":
			// 기안자 본인의 회수
			result = dao.withdraw(approvalNo, loginId);
			resultKey = "withdrawn";
			break;

		default:
			RequestUtil.redirect(request, response, "/pages/approval.do?result=bad_request");
			return;
		}

		// -------------------------------------------------------------
		// 처리 결과 판정
		//  0건 = 권한이 없거나 이미 처리된 문서
		// -------------------------------------------------------------
		if (result <= 0) {
			RequestUtil.redirect(request, response,
					"/pages/approval-view.do?no=" + approvalNo + "&result=already_processed");
			return;
		}

		System.out.println("[ApprovalProcessService] " + action + " 처리 : " + approvalNo);

		// -------------------------------------------------------------
		// 기안자에게 결과 알림 (회수는 본인이 한 것이므로 제외)
		// -------------------------------------------------------------
		if (!"withdraw".equals(action)) {

			String label = "approve".equals(action) ? "承認されました" : "却下されました";

			new NotificationDAO().insert(doc.getEmployee_id(), "APPROVAL",
					doc.getDoc_title() + " が" + label,
					"/pages/approval-view.do?no=" + approvalNo);
		}

		RequestUtil.redirect(request, response,
				"/pages/approval-view.do?no=" + approvalNo + "&result=" + resultKey);
	}
}
