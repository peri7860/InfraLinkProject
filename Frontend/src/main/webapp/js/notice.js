/**
 * ==========================================================================
 * notice.js
 * - お知らせ(공지사항) 관련 화면 : notice-list / notice-view / notice-write
 * - 1단계(현재)는 더미 데이터를 HTML에 직접 작성한 상태이며 이 파일은 자리만 잡아둔다.
 * - 2단계에서 구현 예정 :
 *     - fetchNoticeList()   : 목록 ajax 조회 + 페이지네이션
 *     - fetchNoticeDetail() : 상세 ajax 조회
 *     - submitNoticeWrite() : 작성 폼 검증 + 등록 처리
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    // ==================== 작성 폼 필수값 검증 (notice-write.html) ====================
    var writeForm = document.getElementById("noticeWriteForm");
    if (writeForm) {
      writeForm.addEventListener("submit", function (e) {
        e.preventDefault(); // 1단계는 실제 저장 로직이 없으므로 이동만 막는다
        var title = document.getElementById("noticeTitle");
        if (!title.value.trim()) {
          alert("タイトルを入力してください。");
          title.focus();
          return;
        }
        alert("（デモ画面）お知らせが登録されました。\n実際の保存処理は6段階（DB連携）で実装予定です。");
      });
    }
  });
})();
