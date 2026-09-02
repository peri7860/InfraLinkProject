/**
 * ==========================================================================
 * common.js
 * - JSP의 <jsp:include>로 공통 헤더·사이드바·푸터·모달을 렌더링한 뒤,
 *   현재 화면에 맞는 메뉴만 active 상태로 표시한다.
 * ==========================================================================
 */

(function () {
  "use strict";

  /**
   * 현재 페이지에 해당하는 네비게이션 링크에 active 클래스를 부여한다.
   * body 태그의 data-page 속성 값(예: data-page="notice")과
   * 각 링크의 data-nav-match 속성을 비교한다.
   */
  function markActiveNav() {
    var current = document.body.getAttribute("data-page");
    if (!current) return;
    document.querySelectorAll("[data-nav-match]").forEach(function (el) {
      if (el.getAttribute("data-nav-match") === current) {
        el.classList.add("active");
      }
    });
  }

  document.addEventListener("DOMContentLoaded", markActiveNav);

  window.IntranetCommon = { markActiveNav: markActiveNav };
})();
