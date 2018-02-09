<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "사용자 포인트 조회 | 포인트 관리 | M-Library Admin");
	
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
	
	$('#searchType').val('<c:out value="${params.searchType}"/>');
	$('#searchType').msDropDown().data("dd").set("value", '<c:out value="${params.searchType}"/>');
	
	$('#searchText').val('<c:out value="${params.searchText}"/>');
	
	$('#searchSumType').val('<c:out value="${params.searchSumType}"/>');
	$('#searchSumType').msDropDown().data("dd").set("value", '<c:out value="${params.searchSumType}"/>');
	
	$('#searchSumType').change(function(){
		onChangeSumType();
	});	
	
	onChangeSumType();
	
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
	$('#searchForm').prop('action','/admin/point/pointMemberList.do');
	$('#searchForm').submit();
}

function excel(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/point/pointMemberListExcel.do');
	$('#searchForm').submit();		
}

function view(mid){
	location.href = '/admin/point/pointViewList.do?mid='+mid;	
}

function onChangeSumType(){
	// 누적포인트
	if($('#searchSumType').val()=='acc'){
		$('#searchStart').removeAttr('disabled');
		$('#searchEnd').removeAttr('disabled');	
	}
	// 가용포인트
	else{
		$('#searchStart').val('');
		$('#searchStart').attr('disabled','disabled');
		$('#searchEnd').val('');
		$('#searchEnd').attr('disabled','disabled');		
	}	
}
</script>

<h2 class="mb50">사용자 포인트 조회</h2>

<fieldset>
	<legend>사용자 포인트 조회</legend>
</fieldset>

<form id="searchForm">
<div class="bx07 tac mb50">
	<strong class="tit01">사용자 조회</strong>
	<select id="searchSumType" name="searchSumType" title="검색범위선택" style="width:110px;">
		<option value="">가용포인트</option>
		<option value="acc">누적포인트</option>
	</select>
	<span class="mr40">
		<input type="text" id="searchStart" name="searchStart" style="width:90px;" readOnly>
		~
		<input type="text" id="searchEnd" name="searchEnd" style="width:90px;" readOnly>
	</span>
	
	<select id="searchType" name="searchType" title="검색범위선택" style="width:90px;">
		<option value="">전체</option>
		<option value="memberNm">이름</option>
		<option value="mid">사번</option>
	</select>
	<input type="text" id="searchText" name="searchText" title="검색어 입력" style="width:200px;" onKeyDown="if(event.keyCode == 13){goPage('1');}">
	<button type="button" id="searchBtn" class="btn btnSmall btnBlack">조회</button>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>

</div>
</form>

<table class="tableComm table1 tableType1 mb15">
	<caption class="">통계조회 리스트</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:17%;" span="5">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">NO</th>
			<th scope="col">이름</th>
			<th scope="col">본부</th>
			<th scope="col">팀</th>
			<th scope="col">사번</th>
			<th scope="col">적립/차감 포인트</th>
		</tr>
	</thead>
	<tbody>		
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			<td><a href="javascript:view('<c:out value="${result.MID}"/>');"><c:out value="${result.MEMBER_NM}"/></a></td>
			<td><c:out value="${result.CENTER_NM}"/></td>
			<td><c:out value="${result.TEAM_NM}"/></td>
			<td><a href="javascript:view('<c:out value="${result.MID}"/>');"><c:out value="${result.MID}"/></a></td>
			<td><span><fmt:formatNumber value="${result.SUM_POINT}" groupingUsed="true" /></span> <span>P</span></td>
		</tr>
		</c:forEach>	
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="6" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>				
	</tbody>
</table>
<p class="tar mt10">※ 이름 또는 사번을 클릭 하시면 상세페이지로 이동이 가능합니다.</p>

<button type="button" id="excelBtn" class="btn btn05">엑셀 다운로드</button>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
