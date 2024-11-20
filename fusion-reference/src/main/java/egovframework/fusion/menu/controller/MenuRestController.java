package egovframework.fusion.menu.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.fusion.aop.vo.AccessLogVO;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.DayVO;
import egovframework.fusion.menu.vo.HourVO;
import egovframework.fusion.menu.vo.MonthVO;
import egovframework.fusion.menu.vo.YearVO;

@RestController
public class MenuRestController {
	
	@Autowired
	MenuService menuService;
	
	@PostMapping("menu/getYearStatistics.do")
	public List<YearVO> getYearStatistics() {
		List<YearVO> yearList = menuService.getYearStatistics();
		
		return yearList;
	}
	
	@PostMapping("menu/getMonthStatistics.do")
	public List<MonthVO> getMonthStatistics(AccessLogVO accessLogVO) {
		List<MonthVO> monthList = menuService.getMonthStatistics(accessLogVO);
		
		return monthList;
	}
	
	@PostMapping("menu/getDayStatistics.do")
	public List<DayVO> getDayStatistics(AccessLogVO accessLogVO) {
		List<DayVO> dayList = menuService.getDayStatistics(accessLogVO);
		
		return dayList;
	}
	
	@PostMapping("menu/getHourStatistics.do")
	public List<HourVO> getHourStatistics(AccessLogVO accessLogVO) {
		List<HourVO> hourList = menuService.getHourStatistics(accessLogVO);
		
		return hourList;
	}
	
}
