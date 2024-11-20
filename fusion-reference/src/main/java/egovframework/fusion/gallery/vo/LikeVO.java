package egovframework.fusion.gallery.vo;

public class LikeVO {
	private Integer like_no;
	private Integer board_no;
	private Integer member_no;
	private String regist_dt;
	private Integer update_amount;
	private Integer is_liked;
	
	public Integer getLike_no() {
		return like_no;
	}
	public void setLike_no(Integer like_no) {
		this.like_no = like_no;
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
	public String getRegist_dt() {
		return regist_dt;
	}
	public void setRegist_dt(String regist_dt) {
		this.regist_dt = regist_dt;
	}
	public Integer getUpdate_amount() {
		return update_amount;
	}
	public void setUpdate_amount(Integer update_amount) {
		this.update_amount = update_amount;
	}
	public Integer getIs_liked() {
		return is_liked;
	}
	public void setIs_liked(Integer is_liked) {
		this.is_liked = is_liked;
	}
	@Override
	public String toString() {
		return "LikeVO [like_no=" + like_no + ", board_no=" + board_no + ", member_no=" + member_no + ", regist_dt="
				+ regist_dt + ", update_amount=" + update_amount + ", is_liked=" + is_liked + "]";
	}
	
}
