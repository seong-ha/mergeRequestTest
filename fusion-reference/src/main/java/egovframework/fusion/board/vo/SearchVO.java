package egovframework.fusion.board.vo;

public class SearchVO {
	private Integer nowPage;
	private Integer cntPerPage;
	private String srchType;
	private String srchText;
	private String menuType;
	private String menuForm;
	private boolean noPageChoose;
	private Integer totalChange;
	private Integer memberNo;
	
	
	public Integer getNowPage() {
		return nowPage;
	}
	public void setNowPage(Integer nowPage) {
		this.nowPage = nowPage;
	}
	public Integer getCntPerPage() {
		return cntPerPage;
	}
	public void setCntPerPage(Integer cntPerPage) {
		this.cntPerPage = cntPerPage;
	}
	public String getSrchType() {
		return srchType;
	}
	public void setSrchType(String srchType) {
		this.srchType = srchType;
	}
	public String getSrchText() {
		return srchText;
	}
	public void setSrchText(String srchText) {
		this.srchText = srchText;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public boolean getNoPageChoose() {
		return noPageChoose;
	}
	public void setNoPageChoose(boolean noPageChoose) {
		this.noPageChoose = noPageChoose;
	}
	public String getMenuForm() {
		return menuForm;
	}
	public void setMenuForm(String menuForm) {
		this.menuForm = menuForm;
	}
	public Integer getTotalChange() {
		return totalChange;
	}
	public void setTotalChange(Integer totalChange) {
		this.totalChange = totalChange;
	}
	public Integer getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(Integer memberNo) {
		this.memberNo = memberNo;
	}
	@Override
	public String toString() {
		return "SearchVO [nowPage=" + nowPage + ", cntPerPage=" + cntPerPage + ", srchType=" + srchType + ", srchText="
				+ srchText + ", menuType=" + menuType + ", menuForm=" + menuForm + ", noPageChoose=" + noPageChoose
				+ ", totalChange=" + totalChange + ", memberNo=" + memberNo + "]";
	}
	
}
