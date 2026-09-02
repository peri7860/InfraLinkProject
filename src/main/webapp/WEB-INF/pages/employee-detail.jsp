<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員詳細 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="employee">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>
<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-people"></i> 社員検索</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item"><a href="employee-list.html">社員検索</a></li>
        <li class="breadcrumb-item active" aria-current="page">詳細</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="row g-4">
          <!-- ==================== 프로필 카드 ==================== -->
          <div class="col-md-4">
            <div class="panel text-center p-4">
              <div class="employee-card avatar" style="width:96px;height:96px;font-size:2rem;">佐</div>
              <h5 class="mt-3 mb-0">佐藤 花子</h5>
              <p class="text-muted small mb-2">開発部 ・ 課長</p>
              <span class="status-pill status-normal">在籍中</span>
              <hr>
              <a href="../pages/messenger.html" class="btn btn-teal btn-sm w-100 mb-2"><i class="bi bi-chat-dots"></i> メッセージを送る</a>
              <a href="tel:0312340212" class="btn btn-outline-teal btn-sm w-100"><i class="bi bi-telephone"></i> 内線 212 に発信</a>
            </div>
          </div>

          <!-- ==================== 상세 정보 ==================== -->
          <div class="col-md-8">
            <div class="panel">
              <div class="panel-header">
                <h5><i class="bi bi-person-vcard"></i> 基本情報</h5>
              </div>
              <div class="panel-body">
                <table class="table table-borderless mb-0" style="font-size:.9rem;">
                  <tbody>
                    <tr><th class="text-muted" style="width:140px;">社員番号</th><td>DEV-2021-014</td></tr>
                    <tr><th class="text-muted">部署</th><td>開発部 / プラットフォームチーム</td></tr>
                    <tr><th class="text-muted">役職</th><td>課長</td></tr>
                    <tr><th class="text-muted">入社日</th><td>2021年4月1日</td></tr>
                    <tr><th class="text-muted">内線番号</th><td>212</td></tr>
                    <tr><th class="text-muted">メールアドレス</th><td>h.sato@infralink.co.jp</td></tr>
                    <tr><th class="text-muted">座席</th><td>3階 開発フロア C-12</td></tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="panel mt-4">
              <div class="panel-header">
                <h5><i class="bi bi-diagram-3"></i> 組織図での位置</h5>
              </div>
              <div class="panel-body">
                <div class="d-flex align-items-center flex-wrap gap-2 small">
                  <span class="badge-normal">株式会社インフラリンク</span>
                  <i class="bi bi-chevron-right text-muted"></i>
                  <span class="badge-normal">開発部</span>
                  <i class="bi bi-chevron-right text-muted"></i>
                  <span class="badge-normal">プラットフォームチーム</span>
                  <i class="bi bi-chevron-right text-muted"></i>
                  <span class="status-pill status-progress">佐藤 花子（課長）</span>
                </div>
              </div>
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
<script src="../js/employee.js"></script>
</body>
<%@ include file="../components/footer.jsp"%>
</html>
