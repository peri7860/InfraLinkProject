<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員・社員番号管理 | InfraLink</title>
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
	<%@ include file="/WEB-INF/components/header.jsp"%>
	<%@ include file="/WEB-INF/components/modal.jsp"%>

	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-people"></i> 社員・社員番号管理
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
					<li class="breadcrumb-item active" aria-current="page">社員・社員番号管理</li>
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
					href="${pageContext.request.contextPath}/pages/admin-approval-rules.do">決裁ルール</a><a
					href="${pageContext.request.contextPath}/pages/admin-activity.do">活動履歴</a>
			</nav>
			<div class="filter-bar">
				<select class="form-select form-select-sm" style="width: 150px"><option>すべての状態</option>
					<option>有効</option>
					<option>登録承認待ち</option>
					<option>無効</option></select><input class="form-control form-control-sm"
					style="max-width: 310px" placeholder="社員番号・氏名・メールで検索">
				<button class="btn btn-teal btn-sm">検索</button>
				<button type="button" class="btn btn-outline-teal btn-sm ms-auto"
					onclick="location.href='${pageContext.request.contextPath}/pages/admin-employee-edit.do'">

					<i class="bi bi-person-plus"></i> 社員を追加

				</button>
			</div>
			<div class="panel">
				<div class="panel-header">
					<h5>
						<i class="bi bi-person-vcard"></i> 社員アカウント一覧
					</h5>
				</div>
				<div class="table-scroll">
					<table class="table list-table mb-0">
						<thead>
							<tr>
								<th>社員番号</th>
								<th>氏名</th>
								<th>部署 / 職位</th>
								<th class="text-center">在職状況</th>
								<th class="text-center">変更申請</th>
								<th class="text-center">操作</th>
							</tr>
						</thead>
						<tbody>

							<c:forEach var="employee" items="${employeeList}">

								<tr>

									<!-- 社員番号 -->
									<td>${employee.employee_id}</td>


									<!-- 氏名 -->
									<td>${employee.emp_name}</td>


									<!-- 部署 / 職位 -->
									<td>${employee.dept_name}/${employee.position}</td>


									<!-- アカウント -->
									<td class="text-center"><span
										class="status-pill status-done"> ${employee.emp_status}
									</span></td>

									<!-- 変更申請 -->
									<td class="text-center"><span class="text-muted small">
											なし </span></td>


									<!-- 操作 -->
									<td class="text-center">

										<div class="d-inline-flex gap-1">

											<button type="button"
												onclick="location.href='${pageContext.request.contextPath}/pages/admin-employee-edit.do?id=${employee.employee_id}'"
												class="btn btn-outline-teal btn-sm">編集</button>

										</div>

									</td>

								</tr>

							</c:forEach>


							<!-- 직원이 없는 경우 -->

							<c:if test="${empty employeeList}">

								<tr>

									<td colspan="7" class="text-center py-5 text-muted">

										登録されている社員はいません。</td>

								</tr>

							</c:if>

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
