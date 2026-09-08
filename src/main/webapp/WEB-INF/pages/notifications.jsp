<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  알림 목록

  [수정] 2026-09-07
    변경 전 : 알림이 하드코딩되어 있었고, common.js 의 읽음 처리는
              DOM 만 바꿔서 새로고침하면 다시 미읽음으로 돌아왔다.
              헤더 배지도 "3" 고정이었다.
    변경 후 : NotificationListService 의 notificationList 를 그리고,
              읽음 처리를 DB 에 반영한다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>通知 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="notifications">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-bell"></i> 通知</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">通知</li>
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
            <h5>
              <i class="bi bi-bell"></i> 通知
              <span class="text-muted fw-normal ms-2" style="font-size:.8rem;"
                    data-unread-label>未読 ${unreadCount}件</span>
            </h5>

            <%-- 전체 읽음 : DB 에 반영된다 --%>
            <c:if test="${unreadCount > 0}">
              <form method="post" action="${cp}/pages/notificationRead.do" class="d-inline">
                <input type="hidden" name="mode" value="readAll">
                <button type="submit" class="btn btn-outline-teal btn-sm">
                  すべて既読にする
                </button>
              </form>
            </c:if>
          </div>

          <div class="list-group list-group-flush">

            <c:forEach var="noti" items="${notificationList}">
              <%-- 미읽음은 배경으로 구분한다 --%>
              <div class="list-group-item d-flex gap-3 align-items-start
                          ${noti.unread ? 'bg-teal-tint' : ''}"
                   data-notification>

                <div class="pt-1">
                  <i class="bi ${noti.iconClass} fs-5 text-teal"></i>
                </div>

                <div class="flex-grow-1">
                  <div class="small">
                    <span class="badge-normal me-1"><c:out value="${noti.typeLabel}"/></span>
                    <c:if test="${noti.unread}">
                      <span class="badge-fixed">未読</span>
                    </c:if>
                  </div>

                  <div class="mt-1">
                    <c:choose>
                      <%-- 이동할 곳이 있으면 링크. 클릭 시 읽음 처리 후 이동한다 --%>
                      <c:when test="${not empty noti.url}">
                        <a href="${cp}/pages/notificationRead.do?mode=read&no=${noti.noti_no}"
                           class="title-link"><c:out value="${noti.title}"/></a>
                      </c:when>
                      <c:otherwise>
                        <c:out value="${noti.title}"/>
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <div class="text-muted" style="font-size:.75rem;">${noti.reg_date}</div>
                </div>

                <div class="d-flex flex-column gap-1">
                  <c:if test="${noti.unread}">
                    <form method="post" action="${cp}/pages/notificationRead.do">
                      <input type="hidden" name="mode" value="read">
                      <input type="hidden" name="no" value="${noti.noti_no}">
                      <button type="submit" class="btn btn-outline-secondary btn-sm">既読</button>
                    </form>
                  </c:if>
                  <form method="post" action="${cp}/pages/notificationRead.do">
                    <input type="hidden" name="mode" value="delete">
                    <input type="hidden" name="no" value="${noti.noti_no}">
                    <button type="submit" class="btn btn-link text-danger btn-sm p-0">削除</button>
                  </form>
                </div>
              </div>
            </c:forEach>

            <c:if test="${empty notificationList}">
              <div class="empty-state py-5">
                <i class="bi bi-bell-slash"></i>
                <h6>通知はありません</h6>
                <p class="small mb-0">
                  新しいお知らせや決裁依頼が届くとここに表示されます。
                </p>
              </div>
            </c:if>

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
