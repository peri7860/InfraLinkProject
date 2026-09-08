<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  회의실 예약 신청

  [수정] 2026-09-07
    변경 전 : 폼에 action / name 이 없어 예약이 저장되지 않았다.
              회의실 목록도 하드코딩이었다.
    변경 후 : RoomReserveService 로 POST 한다.
              서버가 같은 시간대 중복 예약을 검사해 거부한다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>会議室予約 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="room">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-door-open"></i> 会議室予約</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/room.do">会議室予約</a></li>
        <li class="breadcrumb-item active" aria-current="page">申請</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-pencil-square"></i> 会議室の予約申請</h5>
            <span class="small text-muted">* 必須項目</span>
          </div>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
              <i class="bi bi-exclamation-circle"></i> <c:out value="${errorMessage}"/>
            </div>
          </c:if>

          <form class="form-panel" method="post" action="${cp}/pages/room-write.do">

            <div class="row g-3">

              <div class="col-md-6">
                <label class="form-label" for="roomCode">
                  会議室 <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="roomCode" name="room_code" required>
                  <option value="">選択してください</option>
                  <c:forEach var="room" items="${roomList}">
                    <option value="${room.room_code}"
                            ${selectedRoom eq room.room_code ? 'selected' : ''}>
                      <c:out value="${room.room_name}"/>（<c:out value="${room.summary}"/>）
                    </option>
                  </c:forEach>
                </select>
              </div>

              <div class="col-md-6">
                <label class="form-label" for="reserveDate">
                  日付 <span class="text-danger">*</span>
                </label>
                <input type="date" class="form-control" id="reserveDate" name="reserve_date"
                       required min="${today}" value="${selectedDate}">
              </div>

              <div class="col-md-6">
                <label class="form-label" for="startTime">
                  開始時刻 <span class="text-danger">*</span>
                </label>
                <input type="time" class="form-control" id="startTime" name="start_time"
                       required value="10:00" step="600">
              </div>

              <div class="col-md-6">
                <label class="form-label" for="endTime">
                  終了時刻 <span class="text-danger">*</span>
                </label>
                <input type="time" class="form-control" id="endTime" name="end_time"
                       required value="11:00" step="600">
                <div class="form-text">
                  同じ会議室・同じ時間帯にすでに予約がある場合は登録できません。
                </div>
              </div>

              <div class="col-12">
                <label class="form-label" for="meetingTitle">
                  件名 <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="meetingTitle" name="meeting_title"
                       maxlength="300" required placeholder="例：開発部 定例ミーティング">
              </div>

              <div class="col-12">
                <label class="form-label" for="attendees">参加者</label>
                <input type="text" class="form-control" id="attendees" name="attendees"
                       maxlength="500" placeholder="例：開発部 全員 / 佐藤・鈴木">
              </div>

            </div>

            <div class="form-actions">
              <a href="${cp}/pages/room.do?date=${selectedDate}"
                 class="btn btn-outline-secondary px-4">キャンセル</a>
              <button type="submit" class="btn btn-teal px-4">予約する</button>
            </div>
          </form>
        </div>
      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<script>
// 종료 시각이 시작보다 빠르면 전송 전에 막는다 (서버도 같은 검사를 한다)
(function () {
  "use strict";
  document.addEventListener("DOMContentLoaded", function () {
    var form = document.querySelector("form.form-panel");
    var start = document.getElementById("startTime");
    var end = document.getElementById("endTime");
    if (!form || !start || !end) return;

    form.addEventListener("submit", function (e) {
      if (end.value <= start.value) {
        e.preventDefault();
        alert("終了時刻は開始時刻より後にしてください。");
        end.focus();
      }
    });
  });
})();
</script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
