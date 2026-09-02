<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ログイン | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<!-- ログイン画面は Header / Footer を使わない専用レイアウト -->
<body data-page="login">

<div class="login-wrap">
  <div class="login-card">
    <a href="../index.html" class="logo">Infra<span>Link</span></a>
    <p class="login-sub">社内統合業務ポータルサイト</p>

    <!-- 1단계 : 실제 인증 로직 없음 (더미 폼). 7단계에서 세션 처리 연동 예정 -->
    <form action="../index.html" method="get">
      <div class="mb-3">
        <label class="form-label" for="loginId">社員ID</label>
        <div class="input-group">
          <span class="input-group-text bg-white"><i class="bi bi-person"></i></span>
          <input type="text" class="form-control" id="loginId" placeholder="社員IDを入力してください" value="t.yamada">
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label" for="loginPw">パスワード</label>
        <div class="input-group">
          <span class="input-group-text bg-white"><i class="bi bi-lock"></i></span>
          <input type="password" class="form-control" id="loginPw" placeholder="パスワードを入力してください" value="dummy1234">
        </div>
      </div>
      <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="rememberMe">
          <label class="form-check-label small text-muted" for="rememberMe">ログイン状態を保持する</label>
        </div>
        <a href="#" class="small text-muted">パスワードをお忘れですか？</a>
      </div>
      <button type="submit" class="btn btn-teal w-100 py-2">ログイン</button>
    </form>

    <hr class="my-4">
    <p class="text-center small text-muted mb-0">
      ID・パスワードを忘れた場合は IT支援部（内線100）までご連絡ください。
    </p>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
