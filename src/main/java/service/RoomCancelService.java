package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.RoomDAO;
import util.RequestUtil;

/**
 * 회의실 예약 취소.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   예약 취소 기능이 없었다.
 *
 * DELETE 가 아니라 status 를 '取消' 로 바꾸는 이유
 *   "누가 언제 예약했다가 취소했는지" 이력이 남아야 회의실 사용 분쟁 시
 *   확인할 수 있다. 취소된 예약은 중복 검사 대상에서 빠지므로
 *   그 시간대는 다시 예약할 수 있다.
 *
 * 권한
 *   DAO 의 WHERE 절에 employee_id 와 status='予約' 가 있어
 *   본인의 유효한 예약만 취소된다. (남의 예약 / 이미 취소된 예약 → 0건)
 * </pre>
 */
public class RoomCancelService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		int reserveNo = RequestUtil.getIntParam(request, "no", 0);
		if (reserveNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/room.do");
			return;
		}

		int result = new RoomDAO().cancelReserve(reserveNo, loginId);

		if (result > 0) {
			System.out.println("[RoomCancelService] 예약 취소 : " + reserveNo);
			RequestUtil.redirect(request, response, "/pages/room.do?result=canceled");
		} else {
			// 본인 예약이 아니거나 이미 취소됨
			RequestUtil.redirect(request, response,
					"/pages/room-view.do?no=" + reserveNo + "&result=no_permission");
		}
	}
}
