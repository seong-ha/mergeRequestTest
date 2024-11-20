<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<body>
	<main class="mt-5 pt-5 card-body">
		<div class="container-fluid px-4 snsSearchDivParent">
			<h1 class="mt-4">
			<c:forEach items="${headerMenuList}" var="headerMenu">
				<c:if test="${headerMenu.menu_type == menuType}">
					<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
				</c:if>											
			</c:forEach>
			</h1>
			<div id="snsSearchDiv">
				<select id="srchType" name="srchType">
					<option value="writer">작성자</option>
					<option value="content">내용</option>
				</select>
	            <input type="text" placeholder="Search..." id="srchText" name="srchText">
	            <button type="button" class="btn btn-sm btn-info" id="snsSearchBtn">검색</button>
	            <button type="button" class="btn btn-sm btn-success" id="returnToFeedBtn">피드로 복귀</button>
			</div>
			<div id="snsContainer" class="card mb-4">
				<c:if test="${author_no != 6 }">
					<section id="snsInput">
						<textarea rows="" cols="" class="editor"></textarea>
						<button type="button" class="btn btn-primary btn-sm" id="snsRegistBtn">등록</button>
						<hr>
					</section>
				</c:if>
				<section id="snsList">
					<jsp:include page="/WEB-INF/jsp/egovframework/views/sns/snsPost.jsp" />
				</section>
			</div>
		</div>
	</main>
	

<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script src="/js/ckeditor5-build-classic/ckeditor.js"></script>
<script src="/js/ckeditor5-build-classic/translations/ko.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 등록된 피드가 없을 때
		if ($('#snsList').find('.snsPost').length == 0) {
			let noSnsPostDiv = `<div class="noSnsPost">등록된 피드가 없습니다.</div>`;
			$('#snsList').append(noSnsPostDiv);
			$('#snsList').css('height', '400px');
		}
		
		
		snsRegistBtn(); // sns 글 등록 버튼 이벤트
		snsSearch();	// 검색 버튼 이벤트
		returnToFeed();	// 피드로 복귀 버튼 이벤트
		
		// 스크롤해서 바닥에 닿으면 추가 목록 가져오기
		$('#snsList').on('scroll', function() {
				console.log((event.target.offsetHeight + event.target.scrollTop), event.target.scrollHeight);
			if ((event.target.offsetHeight + event.target.scrollTop + 1) >= event.target.scrollHeight) {
				getSnsPostList();
				
			}
		})
		
		// sns목록에 피드 수가 적어졌을 때 휠이 사라지는 현상을 방지
		 $(document).on('click', function() {
			 console.log(2);
			 if ($('.snsPost').length == 0) {
				 getSnsPostList();
		    } else if ($('.snsPost').length <= 1) {
				$('#snsList').css('height', '319px');	
			} else if ($('.snsPost').length == 2) {
				$('#snsList').css('height', '630px');
			} else if ($('.snsPost').length > 2) {
				$('#snsList').css('height', '800px');
			}
		});
		 $('#snsList').on('mousewheel', function() {
			 console.log(2);
			if ($('.snsPost').length <= 1) {
				$('#snsList').css('height', '319px');		
			} else if ($('.snsPost').length == 2) {
				$('#snsList').css('height', '630px');
			} else if ($('.snsPost').length > 2) {
				$('#snsList').css('height', '800px');
			}
		})
		
	});
	
	// 비회원은 등록창이 필요없으니 CKEditor도 만들어 주지 않는다.
	if (${author_no} != 6) {
		var editor;
		// CkEditor5
		/* ClassicEditor
	      .create( document.querySelector( '.editor' ), {
	    	  image: {
	              // Configure the types of allowed image files
	              upload: {
	                  types: ['jpeg', 'png', 'gif']
	              }
	          },
	    	  ckfinder: {
		            uploadUrl: '/sns/insUpload.do?menuType=sns'
		        }
	      } )
	      .then( editor => {
	        console.log( 'Editor was initialized', editor );
	      } )
	      .catch( error => {
	        console.error( error.stack );
	      } ); */
		
		ClassicEditor.create( document.querySelector( '.editor' ), {
		    image: {
		        upload: {
	                  types: ['jpeg', 'png', 'gif'],
	              }
		    },
	        ckfinder: {
	            uploadUrl: '/sns/insUpload.do?menuType=sns'
	        }
	    } )
	    .then(newEditor => {
			editor = newEditor;
	    })
	    .catch(error => {
	    	console.log(error);
	    });
		
	}
	
	// sns 글 등록 버튼
	function snsRegistBtn() {
		$('#snsRegistBtn').on('click', function() {
			//let content = editor.getData();
			let content = editor.getData();
			console.log(content);
			if (content == null || content == '') {
				alert('내용을 입력해주세요.');
				$('#content').focus();
				return;
			} else if (content != null && content.length > 3000) {
				alert('3000자 미만으로 입력해주세요.');
				$('#content').focus();
				return;
			}
			
			console.log(content)
			let data = {
					'title': '',
					'content': content,
					'type': 'normal',
					'menu_type': '${menuType}'
			};

			if (confirm("등록하시겠습니까?")) {
				$.ajax({
					url: '/sns/insSnsPost.do',
					type: 'post',
					data: JSON.stringify(data),
					contentType:"application/json",
					dataType: 'json',
					success: function(data2) {
						
						if (data2.result == '성공') {
							// 검색이 아닌 첫화면으로 돌려놓기
							afterPage = 1;
							totalChange = 0;
							searchedType = '';
							searchedText = '';
							$('#srchType').val('writer');
							$('#srchText').val('');
							
							// 스크롤 제일 위로 올리기
							$('#snsList')[0].scrollTop = 0;
							// 첫 피드 5개 불러오기
							getSnsPostList();
							
							// 적어둔 거 지우기
							editor.setData('');
							
						} else {
							alert(data2.msg);
						}
						
					},
					error: function(error) {
						console.log(error);
					}
				});	
			}
		})
	}
	
	// 다음에 가져와야할 페이지
	var afterPage = 2;
	// sns 추가 삭제로 인해 변동된 수 (추가하면 + 1, 삭제하면 - 1)
	var totalChange = 0;
	// 현재 검색 종류와 내용
	var searchedType = '';
	var searchedText = '';
	
	// 검색
	function snsSearch() {
		$('#snsSearchBtn').on('click', function() {
			let srchType = $('#srchType').val();
			let srchText = $('#srchText').val().trim();
			
			// 유효성 검사
			if (srchType == null || srchType == '') {
				alert('검색조건을 선택해주세요.');
				$('#srchType').focus();
				return;
			} else if (srchText == null || srchText == '') {
				alert('검색어를 입력해주세요.');
				$('#srchText').focus();
				return;
			} else if (srchText != null && srchText.length > 45) {
				alert('45자 이하로 입력해주세요.');
				$('#srchText').focus();
				return;
			}
			
			let data = {
					'srchType': srchType,
					'srchText': srchText,
					'menuType': '${menuType}'
			}
			
			$.ajax({
				url: '/sns/snsSearchValidate.do',
				type: 'post',
				data: data,
				async: false,
			    success: function(data) {
			    	
					if (data.result == '성공') {
						// 검색 목록 첫부분 가져오기 위한 셋팅
						searchedType = srchType;
						searchedText = srchText;
						afterPage = 1;
						
						// 검색된 페이지 들고오기
						getSnsPostList();
									
						if ($('#snsList').find('.snsPost').length == 0) {
							let noSnsPostDiv = `<div class="noSnsPost">검색된 피드가 없습니다.</div>`;
							$('#snsList').append(noSnsPostDiv);
						}
					} else {
						alert(data.msg);
						return;
					}
			    },
				error: function(error) {
					console.log(error);
				}
			});
			
			
		})
	}
	
	// sns 게시글 추가목록 가져오기
	function getSnsPostList() {
		let data = {
				'nowPage': afterPage,
				'totalChange': totalChange,
				'menuType': '${menuType}'
		};
		
		// 검색 중이라면
		if (searchedText.length != 0) {
			data.srchType =	searchedType;
			data.srchText =	searchedText;
		}
		
		$.ajax({
			url: '/sns/getSnsPostList.do',
			type: 'post',
			data: data,
			async: false,
		    success: function(data) {
		    	// 첫 5개를 가져오는 거면 비워주고 넣기
		    	if (afterPage == 1) {
		    		$('#snsList').empty();
		    	}
		    	
		    	$('#snsList').append(data);
		    	afterPage += 1;				// 다음에 가져와야할 페이지 + 1
		    	
		    	$('#snsList').css('height', '800px');
		    },
			error: function(error) {
				console.log(error);
			}
		})	
	}
	
	
	// 피드로 돌아가기
	function returnToFeed() {
		$('#returnToFeedBtn').on('click', function() {
			searchedType = '';
			searchedText = '';
			afterPage = 1;
			totalChange = 0;
			$('#srchType').val('writer');
			$('#srchText').val('');
			
			$('#snsList')[0].scrollTop = 0;
			
			getSnsPostList();
			
			if ($('#snsList').find('.snsPost').length == 0) {
				let noSnsPostDiv = `<div class="noSnsPost">검색된 피드가 없습니다.</div>`;
				$('#snsList').append(noSnsPostDiv);
			}
		})
	}
	
	// sns 삭제 버튼(onclick)
	function snsDelete() {
		let $snsPost = $(event.target).parents('.snsPost')
		let boardNo = $snsPost.attr('data-board_no');
		let memberNo = $snsPost.attr('data-member_no');
		
		let data = {
				'board_no': boardNo,
				'member_no': memberNo
		}
		
		if (confirm("삭제하시겠습니까?")) {
			$.ajax({
				url: '/sns/delSnsPost.do',
				type: 'post',
				data: data,
				async: false,
				success: function(data) {
					alert(data.msg);
					
					if (data.result == '성공') {
						$snsPost.remove();
						totalChange -= 1;
					} 
					
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
	}
	
	
	var updateEditor;					// 수정 CKEditor
	var isUpdateEditorAlive = false;	// 수정 CKEditor 객체 존재 여부
	// 수정용 CKEditor 생성
	function createCkEditor(contentHtml, contentHeight) {
		// CkEditor5
		ClassicEditor.create( document.querySelector( '.updateEditor' ), {
			image: {
		        upload: {
	                  types: ['jpeg', 'png', 'gif'],
	              }
		    },
	        ckfinder: {
	            uploadUrl: '/sns/insUpload.do?menuType=sns'
	        }
	    } )
	    .then(newEditor => {
	    	updateEditor = newEditor;
	    	isUpdateEditorAlive = true;
	    	updateEditor.setData(contentHtml);
	    	$('#snsList .ck-editor__editable').css('height', '300px !important');
	    })
	    .catch(error => {
	    	console.log(error);
	    });
	}
	
	// sns 글 수정 버튼(onclick)
	function snsUpdate() {
		$('.snsUpdateCancelBtn').click();						// 열려있는 수정 부분 닫기
		let $snsPost = $(event.target).parents('.snsPost');		// sns 게시물
		let $content = $snsPost.find('.content');				// sns 내용 div
		let contentHeight = $content.css('height');				 // sns 내용 div 높이
		let contentHtml = $content.html();							// sns 내용 div에 적힌 내용
		let $textarea = $('<textarea class="updateEditor"/>');	// sns 기존 내용을 적어둔 textarea
		
		// div의 text를 지우고 textarea로 교체
		$content.empty();			
		$content.append($textarea);
		
		// 수정 CKEditor 존재 시 없애고 다시 만듦.
		if (isUpdateEditorAlive) {
			updateEditor.destroy()
		    .catch( error => {
		        console.log( error );
		    } );
		}
		createCkEditor(contentHtml, contentHeight);
		
		// 삭제,수정 버튼을 지우고, 수정완료/취소 버튼을 삽입
		$(event.target).next().remove();
		$(event.target).remove();
		let updateCompleteBtn = 
			`<button type="button" class="btn btn-secondary btn-sm snsUpdateCompleteBtn" onclick="snsUpdateComplete()">수정완료</button>`
		let updateCancelBtn = 
			`<button type="button" class="btn btn-warning btn-sm snsUpdateCancelBtn"  style="margin-right: 5px">취소</button>`
		$snsPost.find('.snsUpdateDeleteBtns').prepend(updateCompleteBtn);
		$snsPost.find('.snsUpdateDeleteBtns').prepend(updateCancelBtn);
		
		snsUpdateCancelEvent($snsPost, $content, contentHtml, contentHeight);
	}
	
	// 취소버튼에 대한 이벤트
	function snsUpdateCancelEvent($snsPost, $content, contentHtml, contentHeight) {
		$snsPost.find('.snsUpdateDeleteBtns .snsUpdateCancelBtn').on('click', function() {
			// div의 textarea를 지우고 원래 적혀있는 내용으로 교체 
			$content.empty();
			$content.html(contentHtml);
			
			// 수정완료, 취소 버튼 지우고 수정버튼 삽입
			$snsPost.find('.snsUpdateDeleteBtns').empty();
			let updateBtn =
				`<button type="button" class="btn btn-secondary btn-sm snsUpdateBtn" style="margin-right: 5px" onclick="snsUpdate()">수정</button>`;
			let deleteBtn = 
				`<button type="button" class="btn btn-danger btn-sm snsDeleteBtn" onclick="snsDelete()">삭제</button>`;
			$snsPost.find('.snsUpdateDeleteBtns').append(updateBtn);
			$snsPost.find('.snsUpdateDeleteBtns').append(deleteBtn);
		})
	}
	
	
	// sns 글 수정 완료(onclick)
	function snsUpdateComplete() {
		let $eventTarget = $(event.target);
		let $snsPost = $eventTarget.parents('.snsPost');
		let $content = $snsPost.find('.content');
		let updatedContent = updateEditor.getData();
		
		if (updatedContent == null || updatedContent == '') {
			alert('수정내용이 없거나 공백일 수는 없습니다.');
			$content.focus();
			return;
		} else if (updatedContent != null && updatedContent.length > 3000) {
			alert('3000자 미만으로 입력해주세요.');
			$content.focus();
			return;
		}
		
		let data = {
				'board_no': $snsPost.attr('data-board_no'),
				'member_no': $snsPost.attr('data-member_no'),
				'content': updatedContent
		}
		
		if (confirm("수정하시겠습니까?")) {
			
			$.ajax({
				url: '/sns/updSnsPost.do',
				type: 'post',
				contentType: 'application/json',
				data: JSON.stringify(data),
				async: false,
				success: function(data) {
						alert(data.msg);
					if (data.result == '성공') {
						$content.empty();					// 비우고
						$content.html(updatedContent);	// 작성한 것 넣어주기

						// 수정완료, 취소 버튼 지우고 수정,삭제 버튼 다시 삽입
						$eventTarget.prev().remove();	// 취소 버튼 삭제
						$eventTarget.remove();			// 수정완료 버튼 삭제
						
						let updateBtn = 
							`<button type="button" class="btn btn-secondary btn-sm snsUpdateBtn" style="margin-right: 5px" onclick="snsUpdate()">수정</button>`
						let deleteBtn = 
							`<button type="button" class="btn btn-danger btn-sm snsDeleteBtn" onclick="snsDelete()">삭제</button>`;
						$snsPost.find('.snsUpdateDeleteBtns').append(updateBtn);
						$snsPost.find('.snsUpdateDeleteBtns').append(deleteBtn);
					}
					
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
		
	}
	
	
	// 좋아요 버튼 이벤트(onclick)
	function like() {
    	let $target = $(event.target);
    	// 클릭한 타겟이 하트 이미지면 a태그로 타겟을 바꿔주기.
    	if ($(event.target).prop('tagName') == 'IMG') {
    		$target = $(event.target).parent();
    	} 
    	
   		if ($target.hasClass('active')) {
   			let isLikeUpdated = updLike($target);	// 좋아요 등록 및 수정 후, 화면의 board_cnt횟수 반영
   			
   			if (isLikeUpdated) {
   				$target.removeClass('active');
   				$target.find('i').removeClass('fas').addClass('far');
   				$target.find('img').attr({
		                'src': 'https://cdn-icons-png.flaticon.com/512/812/812327.png',
		                alt:"찜하기"
		            });
	   			alert('좋아요 취소');
   			}
   		} else {
   			let isLikeUpdated = updLike($target); // 좋아요 등록 및 수정 후, 화면의 board_cnt횟수 반영
   			
   			if (isLikeUpdated) {
   				$target.addClass('active');
   				$target.find('img').attr({
		              'src': 'https://cdn-icons-png.flaticon.com/512/803/803087.png',
		               alt:'찜하기 완료'
		                });
	   			alert('좋아요!');
   			}
   		}
	        	
	}
	
	// 좋아요 등록 및 수정 후, 화면의 board_cnt횟수 반영
	function updLike($target) {
		let isLikeUpdate = false;	// 좋아요 등록 및 수정에 성공했으면 true
		
		let boardNo = $target.parents('.snsPost').attr('data-board_no');

		$.ajax({
			url: '/sns/updLike.do',
			type: 'post',
			data: {"board_no" :  boardNo},
			async: false,
			success: function(data) {
				if (data.result == '로그인') {
					alert(data.msg);
					isLikeUpdate = false;	
				} else {
				    let updLikeCnt = Number($target.next().text()) + (data.update_amount);
				    $target.next().text(updLikeCnt);
				    isLikeUpdate = true;
				}
				
			},
			error: function(error) {
				console.log(error);
			}
		});
		return isLikeUpdate;
	}
	
	// 댓글 보여주기
	function showComments($this) {
		let $snsPost = $this.parents('.snsPost');								// sns글
		let boardNo = $snsPost.attr('data-board_no');							// 해당 sns글 번호
		let $comments = $snsPost.find('.comments'); 							// 해당 sns글 댓글들 모여있는 위치
		let $likeShowCommentsBtns = $snsPost.find('.likeShowCommentsBtns'); 	// 해당 댓글버튼 좋아요 버튼 담는 div
		let $showCommentBtn = $likeShowCommentsBtns.find('.showCommentBtn'); 	// 해당 글 댓글 버튼
		let $closeCommentBtn = $likeShowCommentsBtns.find('.closeCommentBtn');	// 해당글 댓글 닫기 버튼
		
		$.ajax({
			url: '/sns/getSnsCommentsList.do',
			type: 'post',
			data: {"board_no" :  boardNo},
			async: false,
			success: function(data) {
				// 댓글 영역 비워주고 가져온 댓글들 삽입
				$comments.empty();
				$comments.append(data);
				
				// 기존에 존재하는 댓글 닫기 버튼이 있다면 삭제, 댓글 버튼 삭제
				if ($closeCommentBtn.length > 0) {
					$closeCommentBtn.remove();
				}
				$showCommentBtn.remove();
				
				// 댓글 달기 버튼 추가
				let closeCommentsBtn =
					`<button type="button" class="btn btn-info btn-sm closeCommentBtn" onclick="closeComments($(this))">댓글 닫기</button>`;
					$likeShowCommentsBtns.append(closeCommentsBtn);
				
			},
			error: function(error) {
				console.log(error);
			}
		});
	}
	
	
	// 댓글 영역 닫기
	function closeComments($this) {
		let $snsPost = $this.parents('.snsPost');	// sns글
		let $comments = $snsPost.find('.comments'); // 해당 sns글 댓글들 위치
		
		// 댓글 영역 비우기
		$comments.empty();
		
		// 댓글 버튼 삽입 후 댓글 닫기 버튼 삭제
		let showCommentBtn =
			`<button type="button" class="btn btn-info btn-sm showCommentBtn" onclick="showComments($(this))">댓글</button>`;
		$this.parent().append(showCommentBtn);
		$this.remove();
	}
	
	// 댓글 등록
	function insCmmt($this) {
		let $snsPost = $this.parents('.snsPost');			// sns글
		let boardNo = $snsPost.attr('data-board_no');		// 해당 sns글 번호
		let $comments = $snsPost.find('.comments');			// 댓글 div
		let $content = $(event.target).prev();				// 댓글 입력 창
		let content = $content.val().trim();				// 댓글 입력 내용
		
		if (content == null || content == '') {
			alert('댓글을 입력해주세요');
			$content.focus();
			return;
		} else if (content != null && content.length > 3000) {
			alert('3000자 미만으로 입력해주세요.');
			$content.focus();
			return;
		}
		
		let data = {
				'board_no': boardNo,
				'content': content
		};
		
		$.ajax({
			url: '/sns/insSnsComments.do',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(data) {
				
				// 댓글 등록 성공 시 다시 댓글목록들 받아오기
				if (data.result == '성공') {
					showComments($this);
				} else {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});	
		
	}
	
	// 댓글 수정모드로
	function commentsUpdateMode($this) {
		let $commentsDiv = $this.parents('.commentsDiv');
		let $commentsChildDiv = $commentsDiv.find('.commentsChildDiv');
		let $commentsContent = $commentsChildDiv.find('.commentsContent');
		
		$commentsChildDiv.css('display', 'none');
		
		let $tempDiv = $('<div/>').attr('class', 'tempDiv');
		let $textarea = $('<textarea/>').val($commentsContent.text());
		let commentsUpdateCompleteBtn =
			`<button type="button" class="btn btn-sm btn-outline-secondary"
					onclick="commentsUpdatecomplete($(this))">수정 완료</button>`;
		let commentsUpdateCancelBtn =
			`<button type="button" class="btn btn-sm btn-outline-warning commentsUpdateCancelBtn"
					 style="margin-right: 5px; margin-left: 5px" onclick="commentsUpdatecomplete($(this))">취소</button>`;
					
		$tempDiv.append($textarea);
		$tempDiv.append(commentsUpdateCancelBtn);
		$tempDiv.append(commentsUpdateCompleteBtn);
		
		$commentsDiv.append($tempDiv);
		
		$('.commentsUpdateCancelBtn').on('click', function() {
			$commentsChildDiv.css('display', 'block');
			$(event.target).parent().remove();
		})
		
	}
	
	// 댓글 수정 완료
	function commentsUpdatecomplete($this) {
		let commentsNo = $this.parents('.commentsDiv').attr('data-comments_no');
		let memberNo = $this.parents('.commentsDiv').attr('data-member_no');
		let $content = $this.parent().find('textarea');
		let content = $content.val().trim();
		
		if (content == null || content == '') {
			alert('수정내용이 없거나 공백일 수는 없습니다.');
			$content.focus();
			return;
		} else if (content != null && content.length > 3000) {
			alert('3000자 미만으로 입력해주세요.');
			$content.focus();
			return;
		}
		
		
		let data = {
			'comments_no': commentsNo,
			'member_no': memberNo,
			'content': content
		};
		
		$.ajax({
			url: '/sns/updSnsComments.do',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(data2) {
				
				// 댓글 수정 성공 시 다시 댓글목록들 받아오기
				if (data2.result == '성공') {
					showComments($this);
				} else {
					alert(data.msg);
				}
			},
			error: function(error) {
				console.log(error);
			}
		});	
	}
	
	
	// 댓글 삭제
	function commentsDelete($this) {
		let comments_no = $this.parents('.commentsDiv').attr('data-comments_no');
		let member_no = $this.parents('.commentsDiv').attr('data-member_no');
		
		let data = {
				'comments_no': comments_no,
				'member_no': member_no
		};
		if (confirm("삭제하시겠습니까?")) {
			$.ajax({
				url: '/sns/delSnsComments.do',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(data2) {
					
					// 댓글 삭제 성공 시 다시 댓글목록들 받아오기
					if (data2.result == '성공') {
						showComments($this);
					} else {
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
</body>