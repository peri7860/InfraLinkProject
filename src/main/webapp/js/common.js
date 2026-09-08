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
		bindFeatureInteractions();

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

	function bindFeatureInteractions() {
		document.querySelectorAll('[data-mark-read]').forEach(function(button) {
			button.addEventListener('click', function() {
				var item = button.closest('[data-notification]');
				if (!item) return;
				item.classList.remove('bg-teal-tint');
				item.querySelectorAll('.badge-fixed').forEach(function(badge) { badge.remove(); });
				button.remove(); updateNotificationCount();
			});
		});
		document.querySelectorAll('[data-mark-all-read]').forEach(function(button) {
			button.addEventListener('click', function() {
				document.querySelectorAll('[data-notification]').forEach(function(item) { item.classList.remove('bg-teal-tint'); item.querySelectorAll('.badge-fixed,[data-mark-read]').forEach(function(el) { el.remove(); }); });
				updateNotificationCount(); button.disabled=true; button.textContent='すべて既読です';
			});
		});
		document.querySelectorAll('[data-time-slot]').forEach(function(slot) { slot.addEventListener('click', function() { if (!slot.classList.contains('busy')) { document.querySelectorAll('[data-time-slot]').forEach(function(el){el.classList.remove('selected');});slot.classList.add('selected'); } }); });
		document.querySelectorAll('[data-toggle-target]').forEach(function(button) { button.addEventListener('click', function() { var target=document.querySelector(button.dataset.toggleTarget); if(target) target.classList.toggle('d-none'); }); });
	}

	function updateNotificationCount() {
		var count=document.querySelectorAll('[data-notification].bg-teal-tint').length;
		document.querySelectorAll('[data-notification-count]').forEach(function(el){el.textContent=count;el.style.display=count ? '' : 'none';});
		var label=document.querySelector('[data-unread-label]'); if(label) label.textContent='未読 '+count+'件';
	}

})();
