/**
 * ==========================================================================
 * notice.js
 * - お知らせ(공지사항) 화면 : notice-list / notice-view / notice-write
 *
 * [수정] 2026-09-07
 *   변경 전 : submit 을 preventDefault() 로 막고
 *             alert("（デモ画面）... 6段階（DB連携）で実装予定です。")
 *             만 띄웠다. 즉 저장이 구조적으로 불가능했다.
 *   변경 후 : 서버로 실제 전송한다. JS 는 "보내기 전 확인"만 담당한다.
 *
 * ★ 여기서 하는 검증은 편의 기능일 뿐이다.
 *   개발자도구로 얼마든지 우회할 수 있으므로
 *   진짜 검증은 NoticeInsertService / NoticeUpdateService 가 한다.
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {

    var writeForm = document.getElementById("noticeWriteForm");
    if (!writeForm) return;

    // ==================== 작성/수정 폼 검증 ====================
    writeForm.addEventListener("submit", function (e) {

      var title = document.getElementById("noticeTitle");
      var content = document.getElementById("noticeContent");

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

      // 첨부파일 용량을 브라우저에서 미리 확인한다.
      // (서버도 검사하지만, 10MB 를 다 올린 뒤 거부당하면 사용자만 손해다)
      var file = document.getElementById("noticeFile");
      var MAX_BYTES = 10 * 1024 * 1024;

      if (file && file.files && file.files.length > 0) {
        if (file.files[0].size > MAX_BYTES) {
          e.preventDefault();
          alert("添付ファイルは 10MB 以下にしてください。");
          return;
        }
      }

      // 이중 제출 방지 : 전송이 끝날 때까지 버튼을 잠근다.
      var submitBtn = writeForm.querySelector('button[type="submit"]');
      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.textContent = "送信中...";
      }
    });
  });
})();
