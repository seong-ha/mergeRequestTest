package egovframework.fusion.menu.vo;

public class YearVO {
	private String menu_name;
	private Integer first_year;
	private Integer second_year;
	private Integer third_year;
	public String getMenu_name() {
		return menu_name;
	}
	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}
	public Integer getFirst_year() {
		return first_year;
	}
	public void setFirst_year(Integer first_year) {
		this.first_year = first_year;
	}
	public Integer getSecond_year() {
		return second_year;
	}
	public void setSecond_year(Integer second_year) {
		this.second_year = second_year;
	}
	public Integer getThird_year() {
		return third_year;
	}
	public void setThird_year(Integer third_year) {
		this.third_year = third_year;
	}
	@Override
	public String toString() {
		return "YearVO [menu_name=" + menu_name + ", first_year=" + first_year + ", second_year=" + second_year
				+ ", third_year=" + third_year + "]";
	}
}
