package egovframework.fusion.aop;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.fusion.aop.service.AccessLogMapper;
import egovframework.fusion.aop.vo.AccessLogVO;
import egovframework.fusion.board.vo.SearchVO;

@Aspect
@Component
public class LogAdvice {
	@Autowired
	AccessLogMapper dao;
	
	@AfterReturning("execution(* egovframework.fusion.*.service.*.getBoardList(egovframework.fusion.board.vo.SearchVO)) && args(searchVO)")
	public void logBefore(SearchVO searchVO) {
		//메뉴 선택으로 인한(=페이징 선택이 아닌) 접근이 아니라면 접근 기록 X
		if (!searchVO.getNoPageChoose()) {
			return;
		}
		
		AccessLogVO accessLogVO = new AccessLogVO();
		
		// 메뉴타입
		accessLogVO.setMenu_type(searchVO.getMenuType());
		
		// 회원번호
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		if (request.getSession().getAttribute("member_no") != null) {
			accessLogVO.setMember_no(Integer.valueOf(request.getSession().getAttribute("member_no").toString()));
		} else {
			accessLogVO.setMember_no(0);
		}
		
		dao.insertAccessLog(accessLogVO);
		
		System.out.println("featA 수정1");
		System.out.println("featA 수정2");
		System.out.println("featB 수정1");
		System.out.println("featB 수정2");
		System.out.println("featC 수정1");
		System.out.println("featC 수정2");
		
		System.out.println("last1 수정1");
	}
}
