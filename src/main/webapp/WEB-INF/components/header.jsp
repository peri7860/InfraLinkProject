<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  =====================================================================
  공통 헤더 (fragment)

  [수정] 2026-09-07

  변경 전의 문제
    1) 사용자 이름이 "山田 太郎" 로 하드코딩되어 있었다.
       (세션을 참조하는 JSP 가 프로젝트 전체에 한 개도 없었다)
    2) 알림 개수가 "3" 으로 하드코딩되어 있었다.
    3) "ログアウト" 링크가 로그인 화면으로 이동만 했다.
       세션을 없애는 코드가 없어 뒤로가기 한 번이면 다시 로그인 상태였다.
       → /pages/logout.do (LogoutService) 로 연결.
    4) 파일 앞머리에 HTML 주석이 있고 그 뒤에 page 지시자가 있었다.
       → 지시자를 맨 위로 올렸다.

  참고 : 이 파일은 <%@ include %> 로 25개 화면에 정적 포함된다.
         포함하는 쪽에서 taglib 을 선언한 경우와 충돌하지 않도록
         JSTL 태그 대신 EL 만 사용한다.
  =====================================================================
--%>
<header class="site-header">

  <%-- ==================== 상단 유틸 바 ==================== --%>
  <div class="top-util">
    <div class="container">

      <%-- 로그인 사용자 이름. 세션이 없으면 "ゲスト" --%>
      <span class="user-name">
        <i class="bi bi-person-circle"></i>
        ${empty loginUser ? 'ゲスト' : loginUser.emp_name} さん
        <%-- 관리자면 배지를 하나 더 붙인다 --%>
        <span class="badge bg-light text-dark ms-1"
              style="display:${not empty loginUser and loginUser.admin ? 'inline-block' : 'none'}">管理者</span>
      </span>

      <a href="${pageContext.request.contextPath}/pages/notifications.do"
         class="notification-link" aria-label="通知">
        <i class="bi bi-bell"></i>
        <%--
          미읽음 개수는 NotificationListService 가 unreadCount 로 넘겨준다.
          아직 값이 없으면 배지를 숨긴다.
          (기존에는 "3" 이 항상 박혀 있었다)
        --%>
        <span class="notification-count" data-notification-count
              style="display:${empty unreadCount or unreadCount == 0 ? 'none' : 'inline-block'}">
          ${empty unreadCount ? 0 : unreadCount}
        </span>
      </a>

      <span class="divider">|</span>

      <a href="${pageContext.request.contextPath}/pages/mypage.do">
        <i class="bi bi-person-gear"></i> マイページ
      </a>

      <%--
        관리자에게만 관리자 메뉴를 보여준다.
        화면에서 숨기는 것은 편의일 뿐이고, 실제 차단은 AdminFilter 가 한다.
      --%>
      <a href="${pageContext.request.contextPath}/pages/admin-dashboard.do"
         style="display:${not empty loginUser and loginUser.admin ? 'inline' : 'none'}">
        <i class="bi bi-shield-lock"></i> 管理者
      </a>

      <%--
        로그아웃 : 세션을 실제로 폐기하는 LogoutService 로 보낸다.
        [수정] 기존에는 login.do 로 이동만 해서 세션이 남아 있었다.
      --%>
      <a href="${pageContext.request.contextPath}/pages/logout.do">
        <i class="bi bi-box-arrow-right"></i> ログアウト
      </a>
    </div>
  </div>

  <%-- ==================== 로고 + 메인 내비게이션 ==================== --%>
  <nav class="navbar navbar-expand-lg py-2">
    <div class="container">
      <a href="${pageContext.request.contextPath}/index.do" class="logo">Infra<span>Link</span></a>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
              data-bs-target="#mainNav" style="border-color:rgba(255,255,255,.3);"
              aria-label="メニューを開く">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse justify-content-end" id="mainNav">
        <ul class="navbar-nav main-nav gap-1 align-items-lg-center">
          <li class="nav-item">
            <a class="nav-link" data-nav-match="notice"
               href="${pageContext.request.contextPath}/pages/notice.do">
              <i class="bi bi-megaphone"></i>お知らせ
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-nav-match="board"
               href="${pageContext.request.contextPath}/pages/board.do">
              <i class="bi bi-clipboard2-data"></i>掲示板
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-nav-match="schedule"
               href="${pageContext.request.contextPath}/pages/schedule.do">
              <i class="bi bi-calendar3"></i>スケジュール
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-nav-match="employee"
               href="${pageContext.request.contextPath}/pages/employee.do">
              <i class="bi bi-people"></i>社員検索
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-nav-match="messenger"
               href="${pageContext.request.contextPath}/pages/messenger.do">
              <i class="bi bi-chat-dots"></i>メッセンジャー
            </a>
          </li>
          <li class="nav-item">
            <button type="button" class="nav-link border-0"
                    style="background:rgba(255,255,255,.08);"
                    data-bs-toggle="modal" data-bs-target="#quickMenuModal">
              <i class="bi bi-grid-3x3-gap-fill"></i>クイックメニュー
            </button>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
