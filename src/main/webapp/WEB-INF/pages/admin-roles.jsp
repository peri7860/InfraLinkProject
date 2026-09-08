<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ロール・権限管理 | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body data-page="admin">
<%@ include	file="/WEB-INF/components/header.jsp"%>
<%@ include	file="/WEB-INF/components/modal.jsp"%>
	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-person-lock"></i> ロール・権限管理
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
					<li class="breadcrumb-item active" aria-current="page">ロール・権限管理</li>
				</ol>
			</nav>
		</div>
	</section>
	<div id="app-content">
		<div class="container content-wrap">
		<nav class="admin-nav">
				<a
					href="${pageContext.request.contextPath}/pages/admin-employees.do">社員管理</a><a
					href="${pageContext.request.contextPath}/pages/admin-roles.do">ロール・権限</a><a
					href="${pageContext.request.contextPath}/pages/admin-rules.do">決裁ルール</a><a
					href="${pageContext.request.contextPath}/pages/admin-activity.do">活動履歴</a>
			</nav>
			<div class="alert alert-light border small">
				<i class="bi bi-shield-check text-teal"></i>
				最小権限の原則に基づき、担当業務に必要なロールだけを付与します。
			</div>
			<div class="panel">
				<div class="panel-header">
					<h5>
						<i class="bi bi-key"></i> ロール定義
					</h5>
					<button class="btn btn-teal btn-sm"
						onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">ロールを追加</button>
				</div>
				<div class="table-scroll">
					<table class="table list-table mb-0">
						<thead>
							<tr>
								<th>ロール</th>
								<th>対象</th>
								<th>主要権限</th>
								<th>決裁権限</th>
								<th class="text-center">操作</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><b>システム管理者</b></td>
								<td>IT管理者</td>
								<td>社員、組織、権限、監査ログの管理</td>
								<td>代理設定のみ</td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm"
										onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td><b>部門管理者</b></td>
								<td>部長・人事担当</td>
								<td>部門社員、部門お知らせの管理</td>
								<td>部門の最終承認</td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm"
										onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td><b>課長・決裁者</b></td>
								<td>課長</td>
								<td>チーム予定、部門掲示板</td>
								<td>一次承認</td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm"
										onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td><b>一般社員</b></td>
								<td>全社員</td>
								<td>本人情報、申請、投稿</td>
								<td>申請のみ</td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm"
										onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">編集</button></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
