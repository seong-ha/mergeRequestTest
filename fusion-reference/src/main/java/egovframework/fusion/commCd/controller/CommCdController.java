package egovframework.fusion.commCd.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.commCd.service.CommCdService;
import egovframework.fusion.commCd.vo.CommCdVO;

@Controller
public class CommCdController {
	
	@Autowired
	CommCdService commCdService;
	
	/*
	 * 공통코드 관리 페이지로
	 */
	@GetMapping("/commCd/commCdList.do")
	public String commCdList() {
		return "views/commCd/commCdList";
	}
	
	/*
	 * 그룹코드 가져오기
	 */
	@PostMapping("/commCd/groupCdList.do")
	@ResponseBody
	public List<CommCdVO> getGroupCdList(SearchVO searchVO) {
		//Map<String, Object> map = new HashMap<>();
		List<CommCdVO> groupCdList = commCdService.getGroupCdList(searchVO);
		CommCdVO vv = new CommCdVO();
		//map.put("groupCdList", groupCdList);
		return groupCdList;
	}
	
	/*
	 * 상세코드 가져오기
	 */
	@PostMapping("/commCd/detailCdList.do")
	@ResponseBody
	public List<CommCdVO> getDetailCdList(CommCdVO commCdVO) {
		List<CommCdVO> detailCdList = commCdService.getDetailCdList(commCdVO);
		
		return detailCdList;
	}

	/*
	 * 코드 중복 여부 확인
	 */
	@PostMapping("/commCd/getIsDuplicate.do")
	@ResponseBody
	public Map<String, Object> getIsDuplicate(CommCdVO commCdVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = commCdService.getIsDuplicate(commCdVO);
		
		if ("가능".equals(result)) {
			map.put("result", result);
		} else if ("중복".equals(result)) {
			map.put("result", result);
			map.put("msg", "이미 존재하는 대분류 코드입니다.");
		} else if ("실패".equals(result)) {
			map.put("result", result);
			map.put("msg", "중복 검사 중 오류가 발생했습니다.");
		}
		
		return map;
	}
	
	
	/*
	 * 공통코드 등록
	 */
	@PostMapping("/commCd/insCommCd.do")
	@ResponseBody
	public Map<String, Object> insCommCd(CommCdVO commCdVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = commCdService.insCommCd(commCdVO);
		
		if ("성공".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드가 정상적으로 등록되었습니다.");
		} else if ("실패".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드 등록에 실패했습니다.");
		}
		return map;
	}
	
	
	/*
	 * 공통코드 수정
	 */
	@PostMapping("/commCd/updCommCd.do")
	@ResponseBody
	public Map<String, Object> updCommCd(CommCdVO commCdVO) {
		Map<String, Object> map = new HashMap<>();
		
		String result = commCdService.updCommCd(commCdVO);
		
		if ("성공".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드가 정상적으로 수정되었습니다.");
		} else if ("실패".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드 수정에 실패했습니다.");
		}
		return map;
	}
	
	
	/*
	 * 대분류 안에 소분류가 존재하는 지 확인
	 */
	@PostMapping("/commCd/getHasDetailCd.do")
	@ResponseBody
	public Map<String, Object> getHasDetailCd(@RequestBody List<Integer> list) {
		Map<String, Object> map = new HashMap<>();
		
		map = commCdService.getHasDetailCd(list);
		
		return map;
	}
	
	
	/*
	 * 공통코드 목록 삭제
	 */
	@PostMapping("/commCd/delCommCdList.do")
	@ResponseBody
	public Map<String, Object> delCommCdList(@RequestBody List<Integer> list) {
		Map<String, Object> map = new HashMap<>();
		
		String result = commCdService.delCommCdList(list);
		
		if ("성공".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드가 정상적으로 삭제되었습니다.");
		} else if ("실패".equals(result)) {
			map.put("result", result);
			map.put("msg", "공통코드 삭제에 실패했습니다.");
		}
		return map;
	}
	/*
	 * 그룹및 상세코드 가져오기
	 */
	@PostMapping("/commCd/getGroupDetailCdList.do")
	@ResponseBody
	public List<CommCdVO> getGroupDetailCdList(SearchVO searchVO) {
		List<CommCdVO> commCdList = commCdService.getGroupDetailCdList(searchVO);
		
		return commCdList;
	}
	
}
