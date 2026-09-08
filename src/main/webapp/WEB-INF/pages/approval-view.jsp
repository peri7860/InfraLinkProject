<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  결재 문서 상세 / 결재 처리

  [수정] 2026-09-07
    변경 전 : 특정 문서 하나가 하드코딩. 승인/반려 버튼은 아무 동작도 없었다.
    변경 후 : ApprovalViewService 의 doc 을 그리고,
              승인/반려/회수를 ApprovalProcessService 로 POST 한다.

  버튼 노출 규칙 (서비스가 계산해서 넘겨준다)
    canProcess  : 대기 상태 + 내가 지정된 결재자
    canWithdraw : 대기 상태 + 내가 기안자
    화면에서 숨기는 것은 편의일 뿐이고, 실제 차단은 DAO 의 WHERE 절이 한다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty doc ? '決裁文書' : doc.doc_title}"/> | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">

<style>
.doc-content { white-space: pre-wrap; word-break: break-word; }
</style>
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
        <li class="breadcrumb-item active" aria-current="page">詳細</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <c:if test="${empty doc}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-exclamation-circle"></i>
              <h6><c:out value="${empty errorMessage ? '決裁文書が見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/approval.do" class="btn btn-teal btn-sm mt-3">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty doc}">

          <%-- ==================== 처리 결과 안내 ==================== --%>
          <c:if test="${param.result eq 'approved'}">
            <div class="alert alert-success py-2 px-3 small">承認しました。</div>
          </c:if>
          <c:if test="${param.result eq 'rejected'}">
            <div class="alert alert-success py-2 px-3 small">却下しました。</div>
          </c:if>
          <c:if test="${param.result eq 'withdrawn'}">
            <div class="alert alert-success py-2 px-3 small">文書を回収しました。</div>
          </c:if>
          <c:if test="${param.result eq 'already_processed'}">
            <div class="alert alert-warning py-2 px-3 small">
              すでに処理済みの文書か、決裁権限がありません。
            </div>
          </c:if>
          <c:if test="${param.result eq 'need_comment'}">
            <div class="alert alert-warning py-2 px-3 small">
              却下する場合は理由を入力してください。
            </div>
          </c:if>

          <div class="panel">
            <div class="view-header">
              <span class="badge-normal mb-2 d-inline-block"><c:out value="${doc.doc_type}"/></span>
              <h2><c:out value="${doc.doc_title}"/></h2>
              <div class="view-meta">
                <span><i class="bi bi-person"></i>
                  起案 <c:out value="${doc.emp_name}"/>
                  <c:if test="${not empty doc.dept_name}">（<c:out value="${doc.dept_name}"/>）</c:if>
                </span>
                <span><i class="bi bi-person-check"></i>
                  決裁 <c:out value="${doc.approver_name}"/>
                </span>
                <span><i class="bi bi-calendar3"></i> ${doc.req_date}</span>
                <span class="status-pill ${doc.statusClass}"><c:out value="${doc.status}"/></span>
              </div>
            </div>

            <div class="view-body">
              <div class="doc-content"><c:out value="${doc.content}"/></div>
            </div>

            <%-- ==================== 결재 의견 (처리된 문서) ==================== --%>
            <c:if test="${not empty doc.proc_date}">
              <div class="px-3 pb-3">
                <div class="border rounded p-3 small" style="background:#f7f9fa;">
                  <div class="fw-bold mb-1">
                    <i class="bi bi-chat-left-text"></i> 決裁意見
                    <span class="text-muted fw-normal ms-2">${doc.proc_date}</span>
                  </div>
                  <c:choose>
                    <c:when test="${not empty doc.proc_comment}">
                      <div class="doc-content"><c:out value="${doc.proc_comment}"/></div>
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted">意見はありません。</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </c:if>

            <div class="view-footer">
              <a href="${cp}/pages/approval.do" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>

              <%-- 기안자가 회수 --%>
              <c:if test="${canWithdraw}">
                <form method="post" action="${cp}/pages/approvalProcess.do" class="d-inline"
                      onsubmit="return confirm('この文書を回収しますか？');">
                  <input type="hidden" name="no" value="${doc.approval_no}">
                  <input type="hidden" name="action" value="withdraw">
                  <button type="submit" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-counterclockwise"></i> 回収する
                  </button>
                </form>
              </c:if>
            </div>
          </div>

          <%-- ==================== 결재 처리 (지정 결재자만) ==================== --%>
          <c:if test="${canProcess}">
            <div class="panel mt-3">
              <div class="panel-header">
                <h5><i class="bi bi-pen"></i> 決裁処理</h5>
              </div>
              <form method="post" action="${cp}/pages/approvalProcess.do" class="p-3">
                <input type="hidden" name="no" value="${doc.approval_no}">

                <div class="mb-3">
                  <label class="form-label" for="procComment">決裁意見</label>
                  <textarea class="form-control" id="procComment" name="comment" rows="3"
                            maxlength="1000"
                            placeholder="意見を入力してください（却下の場合は必須）"></textarea>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                  <%-- 반려 : 사유가 필수이므로 서비스에서 다시 검사한다 --%>
                  <button type="submit" name="action" value="reject"
                          class="btn text-white" style="background:var(--warn);"
                          onclick="return confirmReject();">
                    <i class="bi bi-x-circle"></i> 却下
                  </button>
                  <button type="submit" name="action" value="approve"
                          class="btn btn-teal"
                          onclick="return confirm('この文書を承認しますか？');">
                    <i class="bi bi-check-circle"></i> 承認
                  </button>
                </div>
              </form>
            </div>
          </c:if>

        </c:if>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<script>
  // 반려는 사유를 반드시 남기게 한다 (서버에서도 다시 검사한다)
  function confirmReject() {
    var comment = document.getElementById("procComment");
    if (comment && !comment.value.trim()) {
      alert("却下する場合は理由を入力してください。");
      comment.focus();
      return false;
    }
    return confirm("この文書を却下しますか？");
  }
</script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
