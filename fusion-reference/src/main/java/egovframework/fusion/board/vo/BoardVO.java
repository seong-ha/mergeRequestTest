/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.vo;

import java.io.Serializable;

public class BoardVO implements Serializable{

	private static final long serialVersionUID = -8402510944659037798L;

	/* 게시판 */
	private Integer board_num;
	private Integer board_no;
	private String title;
	private Integer member_no;
	private String id;
	private Integer board_cnt;
	private String type;
	private String regist_dt;
	private String update_dt;
	private String del_yn;
	private Integer parent_no;
	private Integer re_lev;
	private Integer total;
	private String content;
	private String menu_type;
	private Integer like_cnt;
	private String thumnail;
	private Integer is_liked;
	
	private String returnUrl;
	private String returnUrl2;
	private String menu_form;
	
	public BoardVO() {
		
	}

	public Integer getBoard_num() {
		return board_num;
	}

	public void setBoard_num(Integer board_num) {
		this.board_num = board_num;
	}

	public Integer getBoard_no() {
		return board_no;
	}

	public void setBoard_no(Integer board_no) {
		this.board_no = board_no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public Integer getBoard_cnt() {
		return board_cnt;
	}

	public void setBoard_cnt(Integer board_cnt) {
		this.board_cnt = board_cnt;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
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

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getMenu_type() {
		return menu_type;
	}

	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}

	public Integer getLike_cnt() {
		return like_cnt;
	}

	public void setLike_cnt(Integer like_cnt) {
		this.like_cnt = like_cnt;
	}

	public String getThumnail() {
		return thumnail;
	}

	public void setThumnail(String thumnail) {
		this.thumnail = thumnail;
	}

	public String getReturnUrl() {
		return returnUrl;
	}

	public void setReturnUrl(String returnUrl) {
		this.returnUrl = returnUrl;
	}

	public String getReturnUrl2() {
		return returnUrl2;
	}

	public void setReturnUrl2(String returnUrl2) {
		this.returnUrl2 = returnUrl2;
	}
	
	public String getMenu_form() {
		return menu_form;
	}

	public void setMenu_form(String menu_form) {
		this.menu_form = menu_form;
	}

	public Integer getIs_liked() {
		return is_liked;
	}

	public void setIs_liked(Integer is_liked) {
		this.is_liked = is_liked;
	}

	@Override
	public String toString() {
		return "BoardVO [board_num=" + board_num + ", board_no=" + board_no + ", title=" + title + ", member_no="
				+ member_no + ", id=" + id + ", board_cnt=" + board_cnt + ", type=" + type + ", regist_dt=" + regist_dt
				+ ", update_dt=" + update_dt + ", del_yn=" + del_yn + ", parent_no=" + parent_no + ", re_lev=" + re_lev
				+ ", total=" + total + ", content=" + content + ", menu_type=" + menu_type + ", like_cnt=" + like_cnt
				+ ", thumnail=" + thumnail + ", is_liked=" + is_liked + ", returnUrl=" + returnUrl + ", returnUrl2="
				+ returnUrl2 + ", menu_form=" + menu_form + "]";
	}
	
}
