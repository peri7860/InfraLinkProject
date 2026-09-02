<!-- =====================================================================
     components/sidebar.html
     - 서브 페이지(공지/게시판/일정/사원/결재 등)에서 공통으로 쓰는 좌측 메뉴
     - common.js 의 loadComponent() 가 #sidebar-placeholder 에 삽입한다
     - 현재 위치는 body 태그의 data-page 값을 읽어 active 클래스를 부여한다 (main.js)
     ===================================================================== -->
     <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<nav class="panel sidebar-menu">
  <div class="panel-header">
    <h5><i class="bi bi-list-ul"></i>業務メニュー</h5>
  </div>
  <div class="list-group list-group-flush">
    <a href="../pages/notice-list.jsp" data-nav-match="notice" class="list-group-item list-group-item-action"><i class="bi bi-megaphone me-2"></i>お知らせ</a>
    <a href="../pages/board-list.jsp" data-nav-match="board" class="list-group-item list-group-item-action"><i class="bi bi-clipboard2-data me-2"></i>掲示板</a>
    <a href="../pages/schedule.jsp" data-nav-match="schedule" class="list-group-item list-group-item-action"><i class="bi bi-calendar3 me-2"></i>スケジュール</a>
    <a href="../pages/approval.jsp" data-nav-match="approval" class="list-group-item list-group-item-action"><i class="bi bi-file-earmark-check me-2"></i>電子決裁</a>
    <a href="../pages/attendance.jsp" data-nav-match="attendance" class="list-group-item list-group-item-action"><i class="bi bi-clock-history me-2"></i>勤怠管理</a>
    <a href="../pages/room-reserve.jsp" data-nav-match="room-reserve" class="list-group-item list-group-item-action"><i class="bi bi-door-open me-2"></i>会議室予約</a>
    <a href="../pages/employee-list.jsp" data-nav-match="employee" class="list-group-item list-group-item-action"><i class="bi bi-people me-2"></i>社員検索</a>
    <a href="../pages/messenger.jsp" data-nav-match="messenger" class="list-group-item list-group-item-action"><i class="bi bi-chat-dots me-2"></i>メッセンジャー</a>
    <a href="../pages/mypage.jsp" data-nav-match="mypage" class="list-group-item list-group-item-action"><i class="bi bi-person-gear me-2"></i>マイページ</a>
  </div>
</nav>
