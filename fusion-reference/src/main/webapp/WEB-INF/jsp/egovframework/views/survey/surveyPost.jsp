<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<div id="surveyPost-div">
	<div id="survey-header">
		<div id="progress-box">
			<h2>진행상황</h2>
			<progress id="progress" value="" min="0" max=""></progress>
			<span id="progress-percent"></span>
		</div>
		<div id="outNSaveBtn">
			<button type="button" class="btn btn-danger" id="outBtn">나가기</button>
			<c:if test="${not empty member_no && member_no != 0}">
				<button type="button" class="btn btn-secondary" id="tempSaveBtn">임시 저장</button>
			</c:if>
				<button type="button" class="btn btn-warning" id="answerSubmit">답변 제출</button>
		</div>
	</div>
	<!-- 자식을 가져서 선택지가 없는 부모들의 수 -->
	<c:set var="noSelectionCount" value="0"></c:set>

	<div class="question-page">
	<c:forEach items="${questionList }" var="question" varStatus="questionStt">
		
		<!-- question_no 0여부로 parent/child 분기 -->
		<c:if test="${question.parent_no == 0}">
			<c:set var="questionType" value="parent" />
		</c:if>
		<c:if test="${question.parent_no != 0}">
			<c:set var="questionType" value="child" />
		</c:if>
		
		
		
		
		<!-- 문항/문항번호/문항분류/문항내용 start-->
		<div class="${questionType}-question question-box" id="${question.question_no}"
											  data-question_no ="${question.question_no}"
		                                      data-question_num="${question.question_num}"
		                                      data-parent_no   ="${question.parent_no}"
		                                      data-necessity_yn="${question.necessity_yn}"
		                                      data-answer_cnt  ="${question.answer_cnt}"
		                                      data-selection_no="${question.selection_no}">
			<div class="question-title">
				<!-- 부모일 때만 '문항' 붙여주기 -->
				<c:if test="${questionType eq 'parent'}">
					<span>문항 </span>
				</c:if>
				<span>${question.question_num}.</span>
			</div>
			
			<div class="question-content">
				<div>
					<c:if test="${not empty question.question_category_name}">
						<span class="question-category-name">[${question.question_category_name}]</span>
					</c:if>
					<span>
						${question.content} 
					</span>
					<span class="necessity_yn">
						<!-- 답변필수여부가 자율이면 무조건 표시. 필수는 주관식일때만 표시 -->
						<c:if test="${question.necessity_yn == 'Y'}">
							<c:if test="${question.selection_no == 5}">
								(필수)
							</c:if>
						</c:if>
						<c:if test="${question.necessity_yn == 'N'}">
							<%-- <c:if test="${question.selection_no != 0}"> --%>
								(자율)
							</c:if>
						<%-- </c:if> --%>
					</span>
					<span class="answer_cnt">
						<!-- 필요 답변 개수가 2개 이상이면 표시 -->
						<c:if test="${question.answer_cnt > 1}">
							(${question.answer_cnt}개 선택)
						</c:if>
					</span>
				</div>
			</div>
		</div>
		<!-- 문항/문항번호/문항분류/문항내용 end-->
		
		
		<!-- 선택지 start -->
		<div class="${questionType}-question-selections">
			<c:forEach items="${question.selectionList}" var="selection" varStatus="selectionStt">
				<!-- 객관식이면(선택지에 이름이 있으면) -->
				<c:if test="${not empty selection.selection_name}">
						<label class="${questionType}-question-selection">
							<input type="checkbox"
								data-selection_ordr="${selection.selection_ordr}"
								data-selection_name="${selection.selection_name}"/> ${selection.selection_name}
								
							<c:if test="${selection.selection_name eq '기타'}">
								<input type="text" name="input" class="content" disabled />
							</c:if>
						</label>
						
				</c:if>
				<!-- 주관식이면(선택지에 이름이 없으면) -->
				<c:if test="${empty selection.selection_name}">
					<textarea class="content" name="textarea" rows="5" data-tag_name="textarea"></textarea>
				</c:if>
				
				<!-- 한 줄의 선택지 수 : 부모문항 선택지는 4개, 자식문항 선택지는 3개-->
				<c:if test="${questionType eq 'parent' }">
					<c:if test="${selectionStt.count % 4 == 0}"><br></c:if>
				</c:if>
				<c:if test="${questionType eq 'child' }">
					<c:if test="${selectionStt.count % 3 == 0}"><br></c:if>
				</c:if>
			</c:forEach>
		</div>
		<!-- 선택지 end -->
		
		
		<!-- 페이지 마무리 및 생성 start -->
			<!-- 1. 마지막이면 페이지를 닫고 마무리
			     2. [현재 문제수 - 선택지 없는 문항 수] 가 5배수에 다다르면, 기존페이지를 닫고 새페이지를 연다.
			     3. 선택지가 없는 문항이면 페이지에 관여하지 않고 noSelectionCount만 + 1 해준다. -->
		<c:choose>
			<c:when test="${questionStt.last}">
				<div class="directionBtn">
					<c:if test="${((questionStt.count - noSelectionCount) / 5) > 1 }">
						<button type="button" class="btn btn-info prevBtn">이전</button>
					</c:if>
				</div>
				</div>
			</c:when>
			<c:when test="${question.selection_no == 0}">
				<c:set var="noSelectionCount" value="${noSelectionCount + 1}"></c:set>
			</c:when>
			<c:otherwise>
				<c:if test="${(questionStt.count - noSelectionCount) % 5 == 0}">
					<div class="directionBtn">
						<c:if test="${((questionStt.count - noSelectionCount) / 5) > 1 }">
							<button type="button" class="btn btn-info prevBtn">이전</button>
						</c:if>
						
						<button type="button" class="btn btn-info nextBtn">다음</button>
					</div>
					
					</div><div class="question-page">
				</c:if>
			</c:otherwise>
		</c:choose>
		<!-- 페이지 마무리 및 생성 end -->
		
		
	</c:forEach>
</div>

<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script>

	if (String(window.performance.getEntriesByType("navigation")[0].type) === "back_forward") {
		alert("잘못된 접근입니다.");
		location.href="/survey/surveyList.do";
	}
	
	window.addEventListener('beforeunload', (event) => {
	    event.preventDefault();
	    event.returnValue = '';
	});
	/* const jsonData = JSON.parse('${json }'); */
	$(document).ready(function() {
		$('#${menuType}').addClass('selected-menu');
		
		initPaging();									// 페이징 초기화
		prevNextBtn();									// 이전/다음 버튼 이벤트 등록
		makeDataMap();									// validation에 이용할 Map 만들기
		getTempAnswerList();							// 임시 답변 존재하면 가져와서 뿌리기
		initProgressBar();								// progress bar 초기화
		uiValidation();									// checkbox change이벤트로 검증 후 제약에 맞게 ui 셋틷
		textContentKeyup();								// textarea, input text의 keyup이벤트
		tempSaveBtn(); 									// 임시 저장 버튼 이벤트 등록
		$('#answerSubmit').on('click', answerSubmit);	// 제출 버튼 이벤트 등록
		outBtn();										// 나가기 버튼 이벤트
	});
	
	// 페이지들
	const pages = $('.question-page');
	
	// 페이징 초기화(첫 페이지만 보여준다)
	function initPaging() {
		pages.css('display', 'none');
		$(pages[0]).css('display', 'block');
	}
	
	// 이전/다음 버튼 이벤트
	function prevNextBtn() {
		$('.prevBtn').on('click', function() {
			let nowPage = '';
			
			for (let i = 0; i < pages.length; i++) {
				if ($(pages[i]).css('display') == 'block') {
					nowPage = $(pages[i]);
				}
			    $(pages[i]).css('display', 'none');
			}
			
			nowPage.prev().css('display', 'block');
			window.scrollTo(0,0);
		});
		
		$('.nextBtn').on('click', function() {
			let nowPage = '';
			
			for (let i = 0; i < pages.length; i++) {
				if ($(pages[i]).css('display') == 'block') {
					nowPage = $(pages[i]);
				}
				$(pages[i]).css('display', 'none');
			}
			nowPage.next().css('display', 'block');
			window.scrollTo(0,0);
		});
	}
	
	
	// validation에 이용할 Map 만들기	
	var dataMap = new Map();
	function makeDataMap() {
		$('.question-box').each(function(idx, item) {
			let question_no  = item.dataset.question_no;
			let question_num = item.dataset.question_num;
			let necessity_yn = item.dataset.necessity_yn;
			let parent_no 	 = item.dataset.parent_no;
			let answer_cnt 	 = item.dataset.answer_cnt;
			let selection_no = item.dataset.selection_no;
			let question_type = ($(item).next().find('textarea.content').length > 0) ? 'form' : 'choice';
			
			let data = {
					'question_no': question_no,
					'question_num': question_num,
					'necessity_yn': necessity_yn,
					'parent_no': parent_no,
					'answer_cnt': answer_cnt,
					'selection_no': selection_no,
					'question_type': question_type,
					'checkedArr': []
			};
			
			dataMap.set(question_no, data);
		})
	}
	
	
	// participate_yn
	// 'Y': 임시저장 -> 제출
	var tempLoaded_yn = '';
	
	// 임시 답변 존재하면 가져와서 뿌리기
	function getTempAnswerList() {
		
		let data = {
				'survey_no': '${questionVO.survey_no}'
		}
		
		$.ajax({
	    	url: '/survey/getTempAnswerList.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
	        success: function(resultList) {
				if (resultList[0].temp_yn == 'N') {
					alert('새 설문을 시작합니다.');
				} else {
					if(!confirm("임시 저장된 답변을 불러오시겠습니까?")) {
						return;
					}
					
					tempLoaded_yn = 'Y';
					
					if (resultList[0].answer_no == 0) {
						alert('임시 저장한 설문을 가져오지 못했습니다.');
						return;
					} 
					
					setTempAnswerToQuestion(resultList);	
				}
			},
			error: function(error) {
				console.log(error);
			}
	    })
		
	}
	
	// 가져온 임시 답변 check 처리 후 dataMap에 담기
	function setTempAnswerToQuestion(list) {
		$(list).each(function(idx, item) {
			// 해당 문항에 대한 dataMap의 value의 checkArr
			let checkedArr = dataMap.get('' + item.question_no).checkedArr;
			
			//해당 질문의 선택지div
			let $selectionDiv = $('div[data-question_no=' + item.question_no + ']').next();
			
			// 선택지가 객관식일 때
			if ($selectionDiv.find('input[type=checkbox]').length > 0) {
				// 해당 선택지에 답을 했을 경우
				if (item.selection_ordr != 0) {
					// 선택지 중에 해당하는 곳에 check해주고 dataMap의 checkedArr에 값 넣어주기
					let $targetSelection = $selectionDiv.find('input[data-selection_ordr=' + item.selection_ordr + ']');
					$targetSelection.attr('checked',true);
					checkedArr.push(item.selection_ordr);
					
					// 만약 해당하는 선택지 다음에 input text(class=content)가 있다면 즉, 기타 선택지 답변란이 존재하면
					if ($targetSelection.next().length > 0) {
						// input text 활성화
						$targetSelection.next().attr('disabled', false);
						// item.content가 null이 아니면 값 넣어주기
						if (item.content != null) {
							$targetSelection.next().val(item.content);
						}
					}
				}
				
			// 선택지가 주관식일 때
			} else {
				// item.content가 null이 아니면 값 넣어주기
				if (item.content != null) {
					$selectionDiv.find('.content').val(item.content);
				}
			}
			
		});
	}
	
	
	
	const $necessityQuestions = $('div[data-necessity_yn=Y]');	// 필수 답변 문항div들
	$('#progress')[0].max = $necessityQuestions.length;			// progress bar max는 필수 문항 개수
	$('#progress').val(0);										// progress bar 초기값은 0
	var finishedQuestionArr = [];	// 완료된 설문 문항번호를 넣어두는 배열(배열의 길이가 progress bar의 value)
	
	// progress bar 현재 상태로 반영
	function progressBarReflecter() {
		// 완료된 설문 수 만큼 progress bar value에 입력해준다.
		$('#progress').val(finishedQuestionArr.length);
		
		let percent = ( $('#progress').val() / $('#progress')[0].max ) * 100; 
		$('#progress-percent').text(Math.floor(percent) + '%');
	}
	
	// progress bar 초기화
	function initProgressBar() {
		// 해당 설문 참여가 처음이라면 return;
		if (tempLoaded_yn != 'Y') {
			// 현재 상태로 progress bar 반영
			progressBarReflecter();
			return;
		}
		
		$necessityQuestions.each(function(idx, item) {
			let questionNo = Number(item.dataset.question_no);	// 문항번호
			let $selectionDiv = $(item).next();					// 선택지 div
			
			// 객관식일 때 
			if ($selectionDiv.find('input[type=checkbox]').length > 0 ) {
				let answerCnt = Number(item.dataset.answer_cnt);	// 필요 답변 수
				let finishedCnt = 0;								// 선택 완료 수
				
				// checkbox 선택지들
				let $checkedboxs = $selectionDiv.find('input[type=checkbox]:checked');
				
				$checkedboxs.each(function(checkedIdx, checkedItem) {
					if (checkedItem.dataset.selection_name == '없음') {
						finishedCnt = answerCnt;
						return false;
					}
					
					// 체크박스 옆의 input text
					let $inputText = $(checkedItem).next();
					
					// 체크박스 옆의 input text가 존재할 때('기타' 선택지일 경우)
					if ($inputText.length > 0) {
						if ($inputText.val().length > 0) {
							finishedCnt++;
						}
						
					// 체크박스 옆의 input text 없으면 그냥 선택 완료 수 올려준다.
					} else {
						finishedCnt++;
					}
				});
				
				// 필요 답변 수와 완료 선택지 수가 일치하면, 해당 문항을 완료문항배열에 넣어주기
				if (answerCnt == finishedCnt) {
					finishedQuestionArr.push(questionNo);
				}
				
			// 주관식일 때
			} else {
				if ($selectionDiv.find('.content').val().length > 0) {
					finishedQuestionArr.push(questionNo);
				}
			}
		});
		
		// 현재 상태로 progress bar 반영
		progressBarReflecter();
	};
	
	
	
	// ui적으로 편리하도록, Check해서 바로잡아주는 함수
	function uiValidation() {
		$('input[type=checkbox]').change(function() {
			 
			// 체크한 선택지, 선택지순서(번호), 선택지명, 체크인지 해제인지
			let $targetSelection = $(event.target);
			let targetSelectionOrdr = Number($(event.target).get(0).dataset.selection_ordr);
			let targetSelection_name = $(event.target).get(0).dataset.selection_name;
			let targetSelectionIsChecked = $targetSelection.get(0).checked;
			
			// 선택지 div, 문항 div, 문항번호 
			let $selectionsDiv = $(event.target).parent().parent();
			let $questionDiv = $selectionsDiv.prev();
			let question_no = $questionDiv.get(0).dataset.question_no;
		 	 
		 	// 현재 체크된 input태그들
			let $checkedInput = $selectionsDiv.find('input[type=checkbox]:checked');
			
		 	// 해당 question_no의 dataMap
		 	let mapdata = dataMap.get(question_no);
		 	
		 	
		 	// 체크 change일 때
		 	if (targetSelectionIsChecked) {
		 		
		 		// 기존에 없음이 체크되어 있는 중에 다른 것을 체크하면, 없음을 체크해제한다.
		 		if (targetSelection_name != '없음') {
		 			$checkedInput.each(function(idx, chkItem) {
			 			if (chkItem.dataset.selection_name == '없음') {
			 				mapdata.checkedArr.forEach(function(mapItem, idx) {
			 					if (chkItem.dataset.selection_ordr == mapItem) {
			 						mapdata.checkedArr.splice(idx, 1);
			 					}
					 		});
					 		chkItem.checked = false;
			 			}
			 		});
		 		}
		 		console.log('없어지지 안음?',mapdata.answer_cnt);
		 		
				// 필요 답변 수 보다 체크된 게 많으면, 먼저 저장한 것 삭제한다.		 		
		 		if ($checkedInput.length > mapdata.answer_cnt) {
		 			if (mapdata.checkedArr.length != 0) {
			 			let deleted_ordr = mapdata.checkedArr.shift();
			 			$selectionsDiv.find('input[data-selection_ordr=' + deleted_ordr + ']').get(0).checked = false;
		 			}
			 	}
				// 체크한 이벤트 대상을 추가
		 		mapdata.checkedArr.push(targetSelectionOrdr);
		 		
				
				
		 		// 체크한 답변이 기타이면 input태그 열어줌
		 		if (targetSelection_name == '기타') {
		 			$targetSelection.next().attr('disabled', false);
				}
		 		
		 		// 체크한 답변이 기타가 아닌데, 기타의 체크가 해제되었으면 input태그 닫아줌
		 		if (targetSelection_name != '기타') {
		 			if ($selectionsDiv.find('input[data-selection_name=' + '기타' + ']').length > 0) {
		 				if ($selectionsDiv.find('input[data-selection_name=' + '기타' + ']').get(0).checked == false) {
		 					$selectionsDiv.find('input.content').val('');
			 				$selectionsDiv.find('input.content').attr('disabled', true);
		 				} 
		 			}
				}
				
		 		// 체크한 답변이 없음이면, 없음 빼고 모두 체크 해제
		 		if (targetSelection_name == '없음') {
					mapdata.checkedArr.splice(0);
					mapdata.checkedArr.push(targetSelectionOrdr);
					
					$checkedInput.each(function(idx, item) {
						if (item.dataset.selection_ordr != targetSelectionOrdr) {
							item.checked = false;
						}
					});
					
					// 기타 text input도 닫아주기
					$selectionsDiv.find('input.content').val('');
					$selectionsDiv.find('input.content').attr('disabled', true);
				}
		 	
		 	// 체크해제 change일 때
		 	} else {
		 		mapdata.checkedArr.forEach(function(item, idx) {
					if (item == targetSelectionOrdr) {
						mapdata.checkedArr.splice(idx, 1);
						
						// 기타 text input도 닫아주기 
						if (targetSelection_name == '기타') {
							$targetSelection.next().val('');
							$targetSelection.next().attr('disabled', true);
						}
					}
				});
		 	}
		 	console.log(mapdata.checkedArr);
			
		 // 변화한 체크 박스 상태를 progress bar에 반영한다.
		 	chkboxReflectProgress(question_no);
		});
		
	}
	
	
	
	// 변화한 체크 박스 상태를 progress bar에 반영한다.
	function chkboxReflectProgress(question_no) {
		
		// 해당 선택지의 문항div
		let $questionDiv = $('div[data-question_no = ' + question_no + ']');
		
		// 필수 문항이면
		if ($questionDiv.attr('data-necessity_yn') == 'Y') {
			let questionNo = question_no;									// 문항 번호
			let answerCnt = Number($questionDiv.attr('data-answer_cnt'));	// 필요 답변 수
			let finishedCnt = 0;											// 선택 완료 수
			
			let $selectionDiv = $questionDiv.next();			// 선택지 div
			console.log($selectionDiv.find('input[type=checkbox]:checked'));
			// 체크된 선택지들을 조사
			$selectionDiv.find('input[type=checkbox]:checked').each(function(idx, item) {
				if (item.dataset.selection_name == '없음') {
					finishedCnt = answerCnt;
					return false;
				}
				// 체크박스 옆의 input text
				let $inputText = $(item).next();
				
				// 체크박스 옆의 input text가 존재할 때('기타' 선택지일 경우)
				if ($inputText.length > 0) {
					if ($inputText.val().length > 0) {
						finishedCnt++;
					}
					
				// 체크박스 옆의 input text 없으면 그냥 선택 완료 수 올려준다.
				} else {
					finishedCnt++;
				}					
			});
			
			// 필요답변수와 완료 선택지 수가 일치할 때
			if (answerCnt == finishedCnt) {
				// 해당 문항 번호가 완료문항배열에 존재하지 않으면 넣어준다.
				if (finishedQuestionArr.find(item => item == questionNo) == undefined) {
					finishedQuestionArr.push(questionNo);
				}
			// 필요답변수와 완료 선택지 수가 불일치할 때
			} else {
				// 해당 문항 번호을 완료문항배열에서 찾아서 없애준다.
				$(finishedQuestionArr).each(function(idx, item) {
					if (item == questionNo) {
						finishedQuestionArr.splice(idx, 1);
						return false;
					}
				});
			}
			
			// 현재 상태로 progress bar 반영
			progressBarReflecter();
		}
	}
	
	
	// textarea, input text의 keyup이벤트
	function textContentKeyup() {
		$('.content').keyup(function() {
			// progress bar 관련 메서드
			textReflectProgress($(event.target));
			
			// 글자 수 최대 1300자 제한
			maxTextCntCheck($(event.target));
		})
	}
	
	
	// keyup이 발생한 input text, textarea 상태를 progress bar에 반영한다.
	function textReflectProgress($target) {
		let tagName = $target[0].tagName;
		
		// textarea일 때
		if (tagName == 'TEXTAREA') {
			let $questionDiv = $target.parent().prev();
			
			if ($questionDiv.attr('data-necessity_yn') == 'Y') {
				console.log('textarea');
				// 해당 문항 번호 구하기
				let questionNo = Number($questionDiv.attr('data-question_no'));
				
				if ($target.val().length > 0) {
					// 해당 문항 번호가 완료문항배열에 존재하지 않으면 넣어준다.
					if (finishedQuestionArr.find(item => item == questionNo) == undefined) {
						finishedQuestionArr.push(questionNo);
					}
				} else {
					// 해당 문항 번호을 완료문항배열에서 찾아서 없애준다.
					$(finishedQuestionArr).each(function(idx, item) {
						if (item == questionNo) {
							finishedQuestionArr.splice(idx, 1);
							return false;
						}
					});
				}
				
				// 현재 상태로 progress bar 반영
				progressBarReflecter();
			}
			
		// input text일 때
		} else if (tagName == 'INPUT') {
			let $questionDiv = $target.parent().parent().prev();
			
			if ($questionDiv.attr('data-necessity_yn') == 'Y') {
				console.log('input');
				let questionNo = Number($questionDiv.attr('data-question_no'));
				let answerCnt = Number($questionDiv.attr('data-answer_cnt'));
				
				let $selectionDiv = $questionDiv.next();
				
				if ($target.val().length > 0) {
					// input text에서 keyup이 발생하려면 무조건 기타에 checked가 되어있어야함.
					// 따라서 checked된 개수만 answerCnt와 같으면 문항 만족.
					if ($selectionDiv.find('input[type=checkbox]:checked').length == answerCnt) {
						// 해당 문항 번호가 완료문항배열에 존재하지 않으면 넣어준다.
						if (finishedQuestionArr.find(item => item == questionNo) == undefined) {
							finishedQuestionArr.push(questionNo);
						}
					} 
					
				} else {
					// keyup이 발생한 상황은 기타가 체크되어있는 상황.
					// 필요답변개수가 몇개든 간에, 현재 체크한 기타에 대한 text답변이 없으니, 완료문항이 될 수가 없다.
					
					// 해당 문항 번호을 완료문항배열에서 찾아서 없애준다.
					$(finishedQuestionArr).each(function(idx, item) {
						if (item == questionNo) {
							finishedQuestionArr.splice(idx, 1);
							return false;
						}
					});
				}
			
				// 현재 상태로 progress bar 반영
				progressBarReflecter();
			}
			
		}
	}
	
	
	// 글자 수 최대 1300자 제한
	function maxTextCntCheck($target) {
		if ($target.val().length > 1300) {
			alert('1300자 이하로만 입력 가능합니다.');
			target.val(target.val().substr(0, 1300));
		}
	}
	
	
	// 해당 하는 페이지로 가기
	function returnToPage(question_no) {
		pages.css('display', 'none');
		$('div[data-question_no=' + question_no + ']').parent().css('display', 'block');
// 		window.scrollTo()location.href='#' + question_no;

	}
	
	
	/*
	   제출전 유효성 검증하기
	    - 필수답변인데 답변개수가 부족할때
		- 기타가 체크되어있지만 입력을 안했을 때(input text disabled == false임에도 length가 0일때)
		- 필수답변인 주관식을 입력 안했을 때
	*/
	function beforeSubmitValidation() {
		let firstQuestionNo = Number('${questionVO.question_no}');
		
		for (let i = firstQuestionNo; i <= (dataMap.size + firstQuestionNo - 1); i++) {
			let attr = dataMap.get('' + i);
			let arr = attr.checkedArr;

			
			if (attr.necessity_yn == 'Y') {
				// 문항의 '없음' 선택지 찾음
				let $none = $("[data-question_no=" + i + "]").next().find('input[data-selection_name=없음]');
				
				// 문항에 '없음' 선택지가 있으면서 체크되어 있을 시에는, dataMap에 선택지번호가 1개만 있는지만 확인
				if ($none.length > 0 && $none.get(0).checked == true) {
					if (arr.length == 1) {
						continue;
					}
				} else {
					// 객관식 답변이면
					if (attr.question_type == 'choice') {
						// 답변 개수 체크
						if (attr.answer_cnt != arr.length) {
							alert(attr.question_num + '번 문항의 답변이 부족합니다.');
							pages.css('display', 'none');
							$('div[data-question_no=' + i + ']').parent().css('display', 'block');
							return false;
						// 답변 개수 맞으면 기타의 [체크여부 + 답변] 확인  
						} else {
							let textInput = $("[data-question_no=" + i + "]").next().find('.content');
							if (textInput.length > 0 && textInput.get(0).disabled == false && textInput.val().length == 0) {
								alert(attr.question_num + '번 문항 기타 선택지의 답변을 입력해주세요.')
								returnToPage(i);
								return false;
							}
						}
					// 주관식 답변이면
					} else {
						let textarea = $("[data-question_no=" + i + "]").next().find('.content');
							console.log(i);
						textarea.blur();
						if (textarea.val().length == 0) {
							alert(attr.question_num + '번 문항 주관식 답변을 입력해주세요.');
							returnToPage(i);
							return false;
						}
					}
				}
			// 자율 답변일 때
			} else {
				// 객관식이면
				if (attr.question_type == 'choice') {
					// 기타의 [체크여부 + 답변] 확인  
					let textInput = $("[data-question_no=" + i + "]").next().find('.content');
					if (textInput.length > 0 && textInput.get(0).disabled == false && textInput.val().length == 0) {
						alert(attr.question_num + '번 문항 기타 선택지의 답변을 입력해주세요.');
						returnToPage(i);
						return false;
					}
				}
			}
		}
		
		return true;
	}
	
	
	// 답변 검증 후 제출
	function answerSubmit() {
		if (!beforeSubmitValidation()) {
			return;
		};
		
		// try/catch로 
		try {
			
			if (window.confirm("최종 제출하시겠습니까?")) {
				const answerList = [];
				let questionList = $('.question-box'); 
				questionList.each(function(idx, item) {
					const selectionList = item.nextElementSibling;
					const checkedList = selectionList.querySelectorAll('input[type=checkbox]:checked');
					let ordrList = Array.prototype.slice.call(checkedList)
								   .map(function(input) { return input.dataset.selection_ordr });
					
					
					// 혹시나 누가 스크립트 checked=true로 장난질 했을때 돌려보내기
					if (item.dataset.necessity_yn == 'Y' && $(item).find('textarea.content').length == 0) {
						if (ordrList.length > Number(item.dataset.answer_cnt)) {
							alert(item.dataset.question_num + '번 문제의 답변을 지우고 다시 체크해주세요.');
							returnToPage(item.dataset.question_no);
							throw 'finish';
						}	
					} 
					
					
					const tag = $(selectionList).find('.content').get(0);
					const content = (typeof tag === 'undefined')? '' : tag.value;
	
					
					// 선택하지 않았다면 0 넣어주기
					if (ordrList.length == 0) {
						// 주관식이면 ordrList에 1을 넣어줘라.(selection_ordr => 1)
						if (tag != null && tag.getAttribute('name') == 'textarea') {
							ordrList.push(1);
						// 객관식인데, 선택지가 존재하지 않는 문항이거나, 선택을 하지 않은 경우
						} else {
							ordrList.push(0);
						}
						
					}
					
					let data = {
							"survey_no" : '${questionVO.survey_no}',
							"question_no" : item.dataset.question_no,
							"question_num" : item.dataset.question_num,
							"selection_ordr" : ordrList,
							"content" : content
					}
					
					// 임시 저장 -> 제출
					if (tempLoaded_yn == 'Y') {
						data.tempLoaded_yn = 'Y';
					}
					
					answerList.push(data)
				})
				
				console.log(answerList);
				
				$.ajax({
			    	url: '/survey/insSurveyAnswer.do',
					type: 'post',
					contentType: 'application/json',
					data: JSON.stringify(answerList),
	//				data: { jsonData : JSON.stringify(answerArr) }, 
					dataType: 'json',
			        success: function(data) {
						alert(data.msg);
						location.href='/survey/surveyList.do?menuType=' + '${menuType}';
					},
					error: function(error) {
						console.log(error);
					}
			    })
			}
		} catch (e) {
			if (e == 'finish') {
				return false;
			}
		}
	}
	
	// 임시저장 버튼 이벤트
	function tempSaveBtn() {
		$('#tempSaveBtn').on('click', function() {
			if (window.confirm("임시 저장하시겠습니까?")) {
				const tempAnswerList = [];
				let questionList = $('.question-box'); 
				questionList.each(function(idx, item) {
					const selectionList = item.nextElementSibling;
					const checkedList = selectionList.querySelectorAll('input[type=checkbox]:checked');
					let ordrList = Array.prototype.slice.call(checkedList)
								   .map(function(input) { return input.dataset.selection_ordr });
					
					const tag = $(selectionList).find('.content').get(0);
					const content = (typeof tag === 'undefined')? '' : tag.value;

					// 선택하지 않았다면 0 넣어주기
					if (ordrList.length == 0) {
						// 주관식이면 ordrList에 1을 넣어줘라.(selection_ordr => 1)
						if (tag != null && tag.getAttribute('name') == 'textarea') {
							ordrList.push(1);
						// 객관식인데, 선택지가 존재하지 않는 문항이거나, 선택을 하지 않은 경우
						} else {
							ordrList.push(0);
						}
						
					}
					
					let data = {
							"survey_no" : '${questionVO.survey_no}',
							"question_no" : item.dataset.question_no,
							"question_num" : item.dataset.question_num,
							"selection_ordr" : ordrList,
							"content" : content
					}
					tempAnswerList.push(data)
				})
				
				console.log(tempAnswerList);
				
				$.ajax({
			    	url: '/survey/insSurveyTempAnswer.do',
					type: 'post',
					contentType: 'application/json',
					data: JSON.stringify(tempAnswerList),
					dataType: 'json',
			        success: function(data) {
						alert(data.msg);
					},
					error: function(error) {
						console.log(error);
					}
			    })
			}
		})
	}
	
	// 나가기 버튼 이벤트
	function outBtn() {
		$('#outBtn').on('click', function() {
			let $form = $('<form>').attr('action', '/survey/surveyInfo.do')
								   .attr('method', 'post')
								   .css('display', 'none')
								   .appendTo($('body'));
				
			let $input = $('<input>').attr('type', 'hidden')
								     .attr('name', 'survey_no')
								     .val('${questionVO.survey_no}')
								     .appendTo($form);
			
			let $menuTypeInput = $('<input>').attr('type', 'hidden')
								              .attr('name', 'menuType')
								              .val('${menuType}')
								              .appendTo($form);
			$form.submit();
		});
	}
</script>

</body>
</html>