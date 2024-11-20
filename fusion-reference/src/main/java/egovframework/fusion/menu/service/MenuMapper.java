package egovframework.fusion.menu.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.aop.vo.AccessLogVO;
import egovframework.fusion.menu.vo.DayVO;
import egovframework.fusion.menu.vo.HourVO;
import egovframework.fusion.menu.vo.MenuNAuthorVO;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.menu.vo.MonthVO;
import egovframework.fusion.menu.vo.YearVO;

@Mapper
public interface MenuMapper {
	// 메뉴 관리용 메뉴리스트 + 그에 담긴 권한번호들(ResultMap menuManageList)
	List<MenuVO> selectMenuList();
	List<Integer> selectMenuAuthorList(MenuVO menuVO);
	
	// 메뉴명 중복 체크
	Integer selectDuplicateMenuName(MenuVO menuVO);
	
	// 메뉴 url 중복체크(menu_type)
	Integer selectDuplicateMenuType(MenuVO menuVO);
	
	// 메뉴 등록
	int insertMenu(MenuVO menuVO);
	
	// 메뉴의 접근 가능 권한 추가
	int insertMenuAuthor(MenuVO toAdd);
	
	// 메뉴의 접근 가능 권한 삭제
	int deleteMenuAuthor(MenuVO toRemove);
	
	// 메뉴 삭제 전에, 해당 메뉴에 해당하는 메뉴-권한 테이블 행들 삭제 
	int deleteMenuNAuthor(MenuVO menuVO);
	
	// 메뉴 삭제
	int deleteMenu(MenuVO menuVO);
	
	// 해당 메뉴에 있던 게시글들 삭제
	int deleteMenuBoard(MenuVO menuVO);

	// 화면 HEADER에 필요한 메뉴 정보 목록
	List<MenuVO> selectHeaderMenuList(Integer author_no);
	
	// 해당 메뉴에 대한 접근 권한 체크할 때 사용
	List<MenuVO> selectIsHasAuthToMenu(MenuNAuthorVO menuNAuthorVO);
	
	// 링크형 메뉴를 제외한 메뉴 정보
	List<MenuVO> selectMenuListNotLink();
	
	// 최근 3년간 연도별 메뉴 접근 통계
	List<YearVO> selectYearStatistics(String a);
	
	// 해당 연도의 월별 통계
	List<MonthVO> selectMonthStatistics(AccessLogVO accessLogVO);
	
	// 해당 연도 월의 일별 통계
	List<DayVO> selectDayStatistics(AccessLogVO accessLogVO);
	
	// 해당 연도 월 일의 시간대별 통계
	List<HourVO> selectHourStatistics(AccessLogVO accessLogVO);
}
