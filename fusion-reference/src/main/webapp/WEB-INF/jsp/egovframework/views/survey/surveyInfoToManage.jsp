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
		<div class="container-fluid px-4 " >
			<h1 class="mt-4">설문 정보 관리(관리자 전용)</h1>

			<!-- 설문 조사 정보 start -->
			<div class="card mb-4" id="surveyInfoShow">
				<h4>설문 정보</h4>
				<c:if test="${empty survey}">
					삭제된 설문 정보입니다.
				</c:if>
				<c:if test="${not empty survey}">
					<div class="surveyInfoToManageUpdateDeleteBtn">
						<button type="button" class="btn btn-success" id="surveyInfoUpdateBtn"
								<c:if test="${today >= survey.start_dt}">disabled</c:if>>수정</button>
						<button type="button" class="btn btn-danger" id="surveyInfoDeleteBtn">삭제</button>
						<button type="button" class="btn btn-info" id="goBackToSurveyManageBtn">돌아가기</button>
					</div>
					<div id="surveyInfoForm" class="card-body">
						<div>
							<div class="infoDiv">
								<label for="hostName" class="form-floating">주관사</label>
								<input type="text" id="hostName" class="form-control" value="${survey.host_name}" required>
							</div>
							<div class="infoDiv">
								<label for="surveyTitle" class="form-floating">설문조사 제목</label>
								<input type="text" id="surveyTitle" class="form-control" value="${survey.survey_title}" required>
							</div>
							<div class="infoDiv">
								<label for="surveyContent" class="form-floating">설문조사 내용</label>
								<textarea id="surveyContent" class="form-control" required>${survey.content}</textarea>
							</div>
								<label for="startDt" class="form-floating">설문조사 기간</label>
							<div class="infoDiv survey-period">
								<input type="date" id="startDt" class="form-control" value="${survey.start_dt}" required>
								 ~ 
								<input type="date" id="endDt" class="form-control" value="${survey.end_dt}" required> 
							</div>
							<div class="infoDiv">
								<label for="winOpenDt" class="form-floating">당첨자 발표일</label>
								<input type="date" id="winOpenDt" class="form-control" value="${survey.win_open_dt}" required>
							</div>
							<div class="infoDiv">
								<label for="winOpenLoc" class="form-floating">당첨자 발표 위치</label>
								<input type="text" id="winOpenLoc" class="form-control" value="${survey.win_open_loc}" required>
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
								<div id="subjects">
									<c:forEach items="${survey.subjectList}" var="sj">
										<div class="divAdded ${sj}">
											<c:choose>
													<c:when test="${sj eq 'ALL'}">
														모두(비회원포함)<input type="hidden" class="divAddedInput" value="${sj}"
														><span onclick="removeSubject()" class="removeSubject">x</span>
													</c:when>
													<c:when test="${sj eq 'NORMAL'}">
														일반<input type="hidden" class="divAddedInput" value="${sj}"
														><span onclick="removeSubject()" class="removeSubject">x</span>
													</c:when>
													<c:when test="${sj eq 'STUDENT'}">
														학생<input type="hidden" class="divAddedInput" value="${sj}"
														><span onclick="removeSubject()" class="removeSubject">x</span>
													</c:when>
													<c:when test="${sj eq 'TEACHER'}">
														교사<input type="hidden" class="divAddedInput" value="${sj}"
														><span onclick="removeSubject()" class="removeSubject">x</span>
													</c:when>
											</c:choose>
										</div>
									</c:forEach>
								</div>
							</div>
							<div class="infoDiv">
								<label for="submitCnt">참여 가능 횟수</label>
								<input type="number" id="submitCnt" class="form-control submitCntNum" value="${survey.submit_cnt}" required>
							</div>
						</div>
						
						<div>
							<button class="btn btn-primary btn-lg" id="goSurveyQuestionManageBtn">문항 관리</button>
						</div>
					</div>
				</c:if>
			</div>
			<!-- 설문 조사 정보 end -->
			
			
			
		</div>
	</main>
	
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		if (String(window.performance.getEntriesByType("navigation")[0].type) === "back_forward") {
			alert("잘못된 접근입니다.");
			location.href="/survey/surveyManage.do?menuType=${menuType}";
		}
	
		$(document).ready(function() {
			$('#${menuType}').addClass('selected-menu');
			
			let notAllowMessage = '${notAllowMessage}';
			if (notAllowMessage != null && notAllowMessage != "") {
				alert(notAllowMessage);
			}
			
			addSubject();					// 선택한 참여대상 담기
			surveyInfoUpdateBtn();			// 설문 정보 수정 버튼(설문정보 검증 후 수정)
			surveyInfoDeleteBtn();			// 설문 정보 삭제 버튼
			goBackToSurveyManageBtn();		// 돌아가기 버튼
			goSurveyQuestionManageBtn();	// 문항 관리 페이지로
		});
		
		
		// 설문 정보 수정 버튼 (설문정보 검증 후 수정)
		function surveyInfoUpdateBtn() {
			$('#surveyInfoUpdateBtn').on('click', function() {
				
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
				
				// 설문정보 데이터 가공.
				let surveyData = {
						'survey_no': '${survey.survey_no}',
						'host_name': hostName,
						'survey_title': surveyTitle,
						'content': surveyContent,
						'start_dt': startDt,
						'end_dt': endDt,
						'win_open_dt': winOpenDt,
						'win_open_loc': winOpenLoc,
						'subjectList': subjectList,
						'submit_cnt': submitCnt,
				}
				
				
				console.log(surveyData);
				
				if (confirm("설문 정보를 수정하시겠습니까?")) {
					$.ajax({
				    	url: '/survey/updSurvey.do',
						type: 'post',
						data: surveyData,
						dataType: 'json',
						async: false,
				        success: function(data) {
				        	alert(data.msg);
				        	if (data.result == '성공') {
					        	location.reload();
				        	}
						},
						error: function(error) {
							console.log(error);
						}
				    })
				}
				
			})
		}
		
		
		// 설문 정보 삭제 버튼
		function surveyInfoDeleteBtn() {
			$('#surveyInfoDeleteBtn').on('click', function() {
				if (confirm("설문 정보를 삭제하시겠습니까? (설문 정보 삭제 시, 문항 정보들도 같이 삭제됩니다.")) {
					
					$.ajax({
				    	url: '/survey/delSurvey.do',
						type: 'post',
						data: {'survey_no': '${survey.survey_no}'},
						dataType: 'json',
						async: false,
				        success: function(data) {
				        	alert(data.msg);
				        	if (data.result == '성공') {
				        		location.href ='/survey/surveyManage.do?menuType=${menuType}';
				        	}
						},
						error: function(error) {
							console.log(error);
						}
				    })
				}
			})
		}
		
		// 돌아가기 버튼
		function goBackToSurveyManageBtn() {
			$('#goBackToSurveyManageBtn').on('click', function() {
				location.href ='/survey/surveyManage.do?menuType=${menuType}';
			})
		}
		
		
		// 해당 설문의 문항관리 페이지로
		function goSurveyQuestionManageBtn() {
			$('#goSurveyQuestionManageBtn').on('click', function() {
				let $form = $("<form>").attr('action', '/survey/surveyQuestionManage.do')
				                	   .attr('method', 'post')
				                	   .css('display', 'none')
				                	   .appendTo($('body'));
				let $input = $('<input>').attr('type', 'hidden')
									     .attr('name', 'survey_no')
									 	 .val('${survey.survey_no}')
									 	 .appendTo($form);
				let $menuTypeInput = $('<input>').attr('type', 'hidden')
								            	  .attr('name', 'menuType')
								             	  .val('${menuType}')
								              	  .appendTo($form);
				$form.submit();
			})
		}
		
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
					alert('비회원 참여 포함 시 참여가능횟수는 1번으로 변경됩니다.')
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