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
	<div id="survey-guide">
		<article>
			<p>${survey.content}</p>
			<ul class="guide-list">
				<li>
					<div class="guide-title">조사주관 : </div>
					<div>${survey.host_name}</div>
				</li>
				<li>
					<div class="guide-title">참여대상 : </div>
					<div>
						<c:forEach items="${survey.subjectList}" var="sj" varStatus="status">
							<c:choose>
								<c:when test="${sj eq 'ALL'}">
									모두(비회원포함)
								</c:when>
								<c:when test="${sj eq 'NORMAL'}">
									일반
								</c:when>
								<c:when test="${sj eq 'STUDENT'}">
									학생
								</c:when>
								<c:when test="${sj eq 'TEACHER'}">
									교사
								</c:when>
							</c:choose>
							<c:if test="!status.last">
								,&nbsp;
							</c:if>
						</c:forEach>
					</div>
				</li>
				<li>
					<div class="guide-title">참여기간 : </div>
					<div>
						<span>
							<fmt:parseDate var="start_dt" value="${survey.start_dt}" pattern="yyyy-MM-dd" />
							'<fmt:formatDate value="${start_dt}" pattern="yyyy. MM. dd." />(${survey.start_dy})
							~
							<fmt:parseDate var="end_dt" value="${survey.end_dt}" pattern="yyyy-MM-dd" />
							'<fmt:formatDate value="${end_dt}" pattern="yyyy. MM. dd." />(${survey.end_dy}),
						</span>
						<span>총 ${survey.total_days}일간</span>
					</div>
				</li>
				<li>
					<div class="guide-title">참여방법 : </div>
					<div>하단의 설문시작 버튼을 클릭하여 총 ${survey.req_que_cnt}개의 문항에 답변을 마치면 응모완료</div>
				</li>
				<li>
					<div class="guide-title">당첨자발표 : </div>
					<div>
						<span>
							<fmt:parseDate var="win_open_dt" value="${survey.win_open_dt}" pattern="yyyy-MM-dd" />
							 &nbsp;'<fmt:formatDate value="${win_open_dt}" pattern="yyyy. MM. dd." />(${survey.win_open_dy}),
						</span>
						<span>${survey.win_open_loc}</span>
					</div>
				</li>
			</ul>
			
			<div class="caution-guide">
				<p>※ 유의사항</p>
				<p> - 당첨자 선정은 응답 내용의 성실성 등을 고려하여 선정됩니다.</p>
				<p>
					 - 1인 ${survey.submit_cnt }회에 한하여 참여가능 합니다.
				</p>
			</div>
		</article>
		<div id="survey-permission">
				<c:choose>
					<c:when test="${survey.subject == 'ALL'}">
						<c:if test="${survey.available_yn == 'Y'}">
							<c:if test="${not empty participateList}">
								<c:if test="${fn:length(participateList) < survey.submit_cnt }">
									<button type="button" class="btn btn-info" onclick="goSurveyPost(${survey.survey_no})">참여</button>
									<c:if test="${survey.submit_cnt > 1}">
										<span class="no-more-participate">( ${fn:length(participateList)} 회 참여 )</span>								
									</c:if>
								</c:if>
								<c:if test="${fn:length(participateList) >= survey.submit_cnt }">
									<span class="no-more-participate">참여가능 횟수만큼 참여하셨습니다.</span>		
								</c:if>
							</c:if>
							<c:if test="${empty participateList }">
								<button type="button" class="btn btn-info" onclick="goSurveyPost(${survey.survey_no})">참여</button>
							</c:if>
						</c:if>
						<c:if test="${survey.available_yn == 'N'}">
							<span class="no-more-participate">참여가능한 기간이 아닙니다.</span>
						</c:if>
					</c:when>
					<c:otherwise>
						<c:if test="${not empty author}">
							<c:if test="${fn:indexOf(survey.subject, author) != -1}">
								<c:if test="${survey.available_yn == 'Y'}">
									<c:if test="${not empty participateList}">
										<c:if test="${fn:length(participateList) < survey.submit_cnt }">
											<div>
												<button type="button" class="btn btn-info" onclick="goSurveyPost(${survey.survey_no})">참여</button>
												<c:if test="${survey.submit_cnt > 1}">
													<span class="no-more-participate">(${fn:length(participateList)}회 참여)</span>								
												</c:if>
											</div>
										</c:if>
										<c:if test="${fn:length(participateList) >= survey.submit_cnt }">
											<span class="no-more-participate">참여가능 횟수만큼 참여하셨습니다.</span>		
										</c:if>
									</c:if>
									<c:if test="${empty participateList }">
										<button type="button" class="btn btn-info" onclick="goSurveyPost(${survey.survey_no})">참여</button>
									</c:if>
								</c:if>
								<c:if test="${survey.available_yn == 'N'}">
									<span class="no-more-participate">참여가능한 기간이 아닙니다.</span>
								</c:if>
							</c:if>
							<c:if test="${fn:indexOf(survey.subject, author) == -1}">
								<span class="no-more-participate">참여 대상이 아닙니다.</span>
							</c:if>
						</c:if>
						<c:if test="${empty author}">
							<span class="no-more-participate">참여 대상이 아닙니다.</span>
						</c:if>
					</c:otherwise>
				</c:choose>
			
			<button type="button" class="btn btn-primary" onclick="location.href='/survey/surveyList.do?menuType=${menuType}'"> 설문 목록으로 돌아가기</button>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		// 제목 클릭 시 해당 설문조사 페이지로
		function goSurveyPost(survey_no) {
			let $form = $('<form>').attr('action', '/survey/surveyPost.do')
								   .attr('method', 'post')
								   .css('display', 'none')
								   .appendTo($('body'));
			
			let $input = $('<input>').attr('type', 'hidden')
									 .attr('name', 'survey_no')
									 .val(survey_no)
									 .appendTo($form);
			
			let $menuTypeInput = $('<input>').attr('type', 'hidden')
								              .attr('name', 'menuType')
								              .val('${menuType}')
								              .appendTo($form);
			
			$form.submit();
		}
	</script>
</body>
</html>