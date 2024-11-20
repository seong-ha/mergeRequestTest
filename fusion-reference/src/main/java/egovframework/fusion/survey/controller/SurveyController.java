package egovframework.fusion.survey.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.member.controller.MemberController;
import egovframework.fusion.menu.service.MenuService;
import egovframework.fusion.menu.vo.MenuVO;
import egovframework.fusion.survey.service.SurveyService;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ParticipateVO;
import egovframework.fusion.survey.vo.QuestionCategoryVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.SelectionVO;
import egovframework.fusion.survey.vo.SurveyVO;
import egovframework.fusion.survey.vo.TempAnswerVO;

@Controller
public class SurveyController {

	@Autowired
	MemberController memberCtrl;
	
	@Autowired
	MenuService menuService;
	
	private final SurveyService surveyService;

	public SurveyController(SurveyService surveyService) {
		this.surveyService = surveyService;
	}

	@GetMapping("/survey/surveyList.do")
	public String surveyList(String menuType, SearchVO searchVO, Model model) {
		if (searchVO.getNowPage() == null) {
			searchVO.setNoPageChoose(true);	// 페이징 선택 안했을 시(= 메뉴 첫접근 => 메뉴 접근 기록 추가)
		} else {
			searchVO.setNoPageChoose(false);// 페이징 선택 했을 시(= 메뉴 첫접근X => 메뉴 접근 기록 추가X)
		}
		
		List<SurveyVO> surveyList = surveyService.getBoardList(searchVO);

		model.addAttribute("surveyList", surveyList);
		model.addAttribute("menuType", menuType);
		
		return "views/survey/surveyList";
	}
	
	@PostMapping("/survey/surveyInfo.do")
	public String surveyInfo(String menuType, SurveyVO surveyVO, Model model) {
		
		surveyVO = surveyService.getSurvey(surveyVO);
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		if ((Integer) request.getSession().getAttribute("member_no") != 0) {
			ParticipateVO participateVO = new ParticipateVO();
			participateVO.setSurvey_no(surveyVO.getSurvey_no());
			participateVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
			List<ParticipateVO> participateList = surveyService.getMemberParticipateList(participateVO);
			model.addAttribute("participateList", participateList);
		}
		
		model.addAttribute("menuType", menuType);
		model.addAttribute("survey", surveyVO);
		return "views/survey/surveyInfo";
	}
	
//	// GET방식은 잘못된 접근이라고 돌려보내기
//	@GetMapping("/survey/surveyInfo.do")
//	public String notAllowSurveyInfo(SurveyVO surveyVO, String menuType, SearchVO searchVO, Model model) {
//		if (memberCtrl.checkSession(model) != null) {
//			return memberCtrl.checkSession(model);
//		}
//		
//		List<SurveyVO> surveyList = surveyService.getBoardList(searchVO);
//		
//		model.addAttribute("surveyList", surveyList);
//		model.addAttribute("notAllowMessage", "잘못된 접근입니다.");
//		if (menuType == null) {
//			model.addAttribute("menuType", "survey");
//		} else {
//			model.addAttribute("menuType", menuType);
//		}
//		
//		return "views/survey/surveyList";
//	}
	
	@PostMapping("/survey/surveyPost.do")
	public String surveyPost(String menuType, SurveyVO surveyVO, SearchVO searchVO, Model model) throws JsonProcessingException {
		String result = "";
		
		// 설문참여기간, 참여횟수 체크
		result = surveyService.surveyValidate(surveyVO);
		
		
		if (!result.equals("검증")) {
			// 설문 리스트 화면으로 돌려보내기 위해 설문 리스트를 가져옴.
			List<SurveyVO> surveyList = surveyService.getBoardList(searchVO);
			model.addAttribute("surveyList", surveyList);
			model.addAttribute("menuType", menuType);
			
			if (result.equals("참여대상")) {
				model.addAttribute("notAllowMessage", "참여대상이 아닙니다.");
			} else if (result.equals("날짜")) {
				model.addAttribute("notAllowMessage", "참여기간이 아닙니다.");
			} else if (result.equals("참여수")) {
				model.addAttribute("notAllowMessage", "참여가능 횟수를 초과했습니다.");
			} else if (result.equals("날짜변환")) {
				model.addAttribute("notAllowMessage", "알 수 없는 오류가 났습니다.");
			} else if (result.equals("세션아웃")) {
				return memberCtrl.checkSession(model);
			} else if (result.equals("실패")) {
				model.addAttribute("notAllowMessage", "알 수 없는 오류가 났습니다.");
			}
			
			return "views/survey/surveyList";
		}
		
		
		List<QuestionVO> questionList = surveyService.getQuestionList(surveyVO);
		
		model.addAttribute("questionList", questionList);
		model.addAttribute("questionVO", questionList.get(0));
		model.addAttribute("menuType", menuType);
		
		
		return "views/survey/surveyPost";
	}
	
	
//	// GET방식은 잘못된 접근이라고 돌려보내기
//		@GetMapping("/survey/surveyPost.do")
//		public String notAllowSurveyPost(SurveyVO surveyVO, String menuType, SearchVO searchVO, Model model) {
//			if (memberCtrl.checkSession(model) != null) {
//				return memberCtrl.checkSession(model);
//			}
//			
//			List<SurveyVO> surveyList = surveyService.getBoardList(searchVO);
//			
//			model.addAttribute("surveyList", surveyList);
//			model.addAttribute("notAllowMessage", "잘못된 접근입니다.");
//			model.addAttribute("menuType", menuType);
//			
//			return "views/survey/surveyList";
//		}
	
	
	// 임시 저장한 답변목록 가져오기
	@PostMapping("/survey/getTempAnswerList.do")
	@ResponseBody
	public List<TempAnswerVO> tempAnswerList(AnswerVO answerVO, Model model) throws JsonProcessingException {
		List<TempAnswerVO> tempAnswerList = new ArrayList<>();
		TempAnswerVO vo = new TempAnswerVO();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		if ((Integer) request.getSession().getAttribute("member_no") != 0) {
			// 현재 세션으로 memeber_no set
			answerVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		} else {
			// 비회원이면 임시 저장을 안 되도록 해놓음.
			// 임시저장한 것이 없다는 표시(첫 객체에 temp_yn이 'N'이면 없다는 뜻
			vo.setTemp_yn("N");
			tempAnswerList.add(vo);
			return tempAnswerList;
		}
		
		// 임시 저장한게 있는지 확인
		int isIn = surveyService.isInTempAnswer(answerVO);
		
		if (isIn > 0) {
			try {
				tempAnswerList = surveyService.getTempAnswerList(answerVO);
			} catch (Exception e) {
				e.printStackTrace();
				// 첫 객체의 answer_no가 0이면, 임시 저장한 설문을 가져오지 못했다는 뜻.
				vo.setAnswer_no(0);
				tempAnswerList.add(vo);
				return tempAnswerList;
			}
		} else {
			// 임시저장한 것이 없다는 표시(첫 객체에 temp_yn이 'N'이면 없다는 뜻
			vo.setTemp_yn("N");
			tempAnswerList.add(vo);
		}
		
		return tempAnswerList;
	}
	
	
	@PostMapping(value="/survey/insSurveyAnswer.do")
	@ResponseBody
	public Map<String, Object> insSurveyAnswer(/*String jsonData,*/ @RequestBody List<AnswerVO> answerList,  Model model) throws JsonProcessingException {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		String result = "";
		
		SurveyVO surveyVO = new SurveyVO();
		surveyVO.setSurvey_no(answerList.get(0).getSurvey_no());
		surveyVO.setMember_no(Integer.valueOf(memberCtrl.getSessionInfo().get("member_no")));
		
		// 설문참여기간, 참여횟수 체크
		result = surveyService.surveyValidate(surveyVO);
		
		if (!result.equals("검증")) {
			if (result.equals("참여대상")) {
				map.put("msg", "참여대상이 아닙니다.");
				return map;
			} else if (result.equals("날짜")) {
				map.put("msg", "참여기간이 아닙니다.");
				return map;
			} else if (result.equals("참여수")) {
				map.put("msg", "참여가능 횟수를 초과했습니다.");
				return map;
			} else if (result.equals("날짜변환")) {
				map.put("msg", "알 수 없는 오류가 났습니다.");
				return map;
			} else if (result.equals("세션아웃")) {
				return memberCtrl.checkSession();
			} else if (result.equals("실패")) {
				map.put("msg", "알 수 없는 오류가 났습니다.");
				return map;
			}
		}
		
		if (request.getSession().getAttribute("member_no") != null) {
			// 현재 세션으로 memeber_no set
			for (int i = 0; i < answerList.size(); i++) {
				answerList.get(i).setMember_no(Integer.valueOf(memberCtrl.getSessionInfo().get("member_no")));
			}
			
			// 제출한 답변들이 임시 저장이었다면
			if (answerList.get(0).getTempLoaded_yn() != null && answerList.get(0).getTempLoaded_yn().equals("Y")) {
				
				// 기존 임시 저장 삭제 처리 후 최종 제출
				result = surveyService.changeTempToSubmit(answerList);
				if (result.equals("실패")) {
					map.put("msg", "설문참여 등록에 실패했습니다.");
					return map;
				}
			// 제출한 답변들이 첫 제출이라면
			} else {
				// 최종 제출
				result = surveyService.insSurveyAnswer(answerList);
			}
		} else {
			// 비회원이면
			for (int i = 0; i < answerList.size(); i++) {
				answerList.get(i).setMember_no(0);
			}
			
			// 최종 제출
			result = surveyService.insSurveyAnswer(answerList);
		}
		
		map.put("result", result);
		if (result.equals("성공")) {
			map.put("msg", "설문참여가 정상 등록되었습니다.");
		} else if (result.equals("실패")) {
			map.put("msg", "설문참여 등록에 실패했습니다.");
		}

		return map;
	}
	

	// 답변들 임시 저장
	@PostMapping(value="/survey/insSurveyTempAnswer.do")
	@ResponseBody
	public Map<String, Object> insSurveyTempAnswer(@RequestBody List<AnswerVO> tempAnswerList,  Model model) throws JsonProcessingException {
		Map<String, Object> map = new HashMap<>();
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		SurveyVO surveyVO = new SurveyVO();
		if ((Integer) request.getSession().getAttribute("member_no") != 0) {
			// 현재 세션으로 memeber_no set
			surveyVO.setSurvey_no(tempAnswerList.get(0).getSurvey_no());
			surveyVO.setMember_no((Integer) request.getSession().getAttribute("member_no"));
		} else {
			// 비회원이면
			map.put("msg", "비회원은 설문 임시 저장을 할 수 없습니다.");
			return map;
		}
		
		String result = "";
		
		
		// 설문참여기간, 참여횟수 체크
		result = surveyService.surveyValidate(surveyVO);
		
		if (!result.equals("검증")) {
			if (result.equals("날짜")) {
				map.put("msg", "참여기간이 아닙니다.");
				return map;
			} else if (result.equals("참여수")) {
				map.put("msg", "참여가능 횟수를 초과했습니다.");
				return map;
			} else if (result.equals("날짜변환")) {
				map.put("msg", "알 수 없는 오류가 났습니다.");
				return map;
			} else if (result.equals("세션아웃")) {
				map.put("msg", "세션 만료로 로그아웃되었습니다. 로그인 후 이용해주세요.");
				return map;
			} else if (result.equals("실패")) {
				map.put("msg", "알 수 없는 오류가 났습니다.");
				return map;
			}
		}
		
		
		for (int i = 0; i < tempAnswerList.size(); i++) {
			tempAnswerList.get(i).setMember_no(Integer.valueOf(memberCtrl.getSessionInfo().get("member_no")));
		}
		
		// 임시 저장한게 있는지 확인
		int isIn = surveyService.isInTempAnswer(tempAnswerList.get(0));

		if (isIn == 0) {
			// 새 임시 저장
			result = surveyService.insSurveyTempAnswer(tempAnswerList);
		} else {
			// 중복 임시 저장
			result = surveyService.updSurveyTempAnswer(tempAnswerList);
		}
		
		map.put("result", result);
		if (result.equals("성공")) {
			map.put("msg", "설문이 임시 저장되었습니다.");
		} else if (result.equals("실패")) {
			map.put("msg", "설문 임시 저장에 실패했습니다.");
		}

		return map;
	}
	
	
	// 설문 관리페이지로
	@GetMapping("/survey/surveyManage.do")
	public String surveyManage(String menuType, SurveyVO surveyVO, SearchVO searchVO, Model model) {
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			model.addAttribute("notAllowMessage", "설문 관리는 관리자만 사용할 수 있습니다.");
			model.addAttribute("menuType", menuType);
			return "views/survey/surveyList"; 
		}
		
		// 설문 리스트 가져오기
		List<SurveyVO> surveyList = surveyService.getSurveyListforManage(searchVO);
		
		model.addAttribute("surveyList", surveyList);
		
		if (menuType == null) {
			model.addAttribute("menuType", "survey");
		} else {
			model.addAttribute("menuType", menuType);
		}
		return "views/survey/surveyManage";
	}
	
	
	// 새 설문 작성 페이지로
	@GetMapping("/survey/surveyRegister.do")
	public String surveyRegister(String menuType, Model model) {
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			model.addAttribute("notAllowMessage", "설문 작성은 관리자만 사용할 수 있습니다.");
			model.addAttribute("menuType", menuType);
			return "views/survey/surveyList"; 
		}
		
		List<QuestionCategoryVO> questionCategoryList = surveyService.getQuestionCategoryList();
		
		model.addAttribute("categoryList", questionCategoryList);
		
		if (menuType == null) {
			model.addAttribute("menuType", "survey");
		} else {
			model.addAttribute("menuType", menuType);
		}
		return "views/survey/surveyRegister";
	}
	
	
	// 설문 등록
	@PostMapping("/survey/insSurvey.do")
	@ResponseBody
	public Map<String, Object> insSurvey(@RequestBody Map<String, Object> data, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("msg", "설문 등록은 관리자만할 수 있습니다.");
			return map; 
		}
		
		
		
		ObjectMapper mapper = new ObjectMapper();
		SurveyVO surveyVO = mapper.convertValue(data.get("surveyVO"), SurveyVO.class);
		surveyVO.setMember_no(Integer.valueOf(memberCtrl.getSessionInfo().get("member_no")));
		
//		List<QuestionVO> questionList = (List<QuestionVO>) data.get("questionList");
//		System.out.println(questionList.toString());
		
		List<QuestionVO> questionList = new ArrayList<>();
		List tempQuestionList = (List) data.get("questionList");
		for (Object obj : tempQuestionList) {
			ObjectMapper mapper2 = new ObjectMapper();
			QuestionVO questionVO = mapper2.convertValue(obj, QuestionVO.class);
			questionList.add(questionVO);
		}
		
		
		String result = surveyService.insSurvey(surveyVO, questionList);
		
		if (result.equals("성공")) {
			map.put("result", result);
			map.put("msg", "설문이 정상 등록되었습니다.");
		} else if (result.equals("실패")) {
			map.put("result", result);
			map.put("msg", "설문 등록에 실패했습니다.");
		} else if (result.equals("시퀀스")) {
			map.put("result", result);
			map.put("msg", "시퀀스 오류가 발생했습니다.");
		} else if (result.equals("오류")) {
			map.put("result", result);
			map.put("msg", "알 수 없는 오류가 발생했습니다.");
		}
		
		return map;
	}
	
	
	// 설문정보관리 페이지로 이동
	@PostMapping("/survey/surveyInfoToManage.do")
	public String surveyInfoToManage(String menuType, SurveyVO surveyVO, Model model) {
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			model.addAttribute("notAllowMessage", "설문 정보 관리는 관리자만 이용할 수 있습니다.");
			model.addAttribute("menuType", menuType);
			return "views/survey/surveyList"; 
		}
		
		SurveyVO surveyInfo = surveyService.getSurvey(surveyVO);

		
		model.addAttribute("survey", surveyInfo);
		model.addAttribute("today", LocalDate.now().toString());
		model.addAttribute("menuType", menuType);
		
		return "views/survey/surveyInfoToManage";
	}
	
	
	// 설문 정보 수정
	@PostMapping("/survey/updSurvey.do")
	@ResponseBody
	public Map<String, Object> updSurvey(SurveyVO surveyVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("msg", "설문 수정은 관리자만할 수 있습니다.");
			return map; 
		}
		
		// 설문 정보 가져와서 설문 시작일 이후에만 수정 가능토록 검증 
		SurveyVO surveyInfo = surveyService.getSurvey(surveyVO);
		try {
			String now = LocalDate.now().toString();

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date today = sdf.parse(now);
			Date startDate = sdf.parse(surveyInfo.getStart_dt());

			// 오늘이 시작일보다 전이 아니면서, 마지막날 이후가 아닐 때
			if (!today.before(startDate)) {
				map.put("msg", "설문 정보는 설문 시작일 전에만 수정가능합니다.");
				return map;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception ee) {
			ee.printStackTrace();
		}
		
		String result = "";
		
		result = surveyService.updateSurvey(surveyVO);
		
		if (result.equals("성공")) {
			map.put("result", result);
			map.put("msg", "설문 정보가 정상적으로 수정되었습니다.");
		} else if (result.equals("실패")) {
			map.put("result", result);
			map.put("msg", "설문 정보 수정에 실패했습니다.");
		}
		
		return map;
	}
	
	
	
	// 설문 정보 삭제 및 종속된 문항,선택지 삭제
	@PostMapping("/survey/delSurvey.do")
	@ResponseBody
	public Map<String, Object> delSurvey(SurveyVO surveyVO, Model model) {
		Map<String, Object> map = new HashMap<>();
		
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("msg", "설문 삭제는 관리자만할 수 있습니다.");
			return map;
		}
		
		String result = "";
		
		result = surveyService.deleteSurvey(surveyVO);
		
		if (result.equals("성공")) {
			map.put("result", result);
			map.put("msg", "설문 및 문항 정보가 정상적으로 삭제되었습니다.");
		} else if (result.equals("실패")) {
			map.put("result", result);
			map.put("msg", "설문 및 문항 정보 삭제에 실패했습니다.");
		}
		
		return map;
	}
	
	// 설문의 문항 관리 페이지로
	@PostMapping("/survey/surveyQuestionManage.do")
	public String surveyQuestionManage(String menuType, SurveyVO surveyVO, Model model) {
		
		
		if (memberCtrl.checkSession(model) != null) {
			return memberCtrl.checkSession(model);
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			model.addAttribute("notAllowMessage", "설문 정보 관리는 관리자만 이용할 수 있습니다.");
			model.addAttribute("menuType", menuType);
			return "views/survey/surveyList"; 
		}
		
		// 설문의 문항 목록, 선택지 목록
		List<QuestionVO> questionList = surveyService.getQuestionListForManage(surveyVO);
		// 문항 분류 리스트
		List<QuestionCategoryVO> questionCategoryList = surveyService.getQuestionCategoryList();
		
		// 문항 및 선택지 각각 동일 레벨화(내부의 객체를 꺼내서 순서대로 재배열) => 수정작업 시 기존과 변화를 편하기 비교하기 위함
		List<QuestionVO> flatQuestionList = new ArrayList<>(); 		// questionList 내부의 대문항과 소문항들을 순서대로 꺼내 담아서 동일 레벨화
		List<SelectionVO> flatSelectionList = new ArrayList<>(); 	// 보기를 가진 문항(일반 문항과 소문항)에서 보기들을 순서대로 꺼내 담아서 동일 레벨화
		if (questionList != null) {
			for (QuestionVO questionVO : questionList) {
				flatQuestionList.add(questionVO); 	// 동일 레벨화(문항)

				List<QuestionVO> childQuestionList = questionVO.getQuestionList();
				
				// 소문항이 있는 경우
				if (childQuestionList != null && childQuestionList.size() != 0) {
					for (QuestionVO childQuestionVO : childQuestionList) {
						flatQuestionList.add(childQuestionVO); // 동일 레벨화(문항)

						List<SelectionVO> selectionList = childQuestionVO.getSelectionList();
						for (SelectionVO selectionVO : selectionList) {
							flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
						}
					}

					// 소문항이 없을 경우(자기 선택지가 있는 대문항)
				} else {
					List<SelectionVO> selectionList = questionVO.getSelectionList();
					for (SelectionVO selectionVO : selectionList) {
						flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
					}
				}

			}
		}
		
		
		// javascript단에서 띄어쓰기에 대해 객체로 parsing이 잘 안되는 걸 방치하기 위해 jsonString으로 변환 후 내리기
		ObjectMapper questionMapper = new ObjectMapper();
		ObjectMapper selectionMapper = new ObjectMapper();
		
		String flatQuestionListJsonInString = "";
		String flatSelectionListJsonInString = "";
		
		try {
			flatQuestionListJsonInString = questionMapper.writeValueAsString(flatQuestionList);
			flatSelectionListJsonInString = selectionMapper.writeValueAsString(flatSelectionList);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		model.addAttribute("questionList", questionList);
		model.addAttribute("categoryList", questionCategoryList);
		model.addAttribute("flatQuestionList1", flatQuestionListJsonInString);
		model.addAttribute("flatQuestionList2", flatQuestionListJsonInString);
		model.addAttribute("flatSelectionList1", flatSelectionListJsonInString);
		model.addAttribute("flatSelectionList2", flatSelectionListJsonInString);
		
		if (menuType == null) {
			model.addAttribute("menuType", "survey");
		} else {
			model.addAttribute("menuType", menuType);
		}
		
		return "views/survey/surveyQuestionManage";
	}
	
	
	// 설문 문항 정보 수정
	@PostMapping("/survey/updSurveyQuestion.do")
	@ResponseBody
	public Map<String, Object> updSurveyQuestion(@RequestBody Map<String, Object> data, Model model) {
		Map<String, Object> map = new HashMap<>();
	
		if (memberCtrl.checkSession() != null) {
			return memberCtrl.checkSession();
		}
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		// 관리자가 아닐 시 돌려보내기
		if ((Integer) request.getSession().getAttribute("author_no") != 1 && (Integer) request.getSession().getAttribute("author_no") != 2) {
			map.put("msg", "설문 등록은 관리자만할 수 있습니다.");
			return map; 
		}
		
		/*
		  삭제된 문항 리스트						deletedQuestionList
		  선택지 삭제로 삭제된 선택지 리스트			deletedSelectionList
		  수정된 문항 리스트						updatedQuestionList
		  수정된 선택지 리스트					updatedSelectionList
		  기존 대문항 소문항들에 추가된 선택지 리스트	addedSelectionListInExist
		  기존 대문항에 추가된 소문항과선택지 리스트		addedQuestionSelectionListInExist
		  완전 새로운 대문항과소문항과선택지 리스트		newQuestionList
		*/
		
		List<QuestionVO> deletedQuestionList = new ArrayList<>();
		List temp1 = (List) data.get("deletedQuestionList");
		for (Object obj : temp1) {
			ObjectMapper mapper = new ObjectMapper();
			QuestionVO questionVO = mapper.convertValue(obj, QuestionVO.class);
			deletedQuestionList.add(questionVO);
		}
		
		List<SelectionVO> deletedSelectionList = new ArrayList<>();
		List temp2 = (List) data.get("deletedSelectionList");
		for (Object obj : temp2) {
			ObjectMapper mapper = new ObjectMapper();
			SelectionVO selectionVO = mapper.convertValue(obj, SelectionVO.class);
			deletedSelectionList.add(selectionVO);
		}
		
		List<QuestionVO> updatedQuestionList = new ArrayList<>();
		List temp3 = (List) data.get("updatedQuestionList");
		for (Object obj : temp3) {
			ObjectMapper mapper = new ObjectMapper();
			QuestionVO questionVO = mapper.convertValue(obj, QuestionVO.class);
			updatedQuestionList.add(questionVO);
		}
		
		List<SelectionVO> updatedSelectionList = new ArrayList<>();
		List temp4 = (List) data.get("updatedSelectionList");
		for (Object obj : temp4) {
			ObjectMapper mapper = new ObjectMapper();
			SelectionVO selectionVO = mapper.convertValue(obj, SelectionVO.class);
			updatedSelectionList.add(selectionVO);
		}
		
		List<SelectionVO> addedSelectionListInExist = new ArrayList<>();
		List temp5 = (List) data.get("addedSelectionListInExist");
		for (Object obj : temp5) {
			ObjectMapper mapper = new ObjectMapper();
			SelectionVO selectionVO = mapper.convertValue(obj, SelectionVO.class);
			addedSelectionListInExist.add(selectionVO);
		}
		
		List<QuestionVO> addedQuestionSelectionListInExist = new ArrayList<>();
		List temp6 = (List) data.get("addedQuestionSelectionListInExist");
		for (Object obj : temp6) {
			ObjectMapper mapper = new ObjectMapper();
			QuestionVO questionVO = mapper.convertValue(obj, QuestionVO.class);
			addedQuestionSelectionListInExist.add(questionVO);
		}
		
		List<QuestionVO> newQuestionList = new ArrayList<>();
		List temp7 = (List) data.get("newQuestionList");
		for (Object obj : temp7) {
			ObjectMapper mapper = new ObjectMapper();
			QuestionVO questionVO = mapper.convertValue(obj, QuestionVO.class);
			newQuestionList.add(questionVO);
		}
		
		
		String result = "";
		
		result = surveyService.updSurveyQuestion(deletedQuestionList, deletedSelectionList, updatedQuestionList, updatedSelectionList
										, addedSelectionListInExist, addedQuestionSelectionListInExist
										, newQuestionList);
		
		
		if (result.equals("성공")) {
			map.put("result", result);
			map.put("msg", "설문 문항이 정상 수정되었습니다.");
		} else if (result.equals("실패")) {
			map.put("result", result);
			map.put("msg", "설문 문항 수정에 실패했습니다.");
		} else if (result.equals("시퀀스")) {
			map.put("result", result);
			map.put("msg", "시퀀스 오류가 발생했습니다.");
		} else if (result.equals("오류")) {
			map.put("result", result);
			map.put("msg", "알 수 없는 오류가 발생했습니다.");
		}
		
		return map;
	}

}
