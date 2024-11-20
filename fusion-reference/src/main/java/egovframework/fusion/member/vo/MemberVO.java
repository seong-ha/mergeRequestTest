package egovframework.fusion.member.vo;

public class MemberVO {

	private Integer member_no;
	private String id;
	private String pwd;
	private String pwd_confirm;
	private String name;
	private String regist_dt;
	private String update_dt;
	private Integer author_no;
	private String del_yn;
	private Integer region;
	
	
	public MemberVO() {
		
	}
	
	public Integer getMember_no() {
		return member_no;
	}
	public void setMember_no(Integer member_no) {
		this.member_no = member_no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public String getPwd_confirm() {
		return pwd_confirm;
	}
	public void setPwd_confirm(String pwd_confirm) {
		this.pwd_confirm = pwd_confirm;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	
	public Integer getAuthor_no() {
		return author_no;
	}

	public void setAuthor_no(Integer author_no) {
		this.author_no = author_no;
	}

	public Integer getRegion() {
		return region;
	}

	public void setRegion(Integer region) {
		this.region = region;
	}

	@Override
	public String toString() {
		return "MemberVO [member_no=" + member_no + ", id=" + id + ", pwd=" + pwd + ", pwd_confirm=" + pwd_confirm
				+ ", name=" + name + ", regist_dt=" + regist_dt + ", update_dt=" + update_dt + ", author_no="
				+ author_no + ", del_yn=" + del_yn + ", region=" + region + "]";
	}

}
