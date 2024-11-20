package egovframework.fusion.survey.vo;

public class TempAnswerVO {
	private Integer answer_no;
	private Integer participate_no;
	private Integer member_no;
	private Integer question_no;
	private Integer selection_ordr;
	private String content;
	private String temp_yn;
	private String del_yn;
	private String regist_dt;
	private String update_dt;
	private Integer survey_no;
	private Integer question_num;
	private Integer selection_no;
	
	public Integer getAnswer_no() {
		return answer_no;
	}
	public void setAnswer_no(Integer answer_no) {
		this.answer_no = answer_no;
	}
	public Integer getParticipate_no() {
		return participate_no;
	}
	public void setParticipate_no(Integer participate_no) {
		this.participate_no = participate_no;
	}
	public Integer getMember_no() {
		return member_no;
	}
	public void setMember_no(Integer member_no) {
		this.member_no = member_no;
	}
	public Integer getQuestion_no() {
		return question_no;
	}
	public void setQuestion_no(Integer question_no) {
		this.question_no = question_no;
	}
	public Integer getSelection_ordr() {
		return selection_ordr;
	}
	public void setSelection_ordr(Integer selection_ordr) {
		this.selection_ordr = selection_ordr;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getTemp_yn() {
		return temp_yn;
	}
	public void setTemp_yn(String temp_yn) {
		this.temp_yn = temp_yn;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
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
	public Integer getSurvey_no() {
		return survey_no;
	}
	public void setSurvey_no(Integer survey_no) {
		this.survey_no = survey_no;
	}
	public Integer getQuestion_num() {
		return question_num;
	}
	public void setQuestion_num(Integer question_num) {
		this.question_num = question_num;
	}
	public Integer getSelection_no() {
		return selection_no;
	}
	public void setSelection_no(Integer selection_no) {
		this.selection_no = selection_no;
	}
	@Override
	public String toString() {
		return "TempAnswerVO [answer_no=" + answer_no + ", participate_no=" + participate_no + ", member_no="
				+ member_no + ", question_no=" + question_no + ", selection_ordr=" + selection_ordr + ", content="
				+ content + ", temp_yn=" + temp_yn + ", del_yn=" + del_yn + ", regist_dt=" + regist_dt + ", update_dt="
				+ update_dt + ", survey_no=" + survey_no + ", question_num=" + question_num + ", selection_no="
				+ selection_no + "]";
	}
	
}
