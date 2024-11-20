package egovframework.fusion.menu.controller;

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

import egovframework.fusion.author.service.AuthorService;
import egovframework.fusion.author.vo.AuthorVO;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.MenuVO;

@Controller
public class MenuController {

	@Autowired
	MenuService menuService;
	
	@Autowired
	AuthorService authorService;
	
	// 메뉴 목록 가져오기
	@GetMapping("/menu/menuList.do")
	public String menuList(String menuType, Model model) {
		List<MenuVO> menuList = menuService.getMenuList();						// 메뉴 정보 목록
		List<AuthorVO> authorList = authorService.getAuthorList();				// 권한 목록
		
		model.addAttribute("menuList", menuList);
		model.addAttribute("authorList", authorList);
		model.addAttribute("menuType", menuType);
		return "views/menu/menuList";
	}
	
	// 메뉴 등록 전 메뉴명 중복검사, 메뉴 url(menu_type) 특수문자,공백,중복검사 
	@PostMapping("menu/checkMenuDuplicate.do")
	@ResponseBody
	public Map<String, Object> checkMenuDuplicate(MenuVO menuVO) {
		Map<String, Object> map = new HashMap<>();

		// 특수문자 및 중간공백 체크
		String pattern = "^[0-9|a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]*$";
		if(!Pattern.matches(pattern, menuVO.getMenu_type())){
			map.put("result", "공백특수문자");
			map.put("msg", "url에는 공백 혹은 특수문자 입력이 제한되어있습니다.");
			return map;
		}

		String result = "";
		result = menuService.checkMenuDuplicate(menuVO);
		
		if ("성공".equals(result)) {
			map.put("result", result); 
		} else if (result.equals("메뉴명")) {
			map.put("result", result); 
			map.put("msg", "이미 존재하는 메뉴명입니다.");
		} else if (result.equals("메뉴url")) {
			map.put("result", result); 
			map.put("msg", "이미 존재하는 메뉴url입니다.");
		} else if (result.equals("실패")) {
			map.put("result", result); 
			map.put("msg", "메뉴 정보 검증에 실패했습니다.");
		}
		
		return map;
	}
	
	// 메뉴 등록
	@PostMapping("/menu/insMenu.do")
	@ResponseBody
	public Map<String, Object> insMenu(MenuVO menuVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = "";
		result = menuService.insMenu(menuVO);
		
		if (result.equals("성공")) {
			map.put("result", result); 
			map.put("msg", "메뉴가 정상적으로 등록되었습니다."); 
		} else if (result.equals("실패")) {
			map.put("result", result); 
			map.put("msg", "메뉴 등록에 실패했습니다.");
		}
		
		return map;
	}
	
	// 메뉴 접근 가능 권한 수정
	@PostMapping("/menu/updMenuAuthor.do")
	@ResponseBody
	public Map<String, Object> updMenuAuthor(MenuVO menuVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = "";
		result = menuService.updMenuAuthor(menuVO);
		
		if (result.equals("성공")) {
			map.put("result", result); 
			map.put("msg", "접근 가능 권한이 정상적으로 등록되었습니다."); 
		} else if (result.equals("실패")) {
			map.put("result", result); 
			map.put("msg", "접근 가능 권한 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	// 메뉴 삭제
	@PostMapping("/menu/delMenu.do")
	@ResponseBody
	public Map<String, Object> delMenu(MenuVO menuVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = "";
		result = menuService.delMenu(menuVO);
		
		if (result.equals("성공")) {
			map.put("result", result); 
			map.put("msg", "메뉴가 정상적으로 삭제되었습니다."); 
		} else if (result.equals("실패")) {
			map.put("result", result); 
			map.put("msg", "메뉴 삭제에 실패했습니다.");
		}
		
		return map;
	}
	
	@GetMapping("/menu/statistics.do")
	public String statistics(String menuType, Model model) {
		model.addAttribute("menuType", menuType);
		return "views/menu/statistics";
	}
}
