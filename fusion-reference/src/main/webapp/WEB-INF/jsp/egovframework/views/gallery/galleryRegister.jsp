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
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify"></script>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.polyfills.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.css" rel="stylesheet" type="text/css" />
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
		<form id="uploadFrm" method="post" onsubmit="return false;">
			<div class="container-fluid px-4">
				<h1 class="mt-4">게시글 작성</h1>
				<div class="card mb-4">
					<div class="card-body">
						<div style="display:flex; justify-content: space-between">
							<div class="mb-3" style="width:79%">
								<label for="title" class="form-label">제목</label>
								<input type="text" class="form-control" id="title" name="title" value="${board.title}">
							</div>
							<div class="mb-3" style="width:20%">
								<label for="menu_type" class="form-label">게시판 유형</label>
								<select id="menu_type" name="menu_type" class="form-select">
									<c:forEach items="${headerMenuList}" var="headerMenu">
										<c:if test="${headerMenu.menu_type == menuType}">
											<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
										</c:if>											
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="mb-3">
							<label for="content" class="form-label">내용</label>
							<textarea class="form-control" id="content" name="content"></textarea>
						</div>
						<div class="insert">
					    	<label for="files" class="input-file-btn">사진 첨부</label>
					        <div class="file-list"></div>
					        <input id="files" style="display:none" type="file" onchange="addFile(this);" multiple />
						</div>
						
						<div class="mb-3">
							<label for="tag" class="form-label">태그</label>
							<input class="form-control" id="tag" name="tag">
						</div>
						
						<input type="hidden" class="form-control" id="member_no" name="member_no" value="${member_no}">
						
						<button type="button" id="reg" class="btn btn-outline-warning" onclick="submitForm()">등록하기</button>
						<button type="button" id="goBack" class="btn btn-outline-danger" onclick="location.href='${returnUrl}';">돌아가기</button>
					</div>
				</div>
			</div>
		</form>
	</main>
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
	
	
	
	
	// tagify API이용.
	const input = document.querySelector('input[name=tag]');
    let tagify = new Tagify(input, {
    	editTags: false
    });
    
    // 태그가 추가되면 이벤트 발생
    tagify.on('add', function() {
    	// 특수문자 처리
		let exceptionChar = ['#', '%', '^', '&', '_', '+', '\\', '|', '[', ']', '{', '}', '`'];
		
		for(let i = 0; i < exceptionChar.length; i++) {
			if (tagify.value[tagify.value.length-1].value.indexOf(exceptionChar[i]) != -1) {
				alert('#   %   ^   &   _   +   \\   |   [   ]   {   }   ` \n특수문자를 제외한 검색어를 입력해주세요.');
				setTimeout(() => {
		    		document.querySelector('.tagify__tag[value="' + tagify.value[tagify.value.length-1].value + '"] > .tagify__tag__removeBtn').click();
		    		return;
	  			}, 100);
			}
		}
		
    	tagify.value[tagify.value.length-1].value
    	
	    if (tagify.value[tagify.value.length-1].value.length > 20) {
	   		alert('최대 20자까지만 입력하실 수 있습니다.');
	    	setTimeout(() => {
	    		document.querySelector('.tagify__tag[value="' + tagify.value[tagify.value.length-1].value + '"] > .tagify__tag__removeBtn').click();
	    		return;
  			}, 100);
	    }
	    if (tagify.value.length > 5) {
	    	alert('태그는 5개 이하까지만 가능합니다.');
	    	setTimeout(() => {
	    		document.querySelector('.tagify__tag[value="' + tagify.value[5].value + '"] > .tagify__tag__removeBtn').click();
			}, 100);
	    		  
	    	return;
	    }
      
    })	


	var fileNo = 0;
	var filesArr = new Array();

	/* 첨부파일 추가 */
	function addFile(obj){
	    var maxFileCnt = 5;   // 첨부파일 최대 개수
	    var attFileCnt = document.querySelectorAll('.filebox').length;    // 기존 추가된 첨부파일 개수
	    var remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
	    var curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수

	    // 첨부파일 개수 확인
	    if (curFileCnt > remainFileCnt) {
	        alert("첨부파일은 최대 " + maxFileCnt + "개 까지 첨부 가능합니다.");
	    }

	    for (var i = 0; i < Math.min(curFileCnt, remainFileCnt); i++) {

	        const file = obj.files[i];

	        // 첨부파일 검증
	        if (validation(file)) {
	            // 파일 배열에 담기
	            var reader = new FileReader();
	            reader.onload = function () {
	                filesArr.push(file);
	            };
	            reader.readAsDataURL(file)

	            // 목록 추가
	            let htmlData = '';
	            htmlData += '<div id="file' + fileNo + '" class="filebox">';
	            htmlData += '   <p class="name">' + file.name + '</p>';
	            htmlData += '   <a class="delete" onclick="deleteFile(' + fileNo + ');">×</a>';
	            htmlData += '</div>';
	            $('.file-list').append(htmlData);
	            fileNo++;
	        } else {
	            continue;
	        }
	    }
	    // 초기화
	    document.querySelector("input[type=file]").value = "";
	}

	/* 첨부파일 검증 */
	function validation(obj){
	    const fileTypes = ['image/gif', 'image/jpeg', 'image/png', 'image/bmp', 'image/tif'];
	    if (obj.name.length > 100) {
	        alert("파일명이 100자 이상인 파일은 제외되었습니다.");
	        return false;
	    } else if (obj.size > (50 * 1024 * 1024)) {
	        alert("최대 파일 용량인 50MB를 초과한 파일은 제외되었습니다.");
	        return false;
	    } else if (obj.name.lastIndexOf('.') == -1) {
	        alert("확장자가 없는 파일은 제외되었습니다.");
	        return false;
	    } else if (!fileTypes.includes(obj.type)) {
	        alert("첨부가 불가능한 파일은 제외되었습니다.");
	        return false;
	    } else {
	        return true;
	    }
	}

	/* 첨부파일 삭제 */
	function deleteFile(num) {
	    document.querySelector("#file" + num).remove();
	    filesArr[num].is_delete = true;
	}

	/* 폼 전송 */
	function submitForm() {
		if (window.confirm("등록하시겠습니까?")) {
			let title = $('#title').val();
			// 빈값 체크
			if (title.length == 0) {
				alert('제목을 입력해주세요.');
				$('#title').focus();
				return;
			} else if (title.length > 300) {
				alert('300자 미만으로 입력해주세요.');
				$('#title').focus();
				return;
			}
			
			let content = $('#content').val();
			
			// 빈값 체크
			 if (content.length == 0) {
				alert('내용을 입력해주세요.');
				$('#content').focus();
				return;
			} else if (content.length > 3000) {
				alert('3000자 미만으로 입력해주세요.');
				$('#content').focus();
				return;
			}
			
			let fileCnt = 0;	// 첨부한 사진 수
		    // 폼데이터 담기
		    var form = document.getElementById('uploadFrm');
		    var formData = new FormData(form);
		    for (var i = 0; i < filesArr.length; i++) {
		        // 삭제되지 않은 파일만 폼데이터에 담기
		        if (!filesArr[i].is_delete) {
		            formData.append("files", filesArr[i]);
		            fileCnt++;
		        }
		    }
		    

		    // tagify에 들어있는 값을 formData에 append해준다.
		    if (tagify.value.length > 0) {
		    	let tempArr = [];
			    for (let i = 0; i < tagify.value.length; i++) {
			    	tempArr.push(tagify.value[i].value);
			    }
			    
			    for (let i = 0; i < tempArr.length; i++) {
			    	formData.append("tags", tempArr[i]);
			    }	
		    }
		    
		    /* for (let [key, value] of formData) {
	          console.log(`\${key}: \${value}\n`);
	        } */
		    
		    
		    $.ajax({
		    	url: '/gallery/insGallery.do',
				type: 'post',
				enctype: 'multipart/form-data',
				processData : false,
	            contentType : false,
				data: formData,
				dataType: 'json',
		        async: true,
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