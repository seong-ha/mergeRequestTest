package egovframework.fusion.survey.vo;

import java.util.List;

public class QuestionVO {
	private Integer question_no;
	private Integer survey_no;
	private String question_num;
	private String content;
	private String necessity_yn;
	private String del_yn;
	private Integer parent_no;
	private Integer question_category_no;
	private String question_category_name;
	private Integer answer_cnt;
	private Integer selection_no;
	
	private List<SelectionVO> selectionList;
	private List<QuestionVO> questionList;
	
	public Integer getQuestion_no() {
		return question_no;
	}
	public void setQuestion_no(Integer question_no) {
		this.question_no = question_no;
	}
	public Integer getSurvey_no() {
		return survey_no;
	}
	public void setSurvey_no(Integer survey_no) {
		this.survey_no = survey_no;
	}
	public String getQuestion_num() {
		return question_num;
	}
	public void setQuestion_num(String question_num) {
		this.question_num = question_num;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getNecessity_yn() {
		return necessity_yn;
	}
	public void setNecessity_yn(String necessity_yn) {
		this.necessity_yn = necessity_yn;
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
	public Integer getQuestion_category_no() {
		return question_category_no;
	}
	public void setQuestion_category_no(Integer question_category_no) {
		this.question_category_no = question_category_no;
	}
	public Integer getAnswer_cnt() {
		return answer_cnt;
	}
	public void setAnswer_cnt(Integer answer_cnt) {
		this.answer_cnt = answer_cnt;
	}
	public Integer getSelection_no() {
		return selection_no;
	}
	public void setSelection_no(Integer selection_no) {
		this.selection_no = selection_no;
	}
	
	public String getQuestion_category_name() {
		return question_category_name;
	}
	public void setQuestion_category_name(String question_category_name) {
		this.question_category_name = question_category_name;
	}
	public List<SelectionVO> getSelectionList() {
		return selectionList;
	}
	public void setSelectionList(List<SelectionVO> selectionList) {
		this.selectionList = selectionList;
	}
	public List<QuestionVO> getQuestionList() {
		return questionList;
	}
	public void setQuestionList(List<QuestionVO> questionList) {
		this.questionList = questionList;
	}
	
	@Override
	public String toString() {
		return "QuestionVO [question_no=" + question_no + ", survey_no=" + survey_no + ", question_num=" + question_num
				+ ", content=" + content + ", necessity_yn=" + necessity_yn + ", del_yn=" + del_yn + ", parent_no="
				+ parent_no + ", question_category_no=" + question_category_no + ", question_category_name="
				+ question_category_name + ", answer_cnt=" + answer_cnt + ", selection_no=" + selection_no
				+ ", selectionList=" + selectionList + ", questionList=" + questionList + "]";
	}

}
