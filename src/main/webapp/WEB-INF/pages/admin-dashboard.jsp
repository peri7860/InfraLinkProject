<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
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
						<div class="text-muted small">在職社員</div>
						<div class="fs-4 fw-bold text-teal">${activeEmployee}</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">本日の出勤</div>
						<div class="fs-4 fw-bold" style="color:#9a6b00">${todayCheckIn}</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">決裁待ち</div>
						<div class="fs-4 fw-bold" style="color:#b23b3b">${waitingApproval}</div>
					</div>
				</div>
				<div class="col-6 col-lg-3">
					<div class="panel text-center py-3">
						<div class="text-muted small">お知らせ / 投稿</div>
						<div class="fs-4 fw-bold text-teal">${noticeCount} / ${boardCount}</div>
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
							<div class="mb-3">
								<div class="fw-bold small mb-2">部署別 在職人数</div>
								<c:forEach var="dept" items="${departmentList}">
									<div class="d-flex justify-content-between small border-bottom py-1">
										<span><c:out value="${dept.dept_name}"/></span>
										<span class="fw-bold">${dept.emp_count}名</span>
									</div>
								</c:forEach>
							</div>
							<div>
								<div class="fw-bold small mb-2">本日の会議室予約</div>
								<c:forEach var="rv" items="${todayReserveList}">
									<div class="d-flex justify-content-between small border-bottom py-1">
										<span class="text-truncate" style="max-width:60%;">
											<c:out value="${rv.meeting_title}"/>
										</span>
										<span class="text-muted"><c:out value="${rv.timeRange}"/></span>
									</div>
								</c:forEach>
								<c:if test="${empty todayReserveList}">
									<span class="text-muted small">本日の予約はありません。</span>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
