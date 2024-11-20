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
			<h1 class="mt-4">메뉴 통계</h1>
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
				<h3>최근 3년간 연도별 통계</h3>
				<div class="card-body">
					<table id="yearStatistics" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>메뉴명</th>
								<th>2021년</th>
								<th>2022년</th>
								<th>2023년</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
				
				<h3>월별 통계</h3>
				<div>
					<select id="selectYear"></select>
				</div>
				<div class="card-body">
					<table id="monthStatistics" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>메뉴명</th>
								<th>1월</th>
								<th>2월</th>
								<th>3월</th>
								<th>4월</th>
								<th>5월</th>
								<th>6월</th>
								<th>7월</th>
								<th>8월</th>
								<th>9월</th>
								<th>10월</th>
								<th>11월</th>
								<th>12월</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
				
				<h3>일별 통계</h3>
				<div>
					<input type="month" id="inputMonth">
				</div>
				<div class="card-body">
					<table id="dayStatistics" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>메뉴명</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
				</div>
				
				<h3>시간대별 통계</h3>
				<div>
					<input type="DATE" id="inputDate">
				</div>
				<div class="card-body">
					<table id="hourStatistics" class="table table-hover table-striped">
						<thead>
							<tr style="width: 100%">
								<th>메뉴명</th>
								<th>00시</th>
								<th>01시</th>
								<th>02시</th>
								<th>03시</th>
								<th>04시</th>
								<th>05시</th>
								<th>06시</th>
								<th>07시</th>
								<th>08시</th>
								<th>09시</th>
								<th>10시</th>
								<th>11시</th>
								<th>12시</th>
								<th>13시</th>
								<th>14시</th>
								<th>15시</th>
								<th>16시</th>
								<th>17시</th>
								<th>18시</th>
								<th>19시</th>
								<th>20시</th>
								<th>21시</th>
								<th>22시</th>
								<th>23시</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>
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
			
			// 최근 3년간 연도별 통계
			years();
			
			// 월별통계의 년도 select태그 만들고 오늘 값 넣어서 통계내기
			selectYear();
			month(year);
			$('#selectYear').on('change', function() {
				month($(event.target).val());
			})
			
			// 일별통계
			let yearMonth = date.toISOString().slice(0, 7);
			$('#inputMonth').val(yearMonth);
			day($('#inputMonth').val());
			$('#inputMonth').on('change', function() {
				day($(event.target).val());
			})
			
			// 시간대별 통계 
			let yearMonthDay = date.toISOString().slice(0, 10);
			$('#inputDate').val(yearMonthDay);
			hour($('#inputDate').val());
			$('#inputDate').on('change', function() {
				hour($(event.target).val());
			});
		});
		
		function years() {
			$('#yearStatistics tBody').empty();
			
			$.ajax({
		    	url: '/menu/getYearStatistics.do',
				type: 'post',
				dataType: 'json',
				async: false,
		        success: function(data) {
		        	let $tBody = $('#yearStatistics tbody');
		        	$(data).each(function(idx, item) {
		        		let $tr = $('<tr>');
		        		
		        		for (let prop in item) {
		        			let $td = $('<td/>');
		        			$td.text(item[prop]);
		        			$tr.append($td);
		        		}
		        		
		        		$tBody.append($tr);
		        	});
		        },
				error: function(error) {
					console.log(error);
				}
		    });
		}
		
		
		// 연도 select태그
		var date = new Date();
		var year = date.getFullYear();
		function selectYear() {
			for (let i = (year - 9); i < (year + 1); i++) {
				let $option = $('<option/>').text(i + '년').val(i);
				$('#selectYear').append($option)
			}
			
			$('#selectYear').val(year);
		}
		
			
		
		function month(year) {
			$('#monthStatistics tBody').empty();
			
			$.ajax({
		    	url: '/menu/getMonthStatistics.do',
				type: 'post',
				data: {'access_year': year.toString()},
				dataType: 'json',
				async: false,
		        success: function(data) {
		        	let $tBody = $('#monthStatistics tbody');
		        	$(data).each(function(idx, item) {
		        		let $tr = $('<tr>');
		        		
		        		for (let prop in item) {
		        			let $td = $('<td/>');
		        			$td.text(item[prop]);
		        			$tr.append($td);
		        			
		        		}
		        		
		        		$tBody.append($tr);
		        	});
		        },
				error: function(error) {
					console.log(error);
				}
		    })
		}
		
		
		function day(yearMonth) {
			$('#dayStatistics thead tr').empty();
			$('#dayStatistics tBody').empty();
			
			let year = yearMonth.substring(0,4);
			let month = yearMonth.substring(5);
			let data = {
				'access_dt': yearMonth,
				'access_year': year,
				'access_month': month 
			};

			
			$.ajax({
		    	url: '/menu/getDayStatistics.do',
				type: 'post',
				data: data,
				dataType: 'json',
				async: false,
		        success: function(data) {
		        	// 메뉴명 th 넣기
					$('#dayStatistics thead tr').append($('<th/>').text('메뉴명'));
					let targetDate = '';	// 통계 월
					let dayCnt = '';		// 통계 월의 일수
					
					// 통계 월의 일수 구해서 그만큼 th에 일수 넣기
					if (month.substring(0, 1) == '0') {
						targetDate = new Date(Number(year), Number(month.substring(1)), 0);
						dayCnt = targetDate.getDate();
					} else {
						targetDate = new Date(Number(year), Number(month) - 1, 0);
						dayCnt = targetDate.getDate();
					}
					
					for (let i = 0; i < dayCnt; i++) {
						let th = $('<th/>').text((i + 1) + '일');
						$('#dayStatistics thead tr').append(th);
					}

		        	let $tBody = $('#dayStatistics tbody');

		        	$(data).each(function(idx, item) {
		        		let $tr = $('<tr>');
		        		
		        		for (let prop in item) {
		        			let $td = $('<td/>');
		        			$td.text(item[prop]);
		        			$tr.append($td);
		        			
							if (prop == ('day' + dayCnt)) {
								break;
							}
		        		}
		        		
		        		if ($tr.find('td:first-child').text() != '') {
			        		$tBody.append($tr);
		        		}
		        	});
		        },
				error: function(error) {
					console.log(error);
				}
		    })
		}
		
		function hour(yearMonthDay) {
			$('#hourStatistics tBody').empty();
			
			let year = yearMonthDay.substring(0,4);
			let month = yearMonthDay.substring(5,7);
			let day = yearMonthDay.substring(8);
			let data = {
				'access_dt': yearMonthDay,
				'access_year': year,
				'access_month': month,
				'access_day': day
			};
			
			$.ajax({
		    	url: '/menu/getHourStatistics.do',
				type: 'post',
				data: data,
				dataType: 'json',
				async: false,
		        success: function(data) {
		        	let $tBody = $('#hourStatistics tbody');

		        	$(data).each(function(idx, item) {
		        		let $tr = $('<tr>');
		        		
		        		for (let prop in item) {
		        			let $td = $('<td/>');
		        			$td.text(item[prop]);
		        			$tr.append($td);
		        		}
		        		
		        		$tBody.append($tr);
		        	});
		        },
				error: function(error) {
					console.log(error);
				}
		    })
		}
		
	</script>
</body>
</html>