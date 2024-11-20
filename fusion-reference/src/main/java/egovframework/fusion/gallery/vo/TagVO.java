package egovframework.fusion.gallery.vo;

public class TagVO {
	private Integer tag_no;
	private String tag_name;
	private Integer board_no;
	private String regist_dt;
	private String del_yn;
	
	public Integer getTag_no() {
		return tag_no;
	}
	public void setTag_no(Integer tag_no) {
		this.tag_no = tag_no;
	}
	public String getTag_name() {
		return tag_name;
	}
	public void setTag_name(String tag_name) {
		this.tag_name = tag_name;
	}
	public Integer getBoard_no() {
		return board_no;
	}
	public void setBoard_no(Integer board_no) {
		this.board_no = board_no;
	}
	public String getRegist_dt() {
		return regist_dt;
	}
	public void setRegist_dt(String regist_dt) {
		this.regist_dt = regist_dt;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	@Override
	public String toString() {
		return "TagVO [tag_no=" + tag_no + ", tag_name=" + tag_name + ", board_no=" + board_no + ", regist_dt="
				+ regist_dt + ", del_yn=" + del_yn + "]";
	}
	
	
}
