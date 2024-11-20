package egovframework.fusion.commCd.vo;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonAutoDetect;

@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class CommCdVO {
	private Integer order_num;
	private Integer comm_cd_no;
	private String code;
	private String code_name;
	private String note;
	private String del_yn;
	private Integer parent_no;
	private String regist_dt;
	private String udpate_dt;
	
	private String menuType;
	private List<CommCdVO> commCdList;
	
	public Integer getOrder_num() {
		return order_num;
	}
	public void setOrder_num(Integer order_num) {
		this.order_num = order_num;
	}
	public Integer getComm_cd_no() {
		return comm_cd_no;
	}
	public void setComm_cd_no(Integer comm_cd_no) {
		this.comm_cd_no = comm_cd_no;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
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
	public String getRegist_dt() {
		return regist_dt;
	}
	public void setRegist_dt(String regist_dt) {
		this.regist_dt = regist_dt;
	}
	public String getUdpate_dt() {
		return udpate_dt;
	}
	public void setUdpate_dt(String udpate_dt) {
		this.udpate_dt = udpate_dt;
	}
	public String getMenuType() {
		return menuType;
	}
	public void setMenuType(String menuType) {
		this.menuType = menuType;
	}
	public List<CommCdVO> getCommCdList() {
		return commCdList;
	}
	public void setCommCdList(List<CommCdVO> commCdList) {
		this.commCdList = commCdList;
	}
	@Override
	public String toString() {
		return "CommCdVO [order_num=" + order_num + ", comm_cd_no=" + comm_cd_no + ", code=" + code + ", code_name="
				+ code_name + ", note=" + note + ", del_yn=" + del_yn + ", parent_no=" + parent_no + ", regist_dt="
				+ regist_dt + ", udpate_dt=" + udpate_dt + ", menuType=" + menuType + ", commCdList=" + commCdList
				+ "]";
	}
	
	
	
	
}
