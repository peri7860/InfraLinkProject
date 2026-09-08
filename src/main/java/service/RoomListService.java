package service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.RoomDAO;
import model.RoomDTO;
import model.Room_ReserveDTO;
import util.RequestUtil;

/**
 * 회의실 예약 현황.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   room-reserve.jsp 의 회의실 목록과 시간대 표가 전부 하드코딩이었다.
 *   테이블·DAO·서비스가 모두 없었다. → 새로 구현.
 *
 * 화면에 넘기는 값
 *   roomList     : 회의실 목록 (해당 날짜 예약 건수 포함)
 *   reserveList  : 해당 날짜의 예약 전체
 *   myReserveList: 내 예약 목록
 *   date / prevDate / nextDate : 날짜 이동용
 * </pre>
 */
public class RoomListService implements Command {

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
		// 조회 날짜 (?date=2026-09-08, 없으면 오늘)
		// 잘못된 값이 와도 예외로 죽지 않게 한다.
		// -------------------------------------------------------------
		LocalDate target;
		try {
			String param = RequestUtil.getParam(request, "date");
			target = param == null ? LocalDate.now() : LocalDate.parse(param);
		} catch (DateTimeParseException e) {
			target = LocalDate.now();
		}

		String date = target.toString();
		String roomCode = RequestUtil.getParam(request, "room_code");

		RoomDAO dao = new RoomDAO();

		List<RoomDTO> roomList = dao.getRoomListWithCount(date);
		List<Room_ReserveDTO> reserveList = dao.selectReserveByDate(date, roomCode);

		request.setAttribute("roomList", roomList);
		request.setAttribute("reserveList", reserveList);
		request.setAttribute("myReserveList", dao.selectMyReserve(loginId));

		request.setAttribute("date", date);
		request.setAttribute("prevDate", target.minusDays(1).toString());
		request.setAttribute("nextDate", target.plusDays(1).toString());
		request.setAttribute("today", LocalDate.now().toString());
		request.setAttribute("selectedRoom", roomCode);

		request.getRequestDispatcher("/WEB-INF/pages/room-reserve.jsp")
				.forward(request, response);
	}
}
