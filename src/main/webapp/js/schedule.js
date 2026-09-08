/**
 * ==========================================================================
 * schedule.js
 * - スケジュール(일정) 화면 전용 스크립트
 * - 2단계에서 구현 예정 :
 *     - 월간 캘린더 렌더링 (이전달/다음달 이동)
 *     - 일정 등록 모달 처리
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    var prevBtn = document.getElementById("calPrevBtn");
    var nextBtn = document.getElementById("calNextBtn");
    if (prevBtn && nextBtn) {
      prevBtn.addEventListener("click", function () {
        alert("（デモ画面）月移動機能は2段階で実装予定です。");
      });
      nextBtn.addEventListener("click", function () {
        alert("（デモ画面）月移動機能は2段階で実装予定です。");
      });
    }
  });
})();
