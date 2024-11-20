package egovframework.fusion.search.vo;

public class IntegratedSearchVO {
	private String integSrchType;
	private String integSrchText;
	private Integer nowPage;
	private Integer cntPerPage;
	
	public String getIntegSrchType() {
		return integSrchType;
	}
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
	public void setIntegSrchType(String integSrchType) {
		this.integSrchType = integSrchType;
	}
	public String getIntegSrchText() {
		return integSrchText;
	}
	public void setIntegSrchText(String integSrchText) {
		this.integSrchText = integSrchText;
	}
	@Override
	public String toString() {
		return "IntegratedSearchVO [integSrchType=" + integSrchType + ", integSrchText=" + integSrchText + ", nowPage="
				+ nowPage + ", cntPerPage=" + cntPerPage + "]";
	}
}
