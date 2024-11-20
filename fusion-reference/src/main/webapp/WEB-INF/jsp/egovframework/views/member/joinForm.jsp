<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Bootstrap core CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
<!-- jQuery CDN -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style>


	.bd-placeholder-img {
	  font-size: 1.125rem;
	  text-anchor: middle;
	  -webkit-user-select: none;
	  -moz-user-select: none;
	  user-select: none;
	}
	
	@media (min-width: 768px) {
	  .bd-placeholder-img-lg {
	    font-size: 3.5rem;
	  }
	}
	
	main {
		width: 500px;
		margin: 100px auto;
	}
	
	#id-form {
		display:flex;
		justify-content: space-between;
	}
	
	#id {
		width: 420px;
		display: inline-block;
		
	}
</style>

    
    <!-- Custom styles for this template -->
<link rel="stylesheet" href="/CSS/bootstrap-5.3.0-alpha1-examples/sign-in/signin.css">
</head>
<body class="text-center">
    
	<main class="form-signin">
	  <form action="/member/join.do" method="post" onsubmit="return false;">
	    
	    <h1 class="h3 mb-3 fw-normal">회원가입</h1>
	
	    <div class="form-floating" id="id-form">
	      <input type="text" class="form-control" id="id" name="id" placeholder="아이디" required>
	      <label for="floatingInput">아이디</label>
	      <button type="button" class="btn btn-sm btn-success" onclick="idCheck()">중복체크</button>
	    </div>
	    <br>
	    
	    <div class="form-floating">
	      <input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호" required>
	      <label for="floatingPassword">비밀번호</label>
	    </div>
	    <div class="form-floating">
	      <input type="password" class="form-control" id="pwd_confirm" name="pwd_confirm" placeholder="비밀번호 확인" required>
	      <label for="floatingPassword">비밀번호 확인</label>
	    </div>
	    <br>
	    <div class="form-floating">
	      <input type="text" class="form-control" id="name" name="name" placeholder="이름" required>
	      <label for="floatingInput">이름</label>
	    </div>
	    <br>
	    <div class="form-floating">
	     <span>회원 종류</span>&nbsp;&nbsp;
	      <select class="form-control" id="author" name="author_no" style="width: 400px; display: inline-block;"required>
	          <option value="5" selected>일반</option>
	          <option value="4">학생</option>
	          <option value="3">교사</option>
	      </select>
	    </div>
	    <div class="form-floating">
	     <span>지역</span>&nbsp;&nbsp;
	      <select class="form-control" id="region" name="region" style="width: 400px; display: inline-block;"required>
	      	<c:forEach items="${commCdList}" var="commCd">
	      		<option value="${commCd.comm_cd_no}">${commCd.code_name}</option>
	      	</c:forEach>
	      </select>
	    </div>
		<br>
		
	    <button type="button" class="w-100 btn btn-lg btn-primary" onclick="formCheck()">회원 가입</button>
	    <button type="button" class="w-100 btn btn-lg btn-secondary" onclick="location.href='/member/loginForm.do'">로그인 화면으로</button>
	    <p class="mt-5 mb-3 text-muted">&copy; 2017–2021</p>
	  </form>
	</main>


	<script type="text/javascript">
		// 중복체크 성공한 아이디
		let checkedId = '';
	
		function idCheck() {
			id = $('#id').val();
			
			if (id.length == 0) {
				alert('아이디를 입력해주세요');
				$('#id').focus();
				return;
			} else if (id.length > 60) {
				alert('60자 미만으로 입력해주세요.');
				$('#id').focus();
				return;
			}
			
			$.ajax({
				url: '/member/idCheck.do',
				type: 'post',
				data: {"id": id},
				dataType: 'json',
				success: function(data) {
					if (data.result == '1') {
						alert(data.msg);
						$('#id').focus();
					} else if (data.result == '0') {
						alert(data.msg);
						checkedId = id;
					}
				},
				error: function(error) {
					console.log('통신실패');
					console.log(error);
				}
			});
			
		}
		
		// 회원가입 전 비밀번호 및 아이디중복체크
		function formCheck() {
			let id = $('#id').val();
			let pwd1 = $('#pwd').val();
			let pwd2 = $('#pwd_confirm').val();
			let name = $('#name').val();
			let author = $('#author').val();
			
			if (id.length == 0) {
				alert('아이디를 입력해주세요');
				$('#id').focus();
				return;
			} else if (id.length > 60) {
				alert('60자 미만으로 입력해주세요.');
				$('#id').focus();
				return;
			} else if (pwd1.length == 0) {
				alert('비밀번호를 입력해주세요');
				$('#pwd').focus();
				return;
			} else if (pwd1.length > 16) {
				alert('16자 미만으로 입력해주세요');
				$('#pwd').focus();
				return;
			} else if (pwd2.length == 0) {
				alert('비밀번호를 입력해주세요');
				$('#pwd_confirm').focus();
				return;
			} else if (pwd2.length > 16) {
				alert('16자 미만으로 입력해주세요');
				$('#pwd_confirm').focus();
				return;
			} else if (name.length == 0) {
				alert('이름을 입력해주세요.');
				$('#name').focus();
				return;
			} else if (name.length > 10) {
				alert('10자 미만으로 입력해주세요.');
				$('#name').focus();
				return;
			} else if (author.length == 0) {
				alert('회원 종류를 선택해주세요');
				$('#author').focus();
				return;
			}
			
			// 아이디 중복 체크 후에 아이디를 바꿀 수도 있으니 한번 더 체크 후 안내
			if (!doubleIdCheck(id)) {
				return;
			}
			
			if (pwd1 != pwd2) {
				alert("비밀번호가 일치하지 않습니다.");
				$('#pwd').val() = "";
				$('#pwd_confirm').val() = "";
				$('#pwd').focus();
				return;
			}
			
			let data = {
					'id': id,
					'pwd': pwd1,
					'name': name,
					'author_no': author
			};
			
			$.ajax({
				url: '/member/join.do',
				type: 'post',
				contentType: 'application/json', 
				data: JSON.stringify(data),
				dataType: 'json',
				success: function(data) {
					if (data.result == '1') {
						alert(data.msg);
						location.href="/member/loginForm.do"
					} else if (data.result == '0') {
						alert(data.msg);
					}
				},
				error: function(error) {
					console.log('통신실패');
					console.log(error);
				}
			});
		}
	
		// 회원가입 버튼 눌렀을 때 아이디 중복 더블 체크
		function doubleIdCheck(id) {
			
			// 중복체크를 통해 통과되었던 아이디인 checkedId와 현재 적힌 아이디가 같은 때만 최종적으로 통과
			if (checkedId == id) {
				return true;
			
			// 통과를 했더라도 checkedId와 현재 적힌 아이디가 다른 경우. 즉, 중복체크하고 나서 아이디 바꿔 적은 경우들은
			// 무조건 아이디 중복체크를 거치게 만들기.
			} else {
					alert("아이디 중복 체크를 해주세요.");
					$('#id').focus();
					return false;
			}
		}
	</script>    
</body>
</html>