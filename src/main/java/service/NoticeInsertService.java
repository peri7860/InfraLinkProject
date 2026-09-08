package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.NoticeDAO;
import model.NoticeDTO;
import model.NotificationDAO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 공지사항 등록.
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제 (이 서비스는 사실상 실행 자체가 불가능했다)
 *  1) 컨트롤러(pages.java)에 이 서비스로 가는 라우트가 아예 없었다.
 *     → /pages/noticeWrite.do 라우트를 추가했다.
 *  2) notice-write.jsp 폼에 action / method="post" /
 *     enctype="multipart/form-data" 가 모두 없었고,
 *     notice.js 가 submit 을 preventDefault() 로 막고 있었다.
 *     → JSP 와 JS 를 고쳐 실제로 전송되게 했다.
 *  3) request.getPart() 를 쓰는데 서블릿에 @MultipartConfig 가 없었다.
 *     → 호출 대상인 PageController 에 @MultipartConfig 를 붙였다.
 *  4) 작성자를 session.getAttribute("employee_id") 로 꺼냈는데
 *     로그인 시 저장하는 키는 "loginUser" 였다.
 *     → 항상 null 이 들어가 FK 위반 또는 작성자 없는 글이 되었다.
 *     → RequestUtil.getLoginId() 로 통일.
 *  5) 업로드 경로가 "C:\\upload2" 하드코딩, 확장자·용량 검증 없음.
 *     → FileUtil(설정 기반 + 화이트리스트 검증)로 이관.
 *  6) 원본 파일명을 저장하지 않아 다운로드하면 UUID 이름으로 받아졌다.
 *     → file_name 컬럼에 원본명을 함께 저장.
 *  7) 저장 후 contextPath + "/notice-write.do" 로 리다이렉트했는데
 *     실제 매핑은 "/pages/*" 라 경로가 틀렸다.
 *     → 목록 화면으로 정상 리다이렉트.
 *  8) 성공/실패 판정이 없었다. (DAO 가 void 였음)
 * </pre>
 */
public class NoticeInsertService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/notice-write.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// -------------------------------------------------------------
		// 1. 작성자 (세션에서)
		// -------------------------------------------------------------
		String employeeId = RequestUtil.getLoginId(request);
		if (employeeId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String title = RequestUtil.getParam(request, "title");
		String content = RequestUtil.getParam(request, "content");
		String category = RequestUtil.getParam(request, "category", "一般");
		String visibility = RequestUtil.getParam(request, "visibility", "ALL");
		String pinYn = request.getParameter("pin_yn") != null ? "Y" : "N";

		// -------------------------------------------------------------
		// 2. 필수값 검증
		// -------------------------------------------------------------
		if (title == null) {
			fail(request, response, "タイトルを入力してください。");
			return;
		}
		if (content == null) {
			fail(request, response, "内容を入力してください。");
			return;
		}

		// -------------------------------------------------------------
		// 3. 첨부파일 처리
		//    getPart 는 multipart 요청이 아니면 예외를 던지므로 감싼다.
		// -------------------------------------------------------------
		FileUtil.UploadResult upload = null;
		try {
			Part filePart = request.getPart("file_path");
			upload = FileUtil.save(filePart);

		} catch (FileUtil.UploadException e) {
			// 확장자/용량 위반 → 사용자에게 이유를 그대로 보여준다.
			fail(request, response, e.getMessage());
			return;

		} catch (IllegalStateException e) {
			// 업로드 최대 크기 초과 등 컨테이너 레벨 오류
			fail(request, response, "添付ファイルのサイズが大きすぎます。");
			return;

		} catch (ServletException e) {
			// multipart 요청이 아닌 경우 → 첨부 없이 계속 진행
			System.out.println("[NoticeInsertService] 첨부파일 없음 (multipart 아님)");
		}

		// -------------------------------------------------------------
		// 4. 저장
		// -------------------------------------------------------------
		NoticeDTO dto = new NoticeDTO();
		dto.setEmployee_id(employeeId);
		dto.setCategory(category);
		dto.setVisibility(visibility);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setPin_yn(pinYn);

		if (upload != null) {
			dto.setFile_path(upload.savedName);
			dto.setFile_name(upload.originalName);
		}

		int result = new NoticeDAO().insertNotice(dto);

		if (result <= 0) {
			// 저장에 실패했다면 이미 올라간 파일은 지워서 쓰레기를 남기지 않는다.
			if (upload != null) {
				FileUtil.delete(upload.savedName);
			}
			fail(request, response, "お知らせの登録に失敗しました。");
			return;
		}

		System.out.println("[NoticeInsertService] 공지 등록 완료 : " + title);

		// -------------------------------------------------------------
		// 5. 전 사원에게 알림 발송 (본인 제외)
		// -------------------------------------------------------------
		new NotificationDAO().insertToAll(
				"NOTICE", "新しいお知らせ : " + title, "/pages/notice.do", employeeId);

		// PRG 패턴 : 새로고침 시 중복 등록되지 않도록 리다이렉트
		RequestUtil.redirect(request, response, "/pages/notice.do?result=created");
	}

	/** 실패 시 입력 폼으로 되돌린다 */
	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("editMode", false);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());
		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
