package egovframework.fusion.survey.service;

import java.util.List;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ParticipateVO;
import egovframework.fusion.survey.vo.QuestionCategoryVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.SelectionVO;
import egovframework.fusion.survey.vo.SurveyVO;
import egovframework.fusion.survey.vo.TempAnswerVO;

public interface SurveyService {
	// 설문 게시판 설문 목록들
	List<SurveyVO> getBoardList(SearchVO searchVO);
	
	// 하나의 설문
	SurveyVO getSurvey(SurveyVO surveyVO);
	
	// 해당 설문에 대한 해당 회원의 참여 목록
	List<ParticipateVO> getMemberParticipateList(ParticipateVO participateVO);
	
	// 설문 참여대상, 참여기간, 참여횟수 검증
	String surveyValidate(SurveyVO surveyVO);
	
	// 해당 설문 화면에 필요한 문항(선택지포함) 목록(ResultMap questionNSelection)
	List<QuestionVO> getQuestionList(SurveyVO surveyVO);

	// 해당 멤버가 임시 저장한 답변 목록이 있는지 확인
	int isInTempAnswer(AnswerVO answerVO);

	// 임시 저장한 답변 가져오기
	List<TempAnswerVO> getTempAnswerList(AnswerVO answerVO);
	
	// 임시 저장된 답변 삭제하고 최종 답변 제출
	String changeTempToSubmit(List<AnswerVO> answerList);
	
	// 설문 답변 최종 제출
	String insSurveyAnswer(List<AnswerVO> answerList);

	// 답변 임시 저장
	String insSurveyTempAnswer(List<AnswerVO> tempAnswerList);
	
	// 기존 임시 저장 답변을 지우고 새 답변을 임시 저장
	String updSurveyTempAnswer(List<AnswerVO> tempAnswerList);
	
	// 설문 관리 페이지에 쓰일 설문 목록 가져오기
	List<SurveyVO> getSurveyListforManage(SearchVO searchVO);
	
	// 설문 작성 페이지에 쓰이는 문항 분류 목록 가져오기
	List<QuestionCategoryVO> getQuestionCategoryList();
	
	// 설문 등록(설문과 문항 및 선택지들)
	String insSurvey(SurveyVO surveyVO, List<QuestionVO> questionList);
	
	// 설문 정보 수정(문항X. only 설문 정보)
	String updateSurvey(SurveyVO surveyVO);
	
	// 설문 정보 삭제 및 설문에 종속된 문항, 선택지 삭제
	String deleteSurvey(SurveyVO surveyVO);

	// 설문 문항관리 페이지에 필요한 문항(선택지 포함) 목록
	//(ResultMap questionNSelectionForManage, childQuestionNSelectionForManage)
	List<QuestionVO> getQuestionListForManage(SurveyVO surveyVO);

	/* 
	 * 설문 문항정보 수정( 삭제된 문항 목록
	 *                , 삭제된 선택지 목록
	 *                , 수정된 문항 목록
	 *                , 수정된 선택지 목록
	 *                , 기존에 존재하는 문항에 추가된 선택지 목록
	 *                , 기존 대문항에 추가된 소문항 목록과 그에 담긴 선택지 목록
	 *                , 새로운 대문항과, 그에 담긴 소문항 목록 소문항 목록(설문등록에 쓰인 것과 같은)
	 */
	String updSurveyQuestion(List<QuestionVO> deletedQuestionList
							, List<SelectionVO> deletedSelectionList
							, List<QuestionVO> updatedQuestionList
							, List<SelectionVO> updatedSelectionList
							, List<SelectionVO> addedSelectionListInExist
							, List<QuestionVO> addedQuestionSelectionListInExist
							, List<QuestionVO> newQuestionList);

	

	
	
	
}
