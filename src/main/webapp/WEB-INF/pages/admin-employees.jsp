<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  사원 계정 관리 (관리자)

  [수정] 2026-09-07
    변경 전 : 목록은 이미 DB 연동되어 있었지만(이 프로젝트에서 유일했다)
              - 검색창과 상태 select 가 동작하지 않았다
              - 페이지네이션이 없어 사원이 늘면 한 화면에 전부 나왔다
              - "社員を追加" 버튼과 편집 버튼이 같은 화면으로 갔다
              - 퇴사 처리·비밀번호 초기화 기능이 아예 없었다
              - 決裁ルール 링크가 라우트에 없어 404 였다
    변경 후 : EmployeeListService 의 검색·페이징 결과를 그리고
              퇴사 처리 / 비밀번호 초기화 버튼을 추가했다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員・社員番号管理 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="admin">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-people"></i> 社員・社員番号管理</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
        <li class="breadcrumb-item active" aria-current="page">社員・社員番号管理</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">

    <nav class="admin-nav">
      <a href="${cp}/pages/admin-employees.do" class="active">社員管理</a
      ><a href="${cp}/pages/admin-roles.do">ロール・権限</a
      ><a href="${cp}/pages/admin-approval-rules.do">決裁ルール</a
      ><a href="${cp}/pages/admin-activity.do">活動履歴</a
      ><a href="${cp}/pages/system-status.do">システム状況</a>
    </nav>

    <%-- ==================== 처리 결과 안내 ==================== --%>
    <c:if test="${param.result eq 'updated'}">
      <div class="alert alert-success py-2 px-3 small">社員情報を更新しました。</div>
    </c:if>
    <c:if test="${param.result eq 'retired'}">
      <div class="alert alert-success py-2 px-3 small">退職処理を行いました。</div>
    </c:if>
    <c:if test="${param.result eq 'self_retire'}">
      <div class="alert alert-warning py-2 px-3 small">
        自分自身を退職処理することはできません。
      </div>
    </c:if>
    <c:if test="${param.result eq 'fail'}">
      <div class="alert alert-danger py-2 px-3 small">処理に失敗しました。</div>
    </c:if>

    <%-- ==================== 상단 통계 ==================== --%>
    <div class="row g-3 mb-3">
      <div class="col-6 col-md-3">
        <div class="panel p-3 text-center">
          <div class="text-muted small mb-1">全社員</div>
          <div class="fs-4 fw-bold">${totalEmployee}</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="panel p-3 text-center">
          <div class="text-muted small mb-1">在職</div>
          <div class="fs-4 fw-bold text-success">${activeEmployee}</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="panel p-3 text-center">
          <div class="text-muted small mb-1">休職</div>
          <div class="fs-4 fw-bold">${leaveEmployee}</div>
        </div>
      </div>
      <div class="col-6 col-md-3">
        <div class="panel p-3 text-center">
          <div class="text-muted small mb-1">検索結果</div>
          <div class="fs-4 fw-bold">${paging.totalCount}</div>
        </div>
      </div>
    </div>

    <%-- ==================== 검색 / 필터 ==================== --%>
    <form class="filter-bar" method="get" action="${cp}/pages/admin-employees.do">

      <select name="emp_status" class="form-select form-select-sm" style="width:150px;"
              onchange="this.form.submit()">
        <option value="">すべての状態</option>
        <option value="在職" ${empStatus eq '在職' ? 'selected' : ''}>在職</option>
        <option value="休職" ${empStatus eq '休職' ? 'selected' : ''}>休職</option>
        <option value="退職" ${empStatus eq '退職' ? 'selected' : ''}>退職</option>
      </select>

      <select name="dept_code" class="form-select form-select-sm" style="width:170px;"
              onchange="this.form.submit()">
        <option value="">全部署</option>
        <c:forEach var="dept" items="${departmentList}">
          <option value="${dept.dept_code}" ${deptCode eq dept.dept_code ? 'selected' : ''}>
            <c:out value="${dept.dept_name}"/>
          </option>
        </c:forEach>
      </select>

      <input type="text" name="keyword" class="form-control form-control-sm"
             style="max-width:300px;"
             placeholder="社員番号・氏名・メールで検索"
             value="<c:out value='${keyword}'/>">
      <button class="btn btn-teal btn-sm" type="submit">検索</button>

      <c:if test="${not empty keyword or not empty deptCode or not empty empStatus}">
        <a href="${cp}/pages/admin-employees.do" class="btn btn-outline-secondary btn-sm">
          リセット
        </a>
      </c:if>

      <button type="button" class="btn btn-outline-teal btn-sm ms-auto"
              onclick="location.href='${cp}/pages/admin-employee-edit.do'">
        <i class="bi bi-person-plus"></i> 社員を追加
      </button>
    </form>

    <div class="panel">
      <div class="panel-header">
        <h5><i class="bi bi-person-vcard"></i> 社員アカウント一覧</h5>
      </div>

      <div class="table-scroll">
        <table class="table list-table mb-0">
          <thead>
            <tr>
              <th>社員番号</th>
              <th>氏名</th>
              <th>部署 / 職位</th>
              <th class="text-center">在職状況</th>
              <th class="text-center">権限</th>
              <th class="text-center" style="width:230px;">操作</th>
            </tr>
          </thead>
          <tbody>

            <c:forEach var="employee" items="${employeeList}">
              <tr>
                <td><c:out value="${employee.employee_id}"/></td>
                <td><c:out value="${employee.emp_name}"/></td>
                <td><c:out value="${employee.deptPosition}"/></td>

                <td class="text-center">
                  <span class="status-pill ${employee.active ? 'status-done' : 'status-wait'}">
                    <c:out value="${employee.emp_status}"/>
                  </span>
                </td>

                <td class="text-center">
                  <c:choose>
                    <c:when test="${employee.admin}">
                      <span class="badge-fixed">管理者</span>
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted small">一般</span>
                    </c:otherwise>
                  </c:choose>
                  <%-- 초기 비밀번호 상태면 눈에 띄게 표시 --%>
                  <c:if test="${employee.pwdReset}">
                    <span class="badge-normal ms-1" title="初期パスワードのままです">初期PW</span>
                  </c:if>
                </td>

                <td class="text-center">
                  <div class="d-inline-flex gap-1">
                    <button type="button" class="btn btn-outline-teal btn-sm"
                            onclick="location.href='${cp}/pages/admin-employee-edit.do?id=${employee.employee_id}'">
                      編集
                    </button>

                    <%-- 비밀번호 초기화 : 사번과 같은 값으로 되돌린다 --%>
                    <form method="post" action="${cp}/pages/employeePasswordReset.do"
                          class="d-inline"
                          onsubmit="return confirm('${employee.emp_name} さんのパスワードを社員番号に初期化しますか？');">
                      <input type="hidden" name="id" value="${employee.employee_id}">
                      <button type="submit" class="btn btn-outline-secondary btn-sm">PW初期化</button>
                    </form>

                    <%-- 퇴사 처리 : 재직/휴직자에게만, 본인 제외 --%>
                    <c:if test="${employee.emp_status ne '退職'
                                  and employee.employee_id ne loginUser.employee_id}">
                      <form method="post" action="${cp}/pages/employeeRetire.do"
                            class="d-inline"
                            onsubmit="return confirm('${employee.emp_name} さんを退職処理しますか？\n過去の文書は残りますが、ログインできなくなります。');">
                        <input type="hidden" name="id" value="${employee.employee_id}">
                        <button type="submit" class="btn btn-sm text-white"
                                style="background:var(--warn);">退職</button>
                      </form>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty employeeList}">
              <tr>
                <td colspan="6" class="text-center py-5">
                  <div class="empty-state">
                    <i class="bi bi-person-x"></i>
                    <h6>該当する社員がいません</h6>
                    <p class="small mb-0">検索条件を変更してお試しください。</p>
                  </div>
                </td>
              </tr>
            </c:if>

          </tbody>
        </table>
      </div>
    </div>

    <c:set var="pagingUrl"   value="${cp}/pages/admin-employees.do"/>
    <c:set var="pagingQuery" value="&keyword=${keyword}&dept_code=${deptCode}&emp_status=${empStatus}"/>
    <%@ include file="/WEB-INF/components/paging.jsp"%>

  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
