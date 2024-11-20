package egovframework.fusion.gallery.vo;

public class FilesVO {
	private Integer files_no;
	private Integer board_no;
	private Integer file_order;
	private String origin_name;
	private String save_name;
	private Integer volume;
	private String path;
	private String del_yn;
	private Integer down_cnt;
    private String regist_dt;
    private String update_dt;
	
	
	public Integer getFiles_no() {
		return files_no;
	}
	public void setFiles_no(Integer files_no) {
		this.files_no = files_no;
	}
	public Integer getBoard_no() {
		return board_no;
	}
	public void setBoard_no(Integer board_no) {
		this.board_no = board_no;
	}
	public Integer getFile_order() {
		return file_order;
	}
	public void setFile_order(Integer file_order) {
		this.file_order = file_order;
	}
	public String getOrigin_name() {
		return origin_name;
	}
	public void setOrigin_name(String origin_name) {
		this.origin_name = origin_name;
	}
	public String getSave_name() {
		return save_name;
	}
	public void setSave_name(String save_name) {
		this.save_name = save_name;
	}
	public Integer getVolume() {
		return volume;
	}
	public void setVolume(Integer volume) {
		this.volume = volume;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getDel_yn() {
		return del_yn;
	}
	public void setDel_yn(String del_yn) {
		this.del_yn = del_yn;
	}
	public Integer getDown_cnt() {
		return down_cnt;
	}
	public void setDown_cnt(Integer down_cnt) {
		this.down_cnt = down_cnt;
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
	@Override
	public String toString() {
		return "FilesVO [file_no=" + files_no + ", board_no=" + board_no + ", file_order=" + file_order
				+ ", origin_name=" + origin_name + ", save_name=" + save_name + ", volume=" + volume + ", path=" + path
				+ ", del_yn=" + del_yn + ", down_cnt=" + down_cnt + ", regist_dt=" + regist_dt + ", update_dt="
				+ update_dt + "]";
	}
}
