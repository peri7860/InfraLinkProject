<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>決裁詳細 | InfraLink</title>
<!-- Bootstrap -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<!-- Google Font -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<!-- Custom CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>

<body data-page="approval">
	<!-- Header -->
	<%@ include file="/WEB-INF/components/header.jsp"%>
	<!-- Modal 공통 -->
	<%@ include file="/WEB-INF/components/modal.jsp"%>
	<!-- ================================
         Sub Banner
    ================================= -->
	<section class="sub-banner">
		<div class="container">
			<h1>
				<i class="bi bi-file-earmark-check"></i> 決裁詳細
			</h1>
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do"> ホーム </a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/approval.do">
							電子決裁 </a></li>
					<li class="breadcrumb-item active" aria-current="page">詳細</li>
				</ol>
			</nav>
		</div>
	</section>
	<!-- ================================
         Main Content
    ================================= -->
	<div id="app-content">
		<div class="container content-wrap">
			<div class="row g-4">
				<!-- ================================
                     Sidebar
                ================================= -->
				<aside class="col-lg-3">
					<%@ include file="/WEB-INF/components/sidebar.jsp"%>
				</aside>
				<!-- ================================
                     Main Section
                ================================= -->
				<section class="col-lg-9">
					<!-- ================================
                         決裁詳細
                    ================================= -->
					<div class="panel">
						<div class="view-header">
							<div class="d-flex justify-content-between gap-3 flex-wrap">
								<div>
									<span class="status-pill status-wait"> 承認待ち </span>
									<h2 class="mt-2 mb-2">9月14日 年次有給休暇</h2>
									<div class="view-meta">
										<span> 文書番号 AP-2026-0912 </span> <span> 起案者 山田 太郎 </span> <span>
											2026.09.03 09:12 </span>
									</div>
								</div>
								<!-- 一覧へ戻る -->
								<button type="button"
									class="btn btn-outline-secondary btn-sm align-self-start"
									onclick="location.href='${pageContext.request.contextPath}/pages/approval.do'">
									一覧へ戻る</button>
							</div>
						</div>
						<!-- 決裁詳細 본문 -->
						<div class="view-body">
							<div class="row g-3 mb-4">
								<!-- 文書種別 -->
								<div class="col-md-4">
									<div class="text-muted small">文書種別</div>
									<b> 休暇申請書 </b>
								</div>
								<!-- 休暇期間 -->
								<div class="col-md-4">
									<div class="text-muted small">休暇期間</div>
									<b> 2026年9月14日（月）終日 </b>
								</div>
								<!-- 代理連絡先 -->
								<div class="col-md-4">
									<div class="text-muted small">代理連絡先</div>
									<b> 田中 健 </b>
								</div>
							</div>
							<!-- 申請理由 -->
							<div class="border-top pt-4">
								<h6>申請理由</h6>
								<p>私用のため年次有給休暇を申請します。 担当案件は田中 健さんへ引継ぎ済みです。</p>
							</div>
						</div>
					</div>
					<!-- ================================
                         決裁経路
                    ================================= -->
					<div class="panel mt-4">
						<div class="panel-header">
							<h5>
								<i class="bi bi-diagram-3"></i> 決裁経路
							</h5>
						</div>
						<div class="panel-body">
							<div class="timeline">
								<!-- 起案 -->
								<div class="timeline-item">
									<span class="timeline-dot done"></span> <span
										class="status-pill status-done"> 起案 </span> <b class="ms-2">
										山田 太郎 </b>
									<div class="small text-muted mt-1">2026.09.03 09:12
										・「担当案件は引継ぎ済みです」</div>
								</div>
								<!-- 1次承認 -->
								<div class="timeline-item">
									<span class="timeline-dot current"></span> <span
										class="status-pill status-wait"> 1次承認待ち </span> <b
										class="ms-2"> 佐藤 花子（課長） </b>
									<div class="small text-muted mt-1">承認コメントを入力して処理できます。</div>
								</div>
								<!-- 最終承認 -->
								<div class="timeline-item">
									<span class="timeline-dot"></span> <span
										class="status-pill status-progress"> 最終承認 </span> <b
										class="ms-2"> 鈴木 一郎（部長） </b>
								</div>
							</div>
						</div>
					</div>
					<!-- ================================
                         添付ファイル
                    ================================= -->
					<div class="panel mt-4">
						<div class="panel-header">
							<h5>
								<i class="bi bi-paperclip"></i> 添付ファイル
							</h5>
						</div>
						<div class="panel-body">
							<div class="attachment-row">
								<!-- 파일 아이콘 -->
								<span class="attachment-icon"> <i
									class="bi bi-file-earmark-pdf"></i>
								</span>
								<!-- 파일 정보 -->
								<div class="flex-grow-1">
									<b class="small"> 休暇届_20260914.pdf </b>
									<div class="small text-muted">PDF・248 KB</div>
								</div>
								<!-- 미리보기 -->
								<button type="button" class="btn btn-outline-teal btn-sm">
									プレビュー</button>
								<!-- 다운로드 -->
								<button type="button" class="btn btn-outline-secondary btn-sm">
									ダウンロード</button>
							</div>
						</div>
					</div>
					<!-- ================================
                         承認アクション
                    ================================= -->
					<div class="panel mt-4">
						<div class="panel-header">
							<h5>
								<i class="bi bi-check2-square"></i> 承認アクション
							</h5>
						</div>
						<div class="panel-body">
							<!-- コメント -->
							<label class="form-label"> コメント <span
								class="text-muted fw-normal"> （差戻し・却下時は必須） </span>
							</label>
							<!-- 댓글 입력 -->
							<textarea class="form-control" rows="3"
								placeholder="コメントを入力してください"></textarea>
							<!-- 버튼 -->
							<div class="form-actions justify-content-end">
								<!-- 差戻し -->
								<button type="button" class="btn btn-outline-secondary"
									data-bs-toggle="modal" data-bs-target="#reasonModal"
									data-reason-title="差戻し理由">差戻し</button>
								<!-- 却下 -->
								<button type="button" class="btn btn-outline-danger"
									data-bs-toggle="modal" data-bs-target="#reasonModal"
									data-reason-title="却下理由">却下</button>
								<!-- 承認 -->
								<button type="button" class="btn btn-teal">承認する</button>
							</div>
						</div>
					</div>
				</section>
			</div>
		</div>
	</div>
	<!-- ================================
         差戻し・却下 Modal
    ================================= -->
	<div class="modal fade" id="reasonModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h5 class="modal-title">差戻し・却下の理由</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<!-- Modal Body -->
				<div class="modal-body">
					<label class="form-label"> 理由 <span class="text-danger">
							* </span>
					</label>
					<textarea class="form-control" rows="4"
						placeholder="申請者へ伝える内容を入力してください"></textarea>
				</div>
				<!-- Modal Footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-secondary"
						data-bs-dismiss="modal">キャンセル</button>
					<button type="button" class="btn btn-outline-danger">
						処理を確定</button>
				</div>
			</div>
		</div>
	</div>
	<!-- ================================
         Footer
    ================================= -->
	<%@ include file="/WEB-INF/components/footer.jsp"%>
	<!-- Bootstrap JS -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js">
		
	</script>
	<!-- Common JS -->
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>