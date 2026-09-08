<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  회의실 예약 현황

  [수정] 2026-09-07
    변경 전 : 회의실 목록과 시간대 표가 전부 하드코딩. 날짜 이동도 없었다.
    변경 후 : RoomListService 의 roomList / reserveList / myReserveList 를
              그린다. 날짜별 예약 현황과 내 예약을 함께 보여준다.
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
        <li class="breadcrumb-item active" aria-current="page">会議室予約</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <c:if test="${param.result eq 'reserved'}">
          <div class="alert alert-success py-2 px-3 small">会議室を予約しました。</div>
        </c:if>
        <c:if test="${param.result eq 'canceled'}">
          <div class="alert alert-success py-2 px-3 small">予約を取り消しました。</div>
        </c:if>

        <%-- ==================== 날짜 이동 ==================== --%>
        <form class="filter-bar" method="get" action="${cp}/pages/room.do">
          <a href="${cp}/pages/room.do?date=${prevDate}"
             class="btn btn-outline-secondary btn-sm" aria-label="前日">
            <i class="bi bi-chevron-left"></i>
          </a>
          <input type="date" name="date" class="form-control form-control-sm"
                 style="width:170px;" value="${date}" onchange="this.form.submit()">
          <a href="${cp}/pages/room.do?date=${nextDate}"
             class="btn btn-outline-secondary btn-sm" aria-label="翌日">
            <i class="bi bi-chevron-right"></i>
          </a>
          <a href="${cp}/pages/room.do" class="btn btn-outline-secondary btn-sm">今日</a>

          <a href="${cp}/pages/room-write.do?date=${date}" class="btn btn-teal btn-sm ms-auto">
            <i class="bi bi-plus-lg"></i> 予約する
          </a>
        </form>

        <%-- ==================== 회의실 목록 ==================== --%>
        <div class="row g-3 mb-3">
          <c:forEach var="room" items="${roomList}">
            <div class="col-md-6 col-lg-3">
              <div class="panel p-3 h-100">
                <div class="fw-bold mb-1"><c:out value="${room.room_name}"/></div>
                <div class="text-muted small mb-2"><c:out value="${room.summary}"/></div>
                <c:if test="${not empty room.equipment}">
                  <div class="text-muted" style="font-size:.75rem;">
                    <i class="bi bi-tv"></i> <c:out value="${room.equipment}"/>
                  </div>
                </c:if>
                <div class="mt-2">
                  <span class="status-pill ${room.reserve_count > 0 ? 'status-wait' : 'status-done'}">
                    ${date} 予約 ${room.reserve_count}件
                  </span>
                </div>
                <a href="${cp}/pages/room-write.do?room_code=${room.room_code}&date=${date}"
                   class="btn btn-outline-teal btn-sm w-100 mt-2">この会議室を予約</a>
              </div>
            </div>
          </c:forEach>
        </div>

        <%-- ==================== 그 날의 예약 ==================== --%>
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-calendar-check"></i> ${date} の予約</h5>
            <span class="text-muted" style="font-size:.8rem;">
              全 ${fn:length(reserveList)}件
            </span>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:140px;">会議室</th>
                  <th style="width:140px;">時間</th>
                  <th>件名</th>
                  <th style="width:130px;">予約者</th>
                  <th style="width:90px;" class="text-center">操作</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="rv" items="${reserveList}">
                  <tr>
                    <td><c:out value="${rv.room_name}"/></td>
                    <td><c:out value="${rv.timeRange}"/></td>
                    <td>
                      <a href="${cp}/pages/room-view.do?no=${rv.reserve_no}"
                         class="title-link"><c:out value="${rv.meeting_title}"/></a>
                    </td>
                    <td><c:out value="${rv.emp_name}"/></td>
                    <td class="text-center">
                      <a href="${cp}/pages/room-view.do?no=${rv.reserve_no}"
                         class="btn btn-outline-secondary btn-sm">詳細</a>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty reserveList}">
                  <tr>
                    <td colspan="5" class="text-center py-4">
                      <span class="text-muted small">この日の予約はありません。</span>
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

        <%-- ==================== 내 예약 ==================== --%>
        <div class="panel mt-3">
          <div class="panel-header">
            <h5><i class="bi bi-person-check"></i> 自分の予約</h5>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:120px;">日付</th>
                  <th style="width:130px;">会議室</th>
                  <th style="width:130px;">時間</th>
                  <th>件名</th>
                  <th style="width:90px;" class="text-center">状態</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="my" items="${myReserveList}">
                  <tr>
                    <td>${my.reserveDate}</td>
                    <td><c:out value="${my.room_name}"/></td>
                    <td><c:out value="${my.timeRange}"/></td>
                    <td>
                      <a href="${cp}/pages/room-view.do?no=${my.reserve_no}"
                         class="title-link"><c:out value="${my.meeting_title}"/></a>
                    </td>
                    <td class="text-center">
                      <span class="status-pill ${my.canceled ? 'status-reject' : 'status-done'}">
                        <c:out value="${my.status}"/>
                      </span>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty myReserveList}">
                  <tr>
                    <td colspan="5" class="text-center py-4">
                      <span class="text-muted small">予約履歴はありません。</span>
                    </td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
