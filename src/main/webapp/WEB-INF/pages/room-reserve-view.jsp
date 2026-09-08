<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>会議室予約詳細 | InfraLink</title>
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
<body data-page="room-reserve"><%@ include
		file="/WEB-INF/components/header.jsp"%><%@ include
		file="/WEB-INF/components/modal.jsp"%><section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-calendar-check"></i> 会議室予約詳細
			</h1>
		</div>
	</section>
	<div id="app-content">
		<div class="container content-wrap">
			<div class="row g-4">
				<aside class="col-lg-3"><%@ include
						file="/WEB-INF/components/sidebar.jsp"%></aside>
				<section class="col-lg-9">
					<div class="panel">
						<div class="view-header">
							<div class="d-flex justify-content-between gap-3 flex-wrap">
								<div>
									<span class="status-pill status-done">予約確定</span>
									<h2 class="mt-2 mb-2">新規プロジェクト企画レビュー</h2>
									<div class="view-meta">
										<span>予約番号 RM-2026-0821</span><span>予約者：山田 太郎</span>
									</div>
								</div>
								<button
									class="btn btn-outline-secondary btn-sm align-self-start"onclick="location.href='${pageContext.request.contextPath}/pages/room.do'">一覧へ戻る</button>
							</div>
						</div>
						<div class="view-body">
							<div class="row g-4">
								<div class="col-md-6">
									<div class="text-muted small mb-1">会議室</div>
									<p>
										<b>3階 大会議室</b><br>
										<small class="text-muted">最大20名・プロジェクター完備</small>
									</p>
								</div>
								<div class="col-md-6">
									<div class="text-muted small mb-1">日時</div>
									<p>
										<b>2026年8月18日（月） 14:00〜15:00</b>
									</p>
								</div>
								<div class="col-md-6">
									<div class="text-muted small mb-1">利用人数</div>
									<p>8名</p>
								</div>
								<div class="col-md-6">
									<div class="text-muted small mb-1">参加者</div>
									<p>山田 太郎、佐藤 花子、田中 健ほか</p>
								</div>
								<div class="col-12">
									<div class="text-muted small mb-1">備考</div>
									<p>プロジェクターを使用します。</p>
								</div>
							</div>
						</div>
						<div class="view-footer">
							<button class="btn btn-outline-danger btn-sm">予約をキャンセル</button>
							<button class="btn btn-teal btn-sm" onclick="location.href='${pageContext.request.contextPath}/pages/room-write.do'">予約内容を変更</button>
						</div>
					</div>
					<p class="text-muted small mt-2">※
						予約変更・キャンセル時は、他の予約との時間重複を確認する想定です。</p>
				</section>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
