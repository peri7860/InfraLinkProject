<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  게시글 작성 / 수정

  [수정] 2026-09-07
    변경 전 : action / method / enctype / name 이 전부 없는 더미 폼.
              board.js 가 submit 을 preventDefault() 로 막았다.
              빵부스러기와 취소 버튼이 .html 링크였다.
    변경 후 : 등록(boardInsert.do) / 수정(boardUpdate.do) 으로 POST.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${editMode ? '投稿編集' : '投稿作成'} | InfraLink</title>

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
        <li class="breadcrumb-item"><a href="${cp}/pages/board.do">掲示板</a></li>
        <li class="breadcrumb-item active" aria-current="page">${editMode ? '編集' : '作成'}</li>
      </ol>
    </nav>
  </div>
</section>

<div id="app-content">
  <div class="container content-wrap">
    <div class="row g-4">
      <aside class="col-lg-3"><%@ include file="/WEB-INF/components/sidebar.jsp"%></aside>

      <section class="col-lg-9">
        <div class="panel">
          <div class="panel-header">
            <h5><i class="bi bi-pencil-square"></i> ${editMode ? '投稿編集' : '投稿作成'}</h5>
            <span class="small text-muted">* 必須項目</span>
          </div>

          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
              <i class="bi bi-exclamation-circle"></i> <c:out value="${errorMessage}"/>
            </div>
          </c:if>

          <form class="form-panel" id="boardWriteForm"
                method="post"
                enctype="multipart/form-data"
                action="${cp}/pages/${editMode ? 'boardUpdate.do' : 'boardInsert.do'}">

            <c:if test="${editMode}">
              <input type="hidden" name="no" value="${board.board_no}">
            </c:if>

            <div class="mb-3">
              <label class="form-label" for="boardCategory">区分</label>
              <select class="form-select" id="boardCategory" name="category" style="max-width:220px;">
                <c:set var="cat" value="${empty board.category ? '自由' : board.category}"/>
                <option value="自由"     ${cat eq '自由'     ? 'selected' : ''}>自由</option>
                <option value="質問"     ${cat eq '質問'     ? 'selected' : ''}>質問</option>
                <option value="情報"     ${cat eq '情報'     ? 'selected' : ''}>情報</option>
                <option value="サークル" ${cat eq 'サークル' ? 'selected' : ''}>サークル</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label" for="boardTitle">
                タイトル <span class="text-danger">*</span>
              </label>
              <input type="text" class="form-control" id="boardTitle" name="title"
                     maxlength="300" required
                     placeholder="タイトルを入力してください"
                     value="<c:out value='${board.title}'/>">
            </div>

            <div class="mb-3">
              <label class="form-label" for="boardContent">
                内容 <span class="text-danger">*</span>
              </label>
              <textarea class="form-control" id="boardContent" name="content"
                        rows="12" required
                        placeholder="内容を入力してください"><c:out value="${board.content}"/></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label" for="boardFile">添付ファイル</label>
              <input type="file" class="form-control" id="boardFile" name="file_path">
              <div class="form-text">
                最大 10MB /
                <c:out value="${empty allowedExt ? 'pdf, docx, xlsx, png, jpg など' : allowedExt}"/>
              </div>

              <c:if test="${editMode and board.hasFile}">
                <div class="border rounded p-2 mt-2 small" style="background:#f7f9fa;">
                  <i class="bi bi-paperclip"></i>
                  現在の添付 : <c:out value="${board.displayFileName}"/>
                  <div class="form-check mt-1">
                    <input class="form-check-input" type="checkbox"
                           id="removeFile" name="remove_file" value="1">
                    <label class="form-check-label" for="removeFile">
                      この添付ファイルを削除する
                    </label>
                  </div>
                </div>
              </c:if>
            </div>

            <div class="form-actions">
              <a href="${editMode ? cp.concat('/pages/board-view.do?no=').concat(board.board_no) : cp.concat('/pages/board.do')}"
                 class="btn btn-outline-secondary px-4">キャンセル</a>
              <button type="submit" class="btn btn-teal px-4">
                ${editMode ? '修正する' : '登録する'}
              </button>
            </div>
          </form>
        </div>
      </section>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
<script src="${cp}/js/common.js"></script>
<script src="${cp}/js/board.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
