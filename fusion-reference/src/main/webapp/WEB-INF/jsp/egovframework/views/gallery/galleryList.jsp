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
	
	.board-cnt {
		font-size: 0.9rem;
    	font-style: italic;
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
			<div style="display: flex; justify-content:flex-end">
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
						<option value="tag"
								<c:if test="${search.srchType == 'tag'}">selected</c:if>>태그(포함)</option>
						<option value="tag_exact"
								<c:if test="${search.srchType == 'tag_exact'}">selected</c:if>>태그(정확)</option>
					</select>
		            <input type="text" placeholder="Search..." id="srchText" name="srchText" value="${search.srchText}">
		            <button type="button" class="btn btn-sm btn-info" onclick="search()">검색</button>
				</div>
				<!-- 검색 start -->
			</div>
			
			<div class="card mb-4">
				<!-- 갤러리 전체 게시판에서는 게시글 작성 불가 -->
				<c:if test="${menuType != 'gallery_all'}">
					<div class="card-header">
						<a class="btn btn-primary float-end" onclick="galleryRigister()">
							<i class="fas fa-edit"></i> 글 작성
						</a>
					</div>
				</c:if>
				<div class="card-body">
					<%-- <c:if test="${not empty noticeList}">
						<c:if test="${paging.nowPage == 1}">
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
									<!-- 공지사항 end-->
								</tbody>
							</table>
						</c:if>
					</c:if> --%>
					
					<!-- 앨범 start -->
					<div class="album py-5 bg-light">
						<c:if test="${empty boardList}">
							<div style="text-align: center">게시물이 없습니다.</div>
						</c:if>
					    <div class="container">
					      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-xl-4 g-3">
						      <c:forEach items="${boardList}" var="board">
						        <div class="col">
						          <div class="card shadow-sm">
						            <img class="thumbnail" onclick="galleryPost(${board.board_no}, '${board.menu_type}', '${menuType}')"alt=""
						            	<c:forEach items="${thumbList}" var="thumb">
						            		<c:if test="${thumb.board_no == board.board_no}"> 
						            			src="/gallery/thumbnail.do?menuType=${menuType}&save_name=${thumb.save_name}&origin_name=${thumb.origin_name}"
						            		</c:if>
						            		
						            	</c:forEach>
						            	/>
						            <div class="card-body">
						            	<div class="gallery-text-header" onclick="galleryPost(${board.board_no}, '${board.menu_type}', '${menuType}')">
							              <p class="card-text gallery-title">${board.title}</p>
							              <p class="gallery-writer">${board.id}</p>
						            	</div>
						              <p class="galleryList-board-type">
						              	<c:forEach items="${headerMenuList}" var="headerMenu">
											<c:if test="${headerMenu.menu_type == menuType}">
												<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
											</c:if>											
										</c:forEach>
									  </p>
						              <c:forEach items="${tagList}" var="tag">
								      	<c:if test="${tag.board_no == board.board_no }">
							          		<a href="/gallery/galleryList.do?srchType=tag_exact&srchText=${tag.tag_name}&menuType=${menuType}" class="hashTag">#${tag.tag_name}</a>
							      	  	</c:if>
							      	  </c:forEach>
						              <div class="d-flex justify-content-between align-items-center">
						                <div class="btn-group board-cnt">
						                	${board.board_cnt}회 조회
						                </div>
						                <small class="text-muted">
						                	<fmt:parseDate var="dateString" value="${board.regist_dt}" pattern="yyyy-MM-dd HH:mm:ss" />
											<fmt:formatDate value="${dateString}" pattern="yyyy-MM-dd" />
						                </small>
						              </div>
						            </div>
						          </div>
						        </div>
						      </c:forEach>  
					      </div>
					    </div>
					  </div>
					<!-- 앨범 end -->
				</div>
			</div>
		</div>
	</main>
	
	<div id="paging_part">
        <table class="page_table">
            <tr>
            	<td>
            		<a href="/gallery/galleryList.do?nowPage=1&cntPerPage=${paging.cntPerPage
            				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}">&lt;&lt;</a>
            	</td>
            	<td>
            		<a <c:if test="${paging.startPage != 1}">
            				href="/gallery/galleryList.do?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage
            				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}"
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
            					<a href="/gallery/galleryList.do?nowPage=${p}&cntPerPage=${paging.cntPerPage
            							}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}" class="aPadding">${p}</a>
            				</td>
            			</c:when>
            		</c:choose>
            	</c:forEach>
            	<td>
            		<a class="aPadding"
           				<c:if test="${paging.endPage != paging.lastPage}">
           				href="/gallery/galleryList.do?nowPage=${paging.endPage + 1}&cntPerPage=${paging.cntPerPage
           				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}"
           				</c:if>>&gt;</a>
            	</td>
            	<td>
            		<a href="/gallery/galleryList.do?nowPage=${paging.lastPage}&cntPerPage=${paging.cntPerPage
            				}&srchType=${search.srchType}&srchText=${search.srchText}&menuType=${menuType}">&gt;&gt;</a>
            	</td>
            </tr>
        </table>
    </div>
<%--     <span>nowPage${paging.nowPage}</span>
	<span>startPage${paging.startPage}</span>
	<span>endPage${paging.endPage}</span>
	<span>lastPage${paging.lastPage}</span>
	<span>total${paging.total}</span> --%>
</body>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#${menuType}').addClass('selected-menu');
	});
	
	
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

	// 검색 버튼 함수
	function search() {
		let srchType = $('#srchType').val();
		let srchText = $('#srchText').val();
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
		location.href='/gallery/galleryList.do?srchType=' + srchType + '&srchText=' + srchText + '&menuType='  +  menuType;
	}
	
	// 게시글 상세보기 버튼 함수
	function galleryPost(boardNo, menu_type, menuType) {
		let returnUrl = window.location.pathname + window.location.search;
		returnUrl = returnUrl.replaceAll('&', '%26');
		location.href='/gallery/galleryPost.do?board_no=' + boardNo + '&menu_type=' + menu_type+ '&menuType=' + menuType + '&returnUrl=' + returnUrl; 
	}	
	
	// 게시글 작성 버튼 함수
	function galleryRigister() {
		let menuType = $('#menuType').val();
		var returnUrl = window.location.pathname + window.location.search;
		returnUrl = returnUrl.replaceAll('&','%26');
		
		location.href = '/gallery/galleryRegister.do?menuType=' + menuType + '&returnUrl='+ returnUrl;
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
</script>
</html>