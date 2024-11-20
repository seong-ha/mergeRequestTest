package egovframework.fusion.sns.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.vo.FilesVO;

@Mapper
public interface SnsMapper {
	// sns글 insert
	int insertSnsPost(BoardVO boardVO);
	
	// sns글 단건 조회
	BoardVO selectSnsPost(BoardVO boardVO);
	
	// sns 목록 조회
	List<BoardVO> selectSnsPostList(SearchVO searchVO);
	
	// 선택된 페이지를 앞이나 뒤로 이동하여 나온 sns 목록 조회
	List<BoardVO> selectMoreSnsPostList(SearchVO searchVO);
	
	// sns 글 삭제
	int deleteSnsPost(BoardVO boardVO);
	
	// sns 삭제파일 등록
	int insDeletedFiles(List<FilesVO> deletedFileList);
	
	// sns 글 수정
	int updateSnsPost(BoardVO boardVO);
	
	// sns 글 댓글 목록 조회
	List<CommentsVO> selectSnsCommentsList(BoardVO boardVO);
	
	// sns 댓글 등록
	int insertSnsComments(CommentsVO commentsVO);
	
	// sns 댓글 수정
	int updateSnsComments(CommentsVO commentsVO);
	
	// sns 댓글 삭제
	int deleteSnsComments(CommentsVO commentsVO);
}
