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
			<h1 class="mt-4">메뉴 관리</h1>
			<div class="card mb-4">
				<c:if test="${author == 'SUPERADMIN'}">
					<div class="card-header">
						<a id="statisticsBtn" class="btn btn-success float-end" style="margin-left: 5px;">
							통계
						</a>
						<a id="menuManageBtn" class="btn btn-primary float-end">
							메뉴 관리
						</a>
					</div>
				</c:if>
				<div class="card-body">
					<table id="menu-table" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>메뉴명</th>
								<th >메뉴 형태</th>
								<th>메뉴 URL</th>
								<th> 접근 가능 권한</th>
								<th> 권한 수정</th>
								<th>삭제</th>
							</tr>
						</thead>
						<tbody>
							<!-- 설문 게시물 start -->
							<c:if test="${empty menuList}">
							 	<tr>
							 		<td colspan="5">설문 게시물이 없습니다.</td>
							 	</tr>
							</c:if>
							<c:if test="${not empty menuList}">
								<c:forEach items="${menuList}" var="menu" varStatus="menuIdx">
									<tr data-menu_no="${menu.menu_no}">
										<td>${menu.menu_name}</td>
										<td>${menu.menu_form}</td>
										<td>${menu.menu_url}</td>
										<td>
											<c:forEach items="${authorList}" var="author" varStatus="authorIdx">
												<c:choose>
													<c:when test="${fn:indexOf(menu.authorList, author.author_no) ne -1}">
														<div class="authorCheckBox">
														    <label class="form-check-label" for="authorCheckbox${menuIdx.count += '' += author.author_no}">
															    <input class="form-check-input" type="checkbox" value="${author.author_no}" id="authorCheckbox${menuIdx.count += '' += author.author_no}" checked>
														        ${author.author_name_kor}
														    </label>
														</div>
													</c:when>
													<c:otherwise>
														<div class="authorCheckBox">
														    <label class="form-check-label" for="authorCheckbox${menuIdx.count += '' += author.author_no}">
															    <input class="form-check-input" type="checkbox" value="${author.author_no}" id="authorCheckbox${menuIdx.count += '' += author.author_no}">
														        ${author.author_name_kor}
														    </label>
														</div>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</td>
										<td>
											<button type="button" class="btn btn-warning" onclick="updateAuthorBtn()">적용</button>
										</td>
										<td>
											<button type="button" class="btn btn-danger" onclick="deleteMenuBtn()">삭제</button>
										</td>
									</tr>
								</c:forEach>
							</c:if>
							<!-- 설문 게시물 end -->
						</tbody>
					</table>
				</div>
				
				<hr>
				<h3>메뉴 등록</h3>
				<div class="card-body">
					<div>
						<div class="labelInputDiv labelInputDivMenuTitle">
						    <label for="menuName" class="form-label">메뉴명</label>
						    <input type="text" class="form-control" id="menuName" placeholder="원하는 메뉴명을 입력하세요.">
					    </div>
					    <div class="labelInputDiv labelInputDivMenuAuthor">
					  	    <label for=authorSelect class="form-label">접근 가능 권한</label>
					  	    <div class="form-control" id="authorSelect">
							   <c:forEach items="${authorList}" var="author" varStatus="authorIdx">
									<div class="authorCheckBox">
									    <label class="form-check-label" for="authorSelectCheck${author.author_no}">
										    <input class="form-check-input" type="checkbox" value="${author.author_no}" id="authorSelectCheck${author.author_no}">
									        ${author.author_name_kor}
									    </label>
									</div>
								</c:forEach>
							</div>
						</div>
						<br>
					    <div class="labelInputDiv labelInputDivMenuForm">
						    <label for="menuFormSelect" class="form-label">메뉴 형태</label>
						    <select id="menuFormSelect" class="form-select">
						        <option value="" selected disabled>메뉴 형태를 선택하세요</option>
						        <option value="board">일반</option>
						        <option value="gallery">갤러리</option>
						        <option value="survey">설문</option>
						        <option value="sns">sns</option>
						        <option value="link">링크</option>
						    </select>
					    </div>
					    <div class="labelInputDiv labelInputDivMenuUrl">
						    <label for="frontUrl" class="form-label">URL</label>
						    <div class="input-group">
						        <span class="input-group-text" id="frontUrl">URL기입란</span>
						        <input type="text" class="form-control" id="menuTypeParam" placeholder="메뉴 형태를 선택하면 url 형식이 나옵니다.">
					  	    </div>
					  	</div>
					</div>
			  	    <button type="button" class="btn btn-success" id="menuRegistBtn">메뉴 등록</button>
			    </div>
		    </div>
		</div>
	</main>

	<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#${menuType}').addClass('selected-menu');
			
			// 통계버튼
			$('#statisticsBtn').on('click', function() {
				location.href = "/menu/statistics.do?menuType=" + '${menuType}';
			})
			// 메뉴관리버튼
			$('#menuManageBtn').on('click', function() {
				location.href = "/menu/menuList.do?menuType=" + '${menuType}';
			})
			
			menuFormSelect();	// 메뉴형식 select 태그
			menuRegistBtn();	// 메뉴 추가 버튼
			
			
			
		});
		
		// 권한 수정 적용 버튼
		function updateAuthorBtn() {
			let $menuTr = $(event.target).parents('tr');						// tr태그
			let $menuNameTd = $menuTr.find('td:first-child');					// 메뉴명 td태그
			let $authorTd = $(event.target).parent().prev();					// 접근 가능 권한 td태그
			let $inputChecked = $authorTd.find('input[type=checkbox]:checked');	// 접근 가능 권한 td태그 안의 체크된 것들
			let checkedAuthorNoList = [];										// 체크된 author_no 리스트
			
			$inputChecked.each(function(idx, item) {
				checkedAuthorNoList.push(item.value);
			});
			
			
			if(confirm($menuNameTd.text() + "의 접근 가능 권한을 수정하시겠습니까?")) {
				let data = {
					'menu_no': $menuTr.attr('data-menu_no'),
					'authorList': checkedAuthorNoList
				};
				
				
				$.ajax({
			    	url: '/menu/updMenuAuthor.do',
					type: 'post',
					data: data,
					dataType: 'json',
					async: false,
			        success: function(data) {
				        alert(data.msg);
				        
			        	if (data.result == '성공') {
				        	location.reload();
			        	}
			        },
					error: function(error) {
						console.log(error);
					}
			    })
			}
			
		}
		
		
		// 메뉴 삭제 버튼
		function deleteMenuBtn() {
			let $menuTr = $(event.target).parents('tr');
			let menuNo = $menuTr.attr('data-menu_no');
			let menuName = $menuTr.find('td:first-child').text();
			console.log(menuNo);
			
			if (confirm(menuName + "을 삭제하시겟습니까?")) {
				$.ajax({
			    	url: '/menu/delMenu.do',
					type: 'post',
					data: {'menu_no': menuNo},
					dataType: 'json',
					async: false,
			        success: function(data) {
				        alert(data.msg);
				        
			        	if (data.result == '성공') {
				        	location.reload();
			        	}
			        },
					error: function(error) {
						console.log(error);
					}
			    })
			}
		}
		
		
		// 메뉴 형식 select태그 change이벤트(url기입란 동적으로 변경)
		function menuFormSelect() {
			$('#menuFormSelect').on('change', function() {
				let selectValue = $(event.target).val();
				
				if (selectValue == 'board') {
					$('#frontUrl').text('/board/boardList.do?menuType=');
					$('#menuTypeParam').attr('placeholder', '원하는 url을 입력하세요. ex) freeboard');
				} else if (selectValue == 'gallery') {
					$('#frontUrl').text('/gallery/galleryList.do?menuType=');
					$('#menuTypeParam').attr('placeholder', '원하는 url을 입력하세요. ex) carGallery');
				} else if (selectValue == 'survey') {
					$('#frontUrl').text('/survey/surveyList.do?menuType=');
					$('#menuTypeParam').attr('placeholder', '원하는 url을 입력하세요. ex) studentSurvey');
				} else if (selectValue == 'sns') {
					$('#frontUrl').text('/sns/snsList.do?menuType=');
					$('#menuTypeParam').attr('placeholder', '원하는 url을 입력하세요.');
				} else if (selectValue == 'link') {
					$('#frontUrl').text('https://');
					$('#menuTypeParam').attr('placeholder', '원하는 url을 입력하세요. ex) www.naver.com');
				}
			})
		}
		
		// 입력한 것들 검증
		function inputValidation() {
			let menuName = $('#menuName').val();
			let menuFormSelect = $('#menuFormSelect').val();
			let menuTypeParam = $('#menuTypeParam').val();
			// 앞뒤 공백, 특수문자 제거
			menuTypeParam = menuTypeParam.replace(/^\s+|\s+$/g, '');
			
			let authorSelect = $('#authorSelect').find('input[type=checkbox]:checked');
			
			
			
			if (menuName == null || menuName == '') {
				alert('게시판명을 입력해주세요.');
				$('#menuName').focus();
				return false;
			} else if (menuName != null && menuName.length > 20) {
				alert('20자 이하로 입력해주세요.');
				$('#menuName').focus();
				return false;
			} else if (menuFormSelect == null || menuFormSelect == '') {
				alert('게시판 형태를 선택해주세요.');
				$('#menuFormSelect').focus();
				return false;
			} else if (menuTypeParam == null || menuTypeParam == '') {
				alert('url을 입력해주세요.');
				$('#menuTypeParam').focus();
				return false;
			} else if (menuTypeParam != null && menuTypeParam.length > 50) {
				alert('50자 이하로 입력해주세요.');
				$('#menuTypeParam').focus();
				return false;
			} else if (authorSelect.length == 0) {
				alert('접근 가능 권한을 체크해주세요');
				$('#authorSelect').focus();
				return false;
			}
			
			
			// 메뉴명 중복랑 URL 중복인지 체크하기
			let result = true;
			$.ajax({
		    	url: '/menu/checkMenuDuplicate.do',
				type: 'post',
				data: {
					'menu_name': menuName,
					'menu_type': menuTypeParam
				},
				dataType: 'json',
				async: false,
		        success: function(data) {
			        
		        	if (data.result != '성공') {
			        	alert(data.msg);
			        	result = false;
		        	}
		        },
				error: function(error) {
					console.log(error);
				}
		    })
		    
			return result;
		}
		
		// 메뉴 추가 버튼
		function menuRegistBtn() {
			$('#menuRegistBtn').on('click', function() {
				// 검증
				if (!inputValidation()) {
					return;
				}
				
				if (confirm("메뉴를 추가하시겠습니까?")) {
					let authorList = [];
					$('#authorSelect').find('input[type=checkbox]:checked').each(function(idx, item) {
						authorList.push($(item).val());
					})
					
					let data = {
							'menu_name': $('#menuName').val().trim(),
							'menu_form': $('#menuFormSelect').val(),
							'menu_url': $('#frontUrl').text() + $('#menuTypeParam').val(),
							'menu_type': $('#menuTypeParam').val().trim(),
							'authorList': authorList
					}
					
					$.ajax({
				    	url: '/menu/insMenu.do',
						type: 'post',
						data: data,
						dataType: 'json',
						async: false,
				        success: function(data) {
					        alert(data.msg);
					        
				        	if (data.result == '성공') {
					        	location.reload();
				        	}
				        },
						error: function(error) {
							console.log(error);
						}
				    })
				}
				
			});
		}
		
	</script>
</body>
</html>