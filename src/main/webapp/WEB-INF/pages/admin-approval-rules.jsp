<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>電子決裁ルール管理 | InfraLink</title>
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
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>
<body data-page="admin">
	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-diagram-3"></i> 電子決裁ルール管理
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
					<li class="breadcrumb-item active" aria-current="page"> 電子決裁ルール管理</li>
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
			<div class="panel">
				<div class="panel-header">
					<h5>
						<i class="bi bi-signpost-split"></i> 承認経路ルール
					</h5>
					<button class="btn btn-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/admin-rule-edit.do'">ルールを追加</button>
				</div>
				<div class="table-scroll">
					<table class="table list-table mb-0">
						<thead>
							<tr>
								<th>文書種別</th>
								<th>適用条件</th>
								<th>承認経路</th>
								<th class="text-center">状態</th>
								<th class="text-center">操作</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>休暇申請書</td>
								<td>全社員</td>
								<td>課長 → 部長</td>
								<td class="text-center"><span
									class="status-pill status-done">有効</span></td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/admin-rule-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td>経費精算書</td>
								<td>50,000円未満</td>
								<td>課長 → 部長</td>
								<td class="text-center"><span
									class="status-pill status-done">有効</span></td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/admin-rule-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td>購買申請書</td>
								<td>50,000円以上</td>
								<td>課長 → 部長 → 管理部長</td>
								<td class="text-center"><span
									class="status-pill status-done">有効</span></td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/admin-rule-edit.do'">編集</button></td>
							</tr>
							<tr>
								<td>稟議書</td>
								<td>500,000円以上</td>
								<td>課長 → 部長 → 役員</td>
								<td class="text-center"><span
									class="status-pill status-done">有効</span></td>
								<td class="text-center"><button
										class="btn btn-outline-teal btn-sm"onclick="location.href='${pageContext.request.contextPath}/pages/admin-role-edit.do'">編集</button></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
