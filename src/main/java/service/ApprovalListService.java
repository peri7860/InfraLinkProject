package service;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.ApprovalDTO;
import util.Paging;
import util.RequestUtil;

/**
 * 전자결재 문서함.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   approval.jsp 의 결재 목록이 전부 하드코딩이었고
 *   테이블·DAO·서비스가 모두 없었다. → 새로 구현.
 *
 * 문서함 구분 (tab 파라미터)
 *   draft   : 내가 기안한 문서
 *   receive : 내가 결재해야 할 문서 (기본값)
 * </pre>
 */
public class ApprovalListService implements Command {

	private static final int PAGE_SIZE = 10;

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String tab = RequestUtil.getParam(request, "tab", "receive");
		String status = RequestUtil.getParam(request, "status");
		int page = Paging.parsePage(request.getParameter("page"));

		// 탭에 따라 검색 조건을 바꾼다.
		String employeeId = "draft".equals(tab) ? loginId : null; // 기안자 조건
		String approverId = "draft".equals(tab) ? null : loginId; // 결재자 조건

		ApprovalDAO dao = new ApprovalDAO();

		int totalCount = dao.countApproval(employeeId, approverId, status);
		Paging paging = new Paging(page, totalCount, PAGE_SIZE, Paging.DEFAULT_BLOCK_SIZE);

		List<ApprovalDTO> approvalList = dao.selectApprovalPage(
				employeeId, approverId, status, paging.getStartRow(), paging.getEndRow());

		request.setAttribute("approvalList", approvalList);
		request.setAttribute("paging", paging);
		request.setAttribute("tab", tab);
		request.setAttribute("status", status);

		// 상단 요약 뱃지용 건수
		request.setAttribute("waitingCount",
				dao.countApproval(null, loginId, ApprovalDAO.STATUS_WAITING));
		request.setAttribute("draftCount",
				dao.countApproval(loginId, null, null));

		request.getRequestDispatcher("/WEB-INF/pages/approval.jsp")
				.forward(request, response);
	}
}
