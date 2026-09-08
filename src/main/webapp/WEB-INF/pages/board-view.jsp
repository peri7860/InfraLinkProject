<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--
  =====================================================================
  게시글 상세 + 댓글

  [수정] 2026-09-07
    변경 전 : 본문과 댓글 3건이 전부 하드코딩. 댓글 등록 버튼은
              board.js 가 alert("2段階で実装予定") 만 띄웠다.
              빵부스러기와 목록 링크가 .html 이라 404 였다.
    변경 후 : BoardViewService 가 담아준 board / commentList 를 그리고
              댓글 등록·삭제가 실제로 동작한다.
  =====================================================================
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${empty board ? '投稿' : board.title}"/> | InfraLink</title>

<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${cp}/css/common.css">
<link rel="stylesheet" href="${cp}/css/header.css">
<link rel="stylesheet" href="${cp}/css/footer.css">
<link rel="stylesheet" href="${cp}/css/responsive.css">

<style>
.view-body .board-content { white-space: pre-wrap; word-break: break-word; }
.comment-text { white-space: pre-wrap; word-break: break-word; }
</style>
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

        <c:if test="${empty board}">
          <div class="panel">
            <div class="empty-state py-5">
              <i class="bi bi-exclamation-circle"></i>
              <h6><c:out value="${empty errorMessage ? '投稿が見つかりません。' : errorMessage}"/></h6>
              <a href="${cp}/pages/board.do" class="btn btn-teal btn-sm mt-3">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty board}">

          <c:if test="${param.result eq 'updated'}">
            <div class="alert alert-success py-2 px-3 small">投稿を更新しました。</div>
          </c:if>
          <c:if test="${param.result eq 'no_permission'}">
            <div class="alert alert-warning py-2 px-3 small">この操作を行う権限がありません。</div>
          </c:if>
          <c:if test="${param.result eq 'empty_comment'}">
            <div class="alert alert-warning py-2 px-3 small">コメントを入力してください。</div>
          </c:if>

          <div class="panel">
            <div class="view-header">
              <span class="badge-normal mb-2 d-inline-block"><c:out value="${board.category}"/></span>
              <h2><c:out value="${board.title}"/></h2>
              <div class="view-meta">
                <span><i class="bi bi-person"></i>
                  <c:out value="${board.emp_name}"/>
                  <c:if test="${not empty board.dept_name}">（<c:out value="${board.dept_name}"/>）</c:if>
                </span>
                <span><i class="bi bi-calendar3"></i> ${board.reg_date}</span>
                <c:if test="${board.modified}">
                  <span><i class="bi bi-pencil"></i> 修正 ${board.upd_date}</span>
                </c:if>
                <span><i class="bi bi-eye"></i> 閲覧 ${board.read_count}</span>
              </div>
            </div>

            <div class="view-body">
              <div class="board-content"><c:out value="${board.content}"/></div>
            </div>

            <c:if test="${board.hasFile}">
              <div class="px-3 pb-3">
                <div class="border rounded p-2 small" style="background:#f7f9fa;">
                  <i class="bi bi-paperclip"></i> 添付ファイル :
                  <a href="${cp}/pages/download.do?type=board&no=${board.board_no}">
                    <c:out value="${board.displayFileName}"/>
                  </a>
                </div>
              </div>
            </c:if>

            <div class="view-footer">
              <a href="${cp}/pages/board.do" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-list"></i> 一覧に戻る
              </a>
              <c:if test="${canEdit}">
                <div class="d-flex gap-2">
                  <a href="${cp}/pages/board-write.do?no=${board.board_no}"
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

          <%-- ==================== 댓글 ==================== --%>
          <div class="panel mt-3">
            <div class="panel-header">
              <h5>
                <i class="bi bi-chat-dots"></i> コメント
                <span class="text-teal">${fn:length(commentList)}</span>
              </h5>
            </div>

            <div class="p-3">

              <c:forEach var="comment" items="${commentList}">
                <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
                  <%-- 이름 첫 글자를 아바타로 쓴다 --%>
                  <div class="employee-card avatar"
                       style="width:38px;height:38px;font-size:.9rem;flex-shrink:0;">
                    <c:out value="${fn:substring(comment.emp_name, 0, 1)}"/>
                  </div>
                  <div class="flex-grow-1">
                    <div class="fw-bold small">
                      <c:out value="${comment.emp_name}"/>
                      <c:if test="${comment.employee_id eq loginId}">
                        <span class="badge-normal ms-1">本人</span>
                      </c:if>
                      <span class="text-muted fw-normal ms-2" style="font-size:.75rem;">
                        ${comment.reg_date}
                      </span>
                    </div>
                    <div class="small mt-1 comment-text"><c:out value="${comment.content}"/></div>

                    <%-- 삭제는 본인 댓글만. 서버(DAO)에서도 한 번 더 막는다 --%>
                    <c:if test="${comment.employee_id eq loginId}">
                      <div class="mt-2">
                        <form method="post" action="${cp}/pages/comment.do" class="d-inline"
                              onsubmit="return confirm('このコメントを削除しますか？');">
                          <input type="hidden" name="mode" value="delete">
                          <input type="hidden" name="no" value="${board.board_no}">
                          <input type="hidden" name="comment_no" value="${comment.comment_no}">
                          <button type="submit" class="btn btn-link text-danger btn-sm p-0">削除</button>
                        </form>
                      </div>
                    </c:if>
                  </div>
                </div>
              </c:forEach>

              <c:if test="${empty commentList}">
                <p class="text-muted small text-center py-3 mb-0">
                  まだコメントはありません。最初のコメントを書いてみましょう。
                </p>
              </c:if>

              <%-- 댓글 입력 --%>
              <form method="post" action="${cp}/pages/comment.do" class="d-flex gap-2 mt-3">
                <input type="hidden" name="mode" value="add">
                <input type="hidden" name="no" value="${board.board_no}">
                <input type="text" class="form-control form-control-sm" id="commentInput"
                       name="content" maxlength="2000" required
                       placeholder="コメントを入力してください">
                <button type="submit" class="btn btn-teal btn-sm" id="commentSubmitBtn">登録</button>
              </form>
            </div>
          </div>

          <%-- ==================== 삭제 확인 모달 ==================== --%>
          <c:if test="${canEdit}">
            <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title">投稿の削除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
                  </div>
                  <div class="modal-body">
                    <p class="mb-1">この投稿を削除しますか？</p>
                    <p class="small text-muted mb-0">コメントと添付ファイルも一緒に削除されます。</p>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">キャンセル</button>
                    <form method="post" action="${cp}/pages/boardDelete.do" class="d-inline">
                      <input type="hidden" name="no" value="${board.board_no}">
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
<script src="${cp}/js/board.js"></script>
<%@ include file="/WEB-INF/components/footer.jsp"%>
</body>
</html>
