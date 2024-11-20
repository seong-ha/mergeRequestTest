package egovframework.fusion.author.vo;

public class AuthorVO {
	private Integer author_no;
	private String author_name;
	private String author_name_kor;
	public Integer getAuthor_no() {
		return author_no;
	}
	public void setAuthor_no(Integer author_no) {
		this.author_no = author_no;
	}
	public String getAuthor_name() {
		return author_name;
	}
	public void setAuthor_name(String author_name) {
		this.author_name = author_name;
	}
	public String getAuthor_name_kor() {
		return author_name_kor;
	}
	public void setAuthor_name_kor(String author_name_kor) {
		this.author_name_kor = author_name_kor;
	}
	@Override
	public String toString() {
		return "AuthorVO [author_no=" + author_no + ", author_name=" + author_name + ", author_name_kor="
				+ author_name_kor + "]";
	}
	
}
