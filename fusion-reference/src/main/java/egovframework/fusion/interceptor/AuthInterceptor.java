package egovframework.fusion.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.MenuNAuthorVO;
import egovframework.fusion.menu.vo.MenuVO;

public class AuthInterceptor implements HandlerInterceptor {
	@Autowired
	MenuService menuService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		
		if (session.getAttribute("author_no") == null) {
			session.setAttribute("member_no", 0);
			session.setAttribute("author_no", 6);
		}
		
		// 그냥 통과시킬 화이트리스트(insert, update, delete, get(설문조사임시답변))
		String uri = request.getRequestURI();
		String uriMiddleSection = uri.substring(uri.indexOf("/"), uri.lastIndexOf("."));
		
		if (uriMiddleSection.indexOf("ins") != -1 || uriMiddleSection.indexOf("upd") != -1 ||
				uriMiddleSection.indexOf("del") != -1 || uriMiddleSection.indexOf("get") != -1) {
			return true;
		}
			
		// 세션이 가지고 있는 권한이 접근 가능한 메뉴 정보들
		List<MenuVO> headerMenuList = menuService.getHeaderMenuList((Integer) session.getAttribute("author_no"));
		request.setAttribute("headerMenuList", headerMenuList);
		
		MenuNAuthorVO menuNAuthorVO = new MenuNAuthorVO();
		menuNAuthorVO.setAuthor_no((Integer) session.getAttribute("author_no"));
		menuNAuthorVO.setMenu_type(request.getParameter("menuType"));
		request.setAttribute("menuType", request.getParameter("menuType"));
		
		
		// 파라미터 menuType(접근하려는 메뉴)에 접근가능한 권한들 중에 해당 권한이 있는지
		Integer isHasAuth = menuService.isHasAuthToMenu(menuNAuthorVO).size();
		
		// 접근하려는 메뉴의 접근가능한 권한들 중에 해당 권한이 없으면 로그인 페이지로
		if (isHasAuth < 1) {
			response.sendRedirect("/member/loginForm.do");
			return false;
		}
		
		System.out.println("hotFix 수정1");
		
		return true;
		
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
	}
	
}
