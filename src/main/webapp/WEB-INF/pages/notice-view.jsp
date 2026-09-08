<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  공지사항 상세

  [수정] 2026-09-07
    변경 전 : 특정 공지 하나의 내용이 통째로 하드코딩. 첨부파일 이름도 고정.
              이전글/다음글 링크에 파라미터가 없어 항상 같은 곳으로 갔다.
              빵부스러기의 "お知らせ" 링크가 "${contextPath}notice.co" 라는
              오타 주소였다. (슬래시 없음 + .co)
    변경 후 : NoticeViewService 가 담아준 notice / prevNotice / nextNotice 를
              그린다. 수정·삭제 버튼은 작성자 본인 또는 관리자에게만 보인다.

  본문 줄바꿈 : DB 의 content 는 순수 텍스트다. 그대로 출력하면 줄바꿈이
                사라지므로 <c:out> 으로 이스케이프한 뒤 CSS 의
                white-space:pre-wrap 으로 줄바꿈을 살린다.
                (HTML 태그를 허용하면 XSS 가 되므로 이스케이프는 필수)
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty notice ? 'お知らせ' : notice.title}"/> | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">

<style>
/* 본문의 줄바꿈을 그대로 살린다 (이스케이프된 텍스트이므로 안전) */
.view-body .notice-content { white-space: pre-wrap; word-break: break-word; }
</style>
</head>
<body data-page="notice">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-megaphone"></i> お知らせ</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <%-- [수정] 기존에는 "${contextPath}notice.co" 라는 오타 주소였다 --%>
        <li class="breadcrumb-item"><a href="${cp}/pages/notice.do">お知らせ</a></li>
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

        <%-- ==================== 글이 없는 경우 ==================== --%>
        <c:if test="${empty notice}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-exclamation-circle"></i>
              <h6><c:out value="${empty errorMessage ? 'お知らせが見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/notice.do" class="btn btn-teal btn-sm mt-3">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty notice}">

          <%-- 처리 결과 안내 --%>
          <c:if test="${param.result eq 'updated'}">
            <div class="alert alert-success py-2 px-3 small">お知らせを更新しました。</div>
          </c:if>
          <c:if test="${param.result eq 'no_permission'}">
            <div class="alert alert-warning py-2 px-3 small">この操作を行う権限がありません。</div>
          </c:if>

          <div class="panel">
            <div class="view-header">
              <span class="${notice.pinned ? 'badge-fixed' : 'badge-normal'} mb-2 d-inline-block">
                <c:out value="${empty notice.category ? '一般' : notice.category}"/>
              </span>
              <h2><c:out value="${notice.title}"/></h2>
              <div class="view-meta">
                <span><i class="bi bi-person"></i>
                  <c:out value="${notice.emp_name}"/>
                  <c:if test="${not empty notice.dept_name}">
                    （<c:out value="${notice.dept_name}"/>）
                  </c:if>
                </span>
                <span><i class="bi bi-calendar3"></i> ${notice.reg_date}</span>
                <c:if test="${not empty notice.upd_date}">
                  <span><i class="bi bi-pencil"></i> 修正 ${notice.upd_date}</span>
                </c:if>
                <span><i class="bi bi-eye"></i> 閲覧 ${notice.read_count}</span>
              </div>
            </div>

            <div class="view-body">
              <%-- 이스케이프 + pre-wrap 으로 줄바꿈 유지 --%>
              <div class="notice-content"><c:out value="${notice.content}"/></div>
            </div>

            <%-- ==================== 첨부파일 ==================== --%>
            <c:if test="${notice.hasFile}">
              <div class="px-3 pb-3">
                <div class="border rounded p-2 small" style="background:#f7f9fa;">
                  <i class="bi bi-paperclip"></i> 添付ファイル :
                  <%-- 파일명이 아니라 글 번호로 다운로드한다 (경로 조작 차단) --%>
                  <a href="${cp}/pages/download.do?type=notice&no=${notice.notice_no}">
                    <c:out value="${notice.displayFileName}"/>
                  </a>
                </div>
              </div>
            </c:if>

            <div class="view-footer">
              <a href="${cp}/pages/notice.do" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>

              <%-- 수정/삭제는 작성자 본인 또는 관리자에게만 --%>
              <c:if test="${canEdit}">
                <div class="d-flex gap-2">
                  <a href="${cp}/pages/notice-write.do?no=${notice.notice_no}"
                     class="btn btn-outline-teal btn-sm">
                    <i class="bi bi-pencil"></i> 編集
                  </a>
                  <button type="button" class="btn btn-sm text-white"
                          style="background:var(--warn);"
                          data-bs-toggle="modal" data-bs-target="#confirmDeleteModal">
                    <i class="bi bi-trash"></i> 削除
                  </button>
                </div>
              </c:if>
            </div>
          </div>

          <%-- ==================== 이전글 / 다음글 ==================== --%>
          <div class="panel mt-3">
            <c:choose>
              <c:when test="${not empty nextNotice}">
                <a href="${cp}/pages/notice-view.do?no=${nextNotice.notice_no}"
                   class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom text-decoration-none"
                   style="color:var(--ink);">
                  <span><i class="bi bi-chevron-up text-teal me-2"></i>次の記事</span>
                  <span class="text-truncate" style="max-width:60%;">
                    <c:out value="${nextNotice.title}"/>
                  </span>
                </a>
              </c:when>
              <c:otherwise>
                <div class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom text-muted small">
                  <span><i class="bi bi-chevron-up me-2"></i>次の記事</span>
                  <span>最新の記事です</span>
                </div>
              </c:otherwise>
            </c:choose>

            <c:choose>
              <c:when test="${not empty prevNotice}">
                <a href="${cp}/pages/notice-view.do?no=${prevNotice.notice_no}"
                   class="d-flex justify-content-between align-items-center px-3 py-2 text-decoration-none"
                   style="color:var(--ink);">
                  <span><i class="bi bi-chevron-down text-teal me-2"></i>前の記事</span>
                  <span class="text-truncate" style="max-width:60%;">
                    <c:out value="${prevNotice.title}"/>
                  </span>
                </a>
              </c:when>
              <c:otherwise>
                <div class="d-flex justify-content-between align-items-center px-3 py-2 text-muted small">
                  <span><i class="bi bi-chevron-down me-2"></i>前の記事</span>
                  <span>最初の記事です</span>
                </div>
              </c:otherwise>
            </c:choose>
          </div>

          <%-- ==================== 삭제 확인 모달 ==================== --%>
          <c:if test="${canEdit}">
            <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">お知らせの削除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
                  </div>
                  <div class="modal-body">
                    <p class="mb-1">このお知らせを削除しますか？</p>
                    <p class="small text-muted mb-0">削除すると元に戻せません。添付ファイルも一緒に削除されます。</p>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">キャンセル</button>
                    <%-- 삭제는 POST 로 보낸다 (링크 클릭만으로 지워지지 않도록) --%>
                    <form method="post" action="${cp}/pages/noticeDelete.do" class="d-inline">
                      <input type="hidden" name="no" value="${notice.notice_no}">
                      <button type="submit" class="btn text-white" style="background:var(--warn);">
                        削除する
                      </button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </c:if>

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
