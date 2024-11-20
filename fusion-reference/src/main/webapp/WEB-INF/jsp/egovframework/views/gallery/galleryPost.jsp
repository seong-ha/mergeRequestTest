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
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<title>퓨전 게시판(앨범)</title>
<style type="text/css">
	 .b-example-divider {
        height: 3rem;
        background-color: rgba(0, 0, 0, .1);
        border: solid rgba(0, 0, 0, .15);
        border-width: 1px 0;
        box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);
      }

      .b-example-vr {
        flex-shrink: 0;
        width: 1.5rem;
        height: 100vh;
      }

      .bi {
        vertical-align: -.125em;
        fill: currentColor;
      }

      .nav-scroller {
        position: relative;
        z-index: 2;
        height: 2.75rem;
        overflow-y: hidden;
      }

      .nav-scroller .nav {
        display: flex;
        flex-wrap: nowrap;
        padding-bottom: 1rem;
        margin-top: -1px;
        overflow-x: auto;
        text-align: center;
        white-space: nowrap;
        -webkit-overflow-scrolling: touch;
      }
      
      .tb-title {
      	width: 50%;
      }
      
      #paging_part {
	    clear: both;
	    text-align: center;
	  }
	
  	  .page_table {
	    display:inline-block;
	    border-collapse: collapse;
	  }
	
	  #paging_part .page_table td {
	    border: 1px solid #e6e6e6;
	    width:35px;
		height:35px;
	    text-align:center;
	    vertical-align: middle;
	  }
	
	  #paging_part .page_table td a {
	    color: gray;
	    font-size: 0.8rem;
	    text-decoration-line: none;
	  }
	
	  #paging_part .page_table td:hover {
	    background-color:darkslategrey;
		color: white;
		border:1px solid darkslategrey;
	    cursor: pointer;
	  }
	
	  #paging_part .page_table td:hover a {
	    color: white
	  }
	
	  #paging_part .page_table td.active {
	    background-color:darkslategrey;
		border:1px solid darkslategrey;
	  }
	
	  #paging_part .page_table td.active a{
	    color: white;
	  }
	  
	  span.noticeBadge {
	  	border: 2px solid gray;
	  	border-radius: 5px;
	  	background-color: #f9f9f8;
	  	margin-right: 5px;
	  }
      
      .page_table td a {
      	padding: 20%;
      }
      
      .page_table td a.aPadding {
      	padding: 20% 35% 20% 35%; 	
      }
      
      .aTitle {
      	color: blue;
      	text-decoration-line: none;
      }
      
      .aTitle:hover {
      	cursor: pointer;
      	color: redOrange !important;
      }
	  main.mt-5 {
		margin-top: 0 !important;
	  }

	  main.mt-5.pt-5 {
		padding-top: 0 !important;
	  }
	  
	  .menus-hover:hover {
	  	color: yellow !important;
	  }
	  
	  .selected-menu {
	  	color: blue !important;
	  }
	  
	  .gallery-text-header {
		display: flex;
		justify-content: space-between;	  
	  }
	  
	  .thumbnail:hover,
	  .gallery-text-header:hover {
	  	cursor:pointer;
	  }
	  
	  .gallery-title {
	  	font-size: 1.2rem;
	  	font-weight: bold;
	  }
	  
	  .gallery-writer {
	  	margin: 0;
	  	text-align: right;
	  	color: gray;
	  }
	  
	  .hashTag {
	  	text-decoration-line: none;
	  }
	  
	  .hashTag:hover {
	  	color: orange;
	  }
	  
	  .initGallerys-board-type {
	  	color: #FF5675;
	  }
	  
      .insert {
	    padding: 20px 30px;
	    display: block;
	    width: 100%;
	    margin: 5vh auto;
	    border: 1px solid #dbdbdb;
	    -webkit-box-sizing: border-box;
	    -moz-box-sizing: border-box;
	    box-sizing: border-box;
      }
      .insert .file-list {
      	
		height: 200px;
		overflow: auto;
		border: 1px solid #989898;
		padding: 10px;
		white-space : wrap;
		text-overflow : ellipsis;
      }
	  .insert .file-list .filebox p {
		font-size: 14px;
		margin-bottom: 0;
		display: inline-block;
	  }
	  .insert .file-list .filebox .delete {
		color: #ff5353;
		margin-left: 5px;
		cursor: pointer;
		text-decoration-line: none;
		vertical-align: middle;
		font-size: 1.5rem;
		line-height: 0;
	  }
		
	  .insert .file-list .filebox .delete:hover {
		font-weight: bold;
	  }
		
	  .insert .input-file-btn{
		padding: 6px 25px;
		background-color:#FF6600;
		border-radius: 4px;
		color: white;
		cursor: pointer;
		text-align:left;
	  }
    .like {
	  text-decoration:none; color:inherit; cursor: pointer;
	}
	
	.right_area {
		display: flex;
		align-items: center;
		justify-content: center;
		border: 1px solid gray;
		border-radius: 10px;
		width: 200px;
		margin: auto auto;
	}
	
	 .right_area .icon{
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    width: 39px;
	    height: 39px;
	
	    border-radius: 50%;
	    border: solid 2px #eaeaea;
	    background-color: #fff;
	}
	
	.icon.heart img{
	    width: 21px;
	    height: 21px;
	}
	
	.icon.heart.fas{
	  color:red
	}
	.heart{
	    transform-origin: center;
	}
	.heart.active img{
	    animation: animateHeart .3s linear forwards;
	}
	
	@keyframes animateHeart{
	    0%{transform:scale(.2);}
	    40%{transform:scale(1.2);}
	    100%{transform:scale(1);}
	}
</style>
<script type="text/javascript">
	function setCookie( name, value, expiredays ) {
	     var todayDate = new Date();
	     todayDate.setDate( todayDate.getDate() + expiredays ); 
	     document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}
	function closePop() {
	     if ( document.pop_form.chkbox.checked ){
	         setCookie( "noticePopup", "done" , 1 );
	     }
	     document.all['layer_popup'].style.visibility = "hidden";
	}
</script>
</head>
<body>
	<main class="mt-5 pt-5">
		<div class="container-fluid px-4">
			<div class="card mb-4">
				<form id="uploadFrm" method="post" onsubmit="return false;">
					<div class="container-fluid px-4">
						<h1 class="mt-4">게시글 상세보기</h1>
						<div class="card mb-4">
							<div class="card-body">
								<div style="display:flex; justify-content: space-between">
									<div class="mb-3" style="width:79%">
										<label for="title" class="form-label">제목</label>
										<input type="text" class="form-control" id="title" name="title" value="${board.title}" readonly>
									</div>
									<div class="mb-3" style="width:20%">
										<label for="menu_type" class="form-label">게시판 유형</label>
										<span class="form-control">
											<c:forEach items="${headerMenuList}" var="headerMenu">
												<c:if test="${headerMenu.menu_type == menuType}">
													${headerMenu.menu_name}
												</c:if>											
											</c:forEach>
										</span>
										<input type="hidden" class="form-control" id="menu_type" name="menu_type" value="${board.menu_type}" readonly>
									</div>
								</div>
								<div class="mb-3">
									<label for="content" class="form-label">내용</label>
									<textarea class="form-control" id="content" name="content" readonly>${board.content}</textarea>
								</div>
								<div class="mb-3">
									<label for="files" class="form-label">사진</label>
									<div class="form-control" id="files">
										<div style="text-align: center">
											<c:forEach items="${files}" var="file">
												<img alt="" width="80%" src="/gallery/img.do?save_name=${file.save_name}&origin_name=${file.origin_name}&menuType=${menuType}">
												<br><br>
											</c:forEach>
										</div>
										<hr>
										<c:forEach items="${files}" var="file">
											<div>
												<fmt:parseNumber var="volume" integerOnly="true" value="${file.volume / 1000}"/>
												<a href="/gallery/download.do?save_name=${file.save_name}&origin_name=${file.origin_name
														}&files_no=${file.files_no}&menuType=${menuType}" style="text-decoration-line: none;" onclick="updDownCnt(${file.down_cnt})">
													${file.origin_name} (${volume}KB)</a>
												<span>${file.down_cnt}</span>회 다운로드
											</div>
										</c:forEach>
										<br>
										<div class="right_area">
										  <span>좋아요</span>&nbsp;<span id="like_cnt">${board.like_cnt}</span>&nbsp;											  
										  <a href="javascript:;" class="icon heart like <c:if test='${like.is_liked == 1}'>active</c:if>">
									     	<c:choose>
									     		<c:when test="${like.is_liked == 1}">
									     			<img src="https://cdn-icons-png.flaticon.com/512/803/803087.png" alt="좋아요">
									     		</c:when>
									     		<c:otherwise>
									     			<img src="https://cdn-icons-png.flaticon.com/512/812/812327.png" alt="좋아요 취소">
									     		</c:otherwise>
									     	</c:choose>
										  </a>
										</div>
									</div>
								</div>
								
								<c:if test="${not empty tags}">
									<div class="mb-3">
										<label for="tag" class="form-label">태그</label>
										<div class="form-control" id="tag">
											<c:forEach items="${tags}" var="tag">
												<a href="/gallery/galleryList.do?srchType=tag_exact&srchText=${tag.tag_name}" class="hashTag">#${tag.tag_name}</a>
											</c:forEach>
										</div>
									</div>
								</c:if>
								
								<!-- 자신이 쓴 글이면 버튼 나타나기 -->
								<c:if test="${board.member_no == member_no || author == 'ADMIN' || author == 'SUPERADMIN'}">
									<button class="btn btn-outline-warning" onclick="goUpdPage(${board.board_no}, '${board.menu_type}', '${menuType}', '${returnUrl}')">수정하기</button>
									<!-- <button type="button" class="btn btn-outline-warning" onclick="movePage()">수정하기2</button> -->
									<button type="button" class="btn btn-outline-danger" onclick="delGallery(${board.board_no}, ${board.member_no})">삭제하기</button>
								</c:if>
								<button id="goBack" type="button" class="btn btn-outline-danger" onclick="goBacks('${returnUrl}', '${returnUrl2}')">돌아가기</button>
							</div>
						</div>
					</div>
				</form>				
			</div>
		</div>
	</main>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		likeBtn();	// 좋아요 버튼 이벤트 등록
		
		let bt = `${menuType}`;
		console.log(bt);
		$('#' + bt).addClass('selected-menu');	// 선택한 메뉴
	});
	window.onload = function(){
		
	}
	function goBacks(returnUrl, returnUrl2) {
		console.log(returnUrl, returnUrl2)
		if (returnUrl == null || returnUrl == '' || returnUrl2 == null || returnUrl2 == '') {
			history.back();
			return;
		}
		if (returnUrl.indexOf(',') != -1) {
			returnUrl = returnUrl.substring(0, returnUrl.indexOf(','));
		}
		
		location.href = returnUrl
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
	
	// 좋아요 버튼 이벤트
	function likeBtn() {
	    var likeBtn =$('.icon.heart');
	    likeBtn.click(function(){
        	// 좋아요 취소
       		if (likeBtn.hasClass('active')) {
       			updLike('좋아요 취소');
       			
       			likeBtn.removeClass('active');
       			$(this).find('i').removeClass('fas').addClass('far');
 	            $(this).find('img').attr({
 	                'src': 'https://cdn-icons-png.flaticon.com/512/812/812327.png',
 	                alt:"찜하기"
 	            });
       		} else {
       			updLike('좋아요!');
       			
       			likeBtn.addClass('active');
       			$(this).find('img').attr({
  	              'src': 'https://cdn-icons-png.flaticon.com/512/803/803087.png',
  	               alt:'찜하기 완료'
  	                });
       		}
	        	
	     })
	}
	
	// 좋아요 등록 및 수정 후, 화면의 board_cnt횟수 반영
	function updLike(str) {
		$.ajax({
			url: '/board/updLike.do',
			type: 'post',
			data: {"board_no" : ${board.board_no} },
			success: function(data) {
			   alert(str);
			   let updLikeCnt = Number($('#like_cnt').text()) + (data.update_amount);
			   $('#like_cnt').text(updLikeCnt); 
			},
			error: function(error) {
				console.log(error);
			}
		});
	}
	
	// 화면단 다운로드 횟수 즉각 반영
	function updDownCnt(downCnt) {
		let nowCnt = Number($(event.target).next().text());
		$(event.target).next().text(nowCnt + 1);
	}
	
	function galleryPostModify() {
		
	}
	
/* 	function movePage() {
		$('<form>').attr('action', '/gallery/galleryPostModify.do?board_no=${board.board_no}&menuType=${menuType}')
				   .attr('mehtod', 'post')
				   .appendTo($('body'))
				   .submit();
	} */
	
	function goUpdPage(board_no, menu_type, menuType, returnUrl) {
		var returnUrl2 = window.location.pathname + window.location.search;
		console.log(window.location.pathname);
// 		returnUrl = returnUrl.replaceAll('&','%26');
// 		returnUrl2 = returnUrl2.replaceAll('&','%26');
		var params = 'board_no=' + board_no + '&menu_type=' + menu_type +'&menuType=' + menuType + '&returnUrl=' +  encodeURIComponent(returnUrl) + '&returnUrl2=' +  encodeURIComponent(returnUrl2);

		location.href = '/gallery/galleryPostModify.do?'+ params;
	}
	
	function delGallery(board_no, member_no) {
		
		if(window.confirm("삭제하시겠습니까?")) {
			let data = {
					"board_no" : board_no,
					"member_no" : member_no
			}
			$.ajax({
		    	url: '/gallery/delGallery.do',
				type: 'post',
				/* contentType: 'application/json', */
				data: data,
				dataType: 'json',
		        success: function(data) {
					if (data.result == '성공') {
						alert(data.msg);
						$('#goBack').click();
					} else if (data.result == '실패') {
						alert(data.msg);
					}
				},
				error: function(error) {
					console.log(error);
				}
		    })
		}
		 
	}
	
</script>
</html>