/**
 * ==========================================================================
 * employee.js
 * - 社員検索(사원 조회) 관련 화면 : employee-list / employee-detail
 * - 2단계에서 구현 예정 :
 *     - fetchEmployeeList()   : 이름/부서 검색 ajax 조회
 *     - fetchEmployeeDetail() : 상세 프로필 ajax 조회
 * ==========================================================================
 */

(function () {
  "use strict";

  document.addEventListener("DOMContentLoaded", function () {
    var searchForm = document.getElementById("employeeSearchForm");
    if (searchForm) {
      searchForm.addEventListener("submit", function (e) {
        e.preventDefault();
        alert("（デモ画面）検索機能は2段階で実装予定です。");
      });
    }
  });
})();
