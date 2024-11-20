/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
package egovframework.fusion.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.fusion.board.service.BoardService;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.CommentsVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.member.service.MemberService;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.paging.vo.PagingVO;



@Controller
public class BoardController {

	@Autowired
	BoardService boardService;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	MenuService menuService;
	
	String sessionResult = "";
	
	// 세션 체크 후 로그아웃 시키기
	public String checkSession(Model model) {
		if (Integer.valueOf(request.getSession().getAttribute("member_no").toString()) == 0) {
			memberService.logout();
			model.addAttribute("msg","로그인 후 이용해주세요.");
			return "views/member/loginForm";
		};
		
		return "";
	}
	
	// 세션의 member_no와 author 가져오기
	public Map<String, String> getSessionInfo() {
		Map<String, String> map = new HashMap<>();
		
		HttpSession session = request.getSession();
		String member_no = session.getAttribute("member_no").toString();
		String author = session.getAttribute("author").toString();
		
		map.put("member_no", member_no);
		map.put("author", author);
		
		return map;
	}
		
		
	/*
	 * 게시판 리스트 출력
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(String menuType, SearchVO searchVO, Model model) {

		// searchVO 초기값 생성
		if (searchVO.getNowPage() == null && searchVO.getCntPerPage() == null) {
			searchVO.setNoPageChoose(true);	// 페이징 선택 안했을 시(= 메뉴 첫접근 => 메뉴 접근 기록 추가)
			searchVO.setNowPage(1);
			searchVO.setCntPerPage(5);
		} else if (searchVO.getNowPage() == null) {
			searchVO.setNoPageChoose(true);	// 페이징 선택 안했을 시(= 메뉴 첫접근 => 메뉴 접근 기록 추가)
			searchVO.setNowPage(1);
		} else if (searchVO.getCntPerPage() == null) {
			searchVO.setNoPageChoose(false);// 페이징 선택 했을 시(= 메뉴 첫접근X => 메뉴 접근 기록 추가X)
			searchVO.setCntPerPage(5);
		}
		searchVO.setMenuType(menuType);
		
		
		try {
			List<BoardVO> noticeList = boardService.getNoticeList(searchVO);		// 공지사항글
			List<BoardVO> boardList = boardService.getBoardList(searchVO);	// 일반게시글
			BoardVO popupNotice = boardService.getPopupNotice(searchVO);			// 팝업용 최신 공지사항글
			
			// 페이징 객체 생성
			int total = 1;					// 아무 게시물도 없을 시
			if (boardList.size() != 0) {	// 게시물 존재 시
				total = boardList.get(0).getTotal();
			}
			
			PagingVO pagingVO = new PagingVO(total, searchVO.getNowPage(), searchVO.getCntPerPage());
			
			model.addAttribute("noticeList", noticeList);
			model.addAttribute("boardList", boardList);
			model.addAttribute("paging", pagingVO);
			model.addAttribute("search", searchVO);
			model.addAttribute("popup", popupNotice);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		// 어떤 게시판 불 밝힐지 내려줌.
		model.addAttribute("menuType", menuType);
		return "views/board/boardList";
	}
	
	/*
	 * 게시글 등록 페이지 이동
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardRegister.do", method = RequestMethod.GET)
	public String boardRegister(String menuType, BoardVO boardVO, Model model) {
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			return sessionResult;
		}
		
		// boardPost.jsp에서 답글을 위한 원글정보 파라미터를 넘겨 받았다면 같이 내려준다.  
		if (boardVO.getParent_no() != null) {
			model.addAttribute("boardReply", boardVO);
			model.addAttribute("menuType", boardVO.getMenu_type());
		} else {
			model.addAttribute("menuType", menuType);
		}
		
		return "noTiles:views/board/boardRegister";
	}
	
	/*
	 * 게시글 등록
	 * @param
	 * @return
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/insBoardPost.do", method = RequestMethod.POST)
	@ResponseBody
	public String insBoardPost(@RequestBody BoardVO boardVO, Model model) {
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			return "세션 만료";
		}
		
		String result = "알 수 없는 문제로 등록에 실패했습니다.";
		
		try {
			result = boardService.insBoardPost(boardVO);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	/*
	 * 게시글 단건(+ 댓글) 조회
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardPost.do", method = RequestMethod.GET)
	public String boardPost(String menuType, BoardVO boardVO, Model model) {
//		sessionResult = checkSession(model);
//		if (sessionResult != "") {
//			return "views/board/boardPost";
//		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		boardVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		try {
			// 조회 이력 체크 후 조회 수 올리기
			Integer chkResult = boardService.chkViewLog(boardVO);
			if (chkResult == null) {
				boardService.updBoardCnt(boardVO);
			}
			// 해당 게시물 가져오기
			BoardVO boardPost = boardService.getBoardPost(boardVO);
			// 해당 게시물 댓글 가져오기
			List<CommentsVO> commentsList = boardService.getCommentsList(boardVO);

			model.addAttribute("boardPost", boardPost);
			model.addAttribute("commentsList", commentsList);
			model.addAttribute("menuType", boardVO.getMenu_type());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return "noTiles:views/board/boardPost";
	}
	
	/*
	 * 게시글 수정 페이지 진입
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardPostModify.do", method = RequestMethod.GET)
	public String boardPostModify(String menuType, BoardVO boardVO, Model model) {
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			return "views/board/boardPostModify";
		}
		
		try {
			BoardVO boardPost = boardService.getBoardPost(boardVO);
			model.addAttribute("boardPost", boardPost);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("menuType", menuType);
		
		return "noTiles:views/board/boardPostModify";
	}
	
	/*
	 * 게시글 수정
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/updBoardPost.do", method = RequestMethod.POST)
	public String updBoardPost(String menuType, BoardVO boardVO, Model model) {
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			return "views/board/boardPost";
		}
		try {
			boardService.updBoardPost(boardVO);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		Integer member_no = (Integer) request.getSession().getAttribute("member_no");
		
		return "redirect:/board/boardPost.do?board_no=" + boardVO.getBoard_no() +
					"&member_no=" + member_no + "&menu_type=" + boardVO.getMenu_type() +
					"&menuType=" + menuType;
	}
	
	/*
	 * 게시글 삭제
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/delBoardPost.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBoardPost(@RequestBody BoardVO boardVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		/*
		 * System.out.println("★★★★★★★★"); System.out.println("★★★★★★★★");
		 * System.out.println(boardVO.getBoard_no());
		 * System.out.println(boardVO.getMember_no());
		 */
		
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			map.put("result", 2);
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 댓글 작성자와 현재 세션과 일치하지 않을 시 돌려보내기
		if (boardVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", 3);
			map.put("msg", "본인의 게시글만 삭제할 수 있습니다.");
			return map;
		}
		
		try {
			int result = boardService.delBoardPost(boardVO);;
			if (result == 0) {
				map.put("result", result);
				map.put("msg", "게시글 삭제에 실패했습니다.");
			} else if (result == 1) {
				map.put("result", result);
			}
		} catch(Exception e) {
			map.put("result", 0);
			map.put("msg", "게시글 삭제에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 댓글 등록
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/insComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insComment(CommentsVO commentsVO, String menuType, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			map.put("result", 2);
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 현재 세션의 회원번호를 넣어주기
		commentsVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		
		try {
			int result = boardService.insComment(commentsVO);
			if (result == 0) {
				map.put("result", result);
				map.put("msg", "댓글 등록에 실패했습니다.");
			} else if (result == 1) {
				map.put("result", result);
			}
		} catch(Exception e) {
			map.put("result", 0);
			map.put("msg", "댓글 등록에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 댓글 수정
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/updComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updComment(@RequestBody CommentsVO commentsVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			map.put("result", 2);
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 댓글 작성자와 현재 세션과 일치하지 않을 시 돌려보내기
		if (commentsVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", 3);
			map.put("msg", "본인의 댓글만 수정할 수 있습니다.");
			return map;
		}
		
		try {
			int result = boardService.updComment(commentsVO);
			if (result == 0) {
				map.put("result", result);
				map.put("msg", "댓글 수정에 실패했습니다.");
			} else if (result == 1) {
				map.put("result", result);
			}
		} catch(Exception e) {
			map.put("result", 0);
			map.put("msg", "댓글 수정에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 댓글 삭제
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/delComment.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delComment(@RequestBody CommentsVO commentsVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			map.put("result", 2);
			map.put("msg", "로그인 후 이용해주세요.");
			return map;
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 댓글 작성자와 현재 세션과 일치하지 않을 시 돌려보내기
		if (commentsVO.getMember_no() != (Integer) request.getSession().getAttribute("member_no")
				&& (Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", 3);
			map.put("msg", "본인의 댓글만 삭제할 수 있습니다.");
			return map;
		}
		
		try {
			int result = boardService.delComment(commentsVO);
			if (result == 0) {
				map.put("result", result);
				map.put("msg", "댓글 삭제에 실패했습니다.");
			} else if (result == 1) {
				map.put("result", result);
			}
		} catch(Exception e) {
			map.put("result", 0);
			map.put("msg", "댓글 삭제에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 체크된 게시물 다중 삭제
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/delChkBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delChkBoard(
					@RequestParam(value = "checkedList[]") List<Integer> checkedList,
					BoardVO boardVO, Model model) {
		
		Map<String, Object> map = new HashMap<>();
		
		sessionResult = checkSession(model);
		if (sessionResult != "") {
			map.put("result", 2);
			map.put("msg", "세션 만료로 로그아웃되었습니다. 로그인 후 이용해주세요.");
			return map;
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리진 아닐 시 삭제 불가
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("result", 3);
			map.put("msg", "관리자만 체크삭제를 할 수 있습니다.");
			return map;
		}
		
		try {
			int result = boardService.delChkBoard(checkedList);
			if (result == 0) {
				map.put("result", result);
				map.put("msg", "체크삭제에 실패했습니다.");
			} else if (result == 1) {
				map.put("result", result);
			}
		} catch(Exception e) {
			map.put("result", 0);
			map.put("msg", "체크삭제에 실패했습니다.");
			e.printStackTrace();
		}
		
		return map;
	}
}
