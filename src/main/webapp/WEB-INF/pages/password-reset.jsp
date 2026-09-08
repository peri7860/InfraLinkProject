<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>パスワード再設定 | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body data-page="password-reset">
	<div class="login-wrap">
		<section class="login-card">
			<a href="#" class="logo">Infra<span>Link</span></a>
			<p class="login-sub">パスワード再設定</p>
			<div class="alert alert-light border small">
				<i class="bi bi-info-circle text-teal"></i>
				登録済みの会社メールアドレスへ再設定用の案内を送信します。
			</div>
			<form>
				<div class="mb-3">
					<label class="form-label">社員番号</label><input class="form-control"
						placeholder="例：EMP-2026001">
				</div>
				<div class="mb-3">
					<label class="form-label">会社メールアドレス</label><input type="email"
						class="form-control" placeholder="name@infralink.co.jp">
				</div>
				<button type="button" class="btn btn-teal w-100 py-2">再設定リンクを送信</button>
			</form>
			<hr class="my-4">
			<p class="text-center small mb-0">
				<a class="text-teal" href="#">ログイン画面へ戻る</a>
			</p>
		</section>
	</div>
</body>
</html>
