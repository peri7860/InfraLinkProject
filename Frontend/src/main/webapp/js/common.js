/**
 * ==========================================================================
 * common.js
 * - 모든 페이지에서 공통으로 사용하는 스크립트
 * - 1단계(현재)에서 하는 일 : Header / Footer / Sidebar / Modal 조각(HTML)을
 *   fetch()로 불러와 각 placeholder에 삽입한다.
 * - 이렇게 분리해두면 3~4단계에서 JSP로 전환할 때
 *   이 fetch 로직을 <jsp:include> 로 그대로 교체하기만 하면 된다.
 *
 * 주의 : fetch()는 file:// 프로토콜에서 CORS 정책으로 막히는 브라우저가 많다.
 *        반드시 Live Server 등 간이 웹서버를 통해 열어서 확인할 것.
 * ==========================================================================
 */

(function () {
  "use strict";

  /**
   * 현재 문서 위치를 기준으로 컴포넌트 안의 {{BASE}} 토큰을 치환할 상대경로를 계산한다.
   * - index.html(루트) 에서 열었을 때        -> ''
   * - pages/xxx.html(하위 폴더) 에서 열었을 때 -> '../'
   */
  function getBasePath() {
    return window.location.pathname.includes("/pages/") ? "../" : "";
  }

  /**
   * fragment(html조각)를 fetch로 읽어와 지정한 placeholder에 삽입한다.
   * @param {string} url        - 불러올 fragment 경로 (components/xxx.html)
   * @param {string} targetId   - 삽입될 placeholder element id
   * @param {Function} [callback] - 삽입 완료 후 실행할 콜백
   */
  function loadComponent(url, targetId, callback) {
    var target = document.getElementById(targetId);
    if (!target) return;

    fetch(url)
      .then(function (res) {
        if (!res.ok) throw new Error("Failed to load component: " + url);
        return res.text();
      })
      .then(function (html) {
        var base = getBasePath();
        target.innerHTML = html.replace(/{{BASE}}/g, base);
        if (typeof callback === "function") callback(target);
      })
      .catch(function (err) {
        console.error(err);
        target.innerHTML =
          '<div class="text-center text-muted small py-2">' +
          "コンポーネントの読み込みに失敗しました (" +
          url +
          ")</div>";
      });
  }

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

  /**
   * 페이지 진입 시 공통 컴포넌트를 순서대로 로드한다.
   * header -> sidebar -> footer -> modal 순서로 불러온 뒤 active 메뉴를 표시한다.
   */
  function initLayout() {
    var base = getBasePath();
    var tasks = [];

    if (document.getElementById("header-placeholder")) {
      tasks.push(
        new Promise(function (resolve) {
          loadComponent(base + "components/header.html", "header-placeholder", resolve);
        })
      );
    }
    if (document.getElementById("sidebar-placeholder")) {
      tasks.push(
        new Promise(function (resolve) {
          loadComponent(base + "components/sidebar.html", "sidebar-placeholder", resolve);
        })
      );
    }
    if (document.getElementById("footer-placeholder")) {
      tasks.push(
        new Promise(function (resolve) {
          loadComponent(base + "components/footer.html", "footer-placeholder", resolve);
        })
      );
    }
    if (document.getElementById("modal-placeholder")) {
      tasks.push(
        new Promise(function (resolve) {
          loadComponent(base + "components/modal.html", "modal-placeholder", resolve);
        })
      );
    }

    Promise.all(tasks).then(markActiveNav);
  }

  document.addEventListener("DOMContentLoaded", initLayout);

  // 다른 JS 파일(main.js, notice.js 등)에서도 재사용할 수 있도록 전역에 노출
  window.IntranetCommon = {
    getBasePath: getBasePath,
    loadComponent: loadComponent,
  };
})();
