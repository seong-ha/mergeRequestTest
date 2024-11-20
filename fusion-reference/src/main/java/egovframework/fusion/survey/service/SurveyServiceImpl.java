package egovframework.fusion.survey.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ParticipateVO;
import egovframework.fusion.survey.vo.QuestionCategoryVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.SelectionVO;
import egovframework.fusion.survey.vo.SurveyVO;
import egovframework.fusion.survey.vo.TempAnswerVO;

@Service
public class SurveyServiceImpl implements SurveyService {

	@Autowired
	private SurveyMapper dao;
	
	@Override
	public List<SurveyVO> getBoardList(SearchVO searchVO) {
		List<SurveyVO> surveyList = dao.selectSurveyList(searchVO);
		
		if (surveyList != null && surveyList.size() > 0) {
			for (SurveyVO surveyVO : surveyList) {
				// ,로 연결된 하나의 String subject를 나눠서 subjectList에 넣어줌.
				String[] subjectArr = surveyVO.getSubject().split(", ");
				surveyVO.setSubjectList(new ArrayList<String>());
				
				for (int i = 0; i < subjectArr.length; i++) {
					surveyVO.getSubjectList().add(subjectArr[i]);
				}
			}
		}
		
		return surveyList;
	}

	@Override
	public SurveyVO getSurvey(SurveyVO surveyVO) {
		surveyVO = dao.selectSurvey(surveyVO);

		// ,로 연결된 하나의 String subject를 나눠서 subjectList에 넣어줌.
		String[] subjectArr = surveyVO.getSubject().split(", ");
		surveyVO.setSubjectList(new ArrayList<String>());
		for (int i = 0; i < subjectArr.length; i++) {
			surveyVO.getSubjectList().add(subjectArr[i]);
		}
		
		return surveyVO;
	}

	@Override
	public List<ParticipateVO> getMemberParticipateList(ParticipateVO participateVO) {
		return dao.selectMemberParticipateList(participateVO);
	}

	@Override
	public String surveyValidate(SurveyVO surveyVO) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		

		surveyVO = dao.selectSurvey(surveyVO);
		if (session.getAttribute("member_no") != null) {
			surveyVO.setMember_no(Integer.valueOf(session.getAttribute("member_no").toString()));
		}
		try {
			boolean subjectValidation = false;
			
			if (!surveyVO.getSubject().equals("ALL")) {
				String[] subjectArr = surveyVO.getSubject().split(", ");
				
				
				String author = session.getAttribute("author").toString();
				
				for (String subject : subjectArr) {
					if (author.equals(subject)) {
						subjectValidation = true;
					}
				}
				
				if (!subjectValidation) {
					return "참여대상";
				}
			}
			
			String now = LocalDate.now().toString();
			System.out.println("now = " + now);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date today = sdf.parse(now);
			Date startDate = sdf.parse(surveyVO.getStart_dt());
			Date endDate = sdf.parse(surveyVO.getEnd_dt());
			System.out.println(sdf.format(startDate));
			System.out.println(sdf.format(endDate));

			// 오늘이 시작일보다 전이 아니면서, 마지막날 이후가 아닐 때
			if (!today.before(startDate) && !today.after(endDate)) {
				ParticipateVO participateVO = new ParticipateVO();
				participateVO.setMember_no(surveyVO.getMember_no());
				participateVO.setSurvey_no(surveyVO.getSurvey_no());

				if (participateVO.getMember_no() != null) {
					participateVO = dao.selectParticipateCnt(participateVO);

					if (participateVO.getParticipate_cnt() >= surveyVO.getSubmit_cnt()) {
						return "참여수";
					}
				} else {
					if(!surveyVO.getSubject().equals("ALL")) {
						return "세션아웃";
					}
				}

			} else {
				return "날짜";
			}
		} catch (ParseException e) {
			e.printStackTrace();
			return "날짜변환";
		} catch (Exception ee) {
			ee.printStackTrace();
			return "실패";
		}

		return "검증";
	}
	
	@Override
	public List<QuestionVO> getQuestionList(SurveyVO surveyVO) {
		List<QuestionVO> list = dao.selectQuestionList(surveyVO);
		return list;
	}
	
	@Override
	public int isInTempAnswer(AnswerVO answerVO) {
		return dao.selectIsInTempAnswer(answerVO);
	}
	
	@Override
	public List<TempAnswerVO> getTempAnswerList(AnswerVO answerVO) {
		return dao.selectTempAnswerList(answerVO);
	}
	
	@Override
	@Transactional
	public String changeTempToSubmit(List<AnswerVO> answerList) {
		String result = "실패";

		ParticipateVO participateVO = new ParticipateVO();
		participateVO.setMember_no(Integer.valueOf(answerList.get(0).getMember_no()));
		participateVO.setSurvey_no(answerList.get(0).getSurvey_no());

		try {
			int deleteResult = dao.deleteTempAnswer(answerList.get(0));
			if (deleteResult > 0) {
				// 설문참여 insert + 설문참여번호 가져오기
				dao.insertParticipate(participateVO);

				// 설문참여번호, 작성자 set 후 답변리스트 insert
				for (int i = 0; i < answerList.size(); i++) {
					answerList.get(i).setParticipate_no(participateVO.getParticipate_no());
				}
				// 최종 제출
				int insertResult = dao.insertAnswer(answerList);
				if (insertResult > 0) {
					result = "성공";
				}
			} else {
				result = "실패";
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}

		return result;
	}
	
	@Override
	@Transactional
	public String insSurveyAnswer(List<AnswerVO> answerList) {
		String result = "실패";

		ParticipateVO participateVO = new ParticipateVO();
		participateVO.setMember_no(Integer.valueOf(answerList.get(0).getMember_no()));
		participateVO.setSurvey_no(answerList.get(0).getSurvey_no());

		try {
			// 설문참여 insert + 설문참여번호 가져오기
			dao.insertParticipate(participateVO);

			// 설문참여번호, 작성자 set 후 답변리스트 insert
			for (int i = 0; i < answerList.size(); i++) {
				answerList.get(i).setParticipate_no(participateVO.getParticipate_no());
			}
			dao.insertAnswer(answerList);

			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	@Override
	public String insSurveyTempAnswer(List<AnswerVO> tempAnswerList) {
		String result = "실패";

		try {
			dao.insertTempAnswer(tempAnswerList);
			result = "성공";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return result;
	}


	@Override
	@Transactional
	public String updSurveyTempAnswer(List<AnswerVO> tempAnswerList) {
		String result = "실패";

		try {
			// 기존 임시 저장 삭제처리
			int deleteResult = dao.deleteTempAnswer(tempAnswerList.get(0));
			if (deleteResult > 0) {
				// 새 임시 저장
				int insertResult = dao.insertTempAnswer(tempAnswerList);
				if (insertResult > 0) {
					result = "성공";
				}
			} else {
				result = "실패";
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result = "실패";
		}

		return result;
	}
	
	@Override
	public List<SurveyVO> getSurveyListforManage(SearchVO searchVO) {
		return dao.selectSurveyListforManage(searchVO);
	}
	
	@Override
	public List<QuestionCategoryVO> getQuestionCategoryList() {
		return dao.selectQuestionCategoryList();
	}

	@Override
	@Transactional
	public String insSurvey(SurveyVO surveyVO, List<QuestionVO> questionList) {
		String result = ""; // 성공 실패여부 리턴

		// 설문 정보 등록
		dao.insertSurvey(surveyVO);
		
		List<QuestionVO> flatQuestionList = new ArrayList<>(); 		// questionList 내부의 대문항과 소문항들을 순서대로 꺼내 담아서 동일 레벨화
		List<SelectionVO> flatSelectionList = new ArrayList<>(); 	// 보기를 가진 문항(일반 문항과 소문항)에서 보기들을 순서대로 꺼내 담아서 동일 레벨화
		int requiredQuestionSequenceCnt = 0; 						// 필요한 문항 sequence 개수
		int requiredSelectionSequenceCnt = 0; 						// 필요한 선택지 sequence 개수
		List<Integer> questionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 문항 sequence 목록
		List<Integer> selectionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 선택지 sequence 목록(한 문항 내의 모든 선택지는 같은 sequence 사용)

		/*
		 * <문항과 보기의 pk를 가져오기 위한 준비단계>
		 * 1. 문항 및 선택지 각각 동일 레벨화(내부의 객체를 꺼내서 순서대로 재배열)
		 * 2. 문항과 보기에 각각 할당할, 필요한 sequence 개수 파악
		 */
		for (QuestionVO questionVO : questionList) {
			flatQuestionList.add(questionVO); 	// 동일 레벨화(문항)
			requiredQuestionSequenceCnt++; 		// 문항마다 추가

			List<QuestionVO> childQuestionList = questionVO.getQuestionList();

			// 소문항이 있는 경우
			if (childQuestionList != null) {
				for (QuestionVO childQuestionVO : childQuestionList) {
					flatQuestionList.add(childQuestionVO); // 동일 레벨화(문항)
					requiredQuestionSequenceCnt++; // 문항마다 추가

					requiredSelectionSequenceCnt++; // 문항마다 선택지들은 하나의 selection sequence를 사용. 따라서 1만 증가
					List<SelectionVO> selectionList = childQuestionVO.getSelectionList();
					for (SelectionVO selectionVO : selectionList) {
						flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
					}
				}

				// 소문항이 없을 경우(자기 선택지가 있는 대문항)
			} else {
				requiredSelectionSequenceCnt++;
				List<SelectionVO> selectionList = questionVO.getSelectionList();
				for (SelectionVO selectionVO : selectionList) {
					flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
				}
			}
		}

		// 필요한 sequence 목록 가져오기
		questionSequenceList = dao.selectQuestionSequenceList(requiredQuestionSequenceCnt);
		selectionSequenceList = dao.selectSelectionSequenceList(requiredSelectionSequenceCnt);

		// 가져온 문항 sequence를 문항에 할당.
		// 문항List들은 같은 questionList를 참조하기 때문에 flatQuestionList에 할당하면 questionList도 할당됨)
		for (int i = 0; i < questionSequenceList.size(); i++) {
			flatQuestionList.get(i).setQuestion_no(questionSequenceList.get(i));
		}

		// 막간을 이용해 selectKey로 가져온 survey_no도 할당
		for (int i = 0; i < questionSequenceList.size(); i++) {
			flatQuestionList.get(i).setSurvey_no(surveyVO.getSurvey_no());
		}

		// 소문항의 parent_no에 대문항 sequence 할당
		for (QuestionVO questionVO : questionList) {
			questionVO.setParent_no(0);	// 대문항들은 다 parent_no가 기본적으로 0
			List<QuestionVO> childQuestionList = questionVO.getQuestionList();
			if (childQuestionList != null) {
				for (QuestionVO childQuestionVO : childQuestionList) {
					childQuestionVO.setParent_no(questionVO.getQuestion_no());
				}
			}
		}

		// 첫 sequence와 마지막 sequence
		Integer currentSelectionSequence = selectionSequenceList.get(0);
		Integer lastSelectionSequence = selectionSequenceList.get(selectionSequenceList.size() - 1);

		// 가져온 선택지 sequence 할당
		for (int i = 0; i < questionList.size(); i++) {
			List<QuestionVO> childQuestionList = questionList.get(i).getQuestionList();

			try {
				// 소문항이 있는 경우
				if (childQuestionList != null) {

					// 소문항이 있는 대문항은 선택지가 없다. => selection_no = 0
					questionList.get(i).setSelection_no(0);

					for (QuestionVO childQuestionVO : childQuestionList) {
						if (currentSelectionSequence > lastSelectionSequence) {
							throw new IllegalStateException("선택지의 sequence가 잘못 할당되었습니다.");
						}
						
						// 각각의 소문항 selection_no fk에 선택지 sequence 할당
						childQuestionVO.setSelection_no(currentSelectionSequence);

						List<SelectionVO> selectionList = childQuestionVO.getSelectionList();
						for (SelectionVO selectionVO : selectionList) {
							selectionVO.setSelection_no(currentSelectionSequence);
						}

						// 한 sequence가 문항별 선택지에 할당되고 나면 1씩 증가. 즉, 선택지 있는 문항 할당한 다음 1증가.
						currentSelectionSequence++;
					}

					// 소문항이 없는 대문항
				} else {
					if (currentSelectionSequence > lastSelectionSequence) {
						throw new IllegalStateException("선택지의 sequence가 잘못 할당되었습니다.");
					}
					
					// 각각의 대문항 selection_no fk에 선택지 sequence 할당
					questionList.get(i).setSelection_no(currentSelectionSequence);

					List<SelectionVO> selectionList = questionList.get(i).getSelectionList();
					for (SelectionVO selectionVO : selectionList) {
						selectionVO.setSelection_no(currentSelectionSequence);
					}

					// 한 sequence가 문항별 선택지에 할당되고 나면 1씩 증가. 즉, 선택지 있는 문항 할당한 다음 1증가.
					currentSelectionSequence++;
				}
			} catch (IllegalStateException ilse) {
				System.out.println(ilse.getMessage());
				ilse.printStackTrace();
				return "시퀀스";

			} catch (Exception e) {
				e.printStackTrace();
				return "오류";
			}

		}

	    try {
	    	dao.insertQuestion(flatQuestionList);
	    	dao.insertSelection(flatSelectionList);
		    result = "성공"; 
	    } catch (Exception e) {
		    e.printStackTrace();
		    return "실패";
	    }
		
		return result;
	}

	@Override
	public String updateSurvey(SurveyVO surveyVO) {
		// subjectList에 있는 참여대상들을 하나로 합쳐서 subject column에 넣을 준비
		surveyVO.setSubject(String.join(", ", surveyVO.getSubjectList()));

		String result = "";
		
		try {
			dao.updateSurvey(surveyVO);
			result = "성공";
		} catch (Exception e) {
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}
	
	@Override
	@Transactional
	public String deleteSurvey(SurveyVO surveyVO) {
		String result = "";
		
		try {
			dao.deleteSurvey(surveyVO);
			dao.deleteSurveyQuestion(surveyVO);
			dao.deleteSurveySelection(surveyVO);
			result = "성공";
		} catch (Exception e) {
			e.printStackTrace();
			result = "실패";
		}
		return result;
	}
	

	@Override
	public List<QuestionVO> getQuestionListForManage(SurveyVO surveyVO) {
		return dao.selectQuestionListForManage(surveyVO);
	}
	
	@Override
	@Transactional
	public String updSurveyQuestion(List<QuestionVO> deletedQuestionList
									, List<SelectionVO> deletedSelectionList
									, List<QuestionVO> updatedQuestionList
									, List<SelectionVO> updatedSelectionList
									, List<SelectionVO> addedSelectionListInExist
									, List<QuestionVO> addedQuestionSelectionListInExist
									, List<QuestionVO> newQuestionList) {
		
		String result = "";
		
		
		// deletedQuestionList: 삭제된 문항을 삭처리한다. 삭제될 문항의 선택지 번호로 해당 선택지들도 삭제
		if (deletedQuestionList != null && deletedQuestionList.size() > 0) {
			dao.deleteQuestionList(deletedQuestionList);
			dao.deleteSelectionListFromQuestionList(deletedQuestionList);
		}
		
		// deletedSelectionList: 오롯이 선택지 삭제로 인해 삭제된 선택지만 삭제
		if (deletedSelectionList != null && deletedSelectionList.size() > 0) {
			dao.deleteSelectionList(deletedSelectionList);
		}
		
		// updatedQuestionList: 수정된 문항들 수정
		if (updatedQuestionList != null && updatedQuestionList.size() > 0) {
			dao.updateQuestionList(updatedQuestionList);
		}
		
		// updatedSelectionList: 수정된 선택지들 수정
		if (updatedSelectionList != null && updatedSelectionList.size() > 0) {
			dao.updateSelectionList(updatedSelectionList);
		}
		
		// addedSelectionListInExist: 기존 문항에 추가된 선택지들 insert
		// selection_ordr의 max+1 값을 가져와서 + foreach인덱스로 insert
		if (addedSelectionListInExist != null && addedSelectionListInExist.size() > 0) {
			int selectionOrdr = dao.selectMaxSelectionOrdr(addedSelectionListInExist.get(0));
			for (SelectionVO vo : addedSelectionListInExist) {
				vo.setSelection_ordr(selectionOrdr);
			}
			dao.insertAddedSelectionListInExist(addedSelectionListInExist);
		}
		
		
		// addedQuestionSelectionListInExist: 기존 대문항에 추가된 소문항과 선택지를 insert
		// 동일 레벨화하여, 소문항만큼의 sequence와 선택지만큼의 sequence를 가져와서 입력 후 insert
		
		
		if (addedQuestionSelectionListInExist != null && addedQuestionSelectionListInExist.size() > 0) {
			List<QuestionVO> flatQuestionList = new ArrayList<>(); 		// addedQuestionSelectionListInExist 내부의 대문항과 소문항들을 순서대로 꺼내 담아서 동일 레벨화
			List<SelectionVO> flatSelectionList = new ArrayList<>(); 	// 보기를 가진 문항(일반 문항과 소문항)에서 보기들을 순서대로 꺼내 담아서 동일 레벨화
			int requiredQuestionSequenceCnt = 0; 						// 필요한 문항 sequence 개수
			int requiredSelectionSequenceCnt = 0; 						// 필요한 선택지 sequence 개수
			List<Integer> questionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 문항 sequence 목록
			List<Integer> selectionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 선택지 sequence 목록(한 문항 내의 모든 선택지는 같은 sequence 사용)

			/*
			 * <문항과 보기의 pk를 가져오기 위한 준비단계> 1. 문항 및 선택지 각각 동일 레벨화(내부의 객체를 꺼내서 순서대로 재배열) 2. 문항과
			 * 보기에 각각 할당할, 필요한 sequence 개수 파악
			 */
			for (QuestionVO questionVO : addedQuestionSelectionListInExist) {
				flatQuestionList.add(questionVO); 	// 동일 레벨화(문항)
				requiredQuestionSequenceCnt++; 		// 문항마다 추가

				requiredSelectionSequenceCnt++;
				List<SelectionVO> selectionList = questionVO.getSelectionList();
				for (SelectionVO selectionVO : selectionList) {
					flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
				}

			}

			// 필요한 sequence 목록 가져오기
			questionSequenceList = dao.selectQuestionSequenceList(requiredQuestionSequenceCnt);
			selectionSequenceList = dao.selectSelectionSequenceList(requiredSelectionSequenceCnt);

			// 가져온 문항 sequence를 문항에 할당.
			// 문항List들은 같은 addedQuestionSelectionListInExist를 참조하기 때문에 flatQuestionList에 할당하면 addedQuestionSelectionListInExist도 할당됨)
			for (int i = 0; i < questionSequenceList.size(); i++) {
				flatQuestionList.get(i).setQuestion_no(questionSequenceList.get(i));
			}

			// 첫 sequence와 마지막 sequence
			Integer currentSelectionSequence = selectionSequenceList.get(0);
			Integer lastSelectionSequence = selectionSequenceList.get(selectionSequenceList.size() - 1);

			// 가져온 선택지 sequence 할당
			for (int i = 0; i < addedQuestionSelectionListInExist.size(); i++) {
				try {
					if (currentSelectionSequence > lastSelectionSequence) {
						throw new IllegalStateException("선택지의 sequence가 잘못 할당되었습니다.");
					}
					
					// 각각의 대문항 selection_no fk에 선택지 sequence 할당
					addedQuestionSelectionListInExist.get(i).setSelection_no(currentSelectionSequence);

					List<SelectionVO> selectionList = addedQuestionSelectionListInExist.get(i).getSelectionList();
					for (SelectionVO selectionVO : selectionList) {
						selectionVO.setSelection_no(currentSelectionSequence);
					}

					// 한 sequence가 문항별 선택지에 할당되고 나면 1씩 증가. 즉, 선택지 있는 문항 할당한 다음 1증가.
					currentSelectionSequence++;
				} catch (IllegalStateException ilse) {
					System.out.println(ilse.getMessage());
					ilse.printStackTrace();
					return "시퀀스";

				} catch (Exception e) {
					e.printStackTrace();
					return "오류";
				}

			}

			
		    try {
		    	dao.insertQuestion(flatQuestionList);
		    	dao.insertSelection(flatSelectionList);
			    result = "성공"; 
		    } catch (Exception e) {
			    e.printStackTrace();
			    return "실패";
		    }
		}
		
	    
	    
	    // newQuestionList: 아예 새로운 대문항과 소문항과 선택지들. 설문등록 시 했던 것과 같은 insert
		if (newQuestionList != null && newQuestionList.size() > 0) {
			List<QuestionVO> flatQuestionList = new ArrayList<>(); 		// newQuestionList 내부의 대문항과 소문항들을 순서대로 꺼내 담아서 동일 레벨화
			List<SelectionVO> flatSelectionList = new ArrayList<>(); 	// 보기를 가진 문항(일반 문항과 소문항)에서 보기들을 순서대로 꺼내 담아서 동일 레벨화
			int requiredQuestionSequenceCnt = 0; 						// 필요한 문항 sequence 개수
			int requiredSelectionSequenceCnt = 0; 						// 필요한 선택지 sequence 개수
			List<Integer> questionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 문항 sequence 목록
			List<Integer> selectionSequenceList = new ArrayList<>(); 	// 필요한 만큼 select해온 선택지 sequence 목록(한 문항 내의 모든 선택지는 같은 sequence 사용)

			/*
			 * <문항과 보기의 pk를 가져오기 위한 준비단계> 1. 문항 및 선택지 각각 동일 레벨화(내부의 객체를 꺼내서 순서대로 재배열) 2. 문항과
			 * 보기에 각각 할당할, 필요한 sequence 개수 파악
			 */
			for (QuestionVO questionVO : newQuestionList) {
				flatQuestionList.add(questionVO); 	// 동일 레벨화(문항)
				requiredQuestionSequenceCnt++; 		// 문항마다 추가

				List<QuestionVO> childQuestionList = questionVO.getQuestionList();

				// 소문항이 있는 경우
				if (childQuestionList != null) {
					for (QuestionVO childQuestionVO : childQuestionList) {
						flatQuestionList.add(childQuestionVO); // 동일 레벨화(문항)
						requiredQuestionSequenceCnt++; // 문항마다 추가

						requiredSelectionSequenceCnt++; // 문항마다 선택지들은 하나의 selection sequence를 사용. 따라서 1만 증가
						List<SelectionVO> selectionList = childQuestionVO.getSelectionList();
						for (SelectionVO selectionVO : selectionList) {
							flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
						}
					}

					// 소문항이 없을 경우(자기 선택지가 있는 대문항)
				} else {
					requiredSelectionSequenceCnt++;
					List<SelectionVO> selectionList = questionVO.getSelectionList();
					for (SelectionVO selectionVO : selectionList) {
						flatSelectionList.add(selectionVO); // 동일 레벨화(선택지)
					}
				}

			}

			// 필요한 sequence 목록 가져오기
			questionSequenceList = dao.selectQuestionSequenceList(requiredQuestionSequenceCnt);
			selectionSequenceList = dao.selectSelectionSequenceList(requiredSelectionSequenceCnt);

			// 가져온 문항 sequence를 문항에 할당.
			// 문항List들은 같은 questionList를 참조하기 때문에 flatQuestionList에 할당하면 questionList도 할당됨)
			for (int i = 0; i < questionSequenceList.size(); i++) {
				flatQuestionList.get(i).setQuestion_no(questionSequenceList.get(i));
			}

			// 소문항의 parent_no에 대문항 sequence 할당
			for (QuestionVO questionVO : newQuestionList) {
				questionVO.setParent_no(0);	// 대문항들은 다 parent_no가 기본적으로 0
				List<QuestionVO> childQuestionList = questionVO.getQuestionList();
				if (childQuestionList != null) {
					for (QuestionVO childQuestionVO : childQuestionList) {
						childQuestionVO.setParent_no(questionVO.getQuestion_no());
					}
				}
			}

			// 첫 sequence와 마지막 sequence
			Integer currentSelectionSequence = selectionSequenceList.get(0);
			Integer lastSelectionSequence = selectionSequenceList.get(selectionSequenceList.size() - 1);

			// 가져온 선택지 sequence 할당
			for (int i = 0; i < newQuestionList.size(); i++) {
				List<QuestionVO> childQuestionList = newQuestionList.get(i).getQuestionList();

				try {
					// 소문항이 있는 경우
					if (childQuestionList != null) {

						// 소문항이 있는 대문항은 선택지가 없다. => selection_no = 0
						newQuestionList.get(i).setSelection_no(0);

						for (QuestionVO childQuestionVO : childQuestionList) {
							if (currentSelectionSequence > lastSelectionSequence) {
								throw new IllegalStateException("선택지의 sequence가 잘못 할당되었습니다.");
							}
							
							// 각각의 소문항 selection_no fk에 선택지 sequence 할당
							childQuestionVO.setSelection_no(currentSelectionSequence);

							List<SelectionVO> selectionList = childQuestionVO.getSelectionList();
							for (SelectionVO selectionVO : selectionList) {
								selectionVO.setSelection_no(currentSelectionSequence);
							}

							// 한 sequence가 문항별 선택지에 할당되고 나면 1씩 증가. 즉, 선택지 있는 문항 할당한 다음 1증가.
							currentSelectionSequence++;
						}

						// 소문항이 없는 대문항
					} else {
						if (currentSelectionSequence > lastSelectionSequence) {
							throw new IllegalStateException("선택지의 sequence가 잘못 할당되었습니다.");
						}
						
						// 각각의 대문항 selection_no fk에 선택지 sequence 할당
						newQuestionList.get(i).setSelection_no(currentSelectionSequence);

						List<SelectionVO> selectionList = newQuestionList.get(i).getSelectionList();
						for (SelectionVO selectionVO : selectionList) {
							selectionVO.setSelection_no(currentSelectionSequence);
						}

						// 한 sequence가 문항별 선택지에 할당되고 나면 1씩 증가. 즉, 선택지 있는 문항 할당한 다음 1증가.
						currentSelectionSequence++;
					}
				} catch (IllegalStateException ilse) {
					System.out.println(ilse.getMessage());
					ilse.printStackTrace();
					return "시퀀스";

				} catch (Exception e) {
					e.printStackTrace();
					return "오류";
				}

			}

			
		    try {
		    	dao.insertQuestion(flatQuestionList);
		    	dao.insertSelection(flatSelectionList);
			    result = "성공"; 
		    } catch (Exception e) {
			    e.printStackTrace();
			    return "실패";
		    }
		}
		if (result == "") {
			result = "성공";
		}
		
		return result;
	}

}
