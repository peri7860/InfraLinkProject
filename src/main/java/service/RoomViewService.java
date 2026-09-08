package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.RoomDAO;
import model.Room_ReserveDTO;
import util.RequestUtil;

/**
 * 회의실 예약 상세.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   room-reserve-view.jsp 가 특정 예약 하나로 하드코딩되어 있었다.
 *
 * 취소 버튼은 예약자 본인에게만 보여준다.
 * (실제 차단은 RoomDAO.cancelReserve 의 WHERE 절이 담당)
 * </pre>
 */
public class RoomViewService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		int reserveNo = RequestUtil.getIntParam(request, "no", 0);

		if (reserveNo <= 0) {
			RequestUtil.redirect(request, response, "/pages/room.do");
			return;
		}

		Room_ReserveDTO reserve = new RoomDAO().selectReserveByNo(reserveNo);

		if (reserve == null) {
			request.setAttribute("errorMessage", "予約が見つかりません。");
			request.getRequestDispatcher("/WEB-INF/pages/room-reserve-view.jsp")
					.forward(request, response);
			return;
		}

		String loginId = RequestUtil.getLoginId(request);

		// 예약자 본인이고 아직 취소되지 않은 예약만 취소할 수 있다
		boolean canCancel = loginId != null
				&& loginId.equals(reserve.getEmployee_id())
				&& !reserve.isCanceled();

		request.setAttribute("reserve", reserve);
		request.setAttribute("canCancel", canCancel);

		request.getRequestDispatcher("/WEB-INF/pages/room-reserve-view.jsp")
				.forward(request, response);
	}
}
