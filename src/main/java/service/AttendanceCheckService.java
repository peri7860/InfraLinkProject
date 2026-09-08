package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AttendanceDAO;
import util.RequestUtil;

/**
 * 출근 / 퇴근 처리.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   출퇴근 등록 기능이 없었다. (화면의 버튼은 아무 동작도 하지 않았다)
 *
 * 중복 처리 방어
 *   - 출근 : attendance 테이블에 (employee_id, work_date) UNIQUE 제약이 있어
 *            같은 날 두 번 INSERT 하면 ORA-00001 이 난다.
 *            DAO 가 이 에러를 잡아 0 을 반환하므로 "이미 출근함"으로 안내한다.
 *   - 퇴근 : UPDATE 의 WHERE 에 out_time IS NULL 이 있어
 *            이미 퇴근했으면 0건이 된다.
 *   두 경우 모두 버튼 연타로 데이터가 망가지지 않는다.
 * </pre>
 */
public class AttendanceCheckService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		String mode = RequestUtil.getParam(request, "mode", "in");
		AttendanceDAO dao = new AttendanceDAO();

		int result;
		String resultKey;

		if ("out".equals(mode)) {
			// 퇴근
			result = dao.checkOut(loginId);
			resultKey = result > 0 ? "checked_out" : "already_out";

		} else {
			// 출근 (근무 형태는 선택값. 出勤 / 在宅 / 出張 / 休暇)
			String workType = RequestUtil.getParam(request, "work_type", "出勤");

			if (!"出勤".equals(workType) && !"在宅".equals(workType)
					&& !"出張".equals(workType) && !"休暇".equals(workType)) {
				workType = "出勤";
			}

			result = dao.checkIn(loginId, workType);
			resultKey = result > 0 ? "checked_in" : "already_in";
		}

		System.out.println("[AttendanceCheckService] " + loginId + " " + mode + " -> " + resultKey);

		RequestUtil.redirect(request, response, "/pages/attendance.do?result=" + resultKey);
	}
}
