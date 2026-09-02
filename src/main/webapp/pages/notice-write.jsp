<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>お知らせ作成 | InfraLink</title>

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
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>
<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-megaphone"></i> お知らせ</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item"><a href="notice-list.html">お知らせ</a></li>
        <li class="breadcrumb-item active" aria-current="page">作成</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-pencil-square"></i> お知らせ作成</h5>
          </div>

          <!-- 1단계 : 저장 버튼은 실제 DB 저장 없이 필수값 검증만 수행 (notice.js) -->
          <form class="form-panel" id="noticeWriteForm">
            <div class="row g-3 mb-3">
              <div class="col-md-4">
                <label class="form-label">区分</label>
                <select class="form-select">
                  <option>一般</option>
                  <option>重要</option>
                </select>
              </div>
              <div class="col-md-4">
                <label class="form-label">作成部署</label>
                <select class="form-select">
                  <option>人事部</option>
                  <option>総務部</option>
                  <option>IT支援部</option>
                  <option>経営企画部</option>
                </select>
              </div>
              <div class="col-md-4">
                <label class="form-label">公開範囲</label>
                <select class="form-select">
                  <option>全社員</option>
                  <option>部署別</option>
                  <option>役職別</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label" for="noticeTitle">タイトル <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="noticeTitle" placeholder="タイトルを入力してください">
            </div>

            <div class="mb-3">
              <label class="form-label" for="noticeContent">内容 <span class="text-danger">*</span></label>
              <textarea class="form-control" id="noticeContent" rows="10" placeholder="内容を入力してください"></textarea>
              <div class="form-text-desc mt-1">※ このエディタは1段階のプレーンテキスト入力欄です。リッチエディタは2段階で適用予定です。</div>
            </div>

            <div class="mb-3">
              <label class="form-label">添付ファイル</label>
              <input type="file" class="form-control">
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="noticePin">
              <label class="form-check-label small" for="noticePin">上部固定表示にする</label>
            </div>

            <div class="form-actions">
              <a href="notice-list.html" class="btn btn-outline-secondary px-4">キャンセル</a>
              <button type="submit" class="btn btn-teal px-4">登録する</button>
            </div>
          </form>
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
<%@ include file="../components/footer.jsp"%>
</html>
