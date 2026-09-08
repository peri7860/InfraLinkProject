<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  전자결재 문서함

  [수정] 2026-09-07
    변경 전 : 결재 목록이 전부 하드코딩. 테이블·DAO·서비스가 모두 없었다.
    변경 후 : ApprovalListService 의 approvalList / paging 을 그린다.

  문서함 구분 (tab)
    receive : 내가 결재해야 할 문서 (기본)
    draft   : 내가 기안한 문서
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>電子決裁 | InfraLink</title>

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
        <li class="breadcrumb-item active" aria-current="page">電子決裁</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <c:if test="${param.result eq 'created'}">
          <div class="alert alert-success py-2 px-3 small">決裁文書を起案しました。</div>
        </c:if>
        <c:if test="${param.result eq 'no_permission'}">
          <div class="alert alert-warning py-2 px-3 small">この文書を閲覧する権限がありません。</div>
        </c:if>

        <%-- ==================== 문서함 탭 ==================== --%>
        <ul class="nav nav-pills gap-2 mb-3">
          <li class="nav-item">
            <a class="nav-link ${tab ne 'draft' ? 'active btn-teal text-white' : ''}"
               href="${cp}/pages/approval.do?tab=receive">
              受信箱
              <c:if test="${waitingCount > 0}">
                <span class="badge bg-light text-dark ms-1">${waitingCount}</span>
              </c:if>
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link ${tab eq 'draft' ? 'active btn-teal text-white' : ''}"
               href="${cp}/pages/approval.do?tab=draft">
              起案文書
              <c:if test="${draftCount > 0}">
                <span class="badge bg-light text-dark ms-1">${draftCount}</span>
              </c:if>
            </a>
          </li>
        </ul>

        <%-- ==================== 상태 필터 ==================== --%>
        <form class="filter-bar" method="get" action="${cp}/pages/approval.do">
          <input type="hidden" name="tab" value="<c:out value='${tab}'/>">
          <select name="status" class="form-select form-select-sm" style="width:150px;"
                  onchange="this.form.submit()">
            <option value="">すべての状態</option>
            <option value="待機" ${status eq '待機' ? 'selected' : ''}>待機</option>
            <option value="承認" ${status eq '承認' ? 'selected' : ''}>承認</option>
            <option value="却下" ${status eq '却下' ? 'selected' : ''}>却下</option>
            <option value="回収" ${status eq '回収' ? 'selected' : ''}>回収</option>
          </select>

          <a href="${cp}/pages/approval-write.do" class="btn btn-teal btn-sm ms-auto">
            <i class="bi bi-pencil-square"></i> 起案する
          </a>
        </form>

        <div class="panel">
          <div class="panel-header">
            <h5>
              <i class="bi bi-inbox"></i>
              ${tab eq 'draft' ? '起案した文書' : '決裁待ちの文書'}
            </h5>
            <span class="text-muted" style="font-size:.8rem;">全 ${paging.totalCount}件</span>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:70px;"  class="text-center">No</th>
                  <th style="width:110px;" class="text-center">種類</th>
                  <th>件名</th>
                  <th style="width:130px;" class="text-center">
                    ${tab eq 'draft' ? '決裁者' : '起案者'}
                  </th>
                  <th style="width:110px;" class="text-center">起案日</th>
                  <th style="width:90px;"  class="text-center">状態</th>
                </tr>
              </thead>
              <tbody>

                <c:forEach var="doc" items="${approvalList}">
                  <tr>
                    <td class="text-center">${doc.approval_no}</td>
                    <td class="text-center">
                      <span class="badge-normal"><c:out value="${doc.doc_type}"/></span>
                    </td>
                    <td>
                      <a href="${cp}/pages/approval-view.do?no=${doc.approval_no}"
                         class="title-link"><c:out value="${doc.doc_title}"/></a>
                    </td>
                    <td class="text-center">
                      <c:out value="${tab eq 'draft' ? doc.approver_name : doc.emp_name}"/>
                    </td>
                    <td class="text-center">${doc.req_date}</td>
                    <td class="text-center">
                      <%-- 상태별 색은 ApprovalDTO.getStatusClass() 가 결정한다 --%>
                      <span class="status-pill ${doc.statusClass}">
                        <c:out value="${doc.status}"/>
                      </span>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty approvalList}">
                  <tr>
                    <td colspan="6" class="text-center py-5">
                      <div class="empty-state">
                        <i class="bi bi-file-earmark-check"></i>
                        <h6>該当する文書はありません</h6>
                        <p class="small mb-0">
                          ${tab eq 'draft' ? '起案した文書がここに表示されます。'
                                           : '決裁依頼が届くとここに表示されます。'}
                        </p>
                      </div>
                    </td>
                  </tr>
                </c:if>

              </tbody>
            </table>
          </div>
        </div>

        <c:set var="pagingUrl"   value="${cp}/pages/approval.do"/>
        <c:set var="pagingQuery" value="&tab=${tab}&status=${status}"/>
        <%@ include file="/WEB-INF/components/paging.jsp"%>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
