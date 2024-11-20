package egovframework.fusion.commCd.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.commCd.vo.CommCdVO;

@Service
public class CommCdServiceImpl implements CommCdService {

	@Autowired
	CommCdMapper dao;
	
	@Override
	public List<CommCdVO> getGroupCdList(SearchVO searchVO) {
		return dao.selectGroupCdList(searchVO);
	}

	@Override
	public List<CommCdVO> getDetailCdList(CommCdVO commCdVO) {
		return dao.selectDetailCdList(commCdVO);
	}

	@Override
	public String getIsDuplicate(CommCdVO commCdVO) {
		String result = "";
		
		try {
			commCdVO = dao.selectCommCdWithCode(commCdVO);
			
			if (commCdVO == null) {
				result = "가능";
			} else {
				result = "중복";
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패"; 
		}
		return result;
	}

	@Override
	public String insCommCd(CommCdVO commCdVO) {
		String result = "";
		
		// 공통코드는 비고를 빈값으로 처리
		if (commCdVO.getNote() == null) {
			commCdVO.setNote("");
		}
		
		try {
			dao.insertCommCd(commCdVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public String updCommCd(CommCdVO commCdVO) {
		String result = "";
		
		try {
			dao.updateCommCd(commCdVO);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}

	@Override
	public Map<String, Object> getHasDetailCd(List<Integer> list) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			for (int i = 0; i < list.size(); i++) {
				int cnt = dao.selectDetailCdCnt(list.get(i));
				if (cnt > 0) {
					map.put("result", "있음");
					map.put("comm_cd_no", list.get(i));
					map.put("msg", " 라는 공통코드에 소분류가 존재합니다.");
					break;
				} else {
					if (i == (list.size() - 1)) {
						map.put("result", "없음");
					}
				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			map.put("result", "실패");
			map.put("msg", "소분류 확인 중 오류가 발생했습니다.");
		}
		
		return map;
	}

	@Override
	public String delCommCdList(List<Integer> list) {
		String result = "";
		
		try {
			dao.deleteCommCdList(list);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}
		
		return result;
	}

	@Override
	public List<CommCdVO> getGroupDetailCdList(SearchVO searchVO) {
		return dao.selectGroupDetailCdList(searchVO);
	}

	@Override
	public List<CommCdVO> getDetailCdListWithCode(String code) {
		return dao.selectDetailCdListWithCode(code);
	}

}
