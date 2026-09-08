<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>決裁申請 | InfraLink</title>
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
<body data-page="approval"><%@ include
		file="/WEB-INF/components/header.jsp"%><%@ include
		file="/WEB-INF/components/modal.jsp"%><section
		class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-file-earmark-plus"></i> 決裁申請
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="#">ホーム</a></li>
					<li class="breadcrumb-item"><a href="#">電子決裁</a></li>
					<li class="breadcrumb-item active">申請</li>
				</ol>
			</nav>
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
								<i class="bi bi-pencil-square"></i> 決裁文書を申請
							</h5>
							<span class="small text-muted">* 必須項目</span>
						</div>
						<form class="form-panel">
							<div class="row g-3">
								<div class="col-md-6">
									<label class="form-label">文書種別 *</label><select
									class="form-select" id="documentType"><option value="leave">休暇申請書</option>
										<option value="trip">出張申請書</option><option value="expense">経費精算書</option><option value="purchase">購買申請書</option>
										<option>稟議書</option></select>
								</div>
								<div class="col-md-6">
									<label class="form-label">申請日</label><input
										class="form-control" value="2026-09-03" disabled>
								</div>
								<div class="col-12">
									<div id="leaveFields" class="row g-3"><div class="col-md-6"><label class="form-label">休暇開始日 *</label><input type="date" class="form-control"></div><div class="col-md-6"><label class="form-label">休暇終了日 *</label><input type="date" class="form-control"></div><div class="col-12"><label class="form-label">引継ぎ先</label><input class="form-control" placeholder="例：田中 健"></div></div>
									<div id="tripFields" class="row g-3 d-none"><div class="col-md-6"><label class="form-label">出張先 *</label><input class="form-control"></div><div class="col-md-6"><label class="form-label">出張期間 *</label><input class="form-control" placeholder="2026/09/10〜09/12"></div></div>
									<div id="expenseFields" class="row g-3 d-none"><div class="col-md-6"><label class="form-label">精算金額 *</label><input type="number" class="form-control" placeholder="0"></div><div class="col-md-6"><label class="form-label">支払日 *</label><input type="date" class="form-control"></div></div>
									<div id="purchaseFields" class="row g-3 d-none"><div class="col-md-6"><label class="form-label">購入予定金額 *</label><input type="number" class="form-control" placeholder="0"></div><div class="col-md-6"><label class="form-label">希望納期</label><input type="date" class="form-control"></div></div>
								</div><div class="col-12">
									<label class="form-label">件名 *</label><input
										class="form-control" placeholder="例：9月14日 年次有給休暇申請">
								</div>
								<div class="col-12">
									<label class="form-label">申請内容 *</label>
									<textarea class="form-control" rows="7"
										placeholder="目的、期間、金額などを入力してください。"></textarea>
								</div>
								<div class="col-12">
									<label class="form-label">添付ファイル</label><input type="file"
										class="form-control">
								</div>
								<div class="col-12">
									<label class="form-label">決裁経路</label>
									<div
										class="border rounded p-3 bg-light d-flex flex-wrap align-items-center gap-2 small">
										<span class="badge bg-secondary">起案者</span><b>山田 太郎</b><i
											class="bi bi-arrow-right text-muted"></i><span class="badge"
											style="background: var(--teal)">一次承認</span><b>佐藤 花子（課長）</b><i
											class="bi bi-arrow-right text-muted"></i><span class="badge"
											style="background: var(--navy)">最終承認</span><b>鈴木 一郎（部長）</b>
									</div>
									<p class="form-text-desc mt-2 mb-0">所属・職位・文書種別に応じて自動設定される想定の表示領域です。</p>
								</div>
							</div>
							<div class="form-actions">
								<button type="button" class="btn btn-outline-secondary">下書き保存</button>
								<button type="button" class="btn btn-teal">上申する</button>
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
	<script>document.getElementById('documentType').addEventListener('change',function(){['leave','trip','expense','purchase'].forEach(function(type){document.getElementById(type+'Fields').classList.toggle('d-none',type!==document.getElementById('documentType').value);});});</script>
</body><%@ include file="/WEB-INF/components/footer.jsp"%></html>
