<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:forEach items="${snsPostList}" var="snsPost" varStatus="status">
	<div class="snsPost card mb-4" data-board_no="${snsPost.board_no}"
	                     data-member_no="${snsPost.member_no}">
	    <c:if test="${snsPost.member_no == member_no || author_no == 1 || author_no == 2}">
			<div class="snsUpdateDeleteBtns">
				<button type="button" class="btn btn-secondary btn-sm snsUpdateBtn" onclick="snsUpdate()">수정</button>
				<button type="button" class="btn btn-danger btn-sm snsDeleteBtn" onclick="snsDelete()">삭제</button>
			</div>
	    </c:if>
	    <div class="writer">${snsPost.id}</div>
		<div class="content card mb-4">${snsPost.content}</div>
		<div class="likeShowCommentsBtns" style="display: flex; justify-content: space-evenly;">
			<div class="right_area">
		    	<a href="javascript:;" class="icon heart like <c:if test='${like.is_liked == 1}'>active</c:if>" onclick="like()">
			     	<c:choose>
			     		<c:when test="${snsPost.is_liked == 1}">
			     			<img src="https://cdn-icons-png.flaticon.com/512/803/803087.png" alt="좋아요">
			     		</c:when>
			     		<c:otherwise>
			     			<img src="https://cdn-icons-png.flaticon.com/512/812/812327.png" alt="좋아요 취소">
			     		</c:otherwise>
			     	</c:choose>
				</a>
				<span class="like_cnt">${snsPost.like_cnt}</span>
			</div>
			<button type="button" class="btn btn-info btn-sm showCommentBtn" onclick="showComments($(this))">댓글</button>
		</div>
		<div class="comments"></div>
	</div>
</c:forEach>
