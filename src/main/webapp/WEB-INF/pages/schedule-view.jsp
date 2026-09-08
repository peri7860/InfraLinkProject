<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>予定詳細 | InfraLink</title>
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
<body data-page="schedule"><%@ include
		file="../components/header.jsp"%><%@ include
		file="../components/modal.jsp"%><section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-calendar-event"></i> 予定詳細
			</h1>
		</div>
	</section>
	<div id="app-content">
		<div class="container content-wrap">
			<div class="row g-4">
				<aside class="col-lg-3"><%@ include
						file="../components/sidebar.jsp"%></aside>
				<section class="col-lg-9">
					<div class="panel">
						<div class="view-header">
							<span class="status-pill status-done">部署共有</span>
							<h2 class="mt-2 mb-2">週次チーム定例会議</h2>
							<div class="view-meta">
								<span><i class="bi bi-calendar3"></i> 2026年8月13日（木）</span><span><i
									class="bi bi-clock"></i> 10:00〜11:00</span><span>登録者：山田 太郎</span>
							</div>
						</div>
						<div class="view-body">
							<div class="row g-4">
								<div class="col-md-6">
									<div class="text-muted small mb-1">場所</div>
									<p>
										<i class="bi bi-geo-alt text-teal"></i> 第1会議室
									</p>
								</div>
								<div class="col-md-6">
									<div class="text-muted small mb-1">公開範囲</div>
									<p>
										<span class="status-pill status-done">営業部に共有</span>
									</p>
								</div>
								<div class="col-12">
									<div class="text-muted small mb-1">詳細</div>
									<p>今週の営業進捗、案件課題、次週の対応方針を確認します。</p>
								</div>
								<div class="col-12">
									<div class="text-muted small mb-2">参加者（4名）</div>
									<span class="badge bg-light text-dark border me-1 p-2">山田
										太郎</span><span class="badge bg-light text-dark border me-1 p-2">佐藤
										花子</span><span class="badge bg-light text-dark border me-1 p-2">田中
										健</span><span class="badge bg-light text-dark border p-2">鈴木
										一郎</span>
								</div>
							</div>
						</div>
						<div class="view-footer">
							<button class="btn btn-outline-danger btn-sm">削除</button>
							<div>
								<button class="btn btn-outline-teal btn-sm">参加可否を回答</button>
								<button class="btn btn-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/schedule-write.do'">編集</button>
							</div>
						</div>
					</div>
				</section>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body><%@ include file="../components/footer.jsp"%></html>
