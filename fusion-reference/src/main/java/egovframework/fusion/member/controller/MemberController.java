package egovframework.fusion.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.fusion.commCd.service.CommCdService;
import egovframework.fusion.commCd.vo.CommCdVO;
import egovframework.fusion.member.service.MemberService;
import egovframework.fusion.member.vo.MemberVO;

@Controller
public class MemberController {

	@Autowired
	MemberService memberService;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	CommCdService commCdService;
	
	// 세션 체크 후 로그아웃 시키기(ajax 시)
	public Map<String, Object> checkSession() {
		if (request.getSession().getAttribute("member_no") == null || Integer.valueOf(request.getSession().getAttribute("member_no").toString()) == 0) {
			Map<String, Object> map = new HashMap<>();
			request.getSession().invalidate();
			
			map.put("result", "세션 만료");
			map.put("msg", "세션 만료로 로그아웃되었습니다. 로그인 후 이용해주세요.");
			return map;
		};
		
		return null;
	}
	
	// 세션 체크 후 로그아웃 시키기(페이지 리턴 시)
	public String checkSession(Model model) {
		if (request.getSession().getAttribute("member_no") == null || Integer.valueOf(request.getSession().getAttribute("member_no").toString()) == 0) {
			request.getSession().invalidate();
			model.addAttribute("msg","로그인 후 이용해주세요.");
			return "noTiles:views/member/loginForm";
		};
		
		return null;
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
	 * 로그인 화면 출력
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@RequestMapping(value = "/member/loginForm.do", method = RequestMethod.GET)
	public String loginForm() {
		return "noTiles:views/member/loginForm";
	}
	
	/*
	 * 로그인
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@PostMapping(value = "/member/login.do")
	@ResponseBody
	public Map<String, Object> login(@RequestBody MemberVO memberVO) {
		Map<String, Object> loginResult = null;
		try {
			loginResult = memberService.login(memberVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		 
		return loginResult;
	}
	
	/*
	 * 회원가입 화면 출력
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@GetMapping(value = "/member/joinForm.do")
	public String joinForm(Model model) {
		List<CommCdVO> commCdList = commCdService.getDetailCdListWithCode("H");
		model.addAttribute("commCdList", commCdList);
		return "noTiles:views/member/joinForm";
	}
	
	/*
	 * 아이디 중복체크
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@PostMapping(value = "/member/idCheck.do")
	@ResponseBody
	public Map<String, Object> idCheck(MemberVO memberVO) {
		Map<String, Object> map = null;
		try {
			map = memberService.idCheck(memberVO);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return map;
	}
	
	/*
	 * 회원가입
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@PostMapping(value = "/member/join.do")
	@ResponseBody
	public Map<String, Object> join(@RequestBody MemberVO memberVO) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			// 가입 전 한번 더 아이디 중복체크
			Map<String, Object> idCheckMap  = memberService.idCheck(memberVO);
			if (((int)idCheckMap.get("result")) == 0) {
				map = memberService.join(memberVO);
			} else if (((int)idCheckMap.get("result")) == 1) {
				map.put("result", 1);
				map.put("msg", "이미 사용 중인 아이디입니다.");
			}
		} catch (Exception e) {
			map.put("result", 1);
			map.put("msg", "오류가 발생했습니다.");
		}
		return map;
	}
	
	/*
	 * 로그아웃
	 * @param	
	 * @return	
	 * @exception Exception
	 */
	@GetMapping(value = "/member/logout.do")
	@ResponseBody
	public Map<String, Object> logout() {
		Map<String, Object> map = null;
		try {
			map = memberService.logout();
		} catch (Exception e) {
			// TODO: handle exception
		}
		return map;
	}
}
