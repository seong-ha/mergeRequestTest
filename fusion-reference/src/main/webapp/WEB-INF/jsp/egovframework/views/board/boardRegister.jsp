<%
/*********************************************************
 * 업 무 명 : 게시판 컨트롤러
 * 설 명 : 게시판을 조회하는 화면에서 사용 
 * 작 성 자 : 김민규
 * 작 성 일 : 2022.10.06
 * 관련테이블 : 
 * Copyright ⓒ fusionsoft.co.kr
 *
 *********************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<title>퓨전 게시판(작성)</title>
<style type="text/css">
	main.mt-5 {
		margin-top: 0 !important;
	}

	main.mt-5 .pt-5 {
		padding-top: 0 !important;
	}
</style>
</head>
<body>
	<main class="mt-5 pt-5">
	<div class="container-fluid px-4">
		<h1 class="mt-4">게시글 작성</h1>
		<div style="display: flex; justify-content: end;">
			<span>게시글 유형:</span>
			<select id="type" name="type">
				<!-- 일반 글 작성 시 -->			
				<c:if test="${empty boardReply}">
					<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">
						<option value="notice">공지사항</option>	
					</c:if>
					<option value="normal">일반</option>
				</c:if>
				
				<!-- 답글 작성 시(공지사항은 답글 불가) -->
				<c:if test="${not empty boardReply}">
					<option value="normal" selected>일반</option>
				</c:if>
			</select>
		</div>
		<div class="card mb-4">
			<div class="card-body">
				<form method="post" action="/board/insBoardPost.do" onsubmit="return false;">
					<div class="mb-3">
						<label for="title" class="form-label">제목</label>
						<input type="text" class="form-control" id="title" name="title" value="">
					</div>
					<div class="mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea class="form-control" id="content" name="content"></textarea>
					</div>
					
					<input type="hidden" class="form-control" id="member_no" name="member_no" value="${member_no}">
					
					<!-- 답글 작성 시 같이 넘겨줄 원글 정보 -->
					<c:if test="${not empty boardReply}">
						<input type="hidden" class="form-control" id="parent_no" name="parent_no" value="${boardReply.parent_no}">
						<input type="hidden" class="form-control" id="re_lev" name="re_lev" value="${boardReply.re_lev}">
					</c:if>
					
					
					<!-- <a href="/board/boardList.do" class="btn btn-outline-secondary">목록</a> -->
					<button type="button" id="reg" class="btn btn-outline-warning">등록하기</button>
					<button type="button" class="btn btn-outline-danger" id="popupClose" onclick="javascript:window.close();">닫기</button>
				</form>
			</div>
		</div>
	</div>
	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		insertBoard();	// 등록하기 버튼 이벤트 등록
	});
	
	// 등록하기 버튼 이벤트
	function insertBoard() {
		$('#reg').on('click', function() {
			let title = $('#title').val();
			let content = $('#content').val();
			let member_no = $('#member_no').val();
			let type = $('#type').val();
			
			// 빈값 체크
			if (title.length == 0) {
				alert('제목을 입력해주세요.');
				$('#title').focus();
				return;
			} else if (title.length > 300) {
				alert('300자 미만으로 입력해주세요.');
				$('#title').focus();
				return;
			} else if (content.length == 0) {
				alert('내용을 입력해주세요.');
				$('#content').focus();
				return;
			} else if (content.length > 3000) {
				alert('3000자 미만으로 입력해주세요.');
				$('#content').focus();
				return;
			}
			
			let data = {
					'title': title,
					'content': content,
					'member_no': member_no,
					'type': type,
					'menu_type': '${menuType}'
			};

			// 답글 등록일 시, 파라미터 추가
			let parent_no = $('#parent_no').val();
			let re_lev = $('#re_lev').val();
			
			if (parent_no != undefined && re_lev != undefined) {
				data = {
						'title': title,
						'content': content,
						'member_no': member_no,
						'type': type,
						'parent_no': parent_no,
						're_lev': re_lev,
						'menu_type': '${menuType}'
				};
			}
			
			$.ajax({
				url: '/board/insBoardPost.do',
				type: 'post',
				contentType: 'application/json',
				data: JSON.stringify(data),
				success: function(data) {
				   if (data == '세션 만료') {
					   alert('세션 만료로 로그아웃되었습니다. 로그인 후 이용해주세요.');
					  opener.call();
					  window.close();
				   } else if (data.length != 0){
						alert(data);
						opener.call();
						window.open('', '_self').close();
					} else {
						alert(data);
					}
				},
				error: function(error) {
					console.log(error);
				}
			});	
		})
		
	}
</script>
</html>