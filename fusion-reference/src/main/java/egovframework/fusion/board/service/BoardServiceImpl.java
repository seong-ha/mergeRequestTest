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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;

@Service
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardServiceImpl.class);

	@Autowired
	BoardMapper boardMapper;

	@Autowired
	HttpServletRequest request;

	@Override
	public List<BoardVO> getBoardList(SearchVO searchVO) {
		return boardMapper.getBoardList(searchVO);
	}

	@Override
	public List<BoardVO> getNoticeList(SearchVO searchVO) {
		return boardMapper.getNoticeList(searchVO);
	}

	@Override
	public String insBoardPost(BoardVO boardVO) {
		// 답글 등록이 아닌 경우. 원글번호, 글깊이 파라미터 0으로 세팅
		if (boardVO.getParent_no() == null && boardVO.getRe_lev() == null) {
			boardVO.setParent_no(0);
			boardVO.setRe_lev(0);
		} else {	// 답글 등록일 시 부모 re_lev에 + 1
			boardVO.setRe_lev(boardVO.getRe_lev() + 1);
		}
		
		int result = boardMapper.insBoardPost(boardVO);
		
		String message = "";
		if (result != 0) {
			message = "정상 등록되었습니다.";
		} else {
			message = "등록에 실패했습니다.";
		}

		return message;
	}

	@Override
	public BoardVO getBoardPost(BoardVO boardVO) {
		return boardMapper.getBoardPost(boardVO);
	}

	@Override
	public Integer chkViewLog(BoardVO boardVO) {
		Integer result = boardMapper.chkViewLog(boardVO);
		
		if (result == null) {
			boardMapper.insViewLog(boardVO);
		}
		return result;
	}

	@Override
	public void updBoardCnt(BoardVO boardVO) {
		boardMapper.updBoardCnt(boardVO);
	}

	@Override
	public void updBoardPost(BoardVO boardVO) {
		boardMapper.updBoardPost(boardVO);
	}

	@Override
	/* @Transactional */
	public int delBoardPost(BoardVO boardVO) {
		int result = 0;
		
		try {
			result = boardMapper.delBoardPost(boardVO);
			result = boardMapper.delBoardPostChild(boardVO);
			if (result == -1) {
				result = 1;
			}
		} catch (Exception e) {
			return 0;
		}
		
		return result;
	}

	@Override
	public int insComment(CommentsVO commentsVO) {
		return boardMapper.insComment(commentsVO);
	}

	@Override
	public List<CommentsVO> getCommentsList(BoardVO boardVO) {
		return boardMapper.getCommentsList(boardVO);
	}

	@Override
	public int updComment(CommentsVO commentsVO) {
		return boardMapper.updComment(commentsVO);
	}

	@Override
	public int delComment(CommentsVO commentsVO) {
		return boardMapper.delComment(commentsVO);
	}

	@Override
	public int delChkBoard(List<Integer> checkedList) {
		BoardVO boardVO = new BoardVO();
		int result = 0;
		
		try {
			for (Integer i : checkedList) {
				boardVO.setBoard_no(i);
				result = boardMapper.delBoardPost(boardVO);
				result = boardMapper.delBoardPostChild(boardVO);
			}
			
			if (result == -1) {
				result = 1;
			}
		} catch (Exception e) {
			result = 0;
		}
		
		return result;
	}

	@Override
	public BoardVO getPopupNotice(SearchVO searchVO) {
		return boardMapper.getPopupNotice(searchVO);
	}

}
