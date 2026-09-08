<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  시스템 현황 (관리자 전용)

  [신규 생성] 2026-09-07
    pages.java 에 "/system-status.do" 라우트는 있었는데
    이 JSP 파일이 아예 없어서 접근하면 500 에러가 났다.
    SystemStatusService 와 함께 새로 만들었다.

  표시 내용은 전부 SystemStatusService 가 request 에 담아 넘긴다.
  비밀번호 등 민감한 설정값은 넘어오지 않는다.
  =====================================================================
--%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>システム状況 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<%-- [수정 방침] 다른 화면의 ../css/ 상대경로 대신 contextPath 를 쓴다.
     상대경로는 URL 깊이가 바뀌면 그대로 깨진다. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">

<style>
/* 이 화면에서만 쓰는 상태 표시 */
.status-dot { display:inline-block; width:9px; height:9px; border-radius:50%; margin-right:6px; }
.status-dot.up   { background:#198754; }
.status-dot.down { background:#dc3545; }
.kv { display:grid; grid-template-columns:170px 1fr; gap:8px 16px; font-size:.92rem; }
.kv dt { color:#6c757d; font-weight:500; }
.kv dd { margin:0; word-break:break-all; }
.mono { font-family:ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; font-size:.86rem; }
</style>
</head>

<body data-page="admin">
<%@ include file="../components/header.jsp"%>
<%@ include file="../components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-hdd-network"></i> システム状況</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="${pageContext.request.contextPath}/index.do">ホーム</a>
        </li>
        <li class="breadcrumb-item">
          <a href="${pageContext.request.contextPath}/pages/admin-dashboard.do">管理者</a>
        </li>
        <li class="breadcrumb-item active">システム状況</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
<div class="container content-wrap">

  <div class="row g-4">

    <%-- ============================ データベース ============================ --%>
    <div class="col-lg-6">
      <div class="panel h-100">
        <div class="panel-header">
          <h5><i class="bi bi-database"></i> データベース</h5>
          <c:choose>
            <c:when test="${dbOk}">
              <span class="status-pill status-done">
                <span class="status-dot up"></span>接続中
              </span>
            </c:when>
            <c:otherwise>
              <span class="status-pill status-reject">
                <span class="status-dot down"></span>接続不可
              </span>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="p-3">
          <dl class="kv mb-0">
            <dt>製品 / バージョン</dt>
            <dd class="mono"><c:out value="${dbProduct}"/></dd>

            <dt>接続 URL</dt>
            <dd class="mono"><c:out value="${dbUrl}"/></dd>
          </dl>

          <c:if test="${not empty dbError}">
            <div class="alert alert-danger mt-3 mb-0 small">
              <strong>接続エラー</strong><br>
              <span class="mono"><c:out value="${dbError}"/></span>
              <hr class="my-2">
              確認事項 : Oracle サービスの起動 /
              <span class="mono">db.properties</span> のアカウント /
              <span class="mono">WEB-INF/lib</span> の ojdbc jar
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <%-- ============================ サーバー ============================ --%>
    <div class="col-lg-6">
      <div class="panel h-100">
        <div class="panel-header">
          <h5><i class="bi bi-cpu"></i> サーバー</h5>
        </div>

        <div class="p-3">
          <dl class="kv">
            <dt>コンテナ</dt>
            <dd class="mono"><c:out value="${serverInfo}"/></dd>

            <dt>Servlet API</dt>
            <dd class="mono"><c:out value="${servletVersion}"/></dd>

            <dt>Java</dt>
            <dd class="mono"><c:out value="${javaVersion}"/></dd>

            <dt>OS</dt>
            <dd class="mono"><c:out value="${osName}"/></dd>

            <dt>コンテキスト</dt>
            <dd class="mono"><c:out value="${contextPath}"/></dd>
          </dl>

          <%-- 메모리 사용률 --%>
          <div class="mt-3">
            <div class="d-flex justify-content-between small mb-1">
              <span class="text-muted">ヒープメモリ</span>
              <span class="mono">${memUsedMb} MB / ${memMaxMb} MB</span>
            </div>
            <div class="progress" style="height:8px;">
              <%-- 80% 넘으면 경고색 --%>
              <div class="progress-bar ${memPercent >= 80 ? 'bg-danger' : 'bg-success'}"
                   role="progressbar"
                   style="width:${memPercent}%"
                   aria-valuenow="${memPercent}" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <%-- ============================ ファイル保存領域 ============================ --%>
    <div class="col-lg-6">
      <div class="panel h-100">
        <div class="panel-header">
          <h5><i class="bi bi-folder2-open"></i> 添付ファイル保存領域</h5>
          <c:choose>
            <c:when test="${uploadOk}">
              <span class="status-pill status-done">
                <span class="status-dot up"></span>書き込み可
              </span>
            </c:when>
            <c:otherwise>
              <span class="status-pill status-reject">
                <span class="status-dot down"></span>書き込み不可
              </span>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="p-3">
          <dl class="kv mb-0">
            <dt>保存パス</dt>
            <dd class="mono"><c:out value="${uploadPath}"/></dd>

            <dt>保存件数</dt>
            <dd class="mono">${uploadCount} 件</dd>

            <dt>1件あたり上限</dt>
            <dd class="mono">${maxUploadMb} MB</dd>

            <dt>許可拡張子</dt>
            <dd class="mono small"><c:out value="${allowedExt}"/></dd>
          </dl>

          <c:if test="${not uploadOk}">
            <div class="alert alert-warning mt-3 mb-0 small">
              保存フォルダに書き込めません。
              <span class="mono">db.properties</span> の
              <span class="mono">upload.dir</span> と
              フォルダの権限をご確認ください。
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <%-- ============================ 利用状況 ============================ --%>
    <div class="col-lg-6">
      <div class="panel h-100">
        <div class="panel-header">
          <h5><i class="bi bi-people"></i> 利用状況</h5>
        </div>

        <div class="p-3">
          <c:choose>
            <c:when test="${dbOk}">
              <div class="row text-center g-3">
                <div class="col-4">
                  <div class="text-muted small mb-1">全社員</div>
                  <div class="fs-3 fw-bold mono">${totalEmployee}</div>
                </div>
                <div class="col-4">
                  <div class="text-muted small mb-1">在職</div>
                  <div class="fs-3 fw-bold mono text-success">${activeEmployee}</div>
                </div>
                <div class="col-4">
                  <div class="text-muted small mb-1">本日出勤</div>
                  <div class="fs-3 fw-bold mono">${todayCheckIn}</div>
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <p class="text-muted small mb-0">
                データベースに接続できないため表示できません。
              </p>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

  </div>

  <div class="mt-4 d-flex gap-2">
    <a href="${pageContext.request.contextPath}/pages/admin-dashboard.do"
       class="btn btn-outline-secondary">
      <i class="bi bi-arrow-left"></i> 管理者ダッシュボードへ
    </a>
    <button type="button" class="btn btn-teal" onclick="location.reload()">
      <i class="bi bi-arrow-clockwise"></i> 再読み込み
    </button>
  </div>

</div>
</div>

<%@ include file="../components/footer.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</body>
</html>
