/**
 * ==========================================================================
 * common.js
 * - 모든 페이지에서 공통으로 사용하는 JavaScript
 * - 공통 메뉴 active 처리
 * - Bootstrap 공통 기능 초기화
 * ==========================================================================
 */

(function() {

	"use strict";

	document.addEventListener("DOMContentLoaded", function() {

		// ==================== Bootstrap 툴팁 초기화 ====================

		var tooltipTriggerList =
			document.querySelectorAll('[data-bs-toggle="tooltip"]');

		tooltipTriggerList.forEach(function(el) {
			new bootstrap.Tooltip(el);
		});


		// ==================== 현재 메뉴 Active 처리 ====================

		markActiveNav();

	});


	/**
	 * 현재 페이지에 해당하는 메뉴에 active 클래스 추가
	 *
	 * body의 data-page와
	 * 메뉴의 data-nav-match를 비교한다.
	 */
	function markActiveNav() {

		var current =
			document.body.getAttribute("data-page");

		if (!current) return;


		document.querySelectorAll("[data-nav-match]")
			.forEach(function(el) {

				if (el.getAttribute("data-nav-match") === current) {

					el.classList.add("active");

				}

			});

	}

})();