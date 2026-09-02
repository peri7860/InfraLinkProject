<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>お知らせ詳細 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="notice">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>
<%@ include file="../../components/header.jsp"%>
<%@ include file="../../components/modal.jsp"%>
<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-megaphone"></i> お知らせ</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item"><a href="notice-list.html">お知らせ</a></li>
        <li class="breadcrumb-item active" aria-current="page">詳細</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel">
          <div class="view-header">
            <span class="badge-fixed mb-2 d-inline-block">重要</span>
            <h2>2026年 夏季休暇および勤務制度のご案内</h2>
            <div class="view-meta">
              <span><i class="bi bi-person"></i> 人事部</span>
              <span><i class="bi bi-calendar3"></i> 2026.08.12</span>
              <span><i class="bi bi-eye"></i> 閲覧 312</span>
            </div>
          </div>
          <div class="view-body">
            <p>社員各位</p>
            <p>お疲れ様です。人事部です。<br>
            2026年度 夏季休暇制度および期間中の勤務ルールについて、下記の通りご案内いたします。</p>
            <p>
              1. 夏季休暇期間：2026年8月17日（月）〜8月21日（金）<br>
              2. 対象：全正社員（契約社員は所属長にご確認ください）<br>
              3. 休暇期間中も緊急連絡網は稼働しますので、担当業務の引き継ぎを事前にお願いいたします。<br>
              4. 休暇申請は電子決裁システムより8月14日（金）までに提出してください。
            </p>
            <p>ご不明な点がございましたら、人事部（内線120）までお問い合わせください。</p>
            <p>よろしくお願いいたします。</p>
          </div>
          <div class="px-3 pb-3">
            <div class="border rounded p-2 small text-muted" style="background:#f7f9fa;">
              <i class="bi bi-paperclip"></i> 添付ファイル : 2026年_夏季休暇制度案内.pdf
            </div>
          </div>
          <div class="view-footer">
            <a href="notice-list.html" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list"></i> 一覧に戻る</a>
            <div class="d-flex gap-2">
              <a href="notice-write.html" class="btn btn-outline-teal btn-sm"><i class="bi bi-pencil"></i> 編集</a>
              <button type="button" class="btn btn-sm text-white" style="background:var(--warn);" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal"><i class="bi bi-trash"></i> 削除</button>
            </div>
          </div>
        </div>

        <!-- ==================== 이전글/다음글 ==================== -->
        <div class="panel mt-3">
          <a href="notice-view.html?no=25" class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom text-decoration-none" style="color:var(--ink);">
            <span><i class="bi bi-chevron-up text-teal me-2"></i>次の記事</span>
            <span class="text-truncate" style="max-width:60%;">社内システム定期点検のお知らせ（8/16 2:00〜5:00）</span>
          </a>
          <a href="notice-view.html?no=23" class="d-flex justify-content-between align-items-center px-3 py-2 text-decoration-none" style="color:var(--ink);">
            <span><i class="bi bi-chevron-down text-teal me-2"></i>前の記事</span>
            <span class="text-truncate" style="max-width:60%;">第3四半期 社内サークル支援金申請のご案内</span>
          </a>
        </div>
      </section>
    </div>
  </div>
</div>

<div id="footer-placeholder"></div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="../js/common.js"></script>
<script src="../js/notice.js"></script>
</body>
<%@ include file="../../components/footer.jsp"%>
</html>
