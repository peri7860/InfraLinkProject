<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  사원 상세 프로필

  [수정] 2026-09-07
    변경 전 : 특정 인물 정보로 하드코딩. 전화번호까지 tel:0312340212 고정.
              목록에서 누구를 눌러도 같은 사람이 나왔다.
    변경 후 : EmployeeDetailService 가 사번으로 조회한 결과를 그린다.

  개인정보 취급
    showFullContact 가 true 일 때(본인 또는 관리자)만 전체 전화번호를 보여준다.
    그 외에는 EmployeeDTO.getMaskedPhone() 으로 가운데를 가린다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty employee ? '社員情報' : employee.emp_name}"/> | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="employee">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-person-vcard"></i> 社員情報</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/employee.do">社員検索</a></li>
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

        <c:if test="${empty employee}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-person-x"></i>
              <h6><c:out value="${empty errorMessage ? '社員が見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/employee.do" class="btn btn-teal btn-sm mt-3">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty employee}">
          <div class="panel">
            <div class="p-4">
              <div class="d-flex gap-4 align-items-center flex-wrap">

                <div class="employee-card avatar"
                     style="width:88px;height:88px;font-size:2rem;flex-shrink:0;">
                  <c:out value="${fn:substring(employee.emp_name, 0, 1)}"/>
                </div>

                <div>
                  <h2 class="h4 fw-bold mb-1"><c:out value="${employee.emp_name}"/></h2>
                  <p class="text-muted mb-2"><c:out value="${employee.deptPosition}"/></p>

                  <%-- 재직 상태 배지 --%>
                  <span class="status-pill ${employee.active ? 'status-done' : 'status-wait'}">
                    <c:out value="${employee.emp_status}"/>
                  </span>
                  <c:if test="${employee.admin}">
                    <span class="badge-fixed ms-1">管理者</span>
                  </c:if>
                </div>
              </div>
            </div>

            <div class="border-top">
              <table class="table mb-0">
                <tbody>
                  <tr>
                    <th style="width:150px;background:#f7f9fa;">社員番号</th>
                    <td><c:out value="${employee.employee_id}"/></td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">部署</th>
                    <td><c:out value="${employee.dept_name}"/></td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">職位</th>
                    <td><c:out value="${employee.position}"/></td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">内線番号</th>
                    <td>
                      <c:choose>
                        <c:when test="${not empty employee.ext_no}">
                          <a href="tel:${employee.ext_no}"><c:out value="${employee.ext_no}"/></a>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">携帯電話</th>
                    <td>
                      <%-- 본인/관리자만 전체 번호. 그 외에는 마스킹 --%>
                      <c:choose>
                        <c:when test="${empty employee.phone}">
                          <span class="text-muted">-</span>
                        </c:when>
                        <c:when test="${showFullContact}">
                          <a href="tel:${employee.phone}"><c:out value="${employee.phone}"/></a>
                        </c:when>
                        <c:otherwise>
                          <c:out value="${employee.maskedPhone}"/>
                          <span class="text-muted small ms-1">（本人・管理者のみ全表示）</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">メール</th>
                    <td>
                      <c:choose>
                        <c:when test="${not empty employee.email}">
                          <a href="mailto:${employee.email}"><c:out value="${employee.email}"/></a>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  <tr>
                    <th style="background:#f7f9fa;">入社日</th>
                    <td><c:out value="${employee.hire_date}"/></td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="view-footer">
              <a href="${cp}/pages/employee.do" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>

              <div class="d-flex gap-2">
                <%-- 관리자에게는 편집 버튼 --%>
                <c:if test="${not empty loginUser and loginUser.admin}">
                  <a href="${cp}/pages/admin-employee-edit.do?id=${employee.employee_id}"
                     class="btn btn-outline-teal btn-sm">
                    <i class="bi bi-pencil"></i> 編集
                  </a>
                </c:if>
                <a href="${cp}/pages/messenger.do" class="btn btn-teal btn-sm">
                  <i class="bi bi-chat-dots"></i> メッセージ
                </a>
              </div>
            </div>
          </div>
        </c:if>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
