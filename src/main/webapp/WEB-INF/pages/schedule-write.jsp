<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  일정 등록 / 수정

  [수정] 2026-09-07
    변경 전 : 이 파일만 전체가 3줄로 압축(한 줄 2555자)되어 있어
              읽지도 고치지도 못하는 상태였다.
              폼에 action / name 이 없고 등록 버튼도 type="button" 이라
              아무 동작을 하지 않았다.
    변경 후 : 사람이 읽을 수 있는 형식으로 되돌리고
              ScheduleWriteService 로 POST 한다. 등록·수정 겸용.

  날짜/시각은 date + time 입력을 나눠 받아 서버에서 합친다.
  (브라우저의 datetime-local 은 브라우저별 지원 편차가 있어 피했다)
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<%-- 수정 모드일 때 기존 값에서 날짜/시각을 분리해 둔다 --%>
<c:if test="${editMode}">
  <c:set var="startDate" value="${fn:substring(schedule.start_time, 0, 10)}"/>
  <c:set var="startTime" value="${fn:substring(schedule.start_time, 11, 16)}"/>
  <c:set var="endDate"   value="${fn:substring(schedule.end_time, 0, 10)}"/>
  <c:set var="endTime"   value="${fn:substring(schedule.end_time, 11, 16)}"/>
</c:if>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${editMode ? '予定編集' : '予定登録'} | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="schedule">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-calendar-plus"></i> ${editMode ? '予定編集' : '予定登録'}</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/schedule.do">スケジュール</a></li>
        <li class="breadcrumb-item active" aria-current="page">${editMode ? '編集' : '登録'}</li>
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
              <i class="bi bi-pencil-square"></i>
              ${editMode ? '予定の編集' : '新しい予定を登録'}
            </h5>
            <span class="small text-muted">* 必須項目</span>
          </div>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
              <i class="bi bi-exclamation-circle"></i> <c:out value="${errorMessage}"/>
            </div>
          </c:if>

          <form class="form-panel" method="post" action="${cp}/pages/schedule-write.do">

            <c:if test="${editMode}">
              <input type="hidden" name="no" value="${schedule.schedule_no}">
            </c:if>

            <div class="row g-3">

              <div class="col-12">
                <label class="form-label" for="scTitle">
                  タイトル <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="scTitle" name="title"
                       maxlength="300" required
                       placeholder="例：営業部 定例ミーティング"
                       value="<c:out value='${schedule.title}'/>">
              </div>

              <div class="col-md-6">
                <label class="form-label">開始日時 <span class="text-danger">*</span></label>
                <div class="input-group">
                  <input type="date" class="form-control" name="start_date" required
                         value="${startDate}">
                  <input type="time" class="form-control" name="start_time"
                         value="${empty startTime ? '09:00' : startTime}">
                </div>
              </div>

              <div class="col-md-6">
                <label class="form-label">終了日時</label>
                <div class="input-group">
                  <input type="date" class="form-control" name="end_date"
                         value="${endDate}">
                  <input type="time" class="form-control" name="end_time"
                         value="${empty endTime ? '10:00' : endTime}">
                </div>
                <div class="form-text">未入力の場合は開始日時と同じになります。</div>
              </div>

              <div class="col-md-6">
                <label class="form-label" for="scLocation">場所 / 会議URL</label>
                <input type="text" class="form-control" id="scLocation" name="location"
                       maxlength="200" placeholder="例：第1会議室 または URL"
                       value="<c:out value='${schedule.location}'/>">
              </div>

              <div class="col-md-6">
                <label class="form-label" for="scVisibility">
                  公開範囲 <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="scVisibility" name="visibility">
                  <c:set var="vis" value="${empty schedule.visibility ? 'PRIVATE' : schedule.visibility}"/>
                  <option value="PRIVATE" ${vis eq 'PRIVATE' ? 'selected' : ''}>個人（自分のみ）</option>
                  <option value="DEPT"    ${vis eq 'DEPT'    ? 'selected' : ''}>部署</option>
                  <option value="ALL"     ${vis eq 'ALL'     ? 'selected' : ''}>全社</option>
                </select>
              </div>

              <div class="col-12">
                <label class="form-label" for="scContent">詳細</label>
                <textarea class="form-control" id="scContent" name="content" rows="6"
                          maxlength="2000"
                          placeholder="予定の内容や補足を入力してください。"><c:out value="${schedule.content}"/></textarea>
              </div>

            </div>

            <div class="form-actions">
              <a href="${cp}/pages/schedule.do" class="btn btn-outline-secondary px-4">
                キャンセル
              </a>
              <%-- [수정] 기존에는 type="button" 이라 눌러도 전송되지 않았다 --%>
              <button type="submit" class="btn btn-teal px-4">
                ${editMode ? '修正する' : '登録する'}
              </button>
            </div>
          </form>
        </div>
      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<script src="${cp}/js/schedule.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
