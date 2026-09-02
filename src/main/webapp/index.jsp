<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>InfraLink | 社内イントラネット</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<!-- Google Fonts : Noto Sans JP (일본어 UI 기본 폰트) -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<!-- 공통 CSS (분리된 파일) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<!-- data-page="home" : common.js 가 현재 메뉴를 표시할 때 사용 (메인은 대상 메뉴 없음) -->
<body data-page="index">
<%@ include file="WEB-INF/components/header.jsp" %>

<%@ include file="WEB-INF/components/modal.jsp" %>

<!-- ==================== 메인비주얼 : 퀵메뉴 ==================== -->
<section class="quick-section">
  <div class="container">
    <div class="d-flex justify-content-between align-items-end flex-wrap mb-2">
      <h2 class="mb-0">よく使う業務</h2>
      <span class="lead-text">業務にすぐアクセスできるショートカットメニューです</span>
    </div>
    <div class="row row-cols-3 row-cols-md-4 row-cols-lg-6 g-3">
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/attendance.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-clock-history"></i></div>
          <span>勤怠管理</span>
        </a>
      </div>
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/approval.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-file-earmark-check"></i></div>
          <span>電子決裁</span>
        </a>
      </div>
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/employee.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-diagram-3"></i></div>
          <span>組織図</span>
        </a>
      </div>
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/room.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-door-open"></i></div>
          <span>会議室予約</span>
        </a>
      </div>
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/schedule.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-calendar3"></i></div>
          <span>スケジュール</span>
        </a>
      </div>
      <div class="col">
        <a href="${pageContext.request.contextPath}/pages/messenger.do" class="quick-btn">
          <div class="icon-wrap"><i class="bi bi-chat-dots"></i></div>
          <span>メッセンジャー</span>
        </a>
      </div>
    </div>
  </div>
</section>

<!-- ==================== 컨텐츠 영역 ==================== -->
<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">

      <!-- ---------- お知らせ (메인 컨텐츠) ---------- -->
      <section class="col-lg-8">
        <div class="panel mb-4">
          <div class="panel-header">
            <h5><i class="bi bi-megaphone"></i> お知らせ</h5>
            <a href="${pageContext.request.contextPath}/pages/notice.do" class="panel-link">すべて見る <i class="bi bi-chevron-right"></i></a>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:70px;" class="text-center">区分</th>
                  <th>タイトル</th>
                  <th style="width:110px;" class="text-center">作成者</th>
                  <th style="width:100px;" class="text-center">登録日</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="text-center"><span class="badge-fixed">重要</span></td>
                  <td><a href="../pages/notice-view.jsp?no=1" class="title-link">2026年 夏季休暇および勤務制度のご案内</a></td>
                  <td class="text-center">人事部</td>
                  <td class="text-center">2026.08.12</td>
                </tr>
                <tr>
                  <td class="text-center"><span class="badge-fixed">重要</span></td>
                  <td><a href="../pages/notice-view.jsp?no=2" class="title-link">社内システム定期点検のお知らせ（8/16 2:00〜5:00）</a></td>
                  <td class="text-center">IT支援部</td>
                  <td class="text-center">2026.08.11</td>
                </tr>
                <tr>
                  <td class="text-center"><span class="badge-normal">一般</span></td>
                  <td><a href="../pages/notice-view.jsp?no=3" class="title-link">第3四半期 社内サークル支援金申請のご案内</a></td>
                  <td class="text-center">総務部</td>
                  <td class="text-center">2026.08.10</td>
                </tr>
                <tr>
                  <td class="text-center"><span class="badge-normal">一般</span></td>
                  <td><a href="../pages/notice-view.jsp?no=4" class="title-link">新入社員オリエンテーション日程のお知らせ</a></td>
                  <td class="text-center">人事部</td>
                  <td class="text-center">2026.08.08</td>
                </tr>
                <tr>
                  <td class="text-center"><span class="badge-normal">一般</span></td>
                  <td><a href="../pages/notice-view.jsp?no=5" class="title-link">本社駐車場利用案内の変更事項</a></td>
                  <td class="text-center">総務部</td>
                  <td class="text-center">2026.08.07</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- ---------- 이번주 스케줄 위젯 ---------- -->
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-calendar3"></i> 今週のスケジュール</h5>
            <a href="../pages/schedule.jsp" class="panel-link">すべて見る <i class="bi bi-chevron-right"></i></a>
          </div>
          <div class="cal-widget">
            <div class="cal-item">
              <div class="cal-date">8/13</div>
              <div>週次チーム定例会議 <span class="text-muted">・ 10:00 ・ 3階 大会議室</span></div>
            </div>
            <div class="cal-item">
              <div class="cal-date">8/14</div>
              <div>第2四半期 実績報告 <span class="text-muted">・ 14:00 ・ 役員会議室</span></div>
            </div>
            <div class="cal-item">
              <div class="cal-date">8/15</div>
              <div>新規プロジェクト キックオフミーティング <span class="text-muted">・ 16:00 ・ 2階 セミナー室</span></div>
            </div>
          </div>
        </div>
      </section>

      <!-- ---------- 사이드 섹션 ---------- -->
      <aside class="col-lg-4">
        <!-- 오늘의 식단 -->
        <div class="panel widget">
          <div class="panel-header">
            <h5><i class="bi bi-cup-hot"></i> 今日の食堂メニュー</h5>
            <span class="text-muted" style="font-size:.78rem;">08/13（木）</span>
          </div>
          <div class="meal-list">
            <div class="meal-item"><span><span class="meal-tag">昼食</span>豚肉炒め定食</span><span class="text-muted">11:30〜13:30</span></div>
            <div class="meal-item"><span><span class="meal-tag">昼食</span>ビビン麺 &amp; 茶碗蒸し</span><span class="text-muted">11:30〜13:30</span></div>
            <div class="meal-item"><span><span class="meal-tag">夕食</span>提供なし</span><span class="text-muted">-</span></div>
          </div>
        </div>

        <!-- 전자결재 현황 -->
        <div class="panel widget">
          <div class="panel-header">
            <h5><i class="bi bi-file-earmark-check"></i> 電子決裁の状況</h5>
            <a href="../pages/approval.jsp" class="panel-link">すべて見る <i class="bi bi-chevron-right"></i></a>
          </div>
          <div class="approval-list">
            <div class="approval-item">
              <span>年次休暇申請書</span>
              <span class="status-pill status-wait">決裁待ち</span>
            </div>
            <div class="approval-item">
              <span>出張報告書</span>
              <span class="status-pill status-progress">進行中</span>
            </div>
            <div class="approval-item">
              <span>備品購入申請書</span>
              <span class="status-pill status-done">承認完了</span>
            </div>
            <div class="approval-item">
              <span>在宅勤務申請書</span>
              <span class="status-pill status-wait">決裁待ち</span>
            </div>
          </div>
        </div>

        <!-- 임직원 검색 -->
        <div class="panel widget">
          <div class="panel-header">
            <h5><i class="bi bi-person-lines-fill"></i> 社員検索</h5>
          </div>
          <div class="emp-search-widget">
            <form class="d-flex gap-2" action="pages/employee-list.html" method="get">
              <input type="text" class="form-control form-control-sm" placeholder="名前または部署で検索" name="keyword">
              <button class="btn btn-sm btn-teal" type="submit">
                <i class="bi bi-search"></i>
              </button>
            </form>
          </div>
        </div>
      </aside>
    </div>
  </div>
</div>

<!-- ==================== Footer (components/footer.html 을 JS로 삽입) ==================== -->
<%@ include file="/WEB-INF/components/footer.jsp" %>
<!-- Bootstrap 5 JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<!-- 공통 컴포넌트 로더 -->
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<!-- 메인 페이지 전용 스크립트 -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>

</html>
