package egovframework.fusion.gallery.service;

import java.util.List;
import java.util.Map;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.vo.FilesVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;

public interface GalleryService {
	// 갤러리 게시글,파일,태그 등록
	public Map<String, Object> insGallery(BoardVO boardVO, List<FilesVO> fileList, List<String> tags);
	// 갤러리 게시글리스트 가져오기
	public List<BoardVO> getBoardList(SearchVO searchVO);
	// 갤러리 게시글리스트의 태그리스트 가져오기
	public List<TagVO> getGalleryTagList(List<Integer> boardNoList);
	// 갤러리 게시글리스트의 썸네일 가져오기
	public List<FilesVO> getGalleryThumbnails(List<Integer> boardNoList);
	// 갤러리 게시글 가져오기
	public BoardVO getGalleryBoard(BoardVO boardVO);
	// 갤러리 게시글의 파일리스트 가져오기
	public List<FilesVO> getGalleryFiles(BoardVO boardVO);
	// 갤러리 게시글의 태그리스트 가져오기
	public List<TagVO> getGalleryTags(BoardVO boardVO);
	// 파일 다운로드 수 올리기
	public void updDownCnt(FilesVO filesVO);
	// 좋아요 로그 등록
	public LikeVO insLikeLog(LikeVO likeVO);
	// 게시글 좋아요 수 업데이트
	public void updBoardLikeCnt(LikeVO likeVO);
	// 회원의 게시물 좋아요 상태
	public LikeVO isLiked(LikeVO likeVO);
	// 갤러리 게시글 수정
	public int updGalleryBoard(BoardVO boardVO);
	// 해당 갤러리 게시글 파일 삭제
	public Map<String, Object> updGalleryFiles(List<Integer> deletedFiles, List<FilesVO> fileList, Integer board_no, String t_path);
	// 태그리스트 삭제하기
	public Map<String, Object> updGalleryTags(List<TagVO> deletedTags, List<TagVO> newTags);
	// 갤러리 게시글 삭제
	public Map<String, Object> delGallery(BoardVO boardVO);
}
