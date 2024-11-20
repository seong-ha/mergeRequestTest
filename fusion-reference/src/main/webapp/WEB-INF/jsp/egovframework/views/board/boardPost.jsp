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
<title>퓨전 게시판(상세보기)</title>
<style type="text/css">
	main.mt-5 {
		margin-top: 0 !important;
	}

	main.mt-5 .pt-5 {
		padding-top: 0 !important;
	}
	.card mb-4 {
		padding-left: 10px;
		padding-right: 10px;
	}
	main {
		max-width:500px;
		min-width:499px;
	}
	
	.cmmt-lev_0 {
		width: 100%;
		display: flex;
		justify-content: space-between;
	}
	
	.cmmt-lev_0 > textarea {
		width: 80%;
		height: 60px;
	}
	
	.cmmt-title {
		font-size: 25px;
		font-weight: bold;
		margin-bottom: 10px;
	}
	
	.cmmt {
		margin-left: 20px;
	}
	
	.reply_cmmt,
	.update_cmmt,
	.delete_cmmt {
		color: white;
		padding: 1px 1px;
	}
	
	#cmmt-content {
		display: block;
	}
	
	.rereplyBtn {
		margin-bottom: 20px;
		margin-left: 10px;
	}
</style>
</head>
<body>
	<main class="mt-5 pt-5">
		<!-- 게시글 조회 start-->
		<div class="container-fluid px-4">
			<h1>게시글 조회</h1>
			<div class="card mb-4">
				<div class="card-body">
					<input type="hidden" id="board_no" value="${boardPost.board_no}">
					<div class="mb-3">
						<label for="title" class="form-label">제목</label>
						<input type="text" class="form-control" id="title" name="title" value="${boardPost.title}" readOnly>
					</div>
					<div class="mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea class="form-control"readOnly>${boardPost.content}</textarea>
					</div>
					<div class="mb-3">
						<label for="writer" class="form-label">작성자</label>
						<input type="text" class="form-control" id="id" name="id" value="${boardPost.id}" disabled>
					</div>
					<!-- 자신이 쓴 글이면 버튼 나타나기 -->
					<c:if test="${boardPost.member_no == member_no || author == 'ADMIN' || author == 'SUPERADMIN'}">
						<button class="btn btn-outline-warning" onclick="location.href='/board/boardPostModify.do?board_no=${boardPost.board_no}&menu_type=${boardPost.menu_type}&menuType=${menuType}'">수정하기</button>
						<button type="button" class="btn btn-outline-danger" onclick="delBoard('${boardPost.board_no}', ${boardPost.member_no})">삭제하기</button>
					</c:if>
					<!-- 일반글은 답글 가능 -->
					<c:if test="${boardPost.type == 'normal'}">
						<button class="btn btn-outline-danger" onclick="location.href='/board/boardRegister.do?parent_no=${boardPost.board_no
								}&re_lev=${boardPost.re_lev}&type=${boardPost.type}&menu_type=${boardPost.menu_type}&menuType=${menuType}'">답글</button>
					</c:if>
					<button type="button" class="btn btn-outline-danger" onclick="javascript:window.close()">닫기</button>
				</div>
			</div>
		</div>
		<!-- 게시글 조회 end-->
	
		<!-- 댓글 start-->
		<div class="container-fluid px-4">
			<div class="card mb-4">
				<span class="cmmt-title">댓글 
					<span style="font-size: 20px; color: green">${commentsList[0].total}</span>
				</span>
				<div class="mb-2 cmmt-lev_0">
					<textarea id="content" name="content"></textarea>
					<button type="button" id="insCmmt"
							class="btn btn-outline-primary" onclick="insCmmt(0,0)">작성</button>
				</div>
				<c:if test="${empty commentsList}">
					<div class="mb-2 cmmt">
				    	<h6><strong>등록된 댓글이 없습니다.</strong></h6>
					</div>
				</c:if>
				<c:if test="${not empty commentsList}">
					<c:forEach items="${commentsList}" var="comments">
						<div class="mb-2 cmmt"
							<c:if test="${comments.re_lev > 1}">
									style="margin-left: ${20 + (comments.re_lev - 1) * 30}px"
							</c:if>>
							<c:if test="${comments.re_lev > 1}">⤷</c:if>
							<c:if test="${comments.del_yn == 'N'}">
							    <b id="">
							    	${comments.id}
							    	<c:if test="${comments.regist_dt != comments.update_dt}">
							    		<b style="color:green">[수정됨]</b>
							    	</c:if>
							    </b>
							    <span style="float:right;" align="right" id="">${comments.regist_dt}</span>
							    <span id="cmmt-content">${comments.content}</span>
							    <button type="button" id="replyBtn" class="reply_cmmt btn btn-sm btn-primary replyBtn" onclick="reply()">대댓글</button>
							    
							    <c:if test="${member_no == comments.member_no}">
								    <button type="button" class="updateBtn update_cmmt btn btn-sm btn-secondary" onclick="update('${comments.content}')">수정</button>
								    <button type="button" class="updateBtn delete_cmmt btn btn-sm btn-danger" onclick="deleteReply('${comments.comments_no}', '${comments.member_no}')">삭제</button>
							    </c:if>
							    <c:if test="${member_no != comments.member_no && (author == 'ADMIN' || author == 'SUPERADMIN')}">
							    	<button type="button" class="updateBtn delete_cmmt btn btn-sm btn-danger" onclick="deleteReply('${comments.comments_no}', ${comments.member_no})">삭제</button>
							    </c:if>
							    <hr>
							    
							    <input type="hidden" id="" value="${comments.member_no}">
							    <input type="hidden" id="" value="${comments.parent_no}">
							    <input type="hidden" id="comments_no_${comments.comments_no}" value="${comments.comments_no}">
							    <input type="hidden" id="" value="${comments.board_no}">
							    <input type="hidden" id="" value="${comments.re_lev}">
						    </c:if>
						   <c:if test="${comments.del_yn == 'Y'}">
						    	<b id="">삭제된 댓글입니다.</b>
						    	<hr>
						    </c:if>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<!-- 댓글 end-->
	</main>
	<input type="hidden" id="sessionResult" value="${msg}">
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		/* 세션 만료로 인한 메세지를 input hidden으로 받아둔다.
		 받아둔 값이 존재하면 메세지를 띄우고 부모윈도우를 새로고침하고 팝업창을 닫는다. */
		let sessionResult = $('#sessionResult').val();
		if (sessionResult.length != 0) {
			alert(sessionResult);
			opener.call();
			window.close();
		}
		
		opener.call();
	});
	
	// 댓글 등록
	function insCmmt(parent_no, re_lev) {
		let board_no = $('#board_no').val();
		let content = $('#content').val().trim();
		
		if (content.length == 0) {
			alert('댓글을 입력해주세요');
			$('#content').focus();
			return;
		}
		
		if (content.length > 3000) {
			alert('3000자 미만으로 입력해주세요.');
			$('#content').focus();
			return;
		}
		
		let data = {
				'board_no': board_no,
				'content': content,
				'parent_no': parent_no,
				're_lev': re_lev,
		};
		
		$.ajax({
			url: '/board/insComment.do',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(data) {
				if (data.result == 0) {
					alert(data.msg);
				} else if (data.result == 1) {
					history.go(0);
				} else if (data.result == 2) {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});	
		
	}
	var replyBtn = '';
	var updateBtn = '';
	var deleteBtn = '';
	var input = '';
	
	// 대댓글 버튼 시, 대댓글 입력 환경 추가 및 기존 버튼들 숨김
	function reply() {
		// 남아있는 대댓글 입력 창과 버튼을 삭제
		$('#rereplyInput').remove();
		$('#rereplyBtn').remove();
		$('#rereplyUpdateBtn').remove();
		
		// 원래 있던 대댓글, 수정, 삭제 버튼을 보이게 돌려놓기
		$('.replyBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		$('.updateBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		$('.deleteBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		
		// 타겟 댓글의 숨길 대댓글, 수정, 삭제 버튼
		replyBtn = $(event.target);
		updateBtn = $(event.target).next();
		deleteBtn = $(event.target).next().next();
		
		// 대댓글 입력 창과 버튼을 추가
		let input = $("<textarea id='rereplyInput' style='width:80%; height:30px'></textarea>");
		let regBtn = $("<button id='rereplyBtn' type='button' class='reply_cmmt btn btn-sm btn-primary rereplyBtn' onclick='rereplyReg()'>등록</button>");
		
		replyBtn.parent().append(input);
		replyBtn.parent().append(regBtn);
		
		// 타겟 댓글의 대댓글, 수정, 삭제 버튼 숨겨주기
		replyBtn.css('display', 'none');
		updateBtn.css('display', 'none');
		deleteBtn.css('display', 'none');
	}
	
	// 대댓글 등록 후 새로고침
	function rereplyReg() {
		let content = $(event.target).prev().val();
		let re_lev = $(event.target).prev().prev().val();
		let board_no = $(event.target).prev().prev().prev().val();
		let parent_no = $(event.target).prev().prev().prev().prev().val();
		
		if (content.length == 0) {
			alert('대댓글을 입력해주세요.');
			$(event.target).prev().focus();
			return;
		}
		
		if (content.length > 3000) {
			alert('3000자 미만으로 입력해주세요.');
			$(event.target).prev().focus();
			return;
		}
		
		let data = {
				'content': content,
				're_lev': parseInt(re_lev) + 1,
				'board_no': board_no,
				'parent_no': parent_no
		};
		console.log(data);
		$.ajax({
			url: '/board/insComment.do',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(data) {
				if (data.result == 0) {
					alert(data.msg);
				} else if (data.result == 1) {
					history.go(0);
				} else if (data.result == 2) {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});
	}
	
	// 수정 버튼 시, 수정 환경 추가 및 기존 버튼들 숨김
	function update(content) {
		// 남아있는 대댓글 입력 창과 버튼을 삭제
		$('#rereplyInput').remove();
		$('#rereplyBtn').remove();
		$('#rereplyUpdateBtn').remove();
		
		// 원래 있던 대댓글, 수정, 삭제 버튼을 보이게 돌려놓기
		$('.replyBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		$('.updateBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		$('.deleteBtn').each(function(index, item){
			$(item).css('display', 'inline');
		});
		
		// 타겟 댓글의 숨길 대댓글, 수정, 삭제 버튼
		updateBtn = $(event.target);
		replyBtn = $(event.target).prev();
		deleteBtn = $(event.target).next();
		
		// 대댓글 입력 창과 버튼을 추가
		let input = $("<textarea id='rereplyInput' style='width:80%; height:30px'>" + content + "</textarea>");
		let regBtn = $("<button id='rereplyUpdateBtn' type='button' class='reply_cmmt btn btn-sm btn-primary rereplyBtn' onclick='rereplyUpdate()'>수정</button>");
		replyBtn.parent().append(input);
		replyBtn.parent().append(regBtn);
		
		// 타겟 댓글의 대댓글, 수정, 삭제 버튼 숨겨주기
		replyBtn.css('display', 'none');
		updateBtn.css('display', 'none');
		deleteBtn.css('display', 'none');
	}
	
	// 댓글 수정
	function rereplyUpdate() {
		let content = $(event.target).prev().val();
		let comments_no = $(event.target).prev().prev().prev().prev().val();
		let member_no = $(event.target).prev().prev().prev().prev().prev().prev().val();
		
		if (content.length == 0) {
			alert('수정 내용을 입력해주세요.');
			$(event.target).prev().focus();
			return;
		}
		
		let data = {
				'content': content,
				'comments_no': comments_no,
				'member_no': member_no
		};
		
		$.ajax({
			url: '/board/updComment.do',
			type: 'post',
			contentType: 'application/json',
			data: JSON.stringify(data),
			dataType: 'json',
			success: function(data) {
				if (data.result == 0) {
					alert(data.msg);
				} else if (data.result == 1) {
					history.go(0);
				} else if (data.result == 2) {
					alert(data.msg);
				} else if (data.result == 3) {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});
		
	}
	
	function deleteReply(comments_no, member_no) {
		let data = {
				'comments_no': comments_no,
				'member_no': member_no
		};
		
		
		$.ajax({
			url: '/board/delComment.do',
			type: 'post',
			contentType: 'application/json',
			data: JSON.stringify(data),
			dataType: 'json',
			success: function(data) {
				if (data.result == 0) {
					alert(data.msg);
				} else if (data.result == 1) {
					history.go(0);
				} else if (data.result == 2) {
					alert(data.msg);
				} else if (data.result == 3) {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});
	}
	
	// 게시글 삭제
	function delBoard(board_no, member_no) {
		let data = {
				'board_no': board_no,
				'member_no': member_no
		};
		if (confirm("삭제하시겠습니까?")) {
			$.ajax({
				url: '/board/delBoardPost.do',
				type: 'post',
				contentType: 'application/json',
				data: JSON.stringify(data),
				dataType: 'json',
				success: function(data) {
					if (data.result == 0) {
						alert(data.msg);
					} else if (data.result == 1) {
						opener.call();
						window.close();
					} else if (data.result == 2) {
						alert(data.msg);
					} else if (data.result == 3) {
						alert(data.msg);
					}
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
	}
</script>
</html>