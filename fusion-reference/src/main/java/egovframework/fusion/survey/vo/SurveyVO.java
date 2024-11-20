package egovframework.fusion.survey.vo;

import java.util.List;

public class SurveyVO {
	private Integer survey_no;
	private Integer member_no;
	private String host_name;
	private String survey_title;
	private String content;
	private String start_dt;
	private String start_dy;
	private String end_dt;
	private String end_dy;
	private Integer total_days;
	private String regist_dt;
	private String update_dt;
	private String del_yn;
	private String win_open_dt;
	private String win_open_dy;
	private String win_open_loc;
	private String subject;
	private List<String> subjectList;
	private Integer submit_cnt;
	private String menu_type;
	
	private String available_yn;
	private Integer req_que_cnt;
	private String id;
	private String menu_form;
	public Integer getSurvey_no() {
		return survey_no;
	}
	public void setSurvey_no(Integer survey_no) {
		this.survey_no = survey_no;
	}
	public Integer getMember_no() {
		return member_no;
	}
	public void setMember_no(Integer member_no) {
		this.member_no = member_no;
	}
	public String getHost_name() {
		return host_name;
	}
	public void setHost_name(String host_name) {
		this.host_name = host_name;
	}
	public String getSurvey_title() {
		return survey_title;
	}
	public void setSurvey_title(String survey_title) {
		this.survey_title = survey_title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getStart_dt() {
		return start_dt;
	}
	public void setStart_dt(String start_dt) {
		this.start_dt = start_dt;
	}
	public String getStart_dy() {
		return start_dy;
	}
	public void setStart_dy(String start_dy) {
		this.start_dy = start_dy;
	}
	public String getEnd_dt() {
		return end_dt;
	}
	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
	public String getEnd_dy() {
		return end_dy;
	}
	public void setEnd_dy(String end_dy) {
		this.end_dy = end_dy;
	}
	public Integer getTotal_days() {
		return total_days;
	}
	public void setTotal_days(Integer total_days) {
		this.total_days = total_days;
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
	public String getWin_open_dt() {
		return win_open_dt;
	}
	public void setWin_open_dt(String win_open_dt) {
		this.win_open_dt = win_open_dt;
	}
	public String getWin_open_dy() {
		return win_open_dy;
	}
	public void setWin_open_dy(String win_open_dy) {
		this.win_open_dy = win_open_dy;
	}
	public String getWin_open_loc() {
		return win_open_loc;
	}
	public void setWin_open_loc(String win_open_loc) {
		this.win_open_loc = win_open_loc;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public List<String> getSubjectList() {
		return subjectList;
	}
	public void setSubjectList(List<String> subjectList) {
		this.subjectList = subjectList;
	}
	public Integer getSubmit_cnt() {
		return submit_cnt;
	}
	public void setSubmit_cnt(Integer submit_cnt) {
		this.submit_cnt = submit_cnt;
	}
	public String getMenu_type() {
		return menu_type;
	}
	public void setMenu_type(String menu_type) {
		this.menu_type = menu_type;
	}
	public String getAvailable_yn() {
		return available_yn;
	}
	public void setAvailable_yn(String available_yn) {
		this.available_yn = available_yn;
	}
	public Integer getReq_que_cnt() {
		return req_que_cnt;
	}
	public void setReq_que_cnt(Integer req_que_cnt) {
		this.req_que_cnt = req_que_cnt;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public String getMenu_form() {
		return menu_form;
	}
	public void setMenu_form(String menu_form) {
		this.menu_form = menu_form;
	}
	@Override
	public String toString() {
		return "SurveyVO [survey_no=" + survey_no + ", member_no=" + member_no + ", host_name=" + host_name
				+ ", survey_title=" + survey_title + ", content=" + content + ", start_dt=" + start_dt + ", start_dy="
				+ start_dy + ", end_dt=" + end_dt + ", end_dy=" + end_dy + ", total_days=" + total_days + ", regist_dt="
				+ regist_dt + ", update_dt=" + update_dt + ", del_yn=" + del_yn + ", win_open_dt=" + win_open_dt
				+ ", win_open_dy=" + win_open_dy + ", win_open_loc=" + win_open_loc + ", subject=" + subject
				+ ", subjectList=" + subjectList + ", submit_cnt=" + submit_cnt + ", menu_type=" + menu_type
				+ ", available_yn=" + available_yn + ", req_que_cnt=" + req_que_cnt + ", id=" + id + ", menu_form="
				+ menu_form + "]";
	}
	
}
