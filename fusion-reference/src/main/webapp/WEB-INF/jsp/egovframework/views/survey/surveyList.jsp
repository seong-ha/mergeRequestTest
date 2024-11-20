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
		<div class="container-fluid px-4">
			<h1 class="mt-4">
				<c:forEach items="${headerMenuList}" var="headerMenu">
					<c:if test="${headerMenu.menu_type == menuType}">
						<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
					</c:if>											
				</c:forEach>
			</h1>
			<div class="card mb-4">
				<c:if test="${author_no == 1 || author_no == 2}">
					<div class="card-header">
						<a id="surveyStatisticsBtn" class="btn btn-success float-end" style="margin-left: 5px;">
							통계
						</a>
						<a id="surveyManageBtn" class="btn btn-primary float-end">
							설문 관리
						</a>
					</div>
				</c:if>
				<div class="card-body">
					<table id="survey-table" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>주관사</th>
								<th class="tb-title">설문명</th>
								<th>참여기간</th>
								<th>참여대상</th>
								<th>참여가능여부</th>
							</tr>
						</thead>
						<tbody>
							<!-- 설문 게시물 start -->
							<c:if test="${empty surveyList}">
							 	<tr>
							 		<td colspan="5">설문 게시물이 없습니다.</td>
							 	</tr>
							</c:if>
							<c:if test="${not empty surveyList}">
								<c:forEach items="${surveyList}" var="vo">
									<tr>
										<td>${vo.host_name}</td>
										<td>
											<a class="make-href" onclick="goSurveyInfo(${vo.survey_no})">${vo.survey_title}</a>
										</td>
										<td>
											<fmt:parseDate var="start_dt" value="${vo.start_dt}" pattern="yyyy-MM-dd" />
											'<fmt:formatDate value="${start_dt}" pattern="yyyy. MM. dd." />(${vo.start_dy})
											~
											<fmt:parseDate var="end_dt" value="${vo.end_dt}" pattern="yyyy-MM-dd" />
											'<fmt:formatDate value="${end_dt}" pattern="yyyy. MM. dd." />(${vo.end_dy})
										</td>
										<td>
											<c:forEach items="${vo.subjectList}" var="sj" varStatus="status">
												<c:choose>
													<c:when test="${sj eq 'ALL'}">
														모두(비회원포함)
													</c:when>
													<c:when test="${sj eq 'NORMAL'}">
														일반<c:if test="${!status.last }">,</c:if>
													</c:when>
													<c:when test="${sj eq 'STUDENT'}">
														학생<c:if test="${!status.last }">,</c:if>
													</c:when>
													<c:when test="${sj eq 'TEACHER'}">
														교사<c:if test="${!status.last }">,</c:if>
													</c:when>
												</c:choose>
											</c:forEach>
										</td>
										<td>
											<c:if test="${vo.subject eq 'ALL' }">
												<c:choose>
													<c:when test="${vo.available_yn == 'Y'}">
														참여가능													
													</c:when>
													<c:when test="${vo.available_yn == 'N'}">
														참여불가
													</c:when>
												</c:choose>
											</c:if>
											<c:if test="${vo.subject ne 'ALL' }">
												<c:if test="${fn:indexOf(vo.subject, author) != -1}">
													<c:choose>
														<c:when test="${vo.available_yn == 'Y'}">
															참여가능													
														</c:when>
														<c:when test="${vo.available_yn == 'N'}">
															참여불가
														</c:when>
													</c:choose>
												</c:if>
												<c:if test="${fn:indexOf(vo.subject, author) == -1}">
													참여불가
												</c:if>
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</c:if>
							<!-- 설문 게시물 end -->
						</tbody>
					</table>
				</div>
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
			
			surveyManageBtn();	// 설문 관리 페이지로
		});
		
		// 제목 클릭 시 해당 설문조사 페이지로
		function goSurveyInfo(survey_no) {
			let $form = $("<form>").attr('action', '/survey/surveyInfo.do')
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
		
		function surveyManageBtn() {
			$('#surveyManageBtn').on('click', function() {
				location.href = '/survey/surveyManage.do?menuType=${menuType}';
			})
		}
	</script>
</body>
</html>