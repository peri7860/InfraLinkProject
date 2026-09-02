<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>   
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>掲示板 詳細 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="board">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>
<%@ include file="../../components/header.jsp"%>
<%@ include file="../../components/modal.jsp"%>
<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-clipboard2-data"></i> 掲示板</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item"><a href="board-list.html">掲示板</a></li>
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
            <span class="badge-normal mb-2 d-inline-block">自由掲示板</span>
            <h2>社員食堂の新メニュー、みなさんはどう思いますか？</h2>
            <div class="view-meta">
              <span><i class="bi bi-person"></i> 佐藤 花子（開発部）</span>
              <span><i class="bi bi-calendar3"></i> 2026.08.13</span>
              <span><i class="bi bi-eye"></i> 閲覧 88</span>
            </div>
          </div>
          <div class="view-body">
            <p>お疲れ様です。開発部の佐藤です。</p>
            <p>先週から食堂のメニューが新しくなりましたが、みなさんはどう思いますか？<br>
            個人的には和食の定食が増えたのがとても嬉しいです。ただ、麺類のメニューがもう少し欲しいなと思っています。</p>
            <p>他の方のご意見も聞いてみたいのでコメントお願いします！</p>
          </div>
          <div class="view-footer">
            <a href="board-list.html" class="btn btn-outline-secondary btn-sm"><i class="bi bi-list"></i> 一覧に戻る</a>
            <div class="d-flex gap-2">
              <a href="board-write.html" class="btn btn-outline-teal btn-sm"><i class="bi bi-pencil"></i> 編集</a>
              <button type="button" class="btn btn-sm text-white" style="background:var(--warn);" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal"><i class="bi bi-trash"></i> 削除</button>
            </div>
          </div>
        </div>

        <!-- ==================== 댓글 영역 (2단계에서 실제 저장 기능 연동) ==================== -->
        <div class="panel mt-3">
          <div class="panel-header">
            <h5><i class="bi bi-chat-dots"></i> コメント <span class="text-teal">12</span></h5>
          </div>
          <div class="p-3">
            <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
              <div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;flex-shrink:0;">田</div>
              <div>
                <div class="fw-bold small">田中 誠 <span class="text-muted fw-normal ms-2" style="font-size:.75rem;">2026.08.13 10:22</span></div>
                <div class="small mt-1">私も麺類が増えてほしいです。特にラーメンがあると嬉しいですね。</div>
              </div>
            </div>
            <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
              <div class="employee-card avatar" style="width:38px;height:38px;font-size:.9rem;flex-shrink:0;">高</div>
              <div>
                <div class="fw-bold small">高橋 直子 <span class="text-muted fw-normal ms-2" style="font-size:.75rem;">2026.08.13 11:05</span></div>
                <div class="small mt-1">和食定食、私も好きです！野菜がたくさん摂れて助かっています。</div>
              </div>
            </div>

            <!-- 댓글 입력 (더미 동작, board.js) -->
            <div class="d-flex gap-2 mt-3">
              <input type="text" class="form-control form-control-sm" id="commentInput" placeholder="コメントを入力してください">
              <button class="btn btn-teal btn-sm" id="commentSubmitBtn">登録</button>
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
<script src="../js/board.js"></script>
</body>
<%@ include file="../../components/footer.jsp"%>
</html>
