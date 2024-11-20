package egovframework.fusion.commCd.service;

import java.util.List;
import java.util.Map;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.commCd.vo.CommCdVO;

public interface CommCdService {
	// 그룹코드(대분류) 목록 가져오기
	List<CommCdVO> getGroupCdList(SearchVO searchVO);
	
	// 상세코드(소분류) 목록 가져오기
	List<CommCdVO> getDetailCdList(CommCdVO commCdVO);
	
	// 코드 중복 여부 체크
	String getIsDuplicate(CommCdVO commCdVO);
	
	// 공통 코드 등록
	String insCommCd(CommCdVO commCdVO);
	
	// 공통 코드 수정
	String updCommCd(CommCdVO commCdVO);
	
	// 대분류 안에 소분류가 존재하는 지 확인
	Map<String, Object> getHasDetailCd(List<Integer> list);
	
	// 공통코드 목록 삭제
	String delCommCdList(List<Integer> list);
	
	// 그룹 및 상세코드 가져오기
	List<CommCdVO> getGroupDetailCdList(SearchVO searchVO);
	
	// 그룹코드 code로 상세코드목록 가져오기
	List<CommCdVO> getDetailCdListWithCode(String code);
}
