<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>電子決裁 | InfraLink</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="approval">
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-file-earmark-check"></i> 電子決裁</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">電子決裁</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <!-- ==================== 결재 현황 요약 ==================== -->
        <div class="row g-3 mb-4">
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">決裁待ち</div>
              <div class="fs-4 fw-bold" style="color:#9a6b00;">3</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">進行中</div>
              <div class="fs-4 fw-bold" style="color:#1d5fc2;">2</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">承認完了</div>
              <div class="fs-4 fw-bold" style="color:#1e7b45;">18</div>
            </div>
          </div>
          <div class="col-6 col-md-3">
            <div class="panel text-center py-3">
              <div class="text-muted small mb-1">差し戻し</div>
              <div class="fs-4 fw-bold" style="color:#b23b3b;">1</div>
            </div>
          </div>
        </div>

        <div class="filter-bar">
          <select class="form-select form-select-sm" style="width:150px;">
            <option selected>全ステータス</option>
            <option>決裁待ち</option>
            <option>進行中</option>
            <option>承認完了</option>
            <option>差し戻し</option>
          </select>
          <select class="form-select form-select-sm" style="width:150px;">
            <option selected>全文書種類</option>
            <option>休暇申請書</option>
            <option>出張報告書</option>
            <option>購買申請書</option>
            <option>在宅勤務申請書</option>
          </select>
          <a href="#" class="btn btn-teal btn-sm ms-auto"><i class="bi bi-file-earmark-plus"></i> 新規決裁申請</a>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-list-ul"></i> 決裁文書一覧</h5>
          </div>
          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:60px;" class="text-center">No</th>
                  <th>文書名</th>
                  <th style="width:120px;" class="text-center">起案者</th>
                  <th style="width:130px;" class="text-center">決裁者</th>
                  <th style="width:110px;" class="text-center">起案日</th>
                  <th style="width:100px;" class="text-center">ステータス</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="text-center">1032</td>
                  <td>年次休暇申請書</td>
                  <td class="text-center">山田 太郎</td>
                  <td class="text-center">佐藤 部長</td>
                  <td class="text-center">2026.08.13</td>
                  <td class="text-center"><span class="status-pill status-wait">決裁待ち</span></td>
                </tr>
                <tr>
                  <td class="text-center">1031</td>
                  <td>出張報告書（大阪出張）</td>
                  <td class="text-center">鈴木 一郎</td>
                  <td class="text-center">田中 課長</td>
                  <td class="text-center">2026.08.12</td>
                  <td class="text-center"><span class="status-pill status-progress">進行中</span></td>
                </tr>
                <tr>
                  <td class="text-center">1030</td>
                  <td>備品購入申請書（モニター2台）</td>
                  <td class="text-center">高橋 直子</td>
                  <td class="text-center">佐藤 部長</td>
                  <td class="text-center">2026.08.11</td>
                  <td class="text-center"><span class="status-pill status-done">承認完了</span></td>
                </tr>
                <tr>
                  <td class="text-center">1029</td>
                  <td>在宅勤務申請書</td>
                  <td class="text-center">田中 誠</td>
                  <td class="text-center">佐藤 部長</td>
                  <td class="text-center">2026.08.10</td>
                  <td class="text-center"><span class="status-pill status-wait">決裁待ち</span></td>
                </tr>
                <tr>
                  <td class="text-center">1028</td>
                  <td>経費精算書（8月分交通費）</td>
                  <td class="text-center">伊藤 健</td>
                  <td class="text-center">田中 課長</td>
                  <td class="text-center">2026.08.09</td>
                  <td class="text-center"><span class="status-pill status-reject">差し戻し</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div class="pagination-wrap">
          <ul class="pagination">
            <li class="page-item disabled"><a class="page-link" href="#">前へ</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">次へ</a></li>
          </ul>
        </div>
      </section>
    </div>
  </div>
</div>

<div id="footer-placeholder"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="../js/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ include file="../components/footer.jsp"%>
