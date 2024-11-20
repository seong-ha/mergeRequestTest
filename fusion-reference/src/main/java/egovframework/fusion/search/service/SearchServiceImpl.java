package egovframework.fusion.search.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.board.service.BoardMapper;
import egovframework.fusion.board.vo.BoardVO;
import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.menu.service.MenuMapper;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.survey.service.SurveyMapper;
import egovframework.fusion.survey.vo.SurveyVO;

@Service
public class SearchServiceImpl implements SearchService {

	@Autowired
	MenuMapper menuMapper;
	
	@Autowired
	BoardMapper boardMapper;
	
	@Autowired
	SurveyMapper surveyMapper;
	
	@Override
	public List integratedSearchList(SearchVO searchVO, List<MenuVO> headerMenuList) {
		List list = new ArrayList();
		
		try {
			// menuList에서 하나씩 꺼내서
			if (headerMenuList != null && headerMenuList.size() > 0) {
				// 메뉴 형태에 따라 분기해서 쿼리 받아와서 list에 추가
				for (MenuVO menuVO : headerMenuList) {
					if ("board".equals(menuVO.getMenu_form())) {
						searchVO.setMenuType(menuVO.getMenu_type());
						List<BoardVO> boardList = boardMapper.selectIntegSrchBoardList(searchVO);	// board 해당 검색어로 board찾아내는 쿼리 만들기
						if (boardList != null && boardList.size() > 0) {
							list.add(boardList);
						}
					} else if ("gallery".equals(menuVO.getMenu_form())) {
						searchVO.setMenuType(menuVO.getMenu_type());
						List<BoardVO> galleryList = boardMapper.selectIntegSrchBoardList(searchVO);	// board 해당 검색어로 board찾아내는 쿼리 만들기
						if (galleryList != null && galleryList.size() > 0) {
							list.add(galleryList);
						}
					} else if ("survey".equals(menuVO.getMenu_form())) {
						searchVO.setMenuType(menuVO.getMenu_type());
						List<SurveyVO> surveyList = surveyMapper.selectIntegSrchSurveyList(searchVO);	// board 해당 검색어로 board찾아내는 쿼리 만들기
						if (surveyList != null && surveyList.size() > 0) {
							list.add(surveyList);
						}
					}
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			
		}
		
		return list;
	}

	@Override
	public List integratedSearchListByType(SearchVO searchVO) {
		List list = new ArrayList();
		
		if ("board".equals(searchVO.getMenuForm())) {
			List<BoardVO> boardList = boardMapper.selectIntegSrchBoardList(searchVO);
			if (boardList != null && boardList.size() > 0) {
				list = boardList;
			}
		} else if ("gallery".equals(searchVO.getMenuForm())) {
			List<BoardVO> galleryList = boardMapper.selectIntegSrchBoardList(searchVO);
			if (galleryList != null && galleryList.size() > 0) {
				list = galleryList;
			}
		} else if ("survey".equals(searchVO.getMenuForm())) {
			List<SurveyVO> surveyList = surveyMapper.selectIntegSrchSurveyList(searchVO);
			if (surveyList != null && surveyList.size() > 0) {
				list = surveyList;
			}
		}
		
		return list;
	}

}
