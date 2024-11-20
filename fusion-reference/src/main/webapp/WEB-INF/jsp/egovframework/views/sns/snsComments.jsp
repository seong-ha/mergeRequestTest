<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 댓글 start-->
<div class="container-fluid px-4">
	<div class="card mb-4">
		<span class="cmmt-title">댓글 
			<span style="font-size: 20px; color: green">
				<c:if test="${empty commentsList}">0</c:if>
				<c:if test="${not empty commentsList}">${commentsList[0].total}</c:if>
			</span>
		</span>
		<div class="mb-2 cmmt-lev_0">
			<textarea id="content" name="content"></textarea>
			<button type="button" id="insCmmt"
					class="btn btn-outline-primary btn-sm" onclick="insCmmt($(this))">작성</button>
		</div>
		<c:if test="${empty commentsList}">
		<hr>
			<div class="mb-2 cmmt">
		    	<h6><strong>등록된 댓글이 없습니다.</strong></h6>
			</div>
		</c:if>
		<c:if test="${not empty commentsList}">
			<c:forEach items="${commentsList}" var="comments">
				<hr>
				<div class="mb-2 commentsDiv" data-comments_no="${comments.comments_no}"
				                       data-member_no="${comments.member_no}">
				    <div class="commentsChildDiv">                   
					    <b>
					    	${comments.id}
					    	<c:if test="${comments.regist_dt != comments.update_dt}">
					    		<b style="color:green">[수정됨]</b>
					    	</c:if>
					    </b>
					    <span style="float:right;" align="right">${comments.regist_dt}</span>
					    <p class="commentsContent">${comments.content}</p>
					    <c:if test="${member_no == comments.member_no || author_no == 1 || author_no == 2}">
					    	<div class="snsCommentsUpdateDeleteBtns">
							    <button type="button" class="update_cmmt btn btn-sm btn-outline-secondary" onclick="commentsUpdateMode($(this))">수정</button>
							    <button type="button" class="delete_cmmt btn btn-sm btn-outline-danger" onclick="commentsDelete($(this))">삭제</button>
						    </div>
					    </c:if>
				    </div>
				</div>
			</c:forEach>
		</c:if>
	</div>
</div>
<!-- 댓글 end-->