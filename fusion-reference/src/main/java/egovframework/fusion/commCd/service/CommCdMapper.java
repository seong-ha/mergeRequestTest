package egovframework.fusion.commCd.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.commCd.vo.CommCdVO;

@Mapper
public interface CommCdMapper {
	// 그룹코드(대분류) 목록 가져오기
	List<CommCdVO> selectGroupCdList(SearchVO searchVO);
	
	// 상세코드(소분류) 목록 가져오기
	List<CommCdVO> selectDetailCdList(CommCdVO commCdVO);
	
	// code가 같은 공통코드 조회
	CommCdVO selectCommCdWithCode(CommCdVO commCdVO);
	
	// 공통코드 등록
	int insertCommCd(CommCdVO commCdVO);
	
	// 공통코드 수정
	int updateCommCd(CommCdVO commCdVO);
	
	// 해당 대분류의 소분류 개수 가져오기
	int selectDetailCdCnt(Integer parent_no);
	
	// 공통코드 목록 삭제
	int deleteCommCdList(List<Integer> list);
	
	// 그룹 및 상세코드 가져오기
	List<CommCdVO> selectGroupDetailCdList(SearchVO searchVO);
	
	// 그룹코드 code로 상세코드목록 가져오기
	List<CommCdVO> selectDetailCdListWithCode(String code);
}
