package egovframework.fusion.survey.vo;

public class ParticipateVO {
	private Integer participate_no;
	private Integer survey_no;
	private Integer member_no;
	
	private Integer participate_cnt;
	
	public Integer getParticipate_no() {
		return participate_no;
	}
	public void setParticipate_no(Integer participate_no) {
		this.participate_no = participate_no;
	}
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
	public Integer getParticipate_cnt() {
		return participate_cnt;
	}
	public void setParticipate_cnt(Integer participate_cnt) {
		this.participate_cnt = participate_cnt;
	}
	@Override
	public String toString() {
		return "ParticipateVO [participate_no=" + participate_no + ", survey_no=" + survey_no + ", member_no="
				+ member_no + ", participate_cnt=" + participate_cnt + "]";
	}
}
