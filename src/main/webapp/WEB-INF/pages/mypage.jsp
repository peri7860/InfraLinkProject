<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  마이페이지

  [수정] 2026-09-07
    변경 전 : 이름·부서·연락처가 전부 "山田 太郎" 로 하드코딩.
              개인정보 수정 폼과 비밀번호 변경 폼에 action 이 없어
              UpdateMyInfoService / ChangePasswordService 를
              호출하는 곳이 프로젝트 전체에 한 곳도 없었다.
    변경 후 : MyPageService 의 employee 를 그리고,
              두 폼을 각각의 서비스로 POST 한다.

  초기 비밀번호(사번과 동일) 상태면 상단에 변경을 유도하는 안내를 띄운다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>マイページ | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="mypage">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-person-gear"></i> マイページ</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">マイページ</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <%-- ==================== 초기 비밀번호 안내 ==================== --%>
        <c:if test="${needPwdChange}">
          <div class="alert alert-warning py-2 px-3 small">
            <i class="bi bi-shield-exclamation"></i>
            <strong>初期パスワードのままです。</strong>
            セキュリティのため、下の「パスワード変更」から変更してください。
          </div>
        </c:if>

        <%-- ==================== 개인정보 수정 결과 ==================== --%>
        <c:if test="${param.result eq 'success'}">
          <div class="alert alert-success py-2 px-3 small">個人情報を更新しました。</div>
        </c:if>
        <c:if test="${param.result eq 'invalid_email'}">
          <div class="alert alert-danger py-2 px-3 small">メールアドレスの形式が正しくありません。</div>
        </c:if>
        <c:if test="${param.result eq 'fail'}">
          <div class="alert alert-danger py-2 px-3 small">更新に失敗しました。</div>
        </c:if>

        <%-- ==================== 비밀번호 변경 결과 ==================== --%>
        <c:if test="${param.pwdResult eq 'success'}">
          <div class="alert alert-success py-2 px-3 small">パスワードを変更しました。</div>
        </c:if>
        <c:if test="${param.pwdResult eq 'fail_mismatch'}">
          <div class="alert alert-danger py-2 px-3 small">現在のパスワードが正しくありません。</div>
        </c:if>
        <c:if test="${param.pwdResult eq 'fail_confirm'}">
          <div class="alert alert-danger py-2 px-3 small">新しいパスワードの確認が一致しません。</div>
        </c:if>
        <c:if test="${param.pwdResult eq 'fail_policy'}">
          <div class="alert alert-danger py-2 px-3 small">
            パスワードは8文字以上で、英字と数字を含めてください。
          </div>
        </c:if>
        <c:if test="${param.pwdResult eq 'fail_same'}">
          <div class="alert alert-danger py-2 px-3 small">
            現在のパスワードと同じものは使用できません。
          </div>
        </c:if>
        <c:if test="${param.pwdResult eq 'empty'}">
          <div class="alert alert-danger py-2 px-3 small">パスワードを入力してください。</div>
        </c:if>

        <%-- ==================== 프로필 ==================== --%>
        <div class="panel mb-3">
          <div class="p-4 d-flex gap-4 align-items-center flex-wrap">
            <div class="employee-card avatar"
                 style="width:80px;height:80px;font-size:1.8rem;flex-shrink:0;">
              <c:out value="${fn:substring(employee.emp_name, 0, 1)}"/>
            </div>
            <div>
              <h2 class="h4 fw-bold mb-1"><c:out value="${employee.emp_name}"/></h2>
              <p class="text-muted mb-2">
                <c:out value="${employee.deptPosition}"/>
                <span class="ms-2"><c:out value="${employee.employee_id}"/></span>
              </p>
              <span class="status-pill status-done"><c:out value="${employee.emp_status}"/></span>
              <c:if test="${employee.admin}">
                <span class="badge-fixed ms-1">管理者</span>
              </c:if>
            </div>
          </div>
        </div>

        <%-- ==================== 이번 달 근태 요약 ==================== --%>
        <div class="row g-3 mb-3">
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">今月の勤務日数</div>
              <div class="fs-4 fw-bold">${workDays}<span class="fs-6 fw-normal">日</span></div>
            </div>
          </div>
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">総勤務時間</div>
              <div class="fs-4 fw-bold">${workHours}<span class="fs-6 fw-normal">時間</span></div>
            </div>
          </div>
          <div class="col-4">
            <div class="panel p-3 text-center">
              <div class="text-muted small mb-1">遅刻</div>
              <div class="fs-4 fw-bold ${lateCount > 0 ? 'text-danger' : ''}">
                ${lateCount}<span class="fs-6 fw-normal">回</span>
              </div>
            </div>
          </div>
        </div>

        <div class="row g-3">

          <%-- ==================== 개인정보 수정 ==================== --%>
          <div class="col-lg-6">
            <div class="panel h-100">
              <div class="panel-header">
                <h5><i class="bi bi-person-lines-fill"></i> 個人情報</h5>
              </div>

              <%-- [수정] 기존에는 action 이 없어 어디로도 전송되지 않았다 --%>
              <form class="form-panel" method="post" action="${cp}/pages/updateMyInfo.do">

                <div class="mb-3">
                  <label class="form-label">社員番号</label>
                  <div class="form-control bg-light"><c:out value="${employee.employee_id}"/></div>
                </div>

                <div class="mb-3">
                  <label class="form-label">部署 / 職位</label>
                  <div class="form-control bg-light"><c:out value="${employee.deptPosition}"/></div>
                  <div class="form-text">部署・職位の変更は管理者へご依頼ください。</div>
                </div>

                <div class="mb-3">
                  <label class="form-label" for="email">メールアドレス</label>
                  <input type="email" class="form-control" id="email" name="email"
                         maxlength="120" value="<c:out value='${employee.email}'/>">
                </div>

                <div class="mb-3">
                  <label class="form-label" for="extNo">内線番号</label>
                  <input type="text" class="form-control" id="extNo" name="ext_no"
                         maxlength="20" value="<c:out value='${employee.ext_no}'/>">
                </div>

                <div class="mb-3">
                  <label class="form-label" for="phone">携帯電話</label>
                  <input type="text" class="form-control" id="phone" name="phone"
                         maxlength="30" value="<c:out value='${employee.phone}'/>">
                </div>

                <div class="form-actions justify-content-end">
                  <button type="submit" class="btn btn-teal">
                    <i class="bi bi-save"></i> 保存
                  </button>
                </div>
              </form>
            </div>
          </div>

          <%-- ==================== 비밀번호 변경 ==================== --%>
          <div class="col-lg-6">
            <div class="panel h-100" id="passwordPanel">
              <div class="panel-header">
                <h5><i class="bi bi-shield-lock"></i> パスワード変更</h5>
              </div>

              <%-- [수정] 기존에는 action 이 없어 어디로도 전송되지 않았다 --%>
              <form class="form-panel" method="post" action="${cp}/pages/changePassword.do"
                    id="passwordForm">

                <div class="mb-3">
                  <label class="form-label" for="currentPassword">
                    現在のパスワード <span class="text-danger">*</span>
                  </label>
                  <input type="password" class="form-control" id="currentPassword"
                         name="current_password" required autocomplete="current-password">
                </div>

                <div class="mb-3">
                  <label class="form-label" for="newPassword">
                    新しいパスワード <span class="text-danger">*</span>
                  </label>
                  <input type="password" class="form-control" id="newPassword"
                         name="new_password" required autocomplete="new-password">
                  <div class="form-text">8文字以上・英字と数字を含めてください。</div>
                </div>

                <div class="mb-3">
                  <label class="form-label" for="confirmPassword">
                    新しいパスワード（確認） <span class="text-danger">*</span>
                  </label>
                  <input type="password" class="form-control" id="confirmPassword"
                         name="confirm_password" required autocomplete="new-password">
                </div>

                <div class="form-actions justify-content-end">
                  <button type="submit" class="btn btn-teal">
                    <i class="bi bi-key"></i> 変更する
                  </button>
                </div>
              </form>
            </div>
          </div>

        </div>

      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<script>
// 비밀번호 확인 일치 여부를 보내기 전에 확인한다 (서버도 같은 검사를 한다)
(function () {
  "use strict";
  document.addEventListener("DOMContentLoaded", function () {

    var form = document.getElementById("passwordForm");
    if (!form) return;

    form.addEventListener("submit", function (e) {
      var pw = document.getElementById("newPassword");
      var confirm = document.getElementById("confirmPassword");

      if (pw.value !== confirm.value) {
        e.preventDefault();
        alert("新しいパスワードの確認が一致しません。");
        confirm.focus();
        return;
      }
      // 8자 이상 + 영문/숫자 (PasswordUtil.isValidPolicy 와 같은 규칙)
      if (!/^(?=.*[A-Za-z])(?=.*\d).{8,}$/.test(pw.value)) {
        e.preventDefault();
        alert("パスワードは8文字以上で、英字と数字を含めてください。");
        pw.focus();
      }
    });

    // 초기 비밀번호 안내로 들어온 경우 변경 폼으로 스크롤
    if (location.search.indexOf("pwdChange=1") >= 0) {
      var panel = document.getElementById("passwordPanel");
      if (panel) panel.scrollIntoView({ behavior: "smooth", block: "center" });
    }
  });
})();
</script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
