package egovframework.fusion.aop.vo;

public class AccessLogVO {
	private Integer access_log_no;
	private Integer menu_no;
	private Integer member_no;
	private String access_dt;
	private String access_year;
	private String access_month;
	private String access_day;
	private String access_hour;
	
	private String menu_type;
	
	public String getMenu_type() {
		return menu_type;
	}
	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}
	public Integer getAccess_log_no() {
		return access_log_no;
	}
	public void setAccess_log_no(Integer access_log_no) {
		this.access_log_no = access_log_no;
	}
	public Integer getMenu_no() {
		return menu_no;
	}
	public void setMenu_no(Integer menu_no) {
		this.menu_no = menu_no;
	}
	public Integer getMember_no() {
		return member_no;
	}
	public void setMember_no(Integer member_no) {
		this.member_no = member_no;
	}
	public String getAccess_dt() {
		return access_dt;
	}
	public void setAccess_dt(String access_dt) {
		this.access_dt = access_dt;
	}
	public String getAccess_year() {
		return access_year;
	}
	public void setAccess_year(String access_year) {
		this.access_year = access_year;
	}
	public String getAccess_month() {
		return access_month;
	}
	public void setAccess_month(String access_month) {
		this.access_month = access_month;
	}
	public String getAccess_day() {
		return access_day;
	}
	public void setAccess_day(String access_day) {
		this.access_day = access_day;
	}
	public String getAccess_hour() {
		return access_hour;
	}
	public void setAccess_hour(String access_hour) {
		this.access_hour = access_hour;
	}
	@Override
	public String toString() {
		return "AccessLogVO [access_log_no=" + access_log_no + ", menu_no=" + menu_no + ", member_no=" + member_no
				+ ", access_dt=" + access_dt + ", access_year=" + access_year + ", access_month=" + access_month
				+ ", access_day=" + access_day + ", access_hour=" + access_hour + ", menu_type=" + menu_type + "]";
	}
}
