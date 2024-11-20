package egovframework.fusion.gallery.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.vo.FilesVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;

@Service
public class GalleryServiceImpl implements GalleryService {
	@Autowired
	GalleryMapper galleryMapper;
	
	@Override
	public Map<String, Object> insGallery(BoardVO boardVO, List<FilesVO> fileList, List<String> tags) {
		Map<String, Object> map = new HashMap<>();
		String result = "";
		
		try {
			galleryMapper.insGalleryBoard(boardVO);		// 게시물 등록
			
			if (fileList != null && fileList.size() > 0) {
				for (FilesVO vo : fileList) {
					vo.setBoard_no(boardVO.getBoard_no());
				}
				galleryMapper.insGalleryFiles(fileList);	// 파일등록
			}
			
			// List<TagVO> 값 부여
			if (tags != null && tags.size() > 0) {
				List<TagVO> tagList = new ArrayList<>();
				for (String str : tags) {
					TagVO vo = new TagVO();
					vo.setBoard_no(boardVO.getBoard_no());
					vo.setTag_name(str);
					tagList.add(vo);
				}
				galleryMapper.insGalleryTags(tagList);
			}
			
			result = "성공";
		} catch (Exception e) {
			e.printStackTrace();
			result = "실패";
		}
		map.put("result", result);
		
		return map;
	}

	@Override
	public List<BoardVO> getBoardList(SearchVO searchVO) {
		return galleryMapper.getGalleryBoardList(searchVO);
	}

	@Override
	public List<TagVO> getGalleryTagList(List<Integer> boardNoList) {
		return galleryMapper.getGalleryTagList(boardNoList);
	}

	@Override
	public List<FilesVO> getGalleryThumbnails(List<Integer> boardNoList) {
		List<FilesVO> list = new ArrayList<>();
		list = galleryMapper.getGalleryThumbnails(boardNoList);
		List<Integer> tempBoardNoList = new ArrayList<>();
		
		// 가져올 게시물이 존재하면 
		if (boardNoList.size() != list.size()) {
			for (int i = 0; i < list.size(); i++) {
				for (int j = 0; j < tempBoardNoList.size(); j++) {
					if(list.get(i).getBoard_no() == tempBoardNoList.get(j)) {
						boardNoList.set(i, 0);
					}
				}
			}
		}
		
		int boardNoListSize = boardNoList.size();
		for (int i = 0; i < boardNoListSize; i++) {
			if (boardNoList.get(i) == 0) {
				boardNoList.remove(i);
			}
		}
		
		for (int i = 0; i < boardNoList.size(); i++) {
			FilesVO vo = new FilesVO();
			vo.setBoard_no(boardNoList.get(i));
			vo.setSave_name("t_thumbnail.jpg");
			vo.setOrigin_name("thumbnail.jpg");
			list.add(vo);
		}
		
		return list;
	}

	@Override
	public BoardVO getGalleryBoard(BoardVO boardVO) {
		return galleryMapper.getGalleryBoard(boardVO);
	}

	@Override
	public List<FilesVO> getGalleryFiles(BoardVO boardVO) {
		return galleryMapper.getGalleryFiles(boardVO);
	}

	@Override
	public List<TagVO> getGalleryTags(BoardVO boardVO) {
		return galleryMapper.getGalleryTags(boardVO);
	}

	@Override
	public void updDownCnt(FilesVO filesVO) {
		galleryMapper.updDownCnt(filesVO);
	}

	@Override
	public LikeVO insLikeLog(LikeVO likeVO) {
		galleryMapper.insLikeLog(likeVO);
		return likeVO;
	}

	@Override
	public void updBoardLikeCnt(LikeVO likeVO) {
		galleryMapper.updBoardLikeCnt(likeVO);
	}

	@Override
	public LikeVO isLiked(LikeVO likeVO) {
		return galleryMapper.isLiked(likeVO);
	}

	@Override
	public int updGalleryBoard(BoardVO boardVO) {
		return galleryMapper.updGalleryBoard(boardVO);
	}

	@Override
	@Transactional
	public Map<String, Object> updGalleryFiles(List<Integer> deletedFiles, List<FilesVO> fileList, Integer board_no, String t_path) {
		Map<String, Object> map = new HashMap<>();
		String result = "";
		
		try {
			// 삭제할 파일들 삭제처리
			if (deletedFiles != null && deletedFiles.size() > 0)
			galleryMapper.delGalleryFiles(deletedFiles);
			
			// 새로 들어온 파일정보 등록
			if (fileList != null && fileList.size() > 0) {
				galleryMapper.insGalleryFiles(fileList);
			}
			
			// 현재의 썸네일 원본파일 정보 가져오기
			FilesVO filesVO = galleryMapper.nowThumbOriginFile(board_no);

			
			// 썸네일 원본파일이 삭제되었다면, 썸네일 파일정보도 지우고.
			// 삭제되지 않은 것 중에 가장 앞에 있는 파일로 썸네일 파일 만들고
			// 썸네일 파일 정보 저장시키기
//			"Y".equals(filesVO.getDel_yn())
			
			if (filesVO != null && filesVO.getDel_yn().equals("Y")) {
				galleryMapper.delThumbFile(filesVO);
				
				// 파일이 다 삭제 되었을 때
				filesVO = galleryMapper.firstExistFile(board_no);
				
				if (filesVO != null) {
					// 디렉토리 존재하지 않으면 만들기
					File t_PathDir = new File(t_path); 	// 썸네일 저장경로
					if (!t_PathDir.exists()) {
						t_PathDir.mkdirs();
					}
					
					String t_name = "t_" + filesVO.getSave_name();	// 썸네일 저장이름
					
					try {
						// 전송해놓은 첫 파일로 썸네일 만들기
						Thumbnails
						.of(new File(filesVO.getPath(), filesVO.getSave_name()))
						.size(400, 400)
						.crop(Positions.TOP_CENTER)
						.toFile(new File(t_path, t_name));
					} catch (Exception e) {
						e.printStackTrace();
					}
					
					filesVO.setOrigin_name(filesVO.getOrigin_name());
					filesVO.setSave_name(t_name);
					filesVO.setVolume(0);
					filesVO.setPath(t_path);
					
					galleryMapper.insGalleryFile(filesVO);
				}

			}
			
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			result = "실패";
			e.printStackTrace();
		}
		map.put("result", result);
		
		return map;
	}

	@Override
	@Transactional
	public Map<String, Object> updGalleryTags(List<TagVO> deletedTags, List<TagVO> newTags) {
		Map<String, Object> map = new HashMap<>();
		String result = "";
		
		try {
			if (deletedTags != null && deletedTags.size() > 0) {
				galleryMapper.delGalleryTags(deletedTags);
			}
			if (newTags != null && newTags.size() > 0) {
				galleryMapper.insGalleryTags(newTags);
			}
			
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			result = "실패";
			e.printStackTrace();
		}
		
		map.put("result", result);
		return map;
	}

	@Override
	@Transactional
	public Map<String, Object> delGallery(BoardVO boardVO) {
		Map<String, Object> map = new HashMap<>();
		String result = "";
		
		try {
			galleryMapper.delGalleryBoard(boardVO);
			galleryMapper.delGalleryBoardFiles(boardVO);
			galleryMapper.delGalleryBoardTags(boardVO);
			
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			result = "실패";
			e.printStackTrace();
		}
		
		map.put("result", result);
		return map;
	}

}
