<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  =====================================================================
  공통 푸터 (fragment)
  각 화면에서 <%@ include %> 로 정적 포함한다.
  (예전에는 common.js 가 #footer-placeholder 에 JS 로 삽입했다)

  [주의] 이 주석은 반드시 JSP 주석이어야 한다.
         HTML 주석 안에 두면 응답에 그대로 나가고,
         그 안의 JSP 지시자는 실제로 실행된다.
  =====================================================================
--%>
<footer class="site-footer">
	<div class="container">
		<div class="row">
			<div class="col-md-4 mb-3 mb-md-0">
				<div class="footer-logo">Infra<span>Link</span></div>
				<p class="footer-info">
					役員・社員のための社内統合業務ポータル、<br>
					InfraLink イントラネットです。
				</p>
			</div>
			<div class="col-md-4 mb-3 mb-md-0">
				<h6 class="text-white mb-2">お問い合わせ / IT サポート</h6>
				<p class="footer-info">
					<strong>会社名</strong> 株式会社インフラリンク &nbsp;|&nbsp; 代表取締役 山田 一郎<br>
					<strong>電話</strong> 03-0000-1234（内線 100）<br>
					<strong>メール</strong> itsupport@infralink.co.jp
				</p>
			</div>
			<div class="col-md-4">
				<h6 class="text-white mb-2">所在地</h6>
				<p class="footer-info">
					東京都港区芝浦 3-1-21<br>
					インフラリンク本社ビル 5階
				</p>
			</div>
		</div>
		<hr>
		<div class="copyright">&copy; 2026 InfraLink Inc. All rights reserved.（本サイトは社内従業員専用です）</div>
	</div>
</footer>