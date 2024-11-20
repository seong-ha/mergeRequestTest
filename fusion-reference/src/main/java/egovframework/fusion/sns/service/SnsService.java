package egovframework.fusion.sns.service;

import java.util.List;
import java.util.Map;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.vo.FilesVO;

public interface SnsService {
	// sns 글 등록
	Map<String, Object> insSnsPost(BoardVO boardVO);
	
	// sns 단건 조회
	BoardVO getSnsPost(BoardVO boardVO);
	
	// sns 목록 조회(첫조회)
	List<BoardVO> getBoardList(SearchVO searchVO);
	
	// sns 추가 목록 조회(스크롤)
	List<BoardVO> getMoreSnsPostList(SearchVO searchVO);
	
	// sns 글 삭제
	String delSnsPost(BoardVO boardVO, List<FilesVO> beDeletedFileList);
	
	// sns 글 수정
	String updSnsPost(BoardVO boardVO, List<FilesVO> deletedFileList);
	
	// sns 글 댓글 목록 조회
	List<CommentsVO> getSnsCommentsList(BoardVO boardVO);
	
	// sns 댓글 등록
	String insSnsComments(CommentsVO commentsVO);
	
	// sns 댓글 수정
	String updSnsComments(CommentsVO commentsVO);
	
	// sns 댓글 삭제
	String delSnsComments(CommentsVO commentsVO);
}
