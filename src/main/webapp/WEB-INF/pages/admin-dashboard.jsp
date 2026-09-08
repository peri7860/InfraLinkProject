<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>管理者ダッシュボード | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="../css/common.css">
<link rel="stylesheet" href="../css/header.css">
<link rel="stylesheet" href="../css/footer.css">
<link rel="stylesheet" href="../css/responsive.css">
</head>
<body data-page="admin">
<%@ include	file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>
		<section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-shield-lock"></i> 管理者ダッシュボード
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item active">管理者</li>
				</ol>
			</nav>
		</div>
	</section>
	<div id="app-content">
		<div class="container content-wrap">
			<div class="row g-3 mb-4">
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">有効な社員</div>
						<div class="fs-4 fw-bold text-teal">248</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">登録承認待ち</div>
						<div class="fs-4 fw-bold" style="color: #9a6b00">4</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">権限変更待ち</div>
						<div class="fs-4 fw-bold" style="color: #b23b3b">2</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">有効な決裁ルール</div>
						<div class="fs-4 fw-bold text-teal">12</div>
					</div>
				</div>
			</div>
			<div class="row g-4">
				<div class="col-md-7">
					<div class="panel">
						<div class="panel-header">
							<h5>
								<i class="bi bi-gear"></i> 管理メニュー
							</h5>
						</div>
						<div class="list-group list-group-flush">
							<a href="${pageContext.request.contextPath}/pages/admin-employees.do" class="list-group-item list-group-item-action py-3"><i
								class="bi bi-people me-3 text-teal"></i><b>社員・社員番号管理</b><small
								class="d-block text-muted ms-4">入社・退職、アカウント有効化、部署・職位の変更</small></a><a
								href="${pageContext.request.contextPath}/pages/admin-roles.do" class="list-group-item list-group-item-action py-3"><i
								class="bi bi-person-lock me-3 text-teal"></i><b>ロール・権限管理</b><small
								class="d-block text-muted ms-4">管理者、決裁者、一般社員の権限設定</small></a><a
								href="${pageContext.request.contextPath}/pages/admin-rules.do" class="list-group-item list-group-item-action py-3"><i
								class="bi bi-diagram-3 me-3 text-teal"></i><b>電子決裁ルール管理</b><small
								class="d-block text-muted ms-4">職位・金額・文書種別ごとの承認経路</small></a><a
								href="${pageContext.request.contextPath}/pages/admin-activity.do" class="list-group-item list-group-item-action py-3"><i
								class="bi bi-clock-history me-3 text-teal"></i><b>管理者活動履歴</b><small
								class="d-block text-muted ms-4">社員・権限・決裁ルールの変更記録を確認</small></a>
						</div>
					</div>
				</div>
				<div class="col-md-5">
					<div class="panel">
						<div class="panel-header">
							<h5>
								<i class="bi bi-exclamation-circle"></i> 要対応
							</h5>
						</div>
						<div class="panel-body">
							<p class="small border-bottom pb-3 mb-3">
								<span class="status-pill status-wait me-2">4件</span>社員登録の承認待ち
							</p>
							<p class="small border-bottom pb-3 mb-3">
								<span class="status-pill status-reject me-2">2件</span>権限変更の確認待ち
							</p>
							<p class="small mb-0">
								<span class="status-pill status-progress me-2">1件</span>組織変更の予約
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="../js/common.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
