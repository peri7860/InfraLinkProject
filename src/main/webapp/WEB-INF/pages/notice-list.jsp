<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  공지사항 목록

  [수정] 2026-09-07
    변경 전 : 공지 8건이 HTML 에 하드코딩. 검색창·분류 select 는 동작하지
              않았고, 페이지 번호(1 2 3 4 5)도 고정에 href="#" 이었다.
              상세로 가는 링크 15곳 전부 ?no= 파라미터가 없어서
              어떤 글인지 알 수 없는 구조였다.
    변경 후 : NoticeListService 가 담아준 noticeList / paging 을 그린다.
              검색·분류 필터가 실제로 동작하고, 링크에 ?no= 가 붙는다.

  XSS : 사용자가 입력한 값(제목·작성자)은 반드시 <c:out> 으로 이스케이프한다.
        ${...} 로 그냥 출력하면 제목에 <script> 를 넣어 저장했을 때 실행된다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>お知らせ一覧 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
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
        <li class="breadcrumb-item active" aria-current="page">お知らせ</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">

        <%-- ==================== 처리 결과 안내 ==================== --%>
        <c:if test="${param.result eq 'created'}">
          <div class="alert alert-success py-2 px-3 small">お知らせを登録しました。</div>
        </c:if>
        <c:if test="${param.result eq 'deleted'}">
          <div class="alert alert-success py-2 px-3 small">お知らせを削除しました。</div>
        </c:if>
        <c:if test="${param.result eq 'not_found'}">
          <div class="alert alert-warning py-2 px-3 small">対象のお知らせが見つかりません。</div>
        </c:if>

        <%-- ==================== 검색 / 필터 바 ====================
             GET 으로 제출한다. 그래야 검색 결과 URL 을 그대로 공유할 수 있고
             페이지 이동 시에도 조건이 유지된다.                        --%>
        <form class="filter-bar" method="get" action="${cp}/pages/notice.do">

          <select name="category" class="form-select form-select-sm" style="width:140px;"
                  onchange="this.form.submit()">
            <option value="">全区分</option>
            <%-- 선택 상태를 유지한다 --%>
            <option value="人事" ${category eq '人事' ? 'selected' : ''}>人事</option>
            <option value="総務" ${category eq '総務' ? 'selected' : ''}>総務</option>
            <option value="IT"   ${category eq 'IT'   ? 'selected' : ''}>IT</option>
            <option value="緊急" ${category eq '緊急' ? 'selected' : ''}>緊急</option>
            <option value="一般" ${category eq '一般' ? 'selected' : ''}>一般</option>
          </select>

          <div class="input-group input-group-sm ms-auto" style="max-width:300px;">
            <input type="text" name="keyword" class="form-control"
                   placeholder="タイトル・本文を検索"
                   value="<c:out value='${keyword}'/>">
            <button class="btn btn-teal" type="submit" aria-label="検索">
              <i class="bi bi-search"></i>
            </button>
          </div>

          <%-- 검색어가 있으면 초기화 버튼을 보여준다 --%>
          <c:if test="${not empty keyword or not empty category}">
            <a href="${cp}/pages/notice.do" class="btn btn-outline-secondary btn-sm">
              <i class="bi bi-x-lg"></i>
            </a>
          </c:if>
        </form>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-list-ul"></i> お知らせ一覧</h5>
            <span class="text-muted" style="font-size:.8rem;">
              全 ${paging.totalCount}件
              <c:if test="${not empty keyword}">
                （「<c:out value="${keyword}"/>」の検索結果）
              </c:if>
            </span>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:60px;"  class="text-center">No</th>
                  <th style="width:80px;"  class="text-center">区分</th>
                  <th>タイトル</th>
                  <th style="width:140px;" class="text-center">作成者</th>
                  <th style="width:110px;" class="text-center">登録日</th>
                  <th style="width:70px;"  class="text-center">閲覧</th>
                </tr>
              </thead>
              <tbody>

                <c:forEach var="notice" items="${noticeList}">
                  <tr>
                    <td class="text-center">${notice.notice_no}</td>

                    <%-- 고정글은 강조 배지 --%>
                    <td class="text-center">
                      <span class="${notice.pinned ? 'badge-fixed' : 'badge-normal'}">
                        <c:out value="${empty notice.category ? '一般' : notice.category}"/>
                      </span>
                    </td>

                    <td>
                      <a href="${cp}/pages/notice-view.do?no=${notice.notice_no}"
                         class="title-link"><c:out value="${notice.title}"/></a>

                      <%-- 첨부파일이 있으면 클립 아이콘 --%>
                      <c:if test="${notice.hasFile}">
                        <i class="bi bi-paperclip text-muted ms-1" title="添付あり"></i>
                      </c:if>
                    </td>

                    <td class="text-center">
                      <c:out value="${empty notice.dept_name ? notice.emp_name : notice.dept_name}"/>
                    </td>
                    <td class="text-center">${notice.reg_date}</td>
                    <td class="text-center">${notice.read_count}</td>
                  </tr>
                </c:forEach>

                <%-- 결과가 없을 때 --%>
                <c:if test="${empty noticeList}">
                  <tr>
                    <td colspan="6" class="text-center py-5">
                      <div class="empty-state">
                        <i class="bi bi-megaphone"></i>
                        <h6>お知らせはありません</h6>
                        <p class="small mb-0">
                          <c:choose>
                            <c:when test="${not empty keyword}">
                              検索条件を変更してもう一度お試しください。
                            </c:when>
                            <c:otherwise>
                              新しいお知らせをお待ちください。
                            </c:otherwise>
                          </c:choose>
                        </p>
                      </div>
                    </td>
                  </tr>
                </c:if>

              </tbody>
            </table>
          </div>
        </div>

        <%-- 작성 버튼 : 관리자에게만 --%>
        <c:if test="${not empty loginUser and loginUser.admin}">
          <div class="d-flex justify-content-end align-items-center mt-3">
            <a href="${cp}/pages/notice-write.do" class="btn btn-teal btn-sm">
              <i class="bi bi-pencil-square"></i> お知らせ作成
            </a>
          </div>
        </c:if>

        <%-- ==================== 페이지네이션 ====================
             검색 조건을 유지한 채 페이지를 이동해야 한다.       --%>
        <c:set var="pagingUrl"   value="${cp}/pages/notice.do"/>
        <c:set var="pagingQuery" value="&keyword=${keyword}&category=${category}"/>
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
