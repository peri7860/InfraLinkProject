<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  공지사항 작성 / 수정

  [수정] 2026-09-07
    변경 전 : 폼에 action / method / enctype 이 모두 없었고 input 에 name 도
              없었다. notice.js 가 submit 을 preventDefault() 로 막고
              alert("6단계에서 구현 예정") 만 띄워 저장 자체가 불가능했다.
              "作成部署" select 는 DB 에 저장할 컬럼조차 없는 항목이었다.
              취소 링크는 "${contextPath}notice.do" (슬래시 누락) 오타.
    변경 후 : editMode 에 따라 등록(noticeInsert.do) / 수정(noticeUpdate.do)
              으로 POST 한다. enctype 을 multipart/form-data 로 지정해야
              첨부파일이 전송된다.

  주의 : 파일 업로드가 있으므로 enctype 이 반드시 multipart/form-data 여야
         한다. 빠뜨리면 request.getPart() 가 아무것도 못 받는다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${editMode ? 'お知らせ編集' : 'お知らせ作成'} | InfraLink</title>

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
        <li class="breadcrumb-item"><a href="${cp}/pages/notice.do">お知らせ</a></li>
        <li class="breadcrumb-item active" aria-current="page">
          ${editMode ? '編集' : '作成'}
        </li>
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
            <h5>
              <i class="bi bi-pencil-square"></i>
              ${editMode ? 'お知らせ編集' : 'お知らせ作成'}
            </h5>
            <span class="small text-muted">* 必須項目</span>
          </div>

          <%-- 서버에서 돌려준 오류 메시지 --%>
          <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger py-2 px-3 small m-3 mb-0">
              <i class="bi bi-exclamation-circle"></i>
              <c:out value="${errorMessage}"/>
            </div>
          </c:if>

          <%--
            등록/수정에 따라 보내는 곳이 달라진다.
            enctype 이 없으면 파일이 전송되지 않는다.
          --%>
          <form class="form-panel" id="noticeWriteForm"
                method="post"
                enctype="multipart/form-data"
                action="${cp}/pages/${editMode ? 'noticeUpdate.do' : 'noticeInsert.do'}">

            <%-- 수정 모드일 때 대상 글 번호를 함께 보낸다 --%>
            <c:if test="${editMode}">
              <input type="hidden" name="no" value="${notice.notice_no}">
            </c:if>

            <div class="row g-3 mb-3">
              <div class="col-md-6">
                <label class="form-label" for="noticeCategory">区分</label>
                <select class="form-select" id="noticeCategory" name="category">
                  <c:set var="cat" value="${empty notice.category ? '一般' : notice.category}"/>
                  <option value="一般" ${cat eq '一般' ? 'selected' : ''}>一般</option>
                  <option value="人事" ${cat eq '人事' ? 'selected' : ''}>人事</option>
                  <option value="総務" ${cat eq '総務' ? 'selected' : ''}>総務</option>
                  <option value="IT"   ${cat eq 'IT'   ? 'selected' : ''}>IT</option>
                  <option value="緊急" ${cat eq '緊急' ? 'selected' : ''}>緊急</option>
                </select>
              </div>

              <%--
                [삭제] "作成部署" select 는 저장할 컬럼이 없는 항목이었다.
                       작성자(employee_id)로부터 부서가 결정되므로 불필요하다.
              --%>

              <div class="col-md-6">
                <label class="form-label" for="noticeVisibility">公開範囲</label>
                <select class="form-select" id="noticeVisibility" name="visibility">
                  <c:set var="vis" value="${empty notice.visibility ? 'ALL' : notice.visibility}"/>
                  <option value="ALL"  ${vis eq 'ALL'  ? 'selected' : ''}>全社員</option>
                  <option value="DEPT" ${vis eq 'DEPT' ? 'selected' : ''}>部署のみ</option>
                </select>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label" for="noticeTitle">
                タイトル <span class="text-danger">*</span>
              </label>
              <input type="text" class="form-control" id="noticeTitle" name="title"
                     maxlength="300" required
                     placeholder="タイトルを入力してください"
                     value="<c:out value='${notice.title}'/>">
            </div>

            <div class="mb-3">
              <label class="form-label" for="noticeContent">
                内容 <span class="text-danger">*</span>
              </label>
              <textarea class="form-control" id="noticeContent" name="content"
                        rows="12" required
                        placeholder="内容を入力してください"><c:out value="${notice.content}"/></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label" for="noticeFile">添付ファイル</label>
              <input type="file" class="form-control" id="noticeFile" name="file_path">
              <div class="form-text">
                最大 10MB /
                <c:out value="${empty allowedExt ? 'pdf, docx, xlsx, png, jpg など' : allowedExt}"/>
              </div>

              <%-- 수정 모드에서 기존 첨부가 있으면 표시하고 삭제 선택지를 준다 --%>
              <c:if test="${editMode and notice.hasFile}">
                <div class="border rounded p-2 mt-2 small" style="background:#f7f9fa;">
                  <i class="bi bi-paperclip"></i>
                  現在の添付 : <c:out value="${notice.displayFileName}"/>
                  <div class="form-check mt-1">
                    <input class="form-check-input" type="checkbox"
                           id="removeFile" name="remove_file" value="1">
                    <label class="form-check-label" for="removeFile">
                      この添付ファイルを削除する
                    </label>
                  </div>
                  <div class="text-muted mt-1">
                    ※ 新しいファイルを選ぶと、既存の添付は置き換えられます。
                  </div>
                </div>
              </c:if>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="noticePin"
                     name="pin_yn" value="Y" ${notice.pinned ? 'checked' : ''}>
              <label class="form-check-label small" for="noticePin">
                上部固定表示にする
              </label>
            </div>

            <div class="form-actions">
              <a href="${editMode ? cp.concat('/pages/notice-view.do?no=').concat(notice.notice_no) : cp.concat('/pages/notice.do')}"
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
<script src="${cp}/js/notice.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
