<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
</style>

    
</head>
<body class="text-center">
    
	<main class="form-signin">
	  <form method="post" onsubmit="return false">
	    
	    <h1 class="h3 mb-3 fw-normal">로그인</h1>
	
	    <div class="form-floating">
	      <input type="text" class="form-control" id="id" name="id" placeholder="아이디" value="superadmin">
	      <label for="floatingInput">아이디</label>
	    </div>
	    <div class="form-floating">
	      <input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호" value="superadmin">
	      <label for="floatingPassword">비밀번호</label>
	    </div>
	
	    <button class="w-100 btn btn-lg btn-primary" onclick="login()">Sign in</button>
	    <br>
	    <button class="w-100 btn btn-lg btn-info" onclick="location.href='/survey/surveyList.do?menuType=survey'">설문게시판으로(비회원)</button>
	    <p class="mt-5 mb-3 text-muted">&copy; 2023</p>
	  </form>
	  <button class="w-100 btn btn-lg btn-secondary" onclick="location.href='/member/joinForm.do'">회원가입</button>
	</main>
	<input type="hidden" id="sessionResult" value="${msg}">

	<script type="text/javascript">
		$(document).ready(function() {
			// 세션 만료되어서 로그인페이지로 돌아왔을 시 안내
			let sessionResult = $('#sessionResult').val();
			if (sessionResult.length != 0) {
				alert(sessionResult);
			}
		});
	
		function login() {
			id = $('#id').val();
			pwd = $('#pwd').val();
			
			if (id.length == 0) {
				alert('아이디를 입력해주세요');
				$('#id').focus();
				return;
			} else if (id.length > 60) {
				alert('유효하지 않은 아이디입니다.');
				$('#id').focus();
				return;
			} else if (pwd.length == 0) {
				alert('비밀번호를 입력해주세요.');
				$('#pwd').focus();
				return;
			} else if (pwd.length > 200) {
				alert('유효하지 않은 비밀번호입니다.');
				$('#pwd').focus();
				return;
			}
			
			let data = {
					'id': id,
					'pwd': pwd
			}
			$.ajax({
				url: '/member/login.do',
				type: 'post',
				contentType:'application/json',
				data: JSON.stringify(data),
				dataType: 'json',
				success: function(data) {
					alert(data.msg);
					
					if (data.result == 1){
						location.href='/board/boardList.do?menuType=normal'
					}
					
				},
				error: function(error) {
					console.log('통신실패');
					console.log(error);
				}
			});
		}
	
	</script>    
</body>
</html>