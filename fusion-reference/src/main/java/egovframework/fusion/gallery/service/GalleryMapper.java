package egovframework.fusion.gallery.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.vo.FilesVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;

@Mapper
public interface GalleryMapper {
	// 갤러리 게시글 등록
	public int insGalleryBoard(BoardVO boardVO);
	// 갤러리 게시글의 파일들 등록
	public int insGalleryFiles(List<FilesVO> fileList);
	// 갤러리 게시글의 태그들 등록
	public int insGalleryTags(List<TagVO> tagList);
	// 갤러리 게시글리스트 가져오기
	public List<BoardVO> getGalleryBoardList(SearchVO searchVO);
	// 갤러리 게시글리스트의 태그리스트 가져오기
	public List<TagVO> getGalleryTagList(List<Integer> boardNoList);
	// 갤러리 게시글리스트의 썸네일 가져오기
	public List<FilesVO> getGalleryThumbnails(List<Integer> boardNoList);
	// 갤러리 게시글 가져오기
	public BoardVO getGalleryBoard(BoardVO boardVO);
	// 갤러리 게시글의 파일리스트 가져오기
	public List<FilesVO> getGalleryFiles(BoardVO boardVO);
	// 갤러리 게시글 태그리스트 가져오기
	public List<TagVO> getGalleryTags(BoardVO boardVO);
	// 파일 다운로드 수 올리기
	public void updDownCnt(FilesVO filesVO);
	// 좋아요 로그 등록
	public void insLikeLog(LikeVO likeVO);
	// 게시글 좋아요 수 업데이트
	public void updBoardLikeCnt(LikeVO likeVO);
	// 회원의 게시물 좋아요 상태
	public LikeVO isLiked(LikeVO likeVO);
	// 갤러리 게시글 수정
	public int updGalleryBoard(BoardVO boardVO);
	// 해당 갤러리 게시글 파일 삭제
	public int delGalleryFiles(List<Integer> deletedFiles);
	// 현재 썸네일 담당하고 있는 원본파일 정보
	public FilesVO nowThumbOriginFile(Integer board_no);
	// 현재 썸네일 파일 삭제하기
	public int delThumbFile(FilesVO filesVO);
	// 현재 해당 게시물에 존재하는 첫번째 파일
	public FilesVO firstExistFile(Integer board_no);
	// 갤러리 게시글의 파일 등록
	public int insGalleryFile(FilesVO filesVO);
	// 태그리스트 삭제하기
	public int delGalleryTags(List<TagVO> deletedTags);
	// 갤러리 게시글 삭제
	public int delGalleryBoard(BoardVO boardVO);
	// 삭제한 게시글의 파일들도 삭제
	public int delGalleryBoardFiles(BoardVO boardVO);
	// 삭제한 게시글의 태그들도 삭제
	public int delGalleryBoardTags(BoardVO boardVO);
}
