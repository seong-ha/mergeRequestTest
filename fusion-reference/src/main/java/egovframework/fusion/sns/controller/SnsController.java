package egovframework.fusion.sns.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.gallery.service.GalleryService;
import egovframework.fusion.gallery.vo.FilesVO;
import egovframework.fusion.gallery.vo.LikeVO;
import egovframework.fusion.sns.service.SnsService;

@Controller
public class SnsController {
	
	@Autowired
	SnsService snsService;
	
	@Autowired
	GalleryService galleryService;
	
	@Autowired
	BoardService boardService;
	
	/*
	 * sns 화면으로, 첫 5개 가져오기
	 */
	@GetMapping("/sns/snsList.do")
	public String snsList(SearchVO searchVO, Model model) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		searchVO.setMemberNo((Integer) request.getSession().getAttribute("member_no"));
		searchVO.setNoPageChoose(true);
		searchVO.setNowPage(1);
		searchVO.setCntPerPage(5);
		
		List<BoardVO> snsPostList = snsService.getBoardList(searchVO);
//		for (BoardVO vo : snsPostList) {
//			String content = vo.getContent();
//			content = StringEscapeUtils.unescapeHtml4(content);
//			vo.setContent(content);
//		}
		
		model.addAttribute("snsPostList", snsPostList);
		model.addAttribute("menuType", searchVO.getMenuType());
		return "views/sns/snsList";
    }
	
	/*
	 * sns 목록 가져오기
	 */
	@PostMapping("/sns/getSnsPostList.do")
	public String getSnsPostList(SearchVO searchVO, Model model) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		searchVO.setMemberNo((Integer) request.getSession().getAttribute("member_no"));
		searchVO.setCntPerPage(5);
		
		List<BoardVO> snsPostList = snsService.getMoreSnsPostList(searchVO);
		/*
		 * for (BoardVO vo : snsPostList) { String content = vo.getContent();
		 * 
		 * content = StringEscapeUtils.unescapeHtml4(content); vo.setContent(content); }
		 */
		
		model.addAttribute("snsPostList", snsPostList);
		return "noTiles:views/sns/snsPost";
	}
	
	@Autowired
	HttpServletRequest request;
	
	private String savePath = "C:\\uploadFiles\\upload";
	private String tempSavePath = "C:\\uploadFiles\\tempUpload";
	
	/*
	 * 사진 파일 업로드
	 */
	@RequestMapping(value = "/sns/insUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insUpload(@RequestParam("upload") MultipartFile multi, HttpServletResponse response) {
		Map<String, Object> map = new HashMap<>();
		
		int sizeLimit = 2 * 1024 * 1024;
		
		if (multi.getSize() > sizeLimit) {
			map.put("uploaded", 0);
			return map;
		}
		
		// 파일의 오리지널 네임
		String originalFileName = multi.getOriginalFilename();
		
        // 파일의 확장자
		String ext = originalFileName.substring(originalFileName.indexOf("."));
		
        // 서버에 저장될 때 중복된 파일 이름인 경우를 방지하기 위해 UUID에 확장자를 붙여 새로운 파일 이름을 생성
		String newFileName = UUID.randomUUID() + ext;

		
		// 브라우저에서 이미지 불러올 때 절대 경로로 불러오면 보안의 위험 있어 상대경로를 쓰거나 이미지 불러오는 jsp 또는 클래스 파일을 만들어 가져오는 식으로 우회해야 함
		// 때문에 savePath와 별개로 상대 경로인 uploadPath 만들어줌
		String uploadPath = "/sns/getTempUpload.do?saveName=" + newFileName;

		
		// 저장 경로로 파일 객체 생성
		Path path = Paths.get(tempSavePath + File.separator + newFileName).toAbsolutePath();

		File file = new File(tempSavePath, newFileName);
		// 파일 업로드
		try {
			multi.transferTo(file);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		map.put("uploaded", true);
		map.put("url", uploadPath);

		return map;
	}
	
	/*
	 * 임시 사진 다운로드
	 */
	@RequestMapping(value = "/sns/getTempUpload.do", method = RequestMethod.GET)
	public void tempFileDownload (String saveName, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// FIXME IO예외 등등 눈에 보이는 예외 처리하기
		// globals.properties
		File file = new File(tempSavePath, saveName);
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

		//User-Agent : 어떤 운영체제로  어떤 브라우저를 서버( 홈페이지 )에 접근하는지 확인함
		String header = request.getHeader("User-Agent");
		String fileName;

		if ((header.contains("MSIE")) || (header.contains("Trident")) || (header.contains("Edge"))) {
		//인터넷 익스플로러 10이하 버전, 11버전, 엣지에서 인코딩 
			fileName = URLEncoder.encode(saveName, "UTF-8");
		} else {
		    //나머지 브라우저에서 인코딩
		    fileName = new String(saveName.getBytes("UTF-8"), "iso-8859-1");
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
	 * 사진 다운로드
	 */
	@RequestMapping(value = "/sns/getUpload.do", method = RequestMethod.GET)
	public void fileDownload (String saveName, HttpServletRequest request, HttpServletResponse response) throws Exception {
		// FIXME IO예외 등등 눈에 보이는 예외 처리하기
		// globals.properties
		File file = new File(savePath, saveName);
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));

		//User-Agent : 어떤 운영체제로  어떤 브라우저를 서버( 홈페이지 )에 접근하는지 확인함
		String header = request.getHeader("User-Agent");
		String fileName;

		if ((header.contains("MSIE")) || (header.contains("Trident")) || (header.contains("Edge"))) {
		//인터넷 익스플로러 10이하 버전, 11버전, 엣지에서 인코딩 
			fileName = URLEncoder.encode(saveName, "UTF-8");
		} else {
		    //나머지 브라우저에서 인코딩
		    fileName = new String(saveName.getBytes("UTF-8"), "iso-8859-1");
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
	 * sns 글 등록
	 */
	@PostMapping(value = "/sns/insSnsPost.do")
	@ResponseBody
	public Map<String, Object> insBoardPost(@RequestBody BoardVO boardVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 작성자(세션 회원 번호), 일반글 set
		boardVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		boardVO.setType("normal");
		
		// 비회원이면 로그인하라고 돌려보내기
		if (boardVO.getMember_no() == 0) {
			map.put("result", "로그인");
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		
		// 진짜 업로드될 파일을 골라내서, 업로드 폴더로 복사 및 임시업로드폴더 정리
		List<String> fileNameList = getFileNameList(boardVO.getContent(), "temp");
		if (fileNameList != null && fileNameList.size() > 0) {
			convertTempuploadToUpload(fileNameList);
		}
		
		// 임시 업로드url을 진짜 업로드url로 바꿈.
		boardVO.setContent(boardVO.getContent().replaceAll("/sns/getTempUpload.do", "/sns/getUpload.do"));
		map = snsService.insSnsPost(boardVO);
		
		return map;
	}
	
	// content 안에 이미지 파일이름 골라낸 리스트 반환
	public List<String> getFileNameList(String content, String target) {
		List<String> list = new ArrayList<>();
		
		String startWord = "";
		String endWord = "\">";
		
		// 골라낼 파일이름 유형을 분기(임시, 기존)
		if ("temp".equals(target)) {
			startWord = "<img src=\"/sns/getTempUpload.do?saveName=";
		} else if ("existing".equals(target)) {
			startWord = "<img src=\"/sns/getUpload.do?saveName=";
		}
		
		int startIndex = 0;
		int endIndex = 0;
		
		while(true) {
			startIndex = content.indexOf(startWord, startIndex);
			if (startIndex == -1) {
				break;
			}
			
			endIndex = content.indexOf(endWord, startIndex + startWord.length());
			list.add(content.substring(startIndex + startWord.length(), endIndex));
			startIndex = endIndex;
		}
		
		return list;
	}
	
	// 정말 업로드할 임시업로드 파일들을 업로드폴더로 옮기고 정리.
	public void convertTempuploadToUpload(List<String> fileNameList) {
		for (String fileName : fileNameList) {
	        //파일객체생성
	        File oriFile = new File(tempSavePath, fileName);
	        //복사파일객체생성
	        File copyFile = new File(savePath, fileName);
	        
	        try {
	            BufferedInputStream in = new BufferedInputStream(new FileInputStream(oriFile));			//읽을파일
	            BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(copyFile));	//복사할파일
	            
	            int fileByte = 0; 
	            // fis.read()가 -1 이면 파일을 다 읽은것
	            while((fileByte = in.read()) != -1) {
	            	out.write(fileByte);
	            }
	            //자원사용종료
	            in.close();
	            out.close();
	            
	        } catch (FileNotFoundException e) {
	            // TODO Auto-generated catch block
	            e.printStackTrace();
	        } catch (IOException e) {
	            // TODO Auto-generated catch block
	            e.printStackTrace();
	        }
		}
		
		File tempDir = new File(tempSavePath);
		if (tempDir.exists()) {
			File[] tempDirList = tempDir.listFiles();
			
			for (int i = 0; i < tempDirList.length; i++) {
				tempDirList[i].delete();
			}
		}
		tempDir.delete();
		tempDir.mkdir();
	}
	
	
	
	/*
	 * sns 글(단건) 가져오기
	 */
	@PostMapping("/sns/getSnsPost.do")
	public String snsPost(BoardVO boardVO, Model model) {
		
		List<BoardVO> list = new ArrayList<>();
		boardVO = snsService.getSnsPost(boardVO);
		list.add(boardVO);
		
		model.addAttribute("snsPostList", list);
		return "noTiles:views/sns/snsPost";
	}
	
	/*
	 * 좋아요 등록수정
	 */
	@RequestMapping(value = "/sns/updLike.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updLike(LikeVO likeVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		likeVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		// 비회원이면 로그인하라고 돌려보내기
		if (likeVO.getMember_no() == 0) {
			map.put("result", "로그인");
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		
		try {
			// 좋아요 이력 등록 후, 계산되어 나온 업데이트값을 게시글 LIKE_CNT에 반영
			likeVO = galleryService.insLikeLog(likeVO);
			galleryService.updBoardLikeCnt(likeVO);
			map.put("result", "성공");
			map.put("update_amount", likeVO.getUpdate_amount());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * sns 글 삭제
	 */
	@RequestMapping(value = "/sns/delSnsPost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delSnsPost(BoardVO boardVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		// 작성자가 아니거나 운영진이 아니면 돌려보내기
		if (boardVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "작성자");
			map.put("msg", "본인만 삭제할 수 있습니다.");
			return map;
		}
		
		// 기존 snsPost의 파일명들을 골라낸다.
		BoardVO existingSnsPost = snsService.getSnsPost(boardVO);
		List<String> fileNameList = getFileNameList(existingSnsPost.getContent(), "existing");
		
		// 삭제할 파일 정보 목록
		List<FilesVO> beDeletedFileList = new ArrayList<>();
		if (fileNameList != null && fileNameList.size() > 0) {
			for (String fileName : fileNameList) {
				
				FilesVO files = new FilesVO();
				files.setBoard_no(boardVO.getBoard_no());
				files.setSave_name(fileName);
				files.setPath(savePath);
				
				beDeletedFileList.add(files);
			}
		}
		
		
		String result = snsService.delSnsPost(boardVO, beDeletedFileList);
		if ("성공".equals(result)) {
			map.put("result", "성공");
			map.put("msg", "글 삭제에 성공했습니다.");
		} else if("실패".equals(result)) {
			map.put("result", "실패");
			map.put("msg", "글 삭제에 실패했습니다.");
		}
		
		return map;
	}
	
	/*
	 * sns 글 수정
	 */
	@RequestMapping(value = "/sns/updSnsPost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updSnsPost(@RequestBody BoardVO boardVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		// 작성자가 아니거나 운영진이 아니면 돌려보내기
		if (boardVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "작성자");
			map.put("msg", "본인만 수정할 수 있습니다.");
			return map;
		}
		
		
		// 진짜 업로드될 파일을 골라내서, 업로드 폴더로 복사 및 임시업로드폴더 정리
		List<String> fileNameList = getFileNameList(boardVO.getContent(), "temp");
		if (fileNameList != null && fileNameList.size() > 0) {
			convertTempuploadToUpload(fileNameList);
		}
		
		// 기존 snsPost와 기존 snsPost에 존재하는 파일이름목록
		BoardVO existingSnsPost = snsService.getSnsPost(boardVO);
		fileNameList = getFileNameList(existingSnsPost.getContent(), "existing");
		
		// 삭제된 파일 정보 목록
		List<FilesVO> deletedFileList = new ArrayList<>();
		if (fileNameList != null && fileNameList.size() > 0) {
			for (String fileName : fileNameList) {
				
				if (boardVO.getContent().indexOf(fileName) != -1) {
					FilesVO files = new FilesVO();
					files.setBoard_no(boardVO.getBoard_no());
					files.setSave_name(fileName);
					files.setPath(savePath);
					
					deletedFileList.add(files);
				}
			}
		}
		
		// 임시 업로드url을 진짜 업로드url로 바꿈.
		boardVO.setContent(boardVO.getContent().replaceAll("/sns/getTempUpload.do", "/sns/getUpload.do"));
		
		String result = snsService.updSnsPost(boardVO, deletedFileList);
		if ("성공".equals(result)) {
			map.put("result", "성공");
			map.put("msg", "글 수정에 성공했습니다.");
		} else if("실패".equals(result)) {
			map.put("result", "실패");
			map.put("msg", "글 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	
	/*
	 * sns 댓글목록 가져오기
	 */
	@PostMapping("/sns/getSnsCommentsList.do")
	public String getSnsCommentsList(BoardVO boardVO, Model model) {
		List<CommentsVO> commentsList = snsService.getSnsCommentsList(boardVO);
		model.addAttribute("commentsList", commentsList);
		return "noTiles:views/sns/snsComments";
	}
	
	/*
	 * sns 댓글 등록
	 */
	@RequestMapping(value = "/sns/insSnsComments.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insSnsComments(CommentsVO commentsVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		commentsVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		// 비회원이면 로그인하라고 돌려보내기
		if (commentsVO.getMember_no() == 0) {
			map.put("result", "로그인");
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		System.out.println("content =" + commentsVO.getContent());
		String result = snsService.insSnsComments(commentsVO);
		
		if ("성공".equals(result)) {
			map.put("result", "성공");
			map.put("msg", "글 수정에 성공했습니다.");
		} else if("실패".equals(result)) {
			map.put("result", "실패");
			map.put("msg", "글 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	/*
	 * sns 댓글 수정
	 */
	@RequestMapping(value = "/sns/updSnsComments.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updSnsComments(CommentsVO commentsVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		commentsVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		// 작성자가 아니거나 운영진이 아니면 돌려보내기
		if (commentsVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "작성자");
			map.put("msg", "본인만 수정할 수 있습니다.");
			return map;
		}
		
		String result = snsService.updSnsComments(commentsVO);
		
		if ("성공".equals(result)) {
			map.put("result", "성공");
			map.put("msg", "댓글 수정에 성공했습니다.");
		} else if("실패".equals(result)) {
			map.put("result", "실패");
			map.put("msg", "댓글 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	
	/*
	 * sns 댓글 수정
	 */
	@RequestMapping(value = "/sns/delSnsComments.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delSnsComments(CommentsVO commentsVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		commentsVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		// 작성자가 아니거나 운영진이 아니면 돌려보내기
		if (commentsVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", "작성자");
			map.put("msg", "본인만 삭제할 수 있습니다.");
			return map;
		}
		
		String result = snsService.delSnsComments(commentsVO);
		
		if ("성공".equals(result)) {
			map.put("result", "성공");
			map.put("msg", "댓글 수정에 성공했습니다.");
		} else if("실패".equals(result)) {
			map.put("result", "실패");
			map.put("msg", "댓글 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	/*
	 * 검색어 특수문자 검증
	 */
	@RequestMapping(value = "/sns/snsSearchValidate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> snsSearchValidate(SearchVO searchVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		// 특수문자 및 중간공백 체크
		String pattern = "^[0-9|a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]*$";
		if(!Pattern.matches(pattern, searchVO.getSrchText())){
			map.put("result", "공백특수문자");
			map.put("msg", "검색어에는 공백 혹은 특수문자 입력이 제한되어있습니다.");
			return map;
		} else {
			map.put("result", "성공");
			map.put("msg", "댓글 수정에 성공했습니다.");
		}
		
		return map;
	}
}
