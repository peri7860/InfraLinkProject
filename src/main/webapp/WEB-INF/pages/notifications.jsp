<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>通知 | InfraLink</title>
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
<body data-page="notifications"><%@ include
		file="/WEB-INF/components/header.jsp"%><%@ include
		file="/WEB-INF/components/modal.jsp"%><section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-bell"></i> 通知
			</h1>
		</div>
	</section>
	<div id="app-content">
		<div class="container content-wrap">
			<div class="row g-4">
				<aside class="col-lg-3"><%@ include
						file="/WEB-INF/components/sidebar.jsp"%></aside>
				<section class="col-lg-9">
					<div
						class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
						<div class="text-muted small" data-unread-label>未読 3件</div>
						<div class="d-flex gap-2">
							<div class="btn-group btn-group-sm">
								<button class="btn btn-outline-secondary active" id="allFilter">すべて</button>
								<button class="btn btn-outline-secondary" id="unreadFilter">未読</button>
							</div>
							<button class="btn btn-outline-teal btn-sm" data-mark-all-read>すべて既読にする</button>
						</div>
					</div>
					<div class="panel">
						<div class="panel-header">
							<h5>
								<i class="bi bi-bell-fill"></i> 通知一覧
							</h5>
						</div>
						<div class="list-group list-group-flush" id="notificationList">
							<a href="#"
								class="list-group-item list-group-item-action p-3 bg-teal-tint"
								data-notification><div class="d-flex gap-3">
									<i class="bi bi-file-earmark-check fs-5 text-teal"></i>
									<div class="flex-grow-1">
										<strong>決裁承認の依頼</strong>
										<div class="small mt-1">「9月14日 年次有給休暇」があなたの承認待ちです。</div>
										<small class="text-muted">5分前</small>
									</div>
									<div class="text-end">
										<span class="badge badge-fixed">未読</span>
										<button class="btn btn-link btn-sm d-block p-0 mt-2"
											data-mark-read>既読にする</button>
									</div>
								</div></a> <a href="#"
								class="list-group-item list-group-item-action p-3 bg-teal-tint"
								data-notification><div class="d-flex gap-3">
									<i class="bi bi-chat-left-text fs-5 text-teal"></i>
									<div class="flex-grow-1">
										<strong>掲示板のコメント</strong>
										<div class="small mt-1">田中 健さんがあなたの投稿にコメントしました。</div>
										<small class="text-muted">1時間前</small>
									</div>
									<div class="text-end">
										<span class="badge badge-fixed">未読</span>
										<button class="btn btn-link btn-sm d-block p-0 mt-2"
											data-mark-read>既読にする</button>
									</div>
								</div></a> <a href="#" class="list-group-item list-group-item-action p-3"
								data-notification><div class="d-flex gap-3">
									<i class="bi bi-megaphone fs-5 text-teal"></i>
									<div>
										<strong>重要なお知らせ</strong>
										<div class="small mt-1">台風接近に伴う在宅勤務への切替について</div>
										<small class="text-muted">2時間前</small>
									</div>
								</div></a>
						</div>
					</div>
					<div class="panel mt-4">
						<div class="panel-header">
							<h5>
								<i class="bi bi-sliders"></i> 通知設定
							</h5>
						</div>
						<div class="panel-body">
							<div class="row g-2">
								<div class="col-md-6">
									<div class="d-flex justify-content-between border rounded p-3">
										<span>決裁</span>
										<div class="form-check form-switch">
											<input class="form-check-input" type="checkbox" checked>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="d-flex justify-content-between border rounded p-3">
										<span>お知らせ</span>
										<div class="form-check form-switch">
											<input class="form-check-input" type="checkbox" checked>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="d-flex justify-content-between border rounded p-3">
										<span>コメント</span>
										<div class="form-check form-switch">
											<input class="form-check-input" type="checkbox" checked>
										</div>
									</div>
								</div>
								<div class="col-md-6">
									<div class="d-flex justify-content-between border rounded p-3">
										<span>メッセンジャー</span>
										<div class="form-check form-switch">
											<input class="form-check-input" type="checkbox">
										</div>
									</div>
								</div>
							</div>
							<div class="form-actions justify-content-end">
								<button class="btn btn-teal btn-sm">保存</button>
							</div>
						</div>
					</div>
					<div class="panel mt-4 d-none" id="emptyNotifications">
						<div class="empty-state">
							<i class="bi bi-bell-slash"></i>
							<h6>新しい通知はありません</h6>
							<p class="small mb-0">新しいお知らせが届くとここに表示されます。</p>
						</div>
					</div>
				</section>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="../js/common.js"></script>
	<script>
		var all = document.getElementById('allFilter'), unread = document
				.getElementById('unreadFilter');
		unread.onclick = function() {
			document.querySelectorAll('[data-notification]').forEach(
					function(e) {
						e.classList.toggle('d-none', !e.classList
								.contains('bg-teal-tint'))
					})
		};
		all.onclick = function() {
			document.querySelectorAll('[data-notification]').forEach(
					function(e) {
						e.classList.remove('d-none')
					})
		};
	</script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
