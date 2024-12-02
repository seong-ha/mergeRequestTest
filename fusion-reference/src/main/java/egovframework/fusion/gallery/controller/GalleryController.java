package egovframework.fusion.gallery.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.service.GalleryService;
import egovframework.fusion.gallery.vo.FilesVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.gallery.vo.TagVO;
import egovframework.fusion.member.controller.MemberController;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.paging.vo.PagingVO;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;

@Controller
public class GalleryController {
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	MemberController memberCtrl;
	
	@Autowired
	GalleryService galleryService;
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	MenuService menuService;
	
	private String path = "C:\\uploadFiles";
	private String t_path = path + "\\thumbnailbb";
	
	/*
	 * 갤러리 메인페이지 이동
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/galleryList.do", method = RequestMethod.GET)
	public String initGallerys(String menuType, SearchVO searchVO, Model model) {
		System.out.println("local에서 sub-master와 merge해서 push해보자, 율하바른정형외과");
		
		// searchVO 초기값 생성
		if (searchVO.getNowPage() == null && searchVO.getCntPerPage() == null) {
			searchVO.setNoPageChoose(true);	// 페이징 선택 안했을 시(= 메뉴 첫접근 => 메뉴 접근 기록 추가)
			searchVO.setNowPage(1);
			searchVO.setCntPerPage(8);
		} else if (searchVO.getNowPage() == null) {
			searchVO.setNoPageChoose(true);	// 페이징 선택 안했을 시(= 메뉴 첫접근 => 메뉴 접근 기록 추가)
			searchVO.setNowPage(1);
		} else if (searchVO.getCntPerPage() == null) {
			searchVO.setNoPageChoose(false);// 페이징 선택 했을 시(= 메뉴 첫접근X => 메뉴 접근 기록 추가X)
			searchVO.setCntPerPage(8);
		}
		
		
		
		
		
		
		
		
		// 게시판 종류 부여
		searchVO.setMenuType(menuType);
		
		System.out.println("서울탑재활정형외과 별로");
		
		try {
			// 게시물 리스트 가져오기
			List<BoardVO> boardList = galleryService.getBoardList(searchVO);
			
			// 가져온 게시물 번호 리스트
			List<Integer> boardNoList = new ArrayList<>();
			for (BoardVO vo : boardList) {
				boardNoList.add(vo.getBoard_no());
			}
			
			List<FilesVO> thumbList = null;	// 게시물 썸네일 가져오기
			List<TagVO> tagList = null;		// 태그 리스트 가져오기
			if (boardList.size() > 0 || boardList == null) {
				thumbList = galleryService.getGalleryThumbnails(boardNoList);
				tagList = galleryService.getGalleryTagList(boardNoList);
			}
			
			// 페이징 객체 생성
			int total = 1;
			if (boardList.size() != 0) {
				total = boardList.get(0).getTotal(); 
			}
			PagingVO pagingVO = new PagingVO(total, searchVO.getNowPage(), searchVO.getCntPerPage());
			
			model.addAttribute("boardList", boardList);
			model.addAttribute("thumbList", thumbList);
			model.addAttribute("tagList", tagList);
			model.addAttribute("paging", pagingVO);
			model.addAttribute("search", searchVO);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 어떤 게시판 불 밝힐지 내려줌.
		if (menuType.indexOf(",") != -1) {
			menuType = menuType.substring(0, menuType.indexOf(","));
		}
		model.addAttribute("menuType", menuType);
		return "views/gallery/galleryList";
	}
	
	/*
	 * 갤러리 등록 페이지 이동
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/galleryRegister.do", method = RequestMethod.GET)
	public String galleryRegister(String menuType, String returnUrl, Model model) {
		model.addAttribute("returnUrl" ,returnUrl);
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		
		model.addAttribute("menuType", menuType);								// 어떤 게시판 불 밝힐지 내려줌.
		
		return "views/gallery/galleryRegister";
	}
	
	/*
	 * 갤러리 게시물 등록
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/insGallery.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insGallery(BoardVO boardVO,
										List<MultipartFile> files,
										@RequestParam(value = "tags", required = false) List<String> tags) {
		
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 현재 세션의 member_no를 member_no로 set해주기
		boardVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		// boardVO의 type을 normal로 고정(갤러리 게시판은 공지사항이 없다고 생각해서)
		boardVO.setType("normal");
		
		List<FilesVO> fileList = new ArrayList<>();
		if (files != null && files.size() > 0) {
			for (MultipartFile file : files) {
				// 원래이름, 확장자, 파일크기
				String origin_name = file.getOriginalFilename();
				String fileExtension = origin_name.substring(origin_name.lastIndexOf("."),origin_name.length());
				int volume = (int) file.getSize();
	
				// 저장할 이름
				String uuid = UUID.randomUUID().toString();
				String save_name = uuid + fileExtension;
				
				// 디렉토리 존재하지 않으면 만들기
				File pathDir = new File(path);
				if (!pathDir.exists()) {
					pathDir.mkdirs();
				}
				
				File saveFile = new File(path, save_name);
				try {
					file.transferTo(saveFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				// 첫 파일이면 썸네일 만들기
				if (files.get(0) == file) {
					// 썸네일 디렉토리 존재하지 않으면 만들기
					File t_PathDir = new File(t_path); 	// 썸네일 저장경로
					if (!t_PathDir.exists()) {
						t_PathDir.mkdirs();
					}
					
					String t_name = "t_" + save_name;	// 썸네일 저장이름
					
					try {
						// 전송해놓은 첫 파일로 썸네일 만들기
						Thumbnails
						.of(new File(path, save_name))
						.size(400, 400)
						.crop(Positions.TOP_CENTER)
						.toFile(new File(t_path, t_name));
					} catch (Exception e) {
						e.printStackTrace();
					}
					
					FilesVO filesVO = new FilesVO();
					filesVO.setOrigin_name(origin_name);
					filesVO.setSave_name(t_name);
					filesVO.setVolume(0);
					filesVO.setPath(t_path);
					fileList.add(filesVO);
				}
				
				// 파일 원래이름/저장이름/파일용량/저장경로 set 후 List에 add 
				FilesVO filesVO = new FilesVO();
				filesVO.setOrigin_name(origin_name);
				filesVO.setSave_name(save_name);
				filesVO.setVolume(volume);
				filesVO.setPath(path);
				fileList.add(filesVO);
			}
		}
		
		try {
			map = galleryService.insGallery(boardVO, fileList, tags);
			
			if (map.get("result").equals("성공")) {
				map.put("msg", "갤러리글이 정상 등록되었습니다.");
			} else if (map.get("result").equals("실패")) {
				map.put("msg", "갤러리글 등록에 실패했습니다.");
			}
		} catch(Exception e) {
			map.put("result", "실패");
			map.put("msg", "갤러리 등록에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 갤러리 사진 다운로드
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/download.do", method = RequestMethod.GET)
	public void fileDownload (String menuType, FilesVO filesVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// FIXME IO예외 등등 눈에 보이는 예외 처리하기
		// globals.properties
		File file = new File(path, filesVO.getSave_name());
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

		//User-Agent : 어떤 운영체제로  어떤 브라우저를 서버( 홈페이지 )에 접근하는지 확인함
		String header = request.getHeader("User-Agent");
		String fileName;

		if ((header.contains("MSIE")) || (header.contains("Trident")) || (header.contains("Edge"))) {
		//인터넷 익스플로러 10이하 버전, 11버전, 엣지에서 인코딩 
			fileName = URLEncoder.encode(filesVO.getOrigin_name(), "UTF-8");
		} else {
		    //나머지 브라우저에서 인코딩
		    fileName = new String(filesVO.getOrigin_name().getBytes("UTF-8"), "iso-8859-1");
		}
		//형식을 모르는 파일첨부용 contentType
		response.setContentType("application/octet-stream");
		//다운로드와 다운로드될 파일이름
		response.setHeader("Content-Disposition", "attachment; filename=\""+ fileName + "\"");
		//파일복사
		FileCopyUtils.copy(in, response.getOutputStream());
		in.close();
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
		// 다운로드 수 증가
		galleryService.updDownCnt(filesVO);
	}
	
	/*
	 * 갤러리 썸네일 다운로드(보기)
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/thumbnail.do", method = RequestMethod.GET)
	public void thumbnail (String menuType, FilesVO filesVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    File file = new File(t_path, filesVO.getSave_name());
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

		//User-Agent : 어떤 운영체제로  어떤 브라우저를 서버( 홈페이지 )에 접근하는지 확인함
		String header = request.getHeader("User-Agent");
		String fileName;

		if ((header.contains("MSIE")) || (header.contains("Trident")) || (header.contains("Edge"))) {
		  //인터넷 익스플로러 10이하 버전, 11버전, 엣지에서 인코딩 
		  fileName = URLEncoder.encode(filesVO.getOrigin_name(), "UTF-8");
		} else {
		  //나머지 브라우저에서 인코딩
		  fileName = new String(filesVO.getOrigin_name().getBytes("UTF-8"), "iso-8859-1");
		}
		//형식을 모르는 파일첨부용 contentType
		response.setContentType("application/octet-stream");
		//다운로드와 다운로드될 파일이름
		response.setHeader("Content-Disposition", "attachment; filename=\""+ fileName + "\"");
		//파일복사
		FileCopyUtils.copy(in, response.getOutputStream());
		in.close();
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	/*
	 * 갤러리 사진 받아보기
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/img.do", method = RequestMethod.GET)
	public void getImg (String menuType, FilesVO filesVO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// FIXME IO예외 등등 눈에 보이는 예외 처리하기
		// globals.properties
		File file = new File(path, filesVO.getSave_name());
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

		//User-Agent : 어떤 운영체제로  어떤 브라우저를 서버( 홈페이지 )에 접근하는지 확인함
		String header = request.getHeader("User-Agent");
		String fileName;

		if ((header.contains("MSIE")) || (header.contains("Trident")) || (header.contains("Edge"))) {
		//인터넷 익스플로러 10이하 버전, 11버전, 엣지에서 인코딩 
			fileName = URLEncoder.encode(filesVO.getOrigin_name(), "UTF-8");
		} else {
		    //나머지 브라우저에서 인코딩
		    fileName = new String(filesVO.getOrigin_name().getBytes("UTF-8"), "iso-8859-1");
		}
		//형식을 모르는 파일첨부용 contentType
		response.setContentType("application/octet-stream");
		//다운로드와 다운로드될 파일이름
		response.setHeader("Content-Disposition", "attachment; filename=\""+ fileName + "\"");
		//파일복사
		FileCopyUtils.copy(in, response.getOutputStream());
		in.close();
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	/*
	 * 갤러리 상세 페이지 이동
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/galleryPost.do", method = RequestMethod.GET)
	public String galleryPost(String menuType, BoardVO boardVO, String returnUrl, Model model) {
		model.addAttribute("returnUrl" ,returnUrl);
		
//		if (memberCtrl.checkSession(model) != null) {
//			return memberCtrl.checkSession(model);
//		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 현재 세션의 member_no를 member_no로 set해주기
		boardVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		try {
			// 조회 이력 체크 후 조회 수 올리기
			Integer chkResult = boardService.chkViewLog(boardVO);
			if (chkResult == null) {
				boardService.updBoardCnt(boardVO);
			}
			
			// 게시글 가져오기
			BoardVO galleryBoard = galleryService.getGalleryBoard(boardVO);
			// 게시물 파일리스트 가져오기
			List<FilesVO> galleryFiles = galleryService.getGalleryFiles(boardVO);
			// 게시물 태그리스트 가져오기
			List<TagVO> galleryTags = galleryService.getGalleryTags(boardVO);
			
			LikeVO likeVO = new LikeVO();
			likeVO.setBoard_no(boardVO.getBoard_no());
			likeVO.setMember_no(boardVO.getMember_no());
			likeVO = galleryService.isLiked(likeVO);
			

			model.addAttribute("board", galleryBoard);
			model.addAttribute("files", galleryFiles);
			model.addAttribute("tags", galleryTags);
			model.addAttribute("like", likeVO);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		// 어떤 게시판 불 밝힐지 내려줌.
		if (menuType.indexOf(",") != -1) {
			menuType = menuType.substring(0, menuType.indexOf(","));
		}
		model.addAttribute("menuType", menuType);

		return "views/gallery/galleryPost";
	}
	
	/*
	 * 좋아요 등록수정
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/updLike.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updLike(LikeVO likeVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 현재 세션의 member_no를 member_no로 set해주기
		likeVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		try {
			// 좋아요 이력 등록 후, 계산되어 나온 업데이트값을 게시글 LIKE_CNT에 반영
			likeVO = galleryService.insLikeLog(likeVO);
			galleryService.updBoardLikeCnt(likeVO);
			map.put("update_amount", likeVO.getUpdate_amount());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 갤러리 수정 페이지 이동
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/galleryPostModify.do")
	public String galleryPostModify(String menuType, BoardVO boardVO, Model model) {
		model.addAttribute("returnUrl" ,boardVO.getReturnUrl());
		model.addAttribute("returnUrl2" ,boardVO.getReturnUrl2());
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 현재 세션의 member_no를 member_no로 set해주기
		boardVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		try {
			// 게시글 가져오기
			BoardVO galleryBoard = galleryService.getGalleryBoard(boardVO);
			// 게시물 파일리스트 가져오기
			List<FilesVO> galleryFiles = galleryService.getGalleryFiles(boardVO);
			// 게시물 태그리스트 가져오기
			List<TagVO> galleryTags = galleryService.getGalleryTags(boardVO);
			
			LikeVO likeVO = new LikeVO();
			likeVO.setBoard_no(boardVO.getBoard_no());
			likeVO.setMember_no(boardVO.getMember_no());
			likeVO = galleryService.isLiked(likeVO);
			
			model.addAttribute("board", galleryBoard);
			model.addAttribute("files", galleryFiles);
			model.addAttribute("tags", galleryTags);
			model.addAttribute("like", likeVO);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		// 어떤 게시판 불 밝힐지 내려줌.
		if (menuType.indexOf(",") != -1) {
			menuType = menuType.substring(0, menuType.indexOf(","));
		}
		model.addAttribute("menuType", menuType);
		
		return "views/gallery/galleryPostModify";
	}
	
	/*
	 * 갤러리 게시물 수정
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/gallery/updGallery.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updGallery(BoardVO boardVO, List<MultipartFile> files,
					@RequestParam(value = "tags", required = false) List<String> tags,
					@RequestParam(value = "deletedFiles", required = false) List<Integer> deletedFiles,
					@RequestParam(value = "originTagNos", required = false) List<Integer> originTagNos,
					@RequestParam(value = "originTagNames", required = false) List<String> originTagNames) {
		
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 글을 수정하는 세션이 글주인과 다르거나, 현재세션이 관리진들이 아니면 돌려보내기
		if (boardVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "실패");
			map.put("msg", "본인만 수정할 수 있습니다.");
			return map;
		}

		// boardVO의 type을 normal로 고정(갤러리 게시판은 공지사항이 없다고 생각해서)
		boardVO.setType("normal");
		
		
		
		/*
		 * 갤러리 게시글 수정
		 */
		try {
			// 갤러리 게시글 수정
			galleryService.updGalleryBoard(boardVO);
		} catch (Exception e) {
			map.put("result", "실패");
			map.put("msg", "갤러리글 글수정에 실패했습니다.");
			e.printStackTrace();
			return map;
		}
		
		
		
		/*
		 * 갤러리 게시글 파일 수정
		 */
		// 새로 받아온 파일들 저장시키고 파일 정보들 뽑아내서 세팅하기
		List<FilesVO> fileList = new ArrayList<>();
		if (files != null && files.size() > 0) {
			for (MultipartFile file : files) {
				// 원래이름, 확장자, 파일크기
				String origin_name = file.getOriginalFilename();
				String fileExtension = origin_name.substring(origin_name.lastIndexOf("."),origin_name.length());
				int volume = (int) file.getSize();

				// 저장할 이름
				String uuid = UUID.randomUUID().toString();
				String save_name = uuid + fileExtension;
				
				// 디렉토리 존재하지 않으면 만들기
				File pathDir = new File(path);
				if (!pathDir.exists()) {
					pathDir.mkdirs();
				}
				
				File saveFile = new File(path, save_name);
				try {
					file.transferTo(saveFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				// 파일 게시글번호/원래이름/저장이름/파일용량/저장경로 set 후 List에 add 
				FilesVO filesVO = new FilesVO();
				filesVO.setBoard_no(boardVO.getBoard_no());
				filesVO.setOrigin_name(origin_name);
				filesVO.setSave_name(save_name);
				filesVO.setVolume(volume);
				filesVO.setPath(path);
				fileList.add(filesVO);
			}
		}
		
		
		try {
			map = galleryService.updGalleryFiles(deletedFiles, fileList, boardVO.getBoard_no(), t_path);
			
			if (map.get("result").equals("실패")) {
				map.put("msg", "갤러리글 파일수정에 실패했습니다.");
				return map;
			}
		} catch(Exception e) {
			map.put("result", "실패");
			map.put("msg", "갤러리 파일수정 실패했습니다.");
			e.printStackTrace();
			return map;
		}
		
		
		/*
		 * 갤러리 게시글 태그 수정
		 */
		
		// 태그 수정 부분
		List<TagVO> originVOList = new ArrayList<>();		// DB로 가져갈 것
		List<TagVO> tempOriginVOList = new ArrayList<>();	// 필터링 하기 위한 것
		List<TagVO> newTags = new ArrayList<>();


		if (originTagNos == null && tags != null) {		// 기존 태그가 없는 경우는 새로 추가만 한다.
			for (int i = 0; i < tags.size(); i++) {
				TagVO vo = new TagVO();
				vo.setBoard_no(boardVO.getBoard_no());
				vo.setTag_name(tags.get(i));
				newTags.add(vo);
			}
		} else if (originTagNos != null && tags == null) {	// 기존 태그가 존재했는데 새태그가 존재하지 않으면 모조리 삭제
			for (int i = 0; i < originTagNos.size(); i++) {
				TagVO tagVO = new TagVO();
				tagVO.setBoard_no(boardVO.getBoard_no());
				tagVO.setTag_no(originTagNos.get(i));
				tagVO.setTag_name(originTagNames.get(i));
				originVOList.add(tagVO);
				
				TagVO tempTagVO = new TagVO();
				tempTagVO.setTag_no(originTagNos.get(i));
				tempTagVO.setTag_name(originTagNames.get(i));
				tempOriginVOList.add(tempTagVO);
			}
		} else if (originTagNos != null && tags != null) {	// 둘 다 있으면 비교하고 삭제하고 새로 추가하고
			for (int i = 0; i < originTagNos.size(); i++) {
				TagVO tagVO = new TagVO();
				tagVO.setBoard_no(boardVO.getBoard_no());
				tagVO.setTag_no(originTagNos.get(i));
				tagVO.setTag_name(originTagNames.get(i));
				originVOList.add(tagVO);
				
				TagVO tempTagVO = new TagVO();
				tempTagVO.setTag_no(originTagNos.get(i));
				tempTagVO.setTag_name(originTagNames.get(i));
				tempOriginVOList.add(tempTagVO);
			}

			for (int i = 0; i < tags.size(); i++) {
				TagVO vo = new TagVO();
				vo.setBoard_no(boardVO.getBoard_no());
				vo.setTag_name(tags.get(i));
				newTags.add(vo);
			}


			// 기존거랑 같은거는 비워줌으로써 제거된 애들을 찾는다.
			for (int i = 0; i < newTags.size(); i++) {
				for (int j = 0; j < originVOList.size(); j++) {
					if (originVOList.get(j).getTag_name().equals(newTags.get(i).getTag_name())) {
						TagVO tempVO = new TagVO();
						tempVO.setTag_name("");
						originVOList.set(j, tempVO);	// 같은 거는 비워준다. 어차피 안 건드릴 거니까
						break;
					}
				}
			}
			
			// 빈 부분 없애주기(originVOList. del_yn='Y'칠 친구들로만 추스림)
			for (int i = 0; i < originVOList.size(); i++) {
				if (originVOList.get(i).getTag_name().equals("")) {
					originVOList.remove(i);
				}
			}
			
			// 기존거에 없는 것을 찾아서 새로 들어온 친구들을 찾는다.
			for (int i = 0; i < tempOriginVOList.size(); i++) {
				for (int j = 0; j <newTags.size(); j++) {
					if (tempOriginVOList.get(i).getTag_name().equals(newTags.get(j).getTag_name())) {
						TagVO tempVO = new TagVO();
						tempVO.setTag_name("");
						newTags.set(j, tempVO);	// 같은 거는 비워준다. 어차피 안 건드릴 거니까
						break;
					}
				}
			}
			
			// 빈 부분 없애주기(tags. 새로 추가할 친구들로만 추스림)
			List<TagVO> tempNewTags = new ArrayList<>();
			for (int i = 0; i < newTags.size(); i++) {
				TagVO vo = new TagVO();
				vo.setBoard_no(boardVO.getBoard_no());
				vo.setTag_name(newTags.get(i).getTag_name());
				tempNewTags.add(vo);
			}
			newTags = new ArrayList<TagVO>();
			
			for (int i = 0; i < tempNewTags.size(); i++) {
				if (!tempNewTags.get(i).getTag_name().equals("")) {
					newTags.add(tempNewTags.get(i));
				}
			}
		}
		
		try {
			map = galleryService.updGalleryTags(originVOList, newTags);
			
			if (map.get("result").equals("성공")) {
				map.put("msg", "갤러리글이 정상 수정되었습니다.");
			} else if (map.get("result").equals("실패")) {
				map.put("msg", "갤러리글 태그수정에 실패했습니다.");
			}
		} catch(Exception e) {
			map.put("result", "실패");
			map.put("msg", "갤러리 태그수정 실패했습니다.");
			e.printStackTrace();
			return map;
		}
		
		
		return map;
	}
	
	/*
	 * 갤러리 게시물 삭제
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "//delGallery.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delGallery( BoardVO boardVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 글을 수정하는 세션이 글주인과 다르거나, 현재세션이 관리진들이 아니면 돌려보내기
		if (boardVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "실패");
			map.put("msg", "본인만 수정할 수 있습니다.");
			return map;
		}

		// boardVO의 type을 normal로 고정(갤러리 게시판은 공지사항이 없다고 생각해서)
		boardVO.setType("normal");
		
		try {
			map = galleryService.delGallery(boardVO);
			
			if (map.get("result").equals("성공")) {
				map.put("msg", "갤러리글이 정상 삭제되었습니다.");
			} else if (map.get("result").equals("실패")) {
				map.put("msg", "갤러리글 삭제 실패했습니다.");
			}
		} catch(Exception e) {
			map.put("result", "실패");
			map.put("msg", "갤러리 태그수정 실패했습니다.");
			e.printStackTrace();
			return map;
		}
		
		return map;
	}
}
