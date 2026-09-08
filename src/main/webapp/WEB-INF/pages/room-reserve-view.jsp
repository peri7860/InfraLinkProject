<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  회의실 예약 상세

  [수정] 2026-09-07
    변경 전 : 특정 예약 하나가 하드코딩되어 있었다.
    변경 후 : RoomViewService 의 reserve 를 그린다.
              취소는 예약자 본인에게만 보이고, DAO 의 WHERE 절이 다시 막는다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty reserve ? '会議室予約' : reserve.meeting_title}"/> | InfraLink</title>

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
        <li class="breadcrumb-item active" aria-current="page">詳細</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <c:if test="${empty reserve}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-calendar-x"></i>
              <h6><c:out value="${empty errorMessage ? '予約が見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/room.do" class="btn btn-teal btn-sm mt-3">一覧に戻る</a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty reserve}">

          <c:if test="${param.result eq 'no_permission'}">
            <div class="alert alert-warning py-2 px-3 small">
              自分の予約のみ取り消せます。すでに取消済みの可能性もあります。
            </div>
          </c:if>

          <div class="panel">
            <div class="view-header">
              <span class="status-pill ${reserve.canceled ? 'status-reject' : 'status-done'} mb-2 d-inline-block">
                <c:out value="${reserve.status}"/>
              </span>
              <h2><c:out value="${reserve.meeting_title}"/></h2>
              <div class="view-meta">
                <span><i class="bi bi-door-open"></i> <c:out value="${reserve.room_name}"/></span>
                <span><i class="bi bi-calendar3"></i> ${reserve.reserveDate}</span>
                <span><i class="bi bi-clock"></i> <c:out value="${reserve.timeRange}"/></span>
              </div>
            </div>

            <div class="border-top">
              <table class="table mb-0">
                <tbody>
                  <tr>
                    <th style="width:150px;background:#f7f9fa;">会議室</th>
                    <td>
                      <c:out value="${reserve.room_name}"/>
                      <span class="text-muted small ms-2">
                        <c:out value="${reserve.location}"/>
                        <c:if test="${reserve.capacity > 0}"> / ${reserve.capacity}名</c:if>
                      </span>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">予約者</th>
                    <td>
                      <c:out value="${reserve.emp_name}"/>
                      <c:if test="${not empty reserve.dept_name}">
                        （<c:out value="${reserve.dept_name}"/>）
                      </c:if>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">参加者</th>
                    <td>
                      <c:choose>
                        <c:when test="${not empty reserve.attendees}">
                          <c:out value="${reserve.attendees}"/>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">予約日</th>
                    <td>${reserve.reg_date}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="view-footer">
              <a href="${cp}/pages/room.do?date=${reserve.reserveDate}"
                 class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>

              <c:if test="${canCancel}">
                <form method="post" action="${cp}/pages/roomCancel.do" class="d-inline"
                      onsubmit="return confirm('この予約を取り消しますか？\n取り消すと、その時間帯は他の方が予約できるようになります。');">
                  <input type="hidden" name="no" value="${reserve.reserve_no}">
                  <button type="submit" class="btn btn-sm text-white" style="background:var(--warn);">
                    <i class="bi bi-x-circle"></i> 予約を取り消す
                  </button>
                </form>
              </c:if>
            </div>
          </div>
        </c:if>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
