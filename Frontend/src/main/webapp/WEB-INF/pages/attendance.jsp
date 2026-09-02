<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<%@ include file="../../components/header.jsp"%>
<%@ include file="../../components/modal.jsp"%>
<body data-page="attendance">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>
<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-clock-history"></i> 勤怠管理</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">勤怠管理</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
     
        <!-- ==================== 오늘의 출퇴근 체크 ==================== -->
        <div class="panel mb-4">
        
          <div class="panel-header">
            <h5><i class="bi bi-fingerprint"></i> 本日の勤怠</h5>
            <span class="text-muted" style="font-size:.8rem;">2026.08.15（土）</span>
          </div>
          <div class="panel-body d-flex flex-wrap gap-4 align-items-center">
            <div>
              <div class="text-muted small">出勤時刻</div>
              <div class="fs-5 fw-bold text-teal">09:02</div>
            </div>
            <div>
              <div class="text-muted small">退勤時刻</div>
              <div class="fs-5 fw-bold text-muted">--:--</div>
            </div>
            <div class="ms-auto d-flex gap-2">
              <button class="btn btn-teal btn-sm" disabled><i class="bi bi-box-arrow-in-right"></i> 出勤済み</button>
              <button class="btn btn-outline-teal btn-sm"><i class="bi bi-box-arrow-right"></i> 退勤する</button>
            </div>
          </div>
        </div>

        <!-- ==================== 이번 달 요약 ==================== -->
        <div class="row g-3 mb-4">
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">出勤日数</div>
              <div class="fs-4 fw-bold text-teal">11</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">遅刻</div>
              <div class="fs-4 fw-bold" style="color:#b23b3b;">1</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">早退</div>
              <div class="fs-4 fw-bold" style="color:#9a6b00;">0</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">残り年次休暇</div>
              <div class="fs-4 fw-bold text-teal">8.5</div>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-calendar-week"></i> 2026年8月 勤怠履歴</h5>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:110px;" class="text-center">日付</th>
                  <th style="width:80px;" class="text-center">曜日</th>
                  <th style="width:100px;" class="text-center">出勤時刻</th>
                  <th style="width:100px;" class="text-center">退勤時刻</th>
                  <th>勤務時間</th>
                  <th style="width:100px;" class="text-center">状態</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="text-center">08/13</td>
                  <td class="text-center">木</td>
                  <td class="text-center">09:00</td>
                  <td class="text-center">18:10</td>
                  <td>9時間10分</td>
                  <td class="text-center"><span class="status-pill status-normal">正常</span></td>
                </tr>
                <tr>
                  <td class="text-center">08/12</td>
                  <td class="text-center">水</td>
                  <td class="text-center">09:24</td>
                  <td class="text-center">18:05</td>
                  <td>8時間41分</td>
                  <td class="text-center"><span class="status-pill status-late">遅刻</span></td>
                </tr>
                <tr>
                  <td class="text-center">08/11</td>
                  <td class="text-center">火</td>
                  <td class="text-center">08:55</td>
                  <td class="text-center">18:02</td>
                  <td>9時間07分</td>
                  <td class="text-center"><span class="status-pill status-normal">正常</span></td>
                </tr>
                <tr>
                  <td class="text-center">08/10</td>
                  <td class="text-center">月</td>
                  <td class="text-center">08:58</td>
                  <td class="text-center">17:55</td>
                  <td>8時間57分</td>
                  <td class="text-center"><span class="status-pill status-normal">正常</span></td>
                </tr>
                <tr>
                  <td class="text-center">08/07</td>
                  <td class="text-center">金</td>
                  <td class="text-center">08:50</td>
                  <td class="text-center">18:00</td>
                  <td>9時間10分</td>
                  <td class="text-center"><span class="status-pill status-normal">正常</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </div>
  </div>
</div>

<div id="footer-placeholder"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="../js/common.js"></script>
</body>
<%@ include file="../../components/footer.jsp"%>
</html>
