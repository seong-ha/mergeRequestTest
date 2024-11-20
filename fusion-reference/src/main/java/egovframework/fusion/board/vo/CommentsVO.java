package egovframework.fusion.board.vo;

public class CommentsVO {
	private Integer comments_num;
	private Integer comments_no;
	private Integer board_no;
	private Integer member_no;
	private String content;
	private String regist_dt;
	private String update_dt;
	private String del_yn;
	private Integer parent_no;
	private Integer re_lev;
	private String id;
	private Integer total;
	
	public Integer getComments_num() {
		return comments_num;
	}
	public void setComments_num(Integer comments_num) {
		this.comments_num = comments_num;
	}
	public Integer getComments_no() {
		return comments_no;
	}
	public void setComments_no(Integer comments_no) {
		this.comments_no = comments_no;
	}
	public Integer getBoard_no() {
		return board_no;
	}
	public void setBoard_no(Integer board_no) {
		this.board_no = board_no;
	}
	public Integer getMember_no() {
		return member_no;
	}
	public void setMember_no(Integer member_no) {
		this.member_no = member_no;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getRegist_dt() {
		return regist_dt;
	}
	public void setRegist_dt(String regist_dt) {
		this.regist_dt = regist_dt;
	}
	public String getUpdate_dt() {
		return update_dt;
	}
	public void setUpdate_dt(String update_dt) {
		this.update_dt = update_dt;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public Integer getParent_no() {
		return parent_no;
	}
	public void setParent_no(Integer parent_no) {
		this.parent_no = parent_no;
	}
	public Integer getRe_lev() {
		return re_lev;
	}
	public void setRe_lev(Integer re_lev) {
		this.re_lev = re_lev;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Integer getTotal() {
		return total;
	}
	public void setTotal(Integer total) {
		this.total = total;
	}
	@Override
	public String toString() {
		return "CommentsVO [comments_num=" + comments_num + ", comments_no=" + comments_no + ", board_no=" + board_no
				+ ", member_no=" + member_no + ", content=" + content + ", regist_dt=" + regist_dt + ", update_dt="
				+ update_dt + ", del_yn=" + del_yn + ", parent_no=" + parent_no + ", re_lev=" + re_lev + ", id=" + id
				+ ", total=" + total + "]";
	}
	
}
