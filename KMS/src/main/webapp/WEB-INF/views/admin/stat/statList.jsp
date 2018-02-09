<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "통계 조회 | 통계 | M-Library Admin");
	
	$( "#searchStart, #searchEnd" ).datepicker({
	    dateFormat: 'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
	    showOn: 'both',
	    buttonImage: '/resources/images/icon_datepicker.png',
	    buttonText: '날짜입력'
	});
	
	$('#searchStart').val('<c:out value="${params.searchStart}"/>');
	$('#searchEnd').val('<c:out value="${params.searchEnd}"/>');
	
	$('#centerCd').val('<c:out value="${params.centerCd}"/>');
	$('#centerCd').msDropDown().data("dd").set("value", '<c:out value="${params.centerCd}"/>');
	
	onCenterCd();
	
	$('#teamCd').val('<c:out value="${params.teamCd}"/>');
	$('#teamCd').msDropDown().data("dd").set("value", '<c:out value="${params.teamCd}"/>');
	
	onTeamCd();
	
	$('#regId').val('<c:out value="${params.regId}"/>');
	$('#regId').msDropDown().data("dd").set("value", '<c:out value="${params.regId}"/>');
	
	$('#centerCd').change(function(){
		onCenterCd();
	});
	
	$('#teamCd').change(function(){
		onTeamCd();
	});
	
	$('#searchBtn').click(function(){
		$('#pageNo').val('1');
		search();
	});
	
	$('#excelBtn').click(function(){
		excel();
	});
});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/stat/statList.do');
	$('#searchForm').submit();
}

function excel(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/stat/statListExcel.do');
	$('#searchForm').submit();		
}

function onCenterCd(){
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/stat/divList.do",
		cache : false,
		async : false,
		data : {divCd:$('#centerCd').val()},
		dataType : "json",				
		success : function(data) {
			
			$('#teamSpan').html('<select id="teamCd" name="teamCd" title="검색범위선택" style="width:150px;"></select>');
			$('#teamCd').append($('<option value="">전체</option>'));
			
			$(data).each(function(){
				$('#teamCd').append($('<option value="'+this.CD+'">'+this.NM+'</option>'));
			});
			
			$('#teamCd').msDropDown();
			
			onTeamCd();
			
			$('#teamCd').change(function(){
				onTeamCd();
			});
			
		},
		error : function(request, status, errorThrown) {

		}
	});	
	
}

function onTeamCd(){
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/stat/memberList.do",
		cache : false,
		async : false,
		data : {divCd:$('#teamCd').val()},
		dataType : "json",				
		success : function(data) {
			
			$('#regSpan').html('<select id="regId" name="regId" title="검색범위선택" style="width:150px;"></select>');
			$('#regId').append($('<option value="">전체</option>'));
			
			$(data).each(function(){
				$('#regId').append($('<option value="'+this.MID+'">'+this.MEMBER_NM+'</option>'));
			});
			
			$('#regId').msDropDown();
			
		},
		error : function(request, status, errorThrown) {

		}
	});	
	
}
</script>

<h2 class="mb50">통계 조회</h2>


<fieldset>
	<legend>통계 조회</legend>
</fieldset>

<form id="searchForm">
<div class="bx07 tac mb50">
	<strong class="tit01">통계조회</strong>
	<span class="mr40">
		<input type="text" id="searchStart" name="searchStart" style="width:90px;" readOnly>
		~
		<input type="text" id="searchEnd" name="searchEnd" style="width:90px;" readOnly>
	</span>
	
	<select id="centerCd" name="centerCd" title="본부선택" style="width:150px;">
		<option value="">전체</option>
		<c:forEach var="center" items="${centerList}" varStatus="status">
			<option value='<c:out value="${center.CD}"/>'><c:out value="${center.NM}"/></option>
		</c:forEach>
	</select>
	
	<span id="teamSpan">
	<select id="teamCd" name="teamCd" title="검색범위선택" style="width:150px;">
		<option value="">전체</option>
	</select>
	</span>
	
	<span id="regSpan">
	<select id="regId" name="regId" title="검색범위선택" style="width:150px;">
		<option value="">전체</option>
	</select>
	</span>
	
	<button type="button" id="searchBtn" class="btn btnSmall btnBlack">조회</button>
</div>
</form>

<table class="tableComm table1 tableType1 mb15">
	<caption class="">통계조회 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:9%;">
		<col style="width:9%;">
		<col style="width:9%;">
		<col style="width:14%;">
		<col style="width:14%;">
		<col style="width:14%;">
		<col style="width:14%;">
		<col style="width:10%;">
	</colgroup>
	<thead>
		<tr>
			<th scope="col" rowspan="2">NO</th>
			<th scope="col" rowspan="2">본부</th>
			<th scope="col" rowspan="2">팀</th>
			<th scope="col" rowspan="2">구성원</th>
			<th scope="col" colspan="4" class="admTh line">등록구분</th>
			<th scope="col" rowspan="2">합산</th>
		</tr>
		<tr>
			<th scope="col" class="admTh">Potential Client 등록</th>
			<th scope="col" class="admTh">PT Report 등록</th>
			<th scope="col" class="admTh">Trend Report 등록</th>
			<th scope="col" class="admTh">History Archive 등록</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${not empty listTotal}">
		<tr>
			<td><c:out value=""/>합계</td>
			<td><c:out value="${listTotal.CENTER_NM}"/></td>
			<td><c:out value="${listTotal.TEAM_NM}"/></td>
			<td><c:out value="${listTotal.MEMBER_NM}"/></td>
			<td><fmt:formatNumber value="${listTotal.VC_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${listTotal.PT_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${listTotal.TR_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${listTotal.HA_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${listTotal.TOTAL_COUNT}" groupingUsed="true" /></td>
		</tr>			
		</c:if>
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			<td><c:out value="${result.CENTER_NM}"/></td>
			<td><c:out value="${result.TEAM_NM}"/></td>
			<td><c:out value="${result.MEMBER_NM}"/></td>
			<td><fmt:formatNumber value="${result.VC_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${result.PT_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${result.TR_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${result.HA_COUNT}" groupingUsed="true" /></td>
			<td><fmt:formatNumber value="${result.TOTAL_COUNT}" groupingUsed="true" /></td>
		</tr>	
		</c:forEach>
		<c:if test="${empty listPage.list and empty listTotal}">
			<tr>
				<td colspan="9" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>			
	</tbody>
</table>

<button type="button" id="excelBtn" class="btn btn05">결과 다운로드</button>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>


<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
