package egovframework.fusion.link.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.link.service.LinkService;
import egovframework.fusion.link.service.LinkService;

@Controller
public class LinkController {

	@Autowired
	LinkService linkService;
	
	@PostMapping("/link/linkLog.do")
	@ResponseBody
	public String linkLog(SearchVO searchVO) {
		searchVO.setNoPageChoose(true);
		linkService.getBoardList(searchVO);
		return "성공";
	}
}
