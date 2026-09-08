<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>ロール登録・編集 | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
</head>
<body data-page="admin">
<%@ include	file="/WEB-INF/components/header.jsp"%>
<%@ include	file="/WEB-INF/components/modal.jsp"%>
<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-person-lock"></i> ロール登録・編集
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
						<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-roles.do">ロール・権限管理</a></li>
					<li class="breadcrumb-item active" aria-current="page">ロール登録・編集</li>
				</ol>
			</nav>
		</div>
	</section>
	<main id="app-content">
		<div class="container content-wrap">
			<div class="panel">
				<div class="panel-header">
					<h5>課長・決裁者</h5>
				</div>
				<form class="form-panel">
					<div class="row g-3">
						<div class="col-md-6">
							<label class="form-label">ロール名</label><input class="form-control"
								value="課長・決裁者">
						</div>
						<div class="col-md-6">
							<label class="form-label">ロール説明</label><input
								class="form-control" value="チームの管理と一次決裁を行う">
						</div>
						<div class="col-12">
							<label class="form-label">権限設定</label>
							<div class="permission-grid">
								<label><input type="checkbox" checked> 社員情報を閲覧</label><label><input
									type="checkbox" checked> 部署予定を管理</label><label><input
									type="checkbox" checked> 掲示板を投稿・編集</label><label><input
									type="checkbox" checked> 一次決裁</label><label><input
									type="checkbox"> 社員アカウントを編集</label><label><input
									type="checkbox"> 決裁ルールを編集</label><label><input
									type="checkbox"> お知らせを作成</label><label><input
									type="checkbox"> 監査ログを閲覧</label>
							</div>
						</div>
					</div>
					<div class="form-actions justify-content-end">
						<button class="btn btn-outline-secondary">キャンセル</button>
						<button class="btn btn-teal">保存</button>
					</div>
				</form>
			</div>
		</div>
	</main>
</body>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</html>
