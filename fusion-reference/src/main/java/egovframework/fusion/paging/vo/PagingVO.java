package egovframework.fusion.paging.vo;

public class PagingVO {
	private Integer nowPage;		// 현재페이지
	private Integer cntPerPage;		// 한 페이지당 게시물 개수
	private Integer cntPages = 5;	// 페이지리스트 단위
	private Integer total;			// 전체 게시물 개수

	private Integer lastPage;		// 마지막 페이지이자 전체페이지 수
	private Integer startPage;		// cntpages 중 시작페이지
	private Integer endPage;		// cntpages 중 마지막페이지
	
	public PagingVO() {
		
	}
	
	public PagingVO(int total, int cntPerPage) {
		setTotal(total);
		setCntPerPage(cntPerPage);
		calcLastPage(getTotal(), getCntPerPage());
	}
	
	public PagingVO(int total, int nowPage, int cntPerPage) {
		setTotal(total);
		setNowPage(nowPage);
		setCntPerPage(cntPerPage);
		calcLastPage(getTotal(), getCntPerPage());
		calcStartEndPage(getNowPage(), getCntPages());
	}
	
	public void calcLastPage(int total, int cntPerPage) {
		setLastPage(((total - 1) / cntPerPage) + 1);
	}
	
	public void calcStartEndPage(int nowPage, int cntPages) {
		setStartPage( ((nowPage - 1) / cntPages) * cntPages + 1 );
		
		setEndPage( getStartPage() + cntPages - 1 );
		// 끝페이지가 마지막페이지을 넘어설 때
		if (getEndPage() > getLastPage()) {
			setEndPage(getLastPage());
		}

	}
	
	public int getNowPage() {
		return nowPage;
	}

	public void setNowPage(int nowPage) {
		this.nowPage = nowPage;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getCntPerPage() {
		return cntPerPage;
	}

	public void setCntPerPage(int cntPerPage) {
		this.cntPerPage = cntPerPage;
	}

	public int getLastPage() {
		return lastPage;
	}

	public void setLastPage(int lastPage) {
		this.lastPage = lastPage;
	}

	public int getCntPages() {
		return cntPages;
	}

	public void setCntPages(int cntPages) {
		this.cntPages = cntPages;
	}
	
	
}
