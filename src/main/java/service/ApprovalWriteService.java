package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ApprovalDAO;
import model.ApprovalDTO;
import model.EmployeeDAO;
import model.NotificationDAO;
import util.RequestUtil;

/**
 * 결재 문서 기안 (작성 폼 + 등록).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   approval-write.jsp 는 폼만 있고 저장 로직이 전혀 없었다.
 *   (버튼도 type="button" 이라 아무 동작 안 함)
 *
 * GET  → 작성 폼 표시 (결재자 선택용 사원 목록 포함)
 * POST → 문서 등록 후 결재자에게 알림 발송
 * </pre>
 */
public class ApprovalWriteService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/approval-write.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		// -------------------------------------------------------------
		// GET : 작성 폼 표시
		// -------------------------------------------------------------
		if (!"POST".equalsIgnoreCase(request.getMethod())) {
			showForm(request, response);
			return;
		}

		// -------------------------------------------------------------
		// POST : 등록
		// -------------------------------------------------------------
		String docType = RequestUtil.getParam(request, "doc_type");
		String docTitle = RequestUtil.getParam(request, "doc_title");
		String content = RequestUtil.getParam(request, "content");
		String approverId = RequestUtil.getParam(request, "approval_id");

		if (docType == null || docTitle == null) {
			fail(request, response, "文書種類とタイトルは必須です。");
			return;
		}
		if (approverId == null) {
			fail(request, response, "決裁者を選択してください。");
			return;
		}

		// 자기 자신을 결재자로 지정할 수 없다.
		if (approverId.equals(loginId)) {
			fail(request, response, "自分自身を決裁者に指定することはできません。");
			return;
		}

		// 결재자가 실제 존재하는 사원인지 확인 (폼 조작 방어 + FK 위반 방지)
		if (new EmployeeDAO().getEmployeeById(approverId) == null) {
			fail(request, response, "存在しない決裁者です。");
			return;
		}

		ApprovalDTO dto = new ApprovalDTO();
		dto.setEmployee_id(loginId);
		dto.setApproval_id(approverId);
		dto.setDoc_type(docType);
		dto.setDoc_title(docTitle);
		dto.setContent(content);

		int result = new ApprovalDAO().insertApproval(dto);

		if (result <= 0) {
			fail(request, response, "決裁文書の起案に失敗しました。");
			return;
		}

		System.out.println("[ApprovalWriteService] 결재 기안 완료 : " + docTitle);

		// 결재자에게 알림 발송
		new NotificationDAO().insert(approverId, "APPROVAL",
				"決裁依頼 : " + docTitle, "/pages/approval.do?tab=receive");

		RequestUtil.redirect(request, response, "/pages/approval.do?tab=draft&result=created");
	}

	/** 작성 폼 표시 (결재자 후보 목록을 함께 넘긴다) */
	private void showForm(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 재직 중인 사원 전체를 결재자 후보로 제공한다.
		request.setAttribute("employeeList",
				new EmployeeDAO().searchEmployees(null, null, "在職", 1, 500));

		request.getRequestDispatcher(FORM_PAGE).forward(request, response);
	}

	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("employeeList",
				new EmployeeDAO().searchEmployees(null, null, "在職", 1, 500));
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
