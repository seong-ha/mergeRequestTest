package egovframework.fusion.menu.vo;

public class MenuNAuthorVO {
	private Integer menu_no;
	private Integer author_no;
	private String menu_type;
	public Integer getMenu_no() {
		return menu_no;
	}
	public void setMenu_no(Integer menu_no) {
		this.menu_no = menu_no;
	}
	public Integer getAuthor_no() {
		return author_no;
	}
	public void setAuthor_no(Integer author_no) {
		this.author_no = author_no;
	}
	
	public String getMenu_type() {
		return menu_type;
	}
	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}
	@Override
	public String toString() {
		return "MenuNAuthorVO [menu_no=" + menu_no + ", author_no=" + author_no + ", menu_type=" + menu_type + "]";
	}
}
