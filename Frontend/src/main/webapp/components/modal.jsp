<!-- =====================================================================
     components/modal.html
     - 헤더의 [クイックメニュー] 버튼으로 여는 공통 빠른메뉴 모달
     - common.js 의 loadComponent() 가 #modal-placeholder 에 삽입한다
     ===================================================================== -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal fade" id="quickMenuModal" tabindex="-1" aria-labelledby="quickMenuModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="quickMenuModalLabel"><i class="bi bi-grid-3x3-gap-fill text-teal"></i> クイックメニュー</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>
      <div class="modal-body">
        <div class="row row-cols-3 row-cols-md-4 g-3">
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/approval.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-file-earmark-check"></i></div>
              <span>電子決裁</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/attendance.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-clock-history"></i></div>
              <span>勤怠管理</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/room.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-door-open"></i></div>
              <span>会議室予約</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/schedule.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-calendar3"></i></div>
              <span>スケジュール</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/employee.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-diagram-3"></i></div>
              <span>組織図</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/board.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-clipboard2-data"></i></div>
              <span>掲示板</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/messenger.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-chat-dots"></i></div>
              <span>メッセンジャー</span>
            </a>
          </div>
          <div class="col">
            <a href="${pageContext.request.contextPath}/pages/mypage.do" class="quick-btn">
              <div class="icon-wrap"><i class="bi bi-person-gear"></i></div>
              <span>マイページ</span>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- =====================================================================
     공통 삭제 확인 모달
     - 게시판/공지 상세 페이지의 [削除] 버튼에서 호출 (더미 동작, 2단계에서 실제 처리 연결)
     ===================================================================== -->
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="confirmDeleteModalLabel"><i class="bi bi-exclamation-triangle text-danger"></i> 削除確認</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
      </div>
      <div class="modal-body">
        <p class="mb-0">この投稿を削除しますか？<br>削除した内容は元に戻せません。</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">キャンセル</button>
        <button type="button" class="btn btn-sm btn-teal" style="background:var(--warn); border-color:var(--warn);">削除する</button>
      </div>
    </div>
  </div>
</div>
