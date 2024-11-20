<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<header>
    <div class="px-3 py-2 border-bottom mb-3">
        <div class="container d-flex flex-wrap justify-content-between">
        	<c:forEach items="${headerMenuList}" var="headerMenu">
        		<c:if test="${headerMenu.menu_no < 1}">
	        		<div class="menusDiv">
			            <button id="${headerMenu.menu_type}" class="menus-hover btn btn-toggle d-inline-flex align-items-center rounded border-0 collapsed"
			    		        data-bs-toggle="collapse" data-bs-target="#home-collapse" aria-expanded="false"
			    		        onclick="location.href='${headerMenu.menu_url}'">
			                <strong>${headerMenu.menu_name}</strong>
			            </button>
			        </div>
        		</c:if>
        	</c:forEach>
        	<div>
       			<select id="integSrchType" name="integSrchType">
					<option value="all"
							<c:if test="${integSearch.srchType == 'all'}">selected</c:if>>전체</option>
					<option value="writer"
							<c:if test="${integSearch.srchType == 'writer'}">selected</c:if>>작성자</option>
					<option value="title"
							<c:if test="${integSearch.srchType == 'title'}">selected</c:if>>제목</option>
					<option value="content"
							<c:if test="${integSearch.srchType == 'content'}">selected</c:if>>내용</option>
				</select>
        		<input type="text" id="integSrchText" placeholder="Search.." value="${integSearch.srchText}">
        		<button type="button" class="btn btn-primary" id="integratedSearchBtn" >통합검색</button>
        	</div>
            <div class="text-end">
       	        <c:if test="${not empty name}">
       		        <span>${name }님 환영합니다.</span>
                    <button type="button" class="btn btn-light text-dark me-2" onclick="logout()">Logout</button>
       		    </c:if>
	       	    <c:if test="${empty name}">
		            <button type="button" class="btn btn-light text-dark me-2" onclick="location.href='/member/loginForm.do'">Login</button>
	       	    </c:if>
       	    </div>
        </div>
    </div>
    <input type="hidden" id="menuType" value="${menuType}">
    <div class="flex-shrink-0 p-3 bg-white">
    	<c:forEach items="${headerMenuList}" var="headerMenu" varStatus="headerIdx">
    		<c:if test="${headerMenu.menu_no > 0}">
    			<c:if test="${headerMenu.menu_form ne 'link'}">
					<div class="menusDiv">
			            <button id="${headerMenu.menu_type}" class="menus-hover btn btn-toggle d-inline-flex align-items-center rounded border-0 collapsed"
			      		   data-bs-toggle="collapse" data-bs-target="#home-collapse" aria-expanded="false"
			      		   onclick="location.href='${headerMenu.menu_url}'">
			                <strong>${headerMenu.menu_name}</strong>
			            </button>
			        </div>    	
		        </c:if>
		        <c:if test="${headerMenu.menu_form eq 'link'}">	
					<div class="menusDiv">
			            <button id="${headerMenu.menu_type}" class="menus-hover btn btn-toggle d-inline-flex align-items-center rounded border-0 collapsed"
			      		   data-bs-toggle="collapse" data-bs-target="#home-collapse" aria-expanded="false"
			      		   onclick="goLink('${headerMenu.menu_url}', '${headerMenu.menu_type}')">
			                <strong>${headerMenu.menu_name}</strong>
			            </button>
			        </div>    
			    </c:if>	
    		</c:if>
    	</c:forEach>
    </div>
</header>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script>
	$(document).ready(function() {
		let menuType = '${menuType}';
		if (menuType != null && menuType != '') {
			$('#${menuType}').addClass('selected-menu');
		}
		
		integratedSearchBtn();	// 통합검색
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
	
	// 통합검색 버튼 함수
	function integratedSearchBtn() {
		$('#integratedSearchBtn').on('click', function() {
			let integSrchType = $('#integSrchType').val();
			let integSrchText = $('#integSrchText').val();
			
			if (integSrchText == null || integSrchText == '') {
				alert('검색어를 입력하세요.');
				$('#integSrchText').focus();
				return;
			} else if (integSrchText != null && integSrchText.length > 40) {
				alert('40자 이하로 입력해주세요.');
				$('#integSrchText').focus();
				return;
			}
			
			$.ajax({
				url: '/search/validateSearch.do',
				type: 'post',
				data: {
					'srchType': integSrchType,
					'srchText': integSrchText.trim()
				},
				async: false,
				dataType: 'json',
				success: function(data) {
					if (data.result == '성공'){
						// 통합검색된 화면으로
						location.href='/search/integratedSeach.do?srchType=' + integSrchType + "&srchText=" + integSrchText;
					} else {
						alert(data.msg);
					}
					
				},
				error: function(error) {
					console.log('통신실패');
					console.log(error);
				}
			});
			
		})
	}
	
	function goLink(url, menuType) {
		
		$.ajax({
			url: '/link/linkLog.do',
			type: 'post',
			data: {'menuType': menuType},
			async: false,
			dataType: 'json',
			success: function(data) {
				location.href = url;
			},
			error: function(error) {
				console.log('통신실패');
				console.log(error);
			}
		});
	}
</script>
