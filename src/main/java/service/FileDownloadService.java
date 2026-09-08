package service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BoardDAO;
import model.BoardDTO;
import model.NoticeDAO;
import model.NoticeDTO;
import util.FileUtil;
import util.RequestUtil;

/**
 * 첨부파일 다운로드.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   업로드는 (동작하지 않는 채로) 코드가 있었지만
 *   <b>다운로드 기능은 아예 없었다.</b>
 *   게다가 저장 경로가 "C:\\upload2" 로 웹 경로 밖이라
 *   (주의: 주석 안에서도 역슬래시+u 는 유니코드 이스케이프로 해석되므로
 *    반드시 이스케이프해서 적어야 컴파일 에러가 나지 않는다)
 *   링크로 접근할 방법 자체가 없었다.
 *
 * 보안상 중요한 점
 *  1) 파일명을 요청 파라미터로 직접 받지 않는다.
 *     ?file=../../conf/server.xml 같은 경로 조작을 원천 차단하기 위해
 *     "글 번호"만 받아 DB 에서 실제 파일명을 꺼낸다.
 *  2) 로그인한 사용자만 다운로드할 수 있다. (LoginFilter 가 보장)
 *  3) 한글/일본어 파일명은 브라우저마다 처리가 달라
 *     RFC 5987 방식(filename*=UTF-8'')으로 내려준다.
 * </pre>
 */
public class FileDownloadService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// type=notice | board , no=글 번호
		String type = RequestUtil.getParam(request, "type", "notice");
		int no = RequestUtil.getIntParam(request, "no", 0);

		if (no <= 0) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
			return;
		}

		// -------------------------------------------------------------
		// 1. DB 에서 실제 저장 파일명 / 원본 파일명을 꺼낸다.
		//    (파라미터로 파일명을 받지 않는 것이 핵심)
		// -------------------------------------------------------------
		String savedName = null;
		String originalName = null;

		if ("board".equals(type)) {
			BoardDTO board = new BoardDAO().selectBoardByNo(no);
			if (board != null) {
				savedName = board.getFile_path();
				originalName = board.getDisplayFileName();
			}
		} else {
			NoticeDTO notice = new NoticeDAO().selectNoticeByNo(no);
			if (notice != null) {
				savedName = notice.getFile_path();
				originalName = notice.getDisplayFileName();
			}
		}

		if (savedName == null || savedName.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "添付ファイルがありません。");
			return;
		}

		// -------------------------------------------------------------
		// 2. 실제 파일 확인
		// -------------------------------------------------------------
		File file = FileUtil.resolve(savedName);

		if (file == null) {
			// DB 에는 있지만 디스크에서 사라진 경우
			System.err.println("[FileDownloadService] 파일 없음 : " + savedName);
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "ファイルが見つかりません。");
			return;
		}

		// -------------------------------------------------------------
		// 3. 응답 헤더
		// -------------------------------------------------------------
		if (originalName == null || originalName.trim().isEmpty()) {
			originalName = file.getName();
		}

		// 브라우저가 파일을 열지 않고 무조건 저장하도록 한다.
		response.setContentType("application/octet-stream");
		response.setContentLengthLong(file.length());

		String encoded = URLEncoder.encode(originalName, StandardCharsets.UTF_8.name())
				.replace("+", "%20"); // 공백이 '+' 로 바뀌는 것을 되돌린다

		response.setHeader("Content-Disposition",
				"attachment; filename=\"" + encoded + "\"; filename*=UTF-8''" + encoded);

		// -------------------------------------------------------------
		// 4. 파일 전송
		// -------------------------------------------------------------
		try (InputStream in = new FileInputStream(file);
				OutputStream out = response.getOutputStream()) {

			byte[] buffer = new byte[8192];
			int length;

			while ((length = in.read(buffer)) != -1) {
				out.write(buffer, 0, length);
			}
			out.flush();

		} catch (IOException e) {
			// 사용자가 다운로드를 취소하면 여기로 온다. 오류가 아니므로 로그만.
			System.out.println("[FileDownloadService] 전송 중단 : " + e.getMessage());
		}
	}
}
