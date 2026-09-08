<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String newEmployeeId = (String) request.getAttribute("newEmployeeId");
String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="ja">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>社員登録完了 | InfraLink</title>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/header.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/footer.css">

</head>


<body data-page="admin">

	<%@ include file="/WEB-INF/components/header.jsp"%>


	<main>

		<div class="container py-5">

			<div class="row justify-content-center">

				<div class="col-md-7 col-lg-6">


					<div class="card shadow-sm border-0 text-center">

						<div class="card-body p-5">


							<%
							if (newEmployeeId != null) {
							%>


							<!-- 성공 아이콘 -->

							<div class="mb-4">

								<i class="bi bi-check-circle-fill text-success"
									style="font-size: 70px;"> </i>

							</div>


							<!-- 제목 -->

							<h2 class="fw-bold mb-3">社員登録が完了しました</h2>


							<p class="text-muted mb-4">新しい社員情報が正常に登録されました。</p>


							<!-- 사원번호 -->

							<div class="bg-light rounded p-4 mb-4">

								<p class="text-muted mb-2">発行された社員番号</p>


								<h3 class="fw-bold mb-0">

									<%=newEmployeeId%>

								</h3>

							</div>


							<!-- 안내 -->

							<div class="alert alert-info text-start">

								<i class="bi bi-info-circle"></i> 初期パスワードは社員番号と同じです。
								初回ログイン後にパスワードを変更してください。

							</div>


							<!-- 버튼 -->

							<div class="d-flex justify-content-center gap-2 mt-4">

								<button type="button" class="btn btn-outline-secondary"
									onclick="location.href='${pageContext.request.contextPath}/pages/admin-employees.do'">

									<i class="bi bi-list"></i> 社員一覧

								</button>


								<button type="button" class="btn btn-primary"
									onclick="location.href='${pageContext.request.contextPath}/pages/admin-employee-edit.do'">

									<i class="bi bi-person-plus"></i> 続けて登録

								</button>

							</div>


							<%
							} else {
							%>


							<!-- 실패 -->

							<div class="mb-4">

								<i class="bi bi-x-circle-fill text-danger"
									style="font-size: 70px;"> </i>

							</div>


							<h2 class="fw-bold mb-3">社員登録に失敗しました</h2>


							<p class="text-muted mb-4">

								<%=errorMessage != null ? errorMessage : "社員登録中にエラーが発生しました。"%>

							</p>


							<button type="button" class="btn btn-secondary"
								onclick="history.back()">戻る</button>


							<%
							}
							%>


						</div>

					</div>


				</div>

			</div>

		</div>

	</main>


	<%@ include file="/WEB-INF/components/footer.jsp"%>


	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js">
		
	</script>

	<script src="${pageContext.request.contextPath}/js/common.js">
		
	</script>

</body>

</html>