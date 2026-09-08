<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>電子決裁ルール編集 | InfraLink</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
</head>
<body data-page="admin">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-diagram-3"></i> 電子決裁ルール登録・編集
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
					<li class="breadcrumb-item active" aria-current="page"> <a
						href="${pageContext.request.contextPath}/pages/admin-rules.do">電子決裁ルール管理</a></li>
					<li class="breadcrumb-item active" aria-current="page"> 電子決裁ルー登録・編集</li>
				</ol>
			</nav>
		</div>
	</section>
	<main id="app-content">
		<div class="container content-wrap">
			<div class="panel">
				<div class="panel-header">
					<h5>購買申請書のルール</h5>
				</div>
				<form class="form-panel">
					<div class="row g-3">
						<div class="col-md-6">
							<label class="form-label">文書種別</label><select class="form-select"><option>購買申請書</option>
								<option>経費精算書</option>
								<option>休暇申請書</option></select>
						</div>
						<div class="col-md-6">
							<label class="form-label">適用状態</label><select class="form-select"><option>有効</option>
								<option>無効</option></select>
						</div>
						<div class="col-md-6">
							<label class="form-label">金額条件（以上）</label>
							<div class="input-group">
								<input class="form-control" type="number" value="50000"><span
									class="input-group-text">円</span>
							</div>
						</div>
						<div class="col-md-6">
							<label class="form-label">対象部署</label><select class="form-select"><option>全社</option>
								<option>営業部</option>
								<option>IT部</option></select>
						</div>
						<div class="col-12">
							<label class="form-label">承認ステップ・承認職位</label>
							<div class="row g-2">
								<div class="col-md-4">
									<div class="border rounded p-3">
										<b class="small">1次承認</b><select
											class="form-select form-select-sm mt-2"><option>課長</option>
											<option>部長</option></select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="border rounded p-3">
										<b class="small">最終承認</b><select
											class="form-select form-select-sm mt-2"><option>部長</option>
											<option>管理部長</option></select>
									</div>
								</div>
								<div class="col-md-4">
									<div class="border rounded p-3">
										<b class="small">追加ステップ</b><select
											class="form-select form-select-sm mt-2"><option>なし</option>
											<option>役員</option></select>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="form-actions justify-content-end">
						<button class="btn btn-outline-secondary">キャンセル</button>
						<button class="btn btn-teal">保存</button>
					</div>
				</form>
			</div>
		</div>
	</main>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
