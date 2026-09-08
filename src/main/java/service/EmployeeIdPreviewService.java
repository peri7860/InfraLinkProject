package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AdminDAO;
import model.DepartmentDAO;
import util.RequestUtil;

/**
 * 사번 미리보기 (부서 선택 시 AJAX 로 호출).
 *
 * <pre>
 * [수정] 2026-09-07
 *
 * 변경 전의 문제
 *  1) Command 를 구현하지 않아 컨트롤러에서 따로 처리해야 했다.
 *  2) AdminDAO.getNextEmpSequencePreview() 가
 *     user_sequences.last_number 를 읽고 있었다.
 *     → 이 값은 "다음에 나올 번호"가 아니라 캐시로 선점한 최대값이다.
 *       시퀀스에 CACHE 가 걸려 있으면 화면에 보여준 사번과
 *       실제 저장되는 사번이 서로 달라진다.
 *     → 기존 사번에서 최대값을 구하는 방식(previewNextEmployeeId)으로 교체.
 *  3) 존재하지 않는 부서 코드를 보내도 그대로 사번을 만들어 보여줬다.
 *
 * ※ 어디까지나 "미리보기"다.
 *   실제 사번은 등록 시점에 AdminDAO 가 채번하며,
 *   그 사이 다른 관리자가 등록하면 번호가 달라질 수 있다.
 *   (등록 결과 화면에서 실제 발급된 사번을 다시 보여준다)
 * </pre>
 */
public class EmployeeIdPreviewService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String deptCode = RequestUtil.getParam(request, "dept_code");

		// -------------------------------------------------------------
		// 1. 파라미터 검증
		// -------------------------------------------------------------
		if (deptCode == null) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			RequestUtil.writeText(response, "部署を選択してください");
			return;
		}

		// -------------------------------------------------------------
		// 2. 실제 존재하는 부서인지 확인
		// -------------------------------------------------------------
		if (!new DepartmentDAO().exists(deptCode)) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			RequestUtil.writeText(response, "存在しない部署です");
			return;
		}

		// -------------------------------------------------------------
		// 3. 다음 사번 계산
		// -------------------------------------------------------------
		String employeeId = new AdminDAO().previewNextEmployeeId(deptCode);

		if (employeeId == null) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			RequestUtil.writeText(response, "社員番号を取得できませんでした");
			return;
		}

		RequestUtil.writeText(response, employeeId);
	}
}
