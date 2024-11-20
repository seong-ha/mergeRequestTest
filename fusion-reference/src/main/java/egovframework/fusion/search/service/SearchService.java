package egovframework.fusion.search.service;

import java.util.List;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.menu.vo.MenuVO;

public interface SearchService {
	List integratedSearchList(SearchVO searchVO, List<MenuVO> headerMenuList);
	
	List integratedSearchListByType(SearchVO searchVO);
}
