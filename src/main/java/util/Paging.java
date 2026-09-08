package util;

/**
 * 목록 화면 페이지네이션 계산기.
 *
 * <pre>
 * [신규 생성] 2026-09-07
 *
 * 기존에는 목록 화면(공지/게시판/사원)의 페이지 번호가 전부 HTML 에
 * 하드코딩되어 있었고(1 2 3 4 5 고정), 서버에는 페이징 계산이 없었다.
 * NoticeDAO.getSearchAndPaging() 만 있었고 그마저 호출하는 곳이 없었다.
 *
 * 이 클래스가 하는 일
 *  - 전체 건수 / 현재 페이지 / 페이지당 건수를 받아
 *    시작·끝 행 번호, 총 페이지 수, 화면에 보여줄 페이지 번호 구간을 계산한다.
 *  - JSP 에서는 ${paging.startPage} 처럼 EL 로 바로 꺼내 쓴다.
 *
 * 오라클 rownum 페이징에서 쓰는 값
 *  - startRow / endRow : "WHERE rn BETWEEN startRow AND endRow"
 * </pre>
 */
public class Paging {

	/** 한 페이지에 보여줄 글 수 (기본값) */
	public static final int DEFAULT_PAGE_SIZE = 10;

	/** 화면 하단에 한 번에 보여줄 페이지 번호 개수 (예: 1 2 3 4 5 6 7 8 9 10) */
	public static final int DEFAULT_BLOCK_SIZE = 10;

	private final int currentPage; // 현재 페이지 (1부터)
	private final int pageSize; // 페이지당 건수
	private final int totalCount; // 전체 건수
	private final int totalPage; // 전체 페이지 수
	private final int startPage; // 화면에 표시할 첫 페이지 번호
	private final int endPage; // 화면에 표시할 마지막 페이지 번호
	private final int startRow; // 오라클 rownum 시작
	private final int endRow; // 오라클 rownum 끝

	public Paging(int currentPage, int totalCount) {
		this(currentPage, totalCount, DEFAULT_PAGE_SIZE, DEFAULT_BLOCK_SIZE);
	}

	public Paging(int currentPage, int totalCount, int pageSize, int blockSize) {

		// ---------------------------------------------------------
		// 방어 : 잘못된 값이 들어와도 계산이 깨지지 않게 보정한다.
		//        (?page=-5 / ?page=abc 같은 요청 대비)
		// ---------------------------------------------------------
		this.pageSize = pageSize < 1 ? DEFAULT_PAGE_SIZE : pageSize;
		this.totalCount = Math.max(totalCount, 0);

		int block = blockSize < 1 ? DEFAULT_BLOCK_SIZE : blockSize;

		// 전체 페이지 수 (올림). 글이 0건이어도 최소 1페이지는 존재한다.
		this.totalPage = Math.max((int) Math.ceil((double) this.totalCount / this.pageSize), 1);

		// 현재 페이지 보정 (1 ~ totalPage)
		int page = currentPage < 1 ? 1 : currentPage;
		this.currentPage = Math.min(page, this.totalPage);

		// 페이지 번호 구간
		this.startPage = ((this.currentPage - 1) / block) * block + 1;
		this.endPage = Math.min(this.startPage + block - 1, this.totalPage);

		// 오라클 rownum 범위
		this.startRow = (this.currentPage - 1) * this.pageSize + 1;
		this.endRow = this.currentPage * this.pageSize;
	}

	/**
	 * 요청 파라미터 문자열을 안전하게 페이지 번호로 변환한다.
	 * null / 숫자 아님 / 음수 → 1
	 */
	public static int parsePage(String pageParam) {

		if (pageParam == null || pageParam.trim().isEmpty()) {
			return 1;
		}
		try {
			int page = Integer.parseInt(pageParam.trim());
			return page < 1 ? 1 : page;
		} catch (NumberFormatException e) {
			return 1;
		}
	}

	// =================================================================
	// getter (JSP 의 EL 이 읽는다)
	// =================================================================

	public int getCurrentPage() {
		return currentPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public int getStartRow() {
		return startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	/** 이전 페이지 블록이 있는가 (« 버튼 표시 여부) */
	public boolean isHasPrevBlock() {
		return startPage > 1;
	}

	/** 다음 페이지 블록이 있는가 (» 버튼 표시 여부) */
	public boolean isHasNextBlock() {
		return endPage < totalPage;
	}

	/** 이전 페이지 번호 (없으면 1) */
	public int getPrevPage() {
		return Math.max(currentPage - 1, 1);
	}

	/** 다음 페이지 번호 (없으면 마지막 페이지) */
	public int getNextPage() {
		return Math.min(currentPage + 1, totalPage);
	}

	@Override
	public String toString() {
		return "Paging[page=" + currentPage + "/" + totalPage
				+ ", rows=" + startRow + "~" + endRow
				+ ", total=" + totalCount + "]";
	}
}
