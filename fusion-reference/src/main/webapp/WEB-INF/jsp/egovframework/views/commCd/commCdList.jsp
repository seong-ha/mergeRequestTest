<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>tr {
   line-height: 25px;
   min-height: 25px;
   height: 25px;
}</style>
<body>
	<main class="mt-5 pt-5 card-body">
		<div class="container-fluid px-4">
			<h1 class="mt-4">
			<c:forEach items="${headerMenuList}" var="headerMenu">
				<c:if test="${headerMenu.menu_type == menuType}">
					<option value="${headerMenu.menu_type}">${headerMenu.menu_name}</option>
				</c:if>											
			</c:forEach>
			</h1>
			
			<div id="commCdContainer">
				<ul class="nav nav-tabs" id="typeTab" role="tablist" style="">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="normal-tab" data-bs-toggle="tab" data-bs-target="#normal-tab-pane" type="button" role="tab" aria-controls="normal-tab-pane" aria-selected="true">일반구조</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="tree-tab" data-bs-toggle="tab" data-bs-target="#tree-tab-pane" type="button" role="tab" aria-controls="tree-tab-pane" aria-selected="false">트리구조</button>
					</li>
				</ul>
				
				<div id="commCdSearchDiv">
					<select id="srchType" name="srchType">
						<option value="code">코드</option>
						<option value="codeName">코드명</option>
					</select>
		            <input type="text" placeholder="Search..." id="srchText" name="srchText">
		            <button type="button" class="btn btn-sm btn-info" id="snsSearchBtn">검색</button>
				</div>
				
				<div class="tab-content" id="myTabContent">
					<div class="tab-pane fade show active" id="normal-tab-pane" role="tabpanel" aria-labelledby="normal-tab" tabindex="0">
						<div class="groupCd card mb-4">
							<div>
								<h3 class="categoryType">대분류</h3>
								<span class="groupCdCnt"></span>
								<button type="button" class="btn btn-sm btn-danger checkDeleteBtn">체크삭제</button>
							</div>
							<table class="table table-hover table-striped table-bordered">
								<colgroup>
									<col width="15%">
									<col width="35%">
									<col width="45%">
								</colgroup>
								<thead>
									<tr>
										<th><input type="checkbox" class="groupCdAllChkbox" /></th>
										<th>코드</th>
										<th>코드명</th>
									</tr>
								</thead>
							</table>
							<div class="tbodyTable">
								<table class="table table-hover table-striped table-bordered">
									<colgroup>
										<col width="15%">
										<col width="35%">
										<col width="45%">
									</colgroup>
									<tbody></tbody>
								</table>
							</div>
						</div>
						<div class="detailCd card mb-4">
							<div>
								<h3 class="categoryType">소분류</h3>
								<span class="detailCdCnt">0건</span>
								<button type="button" class="btn btn-sm btn-danger checkDeleteBtn">체크삭제</button>
							</div>
							<table class="table table-hover table-striped table-bordered">
								<colgroup>
									<col width="10%">
									<col width="20%">
									<col width="35%">
									<col width="35%">
								</colgroup>
								<thead>
									<tr>
										<th><input type="checkbox" class="detailCdAllChkbox" /></th>
										<th>코드</th>
										<th>코드명</th>
										<th>비고</th>
									</tr>
								</thead>
							</table>
							<div class="tbodyTable">
								<table class="table table-hover table-striped table-bordered">
									<colgroup>
										<col width="10%">
										<col width="20%">
										<col width="35%">
										<col width="35%">
									</colgroup>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</div>
					
					
					<div class="tab-pane fade" id="tree-tab-pane" role="tabpanel" aria-labelledby="tree-tab" tabindex="0">
					</div>
				</div>
				
				<div style="display: flex; flex-direction: column; align-items: flex-start; padding-left: 20%;">
					<div style="margin-bottom: 10px">
						<span>대분류 </span>
						<input type="text" placeholder="대분류 코드" id="groupCdInput">
				    	<input type="text" placeholder="대분류 코드명" id="groupCdNameInput">
				    	<button type="button" class="btn btn-sm btn-secondary" id="groupInputCancelBtn">취소</button>
				    	<button type="button" class="btn btn-sm btn-success" id="groupRegistBtn">등록</button>
				    	<button type="button" class="btn btn-sm btn-info" id="groupUpdateBtn" disabled>수정</button>
				    </div>
				    <div>
				    	<span>소분류 </span>
				    	<input type="text" placeholder="소분류 코드" id="detailCdInput" disabled>
				    	<input type="text" placeholder="소분류 코드명" id="detailCdNameInput" disabled>
				    	<input type="text" placeholder="비고" id="detailNoteInput" disabled>
				    	<button type="button" class="btn btn-sm btn-secondary" id="detailInputCancelBtn" disabled>취소</button>
				    	<button type="button" class="btn btn-sm btn-success" id="detailRegistBtn" disabled>등록</button>
				    	<button type="button" class="btn btn-sm btn-info" id="detailUpdateBtn" disabled>수정</button>
					</div>
				</div>
				<hr>
			</div>
		</div>
	</main>

<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script type="text/javascript">
	$(document).ready(function() {
		// 일단 그룹코드를 가져와서 넣는다.
		groupCdSet();
		
		$(document).on('click', function() {
			nowTabId = $('#typeTab .active').attr('id');
		})
		
		// 일반구조 탭 버튼 이벤트
		$('#normal-tab').on('click', function() {
			// 트리구조에서 쓰이는 버튼 없애기
			removeTreePrivateBtn();
			
			$('#normal-tab-pane').css('display', 'flex');
			$('#srchType').val('code');
			$('#srchText').val('');
			
			setTimeout(() => {
				groupCdSet();
				$('#normal-tab-pane .groupCd .tbodyTable')[0].scrollTop = 0;
			}, 10);
			
			cleanGroupInput();
			groupInputRegistMode();
			cleanDetailDiv();
			
			cleanDetailInput();
			disableDetailInput();
		})
		
		// 트리구조 탭 버튼 이벤트
		$('#tree-tab').on('click', function() {
			$('#normal-tab-pane').css('display', 'none');
			$('#srchType').val('code');
			$('#srchText').val('');
			
			removeTreePrivateBtn();
			createTreePrivateBtn();
			// 이벤트 등록
			treeCheckDeleteBtn();
			treeNoneCheckBtn();
			
			setTimeout(() => {
				groupDetailCdSet();
			}, 10);
			
			
			cleanGroupInput();
			groupInputRegistMode();
			cleanDetailInput();
			cleanDetailDiv();
			disableDetailInput();

			//$('#normal-tab-pane .groupCd .tbodyTable')[0].scrollTop = 0;
		})
		
		$('#srchText').on('keyup', function() {
			if (nowTabId == 'normal-tab') {
				groupCdSet();
				cleanGroupInput();
				groupInputRegistMode();
				cleanDetailDiv();
				cleanDetailInput();
				disableDetailInput();
			} else if (nowTabId = 'tree-tab') {
				groupDetailCdSet();
				cleanGroupInput();
				groupInputRegistMode();
				cleanDetailInput();
				cleanDetailDiv();
				disableDetailInput();
			}
		})
		
		// 대분류 allcheckbox 이벤트
		$('.groupCdAllChkbox').on('click', function() {
			if ($(event.target).prop('checked') == true) {
				$('#' + nowTabId + '-pane .groupCd .groupCdChkbox').prop('checked', true);
			} else {
				$('#' + nowTabId + '-pane .groupCd .groupCdChkbox').prop('checked', false);
			}
		})
		
		// 소분류 allcheckbox 이벤트
		$('.detailCdAllChkbox').on('click', function() {
			if ($(event.target).prop('checked') == true) {
				$('#' + nowTabId + '-pane .detailCd .detailCdChkbox').prop('checked', true);
			} else {
				$('#' + nowTabId + '-pane .detailCd .detailCdChkbox').prop('checked', false);
			}
		})
		
		// 대분류 입력란 취소버튼(대분류를 추가하기 위해 선택한 것들을 모두 없앤다.)
		$('#groupInputCancelBtn').on('click', function() {
			if (nowTabId == 'normal-tab') {
				$('.groupCd .tbodyTable tr').removeClass('choosedTr');
				// 그룹코드 입력란 비워주기
				cleanGroupInput();
				// 그룹코드 등록버튼 abled, 수정버튼 disabled
				groupInputRegistMode();
				// 상세코드 div 비워주기
				cleanDetailDiv();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
			} else if (nowTabId == 'tree-tab') {
				$('#' + nowTabId + '-pane .groupCd').removeClass('choosed');
				// 그룹코드 입력란 비워주기
				cleanGroupInput();
				// 그룹코드 등록버튼 abled, 수정버튼 disabled
				groupInputRegistMode();
			}
		})
		
		// 그룹코드 등록버튼 이벤트
		$('#groupRegistBtn').on('click', function() {
			let code = $('#groupCdInput').val().trim();
			let codeName = $('#groupCdNameInput').val().trim();
			
			if (code == null || code == '') {
				alert('대분류 코드를 입력해주세요.');
				$('#groupCdInput').focus();
				return;
			} else if (code != null && code.length > 10) {
				alert('10자 이내로 입력해주세요.');
				$('#groupCdInput').focus();
				return;
			} else if (codeName == null || codeName == '') {
				alert('대분류 코드명를 입력해주세요.');
				$('#groupCdNameInput').focus();
				return;
			} else if (codeName != null && codeName.length > 45) {
				alert('45자 이내로 입력해주세요.');
				$('#groupCdNameInput').focus();
				return;
			}
			
			let data = {
					'code': code,
					'code_name': codeName,
					'parent_no': 0
			};
			
			// 코드 중복이면 되돌리기
			if (checkCodeDuplicate(data)) {
				$('#groupCdInput').focus();
	    		return;
			}
			
			if (confirm('등록하시겠습니까?')) {
				// 공통코드 등록 후 안내
				let result = insCommCd(data);
				if (result == '성공') {
					
					if (nowTabId == 'normal-tab') {
						groupCdSet();
			    		cleanGroupInput();
			    		$('#' + nowTabId + '-pane .groupCd .tbodyTable')[0].scrollTop = 0;
					} else if (nowTabId = 'tree-tab') {
						groupDetailCdSet();
						cleanGroupInput();
						groupInputRegistMode();
						cleanDetailInput();
						cleanDetailDiv();
						disableDetailInput();
					}
				}
			}
		})
		
		
		// 그룹코드 수정버튼 이벤트
		$('#groupUpdateBtn').on('click', function() {
			let commCdNo = '';
			if (nowTabId == 'normal-tab') {
				commCdNo = $('#' + nowTabId + '-pane .groupCd .tbodyTable tr.choosedTr').attr('data-comm_cd_no');
			} else if (nowTabId = 'tree-tab') {
				commCdNo = $('#' + nowTabId + '-pane .groupCd.choosed').parents('.groupDetailDiv').attr('data-comm_cd_no');
			}
			
			let code = $('#groupCdInput').val().trim();
			let codeName = $('#groupCdNameInput').val().trim();
			
			if (code == null || code == '') {
				alert('대분류 코드를 입력해주세요.');
				$('#groupCdInput').focus();
				return;
			} else if (code != null && code.length > 10) {
				alert('10자 이내로 입력해주세요.');
				$('#groupCdInput').focus();
				return;
			} else if (codeName == null || codeName == '') {
				alert('대분류 코드명를 입력해주세요.');
				$('#groupCdNameInput').focus();
				return;
			} else if (codeName != null && codeName.length > 45) {
				alert('45자 이내로 입력해주세요.');
				$('#groupCdNameInput').focus();
				return;
			}
			
			let data = {
					'comm_cd_no': commCdNo,
					'code': code,
					'code_name': codeName,
					'parent_no': 0
			};
			
			// 코드 중복이면 되돌리기
			if (checkCodeDuplicate(data)) {
				$('#groupCdInput').focus();
	    		return;
			}
			
			if (confirm('수정하시겠습니까?')) {
				// 공통코드 수정 후 안내
				let result = updCommCd(data);
				if (result == '성공') {
					
					if (nowTabId == 'normal-tab') {
						groupCdSet();
						// 수정한 공통코드로 scroll 높이 맞추기
			    		let trOrderNum = $('#' + nowTabId + '-pane .groupCd .tbodyTable').find('tr[data-comm_cd_no=' + commCdNo + ']').attr('data-order_num');
			    		$('#' + nowTabId + '-pane .groupCd .tbodyTable')[0].scrollTop = 42 * (trOrderNum -1);
			    		$('#' + nowTabId + '-pane .groupCd .tbodyTable').find('tr[data-comm_cd_no=' + commCdNo + ']').addClass('choosedTr');
			    		
			    		detailCdSet();
			    		cleanDetailInput();
			    		detailInputRegistMode();	
					} else if (nowTabId = 'tree-tab') {
						groupDetailCdSet();
						cleanGroupInput();
						groupInputRegistMode();
						cleanDetailInput();
						cleanDetailDiv();
						disableDetailInput();
					}
					
				}
			}
		})
		
		// 체크삭제 버튼 이벤트
		$('.checkDeleteBtn').on('click', function() {
			let targetCd = '';
			
			if ($(event.target).parents('.groupCd').length > 0) {
				targetCd = 'groupCd';
			} else if ($(event.target).parents('.detailCd').length > 0) {
				targetCd = 'detailCd';
			}
			
			$chkboxes = $('#' + nowTabId + '-pane .' + targetCd).find('input[type=checkbox]:checked');
			
			if ($chkboxes.length == 0) {
				alert('삭제할 공통코드를 체크해주세요.');
				return;
			}
			
			let deleteList = [];
			
			$chkboxes.each(function(idx, item) {
				let commCdNo = $(item).parents('tr').attr('data-comm_cd_no');
				deleteList.push(commCdNo);
			})
			
			if (targetCd == 'groupCd') {
				// 소분류 확인
				let detailCdResult = getHasDetailCd(deleteList);
				
				if (detailCdResult.result == '있음') {
					let trCode = $('#' + nowTabId + '-pane .groupCd .tbodyTable').find('tr[data-comm_cd_no=' + detailCdResult.comm_cd_no + ']').attr('data-code');
					alert(trCode + detailCdResult.msg);
					
					let trOrderNum = $('#' + nowTabId + '-pane .groupCd .tbodyTable').find('tr[data-comm_cd_no=' + detailCdResult.comm_cd_no + ']').attr('data-order_num');
		    		$('#' + nowTabId + '-pane .groupCd .tbodyTable')[0].scrollTop = 42 * (trOrderNum -1);
					return;
				} else if (detailCdResult.result == '실패') {
					alert(detailCdResult.msg);
					return;
				}
			}
			
			if (confirm('삭제하시겠습니까?')) {
				let result = delCommCdList(deleteList);
				if (result == '성공') {
					if (targetCd == 'groupCd') {
						groupCdSet();
			    		cleanGroupInput();
			    		groupInputRegistMode();
			    		$('#' + nowTabId + '-pane .groupCd .tbodyTable')[0].scrollTop = 0;
					} else if(targetCd == 'detailCd') {
						detailCdSet();
						cleanDetailInput();
						detailInputRegistMode();
						$('#' + nowTabId + '-pane .detailCd .tbodyTable')[0].scrollTop = 0;
					}
				}
			}
			
		})
		
		
		// 소분류 입력란 취소버튼(소분류를 추가하기 위해 선택을 해제한다.)
		$('#detailInputCancelBtn').on('click', function() {
			$('.detailCd .tbodyTable tr').removeClass('choosedTr');
			// 상세코드 입력란 비워주기
			cleanDetailInput();
			// 상세코드 등록모드
			detailInputRegistMode();
		})
		
		
		// 소분류 등록 버튼
		$('#detailRegistBtn').on('click', function() {
			let parentNo = '';
			if (nowTabId == 'normal-tab') {
				parentNo = $('#' + nowTabId + '-pane .groupCd .tbodyTable tr.choosedTr').attr('data-comm_cd_no');
			} else if (nowTabId = 'tree-tab') {
				parentNo = $('#' + nowTabId + '-pane .groupCd.choosed').parents('.groupDetailDiv').attr('data-comm_cd_no');
			}
			
			let code = $('#detailCdInput').val().trim();
			let codeName = $('#detailCdNameInput').val().trim();
			let note = $('#detailNoteInput').val().trim();
			 
			if (parentNo == null || parentNo == '') {
				alert('대분류를 먼저 선택해주세요.');
				return;
			} else if (code == null || code == '') {
				alert('소분류 코드를 입력해주세요.');
				$('#detailCdInput').focus();
				return;
			} else if (code != null && code.length > 10) {
				alert('10자 이내로 입력해주세요.');
				$('#detailCdInput').focus();
				return;
			} else if (codeName == null || codeName == '') {
				alert('소분류 코드명를 입력해주세요.');
				$('#detailCdNameInput').focus();
				return;
			} else if (codeName != null && codeName.length > 45) {
				alert('45자 이내로 입력해주세요.');
				$('#detailCdNameInput').focus();
				return;
			} else if (note != null && note.length > 200) {
				alert('100자 이내로 입력해주세요.');
				$('#detailNoteInput').focus();
				return;
			}
			
			let data = {
					'code': code,
					'code_name': codeName,
					'note': note,
					'parent_no': parentNo
			};
			
			// 코드 중복이면 되돌리기
			if (checkCodeDuplicate(data)) {
				$('#detailCdInput').focus();
	    		return;
			}
			
			if (confirm('등록하시겠습니까?')) {
				// 공통코드 등록 후 안내
				let result = insCommCd(data);
				if (result == '성공') {
					if (nowTabId == 'normal-tab') {
						detailCdSet();
			    		cleanDetailInput();
			    		$('#' + nowTabId + '-pane .detailCd .tbodyTable')[0].scrollTop = 0;
					} else if (nowTabId = 'tree-tab') {
						groupDetailCdSet();
						cleanGroupInput();
						groupInputRegistMode();
						cleanDetailDiv();
						cleanDetailInput();
						disableDetailInput();
					}
					
				}
			}
			
		})
		
		
		// 상세코드 수정버튼 이벤트
		$('#detailUpdateBtn').on('click', function() {
			let parentNo = '';
			if (nowTabId == 'normal-tab') {
				parentNo = $('#' + nowTabId + '-pane .groupCd .tbodyTable tr.choosedTr').attr('data-comm_cd_no');
			} else if (nowTabId = 'tree-tab') {
				parentNo = $('#' + nowTabId + '-pane .detailCd.choosed').parents('.groupDetailDiv').attr('data-comm_cd_no');
			}
			
			let commCdNo = '';
			if (nowTabId == 'normal-tab') {
				commCdNo = $('#' + nowTabId + '-pane .detailCd .tbodyTable tr.choosedTr').attr('data-comm_cd_no');
			} else if (nowTabId = 'tree-tab') {
				commCdNo = $('#' + nowTabId + '-pane .detailCd.choosed').attr('data-comm_cd_no');
			}
			
			let code = $('#detailCdInput').val().trim();
			let codeName = $('#detailCdNameInput').val().trim();
			let note = $('#detailNoteInput').val().trim();
			
			
			if (parentNo == null || parentNo == '') {
				alert('대분류를 먼저 선택해주세요.');
				return;
			} 
			
			if (code == null || code == '') {
				alert('소분류 코드를 입력해주세요.');
				$('#detailCdInput').focus();
				return;
			} else if (code != null && code.length > 10) {
				alert('10자 이내로 입력해주세요.');
				$('#detailCdInput').focus();
				return;
			} else if (codeName == null || codeName == '') {
				alert('소분류 코드명를 입력해주세요.');
				$('#detailCdNameInput').focus();
				return;
			} else if (codeName != null && codeName.length > 45) {
				alert('45자 이내로 입력해주세요.');
				$('#detailCdNameInput').focus();
				return;
			} else if (note != null && note.length > 200) {
				alert('100자 이내로 입력해주세요.');
				$('#detailNoteInput').focus();
				return;
			}
			
			let data = {
					'comm_cd_no': commCdNo,
					'code': code,
					'code_name': codeName,
					'note': note,
					'parent_no': parentNo
			};
			
			console.log(data);
			// 코드 중복이면 되돌리기
			if (checkCodeDuplicate(data)) {
				$('#detailCdInput').focus();
	    		return;
			}
			
			if (confirm('수정하시겠습니까?')) {
				let result = updCommCd(data);
				if (result == '성공') {
					if (nowTabId == 'normal-tab') {
						detailCdSet();
						// 수정한 공통코드로 scroll 높이 맞추기
			    		let trOrderNum = $('#' + nowTabId + '-pane .detailCd .tbodyTable').find('tr[data-comm_cd_no=' + commCdNo + ']').attr('data-order_num');
			    		$('#' + nowTabId + '-pane .detailCd .tbodyTable')[0].scrollTop = 42 * (trOrderNum -1);
			    		$('#' + nowTabId + '-pane .detailCd .tbodyTable').find('tr[data-comm_cd_no=' + commCdNo + ']').addClass('choosedTr');
			    		detailInputRegistMode();
					} else if (nowTabId = 'tree-tab') {
						groupDetailCdSet();
						cleanGroupInput();
						groupInputRegistMode();
						cleanDetailInput();
						cleanDetailDiv();
						disableDetailInput();
						
					}
				}
			}
		})
	});

	// 현재 탭 id. 처음엔 일반구조탭
	var nowTabId = 'normal-tab';
	
	// 그룹코드 가져와서 넣어주기
	function groupCdSet() {
		let groupCdList = getGroupCdList();
		
		if (groupCdList != null && groupCdList.length > 0) {
			cleanGroupDiv();
			placeGroupCd(groupCdList);
			cleanDetailDiv();
		} else {
			cleanGroupDiv();
			let tr =`<tr><td colspan="3">검색된 공통 코드가 없습니다.</td></tr>`;
			$('#' + nowTabId + '-pane .groupCd .tbodyTable tbody').append(tr);
			$('#' + nowTabId + '-pane .groupCd .groupCdCnt').text('0건');
		}
	}
	
	
	// 그룹코드 div 비워주기
	function cleanGroupDiv() {
		$('#' + nowTabId + '-pane .groupCd tbody').empty();
	}
	
	
	// 그룹코드리스트 가져오기
	function getGroupCdList() {
		let data = {
				'srchType': $('#srchType').val().trim(),
				'srchText': $('#srchText').val().trim(),
				'menuType': '${menuType}'
		}
		
		let groupCdList = '';
		
		$.ajax({
			url: '/commCd/groupCdList.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
				groupCdList = data;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return groupCdList;
	}
	
	
	// 그룹코드리스트 만들어서 배치하기
	function placeGroupCd(groupCdList) {
		let $groupCdTbody = $('#' + nowTabId + '-pane .groupCd .tbodyTable tbody');
		$(groupCdList).each(function(idx, item) {
			let $tr = $('<tr '
					    + 'data-order_num='  + item.order_num  + ' '
					    + 'data-comm_cd_no=' + item.comm_cd_no + ' '
					    + 'data-code='       + item.code       + ' '
					    + 'data-code_name='  + item.code_name  + ' '
					    + 'data-note='       + item.note       + '>'
					   );
			let $orderNumTd = $('<td/>');
			let $label = $('<label>' + item.order_num + '</label>');
			let $checkbox = $('<input type="checkbox" class="groupCdChkbox"/>');
			$label.prepend($checkbox);
			$orderNumTd.prepend($label);
			
			let $codeTd = $('<td/>').text(item.code);
			let $codeNameTd = $('<td/>').text(item.code_name);
			
			$tr.append($orderNumTd, $codeTd, $codeNameTd);
			$groupCdTbody.append($tr);
		})
		
		// 체크박스 이벤트버블링 차단
		addCheckboxStopPropagate();
		// 그룹코드 tbody tr 클릭 시 색깔 주기
		addGroupCdTrClickEvent();
		$('#' + nowTabId + '-pane .groupCd .groupCdCnt').text(groupCdList.length + '건');
		
	}
	
	// 체크박스,라벨 이벤트버블링 차단
	function addCheckboxStopPropagate() {
		$('input[tupe=checkbox]').on('click', function(event) {
			event.stopPropagation();
		})
		
		$('label').on('click', function(event) {
			event.stopPropagation();
		})
	}
	
	// 그룹코드 tbody tr 클릭 이벤트
	function addGroupCdTrClickEvent() {
		$('.groupCd .tbodyTable tr').on('click', function() {
			console.log($(this).css('background-color'));
			if ($(this).css('background-color') == 'rgba(0, 0, 0, 0)') {
				$('.groupCd .tbodyTable tr').removeClass('choosedTr');
				$(this).addClass('choosedTr');
				
				// 선택한 그룹코드 입력란에 넣어주기
				addGroupInput();
				// 그룹코드 등록버튼 disabled, 수정버튼 abled
				groupInputUpdateMode();
				// 상세 코드 가져와서 넣어주기
				detailCdSet();
				// 상세코드 입력란 disabled 풀어주기
				enableDetailInput();
				detailInputRegistMode();
				cleanDetailInput();
			} else {
				$('.groupCd .tbodyTable tr').removeClass('choosedTr');
				// 그룹코드 입력란 비워주기
				cleanGroupInput();
				// 그룹코드 등록버튼 abled, 수정버튼 disabled
				groupInputRegistMode();
				// 상세코드 div 비워주기
				cleanDetailDiv();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
			}
		});
	}
	
	// 코드 중복여부 확인 
	function checkCodeDuplicate(data) {
		// code 중복 여부
		let isDuplicate = false;
		
		$.ajax({
			url: '/commCd/getIsDuplicate.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	if (data.result != '가능') {
		    		alert(data.msg);
		    		isDuplicate = true;
		    	}
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		// code가 중복이면 true return
		return isDuplicate
	}
	
	// 공통코드 등록
	function insCommCd(data) {
		let result = '';
		$.ajax({
			url: '/commCd/insCommCd.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	alert(data.msg);
	    		result = data.result;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return result;
	}
	
	
	// 공통코드 수정
	function updCommCd(data) {
		let result = '';
		$.ajax({
			url: '/commCd/updCommCd.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	alert(data.msg);
	    		result = data.result;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return result;
	}
	
	
	// 체크삭제 전에 소분류를 가지고 있는지 확인
	function getHasDetailCd(data) {
		let result = '';
		$.ajax({
			url: '/commCd/getHasDetailCd.do',
			type: 'post',
			contentType: 'application/json',
			data: JSON.stringify(data),
			dataType: 'json',
			async: false,
		    success: function(data) {
	    		result = data;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return result;
	}
	
	// 체크 공통코드 삭제
	function delCommCdList(data) {
		let result = '';
		$.ajax({
			url: '/commCd/delCommCdList.do',
			type: 'post',
			contentType: 'application/json',
			data: JSON.stringify(data),
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	alert(data.msg);
		    	result = data.result;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return result;
	}
	
	
	// 선택한 그룹코드 입력란에 넣어주기
	function addGroupInput() {
		let $choosedTr = $('.groupCd .tbodyTable tr.choosedTr');
		let code = $choosedTr.attr('data-code');
		let codeName = $choosedTr.attr('data-code_name');
		$('#groupCdInput').val(code);
		$('#groupCdNameInput').val(codeName);
		
	}
	
	// 그룹코드 입력란 비워주기
	function cleanGroupInput() {
		$('#groupCdInput').val('');
		$('#groupCdNameInput').val('');
	}
	
	// 그룹코드 등록버튼 disabled, 수정버튼 abled
	function groupInputUpdateMode() {
		$('#groupRegistBtn').prop('disabled', true);
		$('#groupUpdateBtn').prop('disabled', false);
	}
	
	// 그룹코드 등록버튼 abled, 수정버튼 disabled
	function groupInputRegistMode() {
		$('#groupRegistBtn').prop('disabled', false);
		$('#groupUpdateBtn').prop('disabled', true);
	}
	
	// 그룹코드 입력란, 버튼 비활성화
	function disableGroupInput() {
		$('#groupCdInput').prop('disabled', true);
		$('#groupCdNameInput').prop('disabled', true);
		$('#groupCdInput').prop('disabled', true);
		
		$('#groupInputCancelBtn').prop('disabled', true);
		$('#groupRegistBtn').prop('disabled', true);
		$('#groupUpdateBtn').prop('disabled', true);
	}
	// 그룹코드 입력란, 버튼 활성화
	function enableGroupInput() {
		$('#groupCdInput').prop('disabled', false);
		$('#groupCdNameInput').prop('disabled', false);
		$('#groupCdInput').prop('disabled', false);
		
		$('#groupInputCancelBtn').prop('disabled', false);
		$('#groupRegistBtn').prop('disabled', false);
	}
	
	
	// 상세코드 가져와서 넣어주기
	function detailCdSet() {
		let detailCdList = getDetailCdList();
		
		if (detailCdList != null && detailCdList.length > 0) {
			cleanDetailDiv();
			placeDetailCd(detailCdList);
		} else {
			cleanDetailDiv();
			let tr =`<tr><td colspan="4">검색된 소분류 코드가 없습니다.</td></tr>`;
			$('#' + nowTabId + '-pane .detailCd .tbodyTable tbody').append(tr);
		}
	}
	
	
	// 상세코드 div 비워주기
	function cleanDetailDiv() {
		$('#' + nowTabId + '-pane .detailCd .tbodyTable tbody').empty();
		$('#' + nowTabId + '-pane .detailCd .detailCdCnt').text('0건');
	}
	
	
	// 상세코드리스트 가져오기
	function getDetailCdList() {
		let parentNo = $('.groupCd .tbodyTable tr.choosedTr').attr('data-comm_cd_no');
		let data = {
				'parent_no': parentNo,
				'menuType': '${menuType}'
		}
		console.log(data);
		
		let detailCdList = '';
		
		$.ajax({
			url: '/commCd/detailCdList.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	detailCdList = data;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return detailCdList;
	}
	
	// 상세코드리스트 만들어서 배치하기
	function placeDetailCd(detailCdList) {
		let $detailCdTbody = $('#' + nowTabId + '-pane .detailCd .tbodyTable tbody');
		$(detailCdList).each(function(idx, item) {
			let $tr = $('<tr '
					    + 'data-comm_cd_no=' + item.comm_cd_no + ' '
					    + 'data-code='       + item.code       + ' '
					    + 'data-code_name='  + item.code_name  + ' '
					    + 'data-note='       + item.note       + ' '
					    + 'data-parent_no='  + item.parent_no  + '>'
					   );
			let $orderNumTd = $('<td/>');
			let $label = $('<label>' + item.order_num + '</label>');
			let $checkbox = $('<input type="checkbox" class="detailCdChkbox"/>');
			$label.prepend($checkbox);
			$orderNumTd.prepend($label);
			
			let $codeTd = $('<td/>').text(item.code);
			let $codeNameTd = $('<td/>').text(item.code_name);
			let $noteTd = $('<td/>').text(item.note);
			
			$tr.append($orderNumTd, $codeTd, $codeNameTd, $noteTd);
			$detailCdTbody.append($tr);
		})
		
		// 체크박스 이벤트버블링 차단
		addCheckboxStopPropagate();
		// 그룹코드 tbody tr 클릭 시 색깔 주기
		addDetailCdTrClickEvent();
		$('#' + nowTabId + '-pane .detailCd .detailCdCnt').text(detailCdList.length + '건');
	}
	
	// 상세코드 tbody tr 클릭 이벤트
	function addDetailCdTrClickEvent() {
		$('.detailCd .tbodyTable tr').on('click', function() {
			console.log($(this).css('background-color'));
			if ($(this).css('background-color') == 'rgba(0, 0, 0, 0)') {
				$('.detailCd .tbodyTable tr').removeClass('choosedTr');
				$(this).addClass('choosedTr');
				
				addDetailInput();
				// 상세코드 등록버튼 disable, 수정버튼 able
				detailInputUpdateMode();
			} else {
				$('.detailCd .tbodyTable tr').removeClass('choosedTr');
				cleanDetailInput();
				// 상세코드 등록버튼 able, 수정버튼 disabled
				detailInputRegistMode();
			}
		});
	}
	
	// 선택한 상세코드 입력란에 넣어주기
	function addDetailInput() {
		let $choosedTr = $('.detailCd .tbodyTable tr.choosedTr');
		let code = $choosedTr.attr('data-code');
		let codeName = $choosedTr.attr('data-code_name');
		let note = $choosedTr.attr('data-note');
		if (note == 'null') {
			note = '';
		}
		$('#detailCdInput').val(code);
		$('#detailCdNameInput').val(codeName);
		$('#detailNoteInput').val(note);
	}
	
	// 상세코드 입력란 비워주기
	function cleanDetailInput() {
		$('#detailCdInput').val('');
		$('#detailCdNameInput').val('');
		$('#detailNoteInput').val('');
	}
	
	// 상세코드 disabled 풀어주기
	function enableDetailInput() {
		$('#detailCdInput').prop('disabled', false);
		$('#detailCdNameInput').prop('disabled', false);
		$('#detailNoteInput').prop('disabled', false);
		$('#detailInputCancelBtn').prop('disabled', false);
		$('#detailRegistBtn').prop('disabled', false);
	}
	
	// 상세코드 disabled 걸어주기
	function disableDetailInput() {
		$('#detailCdInput').prop('disabled', true);
		$('#detailCdNameInput').prop('disabled', true);
		$('#detailNoteInput').prop('disabled', true);
		$('#detailInputCancelBtn').prop('disabled', true);
		$('#detailRegistBtn').prop('disabled', true);
		$('#detailUpdateBtn').prop('disabled', true);
	}
	
	// 상세코드 등록버튼 able, 수정버튼 disabled
	function detailInputRegistMode() {
		$('#detailRegistBtn').prop('disabled', false);
		$('#detailUpdateBtn').prop('disabled', true);
	}
	
	// 상세코드 등록버튼 disable, 수정버튼 able
	function detailInputUpdateMode() {
		$('#detailRegistBtn').prop('disabled', true);
		$('#detailUpdateBtn').prop('disabled', false);
	}
	
	
	
	/////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	// 트리구조

	// 트리구조 체크삭제 체크해제버튼 지우기
	function removeTreePrivateBtn() {
		$('#treeCheckDeleteBtn').remove();
		$('#treeNoneCheckBtn').remove();
		$('#treeCheckDeleteBtn').off();
		$('#treeNoneCheckBtn').off();
	}
	
	// 트리구조 체크삭제 체크해제버튼 생성
	function createTreePrivateBtn() {
		let treeCheckDeleteBtn = $('<button type="button" class="btn btn-sm btn-danger" id="treeCheckDeleteBtn">체크삭제</button>');
		treeCheckDeleteBtn.css('margin-left', '15px');
		treeCheckDeleteBtn.css('margin-right', '5px');
		$('#commCdSearchDiv').append(treeCheckDeleteBtn);
		let treeNoneCheckBtn = $('<button type="button" class="btn btn-sm btn-secondary" id="treeNoneCheckBtn">체크해제</button>');
		$('#commCdSearchDiv').append(treeNoneCheckBtn);
		
	}
	
	// 트리구조 체크삭제버튼 이벤트
	function treeCheckDeleteBtn() {
		$('#treeCheckDeleteBtn').on('click', function() {
			let $chkboxes = $('#' + nowTabId + '-pane input[type=checkbox]:checked');
			
			if ($chkboxes.length == 0) {
				alert('삭제할 공통코드를 체크해주세요.');
				return;
			}
			
			let targetCd = '';
			
			if ($($chkboxes[0]).attr('class') == 'treeGroupCdChkbox') {
				targetCd = 'groupCd';
			} else if ($($chkboxes[0]).attr('class') == 'treeDetailCdChkbox') {
				targetCd = 'detailCd';
			}
			
			let deleteList = [];

			if (targetCd == 'groupCd') {
				$chkboxes.each(function(idx, item) {
					let commCdNo = $(item).parents('.groupDetailDiv').attr('data-comm_cd_no');
					deleteList.push(commCdNo);
				})
			} else if (targetCd == 'detailCd') {
				$chkboxes.each(function(idx, item) {
					let commCdNo = $(item).parents('.detailCd').attr('data-comm_cd_no');
					deleteList.push(commCdNo);
				})
			}
			
			
			
			if (targetCd == 'groupCd') {
				// 소분류 확인
				let detailCdResult = getHasDetailCd(deleteList);
				
				if (detailCdResult.result == '있음') {
					let duplicatedCode = $('#' + nowTabId + '-pane .groupDetailDiv[data-comm_cd_no=' + detailCdResult.comm_cd_no + ']').attr('data-code');
					alert(duplicatedCode + detailCdResult.msg);
					$('#' + nowTabId + '-pane .groupDetailDiv[data-comm_cd_no=' + detailCdResult.comm_cd_no + ']'),focus();
					return;
				} else if (detailCdResult.result == '실패') {
					alert(detailCdResult.msg);
					return;
				}
			}
			
			if (confirm('삭제하시겠습니까?')) {
				let result = delCommCdList(deleteList);
				if (result == '성공') {
					groupDetailCdSet();
					cleanGroupInput();
					groupInputRegistMode();
					cleanDetailInput();
					disableDetailInput();
				}
			}
		});
	}
	
	function treeNoneCheckBtn() {
		$('#treeNoneCheckBtn').on('click', function() {
			$('#' + nowTabId + '-pane input[type=checkbox]').prop('checked', false);
		});
	}
	
	
	
	// 그룹코드 가져와서 넣어주기
	function groupDetailCdSet() {
		let commCdList = getGroupDetailCdList();
		
		if (commCdList != null && commCdList.length > 0) {
			cleanTreeTab();
			placeGroupDetailCd(commCdList);
		} else {
			cleanTreeTab();
			let div =`<div>검색된 공통 코드가 없습니다.</div>`;
			$('#' + nowTabId + '-pane').append(div);
		}
	}
	
	
	// 트리 비워주기
	function cleanTreeTab() {
		$('#' + nowTabId + '-pane').empty();
	}
	
	
	// 계층 구조로 가져오기
	function getGroupDetailCdList() {
		let data = {
				'srchType': $('#srchType').val().trim(),
				'srchText': $('#srchText').val().trim(),
				'menuType': '${menuType}'
		}
		
		let commCdList = '';
		$.ajax({
			url: '/commCd/getGroupDetailCdList.do',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
		    success: function(data) {
		    	commCdList = data;
		    },
			error: function(error) {
				console.log(error);
			}
		});
		
		return commCdList;
	}
	
	// 가져온 계층구조를 트리구조로 넣기
	function placeGroupDetailCd(commCdList) {
		$(commCdList).each(function(idx, item) {
			let plusMinusBtn = '';
			if (item.commCdList != null && item.commCdList.length > 0) {
				plusMinusBtn = 
					`<svg class="plus" xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-plus-square-fill" viewBox="0 0 16 16">
						<path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm6.5 4.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3a.5.5 0 0 1 1 0z"/>
					</svg>
					<svg class="minus" xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-dash-square-fill" viewBox="0 0 16 16">
					    <path d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm2.5 7.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1 0-1z"/>
					</svg>`
			}
			
			let groupDetailDiv =
				`<div class="groupDetailDiv" `
					+ `data-comm_cd_no=`+ item.comm_cd_no
					+ ` data-code=`+ item.code
					+ ` data-code_name=`+ item.code_name
					+ `>
					<div class="groupCd">
						<div>
							<label><input type="checkbox" class="treeGroupCdChkbox"/></label>
							
						</div>
						<div>` + item.code + `</div>
						<div>` + item.code_name + `</div>
						<div class="plusMinus">` +
						plusMinusBtn
					 + `</div>
					</div>
				</div>`;
				
			$('#' + nowTabId + '-pane').append(groupDetailDiv);
			
			// 소분류 있으면 넣기
			let detailCdDiv = '';
			
			if (plusMinusBtn != '') {
				let detailCds = '';
				
				$(item.commCdList).each(function (detailIdx, detailItem) {
					if (detailItem.note == null) {
						detailItem.note = '';
					}
					
					detailCds += 
						`<div class="detailCd" `
							+ `data-comm_cd_no=`+ detailItem.comm_cd_no
							+ ` data-code=`+ detailItem.code
							+ ` data-code_name=`+ detailItem.code_name
							+ ` data-note=\"`+ detailItem.note
							+ `\" data-parent_no=`+ detailItem.parent_no
							+ `>
							<div class="chkBox">
								<label><input type="checkbox" class="treeDetailCdChkbox"/></label>
							</div>
							<div class="code">` + detailItem.code + `</div>
							<div class="codeName">` + detailItem.code_name + `</div>
							<div class="note">` + detailItem.note + `</div>
						</div>`
				});
				
				detailCdDiv = `<div class="detailCdDiv">` + detailCds + `</div>`;
			}
			
			$('#' + nowTabId + '-pane ' + 'div[data-comm_cd_no=' + item.comm_cd_no + ']').append(detailCdDiv);
		})
		plusBtn();
		minusBtn();
		hideMinusBtn();
		addTreeGroupDivClickEvent();
		addTreeDetailDivClickEvent();
		treeCheckboxClickEvent();
	}
	
	// 마이너스 버튼 숨기기
	function hideMinusBtn() {
		$('.minus').css('display', 'none');
	};
	
	// 플러스 버튼 이벤트
	function plusBtn() {
		$('.plus').on('click', function(event) {
			console.log($(this))
			$(this).parents('.groupCd').next().css('display', 'block');
			$(this).next().css('display', 'block');
			$(this).css('display', 'none');
			
			event.stopPropagation();
		})
	}
	
	// 마이너스 버튼 이벤트
	function minusBtn() {
		$('.minus').on('click', function(event) {
			$(this).parents('.groupCd').next().css('display', 'none');
			$(this).parents('.groupCd').next().find('input[type=checkbox]').each(function(idx, item) {
				$(item).prop('checked', false);
			})
			$(this).prev().css('display', 'block');
			$(this).css('display', 'none');
			
			event.stopPropagation();
		})
	}
	
	// 그룹코드 .groupCd Div 클릭 이벤트
	function addTreeGroupDivClickEvent() {
		
		$('#' + nowTabId + '-pane .groupCd').on('click', function() {
			if ($(this).css('background-color') == 'rgb(127, 255, 212)') {
				$('#' + nowTabId + '-pane .detailCd').removeClass('choosed');
				$('#' + nowTabId + '-pane .groupCd').removeClass('choosed');
				$(this).addClass('choosed');
				
				cleanGroupInput();
				enableGroupInput();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
				
				// 선택한 그룹코드 입력란에 넣어주기
				addTreeGroupInput();
				// 상세코드 입력란 비우고 diabled
				groupInputUpdateMode();
				cleanDetailInput();
				enableDetailInput();
				detailInputRegistMode();
			} else {
				$(this).removeClass('choosed');
				// 그룹코드 입력란 비워주기
				cleanGroupInput();
				// 그룹코드 등록버튼 abled, 수정버튼 disabled
				groupInputRegistMode();
				// 상세코드 div 비워주기
				cleanDetailDiv();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
			}
		});
	}
	
	// 선택한 그룹코드 입력란에 넣기
	function addTreeGroupInput() {
		let $groupDetailDiv = $('#' + nowTabId + '-pane .groupCd.choosed').parents('.groupDetailDiv');
		let code = $groupDetailDiv.attr('data-code');
		let codeName = $groupDetailDiv.attr('data-code_name');
		
		$('#groupCdInput').val(code);
		$('#groupCdNameInput').val(codeName);
	}
	
	function treeCheckboxClickEvent() {
		$('#' + nowTabId + '-pane input[type=checkbox]').on('click', function(event) {
			if($(this).attr('class') == 'treeGroupCdChkbox') {
				$('.treeDetailCdChkbox').prop('checked', false);
			} else if ($(this).attr('class') == 'treeDetailCdChkbox') {
				$('.treeGroupCdChkbox').prop('checked', false);
			}
			
			event.stopPropagation();
		})
		
		$('#' + nowTabId + '-pane .input[type=checkbox]')
	}
	
	// 상세코드 .detailCd div 클릭 이벤트
	function addTreeDetailDivClickEvent() {
		$('#' + nowTabId + '-pane .detailCd').on('click', function() {
			if ($(this).css('background-color') == 'rgb(0, 255, 255)') {
				$('#' + nowTabId + '-pane .groupCd').removeClass('choosed');
				$('#' + nowTabId + '-pane .detailCd').removeClass('choosed');
				$(this).addClass('choosed');
				
				// 그룹코드 입력란 비워주기
				cleanGroupInput();
				// 그룹코드 등록버튼 abled, 수정버튼 disabled
				groupInputRegistMode();
				// 상세코드 div 비워주기
				cleanDetailDiv();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
				
				
				disableGroupInput();
				enableDetailInput();
				addTreeDetailInput();
				// 상세코드 등록버튼 disable, 수정버튼 able
				detailInputUpdateMode();
				
			} else {
				$(this).removeClass('choosed');
				cleanGroupInput();
				enableGroupInput();
				// 상세코드 입력란 비워주기
				cleanDetailInput();
				// 상세코드 입력란 disabled 걸어주기
				disableDetailInput();
			}
		});
	}
	
	function addTreeDetailInput() {
		let $detailCdDiv = $('#' + nowTabId + '-pane .detailCd.choosed');
		let code = $detailCdDiv.attr('data-code');
		let codeName = $detailCdDiv.attr('data-code_name'); 
		let note = $detailCdDiv.attr('data-note');
		
		$('#detailCdInput').val(code);
		$('#detailCdNameInput').val(codeName);
		$('#detailNoteInput').val(note);
		
		let $groupDetailDiv = $detailCdDiv.parents('.groupDetailDiv');
		code = $groupDetailDiv.attr('data-code');
		codeName = $groupDetailDiv.attr('data-code_name');
		
		$('#groupCdInput').val(code);
		$('#groupCdNameInput').val(codeName);
	}
</script>
</body>