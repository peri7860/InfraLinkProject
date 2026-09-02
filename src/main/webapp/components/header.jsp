<!-- =====================================================================
     components/header.html
     - 모든 페이지 공통 헤더 (fragment)
     - common.js 의 loadComponent() 가 #header-placeholder 에 삽입한다
     - href 안의 {{BASE}} 는 삽입 시점에 실제 상대경로로 치환된다
       (index.html 에서는 '', pages/*.html 에서는 '../')
     ===================================================================== -->
     <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<header class="site-header">

  <!-- ==================== 상단 유틸 바 : 로그인/마이페이지/로그아웃 ==================== -->
  <div class="top-util">
    <div class="container">
      <span class="user-name"><i class="bi bi-person-circle"></i> 山田 太郎 さん</span>
      <span class="divider">|</span>
      <a href="{{BASE}}pages/mypage.html"><i class="bi bi-person-gear"></i> マイページ</a>
      <a href="{{BASE}}pages/login.html"><i class="bi bi-box-arrow-right"></i> ログアウト</a>
    </div>
  </div>

  <!-- ==================== 로고 + 메인 내비게이션 ==================== -->
  <nav class="navbar navbar-expand-lg py-2">
    <div class="container">
      <a href="{{BASE}}index.html" class="logo">Infra<span>Link</span></a>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" style="border-color:rgba(255,255,255,.3);" aria-label="メニューを開く">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse justify-content-end" id="mainNav">
        <ul class="navbar-nav main-nav gap-1 align-items-lg-center">
          <li class="nav-item"><a class="nav-link" data-nav-match="notice" href="../pages/notice-list.jsp"><i class="bi bi-megaphone"></i>お知らせ</a></li>
          <li class="nav-item"><a class="nav-link" data-nav-match="board" href="../pages/board-list.jsp"><i class="bi bi-clipboard2-data"></i>掲示板</a></li>
          <li class="nav-item"><a class="nav-link" data-nav-match="schedule" href="../pages/schedule.jsp"><i class="bi bi-calendar3"></i>スケジュール</a></li>
          <li class="nav-item"><a class="nav-link" data-nav-match="employee" href="../pages/employee-list.jsp"><i class="bi bi-people"></i>社員検索</a></li>
          <li class="nav-item"><a class="nav-link" data-nav-match="messenger" href="../pages/messenger.jsp"><i class="bi bi-chat-dots"></i>メッセンジャー</a></li>
          <li class="nav-item">
            <button type="button" class="nav-link border-0" style="background:rgba(255,255,255,.08);" data-bs-toggle="modal" data-bs-target="#quickMenuModal">
              <i class="bi bi-grid-3x3-gap-fill"></i>クイックメニュー
            </button>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</header>
