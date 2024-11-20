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
			<h1 class="mt-4">통합 검색 더보기</h1>
			<div class="card mb-4">
				<div class="card-body">
		 			<div style="border:1px solid gray; border-radius: 10px; margin-bottom: 10px">
		 				<label>
			 				<c:forEach items="${headerMenuList}" var="headerMenu">
								<c:if test="${headerMenu.menu_type == integSrchListByType[0].menu_type}">
									<h3>${headerMenu.menu_name}</h3>
								</c:if>											
							</c:forEach>
						</label>
		 				<table id="survey-table" class="table table-hover table-striped">
							<colgroup>
								<col width="30%">
								<col width="20%">
								<col width="50%">
							</colgroup>
							<thead>
								<tr>
									<th>제목</th>
									<th>작성자</th>
									<th>내용</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${integSrchListByType}" var="article">
									<tr>
										<td>
											<c:if test="${article.menu_form eq 'board'}">
												<a class="make-href" onclick="boardPost('${article.menu_type}', ${article.board_no})">${article.title}</a>
											</c:if>
											<c:if test="${article.menu_form eq 'gallery'}">
												<a class="make-href" href="/gallery/galleryPost.do?menuType=${article.menu_type}&board_no=${article.board_no}">${article.title}</a>
											</c:if>
											<c:if test="${article.menu_form eq 'survey'}">
												<a class="make-href" onclick="goSurveyInfo(${article.survey_no}, '${article.menu_type}')">${article.survey_title}</a>
											</c:if>
										</td>
										<td>
											${article.id}
										</td>
										<td>
											<c:if test="${fn:length(article.content) > 30 }">
												${fn:substring(article.content, 0, 30) }...
											</c:if>
											<c:if test="${fn:length(article.content) <= 30 }">
												${article.content }
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
		 			</div>
				</div>
			</div>
		</div>
	</main>
	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		
		
		// 게시글 작성 완료 시 실행 이벤트
		// 팝업창에서 세션 만료 시 로그인 페이지로 이동
		window.call = function(){
			history.go(0);
		}
		
		
		// 게시글 상세보기
		var postPopup = '';
		function boardPost(menuType, boardNo) {
			postPopup = window.open("/board/boardPost.do?board_no=" + boardNo + '&menu_type=' + menuType + '&menuType=' + menuType,
							"_blank", "width = 500, height = 1000, top = 100, left = 200, location = no");
		}
		
		// 제목 클릭 시 해당 설문조사 페이지로
		function goSurveyInfo(survey_no, menuType) {
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
								              .val(menuType)
								              .appendTo($form);
			$form.submit();
		}
	</script>
</body>
</html>