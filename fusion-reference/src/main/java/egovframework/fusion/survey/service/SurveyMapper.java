package egovframework.fusion.survey.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.fusion.board.vo.SearchVO;
import egovframework.fusion.survey.vo.AnswerVO;
import egovframework.fusion.survey.vo.ParticipateVO;
import egovframework.fusion.survey.vo.QuestionCategoryVO;
import egovframework.fusion.survey.vo.QuestionVO;
import egovframework.fusion.survey.vo.SelectionVO;
import egovframework.fusion.survey.vo.SurveyVO;
import egovframework.fusion.survey.vo.TempAnswerVO;

@Mapper
public interface SurveyMapper {
	// 설문 목록 조회
	List<SurveyVO> selectSurveyList(SearchVO searchVO);

	// 설문 단건 조회
	SurveyVO selectSurvey(SurveyVO surveyVO);
	
	// 해당 설문에 대한 회원의 참여 목록 조회
	List<ParticipateVO> selectMemberParticipateList(ParticipateVO participateVO);
	
	// 해당 설문에 대한 문항 목록(ResultMap questionNSelection 시작 쿼리)
	List<QuestionVO> selectQuestionList(SurveyVO surveyVO);
	List<SelectionVO> selectSelectionList(QuestionVO questionVO);
	
	// 해당 설문에 대한 해당 회원의 참여 수 조회
	ParticipateVO selectParticipateCnt(ParticipateVO participateVO);
	
	// 임시 저장한 답변 수 조회
	int selectIsInTempAnswer(AnswerVO AnswerList);
	
	// 임시 저장한 답변목록 조회 
	List<TempAnswerVO> selectTempAnswerList(AnswerVO answerVO);
	
	// 임시 저장 답변 삭제
	int deleteTempAnswer(AnswerVO answerVO);
	
	// 설문 참여 입력
	int insertParticipate(ParticipateVO participateVO);
	
	// 설문 답변 목록 입력
	int insertAnswer(List<AnswerVO> AnswerList);
	
	// 임시 저장용 답변 입력
	int insertTempAnswer(List<AnswerVO> tempAnswerList);
	
	// 날짜를 조건으로 설문 목록 조회(날짜 조건은 아직 파라미터로 못 가져옴)
	List<SurveyVO> selectSurveyListforManage(SearchVO searchVO);
	
	// 문항 분류 목록 가져오기
	List<QuestionCategoryVO> selectQuestionCategoryList();
	
	// 설문정보 입력
	int insertSurvey(SurveyVO surveyVO);
	
	// 필요한 만큼 문항 sequence를 올리고 가져오기
	List<Integer> selectQuestionSequenceList(int requiredCnt);
	
	// 필요한 만큼 선택지 sequence를 올리고 가져오기
	List<Integer> selectSelectionSequenceList(int requiredCnt);
	
	// 문항들 입력
	int insertQuestion(List<QuestionVO> questionList);
	
	// 선택지들 입력
	int insertSelection(List<SelectionVO> SelectionList);
	
	// 설문 정보 수정
	int updateSurvey(SurveyVO surveyVO);
	
	// 설문 정보 삭제
	int deleteSurvey(SurveyVO surveyVO);

	// 해당 설문의 문항 삭제
	int deleteSurveyQuestion(SurveyVO surveyVO);
	
	// 해당 설문의 선택지 삭제
	int deleteSurveySelection(SurveyVO surveyVO);
	
	// 해당 설문에 대한 문항 목록 조회(resultMap 안의 resultMap 시작 쿼리)
	// ResultMap questionNSelectionForManage 
	// ResultMap childQuestionNSelectionForManage
	List<QuestionVO> selectQuestionListForManage(SurveyVO surveyVO);
	List<QuestionVO> selectChildQuestionList(QuestionVO questionVO);
	
	// 여러 문항 삭제
	int deleteQuestionList(List<QuestionVO> deletedQuestionList);
	
	// 문항 목록의 선택지 번호에 해당하는 여러 선택지 삭제
	int deleteSelectionListFromQuestionList(List<QuestionVO> deletedQuestionList);
	
	// 여러 선택지 삭제
	int deleteSelectionList(List<SelectionVO> deletedSelectionList);
	
	// 여러 문항 수정
	int updateQuestionList(List<QuestionVO> updatedQuestionList);
	
	// 여러 선택지 수정
	int updateSelectionList(List<SelectionVO> updatedSelectionList);
	
	// 해당 선택지 번호의 최고 높은 선택지 순서 + 1 값을 조회
	int selectMaxSelectionOrdr(SelectionVO selectionVO);
	
	// 같은 선택지 번호를 가진 여러 선택지들을, 선택지 순서를 높이면서 입력
	int insertAddedSelectionListInExist(List<SelectionVO> addedSelectionListInExist);

	// 통합검색
	List<SurveyVO> selectIntegSrchSurveyList(SearchVO searchVO);
}
