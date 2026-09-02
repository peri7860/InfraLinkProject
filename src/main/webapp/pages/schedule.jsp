<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
<style>
  /* 이 페이지 전용 캘린더 그리드는 분량이 작아 공통 CSS에 포함하지 않고 여기서 관리 */
  .cal-grid { border: 1px solid var(--line); border-radius: var(--radius-md); overflow: hidden; }
  .cal-grid table { width: 100%; border-collapse: collapse; }
  .cal-grid th { background: #f7f9fa; font-size: .78rem; color: var(--ink-soft); padding: .6rem 0; text-align: center; border-bottom: 1px solid var(--line); }
  .cal-grid td { width: 14.28%; height: 92px; vertical-align: top; padding: .4rem; border: 1px solid var(--line); font-size: .78rem; }
  .cal-grid td .day-num { font-weight: 700; color: var(--ink); font-size: .82rem; }
  .cal-grid td.muted .day-num { color: #c3cad4; }
  .cal-grid td.today { background: var(--teal-tint); }
  .cal-grid .ev { display:block; background: var(--navy); color:#fff; border-radius:4px; padding:.05rem .35rem; font-size:.7rem; margin-top:.25rem; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  .cal-grid .ev.ev-teal { background: var(--teal); }
</style>
</head>
<body data-page="schedule">
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>
<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-calendar3"></i> スケジュール</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">スケジュール</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel mb-4">
          <div class="panel-header">
            <div class="d-flex align-items-center gap-2">
              <button class="btn btn-sm btn-outline-secondary" id="calPrevBtn"><i class="bi bi-chevron-left"></i></button>
              <h5 class="mb-0">2026年 8月</h5>
              <button class="btn btn-sm btn-outline-secondary" id="calNextBtn"><i class="bi bi-chevron-right"></i></button>
            </div>
            <a href="#" class="btn btn-teal btn-sm"><i class="bi bi-plus-lg"></i> 予定登録</a>
          </div>
          <div class="p-3">
            <div class="cal-grid table-scroll">
              <table>
                <thead>
                  <tr>
                    <th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="muted"><span class="day-num">26</span></td>
                    <td class="muted"><span class="day-num">27</span></td>
                    <td class="muted"><span class="day-num">28</span></td>
                    <td class="muted"><span class="day-num">29</span></td>
                    <td class="muted"><span class="day-num">30</span></td>
                    <td class="muted"><span class="day-num">31</span></td>
                    <td><span class="day-num">1</span></td>
                  </tr>
                  <tr>
                    <td><span class="day-num">2</span></td>
                    <td><span class="day-num">3</span><span class="ev">週次定例</span></td>
                    <td><span class="day-num">4</span></td>
                    <td><span class="day-num">5</span></td>
                    <td><span class="day-num">6</span><span class="ev ev-teal">安全教育</span></td>
                    <td><span class="day-num">7</span></td>
                    <td><span class="day-num">8</span></td>
                  </tr>
                  <tr>
                    <td><span class="day-num">9</span></td>
                    <td><span class="day-num">10</span><span class="ev">週次定例</span></td>
                    <td><span class="day-num">11</span></td>
                    <td><span class="day-num">12</span></td>
                    <td><span class="day-num">13</span><span class="ev ev-teal">キックオフMTG</span></td>
                    <td><span class="day-num">14</span></td>
                    <td><span class="day-num">15</span></td>
                  </tr>
                  <tr>
                    <td><span class="day-num">16</span></td>
                    <td><span class="day-num">17</span><span class="ev">夏季休暇開始</span></td>
                    <td><span class="day-num">18</span></td>
                    <td><span class="day-num">19</span></td>
                    <td><span class="day-num">20</span></td>
                    <td><span class="day-num">21</span><span class="ev">夏季休暇終了</span></td>
                    <td><span class="day-num">22</span></td>
                  </tr>
                  <tr>
                    <td><span class="day-num">23</span></td>
                    <td><span class="day-num">24</span><span class="ev">週次定例</span></td>
                    <td><span class="day-num">25</span></td>
                    <td><span class="day-num">26</span></td>
                    <td><span class="day-num">27</span></td>
                    <td><span class="day-num">28</span></td>
                    <td><span class="day-num">29</span></td>
                  </tr>
                  <tr>
                    <td><span class="day-num">30</span></td>
                    <td><span class="day-num">31</span></td>
                    <td class="muted"><span class="day-num">1</span></td>
                    <td class="muted"><span class="day-num">2</span></td>
                    <td class="muted"><span class="day-num">3</span></td>
                    <td class="muted"><span class="day-num">4</span></td>
                    <td class="muted"><span class="day-num">5</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- ==================== 이번주 일정 리스트 ==================== -->
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-list-ul"></i> 今週の予定一覧</h5>
          </div>
          <div class="cal-widget">
            <div class="cal-item">
              <div class="cal-date">8/13</div>
              <div>週次チーム定例会議 <span class="text-muted">・ 10:00〜11:00 ・ 3階 大会議室</span></div>
            </div>
            <div class="cal-item">
              <div class="cal-date">8/14</div>
              <div>第2四半期 実績報告 <span class="text-muted">・ 14:00〜15:30 ・ 役員会議室</span></div>
            </div>
            <div class="cal-item">
              <div class="cal-date">8/15</div>
              <div>新規プロジェクト キックオフミーティング <span class="text-muted">・ 16:00〜17:00 ・ 2階 セミナー室</span></div>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</div>

<div id="footer-placeholder"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="../js/common.js"></script>
<script src="../js/schedule.js"></script>
</body>
<%@ include file="../components/footer.jsp"%>
</html>
