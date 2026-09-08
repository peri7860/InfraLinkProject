<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>会議室予約 | InfraLink</title>
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
<body data-page="room-reserve"><%@ include
		file="/WEB-INF/components/header.jsp"%><%@ include
		file="/WEB-INF/components/modal.jsp"%><section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-door-open"></i> 会議室予約
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
						<div class="panel-header">
							<h5>
								<i class="bi bi-calendar-plus"></i> 会議室を予約
							</h5>
							<span class="small text-muted">空き状況を確認して登録します</span>
						</div>
						<form class="form-panel">
							<div class="row g-3">
								<div class="col-md-6">
									<label class="form-label">会議室 *</label><select
										class="form-select"><option>3階 大会議室（最大20名）</option>
										<option>役員会議室（最大10名）</option>
										<option>2階 セミナー室（最大40名）</option></select>
								</div>
								<div class="col-md-6">
									<label class="form-label">利用人数 *</label><input type="number"
										class="form-control" placeholder="例：8">
								</div>
								<div class="col-md-6">
									<label class="form-label">利用日 *</label><input type="date"
										class="form-control">
								</div>
								<div class="col-md-6">
									<label class="form-label">利用時間 *</label>
									<div class="input-group">
										<input type="time" class="form-control"><span
											class="input-group-text">〜</span><input type="time"
											class="form-control">
									</div>
								</div>
								<div class="col-12">
									<label class="form-label">予約可能時間を選択</label>
									<div class="time-slots">
										<button type="button" class="time-slot" data-time-slot>09:00</button>
										<button type="button" class="time-slot" data-time-slot>10:00</button>
										<button type="button" class="time-slot busy" data-time-slot>11:00（予約済）</button>
										<button type="button" class="time-slot" data-time-slot>12:00</button>
										<button type="button" class="time-slot" data-time-slot>13:00</button>
										<button type="button" class="time-slot busy" data-time-slot>14:00（予約済）</button>
										<button type="button" class="time-slot" data-time-slot>15:00</button>
										<button type="button" class="time-slot" data-time-slot>16:00</button>
									</div>
									<p class="form-text-desc mt-2 mb-0">空きスロットをクリックして開始時間を選択できます。</p>
								</div>
								<div class="col-12">
									<label class="form-label">会議名 *</label><input
										class="form-control" placeholder="例：新規プロジェクト企画レビュー">
								</div>
								<div class="col-12">
									<label class="form-label">参加者</label><input
										class="form-control" placeholder="社員番号または氏名を入力して追加">
								</div>
								<div class="col-12">
									<label class="form-label">備考</label>
									<textarea class="form-control" rows="4"
										placeholder="設備利用などの要望があれば入力してください。"></textarea>
								</div>
							</div>
							<div class="form-actions">
								<button type="button" class="btn btn-outline-secondary" onclick="location.href='${pageContext.request.contextPath}/pages/room.do'">キャンセル</button>
								<button type="button" class="btn btn-teal"
									data-bs-toggle="modal" data-bs-target="#conflictModal">空き状況を確認して予約</button>
							</div>
						</form>
					</div>
				</section>
			</div>
		</div>
	</div>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script src="../js/common.js"></script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
