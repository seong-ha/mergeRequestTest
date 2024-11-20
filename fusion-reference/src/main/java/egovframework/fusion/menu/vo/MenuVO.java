package egovframework.fusion.menu.vo;

import java.util.List;

public class MenuVO {
	private Integer menu_no;
	private String menu_name;
	private String menu_form;
	private String menu_url;
	private String menu_type;
	
	private List<Integer> authorList;

	public Integer getMenu_no() {
		return menu_no;
	}

	public void setMenu_no(Integer menu_no) {
		this.menu_no = menu_no;
	}

	public String getMenu_name() {
		return menu_name;
	}

	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}

	public String getMenu_form() {
		return menu_form;
	}

	public void setMenu_form(String menu_form) {
		this.menu_form = menu_form;
	}

	public String getMenu_url() {
		return menu_url;
	}

	public void setMenu_url(String menu_url) {
		this.menu_url = menu_url;
	}

	public String getMenu_type() {
		return menu_type;
	}

	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}

	public List<Integer> getAuthorList() {
		return authorList;
	}

	public void setAuthorList(List<Integer> authorList) {
		this.authorList = authorList;
	}

	@Override
	public String toString() {
		return "MenuVO [menu_no=" + menu_no + ", menu_name=" + menu_name + ", menu_form=" + menu_form + ", menu_url="
				+ menu_url + ", menu_type=" + menu_type + ", authorList=" + authorList + "]";
	}
	
}
