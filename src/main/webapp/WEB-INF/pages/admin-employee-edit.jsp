<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  사원 등록 / 수정 (관리자)

  [수정] 2026-09-07

  ★ 가장 큰 문제였던 화면이다.
    변경 전 : "編集" 으로 들어와도 폼이 항상 비어 있었다.
              EmployeeEditService 가 employee 를 넘겨줬는데
              이 JSP 에서 ${employee...} 를 쓰는 곳이 <b>한 군데도 없었다.</b>
              게다가 폼이 항상 employeeRegister.do(신규 INSERT)로 갔기 때문에
              기존 사원을 "수정" 하면 새 사번으로 사원이 하나 더 생겼다.
    변경 후 : editMode 에 따라
                신규 → employeeRegister.do
                수정 → employeeUpdate.do
              로 보내고, 수정 모드에서는 기존 값을 채운다.

    그 외
    - 부서 select 옵션이 하드코딩이었다 → department 테이블에서 채운다
    - 사번 미리보기는 신규 등록일 때만 의미가 있다 (수정 시에는 고정값 표시)
    - 수정 모드에서는 재직 상태와 권한도 바꿀 수 있어야 한다
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${editMode ? '社員情報編集' : '社員登録'} | InfraLink</title>

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
    <h1><i class="bi bi-person-gear"></i> ${editMode ? '社員情報編集' : '社員登録'}</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/admin-dashboard.do">管理者ダッシュボード</a></li>
        <li class="breadcrumb-item"><a href="${cp}/pages/admin-employees.do">社員管理</a></li>
        <li class="breadcrumb-item active" aria-current="page">${editMode ? '編集' : '登録'}</li>
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
      ><a href="${cp}/pages/admin-activity.do">活動履歴</a>
    </nav>

    <div class="panel">
      <div class="panel-header">
        <h5>
          <i class="bi bi-person-vcard"></i>
          ${editMode ? '社員情報の編集' : '新規社員登録'}
        </h5>
        <span class="small text-muted">
          <c:choose>
            <c:when test="${editMode}">社員番号とパスワードは変更できません</c:when>
            <c:otherwise>初期パスワードは社員番号と同じです</c:otherwise>
          </c:choose>
        </span>
      </div>

      <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
          <i class="bi bi-exclamation-circle"></i> <c:out value="${errorMessage}"/>
        </div>
      </c:if>
      <c:if test="${param.result eq 'pwd_reset'}">
        <div class="alert alert-success py-2 px-3 small m-3 mb-0">
          パスワードを社員番号に初期化しました。
        </div>
      </c:if>

      <%-- 등록과 수정은 보내는 곳이 다르다 --%>
      <form class="form-panel" method="post"
            action="${cp}/pages/${editMode ? 'employeeUpdate.do' : 'employeeRegister.do'}">

        <%-- 수정 대상 사번 (수정 모드에서만) --%>
        <c:if test="${editMode}">
          <input type="hidden" name="employee_id" value="${employee.employee_id}">
        </c:if>

        <div class="row g-3">

          <%-- ==================== 사번 ==================== --%>
          <div class="col-md-6">
            <label class="form-label">社員番号</label>
            <c:choose>
              <c:when test="${editMode}">
                <div class="form-control bg-light"><c:out value="${employee.employee_id}"/></div>
                <div class="form-text">社員番号は変更できません。</div>
              </c:when>
              <c:otherwise>
                <%-- 부서를 고르면 employee-register.js 가 AJAX 로 채운다 --%>
                <div class="form-control bg-light" id="employeeIdPreview">
                  部署を選択してください
                </div>
                <div class="form-text">
                  部署を選択すると発行予定の社員番号が表示されます。
                  （実際の番号は登録時に確定します）
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <%-- ==================== 성명 ==================== --%>
          <div class="col-md-6">
            <label class="form-label" for="empName">氏名 <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="empName" name="emp_name"
                   maxlength="60" required placeholder="氏名を入力してください"
                   value="<c:out value='${employee.emp_name}'/>">
          </div>

          <%-- ==================== 부서 ====================
               [수정] 옵션이 하드코딩이었다. department 테이블에서 채운다. --%>
          <div class="col-md-6">
            <label class="form-label" for="deptCode">部署 <span class="text-danger">*</span></label>
            <select class="form-select" name="dept_code" id="deptCode" required>
              <option value="">選択してください</option>
              <c:forEach var="dept" items="${departmentList}">
                <option value="${dept.dept_code}"
                        ${employee.dept_code eq dept.dept_code ? 'selected' : ''}>
                  <c:out value="${dept.dept_name}"/> (${dept.dept_code})
                </option>
              </c:forEach>
            </select>
          </div>

          <%-- ==================== 직위 ==================== --%>
          <div class="col-md-6">
            <label class="form-label" for="position">職位 <span class="text-danger">*</span></label>
            <select class="form-select" name="position" id="position" required>
              <option value="">選択してください</option>
              <c:forEach var="pos" items="社員,主任,代理,課長,次長,部長,理事">
                <option value="${pos}" ${employee.position eq pos ? 'selected' : ''}>
                  <c:out value="${pos}"/>
                </option>
              </c:forEach>
            </select>
          </div>

          <%-- ==================== 권한 ==================== --%>
          <div class="col-md-6">
            <label class="form-label" for="authRole">ロール</label>
            <select class="form-select" name="auth_role" id="authRole">
              <option value="USER"  ${employee.auth_role ne 'ADMIN' ? 'selected' : ''}>一般社員</option>
              <option value="ADMIN" ${employee.auth_role eq 'ADMIN' ? 'selected' : ''}>管理者</option>
            </select>
            <div class="form-text">管理者は社員管理・システム状況にアクセスできます。</div>
          </div>

          <%-- ==================== 재직 상태 (수정 모드에서만) ==================== --%>
          <c:if test="${editMode}">
            <div class="col-md-6">
              <label class="form-label" for="empStatus">在職状況</label>
              <select class="form-select" name="emp_status" id="empStatus">
                <option value="在職" ${employee.emp_status eq '在職' ? 'selected' : ''}>在職</option>
                <option value="休職" ${employee.emp_status eq '休職' ? 'selected' : ''}>休職</option>
                <option value="退職" ${employee.emp_status eq '退職' ? 'selected' : ''}>退職</option>
              </select>
              <div class="form-text">退職にするとログインできなくなります。</div>
            </div>
          </c:if>

          <%-- ==================== 연락처 ==================== --%>
          <div class="col-md-6">
            <label class="form-label" for="email">メールアドレス</label>
            <input type="email" class="form-control" id="email" name="email"
                   maxlength="120" placeholder="name@infralink.co.jp"
                   value="<c:out value='${employee.email}'/>">
          </div>

          <div class="col-md-6">
            <label class="form-label" for="extNo">内線番号</label>
            <input type="text" class="form-control" id="extNo" name="ext_no"
                   maxlength="20" placeholder="100"
                   value="<c:out value='${employee.ext_no}'/>">
          </div>

          <div class="col-md-6">
            <label class="form-label" for="phone">電話番号</label>
            <input type="text" class="form-control" id="phone" name="phone"
                   maxlength="30" placeholder="090-1111-0001"
                   value="<c:out value='${employee.phone}'/>">
          </div>

        </div>

        <div class="form-actions justify-content-end">
          <button type="button" class="btn btn-outline-secondary"
                  onclick="location.href='${cp}/pages/admin-employees.do'">戻る</button>
          <button type="submit" class="btn btn-teal">
            <i class="bi bi-save"></i> ${editMode ? '更新' : '保存'}
          </button>
        </div>
      </form>
    </div>

  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>

<script>
  // employee-register.js 가 AJAX 주소를 만들 때 쓴다
  const contextPath = '${cp}';
</script>
<%-- 사번 미리보기는 신규 등록일 때만 필요하다 --%>
<c:if test="${not editMode}">
  <script src="${cp}/js/employee-register.js"></script>
</c:if>
</body>
</html>
