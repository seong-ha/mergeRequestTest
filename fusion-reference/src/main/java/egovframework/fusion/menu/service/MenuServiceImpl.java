package egovframework.fusion.menu.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.fusion.aop.vo.AccessLogVO;
import egovframework.fusion.menu.vo.DayVO;
import egovframework.fusion.menu.vo.HourVO;
import egovframework.fusion.menu.vo.MenuNAuthorVO;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.menu.vo.MonthVO;
import egovframework.fusion.menu.vo.YearVO;

@Service
public class MenuServiceImpl implements MenuService {

	@Autowired
	private MenuMapper dao;
	
	@Override
	public List<MenuVO> getMenuList() {
		return dao.selectMenuList();
	}
	
	@Override
	public String checkMenuDuplicate(MenuVO menuVO) {
		String result = "";
		Integer findCnt = 0;
		try {
			findCnt = dao.selectDuplicateMenuName(menuVO);
			if (findCnt != 0) {
				return "메뉴명";
			}
			findCnt = dao.selectDuplicateMenuType(menuVO);
			if (findCnt != 0) {
				return "메뉴url";
			}
			result = "성공";
		} catch (Exception e) {
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}
	
	@Override
	public String insMenu(MenuVO menuVO) {
		//슈퍼관리자는 항상 넣는다.
		menuVO.getAuthorList().add(1);
		
		String result = "";
		try {
			dao.insertMenu(menuVO);
			result = "성공";
		} catch (Exception e) {
			e.printStackTrace();
			result = "실패";
		}
		
		return result; 
	}
	

	@Override
	@Transactional
	public String updMenuAuthor(MenuVO menuVO) {
		MenuVO toAdd = new MenuVO();		// 해당 메뉴에 대한 접근을 추가할 권한들을 담을 메뉴vo
		MenuVO toRemove = new MenuVO();	    // 해당 메뉴에 대한 접근을 삭제할 권한들을 담을 메뉴vo
		toAdd.setAuthorList(new ArrayList<Integer>());
		toRemove.setAuthorList(new ArrayList<Integer>());
		// 해당 메뉴 번호 입력
		toAdd.setMenu_no(menuVO.getMenu_no());
		toRemove.setMenu_no(menuVO.getMenu_no());
		
		menuVO.getAuthorList().add(1);	// 슈퍼관리자는 무조건 존재.
		
		// 해당 메뉴의 권한번호들
		List<Integer> menuAuthorList = dao.selectMenuAuthorList(menuVO);
		
		// 새로운 접근권한리스트와 기존 접근권한리스트를 비교하여 같은부분은 0으로 만듦(같은 부분은 놔둔다.
		for (int i = 0; i < menuVO.getAuthorList().size(); i++) {
			for (int j = 0; j < menuAuthorList.size(); j++) {
				if (menuVO.getAuthorList().get(i) == menuAuthorList.get(j)) {
					menuVO.getAuthorList().set(i, 0);
					menuAuthorList.set(j, 0);
				}
			}
		}
		
		// 새로운 권한리스트에 0이 아닌 권한번호는 새로 추가할 권한
		for (int newAuthorNo : menuVO.getAuthorList()) {
			if (newAuthorNo != 0) {
				toAdd.getAuthorList().add(newAuthorNo);
			}
		}
		// 기존 권한스트에 0이 아닌 권한번호는 삭제할 권한 
		for (int existingAuthorNo : menuAuthorList) {
			if (existingAuthorNo != 0) {
				toRemove.getAuthorList().add(existingAuthorNo);
			}
		}
		
		String result = "";
		
		try {
			// 추가/삭제할거 있으면 추가/삭제
			if (toAdd.getAuthorList() != null && toAdd.getAuthorList().size() > 0) {
				dao.insertMenuAuthor(toAdd);
			}
			if (toRemove.getAuthorList()!= null && toRemove.getAuthorList().size() > 0) {
				dao.deleteMenuAuthor(toRemove);
			}
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		
		return result;
	}
	
	@Override
	@Transactional
	public String delMenu(MenuVO menuVO) {
		String result = "";
		try {
			dao.deleteMenuNAuthor(menuVO);
			dao.deleteMenu(menuVO);
			dao.deleteMenuBoard(menuVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}
	
	
	@Override
	public List<MenuVO> getHeaderMenuList(Integer author_no) {
		return dao.selectHeaderMenuList(author_no);
	}

	@Override
	public List<MenuVO> isHasAuthToMenu(MenuNAuthorVO menuNAuthorVO) {
		return dao.selectIsHasAuthToMenu(menuNAuthorVO);
	}
	
	@Override
	public List<YearVO> getYearStatistics() {
		LocalDate now = LocalDate.now();
		int year = now.getYear();
		String years = (year - 2) + " AS FIRST_YEAR, " + (year - 1) + " AS SECOND_YEAR, " + year + " AS THIRD_YEAR";
		return dao.selectYearStatistics(years);
	}

	@Override
	public List<MonthVO> getMonthStatistics(AccessLogVO accessLogVO) {
		return dao.selectMonthStatistics(accessLogVO);
	}

	@Override
	public List<DayVO> getDayStatistics(AccessLogVO accessLogVO) {
		return dao.selectDayStatistics(accessLogVO);
	}

	@Override
	public List<HourVO> getHourStatistics(AccessLogVO accessLogVO) {
		return dao.selectHourStatistics(accessLogVO);
	}

}
