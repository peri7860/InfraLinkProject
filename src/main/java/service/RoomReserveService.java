package service;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.NotificationDAO;
import model.RoomDAO;
import model.Room_ReserveDTO;
import util.RequestUtil;

/**
 * 회의실 예약 (폼 + 등록).
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *   room-reserve-write.jsp 는 폼만 있고 저장 로직이 없었다.
 *
 * ★ 이 서비스의 핵심은 중복 예약 검사다.
 *   같은 회의실을 같은 시간대에 두 사람이 예약하면 안 된다.
 *   RoomDAO.isOverlapped 가 판정한다.
 *     기존.start &lt; 신규.end  AND  기존.end &gt; 신규.start  → 겹침
 *   경계가 맞닿는 예약(10:00~11:00 과 11:00~12:00)은 겹치지 않는다.
 *
 * 남는 경합 가능성
 *   검사와 INSERT 사이에 다른 사람이 예약하면 이론상 중복이 가능하다.
 *   완전히 막으려면 DB 레벨 배타 제약이 필요한데(오라클에서는 트리거나
 *   범위 제약이 필요) 사내 회의실 규모에서는 과한 설계라 판단해
 *   애플리케이션 검사로 처리한다.
 * </pre>
 */
public class RoomReserveService implements Command {

	private static final String FORM_PAGE = "/WEB-INF/pages/room-reserve-write.jsp";

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String loginId = RequestUtil.getLoginId(request);
		if (loginId == null) {
			RequestUtil.redirect(request, response, "/pages/login.do");
			return;
		}

		RoomDAO dao = new RoomDAO();

		// -------------------------------------------------------------
		// GET : 예약 폼
		// -------------------------------------------------------------
		if (!"POST".equalsIgnoreCase(request.getMethod())) {

			request.setAttribute("roomList", dao.getRoomList());
			request.setAttribute("today", LocalDate.now().toString());
			// 목록에서 회의실/날짜를 선택하고 넘어온 경우 미리 채워준다
			request.setAttribute("selectedRoom", RequestUtil.getParam(request, "room_code"));
			request.setAttribute("selectedDate",
					RequestUtil.getParam(request, "date", LocalDate.now().toString()));

			request.getRequestDispatcher(FORM_PAGE).forward(request, response);
			return;
		}

		// -------------------------------------------------------------
		// POST : 예약 등록
		// -------------------------------------------------------------
		String roomCode = RequestUtil.getParam(request, "room_code");
		String title = RequestUtil.getParam(request, "meeting_title");
		String attendees = RequestUtil.getParam(request, "attendees");
		String date = RequestUtil.getParam(request, "reserve_date");
		String start = RequestUtil.getParam(request, "start_time");
		String end = RequestUtil.getParam(request, "end_time");

		// 필수값
		if (roomCode == null || title == null || date == null || start == null || end == null) {
			fail(request, response, "会議室・件名・日付・時間はすべて必須です。");
			return;
		}

		String startTime = date + " " + start;
		String endTime = date + " " + end;

		// 종료가 시작보다 빠르거나 같으면 안 된다
		if (endTime.compareTo(startTime) <= 0) {
			fail(request, response, "終了時刻は開始時刻より後にしてください。");
			return;
		}

		// -------------------------------------------------------------
		// ★ 중복 예약 검사 (신규 예약이므로 제외할 예약번호는 0)
		// -------------------------------------------------------------
		if (dao.isOverlapped(roomCode, startTime, endTime, 0)) {
			fail(request, response, "その時間帯はすでに予約が入っています。別の時間をお選びください。");
			return;
		}

		Room_ReserveDTO dto = new Room_ReserveDTO();
		dto.setRoom_code(roomCode);
		dto.setEmployee_id(loginId);
		dto.setMeeting_title(title);
		dto.setAttendees(attendees);
		dto.setStart_time(startTime);
		dto.setEnd_time(endTime);

		int result = dao.insertReserve(dto);

		if (result <= 0) {
			fail(request, response, "予約の登録に失敗しました。");
			return;
		}

		System.out.println("[RoomReserveService] 예약 등록 : " + roomCode + " " + startTime);

		// 본인에게 확정 알림
		new NotificationDAO().insert(loginId, "ROOM",
				"会議室の予約が確定しました : " + title, "/pages/room.do?date=" + date);

		RequestUtil.redirect(request, response, "/pages/room.do?date=" + date + "&result=reserved");
	}

	/** 실패 시 폼으로 되돌린다 (회의실 목록을 다시 채워야 select 가 비지 않는다) */
	private void fail(HttpServletRequest request, HttpServletResponse response, String message)
			throws ServletException, IOException {

		request.setAttribute("roomList", new RoomDAO().getRoomList());
		request.setAttribute("today", LocalDate.now().toString());
		request.setAttribute("selectedRoom", RequestUtil.getParam(request, "room_code"));
		request.setAttribute("selectedDate", RequestUtil.getParam(request, "reserve_date"));

		RequestUtil.forwardWithError(request, response, FORM_PAGE, message);
	}
}
