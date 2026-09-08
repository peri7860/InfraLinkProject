<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="ja">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width,initial-scale=1">

<title>社員情報の登録・編集 | InfraLink</title>

<!-- Bootstrap -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">

<!-- CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/header.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/footer.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/responsive.css">

</head>


<body data-page="admin">

	<!-- Header -->
	<%@ include file="/WEB-INF/components/header.jsp"%>


	<!-- Modal -->
	<%@ include file="/WEB-INF/components/modal.jsp"%>


	<!-- =========================
         Sub Banner
    ========================== -->

	<section class="sub-banner">

		<div class="container">

			<h1>
				<i class="bi bi-person-vcard"></i> 社員情報の登録・編集
			</h1>


			<nav aria-label="breadcrumb">

				<ol class="breadcrumb">

					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/index.do"> ホーム </a></li>


					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-dashboard.do">
							管理者ダッシュボード </a></li>


					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/pages/admin-employees.do">
							社員・社員番号管理 </a></li>


					<li class="breadcrumb-item active" aria-current="page">

						社員情報の登録・編集</li>

				</ol>

			</nav>

		</div>

	</section>



	<!-- =========================
         Main
    ========================== -->

	<main id="app-content">

		<div class="container content-wrap">


			<!-- 관리자 메뉴 -->

			<nav class="admin-nav">

				<a
					href="${pageContext.request.contextPath}/pages/admin-employees.do">
					社員管理 </a> <a
					href="${pageContext.request.contextPath}/pages/admin-roles.do">
					ロール・権限 </a> <a
					href="${pageContext.request.contextPath}/pages/admin-approval-rules.do">
					決裁ルール </a> <a
					href="${pageContext.request.contextPath}/pages/admin-activity.do">
					活動履歴 </a>

			</nav>



			<!-- =========================
                 Employee Register Panel
            ========================== -->

			<div class="panel">


				<!-- Panel Header -->

				<div class="panel-header">

					<h5>

						<i class="bi bi-person-lines-fill"></i> 社員情報の登録

					</h5>


					<span class="small text-muted"> 管理者による新規社員登録 </span>

				</div>



				<!-- =========================
                     Form
                ========================== -->

				<form class="form-panel" method="post"
					action="${pageContext.request.contextPath}/pages/employeeRegister.do">


					<div class="row g-3">


						<!-- =========================
                             社員番号
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label">社員番号</label>

							<div class="form-control bg-light" id="employeeIdPreview">
								部署を選択してください</div>

							<div class="form-text">部署を選択すると発行予定の社員番号が表示されます。</div>

						</div>


						<!-- =========================
                             氏名
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> 氏名 </label> <input type="text"
								class="form-control" name="emp_name" placeholder="氏名を入力してください"
								required>

						</div>



						<!-- =========================
                             部署
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> 部署 </label> <select
								class="form-select" name="dept_code" id="deptCode" required>


								<option value="">選択してください</option>


								<!--
                                    아래 D001 / D002 / D003은
                                    DB의 실제 dept_code에 맞춰야 함
                                -->

								<option value="D001">営業部</option>

								<option value="D002">IT部</option>

								<option value="D003">総務部</option>


							</select>

						</div>



						<!-- =========================
                             職位
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> 職位 </label> <select
								class="form-select" name="position" required>


								<option value="">選択してください</option>


								<option value="一般">一般</option>

								<option value="課長">課長</option>

								<option value="部長">部長</option>


							</select>

						</div>



						<!-- =========================
                             ロール
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> ロール </label> <select
								class="form-select" name="auth_role" required>


								<option value="">選択してください</option>


								<option value="USER">一般社員</option>

								<option value="APPROVER">課長・決裁者</option>

								<option value="ADMIN">部門管理者</option>


							</select>

						</div>



						<!-- =========================
                             Email
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> メールアドレス </label> <input type="email"
								class="form-control" name="email"
								placeholder="example@infralink.co.jp" required>

						</div>



						<!-- =========================
                             電話番号
                        ========================== -->

						<div class="col-md-6">

							<label class="form-label"> 電話番号 </label> <input type="text"
								class="form-control" name="phone" placeholder="03-0000-1234"
								required>

						</div>


					</div>



					<!-- =========================
                         Buttons
                    ========================== -->

					<div class="form-actions justify-content-end">


						<!-- 戻る -->

						<button type="button" class="btn btn-outline-secondary"
							onclick="location.href='${pageContext.request.contextPath}/pages/admin-employees.do'">

							戻る</button>



						<!-- 保存 -->

						<button type="submit" class="btn btn-teal">

							<i class="bi bi-save"></i> 保存

						</button>


					</div>


				</form>

			</div>


		</div>

	</main>



	<!-- =========================
         Bootstrap JS
    ========================== -->

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js">
		
	</script>


	<!-- Common JS -->

	<script src="${pageContext.request.contextPath}/js/common.js">
		
	</script>


	<!-- Footer -->

	<%@ include file="/WEB-INF/components/footer.jsp"%>

	<script>
		const contextPath = '${pageContext.request.contextPath}';
	</script>

	<script
		src="${pageContext.request.contextPath}/js/employee-register.js"></script>
</body>

</html>
