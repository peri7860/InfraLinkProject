<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  로그인 화면

  [수정] 2026-09-07

  변경 전의 문제 (로그인이 아예 불가능한 상태였다)
    1) form action 이 "${contextPath}/index.do" 였다.
       → LoginService 가 아니라 메인 화면으로 갔다.
    2) method="get" 이었다.
       → 비밀번호가 주소창과 서버 접근 로그에 그대로 남는다.
    3) input 에 name 속성이 없었다.
       → employee_id / password 파라미터가 아예 전송되지 않았다.
    4) value 에 "t.yamada" / "dummy1234" 가 하드코딩되어 있었다.
    5) CSS 를 "../css/" 상대경로로 참조했다.
       → URL 깊이가 바뀌면 깨진다.
    6) 로그인 실패 사유를 보여줄 자리가 없었다.

  변경 후
    · POST 로 /pages/loginpro.do 전송
    · name 속성 부여, 더미 값 제거
    · contextPath 기반 절대경로
    · 실패/로그아웃/로그인필요 메시지 표시
    · 실패 시 입력했던 사번 유지
  =====================================================================
--%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ログイン | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>

<%-- 로그인 화면은 Header / Footer 를 쓰지 않는 전용 레이아웃 --%>
<body data-page="login">

	<div class="login-wrap">
		<div class="login-card">

			<a href="${pageContext.request.contextPath}/index.do" class="logo">Infra<span>Link</span></a>
			<p class="login-sub">社内統合業務ポータルサイト</p>

			<%-- ============================================================
			     안내 / 오류 메시지
			     ============================================================ --%>

			<%-- 로그인 실패 (LoginService 가 errorMessage 를 담아 forward) --%>
			<c:if test="${not empty errorMessage}">
				<div class="alert alert-danger py-2 px-3 small text-start" role="alert">
					<i class="bi bi-exclamation-circle"></i>
					<c:out value="${errorMessage}" />
				</div>
			</c:if>

			<%-- 로그인이 필요한 화면에 접근했을 때 (LoginFilter 가 붙여준다) --%>
			<c:if test="${param.need eq 'login'}">
				<div class="alert alert-warning py-2 px-3 small text-start" role="alert">
					<i class="bi bi-lock"></i>
					このページを表示するにはログインが必要です。
				</div>
			</c:if>

			<%-- 로그아웃 완료 --%>
			<c:if test="${param.logout eq '1'}">
				<div class="alert alert-success py-2 px-3 small text-start" role="alert">
					<i class="bi bi-check-circle"></i>
					ログアウトしました。
				</div>
			</c:if>

			<%-- ============================================================
			     로그인 폼
			       · POST 로 전송한다 (비밀번호가 URL 에 남지 않도록)
			       · name 속성이 LoginService 가 읽는 파라미터명과 일치해야 한다
			     ============================================================ --%>
			<form action="${pageContext.request.contextPath}/pages/loginpro.do" method="post">

				<div class="mb-3">
					<label class="form-label" for="loginId">社員ID</label>
					<div class="input-group">
						<span class="input-group-text bg-white"><i class="bi bi-person"></i></span>
						<%-- 실패 시 입력했던 사번을 유지한다 --%>
						<input type="text" class="form-control" id="loginId"
							name="employee_id"
							value="<c:out value='${inputEmployeeId}'/>"
							placeholder="社員IDを入力してください"
							autocomplete="username" required autofocus>
					</div>
					<div class="form-text">例 : DEV-2026-002</div>
				</div>

				<div class="mb-3">
					<label class="form-label" for="loginPw">パスワード</label>
					<div class="input-group">
						<span class="input-group-text bg-white"><i class="bi bi-lock"></i></span>
						<input type="password" class="form-control" id="loginPw"
							name="password"
							placeholder="パスワードを入力してください"
							autocomplete="current-password" required>
						<%-- 비밀번호 표시 토글 --%>
						<button class="btn btn-outline-secondary" type="button"
							id="togglePw" aria-label="パスワードを表示">
							<i class="bi bi-eye"></i>
						</button>
					</div>
				</div>

				<div class="d-flex flex-column gap-2 mb-3">
					<div class="form-check">
						<input class="form-check-input" type="checkbox" id="rememberMe" name="remember">
						<label class="form-check-label small text-muted" for="rememberMe">
							社員IDを記憶する
						</label>
					</div>
					<div>
						<a href="${pageContext.request.contextPath}/pages/password-reset.do"
							class="small text-muted">パスワードをお忘れですか？</a>
					</div>
				</div>

				<button type="submit" class="btn btn-teal w-100 py-2">ログイン</button>
			</form>

			<hr class="my-4">
			<p class="text-center small text-muted mb-0">
				ID・パスワードを忘れた場合は IT支援部（内線100）までご連絡ください。
			</p>
		</div>
	</div>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
	<script>
	(function () {
		"use strict";

		// ==================== 비밀번호 표시 토글 ====================
		var toggle = document.getElementById("togglePw");
		var pw = document.getElementById("loginPw");

		if (toggle && pw) {
			toggle.addEventListener("click", function () {
				var isHidden = pw.type === "password";
				pw.type = isHidden ? "text" : "password";
				toggle.innerHTML = isHidden
					? '<i class="bi bi-eye-slash"></i>'
					: '<i class="bi bi-eye"></i>';
			});
		}

		// ==================== 사번 기억하기 ====================
		// 비밀번호는 절대 저장하지 않는다. 사번만 편의상 기억한다.
		var idInput = document.getElementById("loginId");
		var remember = document.getElementById("rememberMe");
		var KEY = "infralink.lastEmployeeId";

		try {
			var saved = localStorage.getItem(KEY);
			if (saved && idInput && !idInput.value) {
				idInput.value = saved;
				if (remember) remember.checked = true;
			}
		} catch (e) {
			// 시크릿 모드 등에서 localStorage 접근이 막힐 수 있다
		}

		var form = document.querySelector("form");
		if (form) {
			form.addEventListener("submit", function () {
				try {
					if (remember && remember.checked) {
						localStorage.setItem(KEY, idInput.value);
					} else {
						localStorage.removeItem(KEY);
					}
				} catch (e) { /* 무시 */ }
			});
		}
	})();
	</script>
</body>
</html>
