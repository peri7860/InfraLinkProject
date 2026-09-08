<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  일정 상세

  [수정] 2026-09-07
    변경 전 : 하드코딩된 일정 하나를 보여줬다.
    변경 후 : ScheduleViewService 의 schedule 을 그린다.
              수정/삭제는 등록한 본인에게만 보인다.

  공개 범위가 맞지 않으면 서비스가 아예 null 을 돌려준다.
  (PRIVATE 인 남의 일정은 번호를 알아도 열 수 없다)
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty schedule ? '予定' : schedule.title}"/> | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">

<style>.sc-content { white-space: pre-wrap; word-break: break-word; }</style>
</head>
<body data-page="schedule">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-calendar3"></i> スケジュール</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/schedule.do">スケジュール</a></li>
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

        <c:if test="${empty schedule}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-calendar-x"></i>
              <h6><c:out value="${empty errorMessage ? '予定が見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/schedule.do" class="btn btn-teal btn-sm mt-3">
                <i class="bi bi-calendar3"></i> カレンダーに戻る
              </a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty schedule}">
          <div class="panel">
            <div class="view-header">
              <span class="badge-normal mb-2 d-inline-block">
                <c:out value="${schedule.visibilityLabel}"/>
              </span>
              <h2><c:out value="${schedule.title}"/></h2>
              <div class="view-meta">
                <span><i class="bi bi-person"></i> <c:out value="${schedule.emp_name}"/></span>
                <span><i class="bi bi-calendar3"></i> ${schedule.schedule_date}</span>
                <span><i class="bi bi-clock"></i> <c:out value="${schedule.timeRange}"/></span>
              </div>
            </div>

            <div class="border-top">
              <table class="table mb-0">
                <tbody>
                  <tr>
                    <th style="width:150px;background:#f7f9fa;">開始</th>
                    <td>${schedule.start_time}</td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">終了</th>
                    <td>${schedule.end_time}</td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">場所 / 会議URL</th>
                    <td>
                      <c:choose>
                        <c:when test="${not empty schedule.location}">
                          <c:out value="${schedule.location}"/>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">詳細</th>
                    <td>
                      <c:choose>
                        <c:when test="${not empty schedule.content}">
                          <div class="sc-content"><c:out value="${schedule.content}"/></div>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="view-footer">
              <a href="${cp}/pages/schedule.do?ym=${fn:substring(schedule.schedule_date, 0, 7)}"
                 class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-calendar3"></i> カレンダーに戻る
              </a>

              <%-- 수정/삭제는 등록한 본인만 --%>
              <c:if test="${canEdit}">
                <div class="d-flex gap-2">
                  <a href="${cp}/pages/schedule-write.do?no=${schedule.schedule_no}"
                     class="btn btn-outline-teal btn-sm">
                    <i class="bi bi-pencil"></i> 編集
                  </a>
                  <form method="post" action="${cp}/pages/scheduleDelete.do" class="d-inline"
                        onsubmit="return confirm('この予定を削除しますか？');">
                    <input type="hidden" name="no" value="${schedule.schedule_no}">
                    <button type="submit" class="btn btn-sm text-white"
                            style="background:var(--warn);">
                      <i class="bi bi-trash"></i> 削除
                    </button>
                  </form>
                </div>
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
