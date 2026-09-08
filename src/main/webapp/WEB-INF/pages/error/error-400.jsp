<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%--
  =====================================================================
  400 에러 페이지
  ---------------------------------------------------------------------
  [신규 생성] 2026-09-07
    기존에는 web.xml 자체가 없어서 오류가 나면 톰캣 기본 화면이 떴다.
    기본 화면에는 스택트레이스와 서버 버전이 그대로 노출되어
    공격자에게 정보를 주기 때문에 반드시 자체 페이지로 덮어써야 한다.
  =====================================================================
--%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>400 | InfraLink</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body class="d-flex align-items-center justify-content-center" style="min-height:100vh;">
  <div class="text-center px-3" style="max-width:520px;">
    <p class="display-1 fw-bold mb-2" style="letter-spacing:-.04em;">400</p>
    <h1 class="h4 fw-bold mb-3">リクエストが正しくありません</h1>
    <p class="text-muted mb-4">入力内容をご確認のうえ、もう一度お試しください。</p>
    <div class="d-flex gap-2 justify-content-center">
      <a href="${pageContext.request.contextPath}/index.do" class="btn btn-teal px-4">
        <i class="bi bi-house"></i> ホームへ
      </a>
      <button type="button" class="btn btn-outline-secondary px-4" onclick="history.back()">
        <i class="bi bi-arrow-left"></i> 戻る
      </button>
    </div>
    <p class="small text-muted mt-4 mb-0">
      問題が続く場合は IT支援部（内線100）までご連絡ください。
    </p>
  </div>
</body>
</html>
