package service;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AttendanceDAO;
import model.EmployeeDAO;
import util.AppConfig;
import util.DBManager;
import util.FileUtil;

/**
 * 시스템 현황 (관리자).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존 문제
 *   pages.java 에 "/system-status.do" 라우트는 있는데
 *   가리키는 system-status.jsp 파일이 <b>아예 없었다.</b>
 *   → 이 경로로 들어가면 그대로 500 에러가 났다.
 *   화면(system-status.jsp)과 함께 새로 만들었다.
 *
 * 보여주는 것
 *   - DB 접속 가능 여부와 제품/버전
 *   - 업로드 폴더 경로와 쓰기 가능 여부
 *   - 서버(톰캣/JVM) 정보와 메모리 사용량
 *   - 간단한 사용 현황 (사원 수, 오늘 출근자)
 *
 * 비밀번호 같은 민감한 설정값은 절대 화면으로 넘기지 않는다.
 * (DB URL 은 관리자 화면이므로 표시하되 계정/비밀번호는 제외)
 * </pre>
 */
public class SystemStatusService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// -------------------------------------------------------------
		// 1. DB 상태
		// -------------------------------------------------------------
		boolean dbOk = false;
		String dbProduct = "-";
		String dbError = null;

		try (Connection conn = DBManager.getConnection()) {

			DatabaseMetaData meta = conn.getMetaData();
			dbProduct = meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion();
			dbOk = true;

		} catch (Exception e) {
			// 관리자 전용 화면이므로 실패 사유를 그대로 보여준다.
			dbError = e.getClass().getSimpleName() + " : " + e.getMessage();
		}

		request.setAttribute("dbOk", dbOk);
		request.setAttribute("dbProduct", dbProduct);
		request.setAttribute("dbError", dbError);
		request.setAttribute("dbUrl", AppConfig.get("db.url", "(미설정)"));

		// -------------------------------------------------------------
		// 2. 업로드 폴더 상태
		// -------------------------------------------------------------
		File uploadDir = FileUtil.getUploadDir();
		String[] files = uploadDir.exists() ? uploadDir.list() : null;

		request.setAttribute("uploadPath", uploadDir.getAbsolutePath());
		request.setAttribute("uploadOk", uploadDir.exists() && uploadDir.canWrite());
		request.setAttribute("uploadCount", files == null ? 0 : files.length);
		request.setAttribute("allowedExt", FileUtil.getAllowedExtensionText());
		request.setAttribute("maxUploadMb",
				AppConfig.getInt("upload.maxSize", 10 * 1024 * 1024) / 1024 / 1024);

		// -------------------------------------------------------------
		// 3. 서버 / JVM 정보
		//    ServletContext 는 요청에서 바로 얻는다 (Servlet 3.0+).
		//    서비스는 서블릿이 아니므로 getServletContext() 를 쓸 수 없다.
		// -------------------------------------------------------------
		ServletContext context = request.getServletContext();
		Runtime runtime = Runtime.getRuntime();

		long usedMb = (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024;
		long maxMb = runtime.maxMemory() / 1024 / 1024;

		request.setAttribute("serverInfo", context.getServerInfo());
		request.setAttribute("servletVersion",
				context.getMajorVersion() + "." + context.getMinorVersion());
		request.setAttribute("contextPath", context.getContextPath());
		request.setAttribute("javaVersion", System.getProperty("java.version"));
		request.setAttribute("osName",
				System.getProperty("os.name") + " " + System.getProperty("os.arch"));
		request.setAttribute("memUsedMb", usedMb);
		request.setAttribute("memMaxMb", maxMb);
		request.setAttribute("memPercent", maxMb > 0 ? (int) (usedMb * 100 / maxMb) : 0);

		// -------------------------------------------------------------
		// 4. 사용 현황 (DB 가 살아 있을 때만 조회)
		// -------------------------------------------------------------
		if (dbOk) {
			EmployeeDAO employeeDAO = new EmployeeDAO();
			request.setAttribute("totalEmployee", employeeDAO.countByStatus(null));
			request.setAttribute("activeEmployee", employeeDAO.countByStatus("在職"));
			request.setAttribute("todayCheckIn", new AttendanceDAO().countTodayCheckIn());
		}

		request.getRequestDispatcher("/WEB-INF/pages/system-status.jsp")
				.forward(request, response);
	}
}
