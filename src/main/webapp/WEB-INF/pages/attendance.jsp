<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  근태 관리

  [수정] 2026-09-07
    변경 전 : 출퇴근 기록과 통계가 전부 하드코딩.
              테이블·DTO·DAO·서비스가 모두 없었고 버튼도 동작하지 않았다.
    변경 후 : AttendanceService 의 today / attendanceList / 통계를 그리고
              출근·퇴근을 AttendanceCheckService 로 POST 한다.

  버튼 상태
    미출근      → 출근 버튼
    출근·미퇴근 → 퇴근 버튼
    퇴근 완료   → 오늘 근무 요약만 표시
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>勤怠管理 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="attendance">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-clock-history"></i> 勤怠管理</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">勤怠管理</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <%-- ==================== 처리 결과 ==================== --%>
        <c:if test="${param.result eq 'checked_in'}">
          <div class="alert alert-success py-2 px-3 small">出勤を記録しました。</div>
        </c:if>
        <c:if test="${param.result eq 'checked_out'}">
          <div class="alert alert-success py-2 px-3 small">退勤を記録しました。お疲れ様でした。</div>
        </c:if>
        <c:if test="${param.result eq 'already_in'}">
          <div class="alert alert-warning py-2 px-3 small">本日はすでに出勤済みです。</div>
        </c:if>
        <c:if test="${param.result eq 'already_out'}">
          <div class="alert alert-warning py-2 px-3 small">
            出勤記録がないか、すでに退勤済みです。
          </div>
        </c:if>

        <%-- ==================== 오늘의 출퇴근 ==================== --%>
        <div class="panel mb-3">
          <div class="panel-header">
            <h5><i class="bi bi-person-workspace"></i> 本日の勤怠</h5>
          </div>
          <div class="p-3">
            <div class="row g-3 align-items-center">

              <div class="col-md-3 text-center">
                <div class="text-muted small mb-1">出勤</div>
                <div class="fs-4 fw-bold">
                  <c:out value="${empty today.in_time ? '--:--' : today.in_time}"/>
                </div>
                <c:if test="${not empty today and today.late}">
                  <span class="status-pill status-reject">遅刻</span>
                </c:if>
              </div>

              <div class="col-md-3 text-center">
                <div class="text-muted small mb-1">退勤</div>
                <div class="fs-4 fw-bold">
                  <c:out value="${empty today.out_time ? '--:--' : today.out_time}"/>
                </div>
              </div>

              <div class="col-md-3 text-center">
                <div class="text-muted small mb-1">勤務時間</div>
                <div class="fs-5 fw-bold">
                  <c:out value="${empty today ? '-' : today.workTimeText}"/>
                </div>
              </div>

              <div class="col-md-3 text-center">
                <%-- 상태에 따라 버튼이 바뀐다 --%>
                <c:choose>

                  <%-- 아직 출근 안 함 --%>
                  <c:when test="${empty today}">
                    <form method="post" action="${cp}/pages/attendanceCheck.do">
                      <input type="hidden" name="mode" value="in">
                      <select name="work_type" class="form-select form-select-sm mb-2">
                        <option value="出勤">出勤</option>
                        <option value="在宅">在宅</option>
                        <option value="出張">出張</option>
                        <option value="休暇">休暇</option>
                      </select>
                      <button type="submit" class="btn btn-teal w-100">
                        <i class="bi bi-box-arrow-in-right"></i> 出勤する
                      </button>
                    </form>
                  </c:when>

                  <%-- 출근했고 아직 퇴근 안 함 --%>
                  <c:when test="${not today.checkedOut}">
                    <form method="post" action="${cp}/pages/attendanceCheck.do"
                          onsubmit="return confirm('退勤を記録しますか？');">
                      <input type="hidden" name="mode" value="out">
                      <div class="mb-2">
                        <span class="badge-normal"><c:out value="${today.work_type}"/></span>
                      </div>
                      <button type="submit" class="btn btn-outline-teal w-100">
                        <i class="bi bi-box-arrow-right"></i> 退勤する
                      </button>
                    </form>
                  </c:when>

                  <%-- 퇴근까지 완료 --%>
                  <c:otherwise>
                    <div class="text-muted small">
                      <i class="bi bi-check-circle text-success fs-4 d-block mb-1"></i>
                      本日の勤怠は記録済みです
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>

            </div>
          </div>
        </div>

        <%-- ==================== 월간 통계 ==================== --%>
        <div class="row g-3 mb-3">
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">勤務日数</div>
              <div class="fs-4 fw-bold">${workDays}<span class="fs-6 fw-normal">日</span></div>
            </div>
          </div>
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">総勤務時間</div>
              <div class="fs-4 fw-bold">${workHours}<span class="fs-6 fw-normal">時間</span></div>
            </div>
          </div>
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">遅刻</div>
              <div class="fs-4 fw-bold ${lateCount > 0 ? 'text-danger' : ''}">
                ${lateCount}<span class="fs-6 fw-normal">回</span>
              </div>
            </div>
          </div>
        </div>

        <%-- ==================== 월간 기록 ==================== --%>
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-calendar3"></i> ${year}年 ${month}月の勤怠記録</h5>
            <div class="d-flex gap-2">
              <a href="${cp}/pages/attendance.do?ym=${prevMonth}"
                 class="btn btn-outline-secondary btn-sm" aria-label="前の月">
                <i class="bi bi-chevron-left"></i>
              </a>
              <a href="${cp}/pages/attendance.do" class="btn btn-outline-secondary btn-sm">今月</a>
              <a href="${cp}/pages/attendance.do?ym=${nextMonth}"
                 class="btn btn-outline-secondary btn-sm" aria-label="次の月">
                <i class="bi bi-chevron-right"></i>
              </a>
            </div>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:130px;">日付</th>
                  <th style="width:100px;" class="text-center">出勤</th>
                  <th style="width:100px;" class="text-center">退勤</th>
                  <th style="width:130px;" class="text-center">勤務時間</th>
                  <th style="width:100px;" class="text-center">区分</th>
                  <th>備考</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="att" items="${attendanceList}">
                  <tr>
                    <td>${att.work_date}</td>
                    <td class="text-center">
                      <c:out value="${empty att.in_time ? '-' : att.in_time}"/>
                      <c:if test="${att.late}">
                        <span class="text-danger small">遅</span>
                      </c:if>
                    </td>
                    <td class="text-center">
                      <c:out value="${empty att.out_time ? '-' : att.out_time}"/>
                    </td>
                    <td class="text-center"><c:out value="${att.workTimeText}"/></td>
                    <td class="text-center">
                      <span class="badge-normal"><c:out value="${att.work_type}"/></span>
                    </td>
                    <td><c:out value="${att.note}"/></td>
                  </tr>
                </c:forEach>

                <c:if test="${empty attendanceList}">
                  <tr>
                    <td colspan="6" class="text-center py-4">
                      <span class="text-muted small">この月の勤怠記録はありません。</span>
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
