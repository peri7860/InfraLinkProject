<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  =====================================================================
  공통 페이지네이션

  [신규 생성] 2026-09-07
    기존에는 목록 화면마다 페이지 번호(1 2 3 4 5)가 HTML 에 하드코딩되어
    있었다. 글이 몇 건이든 항상 같은 번호가 나왔고, 눌러도 href="#" 이라
    아무 일도 일어나지 않았다.

  사용법 (호출하는 화면에서)
    1) 서비스가 request 에 util.Paging 객체를 "paging" 으로 담아둔다.
    2) 화면에서 이동할 기준 주소와 추가 파라미터를 지정한 뒤 include 한다.

       <c:set var="pagingUrl"   value="${cp}/pages/notice.do"/>
       <c:set var="pagingQuery" value="&keyword=${keyword}"/>
       <%@ include file="/WEB-INF/components/paging.jsp"%>

    pagingQuery 는 없으면 생략해도 된다.
  =====================================================================
--%>
<c:if test="${not empty paging and paging.totalPage > 1}">
  <div class="pagination-wrap">
    <ul class="pagination">

      <%-- 이전 페이지 블록 («) --%>
      <c:choose>
        <c:when test="${paging.hasPrevBlock}">
          <li class="page-item">
            <a class="page-link"
               href="${pagingUrl}?page=${paging.startPage - 1}${pagingQuery}"
               aria-label="前のページ群">&laquo;</a>
          </li>
        </c:when>
        <c:otherwise>
          <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
        </c:otherwise>
      </c:choose>

      <%-- 이전 페이지 --%>
      <c:choose>
        <c:when test="${paging.currentPage > 1}">
          <li class="page-item">
            <a class="page-link"
               href="${pagingUrl}?page=${paging.prevPage}${pagingQuery}">前へ</a>
          </li>
        </c:when>
        <c:otherwise>
          <li class="page-item disabled"><span class="page-link">前へ</span></li>
        </c:otherwise>
      </c:choose>

      <%-- 페이지 번호 --%>
      <c:forEach var="p" begin="${paging.startPage}" end="${paging.endPage}">
        <c:choose>
          <c:when test="${p eq paging.currentPage}">
            <li class="page-item active" aria-current="page">
              <span class="page-link">${p}</span>
            </li>
          </c:when>
          <c:otherwise>
            <li class="page-item">
              <a class="page-link" href="${pagingUrl}?page=${p}${pagingQuery}">${p}</a>
            </li>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <%-- 다음 페이지 --%>
      <c:choose>
        <c:when test="${paging.currentPage < paging.totalPage}">
          <li class="page-item">
            <a class="page-link"
               href="${pagingUrl}?page=${paging.nextPage}${pagingQuery}">次へ</a>
          </li>
        </c:when>
        <c:otherwise>
          <li class="page-item disabled"><span class="page-link">次へ</span></li>
        </c:otherwise>
      </c:choose>

      <%-- 다음 페이지 블록 (») --%>
      <c:choose>
        <c:when test="${paging.hasNextBlock}">
          <li class="page-item">
            <a class="page-link"
               href="${pagingUrl}?page=${paging.endPage + 1}${pagingQuery}"
               aria-label="次のページ群">&raquo;</a>
          </li>
        </c:when>
        <c:otherwise>
          <li class="page-item disabled"><span class="page-link">&raquo;</span></li>
        </c:otherwise>
      </c:choose>

    </ul>
  </div>
</c:if>
