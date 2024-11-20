package egovframework.fusion.survey.vo;

public class SelectionVO {
	private Integer selection_no;
	private Integer selection_ordr;
	private String selection_name;
	
	public Integer getSelection_no() {
		return selection_no;
	}
	public void setSelection_no(Integer selection_no) {
		this.selection_no = selection_no;
	}
	public Integer getSelection_ordr() {
		return selection_ordr;
	}
	public void setSelection_ordr(Integer selection_ordr) {
		this.selection_ordr = selection_ordr;
	}
	public String getSelection_name() {
		return selection_name;
	}
	public void setSelection_name(String selection_name) {
		this.selection_name = selection_name;
	}
	
	@Override
	public String toString() {
		return "SelectionVO [selection_no=" + selection_no + ", selection_ordr=" + selection_ordr + ", selection_name="
				+ selection_name + "]";
	}
	
}
