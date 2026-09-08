/**
 * ==========================================================================
 * board.js
 * - 掲示板(자유게시판) 화면 : board-list / board-view / board-write
 *
 * [수정] 2026-09-07
 *   변경 전 : 작성 폼과 댓글 등록을 preventDefault() 로 막고
 *             alert("2段階で実装予定です。") 만 띄웠다.
 *             즉 게시판 기능이 구조적으로 동작할 수 없었다.
 *   변경 후 : 서버로 실제 전송한다. JS 는 전송 전 확인만 담당한다.
 *
 * 서버 검증이 진짜다
 *   BoardInsertService / BoardUpdateService / CommentService 가
 *   같은 항목을 다시 검사한다. 여기서 막는 것은 사용자 편의일 뿐이다.
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {

    // ==================== 작성 / 수정 폼 ====================
    var writeForm = document.getElementById("boardWriteForm");

    if (writeForm) {
      writeForm.addEventListener("submit", function (e) {

        var title = document.getElementById("boardTitle");
        var content = document.getElementById("boardContent");

        if (title && !title.value.trim()) {
          e.preventDefault();
          alert("タイトルを入力してください。");
          title.focus();
          return;
        }

        if (content && !content.value.trim()) {
          e.preventDefault();
          alert("内容を入力してください。");
          content.focus();
          return;
        }

        var file = document.getElementById("boardFile");
        var MAX_BYTES = 10 * 1024 * 1024;

        if (file && file.files && file.files.length > 0
            && file.files[0].size > MAX_BYTES) {
          e.preventDefault();
          alert("添付ファイルは 10MB 以下にしてください。");
          return;
        }

        // 이중 제출 방지
        var submitBtn = writeForm.querySelector('button[type="submit"]');
        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.textContent = "送信中...";
        }
      });
    }

    // ==================== 댓글 등록 ====================
    var commentInput = document.getElementById("commentInput");

    if (commentInput && commentInput.form) {
      commentInput.form.addEventListener("submit", function (e) {
        if (!commentInput.value.trim()) {
          e.preventDefault();
          alert("コメントを入力してください。");
          commentInput.focus();
        }
      });
    }
  });
})();
