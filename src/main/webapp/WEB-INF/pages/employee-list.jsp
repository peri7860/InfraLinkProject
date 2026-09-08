<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  사원 검색 (일반 사원용 조직도)

  [수정] 2026-09-07
    변경 전 : 사원 목록이 HTML 하드코딩("全 128名" 도 고정).
              부서/직급 select 는 화면에만 있고 아무 동작도 하지 않았다.
              employee.js 가 검색 submit 을 막고
              alert("2段階で実装予定です。") 만 띄웠다.
              상세 링크에 ?id= 가 없어 항상 같은 사람이 열렸다.
    변경 후 : EmployeeSearchService 의 employeeList / paging 을 그린다.
              부서 목록도 department 테이블에서 읽어 채운다.

  개인정보 : 전화번호는 마스킹된 값(getMaskedPhone)을 쓴다.
             전체 번호는 상세 화면에서 본인/관리자에게만 보여준다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員検索 | InfraLink</title>

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
    <h1><i class="bi bi-people"></i> 社員検索</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">社員検索</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <%-- ==================== 검색 폼 ====================
             GET 으로 보내야 검색 결과 URL 을 공유할 수 있고
             페이지 이동 시에도 조건이 유지된다.                --%>
        <form class="filter-bar" id="employeeSearchForm"
              method="get" action="${cp}/pages/employee.do">

          <select name="dept_code" class="form-select form-select-sm" style="width:170px;"
                  onchange="this.form.submit()">
            <option value="">全部署</option>
            <c:forEach var="dept" items="${departmentList}">
              <option value="${dept.dept_code}" ${deptCode eq dept.dept_code ? 'selected' : ''}>
                <c:out value="${dept.dept_name}"/>
                <c:if test="${dept.emp_count > 0}">(${dept.emp_count})</c:if>
              </option>
            </c:forEach>
          </select>

          <div class="input-group input-group-sm ms-auto" style="max-width:280px;">
            <input type="text" name="keyword" class="form-control"
                   placeholder="氏名・社員番号・メールで検索"
                   value="<c:out value='${keyword}'/>">
            <button class="btn btn-teal" type="submit" aria-label="検索">
              <i class="bi bi-search"></i>
            </button>
          </div>

          <c:if test="${not empty keyword or not empty deptCode}">
            <a href="${cp}/pages/employee.do" class="btn btn-outline-secondary btn-sm">
              <i class="bi bi-x-lg"></i>
            </a>
          </c:if>
        </form>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-people"></i> 社員一覧</h5>
            <span class="text-muted" style="font-size:.8rem;">全 ${paging.totalCount}名</span>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:80px;" class="text-center">写真</th>
                  <th>氏名</th>
                  <th>部署</th>
                  <th>役職</th>
                  <th style="width:80px;">内線</th>
                  <th>メール</th>
                </tr>
              </thead>
              <tbody>

                <c:forEach var="emp" items="${employeeList}">
                  <tr>
                    <td class="text-center">
                      <%-- 사진 대신 이름 첫 글자를 아바타로 --%>
                      <div class="employee-card avatar"
                           style="width:38px;height:38px;font-size:.9rem;margin:0 auto;">
                        <c:out value="${fn:substring(emp.emp_name, 0, 1)}"/>
                      </div>
                    </td>
                    <td>
                      <a href="${cp}/pages/employee-detail.do?id=${emp.employee_id}"
                         class="title-link"><c:out value="${emp.emp_name}"/></a>
                    </td>
                    <td><c:out value="${emp.dept_name}"/></td>
                    <td><c:out value="${emp.position}"/></td>
                    <td><c:out value="${emp.ext_no}"/></td>
                    <td><c:out value="${emp.email}"/></td>
                  </tr>
                </c:forEach>

                <c:if test="${empty employeeList}">
                  <tr>
                    <td colspan="6" class="text-center py-5">
                      <div class="empty-state">
                        <i class="bi bi-person-x"></i>
                        <h6>該当する社員が見つかりません</h6>
                        <p class="small mb-0">検索条件を変更してお試しください。</p>
                      </div>
                    </td>
                  </tr>
                </c:if>

              </tbody>
            </table>
          </div>
        </div>

        <c:set var="pagingUrl"   value="${cp}/pages/employee.do"/>
        <c:set var="pagingQuery" value="&keyword=${keyword}&dept_code=${deptCode}"/>
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
