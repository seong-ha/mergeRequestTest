package egovframework.fusion.search.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.search.service.SearchService;

@Controller
public class SearchController {

	@Autowired
	SearchService searchService;
	
	@Autowired
	MenuService menuService;
	
	@PostMapping("/search/validateSearch.do")
	@ResponseBody
	public Map<String, Object> validateSearch(SearchVO searchVO) {
		Map<String, Object> map = new HashMap<>();
		
		// 특수문자 및 중간공백 체크
		String pattern = "^[0-9|a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]*$";
		if(!Pattern.matches(pattern, searchVO.getSrchText())){
			map.put("result", "공백특수문자");
			map.put("msg", "공백 혹은 특수문자 입력이 제한되어있습니다.");
		} else {
			map.put("result", "성공");
		}
		
		return map;
	}
	
	@GetMapping("/search/integratedSeach.do")
	public String integratedSearch(SearchVO searchVO, Model model) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		List<MenuVO> headerMenuList = menuService.getHeaderMenuList((Integer) request.getSession().getAttribute("author_no"));
		List integSrchList = searchService.integratedSearchList(searchVO, headerMenuList);
		
		model.addAttribute("integSrchList", integSrchList);
		model.addAttribute("headerMenuList", headerMenuList);
		model.addAttribute("integSearch", searchVO);
		
		return "views/search/searchList";
	}
	
	
	@GetMapping("/search/integratedSeachPost.do")
	public String integratedSeachPost(SearchVO searchVO, Model model) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		List<MenuVO> headerMenuList = menuService.getHeaderMenuList((Integer) request.getSession().getAttribute("author_no"));
		List list = searchService.integratedSearchListByType(searchVO);
		
		model.addAttribute("integSrchListByType", list);
		model.addAttribute("headerMenuList", headerMenuList);
		model.addAttribute("integSearch", searchVO);
		
		return "views/search/searchListByType";
	}
	
	
}
