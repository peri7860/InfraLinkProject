<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  자유게시판 목록

  [수정] 2026-09-07
    변경 전 : 게시글이 HTML 하드코딩. 테이블도 DAO 도 없었다.
              탭 링크가 "board-list.html" 이라 눌러도 404 였다.
    변경 후 : BoardListService 가 담아준 boardList / paging 을 그린다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>自由掲示板 | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">
</head>
<body data-page="board">
<%@ include file="/WEB-INF/components/header.jsp"%>
<%@ include file="/WEB-INF/components/modal.jsp"%>

<section class="sub-banner">
  <div class="container">
    <h1><i class="bi bi-clipboard2-data"></i> 掲示板</h1>
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${cp}/index.do">ホーム</a></li>
        <li class="breadcrumb-item active" aria-current="page">自由掲示板</li>
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
          <div class="alert alert-success py-2 px-3 small">投稿を登録しました。</div>
        </c:if>
        <c:if test="${param.result eq 'deleted'}">
          <div class="alert alert-success py-2 px-3 small">投稿を削除しました。</div>
        </c:if>

        <%-- ==================== 분류 탭 ====================
             [수정] 기존 탭은 href="board-list.html" 이라 404 였다. --%>
        <ul class="nav nav-pills gap-2 mb-3">
          <li class="nav-item">
            <a class="nav-link ${empty category ? 'active btn-teal text-white' : ''}"
               href="${cp}/pages/board.do">全体</a>
          </li>
          <c:forEach var="cat" items="自由,質問,情報,サークル">
            <li class="nav-item">
              <a class="nav-link ${category eq cat ? 'active btn-teal text-white' : ''}"
                 href="${cp}/pages/board.do?category=${cat}"><c:out value="${cat}"/></a>
            </li>
          </c:forEach>
        </ul>

        <%-- ==================== 검색 ==================== --%>
        <form class="filter-bar" method="get" action="${cp}/pages/board.do">
          <input type="hidden" name="category" value="<c:out value='${category}'/>">
          <div class="input-group input-group-sm ms-auto" style="max-width:300px;">
            <input type="text" name="keyword" class="form-control"
                   placeholder="タイトル・本文を検索"
                   value="<c:out value='${keyword}'/>">
            <button class="btn btn-teal" type="submit" aria-label="検索">
              <i class="bi bi-search"></i>
            </button>
          </div>
          <c:if test="${not empty keyword}">
            <a href="${cp}/pages/board.do" class="btn btn-outline-secondary btn-sm">
              <i class="bi bi-x-lg"></i>
            </a>
          </c:if>
        </form>

        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-list-ul"></i> 投稿一覧</h5>
            <span class="text-muted" style="font-size:.8rem;">全 ${paging.totalCount}件</span>
          </div>

          <div class="table-scroll">
            <table class="table list-table mb-0">
              <thead>
                <tr>
                  <th style="width:60px;"  class="text-center">No</th>
                  <th style="width:90px;"  class="text-center">区分</th>
                  <th>タイトル</th>
                  <th style="width:140px;" class="text-center">作成者</th>
                  <th style="width:110px;" class="text-center">登録日</th>
                  <th style="width:70px;"  class="text-center">閲覧</th>
                </tr>
              </thead>
              <tbody>

                <c:forEach var="board" items="${boardList}">
                  <tr>
                    <td class="text-center">${board.board_no}</td>
                    <td class="text-center">
                      <span class="badge-normal"><c:out value="${board.category}"/></span>
                    </td>
                    <td>
                      <a href="${cp}/pages/board-view.do?no=${board.board_no}"
                         class="title-link"><c:out value="${board.title}"/></a>

                      <%-- 댓글 수 (스칼라 서브쿼리로 목록과 함께 가져온다) --%>
                      <c:if test="${board.comment_count > 0}">
                        <span class="text-teal small ms-1">[${board.comment_count}]</span>
                      </c:if>
                      <c:if test="${board.hasFile}">
                        <i class="bi bi-paperclip text-muted ms-1" title="添付あり"></i>
                      </c:if>
                    </td>
                    <td class="text-center"><c:out value="${board.emp_name}"/></td>
                    <td class="text-center">${board.reg_date}</td>
                    <td class="text-center">${board.read_count}</td>
                  </tr>
                </c:forEach>

                <c:if test="${empty boardList}">
                  <tr>
                    <td colspan="6" class="text-center py-5">
                      <div class="empty-state">
                        <i class="bi bi-clipboard2-data"></i>
                        <h6>投稿はありません</h6>
                        <p class="small mb-0">最初の投稿を書いてみませんか。</p>
                      </div>
                    </td>
                  </tr>
                </c:if>

              </tbody>
            </table>
          </div>
        </div>

        <div class="d-flex justify-content-end align-items-center mt-3">
          <a href="${cp}/pages/board-write.do" class="btn btn-teal btn-sm">
            <i class="bi bi-pencil-square"></i> 投稿する
          </a>
        </div>

        <c:set var="pagingUrl"   value="${cp}/pages/board.do"/>
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
