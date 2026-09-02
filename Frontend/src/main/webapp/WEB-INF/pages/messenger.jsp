<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>メッセンジャー | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
<style>
  /* 메신저 화면 전용 레이아웃 - 분량이 작아 별도 CSS 파일로 분리하지 않고 여기서 관리 */
  .msg-shell { display: flex; height: 600px; border: 1px solid var(--line); border-radius: var(--radius-md); overflow: hidden; background: var(--surface); }
  .msg-contacts { width: 260px; flex-shrink: 0; border-right: 1px solid var(--line); overflow-y: auto; }
  .msg-contacts .contact { display: flex; align-items: center; gap: .6rem; padding: .7rem 1rem; border-bottom: 1px solid var(--line); cursor: pointer; }
  .msg-contacts .contact:hover, .msg-contacts .contact.active { background: var(--teal-tint); }
  .msg-contacts .contact .dot { width: 8px; height: 8px; border-radius: 50%; background: #1e7b45; margin-left: auto; }
  .msg-contacts .contact .dot.off { background: #c3cad4; }
  .msg-window { flex: 1; display: flex; flex-direction: column; }
  .msg-window .msg-head { padding: .8rem 1.2rem; border-bottom: 1px solid var(--line); font-weight: 700; }
  .msg-body { flex: 1; padding: 1.2rem; overflow-y: auto; background: #f7f9fa; }
  .bubble { max-width: 65%; padding: .55rem .8rem; border-radius: 12px; font-size: .87rem; margin-bottom: .7rem; line-height: 1.5; }
  .bubble.in { background: #fff; border: 1px solid var(--line); border-bottom-left-radius: 2px; }
  .bubble.out { background: var(--teal); color: #fff; margin-left: auto; border-bottom-right-radius: 2px; }
  .msg-input { padding: .8rem; border-top: 1px solid var(--line); display: flex; gap: .5rem; }
</style>
</head>
<%@ include file="../../components/header.jsp"%>
<%@ include file="../../components/modal.jsp"%>
<body data-page="messenger">

<div id="header-placeholder"></div>
<div id="modal-placeholder"></div>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-chat-dots"></i> 社内メッセンジャー</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="../index.html">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">メッセンジャー</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><div id="sidebar-placeholder"></div><%@ include file="../../components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="msg-shell">
          <!-- ==================== 연락처 목록 ==================== -->
          <div class="msg-contacts">
            <div class="p-2 border-bottom">
              <input type="text" class="form-control form-control-sm" placeholder="名前で検索">
            </div>
            <div class="contact active">
              <div class="employee-card avatar" style="width:34px;height:34px;font-size:.8rem;">田</div>
              <div>
                <div class="fw-bold small">田中 誠</div>
                <div class="text-muted" style="font-size:.72rem;">人事部</div>
              </div>
              <span class="dot"></span>
            </div>
            <div class="contact">
              <div class="employee-card avatar" style="width:34px;height:34px;font-size:.8rem;">高</div>
              <div>
                <div class="fw-bold small">高橋 直子</div>
                <div class="text-muted" style="font-size:.72rem;">総務部</div>
              </div>
              <span class="dot"></span>
            </div>
            <div class="contact">
              <div class="employee-card avatar" style="width:34px;height:34px;font-size:.8rem;">鈴</div>
              <div>
                <div class="fw-bold small">鈴木 一郎</div>
                <div class="text-muted" style="font-size:.72rem;">営業部</div>
              </div>
              <span class="dot off"></span>
            </div>
            <div class="contact">
              <div class="employee-card avatar" style="width:34px;height:34px;font-size:.8rem;">伊</div>
              <div>
                <div class="fw-bold small">伊藤 健</div>
                <div class="text-muted" style="font-size:.72rem;">開発部</div>
              </div>
              <span class="dot off"></span>
            </div>
          </div>

          <!-- ==================== 채팅창 ==================== -->
          <div class="msg-window">
            <div class="msg-head"><i class="bi bi-person-circle text-teal"></i> 田中 誠</div>
            <div class="msg-body">
              <div class="bubble in">お疲れ様です！明日の会議資料、確認いただけましたか？</div>
              <div class="bubble out">お疲れ様です。確認しました、午後にコメントお送りします。</div>
              <div class="bubble in">ありがとうございます、よろしくお願いします！</div>
            </div>
            <div class="msg-input">
              <input type="text" class="form-control form-control-sm" placeholder="メッセージを入力してください（1段階：送信機能なし）" disabled>
              <button class="btn btn-teal btn-sm" disabled><i class="bi bi-send"></i></button>
            </div>
          </div>
        </div>
        <p class="text-muted small mt-2">※ メッセンジャー機能は画面のみのモックアップです。実際の送受信は2段階以降で実装予定です。</p>
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
