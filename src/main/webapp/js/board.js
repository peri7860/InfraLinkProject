/**
 * ==========================================================================
 * board.js
 * - 掲示板(사내 게시판) 관련 화면 : board-list / board-view / board-write
 * - 2단계에서 구현 예정 :
 *     - fetchBoardList()   : 목록 ajax 조회 + 검색/페이지네이션
 *     - submitBoardWrite() : 작성 폼 검증 + 등록 처리
 *     - submitComment()    : 댓글 등록
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    // ==================== 작성 폼 필수값 검증 (board-write.html) ====================
    var writeForm = document.getElementById("boardWriteForm");
    if (writeForm) {
      writeForm.addEventListener("submit", function (e) {
        e.preventDefault();
        var title = document.getElementById("boardTitle");
        var content = document.getElementById("boardContent");
        if (!title.value.trim() || !content.value.trim()) {
          alert("タイトルと内容をすべて入力してください。");
          return;
        }
        alert("（デモ画面）投稿が登録されました。\n実際の保存処理は6段階（DB連携）で実装予定です。");
      });
    }

    // ==================== 댓글 등록 버튼 (board-view.html, 더미 동작) ====================
    var commentBtn = document.getElementById("commentSubmitBtn");
    if (commentBtn) {
      commentBtn.addEventListener("click", function () {
        var input = document.getElementById("commentInput");
        if (!input.value.trim()) {
          alert("コメントを入力してください。");
          return;
        }
        alert("（デモ画面）コメント機能は2段階で実装予定です。");
        input.value = "";
      });
    }
  });
})();
