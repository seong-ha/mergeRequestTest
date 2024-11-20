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
<title>퓨전 게시판(목록)</title>
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
		<h1 class="mt-4">
			<c:forEach items="${headerMenuList}" var="headerMenu">
				<c:if test="${headerMenu.menu_type == menuType}">
					<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
				</c:if>											
			</c:forEach>
		</h1>

		<div style="display: flex; justify-content:space-between">
			<!-- 몇줄씩 보기 start -->
			<div>
				<input type="hidden" id="hidsrchType" value="${srchType}">
				<input type="hidden" id="hidsrchText" value="${srchText}">
				<select id="cntPerPage" name="cntPerPage" onchange="cntPerPageChange()">
					<option value="5"
							<c:if test="${paging.cntPerPage == 5}">selected</c:if>>5개씩</option>
					<option value="10"
							<c:if test="${paging.cntPerPage == 10}">selected</c:if>>10개씩</option>
					<option value="15"
							<c:if test="${paging.cntPerPage == 15}">selected</c:if>>15개씩</option>
					<option value="20"
							<c:if test="${paging.cntPerPage == 20}">selected</c:if>>20개씩</option>
				</select>
			</div>
			<!-- 몇줄씩 보기 end -->
			
			<!-- 검색 start -->
			<div>
				<select id="srchType" name="srchType">
					<option value="all"
							<c:if test="${search.srchType == 'all'}">selected</c:if>>전체</option>
					<option value="writer"
							<c:if test="${search.srchType == 'writer'}">selected</c:if>>작성자</option>
					<option value="title"
							<c:if test="${search.srchType == 'title'}">selected</c:if>>제목</option>
					<option value="content"
							<c:if test="${search.srchType == 'content'}">selected</c:if>>내용</option>
				</select>
	            <input type="text" placeholder="Search..." id="srchText" name="srchText" value="${search.srchText}">
	            <button type="button" class="btn btn-sm btn-info" onclick="search()">검색</button>
			</div>
			<!-- 검색 start -->
		</div>
		
		<div class="card mb-4">
			<div class="card-header">
				<a class="btn btn-primary float-end" onclick="boardRigister()">
					<i class="fas fa-edit"></i> 글 작성
				</a>
				<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">
					<a class="btn btn-danger float-end" onclick="chkBoardDelete()">
						<i class="fas fa-edit"></i> 체크삭제
					</a>
				</c:if>
			</div>
			<div class="card-body">
				<table class="table table-hover table-striped">
					<thead>
						<tr style="width: 100%">
							<!-- 관리자일 시 체크박스 표시 -->
							<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">
								<td></td>
							</c:if>
							<th>글번호</th>
							<th class="tb-title">제목</th>
							<th>작성자</th>
							<th>조회수</th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<!-- 공지사항 start -->
						<c:if test="${not empty noticeList}">
							<c:if test="${paging.nowPage == 1}">
								<c:forEach items="${noticeList}" var="notice">
									<tr style="border-left: 2px solid red">
										<!-- 관리자일 시 체크박스 표시 -->
										<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">
											<td>
												<input class="form-check-input" type="checkbox" value="${notice.board_no}" id="flexCheckDefault">
											</td>
										</c:if>
										<td>${notice.board_no}</td>
										<td>
											<span class="noticeBadge">공지</span>
											<a class="aTitle" onclick="boardPost(${notice.board_no})">${notice.title}</a>
										</td>
										<td>${notice.id}</td>
										<td>${notice.board_cnt}</td>
										<td>${notice.regist_dt}</td>
									</tr>
								</c:forEach>
							</c:if>
						</c:if>
						<!-- 공지사항 end-->
						
						<!-- 일반 게시물 start -->
						<c:if test="${empty boardList}">
							<tr>
								
								<td colspan="<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">6</c:if><c:if test="${author != 'ADMIN' || author != 'SUPERADMIN'}">5</c:if>" style="text-align:center">게시물이 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${not empty boardList}">
							<c:forEach items="${boardList}" var="board">
								<tr>
									<!-- 관리자일 시 체크박스 표시 -->
									<c:if test="${author == 'ADMIN' || author == 'SUPERADMIN'}">
										<td>
											<input class="form-check-input" type="checkbox" value="${board.board_no}" id="flexCheckDefault">
										</td>
									</c:if>
									<td>${board.board_no}</td>
									<td>
										<!-- 답글 깊이 표시 -->
										<c:if test="${board.re_lev > 1}">
											<c:forEach begin="2" end="${board.re_lev}" varStatus="status">
												&nbsp;&nbsp;
												<c:if test="${status.last}">⤷Re:</c:if>
											</c:forEach>
										</c:if>
										<a class="aTitle" onclick="boardPost(${board.board_no})">${board.title}</a>
									</td>
									<td>${board.id}</td>
									<td>${board.board_cnt}</td>
									<td>${board.regist_dt}</td>
								</tr>
							</c:forEach>
						</c:if>
						<!-- 일반 게시물 end -->
					</tbody>
				</table>
			</div>
		</div>
	</div>
	</main>
	
	<div id="paging_part">
        <table class="page_table">
            <tr>
            	<td>
            		<a href="/board/boardList.do?nowPage=1&cntPerPage=${paging.cntPerPage
            				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}">&lt;&lt;</a>
            	</td>
            	<td>
            		<a <c:if test="${paging.startPage != 1}">
            				href="/board/boardList.do?nowPage=${paging.startPage - 1
            				}&cntPerPage=${paging.cntPerPage}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}"
            			</c:if> class="aPadding">
            			&lt;
            		</a>
            	</td>
            	<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
            		<c:choose>
            			<c:when test="${p == paging.nowPage}">
            				<td class="active">
            					<a>${p}</a>
            				</td>
            			</c:when>
            			<c:when test="${p != paging.nowPage}">
            				<td>
            					<a href="/board/boardList.do?nowPage=${p}&cntPerPage=${paging.cntPerPage
            							}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}" class="aPadding">${p}</a>
            				</td>
            			</c:when>
            		</c:choose>
            	</c:forEach>
            	<td>
            		<a class="aPadding"
           				<c:if test="${paging.endPage != paging.lastPage}">
           				href="/board/boardList.do?nowPage=${paging.endPage + 1}&cntPerPage=${paging.cntPerPage
           				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}"
           				</c:if>>&gt;</a>
            	</td>
            	<td>
            		<a href="/board/boardList.do?nowPage=${paging.lastPage}&cntPerPage=${paging.cntPerPage
            				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}">&gt;&gt;</a>
            	</td>
            </tr>
        </table>
    </div>
    <!-- layer popup content -->
	<!-- Button trigger modal -->
	<button id="modalTrigger" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" style="display:none">
	  modal on
	</button>
	
	<!-- Modal -->
	<div class="modal" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" style="margin-left: 50px;margin-top: 100px;">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h1 class="modal-title fs-5" id="exampleModalLabel"><strong>공지사항</strong></h1>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	      	<h5>${popup.title}</h5><br>
	        <p>${popup.content}</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-primary" data-bs-dismiss="modal" onclick="todayNoticeOff()">하루동안 보이지 않기</button>
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
<%--     <span>nowPage${paging.nowPage}</span> --%>
<%-- 	<span>startPage${paging.startPage}</span> --%>
<%-- 	<span>endPage${paging.endPage}</span> --%>
<%-- 	<span>lastPage${paging.lastPage}</span> --%>
<%-- 	<span>total${paging.total}</span> --%>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
	    $('#${menuType}').addClass('selected-menu');
	    
	    let cookiedata = document.cookie;
	    if ( cookiedata.indexOf("noticePopup=done") < 0 ){     
	    	$('#modalTrigger').click();
	    }
	});
	
	// 공지사항 레이어 팝업 하루동안 보지 않기
	function todayNoticeOff() {
		setCookie('noticePopup', 'done', 1);
		
		/* head에 등록되어있음
		function setCookie( name, value, expiredays ) {
		     var todayDate = new Date();
		     todayDate.setDate( todayDate.getDate() + expiredays ); 
		     document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
		}
		*/
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
	// 게시글 수 변화 시, 적용된 페이지 조회 함수
	function cntPerPageChange() {
		let selected = $('#cntPerPage').val();
		let srchType = $('#srchType').val();
		let srchText = $('#srchText').val();
		let menuType = $('#menuType').val();
		
		location.href='/board/boardList.do?nowPage=1&cntPerPage='+ selected +
						'&srchType=' + srchType + '&srchText=' + srchText + '&menuType=' + menuType;
	}
	
	// 검색 버튼 함수
	function search() {
		let srchType = $('#srchType').val();
		let srchText = $('#srchText').val();
		let cntPerPage = $('#cntPerPage').val();
		let menuType = $('#menuType').val();
		
		// 검색어 길이 제한
		if (srchText.length > 60) {
			alert('60자 미만으로 입력해주세요.');
			$('#srchText').focus();
			return;
		}
		
		// 특수문자 처리
		let exceptionChar = ['#', '%', '^', '&', '_', '+', '\\', '|', '[', ']', '{', '}', '`'];
		
		for(let i = 0; i < exceptionChar.length; i++) {
			if (srchText.indexOf(exceptionChar[i]) != -1) {
				alert('#   %   ^   &   _   +   \\   |   [   ]   {   }   ` \n특수문자를 제외한 검색어를 입력해주세요.');
				$('#srchType').focus();
				return;
			}
		}
		
		location.href='/board/boardList.do?srchType=' +
						srchType + '&srchText=' + srchText + '&cntPerPage=' + cntPerPage + '&menuType=' + menuType;
	}
	
	// 게시글 작성 버튼 함수
	var registPopup = '';
	function boardRigister() {
		registPopup = window.open("/board/boardRegister.do?menuType=${menuType}",
						"_blank", "width = 500, height = 1000, top = 100, left = 200, location = no");
		/*
 		registPopup.addEventListener('beforeunload', function() {
			history.go(0);
			event.preventDefault();
		});
		 */
	}
	
	// 게시글 작성 완료 시 실행 이벤트
	// 팝업창에서 세션 만료 시 로그인 페이지로 이동
	window.call = function(){
		history.go(0);
	}
	
	
	// 게시글 상세보기
	var postPopup = '';
	function boardPost(boardNo) {
		postPopup = window.open("/board/boardPost.do?board_no=" + boardNo + '&menu_type=${menuType}&menuType=${menuType}',
						"_blank", "width = 500, height = 1000, top = 100, left = 200, location = no");
	}
	
	// 체크 후 다중 삭제
	function chkBoardDelete() {
		let checked = $('.form-check-input:checked')
		
		if(checked.length == 0) {
			alert('삭제할 글을 체크해주세요.');
			return;
		}
		
		let data = [];
		$(checked).each(function(index, item){
			data.push(item.value);
		});
		
		$.ajax({
			url: '/board/delChkBoard.do',
			type: 'post',
			data: {'checkedList': data,
				   'menuType': '${menuType}'},
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
</script>
</html>