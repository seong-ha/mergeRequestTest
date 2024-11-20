<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
		<div class="container-fluid px-4 ">
			<h1 class="mt-4">
				<c:forEach items="${headerMenuList}" var="headerMenu">
					<c:if test="${headerMenu.menu_type == menuType}">
						<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
					</c:if>											
				</c:forEach>
			</h1>
			<div class="card card-body">
				
				<!-- 설문 조사 정보 start -->
				<section class="card mb-4" id="surveyInfoShow">
					<h4>설문 정보</h4>
					<div id="surveyInfoForm" class="card-body">
						<div>
							<div class="infoDiv">
								<label for="hostName" class="form-floating">주관사</label>
								<input type="text" id="hostName" class="form-control" required>
							</div>
							<div class="infoDiv">
								<label for="surveyTitle" class="form-floating">설문조사 제목</label>
								<input type="text" id="surveyTitle" class="form-control" required>
							</div>
							<div class="infoDiv">
								<label for="surveyContent" class="form-floating">설문조사 내용</label>
								<textarea id="surveyContent" class="form-control" required></textarea>
							</div>
							<label for="startDt" class="form-floating">설문조사 기간</label>
							<div class="infoDiv survey-period">
								<input type="date" id="startDt" class="form-control" required> ~ <input type="date" id="endDt" class="form-control" required> 
							</div>
							<div class="infoDiv">
								<label for="winOpenDt" class="form-floating">당첨자 발표일</label>
								<input type="date" id="winOpenDt" class="form-control" required>
							</div>
							<div class="infoDiv">
								<label for="winOpenLoc" class="form-floating">당첨자 발표 위치</label>
								<input type="text" id="winOpenLoc" class="form-control" required>
							</div>
							<div class="infoDiv">
								<label for="subject" class="form-floating">참여 대상</label>
								<select id="subject" class="form-control">
									<option value="" disabled selected>원하는 대상을 추가해주세요</option>
									<option value="ALL" >모두(비회원포함)</option>
									<option value="NORMAL">일반</option>
									<option value="STUDENT">학생</option>
									<option value="TEACHER">교사</option>
								</select>
								<div id="subjects"></div>
							</div>
							<div class="infoDiv">
								<label for="submitCnt">참여 가능 횟수</label>
								<input type="number" id="submitCnt" class="form-control submitCntNum" min="1" max="10" required>
							</div>
						</div>
					</div>
				</section>
				<!-- 설문 조사 정보 end -->
				
				
				<!-- 전체 문항 정보 start -->
				<section class="card mb-4">
					<h4>문항 정보</h4>
					<div class="card-body" id="questionInfoForm">
						<button type="button" class="btn btn-primary btn-lg" id="addQuestionBtn">문항추가</button>
						<!-- 문항 정보 추가될 자리 -->
					</div>
				</section>
				<!-- 전체 문항 정보 end -->
				
				<button type="button" class="btn btn-success btn-lg" id="surveyRegistBtn">설문 전체 등록</button>
			</div>
		</div>
	</main>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			console.log('${menuType}')
			$('#${menuType}').addClass('selected-menu');
			
			let notAllowMessage = '${notAllowMessage}';
			if (notAllowMessage != null && notAllowMessage != "") {
				alert(notAllowMessage);
			}
			
			addSubject();						// 선택한 참여대상 담기
			addQuestionBtn();					// 문항 추가
			grantQuestionNum();					// 문항 번호 부여
			validationNRegist();				// 설문 및 문항 검증. 검증 완료 시 등록
		});
		
		
		// 참여대상 select태그 선택한 참여대상 담기
		function addSubject() {
			$('#subject').on('change', function() {
				let changedVal = $(event.target).val();					// 변화된 select value
				let changedText = $('#subject').find('option[value=' + changedVal + ']').text();
				let $subjectsDivs = $('#subjects').find('.divAdded');	// 추가한 참여대상
				
				// 추가한 적이 있을 때, 중복된 값이 있다면 추가 안함.
				if ($subjectsDivs.length > 0) {
					for (let i = 0; i < $subjectsDivs.length; i++) {
						if ($subjectsDivs[i].innerText.slice(0,-1) == changedText) {
							// 안내 글자로 돌려주기
							$('#subject').val('');
							return;
						}
					}
				}
				
				// 모두(비회원포함) 선택 시 원래 있던 것들 제거 
				if (changedText == '모두(비회원포함)') {
					$('#subjects').empty();
					$('#submitCnt').val(1);
					alert('비회원 참여 포함 시 참여가능횟수는 1번입니다.')
				}
				
				// 모두(비회원포함)이 있으면 비워준다.
				if ($('#subjects').find('.ALL').length > 0) {
					$('#subjects').empty();
				}
				
				let $divAdded = $('<div>').attr('class', 'divAdded ' + changedVal)
                   						  .text(changedText);
				let $span = $('<span>').attr('onclick', 'removeSubject()')
				                   	   .attr('class', 'removeSubject')
				                       .text('x');
				let $input = $('<input>').attr('type', 'hidden')
				                       .attr('class','divAddedInput')
				                       .val(changedVal)
				$divAdded.append($input);
				$divAdded.append($span);
				$('#subjects').append($divAdded);
				
				// 안내 글자로 돌려주기
				$('#subject').val('');
			});
		}
		
		
		// 추가한 참여대상 삭제
		function removeSubject() {
			$(event.target).parent().remove();			
		}
		
		
		// 문항 추가 버튼
		function addQuestionBtn() {
			$('#addQuestionBtn').on('click', function() {

				// 문항 정보 만들기
				let questionInfoBox = `<!-- 문항 정보 start -->
					<div class="card mb-4 questionInfoBox">
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
			$questionInfoDiv.find('.answerCnt').val(0);
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
				<div class="card mb-4 childQuestionInfoBox">
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
									<div class="selectionInfo">
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
									<div class="selectionInfo">
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
			let selectionInfo = `<div class="selectionInfo">
									<span>Ο</span> <input type="text" placeholder="선택지명을 입력하세요.">
									<button type="button" class="btn btn-danger selectionRemoveBtn"
									                      onclick="selectionInfoRemoveBtn()">×</button>
								</div>`;
			$selectionInfoAppendLocation.append(selectionInfo);
		}
		
		// 기타 선택지 추가 버튼
		function addEtcSelectionInfoBtn() {
			let $etcSelectionInfoAppendLocation = $(event.target).parent().parent().find('.etcSelectionInfo');
			
			// 기타 선택지가(input) 없을 때만 추가
			if ($etcSelectionInfoAppendLocation.find('input').length == 0) {
				let etcSelectionInfo = `<div>
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
				let noneSelectionInfo = `<div>
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
		
		
		
		// 설문 및 문항 검증. 검증 완료 시 등록
		function validationNRegist() {
			
			$('#surveyRegistBtn').on('click', function() {
				/*--------------------
				설문정보 검증
				--------------------*/
				let hostName = $.trim($('#hostName').val());
				let surveyTitle = $.trim($('#surveyTitle').val());
				let surveyContent = $('#surveyContent').val();
				let startDt = $('#startDt').val();
				let endDt = $('#endDt').val();
				let winOpenDt = $('#winOpenDt').val();
				let winOpenLoc = $.trim($('#winOpenLoc').val());
				let subject = $('#subjects').find('.divAdded');
				let submitCnt = $('#submitCnt').val();
				
				if (hostName == null || hostName.length == 0) {
					alert('주관사를 입력해주세요.');
					setTimeout(()=> {$('#hostName').focus();}, 1);
					return;
				} else if (hostName != null && hostName.length > 20) {
					alert('20자 이하로 입력해주세요.');
					setTimeout(()=> {$('#hostName').focus();}, 1);
					return;
				} else if (surveyTitle == null || surveyTitle.length == 0) {
					alert('설문조사 제목을 입력해주세요.');
					setTimeout(()=> {$('#surveyTitle').focus();}, 1);
					return;
				} else if (surveyTitle != null && surveyTitle.length > 45) {
					alert('45자이하로 입력해주세요.');
					setTimeout(()=> {$('#surveyTitle').focus();}, 1);
					return;
				} else if (surveyContent == null || surveyContent.length == 0) {
					alert('설문조사 내용을 입력해주세요.');
					setTimeout(()=> {$('#surveyContent').focus();}, 1);
					return;
				} else if (surveyContent != null && surveyContent.length > 1900) {
					alert('1900자 이하로 입력해주세요.');
					setTimeout(()=> {$('#surveyContent').focus();}, 1);
					return;
				} else if (startDt == null || startDt.length == 0) {
					alert('설문조사 시작일을 입력해주세요.');
					setTimeout(()=> {$('#startDt').focus();}, 1);
					return;
				} else if (endDt == null || endDt.length == 0) {
					alert('설문조사 마감일을 입력해주세요.');
					setTimeout(()=> {$('#endDt').focus();}, 1);
					return;
				} else if (winOpenDt == null || winOpenDt.length == 0) {
					alert('당첨자 발표일을 입력해주세요.');
					setTimeout(()=> {$('#winOpenDt').focus();}, 1);
					return;
				} else if (winOpenLoc == null || winOpenLoc.length == 0) {
					alert('당첨자 발표 위치을 입력해주세요.');
					setTimeout(()=> {$('#winOpenLoc').focus();}, 1);
					return;
				} else if (winOpenLoc != null && winOpenLoc.length > 20) {
					alert('20자 이하로 입력해주세요.');
					setTimeout(()=> {$('#winOpenLoc').focus();}, 1);
					return;
				} else if (subject.length == 0) {
					alert('참여 대상을 선택해주세요.');
					setTimeout(()=> {$('#subject').focus();}, 1);
					return;
				} else if (submitCnt == null || submitCnt.length == 0) {
					alert('참여 가능 횟수를 입력해주세요.');
					setTimeout(()=> {$('#submitCnt').focus();}, 1);
					return;
				} else if (submitCnt != null && (submitCnt < 1 || submitCnt > 10 || submitCnt.indexOf('.') != -1)) {
					alert('참여가능 횟수는 1회 이상 10회 이하로만 가능합니다.');
					setTimeout(()=> {$('#submitCnt').focus();}, 1);
					return;
				}
				
				
				// 날짜 오늘부터 설정가능. 시작끝날짜가 엇갈리면 안됨
				let date = new Date();
			    let year = date.getFullYear();
			    let month = ('0' + (1 + date.getMonth())).slice(-2);
			    let day = ('0' + date.getDate()).slice(-2);
			
			    let today = year + "-" + month + "-" + day;
				
				if (today > startDt) {
					alert('오늘부터 시작일을 설정할 수 있습니다.');
					setTimeout(()=> {$('#startDt').focus();}, 1);
					return;
				} else if (startDt > endDt) {
					alert('시작일은 마지막날을 넘을 수 없습니다.');
					setTimeout(()=> {$('#startDt').focus();}, 1);
					return;
				} else if (endDt > winOpenDt) {
					alert('당첨자 발표일이 설문 마지막날보다 빠를 수 없습니다.');
					setTimeout(()=> {$('#winOpenDt').focus();}, 1);
					return;
				}
				
				// 참여대상리스트
				let subjectList = [];
				subject.each(function(idx, item) {
					subjectList.push($(item).find('input').val());
				});
				
				for (let sub of subjectList) {
					if (sub == 'ALL') {
						if(submitCnt != 1) {
							alert('참여대상이 모두(비회원포함)임으로 참여가능횟수가 1회로 바뀝니다.');
							submitCnt = 1;
						}
					}
				}
				
				// 설문정보 데이터 가공.
				let surveyData = {
						'host_name': hostName,
						'survey_title': surveyTitle,
						'content': surveyContent,
						'start_dt': startDt,
						'end_dt': endDt,
						'win_open_dt': winOpenDt,
						'win_open_loc': winOpenLoc,
						'subjectList': subjectList,
						'submit_cnt': submitCnt,
						'menu_type': '${menuType}'
				}
				
				
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
										
										let selection_ordr = inputIdx + 1;
										let selection_name = $(inputItem).val();
										
										let selectionData = {
												'selection_ordr': selection_ordr,
												'selection_name': selection_name
										};
										
										questionData.selectionList.push(selectionData);
									});
									
									
								// 주관식 일 때
								} else if ($questionType.val() == 'shortForm') {
									
									let selection_ordr = 1;	// 주관식 선택지 순서는 1, 선택지이름은 빈 string
									
									let selectionData = {
											'selection_ordr': selection_ordr,
											'selection_name': ''
									};
									
									questionData.selectionList.push(selectionData);
								}
								
								// 완성된 하나의 대문항 정보를 대문항 정보 배열에 push
								questionsList.push(questionData);
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
											
											let selection_ordr = inputIdx + 1;
											let selection_name = $(inputItem).val();
											
											let selectionData = {
													'selection_ordr': selection_ordr,
													'selection_name': selection_name
											};
											
											childQuestionData.selectionList.push(selectionData);
										});
										
										
									// 주관식 일 때
									} else if ($questionType.val() == 'shortForm') {
										
										let selection_ordr = 1;	// 주관식 선택지 순서는 1, 선택지이름은 빈 string
										
										let selectionData = {
												'selection_ordr': selection_ordr,
												'selection_name': ''
										};
										
										childQuestionData.selectionList.push(selectionData);
									}
									
									// 완성된 하나의 소문항 정보를 소문항의 부모인 '대문항' 안에 있는 questionList에 push
									questionData.questionList.push(childQuestionData)
								}
								
							})
							
							// 소문항의 정보들을 주루룩 담은 questionList를 가진, 완성된 대문항을 대문항 정보 배열에 push 
							questionsList.push(questionData);
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
				
				if (confirm('설문을 등록하시겠습니까?')) {
					$.ajax({
				    	url: '/survey/insSurvey.do',
						type: 'post',
						contentType: 'application/json',
						data: JSON.stringify({
									surveyVO : surveyData,
									questionList : questionsList
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