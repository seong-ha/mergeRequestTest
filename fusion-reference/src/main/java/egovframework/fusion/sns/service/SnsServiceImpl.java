package egovframework.fusion.sns.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.service.GalleryMapper;
import egovframework.fusion.gallery.vo.FilesVO;

@Service
public class SnsServiceImpl implements SnsService{
	@Autowired
	SnsMapper dao;
	
	@Autowired
	GalleryMapper galleryMapper;
	
	@Override
	public Map<String, Object> insSnsPost(BoardVO boardVO) {
		Map<String, Object> map = new HashMap<>();
		// SNS는 계층형 글이 아니므로 모두 0
		boardVO.setParent_no(0);
		boardVO.setRe_lev(0);
		
		int result = 0;
		
		try {
			result = dao.insertSnsPost(boardVO);
			map.put("result", "성공");
			map.put("msg", "글 등록에 성공했습니다.");
			map.put("board_no", boardVO.getBoard_no());
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "실패");
			map.put("msg", "글 등록에 실패했습니다.");
		}

		return map;
	}

	@Override
	public BoardVO getSnsPost(BoardVO boardVO) {
		boardVO = dao.selectSnsPost(boardVO);
		return boardVO;
	}

	@Override
	public List<BoardVO> getBoardList(SearchVO searchVO) {
		return dao.selectSnsPostList(searchVO);
	}

	@Override
	public List<BoardVO> getMoreSnsPostList(SearchVO searchVO) {
		return dao.selectMoreSnsPostList(searchVO);
	}

	@Override
	public String delSnsPost(BoardVO boardVO, List<FilesVO> beDeletedFileList) {
		String result = "";
		
		try {
			// 삭제할 파일 있으면 등록
			if (beDeletedFileList != null && beDeletedFileList.size() > 0) {
				dao.insDeletedFiles(beDeletedFileList);
			}
			
			dao.deleteSnsPost(boardVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public String updSnsPost(BoardVO boardVO, List<FilesVO> deletedFileList) {
		String result = "";
		
		try {
			// 삭제된 파일 있으면 등록
			if (deletedFileList != null && deletedFileList.size() > 0) {
				dao.insDeletedFiles(deletedFileList);
			}
			
			dao.updateSnsPost(boardVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public List<CommentsVO> getSnsCommentsList(BoardVO boardVO) {
		return dao.selectSnsCommentsList(boardVO);
	}

	@Override
	public String insSnsComments(CommentsVO commentsVO) {
		String result = "";
		
		try {
			dao.insertSnsComments(commentsVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public String updSnsComments(CommentsVO commentsVO) {
		String result = "";
		
		try {
			dao.updateSnsComments(commentsVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public String delSnsComments(CommentsVO commentsVO) {
		String result = "";
		
		try {
			dao.deleteSnsComments(commentsVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

}
