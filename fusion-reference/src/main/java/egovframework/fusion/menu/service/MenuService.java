package egovframework.fusion.menu.service;

import java.util.List;

import egovframework.fusion.aop.vo.AccessLogVO;
import egovframework.fusion.menu.vo.DayVO;
import egovframework.fusion.menu.vo.HourVO;
import egovframework.fusion.menu.vo.MenuNAuthorVO;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.menu.vo.MonthVO;
import egovframework.fusion.menu.vo.YearVO;

public interface MenuService {
	// 메뉴 목록 가져오기
	List<MenuVO> getMenuList();
	
	// 메뉴명, 메뉴url(menu_type) 중복 체크
	String checkMenuDuplicate(MenuVO menuVO);
	
	// 메뉴 등록
	String insMenu(MenuVO menuVO);
	
	// 메뉴 권한들 수정
	String updMenuAuthor(MenuVO menuVO);
	
	// 메뉴 삭제
	String delMenu(MenuVO menuVO);
	
	// 화면 HEADER에 필요한 메뉴 정보 목록
	List<MenuVO> getHeaderMenuList(Integer author_no);
	
	// Interceptor에서 메뉴 접근 시 권한 체크할 때 사용
	List<MenuVO> isHasAuthToMenu(MenuNAuthorVO menuNAuthorVO);
	
	// 최근 3년간 연도별 통계
	List<YearVO> getYearStatistics();
	
	// 해당 연도의 월별 통계
	List<MonthVO> getMonthStatistics(AccessLogVO accessLogVO);
	
	// 해당 연도 월의 일별 통계
	List<DayVO> getDayStatistics(AccessLogVO accessLogVO);
	
	// 해당 연도 월 일의 시간대별 통계
	List<HourVO> getHourStatistics(AccessLogVO accessLogVO);
}
