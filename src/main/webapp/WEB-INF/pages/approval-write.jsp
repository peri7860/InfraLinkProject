<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  결재 문서 기안

  [수정] 2026-09-07
    변경 전 : 폼에 action / name 이 없고 등록 버튼도 type="button" 이라
              아무 동작을 하지 않았다. 결재자 선택 항목도 없었다.
    변경 후 : ApprovalWriteService 로 POST 한다.
              결재자는 재직 중인 사원 목록에서 고른다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>決裁起案 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="approval">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-file-earmark-check"></i> 電子決裁</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/approval.do">電子決裁</a></li>
        <li class="breadcrumb-item active" aria-current="page">起案</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-pencil-square"></i> 決裁文書の起案</h5>
            <span class="small text-muted">* 必須項目</span>
          </div>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
              <i class="bi bi-exclamation-circle"></i> <c:out value="${errorMessage}"/>
            </div>
          </c:if>

          <form class="form-panel" method="post" action="${cp}/pages/approval-write.do">

            <div class="row g-3">

              <div class="col-md-6">
                <label class="form-label" for="docType">
                  文書種類 <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="docType" name="doc_type" required>
                  <option value="">選択してください</option>
                  <c:forEach var="t" items="休暇申請,経費精算,購買稟議,出張申請,その他">
                    <option value="${t}"><c:out value="${t}"/></option>
                  </c:forEach>
                </select>
              </div>

              <div class="col-md-6">
                <label class="form-label" for="approvalId">
                  決裁者 <span class="text-danger">*</span>
                </label>
                <select class="form-select" id="approvalId" name="approval_id" required>
                  <option value="">選択してください</option>
                  <%-- 자기 자신은 서비스에서 거른다 --%>
                  <c:forEach var="emp" items="${employeeList}">
                    <c:if test="${emp.employee_id ne loginUser.employee_id}">
                      <option value="${emp.employee_id}">
                        <c:out value="${emp.emp_name}"/>
                        （<c:out value="${emp.deptPosition}"/>）
                      </option>
                    </c:if>
                  </c:forEach>
                </select>
                <div class="form-text">決裁者に通知が届きます。</div>
              </div>

              <div class="col-12">
                <label class="form-label" for="docTitle">
                  件名 <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="docTitle" name="doc_title"
                       maxlength="300" required
                       placeholder="例：夏季休暇申請（9/14〜9/16）">
              </div>

              <div class="col-12">
                <label class="form-label" for="docContent">内容</label>
                <textarea class="form-control" id="docContent" name="content" rows="10"
                          placeholder="申請の理由や詳細を入力してください。"></textarea>
              </div>

            </div>

            <div class="form-actions">
              <a href="${cp}/pages/approval.do" class="btn btn-outline-secondary px-4">
                キャンセル
              </a>
              <%-- [수정] 기존에는 type="button" 이라 눌러도 전송되지 않았다 --%>
              <button type="submit" class="btn btn-teal px-4">起案する</button>
            </div>
          </form>
        </div>
      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
