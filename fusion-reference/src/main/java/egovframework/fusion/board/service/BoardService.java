/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.service;

import java.util.List;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;


public interface BoardService {

	public List<BoardVO> getBoardList(SearchVO searchVO);
	
	public List<BoardVO> getNoticeList(SearchVO searchVO);
	
	public String insBoardPost(BoardVO boardVO);
	
	public BoardVO getBoardPost(BoardVO boardVO);
	
	public Integer chkViewLog(BoardVO boardVO);
	
	public void updBoardCnt(BoardVO boardVO);
	
	public void updBoardPost(BoardVO boardVO);
	
	public int delBoardPost(BoardVO boardVO);
	
	public int insComment(CommentsVO commentsVO);
	
	public List<CommentsVO> getCommentsList(BoardVO boardVO);
	
	public int updComment(CommentsVO commentsVO);
	
	public int delComment(CommentsVO commentsVO);
	
	public int delChkBoard(List<Integer> checkedList);
	
	public BoardVO getPopupNotice(SearchVO searchVO);
}
