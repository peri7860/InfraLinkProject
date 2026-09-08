<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  일정 (월간 캘린더)

  [수정] 2026-09-07
    변경 전 : 달력 칸과 일정이 전부 하드코딩. 월 이동도 되지 않았다.
    변경 후 : ScheduleListService 가 담아준 scheduleList 를
              날짜별로 묶어 달력에 배치한다.

  달력 그리는 방법
    firstDayOfWeek : 1일의 요일 (일=0 ... 토=6). 앞쪽 빈 칸 개수가 된다.
    lastDay        : 그 달의 마지막 날짜
    일정은 schedule_date("YYYY-MM-DD") 로 비교해 해당 칸에 넣는다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>スケジュール | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">

<style>
/* 월간 캘린더 */
.cal-table { table-layout: fixed; width: 100%; }
.cal-table th { text-align: center; padding: 8px 4px; font-size: .82rem; background: #f7f9fa; }
.cal-table td { height: 108px; vertical-align: top; padding: 6px; border: 1px solid #e5eaea; }
.cal-table td.empty { background: #fafbfb; }
.cal-day { font-size: .8rem; font-weight: 600; margin-bottom: 4px; }
.cal-day.sun { color: #c0392b; }
.cal-day.sat { color: #2b6cb0; }
.cal-table td.today { background: #eef8f6; }
.cal-table td.today .cal-day { color: var(--teal, #0e7c6f); }
.cal-event {
  display: block; font-size: .72rem; line-height: 1.4;
  padding: 2px 5px; margin-bottom: 3px; border-radius: 3px;
  background: #e2f1ee; color: #0a5b51; text-decoration: none;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.cal-event:hover { background: #cfe8e3; }
.cal-event.all  { background: #fdf0dc; color: #8a5a08; }
.cal-event.dept { background: #e6eefb; color: #244f8f; }
</style>
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
        <li class="breadcrumb-item active" aria-current="page">スケジュール</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <c:if test="${param.result eq 'saved'}">
          <div class="alert alert-success py-2 px-3 small">予定を保存しました。</div>
        </c:if>
        <c:if test="${param.result eq 'deleted'}">
          <div class="alert alert-success py-2 px-3 small">予定を削除しました。</div>
        </c:if>
        <c:if test="${param.result eq 'no_permission'}">
          <div class="alert alert-warning py-2 px-3 small">
            自分が登録した予定のみ編集できます。
          </div>
        </c:if>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-calendar3"></i> ${year}年 ${month}月</h5>

            <div class="d-flex gap-2 align-items-center">
              <a href="${cp}/pages/schedule.do?ym=${prevMonth}"
                 class="btn btn-outline-secondary btn-sm" aria-label="前の月">
                <i class="bi bi-chevron-left"></i>
              </a>
              <a href="${cp}/pages/schedule.do" class="btn btn-outline-secondary btn-sm">今月</a>
              <a href="${cp}/pages/schedule.do?ym=${nextMonth}"
                 class="btn btn-outline-secondary btn-sm" aria-label="次の月">
                <i class="bi bi-chevron-right"></i>
              </a>
              <a href="${cp}/pages/schedule-write.do" class="btn btn-teal btn-sm ms-2">
                <i class="bi bi-plus-lg"></i> 予定登録
              </a>
            </div>
          </div>

          <div class="table-scroll">
            <table class="cal-table">
              <thead>
                <tr>
                  <th style="color:#c0392b;">日</th>
                  <th>月</th><th>火</th><th>水</th><th>木</th><th>金</th>
                  <th style="color:#2b6cb0;">土</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <%-- 1일 앞의 빈 칸 --%>
                  <c:forEach begin="1" end="${firstDayOfWeek}" var="i">
                    <td class="empty"></td>
                  </c:forEach>

                  <c:forEach begin="1" end="${lastDay}" var="day">
                    <%-- 이 칸의 날짜 문자열 (YYYY-MM-DD) --%>
                    <c:set var="cellDate"
                           value="${yearMonth}-${day < 10 ? '0'.concat(day) : day}"/>

                    <td class="${cellDate eq today ? 'today' : ''}">
                      <c:set var="dow" value="${(firstDayOfWeek + day - 1) % 7}"/>
                      <div class="cal-day ${dow == 0 ? 'sun' : (dow == 6 ? 'sat' : '')}">
                        ${day}
                      </div>

                      <%-- 이 날짜의 일정만 그린다 --%>
                      <c:forEach var="sc" items="${scheduleList}">
                        <c:if test="${sc.schedule_date eq cellDate}">
                          <a href="${cp}/pages/schedule-view.do?no=${sc.schedule_no}"
                             class="cal-event ${sc.visibility eq 'ALL' ? 'all'
                                              : (sc.visibility eq 'DEPT' ? 'dept' : '')}"
                             title="<c:out value='${sc.title}'/>">
                            <c:out value="${sc.timeRange}"/>
                            <c:out value="${sc.title}"/>
                          </a>
                        </c:if>
                      </c:forEach>
                    </td>

                    <%-- 토요일이면 줄바꿈 --%>
                    <c:if test="${dow == 6 and day ne lastDay}">
                      </tr><tr>
                    </c:if>
                  </c:forEach>

                  <%-- 마지막 주의 남은 칸 채우기 --%>
                  <c:set var="lastDow" value="${(firstDayOfWeek + lastDay - 1) % 7}"/>
                  <c:if test="${lastDow < 6}">
                    <c:forEach begin="${lastDow + 1}" end="6" var="i">
                      <td class="empty"></td>
                    </c:forEach>
                  </c:if>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <%-- ==================== 이번 달 일정 목록 ==================== --%>
        <div class="panel mt-3">
          <div class="panel-header">
            <h5><i class="bi bi-list-ul"></i> ${month}月の予定</h5>
            <span class="text-muted" style="font-size:.8rem;">
              全 ${fn:length(scheduleList)}件
            </span>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:120px;">日付</th>
                  <th style="width:120px;">時間</th>
                  <th>件名</th>
                  <th style="width:140px;">場所</th>
                  <th style="width:90px;" class="text-center">公開</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="sc" items="${scheduleList}">
                  <tr>
                    <td>${sc.schedule_date}</td>
                    <td><c:out value="${sc.timeRange}"/></td>
                    <td>
                      <a href="${cp}/pages/schedule-view.do?no=${sc.schedule_no}"
                         class="title-link"><c:out value="${sc.title}"/></a>
                    </td>
                    <td><c:out value="${sc.location}"/></td>
                    <td class="text-center">
                      <span class="badge-normal"><c:out value="${sc.visibilityLabel}"/></span>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty scheduleList}">
                  <tr>
                    <td colspan="5" class="text-center py-4">
                      <span class="text-muted small">この月の予定はありません。</span>
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
