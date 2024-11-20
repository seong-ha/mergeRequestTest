package egovframework.fusion.survey.vo;

public class QuestionCategoryVO {
	private Integer question_category_no;
	private String question_category_name;
	private String regist_dt;
	private String update_dt;
	private String del_yn;

	public Integer getQuestion_category_no() {
		return question_category_no;
	}
	public void setQuestion_category_no(Integer question_category_no) {
		this.question_category_no = question_category_no;
	}
	public String getQuestion_category_name() {
		return question_category_name;
	}
	public void setQuestion_category_name(String question_category_name) {
		this.question_category_name = question_category_name;
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
	@Override
	public String toString() {
		return "QuestionCategoryVO [question_category_no=" + question_category_no + ", question_category_name="
				+ question_category_name + ", regist_dt=" + regist_dt + ", update_dt=" + update_dt + ", del_yn="
				+ del_yn + "]";
	}
}
