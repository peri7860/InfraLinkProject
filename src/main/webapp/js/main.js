/**
 * ==========================================================================
 * main.js
 * - index.html(메인 대시보드) 전용 스크립트
 * - 1단계(현재)에는 화면 표시만 담당하며 실제 데이터 연동 로직은 없다.
 * - 2단계에서 구현 예정 :
 *     - 공지사항 목록 ajax 갱신
 *     - 전자결재 현황 실시간 카운트
 *     - 이번 주 일정 위젯 동적 렌더링
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    // ==================== Bootstrap 툴팁 초기화 ====================
    var tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltipTriggerList.forEach(function (el) {
      new bootstrap.Tooltip(el);
    });

    // TODO(2단계) : notice.js 의 fetchNoticeList() 를 호출하여
    //               메인 화면 공지사항 위젯을 동적으로 채운다.
  });
})();
