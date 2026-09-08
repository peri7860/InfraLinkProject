/**
 * ==========================================================================
 * schedule.js
 * - スケジュール 화면 : schedule / schedule-view / schedule-write
 *
 * [수정] 2026-09-07
 *   변경 전 : 자리만 잡아둔 빈 파일이었다. (등록 버튼은 type="button" 이라
 *             애초에 아무 동작도 하지 않았다)
 *   변경 후 : 등록 폼의 날짜 입력 편의 기능을 담당한다.
 *
 * 하는 일
 *   1) 시작 날짜를 고르면 종료 날짜를 같은 날로 맞춰준다
 *      (대부분의 일정이 당일 안에서 끝나므로 두 번 입력할 필요가 없다)
 *   2) 종료가 시작보다 빠르면 전송 전에 막는다
 *      (서버와 DB CHECK 제약도 같은 검사를 한다)
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {

    var startDate = document.querySelector('input[name="start_date"]');
    var startTime = document.querySelector('input[name="start_time"]');
    var endDate = document.querySelector('input[name="end_date"]');
    var endTime = document.querySelector('input[name="end_time"]');

    if (!startDate || !endDate) return;

    // ==================== 시작일을 고르면 종료일도 같이 ====================
    startDate.addEventListener("change", function () {
      if (!endDate.value || endDate.value < startDate.value) {
        endDate.value = startDate.value;
      }
    });

    // ==================== 전송 전 순서 검사 ====================
    var form = startDate.form;
    if (!form) return;

    form.addEventListener("submit", function (e) {

      if (!startDate.value) {
        e.preventDefault();
        alert("開始日を入力してください。");
        startDate.focus();
        return;
      }

      // 종료를 비워두면 서버가 시작과 같게 처리하므로 검사하지 않는다
      if (!endDate.value) return;

      var start = startDate.value + " " + (startTime.value || "00:00");
      var end = endDate.value + " " + (endTime.value || "00:00");

      if (end < start) {
        e.preventDefault();
        alert("終了日時は開始日時より後にしてください。");
        endDate.focus();
      }
    });
  });
})();
