<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="/css/egovframework/all.css">
</head>
<body>
	<main class="mt-5 pt-5">
		<div class="container-fluid px-4 " >
			<h1 class="mt-4">설문 문항 관리(관리자 전용)</h1>
			<div class="card card-body">
			
				<!-- 전체 문항 정보 start -->
				<section class="card mb-4">
					<h4>문항 정보</h4>
					<button type="button" class="btn btn-info" id="goSurveyInfo">돌아가기</button>
					<div class="card-body" id="questionInfoForm">
						<button type="button" class="btn btn-primary btn-lg" id="addQuestionBtn">문항추가</button>
						
						
						<!-- 문항 정보 추가될 자리 -->
						<c:forEach items="${questionList}" var="question">
							
							<!-- 문항 정보 start -->
							<div class="card mb-4 questionInfoBox" data-question_no="${question.question_no}"
							                                       data-question_num="${question.question_num}"
							                                       data-parent_no="${question.parent_no}"
							                                       data-question_category_no="<c:if test='${empty question.question_category_no}'>0</c:if><c:if test='${not empty question.question_category_no}'>${question.question_category_no}</c:if>"
							                                       data-content="${question.content}"
							                                       data-necessity_yn="${question.necessity_yn}"
							                                       data-answer_cnt="${question.answer_cnt}"
							                                       data-selection_no="${question.selection_no}"
							                                       data-type="question"
							                                       data-type_detail="parent"
							                                       data-question_type="<c:if test='${empty question.questionList}'><c:if test='${not empty question.selectionList[0].selection_name}'>multipleChoice</c:if><c:if test='${empty question.selectionList[0].selection_name}'>shortForm</c:if></c:if><c:if test='${not empty question.questionList}'></c:if>">
								<div class="card-body questionInfoBoxBody question">
									<div class="questionNumNRemoveBtn">
										<div class="questionNumDiv">
											<span>문항 </span>
											<h4 class="questionNum"></h4>
											<span>.</span>
										</div>
										<button type="button" class="btn btn-danger questionRemoveBtn" onclick="questionRemoveBtn()">×</button>
									</div>
									<div class="questionInfoDiv question">
										<div class="questionInfo question">
											<div>
												<label for="questionContent">문항 내용</label>
												<input type="text" class="questionContent question" placeholder="문항 정보를 입력해주세요." value="${question.content}">
											</div>
											<div <c:if test="${not empty question.questionList}">style="display:none;"</c:if>>
												<div class="questionCondition">
													<span>① 문항 유형 : </span>
													<select class="multipleChoiceNShortForm question" onchange="multipleChoiceNShortFormSelect()">
														<c:if test="${not empty question.questionList}">
															<option value="" selected disabled>문항 유형을 선택하세요.</option>
															<option value="multipleChoice">객관식</option>
															<option value="shortForm">주관식</option>
														</c:if>
														<c:if test="${empty question.questionList}">
															<option value="" disabled>문항 유형을 선택하세요.</option>
															<option value="multipleChoice" <c:if test="${not empty question.selectionList[0].selection_name}">selected</c:if>>객관식</option>
															<option value="shortForm" <c:if test="${empty question.selectionList[0].selection_name}">selected</c:if>>주관식</option>
														</c:if>
													</select>
												</div>
												<div class="questionCondition">
												    <span>② 답변 유형 : </span>
													<select class="necessityYN question">
														<c:if test="${empty question.necessity_yn}">
															<option value="" selected disabled>답변 유형을 선택하세요.</option>
															<option value="Y">필수</option>
															<option value="N">자율</option>
														</c:if>
														<c:if test="${not empty question.necessity_yn}">
															<option value="" disabled>답변 유형을 선택하세요.</option>
															<option value="Y" <c:if test="${question.necessity_yn == 'Y'}">selected</c:if>>필수</option>
															<option value="N" <c:if test="${question.necessity_yn == 'N'}">selected</c:if>>자율</option>
														</c:if>
													</select>
												</div>
												<div class="questionCondition">
													<span>③ 답변 선택 수 : </span>
													<select class="answerCnt question">
														<c:if test="${question.answer_cnt == 0}"><option value="0" selected disabled></option></c:if>
														<option value="1" <c:if test="${question.answer_cnt == 1}">selected</c:if>>1개</option>
														<option value="2" <c:if test="${question.answer_cnt == 2}">selected</c:if>>2개</option>
														<option value="3" <c:if test="${question.answer_cnt == 3}">selected</c:if>>3개</option>
														<option value="4" <c:if test="${question.answer_cnt == 4}">selected</c:if>>4개</option>
														<option value="5" <c:if test="${question.answer_cnt == 5}">selected</c:if>>5개</option>
													</select>
												</div>
												<div class="questionCondition">
													<span>④ 문항 분류 : </span>
													<select class="questionCategory question">
														<option value=0>없음</option>
														<c:forEach items="${categoryList}" var="category">
															<option value="${category.question_category_no}"
																<c:if test="${category.question_category_no == question.question_category_no}">selected</c:if>>
																${category.question_category_name}
															</option>
														</c:forEach>
													</select>
												</div>
											</div>
										</div>
										<div>
											<button type="button" class="btn btn-secondary addChildQuestionBtn" onclick="addChildQuestionBtn()">소문항 추가</button>
										</div>
									</div>
									<!-- 선택지정보 start -->
									<c:if test="${not empty question.selectionList}">
										<hr>
										<!-- 객관식 start-->
										<c:if test="${not empty question.selectionList[0].selection_name}">
											<div class="selectionInfoBox">
												<div>
													<div class="selectionBtns">
														<button type="button" class="btn btn-info btn-sm" onclick="addSelectionInfoBtn()">선택지 추가</button> 또는
														<button type="button" class="btn btn-success btn-sm" onclick="addEtcSelectionInfoBtn()" 
															<c:if test="${question.selectionList[fn:length(question.selectionList) - 2].selection_name eq '기타'}">disabled</c:if>>
															기타 추가
														</button>
														<button type="button" class="btn btn-warning btn-sm" onclick="addNoneSelectionInfoBtn()"
															<c:if test="${question.selectionList[fn:length(question.selectionList) - 1].selection_name eq '없음'}">disabled</c:if>>
															없음 추가
														</button>
													</div>
													<div class="selectionsInfoBox">
														<!-- 일반 선택지 -->
														<div class="selectionsInfo">
															<c:forEach items="${question.selectionList}" var="selection">
																<c:if test="${selection.selection_name ne '기타' && selection.selection_name ne '없음'}">
																	<div class="selectionInfo" data-selection_no="${selection.selection_no}"
																	                           data-selection_ordr="${selection.selection_ordr}"
																	                           data-selection_name="${selection.selection_name}"
																	                           data-question_no="${question.question_no}"
																	                           data-type="selection">
																		<span>Ο</span> <input type="text" value="${selection.selection_name}" placeholder="선택지명을 입력하세요.">
																		<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
																	</div>
																</c:if>
															</c:forEach>
														</div>
														<!-- 기타 선택지 -->
														<div class="etcSelectionInfo">
															<c:if test="${question.selectionList[fn:length(question.selectionList) - 2].selection_name eq '기타'}">
																<div data-selection_no="${question.selectionList[fn:length(question.selectionList) - 2].selection_no}"
										                             data-selection_ordr="${question.selectionList[fn:length(question.selectionList) - 2].selection_ordr}"
										                             data-selection_name="${question.selectionList[fn:length(question.selectionList) - 2].selection_name}"
										                             data-question_no="${question.question_no}"
										                             data-type="selection">
																	<span>Ο</span> <input type="text" value="기타" disabled>
																 	<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
															 	</div>
														 	</c:if>
														</div>
														<!-- 없음 선택지 -->											
														<div class="noneSelectionInfo">
															<c:if test="${question.selectionList[fn:length(question.selectionList) - 1].selection_name eq '없음'}">
																<div data-selection_no="${question.selectionList[fn:length(question.selectionList) - 1].selection_no}"
										                             data-selection_ordr="${question.selectionList[fn:length(question.selectionList) - 1].selection_ordr}"
										                             data-selection_name="${question.selectionList[fn:length(question.selectionList) - 1].selection_name}"
										                             data-question_no="${question.question_no}"
										                             data-type="selection">
																	<span>Ο</span> <input type="text" value="없음" disabled>
															 		<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
															 	</div>
															 </c:if>
														</div>											
													</div>											
												</div>
											</div>
										</c:if>
										<!-- 객관식 end-->
										
										<!-- 주관식 start -->
										<c:if test="${empty question.selectionList[0].selection_name}">
											<div class="selectionInfoBox">
												<div>
													<div class="selectionsInfoBox">
														<div class="selectionsInfo">
															<div class="selectionInfo" data-selection_no="${question.selectionList[0].selection_no}"
														                               data-selection_ordr="${question.selectionList[0].selection_ordr}"
														                               data-selection_name="${question.selectionList[0].selection_name}"
														                               data-question_no="${question.question_no}"
														                               data-type="selection">
																<span>Ο</span> <input type="text" value="주관식" disabled>
															</div>
														</div>
													</div>
												</div>
											</div>
										</c:if>
										<!-- 주관식 end -->
										
									</c:if>
									<!-- 선택지정보 end -->
									
									
									<!-- 소문항 정보 start -->
									<c:forEach items="${question.questionList}" var="childQuestion">
										<div class="card mb-4 childQuestionInfoBox" data-question_no="${childQuestion.question_no}"
											                                        data-question_num="${childQuestion.question_num}"
											                                        data-parent_no="${childQuestion.parent_no}"
											                                        data-question_category_no="${childQuestion.question_category_no}"
											                                        data-content="${childQuestion.content}"
											                                        data-necessity_yn="${childQuestion.necessity_yn}"
											                                        data-answer_cnt="${childQuestion.answer_cnt}"
											                                        data-selection_no="${childQuestion.selection_no}"
											                                        data-type="question"
											                                        data-type_detail="child"
											                                        data-question_type="<c:if test='${not empty childQuestion.selectionList[0].selection_name}'>multipleChoice</c:if><c:if test='${empty childQuestion.selectionList[0].selection_name}'>shortForm</c:if>">
											<div class="card-body childQuestionInfoBoxBody childQuestion">
												<div class="questionNumNRemoveBtn">
													<div class="questionNumDiv">
														<h4 class="childQuestionNum"></h4>
														<span>.</span>
													</div>
													<button type="button" class="btn btn-danger questionRemoveBtn" onclick="childQuestionRemoveBtn()">×</button>
												</div>
												<div class="questionInfoDiv">
													<div class="questionInfo childQuestion">
														<div>
															<label for="questionContent">소문항 내용</label>
														<input type="text" class="questionContent childQuestion" placeholder="소문항 정보를 입력해주세요." value="${childQuestion.content}">
														</div>
														<div>
															<div class="questionCondition">
																<span>① 소문항 유형 : </span>
																<select class="multipleChoiceNShortForm childQuestion" onchange="multipleChoiceNShortFormSelect()">
																	<option value="" disabled>문항 유형을 선택하세요.</option>
																	<option value="multipleChoice" <c:if test="${not empty childQuestion.selectionList[0].selection_name}">selected</c:if>>객관식</option>
																	<option value="shortForm" <c:if test="${empty childQuestion.selectionList[0].selection_name}">selected</c:if>>주관식</option>
																</select>
															</div>
															<div class="questionCondition">
															    <span>② 답변 유형 : </span>
																<select class="necessityYN childQuestion">
																	<option value="" disabled>답변 유형을 선택하세요.</option>
																	<option value="Y" <c:if test="${childQuestion.necessity_yn == 'Y'}">selected</c:if>>필수</option>
																	<option value="N" <c:if test="${childQuestion.necessity_yn == 'N'}">selected</c:if>>자율</option>
																</select>
															</div>
															<div class="questionCondition">
																<span>③ 답변 선택 수 : </span>
																<select class="answerCnt childQuestion" value="${childQuestion.answer_cnt}">
																	<option value="1" <c:if test="${childQuestion.answer_cnt == 1}">selected</c:if>>1개</option>
																	<option value="2" <c:if test="${childQuestion.answer_cnt == 2}">selected</c:if>>2개</option>
																	<option value="3" <c:if test="${childQuestion.answer_cnt == 3}">selected</c:if>>3개</option>
																	<option value="4" <c:if test="${childQuestion.answer_cnt == 4}">selected</c:if>>4개</option>
																	<option value="5" <c:if test="${childQuestion.answer_cnt == 5}">selected</c:if>>5개</option>
																</select>
															</div>
															<div class="questionCondition">
																<span>④ 문항 분류 : </span>
																<select class="questionCategory childQuestion">
																	<option value=0>없음</option>
																	<c:forEach items="${categoryList}" var="category">
																		<option value="${category.question_category_no}"
																			<c:if test="${category.question_category_no == childQuestion.question_category_no}">selected</c:if>>
																			${category.question_category_name}
																		</option>
																	</c:forEach>
																</select>
															</div>
														</div>
													</div>
												</div>
												
												<!-- 선택지정보 start -->
												<c:if test="${not empty childQuestion.selectionList}">
													<hr>
													<!-- 객관식 start-->
													<c:if test="${not empty childQuestion.selectionList[0].selection_name}">
														<div class="selectionInfoBox">
															<div>
																<div class="selectionBtns">
																	<button type="button" class="btn btn-info btn-sm" onclick="addSelectionInfoBtn()">선택지 추가</button> 또는
																	<button type="button" class="btn btn-success btn-sm" onclick="addEtcSelectionInfoBtn()" 
																		<c:if test="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 2].selection_name eq '기타'}">disabled</c:if>>
																		기타 추가
																	</button>
																	<button type="button" class="btn btn-warning btn-sm" onclick="addNoneSelectionInfoBtn()"
																		<c:if test="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 1].selection_name eq '없음'}">disabled</c:if>>
																		없음 추가
																	</button>
																</div>
																<div class="selectionsInfoBox">
																	<!-- 일반 선택지 -->
																	<div class="selectionsInfo">
																		<c:forEach items="${childQuestion.selectionList}" var="selection">
																			<c:if test="${selection.selection_name ne '기타' && selection.selection_name ne '없음'}">
																				<div class="selectionInfo" data-selection_no="${selection.selection_no}"
																			                               data-selection_ordr="${selection.selection_ordr}"
																			                               data-selection_name="${selection.selection_name}"
																			                               data-question_no="${question.question_no}"
																			                               data-type="selection">
																					<span>Ο</span> <input type="text" value="${selection.selection_name}" placeholder="선택지명을 입력하세요.">
																					<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
																				</div>
																			</c:if>
																		</c:forEach>
																	</div>
																	<!-- 기타 선택지 -->
																	<div class="etcSelectionInfo">
																		<c:if test="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 2].selection_name eq '기타'}">
																			<div data-selection_no="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 2].selection_no}"
													                             data-selection_ordr="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 2].selection_ordr}"
													                             data-selection_name="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 2].selection_name}"
													                             data-question_no="${question.question_no}"
													                             data-type="selection">
																				<span>Ο</span> <input type="text" value="기타" disabled>
																			 	<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
																		 	</div>
																	 	</c:if>
																	</div>
																	<!-- 없음 선택지 -->											
																	<div class="noneSelectionInfo">
																		<c:if test="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 1].selection_name eq '없음'}">
																			<div data-selection_no="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 1].selection_no}"
													                             data-selection_ordr="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 1].selection_ordr}"
													                             data-selection_name="${childQuestion.selectionList[fn:length(childQuestion.selectionList) - 1].selection_name}"
													                             data-question_no="${question.question_no}"
													                             data-type="selection">
																				<span>Ο</span> <input type="text" value="없음" disabled>
																		 		<button type="button" class="btn btn-danger selectionRemoveBtn" onclick="selectionInfoRemoveBtn()">×</button>
																		 	</div>
																		 </c:if>
																	</div>											
																</div>											
															</div>
														</div>
													</c:if>
													<!-- 객관식 end-->
													
													<!-- 주관식 start -->
													<c:if test="${empty childQuestion.selectionList[0].selection_name}">
														<div class="selectionInfoBox">
															<div>
																<div class="selectionsInfoBox">
																	<div class="selectionsInfo">
																		<div class="selectionInfo" data-selection_no="${childQuestion.selectionList[0].selection_no}"
																	                               data-selection_ordr="${childQuestion.selectionList[0].selection_ordr}"
																	                               data-selection_name="${childQuestion.selectionList[0].selection_name}"
																	                               data-question_no="${question.question_no}"
																	                               data-type="selection">
																			<span>Ο</span> <input type="text" value="주관식" disabled>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</c:if>
													<!-- 주관식 end -->
													
												</c:if>
												<!-- 선택지정보 end -->
												
												
											</div>
										</div>
									</c:forEach>
									<!-- 소문항 정보 end -->
									
								</div>
							</div>
							<!-- 문항 정보 end -->
						</c:forEach>
						
					</div>
				</section>
				<!-- 전체 문항 정보 end -->
				
				<button type="button" class="btn btn-success btn-lg" id="surveyUpdateBtn">설문 수정</button>
			
			</div>
		</div>
	</main>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		
	
		$(document).ready(function() {
			$('#${menuType}').addClass('selected-menu');
			
			let notAllowMessage = '${notAllowMessage}';
			if (notAllowMessage != null && notAllowMessage != "") {
				alert(notAllowMessage);
			}
			
			goSurveyInfo();
			addQuestionBtn();					// 문항 추가
			grantQuestionNum();					// 문항 번호 부여
			$(document).click();				// 문항 번호 부여 작동
			validationNUpdate();				// 검증 후 수정
		});
		
		// 제목 클릭 시 해당 설문조사 페이지로
		function goSurveyInfo() {
			$('#goSurveyInfo').on('click', function() {
				let $form = $("<form>").attr('action', '/survey/surveyInfoToManage.do')
						                .attr('method', 'post')
						                .css('display', 'none')
						                .appendTo($('body'));
						let $input = $('<input>').attr('type', 'hidden')
											 .attr('name', 'survey_no')
											 .val('${questionList[0].survey_no}')
											 .appendTo($form);
						let $menuTypeInput = $('<input>').attr('type', 'hidden')
										              .attr('name', 'menuType')
										              .val('${menuType}')
										              .appendTo($form);
						$form.submit();	
			})
			
		}
		
		// 문항 추가 버튼
		function addQuestionBtn() {
			$('#addQuestionBtn').on('click', function() {

				// 문항 정보 만들기
				let questionInfoBox = `<!-- 문항 정보 start -->
					<div class="card mb-4 questionInfoBox new newQuestion">
						<div class="card-body questionInfoBoxBody question">
							<div class="questionNumNRemoveBtn">
								<div class="questionNumDiv">
									<span>문항 </span>
									<h4 class="questionNum"></h4>
									<span>.</span>
								</div>
								<button type="button" class="btn btn-danger questionRemoveBtn" onclick="questionRemoveBtn()">×</button>
							</div>
							<div class="questionInfoDiv question">
								<div class="questionInfo question">
									<div>
										<label for="questionContent">문항 내용</label>
										<input type="text" class="questionContent question" placeholder="문항 정보를 입력해주세요.">
									</div>
									<div>
										<div class="questionCondition">
											<span>① 문항 유형 : </span>
											<select class="multipleChoiceNShortForm question" onchange="multipleChoiceNShortFormSelect()">
												<option value="" disabled selected>문항 유형을 선택하세요.</option>
												<option value="multipleChoice">객관식</option>
												<option value="shortForm">주관식</option>
											</select>
										</div>
										<div class="questionCondition">
										    <span>② 답변 유형 : </span>
											<select class="necessityYN question">
												<option value="" disabled selected>답변 유형을 선택하세요.</option>
												<option value="Y">필수</option>
												<option value="N">자율</option>
											</select>
										</div>
										<div class="questionCondition">
											<span>③ 답변 선택 수 : </span>
											<select class="answerCnt question">
												<option value="1">1개</option>
												<option value="2">2개</option>
												<option value="3">3개</option>
												<option value="4">4개</option>
												<option value="5">5개</option>
											</select>
										</div>
										<div class="questionCondition">
											<span>④ 문항 분류 : </span>
											<select class="questionCategory question">
												<option value=0>없음</option>
												<c:forEach items="${categoryList}" var="category">
													<option value=${category.question_category_no}>${category.question_category_name}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
								<div>
									<button type="button" class="btn btn-secondary addChildQuestionBtn" onclick="addChildQuestionBtn()">소문항 추가</button>
								</div>
							</div>
						</div>
					</div>
					<!-- 문항 정보 end -->`;
				
				// 전체 문항정보 안에 넣기
				$('#questionInfoForm').append(questionInfoBox)
			})
		}
		
		
		// 대문항 삭제 버튼
		function questionRemoveBtn() {
			$(event.target).parent().parent().parent().remove();
		}
		
		
		// 소문항 추가 버튼
		function addChildQuestionBtn() {
			// 대문항 답변 수 0으로 만들고, 대문항 조건들 display:none 처리
			let $questionInfoDiv = $(event.target).parent().parent();
			$questionInfoDiv.find('.multipleChoiceNShortForm').val('');
			$questionInfoDiv.find('.necessityYN').val('');
			$questionInfoDiv.find('.answerCnt').val(0);
			$questionInfoDiv.find('.questionCategory').val(0);
			$questionInfoDiv.find('.questionInfo > div:last').css('display', 'none');
			
			// 소문항이 없다면(소문항이 있을 때는 소문항의 선택지가 지워지니깐)
			let $questionInfoBoxBody = $questionInfoDiv.parent(); 
			if ($questionInfoBoxBody.find('.childQuestionInfoBox').length == 0) {
				// 대문항 선택지 생성되어 있으면 hr이랑 선택지 삭제.
				let $hr = $questionInfoBoxBody.find('hr');
				if ($hr.length > 0) {
					$hr.remove();
					$questionInfoBoxBody.find('.selectionInfoBox').remove();
				}				
			}
			
			
			// 소문항 append할 곳
			let $childQuestionInfoBoxAppendLocation = $(event.target).parent().parent().parent();
			
			// 소문항 정보 만들기
			let childQuestionInfoBox = `<!-- 소문항 정보 start -->
				<div class="card mb-4 childQuestionInfoBox new newChildQuestion">
					<div class="card-body childQuestionInfoBoxBody childQuestion">
						<div class="questionNumNRemoveBtn">
							<div class="questionNumDiv">
								<h4 class="childQuestionNum"></h4>
								<span>.</span>
							</div>
							<button type="button" class="btn btn-danger questionRemoveBtn" onclick="childQuestionRemoveBtn()">×</button>
						</div>
						<div class="questionInfoDiv">
							<div class="questionInfo childQuestion">
								<div>
									<label for="questionContent">소문항 내용</label>
									<input type="text" class="questionContent childQuestion" placeholder="소문항 정보를 입력해주세요.">
								</div>
								<div>
									<div class="questionCondition">
										<span>① 소문항 유형 : </span>
										<select class="multipleChoiceNShortForm childQuestion" onchange="multipleChoiceNShortFormSelect()">
											<option value="" disabled selected>소문항 유형을 선택하세요.</option>
											<option value="multipleChoice">객관식</option>
											<option value="shortForm">주관식</option>
										</select>
									</div>
									<div class="questionCondition">
									    <span>② 답변 유형 : </span>
										<select class="necessityYN childQuestion">
											<option value="" disabled selected>답변 유형을 선택하세요.</option>
											<option value="Y">필수</option>
											<option value="N">자율</option>
										</select>
									</div>
									<div class="questionCondition">
										<span>③ 답변 선택 수 : </span>
										<select class="answerCnt childQuestion">
											<option value="1">1개</option>
											<option value="2">2개</option>
											<option value="3">3개</option>
											<option value="4">4개</option>
											<option value="5">5개</option>
										</select>
									</div>
									<div class="questionCondition">
										<span>④ 문항 분류 : </span>
										<select class="questionCategory childQuestion">
											<option value=0>없음</option>
											<c:forEach items="${categoryList}" var="category">
												<option value=${category.question_category_no}>${category.question_category_name}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 소문항 정보 end -->`;
				
			$childQuestionInfoBoxAppendLocation.append(childQuestionInfoBox);
		}
		
		// 소문항 삭제 버튼
		function childQuestionRemoveBtn() {
			let $questionInfoBoxBody = $(event.target).parent().parent().parent().parent().parent();
			
			// 지금 없어질 소문항이 마지막이라면
			// 대문항 답변 선택 수 1로 바꾸고 대문항 정보들 display:block처리
			let childQuestionInfoBoxCnt = $questionInfoBoxBody.find('.childQuestionInfoBox').length;
			if (childQuestionInfoBoxCnt == 1) {
				$questionInfoBoxBody.find('.questionInfo:first > div:last').css('display', 'block');
				$questionInfoBoxBody.find('.questionInfo:first > div:last').find('.answerCnt').val(1);
			}
			
			// 소문항 삭제
			$(event.target).parent().parent().parent().remove();
		}
		
		
		
		// 객관식주관식 select태그 change이벤트
		function multipleChoiceNShortFormSelect() {
			// 객관식 선택 시 아래에 선택지 지워주고 넣기.
			
			let $select = $(event.target);
			// 선택지 append할 때 위치의 태그
			let $selectionInfoBoxAppendLocation = $select.parent().parent().parent().parent().parent();
			// 선택지를 hr태그 아래에 만듦. 따라서 hr태그가 있으면 이미 선택지가 있음.
			let isInHr = ($selectionInfoBoxAppendLocation.find('hr').length > 0) ? true : false;
			
			// 이미 존재하면 hr, 선택지 정보 지워주기
			if (isInHr) {
				$selectionInfoBoxAppendLocation.find('hr').remove();
				$selectionInfoBoxAppendLocation.find('.selectionInfoBox').remove();
			}
			
			// 객관식 주관식 구별해서 넣어주기
			if ($select.val() == 'multipleChoice') {
				
				$select.parent().parent().find('.answerCnt').attr('disabled', false);
				
				let selectionInfoBox = `<hr>
					<!-- 선택지 정보 start -->
					<div class="selectionInfoBox">
						<div>
							<div class="selectionBtns">
								<button type="button" class="btn btn-info btn-sm" onclick="addSelectionInfoBtn()">선택지 추가</button> 또는
								<button type="button" class="btn btn-success btn-sm" onclick="addEtcSelectionInfoBtn()">기타 추가</button>
								<button type="button" class="btn btn-warning btn-sm" onclick="addNoneSelectionInfoBtn()">없음 추가</button>
							</div>
							<div class="selectionsInfoBox">
								<div class="selectionsInfo">
									<div class="selectionInfo newSelection">
										<span>Ο</span> <input type="text" placeholder="선택지명을 입력하세요.">
										<button type="button" class="btn btn-danger selectionRemoveBtn"
										                      onclick="selectionInfoRemoveBtn()">×</button>
									</div>
								</div>
								<!-- 기타와 없음은 아래쪽에 위치하도록함. 기타는 prepend. 없음은 append -->
								<div class="etcSelectionInfo"></div>											
								<div class="noneSelectionInfo"></div>											
								</div>											
							</div>
						</div>
					</div>
					<!-- 선택지 정보 end -->`;
					
				$selectionInfoBoxAppendLocation.append(selectionInfoBox);
					
			} else if ($select.val() == 'shortForm') {
				// 답변 선택 수 1개로 하고 선택 불가능하게
				$select.parent().parent().find('.answerCnt').val(1).attr('disabled', true);
				
				// 주관식
				let selectionInfoBox = `<hr>
					<!-- 선택지 정보 start -->
					<div class="selectionInfoBox">
						<div>
							<div class="selectionsInfoBox">
								<div class="selectionsInfo">
									<div class="selectionInfo newSelection">
										<span>Ο</span> <input type="text" value="주관식" disabled>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 선택지 정보 end -->`;
					
				$selectionInfoBoxAppendLocation.append(selectionInfoBox);
			}
		}
		
		// 선택지 추가 버튼
		function addSelectionInfoBtn() {
			let $selectionInfoAppendLocation = $(event.target).parent().parent().find('.selectionsInfo');
			let selectionInfo = `<div class="selectionInfo newSelection">
									<span>Ο</span> <input type="text" placeholder="선택지명을 입력하세요.">
									<button type="button" class="btn btn-danger selectionRemoveBtn"
									                      onclick="selectionInfoRemoveBtn()">×</button>
								</div>`;
			$selectionInfoAppendLocation.append(selectionInfo);
			
			// 기타와 없음은 selection_ordr이 제일 마지막에 위치해야하기 때문에,
			// 일반 선택지 추가 시 기타와없음을 지우고 다시 추가해서, 수정될 때 기존 기타와없음은 지워주고 새로 기타와없음을 넣어준다.
			let $etcSelectionInfo = $(event.target).parent().parent().find('.etcSelectionInfo');
			let $noneSelectionInfo = $(event.target).parent().parent().find('.noneSelectionInfo');
			let $etcSelectionRemoveBtn = $etcSelectionInfo.find('.selectionRemoveBtn');
			let $noneSelectionRemoveBtn = $noneSelectionInfo.find('.selectionRemoveBtn');
			let $etcSelectionAddBtn = $(event.target).next();
			let $noneSelectionAddBtn = $(event.target).next().next();
			
			if ($etcSelectionRemoveBtn.length > 0) {
				$etcSelectionInfo.empty();
				$etcSelectionAddBtn.attr('disabled', false);
				$etcSelectionAddBtn.click();
				$etcSelectionAddBtn.attr('disabled', true);
			}
			if ($noneSelectionRemoveBtn.length > 0) {
				$noneSelectionInfo.empty();
				$noneSelectionAddBtn.attr('disabled', false);
				$noneSelectionAddBtn.click();
				$noneSelectionAddBtn.attr('disabled', true);
			}
			
		}
		
		// 기타 선택지 추가 버튼
		function addEtcSelectionInfoBtn() {
			let $etcSelectionInfoAppendLocation = $(event.target).parent().parent().find('.etcSelectionInfo');
			
			// 기타 선택지가(input) 없을 때만 추가
			if ($etcSelectionInfoAppendLocation.find('input').length == 0) {
				let etcSelectionInfo = `<div class="newSelection">
											<span>Ο</span> <input type="text" value="기타" disabled>
										 	<button type="button" class="btn btn-danger selectionRemoveBtn"
										 					   onclick="selectionInfoRemoveBtn()">×</button>
									 	</div>`;
				$etcSelectionInfoAppendLocation.append(etcSelectionInfo);
				$(event.target).attr('disabled', true);
			}
			
		}
		
		
		// 없음 선택지 추가 버튼
		function addNoneSelectionInfoBtn() {
			let $noneSelectionInfoAppendLocation = $(event.target).parent().parent().find('.noneSelectionInfo');
			
			// 없음 선택지가 없을 때만 추가
			if ($noneSelectionInfoAppendLocation.find('input').length == 0) {
				let noneSelectionInfo = `<div class="newSelection">
											<span>Ο</span> <input type="text" value="없음" disabled>
									 		<button type="button" class="btn btn-danger selectionRemoveBtn"
									 					   onclick="selectionInfoRemoveBtn()">×</button>
									 	</div>`;
				$noneSelectionInfoAppendLocation.append(noneSelectionInfo);
				$(event.target).attr('disabled', true);
			}
		}
		
		
		// 선택지 삭제 버튼
		function selectionInfoRemoveBtn() {
			let $selectionsInfoBox = $(event.target).parent().parent().parent()
			let selectionInfoCnt = $(event.target).parent().parent().parent().find('input').length;
			let answerCnt = $selectionsInfoBox.parent().parent().parent().find('.answerCnt').val();
			
			// 선택지 수가 답변 선택 수보다 적으면 안된다. 
			if (selectionInfoCnt <= answerCnt) {
				alert('답변 선택 수보다 선택지가 적습니다.');
				return;
			}
			
			// 만약 기타나 없음 선택지를 없앴으면 기타/없음버튼을 돌려놓는다.
			let selectionInfoVal = $(event.target).prev().val();
			let $selectionBtns = $(event.target).parent().parent().parent().parent().find('.selectionBtns > button');
			if (selectionInfoVal == '기타') {
				$selectionBtns[1].disabled = false;
			} else if (selectionInfoVal == '없음') {
				$selectionBtns[2].disabled = false;
			}
			
			// 삭제
			$(event.target).parent().remove();
		}
		
		// 문항 번호 입력
		function grantQuestionNum() {
			// 모든 클릭에 실행
			$(document).on('click', function() {
				let $questionInfoBoxs = $('.questionInfoBox');	// 대문항
				$questionInfoBoxs.each(function(idx, item) {
					$(item).find('.questionNum').text(idx + 1);	// 대문항 번호 부여
					let questionNum = idx + 1;					// 부여한 대문항 번호 보관 
					
					// 소문항들 번호에 '대문항번호-X'로 입력
					let $childQuestionNums = $(item).find('.childQuestionNum');
					$childQuestionNums.each(function(childIdx, childItem) {
						$(childItem).text(questionNum + '-' + (childIdx + 1));
					});
				});
			});
		}
		
		
		// 서버에서 동일 레벨화해서 가져온 문항,선택지 목록
		var flatQuestionList = ${flatQuestionList1};
		var flatQuestionList_copy = ${flatQuestionList2};
		var flatSelectionList = ${flatSelectionList2};
		var flatSelectionList_copy = ${flatSelectionList2};
		
		// 삭제해야할 문항목록 가져오기(삭제할 문항들. 이 문항들이 가진 selection_no로 해당되는 선택지도 삭제할 예정)
		function getDeletedQuestionList() {
			/* 
				서버에서 동일레벨화 문항 복사본
				남아있는 기존의 문항들.
				삭제해야할 문항들 담을 리스트
			*/
			let $flatQuestionList_copy = $(flatQuestionList_copy);
			let $existingQuestions = $('[data-type=question]');
			
			
			// DB에서 가져온 기존 문항정보에서 현재 남아있는 기존 문항정보를 제거한다.
			for (let i = 0; i < $flatQuestionList_copy.length; i++) {
					let flat = $flatQuestionList_copy[i].question_no;
					
				for (let j = 0; j < $existingQuestions.length; j++) {
					let existing = Number($existingQuestions[j].dataset.question_no);
					if (flat == existing) {
						delete $flatQuestionList_copy[i];
					}
				}
			}
			
			// 위의 작업으로, 현재 사라진 것들을 제외하고 다 deletedQuestionList에 넣는다.
			let deletedQuestionList = [];
			for (let toDelete of $flatQuestionList_copy) {
				if (toDelete != undefined) {
					deletedQuestionList.push(toDelete);
				}
			}
			
			console.log('deletedQuestionList', deletedQuestionList);
			
			return deletedQuestionList;
		}
		
		// 삭제해야할 선택지 목록 가져오기(특별히 타겟팅해서 삭제할 선택지들)
		function getDeletedSelectionList(deletedQuestionList) {
			let selectionNoSet = new Set();
			let $selectionNoList = [];	// 문항 삭제로 인해 미리 삭제될 selection_no들
			
			// 삭제할문항리스트가 가진 selection_no들 추출
			for (let tempQuestion of deletedQuestionList) {
				// selection_no가 0인 것은 담지 않는다.
				if (tempQuestion.selection_no == 0) {
					continue;
				}
				selectionNoSet.add(tempQuestion.selection_no);
			}
			
			// 문항 삭제로 인해 미리 삭제될 selection_no들
			$selectionNoList = $(Array.from(selectionNoSet));
			
			let $flatSelectionList_copy = $(flatSelectionList);		// 서버에서 가져온 기존 선택지들
			let $existingSelections = $('[data-type=selection]');	// 현재 남은 기존 선택지들

			// 서버에서 가져온 원본 선택지에서 현재 남아있는 선택지들을 제거헤서 삭제된 선택지만 남긴다.
			$flatSelectionList_copy.each(function(idx, item) {
				$existingSelections.each(function(eIdx, eItem) {
					if (item.selection_no == eItem.dataset.selection_no && item.selection_ordr == eItem.dataset.selection_ordr) {
						delete $flatSelectionList_copy[idx];
					}
				})
			})
			
			// 삭제된 선택지들 중에 문항 삭제로 인해 미리 삭제될 선택지 번호에 해당하는 선택지는 제거한다.
			// 문항들에 의해 삭제된 선택지를 제외한, 오롯이 선택지 삭제에 의해서만 삭제된 선택지들만 남긴다. 
			$flatSelectionList_copy.each(function(idx, item) {
				if (item != undefined) {
					$selectionNoList.each(function(sIdx, sItem) {
						if (item.selection_no == sItem) {
							delete $flatSelectionList_copy[idx];
						}
					})
				}
			})
			
			let deletedSelectionList = [];
			
			// 선택지 삭제에 의해서만 삭제된 선택지들만 옮겨 담는다. 
			for (let toDelete of $flatSelectionList_copy) {
				if (toDelete != undefined) {
					deletedSelectionList.push(toDelete);
				}
			}
			console.log(deletedSelectionList);
			return deletedSelectionList;
		}
		
		// 수정해야할 문항목록 가져오기(해당 question_no의 모든 것을 update할 것들)
		function getUpdatedQuestionList() {
			let $existingQuestions = $('[data-type=question]');
			
			// 삭제되지 않고 남아있지만 수정된 문항 목록
			let updatedQuestionList = [];
			
			// 남아있는 기존 문항들의 수정여부 판단 후 updateQuestionList에 추가
			$existingQuestions.each(function(idx, item) {
				// 대문항일 때
				if (item.dataset.parent_no == 0) {
					let questionNum = $(item).find('.questionNum').text();
					let content = $(item).find('.questionContent.question').val();
					let questionType = $(item).find('.multipleChoiceNShortForm.question')[0].value;
					let necessityYN = $(item).find('.necessityYN.question')[0].value;
					let answerCnt = $(item).find('.answerCnt.question')[0].value;
					let questionCategory= $(item).find('.questionCategory.question').val();
					
					// 하나라도 다르면 바뀐값으로 문항정보 만들어서 넣어준다.
					if (item.dataset.question_num != questionNum ||
							item.dataset.content != content ||
							item.dataset.question_type != questionType ||
							item.dataset.necessity_yn != necessityYN ||
							item.dataset.answer_cnt != answerCnt ||
							item.dataset.question_category_no != questionCategory) {
						
						let questionData = {
								'question_no': Number(item.dataset.question_no),
								'survey_no': Number('${questionList[0].survey_no}'),
								'question_num': questionNum,
								'parent_no': 0,
								'question_category_no': Number(questionCategory),
								'content': content,
								'necessity_yn': necessityYN,
								'answer_cnt': Number(answerCnt),
						}
						
						// 소문항이 추가 되어 객관식주관식 구분 값이 없어졌다면 selection_no를 0으로
						if (questionType == null || questionType == '') {
							questionData.selection_no = 0;
						} else {
							questionData.selection_no = item.dataset.selection_no;
						}
						
						updatedQuestionList.push(questionData);
						
					}
					
				// 소문항일 때
				} else {
					let questionNum = $(item).find('.childQuestionNum').text();
					let content = $(item).find('.questionContent.childQuestion').val();
					let questionType = $(item).find('.multipleChoiceNShortForm.childQuestion')[0].value;
					let necessityYN = $(item).find('.necessityYN.childQuestion')[0].value;
					let answerCnt = $(item).find('.answerCnt.childQuestion').val();
					let questionCategory= $(item).find('.questionCategory.childQuestion').val();
					
					// 하나라도 다르면 바뀐값으로 문항정보 만들어서 넣어준다.
					if (item.dataset.question_num != questionNum ||
							item.dataset.content != content ||
							item.dataset.question_type != questionType ||
							item.dataset.necessity_yn != necessityYN ||
							item.dataset.answer_cnt != answerCnt ||
							item.dataset.question_category_no != questionCategory) {
						
						let childQuestionData = {
								'question_no': Number(item.dataset.question_no),
								'survey_no': Number('${questionList[0].survey_no}'),
								'question_num': questionNum,
								'parent_no': Number(item.dataset.parent_no),
								'question_category_no': Number(questionCategory),
								'content': content,
								'necessity_yn': necessityYN,
								'answer_cnt': Number(answerCnt),
								'selection_no': Number(item.dataset.selection_no)
						}
						
						updatedQuestionList.push(childQuestionData);
					}	
				}
				
			})
			console.log(updatedQuestionList);
			
			return updatedQuestionList;
		}
		
		
		// 수정해야할 선택지 가져오기(해당 selection_no이면서 selection_ordr인 것을 name만 바꿈)
		function getUpdatedSelectionList() {
			let $existingSelections = $('[data-type=selection]');
			
			// 삭제되지 않고 남아있지만 수정된 선택지 목록
			let updatedSelectionList = [];
			
			// 남아있는 기존 문항들의 수정여부 판단 후 updateQuestionList에 추가
			$existingSelections.each(function(idx, item) {
				// 주관식일 때는 selection_name이 ''임. 근데 input에는 주관식이라 적혀있음. 참고
				if (item.dataset.selection_name != '' && item.dataset.selection_name != $(item).find('input[type=text]').val()) {
					let selectionData = {
							'selection_no': Number(item.dataset.selection_no),
							'selection_ordr': Number(item.dataset.selection_ordr),
							'selection_name': $(item).find('input[type=text]').val()
					}
					
					updatedSelectionList.push(selectionData);
				}
			})
			
			console.log(updatedSelectionList);
			return updatedSelectionList;
		}
		
		
		// 기존에 존재하는 문항에 대해서 추가된 선택지 목록 가져오기(해당되는 selection_no에서 최고 ordr + 1해서 넣을 것들)
		function getAddedSelectionListInExist() {
			let $newAddedSelection = $('.newSelection');
			
			let addSelectionListInExist = [];
			
			$newAddedSelection.each(function(idx, item) {
				// 해당 선택지에 대한 대문항
				let $parentQuestion = $(item).parents('[data-type_detail=parent]');
				// 해당 선택지에 대한 소문항
				let $childQuestion = $(item).parents('[data-type_detail=child]');
				// 해당 선택지에 대한 새로운 소문항
				let $newChildQuestion = $(item).parents('.newChildQuestion');
				
				// 대문항 선택지에 추가된 경우
				if ($parentQuestion.length > 0 && $childQuestion.length == 0 && $newChildQuestion.length == 0) {
					
					let selection_no = $parentQuestion[0].dataset.selection_no;
					let selection_name = $(item).find('input[type=text]').val();
					
					if (selection_name == '주관식') {
						selection_name = '';
					}
					let selectionData = {
							'selection_no': selection_no,
							'selection_name': selection_name
					}
					
					addSelectionListInExist.push(selectionData);
					
				// 소문항 선택지에 추가된 경우
				} else if ($parentQuestion.length > 0 && $childQuestion.length > 0) {
					let selection_no = $childQuestion[0].dataset.selection_no;
					let selection_name = $(item).find('input[type=text]').val();
					
					if (selection_name == '주관식') {
						selection_name = '';
					}
					let selectionData ={
							'selection_no': selection_no,
							'selection_name': selection_name
					}
					
					addSelectionListInExist.push(selectionData);
				}
			})
			
			console.log(addSelectionListInExist);
			return addSelectionListInExist;
		}
		
		
		// 기존에 존재하는 대문항에 대해서 추가된 소문항과 선택지 목록 가져오기(question,selection 둘다 pk 받아와서 넣어서 insert해야함)
		function getAddedQuestionSelectionListInExist() {
			let $newAddedChildQuestion = $('.newChildQuestion');
			
			let addedQuestionSelectionListInExist = [];
			
			$newAddedChildQuestion.each(function(idx, item) {
				// 해당 문항의 대문항
				let $parentQuestion = $(item).parents('[data-type_detail=parent]');
				
				// 해당 문항의 기존 대문항이 존재할 시
				if ($parentQuestion.length > 0) {
					let questionNum = $(item).find('.childQuestionNum').text();
					let parentNo = Number($parentQuestion[0].dataset.question_no);
					let questionCategory = Number($(item).find('.questionCategory.childQuestion').val());
					let content = $(item).find('.questionContent.childQuestion').val();
					let necessityYN = $(item).find('.necessityYN.childQuestion').val();
					let answerCnt = Number($(item).find('.answerCnt.childQuestion').val());
					
					
					let questionData = {
							'survey_no': Number('${questionList[0].survey_no}'),
							'question_num': questionNum,
							'parent_no': parentNo,
							'question_category_no': questionCategory,
							'content': content,
							'necessity_yn': necessityYN,
							'answer_cnt': answerCnt,
							'selectionList': []
					}
					
					// 선택지들
					let $newChildQuestionSelection = $(item).find('.selectionInfoBox input[type=text]');
					
					$newChildQuestionSelection.each(function(sIdx, sItem) {
						// 주관식은 하나만 하고 패스
						if (sItem.value == '주관식') {
							let selectionData = {
									'selection_ordr': 1,
									'selection_name': ''
							}
							questionData.selectionList.push(selectionData);
							return false;
						}
						
						let selectionData = {
								'selection_ordr': sIdx + 1,
								'selection_name': sItem.value
						}
						
						questionData.selectionList.push(selectionData);
					})
					
					addedQuestionSelectionListInExist.push(questionData);
				}
			})
			console.log(addedQuestionSelectionListInExist);
			
			return addedQuestionSelectionListInExist;
		}
		
		
		// 완전 새로운 대문항과 소문항과 선택지들
		function getNewQuestionList() {
			let $newQuestion = $('.newQuestion');
			
			let newQuestionList = [];
			
			$newQuestion.each(function(idx, item) {
				let $newChildQuestion = $(item).find('.newChildQuestion');
				// 소문항 없는 경우
				if ($newChildQuestion.length == 0) {
					let questionNum = $(item).find('.questionNum').text();
					let questionCategory = Number($(item).find('.questionCategory.question').val());
					let content = $(item).find('.questionContent.question').val();
					let necessityYN = $(item).find('.necessityYN.question').val();
					let answerCnt = Number($(item).find('.answerCnt.question').val());
					
					let questionData = {
							'survey_no': Number('${questionList[0].survey_no}'),
							'question_num': questionNum,
							'question_category_no': questionCategory,
							'content': content,
							'necessity_yn': necessityYN,
							'answer_cnt': answerCnt,
							'selectionList': []
					}
					
					// 선택지 정보
					let $newSelection = $(item).find('.newSelection input[type=text]');
					
					$newSelection.each(function(sIdx, sItem) {
						// 주관식은 하나만 하고 패스
						if (sItem.value == '주관식') {
							let selectionData = {
									'selection_ordr': 1,
									'selection_name': ''
							}
							questionData.selectionList.push(selectionData);
							return false;
						}
						
						let selectionData = {
								'selection_ordr': sIdx + 1,
								'selection_name': sItem.value
						}
						
						questionData.selectionList.push(selectionData);
					})
					
					newQuestionList.push(questionData);
				// 소문항 있는 경우	
				} else {
					let questionNum = $(item).find('.questionNum').text();
					let questionCategory = 0;
					let content = $(item).find('.questionContent.question').val();
					let necessityYN = '';
					let answerCnt = 0;
					
					let questionData = {
							'survey_no': Number('${questionList[0].survey_no}'),
							'question_num': questionNum,
							'question_category_no': questionCategory,
							'content': content,
							'necessity_yn': necessityYN,
							'answer_cnt': answerCnt,
							'questionList': []
					}
					
					$newChildQuestion.each(function(childIdx, childItem) {
						// 소문항 정보들 셋팅
						let childQuestionNum = $(childItem).find('.childQuestionNum').text();
						let childQuestionCategory = Number($(childItem).find('.questionCategory.childQuestion').val());
						let childContent = $(childItem).find('.questionContent.childQuestion').val();
						let childNecessityYN = $(childItem).find('.necessityYN.childQuestion').val();
						let childAnswerCnt = Number($(childItem).find('.answerCnt.childQuestion').val());
						
						let childQuestionData = {
								'survey_no': Number('${questionList[0].survey_no}'),
								'question_num': childQuestionNum,
								'question_category_no': childQuestionCategory,
								'content': childContent,
								'necessity_yn': childNecessityYN,
								'answer_cnt': childAnswerCnt,
								'selectionList': []
						}
						
						// 선택지 정보
						let $newSelection = $(childItem).find('.newSelection input[type=text]');
						
						$newSelection.each(function(sIdx, sItem) {
							// 주관식은 하나만 하고 패스
							if (sItem.value == '주관식') {
								let selectionData = {
										'selection_ordr': 1,
										'selection_name': ''
								}
								childQuestionData.selectionList.push(selectionData);
								return false;
							}
							
							let selectionData = {
									'selection_ordr': sIdx + 1,
									'selection_name': sItem.value
							}
							
							childQuestionData.selectionList.push(selectionData);
						})
						
						questionData.questionList.push(childQuestionData);
					})
					
					newQuestionList.push(questionData);
				}
			})
			
			console.log(newQuestionList);
			return newQuestionList;
		}
		
		
		// 검증 후 수정.......
		function validationNUpdate() {
			
			$('#surveyUpdateBtn').on('click', function() {
				/*--------------------
				문항정보 검증
				--------------------*/
				
				// 서버로 들고 갈 대문항정보 배열
				let questionsList = [];
				// 대문항들
				let $questionInfos = $('.questionInfoBox');
				
				// 문항이 있는지 체크
				if ($questionInfos.length == 0) {
					alert('설문 문항이 없습니다. 문항을 추가해주세요.');
					setTimeout(()=> {$('#questionInfoForm').focus();}, 1);
					return;
				}
				
				try {
					
					$questionInfos.each(function(idx, item) {
						let $questionContent = $(item).find('.questionContent.question');
						
						// 문항 내용 체크
						if ($questionContent.val() == null || $questionContent.val().length == 0) {
							alert('문항 내용을 입력해주세요.')
							setTimeout(()=> {$questionContent.focus();}, 1);
							throw('noValue');
						}
						
						
						// 소문항이 없으면 대문항들 계속해서 검증
						let $childQuestionInfoBox = $(item).find('.childQuestionInfoBox');
						if ($childQuestionInfoBox.length == 0) {
							
							// 문항 유형 체크
							let $questionType = $(item).find('.multipleChoiceNShortForm.question');
							
							if ($questionType.val() == null || $questionType.val() == '') {
								alert('문항 유형을 선택해주세요.')
								setTimeout(()=> {$questionType.focus();}, 1);
								throw('noValue');
							} else if ($questionType.val() != null && $questionType.val() != '') {
								// 답변 유형(미리 가져옴)
								let $necessityYN = $(item).find('.necessityYN.question');
								
								// 답변 유형 체크
								if ($necessityYN.val() == null || $necessityYN.val() == '') {
									alert('답변 유형을 선택해주세요.')
									setTimeout(()=> {$necessityYN.focus();}, 1);
									throw('noValue');
								}
								
								
								// 대문항 정보들 셋팅
								let question_num = $(item).find('.questionNum').text();
								let question_category_no = Number($(item).find('.questionCategory.question').val());
								let content = $(item).find('.questionContent.question').val();
								let necessity_yn = $(item).find('.necessityYN.question').val();
								let answer_cnt = Number($(item).find('.answerCnt.question').val());
								let questionData = {
										'question_num': question_num,
										'question_category_no': question_category_no,
										'content': content,
										'necessity_yn': necessity_yn,
										'answer_cnt': answer_cnt,
										'selectionList': []
								}

								// 선택지 정보
								let $selectionsInfoBox = $(item).find('.selectionsInfoBox');
								// 선택지들
								let $selectionInput = $selectionsInfoBox.find('input');
								
								// 답변 수보다 선택지가 적을 경우 체크
								if ($selectionInput.length < answer_cnt) {
									alert('답변 수보다 선택지 수가 적습니다.');
									setTimeout(()=> {$(item).find('.answerCnt.question').focus();}, 1);
									throw('lackValue');
								}
								
								// 객관식 일 때
								if ($questionType.val() == 'multipleChoice') {
									
									// 작성한 선택지들을 검증
									$selectionInput.each(function(inputIdx, inputItem) {
										if ($(inputItem).val() == null || $(inputItem).val().length == 0) {
											alert('선택지명을 입력해주세요.')
											setTimeout(()=> {inputItem.focus();}, 1);
											throw('noValue');
										}
										
									});
									
								}								
								
							}
								
							
						// 소문항이 있을 때
						} else if ($childQuestionInfoBox.length > 0){
							/* 
							   대문항 정보들 셋팅: 문항 num이랑 문항 내용 값만 가져오면 됨.
							                   (나머지: 문항유형X,문항분류없음,답변유형없음,답변수0개)
							   대문항은 selectionList가 없고 questionList가 있다.
							*/ 
							
							let question_num = $(item).find('.questionNum').text();
							let question_category_no = 0;
							let content = $(item).find('.questionContent.question').val();
							let necessity_yn = ''
							let answer_cnt = 0;
							
							let questionData = {
									'question_num': question_num,
									'question_category_no': question_category_no,
									'content': content,
									'necessity_yn': necessity_yn,
									'answer_cnt': answer_cnt,
									'questionList': []
							}
							
							
							/*
								소문항들 가져와서 소문항 유형 빈값 체크
								소문항 답변 유형 빈값 체크
							*/
							// 소문항들 검증 시작
							$childQuestionInfoBox.each(function (childIdx, childItem) {
								
								let $childQuestionContent = $(childItem).find('.questionContent.childQuestion');
								
								// 문항 내용 체크
								if ($childQuestionContent.val() == null || $childQuestionContent.val().length == 0) {
									alert('소문항 내용을 입력해주세요.')
									setTimeout(()=> {$childQuestionContent.focus();}, 1);
									throw('noValue');
								}
								
								
								// 소문항 유형 체크
								let $questionType = $(childItem).find('.multipleChoiceNShortForm.childQuestion');
								
								if ($questionType.val() == null || $questionType.val() == '') {
									alert('소문항 유형을 선택해주세요.')
									setTimeout(()=> {$questionType.focus();}, 1);
									throw('noValue');
								} else if ($questionType.val() != null && $questionType.val() != '') {
									// 답변 유형(미리 가져옴)
									let $necessityYN = $(childItem).find('.necessityYN.childQuestion');
									
									// 답변 유형 체크
									if ($necessityYN.val() == null || $necessityYN.val() == '') {
										alert('소문항 답변 유형을 선택해주세요.')
										setTimeout(()=> {$necessityYN.focus();}, 1);
										throw('noValue');
									}
									
									
									// 소문항 정보들 셋팅
									let child_question_num = $(childItem).find('.childQuestionNum').text();
									let child_question_category_no = Number($(childItem).find('.questionCategory.childQuestion').val());
									let child_content = $(childItem).find('.questionContent.childQuestion').val();
									let child_necessity_yn = $(childItem).find('.necessityYN.childQuestion').val();
									let child_answer_cnt = Number($(childItem).find('.answerCnt.childQuestion').val());
									
									let childQuestionData = {
											'question_num': child_question_num,
											'question_category_no': child_question_category_no,
											'content': child_content,
											'necessity_yn': child_necessity_yn,
											'answer_cnt': child_answer_cnt,
											'selectionList': []
									}
									
									// 선택지 정보
									let $selectionsInfoBox = $(childItem).find('.selectionsInfoBox');
									// 선택지들
									let $selectionInput = $selectionsInfoBox.find('input');
									
									// 답변 수보다 선택지가 적을 경우 체크
									if ($selectionInput.length < child_answer_cnt) {
										alert('소문항 답변 수보다 선택지 수가 적습니다.');
										setTimeout(()=> {$(childItem).find('.answerCnt.childQuestion').focus();}, 1);
										throw('lackValue');
									}
									
									
									// 객관식 일 때
									if ($questionType.val() == 'multipleChoice') {
										
										// 작성한 선택지들을 검증
										$selectionInput.each(function(inputIdx, inputItem) {
											if ($(inputItem).val() == null || $(inputItem).val().length == 0) {
												alert('소문항 선택지명을 입력해주세요.')
												setTimeout(()=> {inputItem.focus();}, 1);
												throw('noValue');
											}
										});
									}
								}
							})
							
						// 알 수 없는 에러
						} else {
							throw('error');
						}
						
					})
					
				} catch (e) {
					if (e == 'noValue') {
						return false;
					} else if (e == 'lackValue') {
						return false;
					} else if (e == 'error') {
						alert('알 수 없는 오류입니다.');
						return false;
					}
				}
				
				
				
				
				if (confirm('수정하시겠습니까?')) {
					/*
					  삭제된 문항 리스트
					  선택지 삭제로 삭제된 선택지 리스트
					  수정된 문항 리스트
					  수정된 선택지 리스트
					  기존 대문항 소문항들에 추가된 선택지 리스트
					  기존 대문항에 추가된 소문항과선택지 리스트
					  완전 새로운 대문항과소문항과선택지 리스트
					*/
					let deletedQuestionList = getDeletedQuestionList();
					let deletedSelectionList = getDeletedSelectionList(deletedQuestionList);
					let updatedQuestionList = getUpdatedQuestionList();
					let updatedSelectionList = getUpdatedSelectionList();
					let addedSelectionListInExist = getAddedSelectionListInExist();
					let addedQuestionSelectionListInExist = getAddedQuestionSelectionListInExist();
					let newQuestionList = getNewQuestionList();
					
					$.ajax({
				    	url: '/survey/updSurveyQuestion.do',
						type: 'post',
						contentType: 'application/json',
						data: JSON.stringify({
							'deletedQuestionList': deletedQuestionList,
							'deletedSelectionList': deletedSelectionList,
							'updatedQuestionList': updatedQuestionList,
							'updatedSelectionList': updatedSelectionList,
							'addedSelectionListInExist': addedSelectionListInExist,
							'addedQuestionSelectionListInExist': addedQuestionSelectionListInExist,
							'newQuestionList': newQuestionList
						}),
						dataType: 'json',
						async: false,
				        success: function(data) {
					        alert(data.msg);
					        
				        	if (data.result == '성공') {
					        	location.href='/survey/surveyManage.do?menuType=${menuType}';
				        	}
				        },
						error: function(error) {
							console.log(error);
						}
				    })					
				}
				
			})
			
		}
		
		
		// 로그아웃
		function logout() {
			$.ajax({
				url: '/member/logout.do',
				success: function(data) {
					if (data.result == 1){
						alert(data.msg);
						location.href='/member/loginForm.do';
					} else {
						alert(data.msg);
					}
					
				},
				error: function(error) {
					console.log('통신실패');
					console.log(error);
				}
			});
		}
	</script>
</body>
</html>