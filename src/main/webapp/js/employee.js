/**
 * ==========================================================================
 * employee.js
 * - 社員検索 화면 : employee-list / employee-detail
 *
 * [수정] 2026-09-07
 *   변경 전 : 검색 폼 submit 을 preventDefault() 로 막고
 *             alert("（デモ画面）検索機能は2段階で実装予定です。") 만 띄웠다.
 *             즉 검색이 절대 동작하지 않았다.
 *   변경 후 : 폼을 서버(GET /pages/employee.do)로 그대로 보낸다.
 *             GET 을 쓰는 이유는 검색 결과 주소를 그대로 공유할 수 있고,
 *             페이지를 넘겨도 조건이 유지되기 때문이다.
 *
 * 이제 이 파일이 하는 일은 "빈 검색 방지" 정도의 편의 기능뿐이다.
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {

    var searchForm = document.getElementById("employeeSearchForm");
    if (!searchForm) return;

    searchForm.addEventListener("submit", function () {

      // 빈 파라미터가 주소에 붙는 것을 막는다.
      // (?keyword=&dept_code= 같은 지저분한 URL 방지)
      Array.prototype.forEach.call(
        searchForm.querySelectorAll("input[name], select[name]"),
        function (el) {
          if (!el.value) {
            el.disabled = true; // disabled 요소는 전송되지 않는다
          }
        }
      );
    });
  });
})();
