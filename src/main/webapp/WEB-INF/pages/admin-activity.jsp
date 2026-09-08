<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>管理者活動履歴 | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
</head>
<body data-page="admin">
	<%@ include file="/WEB-INF/components/header.jsp"%>
	<%@ include file="/WEB-INF/components/modal.jsp"%>
	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-clock-history"></i> 管理者活動履歴
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
					<li class="breadcrumb-item active" aria-current="page">管理者活動履歴</li>
				</ol>
			</nav>
		</div>
	</section>
	<main id="app-content">
		<div class="container content-wrap">
			<nav class="admin-nav">
				<a
					href="${pageContext.request.contextPath}/pages/admin-employees.do">社員管理</a><a
					href="${pageContext.request.contextPath}/pages/admin-roles.do">ロール・権限</a><a
					href="${pageContext.request.contextPath}/pages/admin-rules.do">決裁ルール</a><a
					href="${pageContext.request.contextPath}/pages/admin-activity.do">活動履歴</a>
			</nav>
			<div class="col-lg-12">
				<div class="panel-header">
					<h5>活動ログ</h5>
					<span class="small text-muted">監査用に記録されます</span>
				</div>
				<div class="table-scroll">
					<table class="table list-table mb-0">
						<thead>
							<tr>
								<th>日時</th>
								<th>管理者</th>
								<th>操作</th>
								<th>対象</th>
								<th>詳細</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>2026.09.03 10:20</td>
								<td>管理者 佐藤</td>
								<td><span class="status-pill status-done">社員有効化</span></td>
								<td>小川 遥</td>
								<td>アカウントを有効に変更</td>
							</tr>
							<tr>
								<td>2026.09.03 09:48</td>
								<td>管理者 佐藤</td>
								<td><span class="status-pill status-progress">権限変更</span></td>
								<td>田中 健</td>
								<td>一般社員 → 課長・決裁者</td>
							</tr>
							<tr>
								<td>2026.09.02 16:10</td>
								<td>管理者 鈴木</td>
								<td><span class="status-pill status-wait">ルール更新</span></td>
								<td>購買申請書</td>
								<td>50,000円以上の最終承認者を変更</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</main>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
