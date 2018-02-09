<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "리스트 | Potential Client | M-Library");
	
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
	    changeYear: true,
	    changeMonth: true,
	    showOn: 'both',
	    buttonImage: '/resources/images/icon_datepicker.png',
	    buttonText: '날짜입력'
	});
	
	$('#searchStart').val('<c:out value="${params.searchStart}"/>');
	$('#searchEnd').val('<c:out value="${params.searchEnd}"/>');
	
	$('#searchBizCd').val('<c:out value="${params.searchBizCd}"/>');
	$('#searchBizCd').msDropDown().data("dd").set("value", '<c:out value="${params.searchBizCd}"/>');
	
	$('#searchContactCd').val('<c:out value="${params.searchContactCd}"/>');
	$('#searchContactCd').msDropDown().data("dd").set("value", '<c:out value="${params.searchContactCd}"/>');
	
	$('#searchType').val('<c:out value="${params.searchType}"/>');
	$('#searchType').msDropDown().data("dd").set("value", '<c:out value="${params.searchType}"/>');
	
	$('#searchText').val('<c:out value="${params.searchText}"/>');
	
	if($('#orderBy').val()=='hit'){
		$('#hitBtn').attr('class','on');
	}
	else{
		$('#regDtmBtn').attr('class','on');
	}
	
	$('#regDtmBtn').click(function(){
		$('#orderBy').val('regDtm');
		$('#pageNo').val('1');
		search();
	});
	
	$('#hitBtn').click(function(){
		$('#orderBy').val('hit');
		$('#pageNo').val('1');
		search();
	});
	
	$('#searchBtn').click(function(){
		$('#pageNo').val('1');
		search();
	});
	
	$('#insertBtn').click(function(){
		insert();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/virtual/vcList.do');
	$('#searchForm').submit();
}

function excel(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/virtual/vcListExcel.do');
	$('#searchForm').submit();		
}

function view(vcId){
	$('#vcId').val(vcId);
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/virtual/vcView.do');
	$('#searchForm').submit();		
}

function insert(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/virtual/vcInsert.do');
	$('#searchForm').submit();	
}
</script>

<h2 class="mb60">Potential Client</h2>

<!-- search box -->
<form id="searchForm">
<div class="bx01 mb70">
	<div class="search-box">
		<div class="flConts">
			<p class="line-search">
				<span class="w320">
					<strong class="tit01">기간</strong>
					<input type="text" id="searchStart" name="searchStart" style="width:88px" readOnly/>
					~
					<input type="text" id="searchEnd" name="searchEnd" style="width:88px" readOnly/>
				</span>

				<select id="searchType" name="searchType" title="검색범위선택" style="width:80px;">
					<option value="">전체</option>
					<option value="title">제목</option>
					<option value="regNm">작성자</option>
				</select>				 
				<input type="text" id="searchText" name="searchText" style="width:153px" onKeyDown="if(event.keyCode == 13){goPage('1');}"/>
				<input type="hidden" id="orderBy" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
				<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
				<input type="hidden" id="vcId" name="vcId" value=""/>
				<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
				<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
			</p>

			<p class="">
				<span class="w320">
					<strong class="tit01">업종</strong>
					<select id="searchBizCd" name="searchBizCd" title="검색범위선택" style="width:200px;">
						<option value="">전체</option>
						<c:forEach var="biz" items="${bizList}" varStatus="status">
							<option value='<c:out value="${biz.CD}"/>'><c:out value="${biz.NM}"/></option>
						</c:forEach>
					</select>					
				</span>

				<strong class="tit01">Contact 경로</strong>
				<select id="searchContactCd" name="searchContactCd" title="검색범위선택" style="width:200px;">
					<option value="">전체</option>
					<c:forEach var="contact" items="${contactPathList}" varStatus="status">
						<option value='<c:out value="${contact.CD}"/>'><c:out value="${contact.NM}"/></option>
					</c:forEach>			
				</select>
			</p>
		</div>
	</div>
</div>
</form>
<!-- search box // -->

<!-- list -->
<div class="listinfo">
	<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
	<p class="sort">
		<button type="button" id="regDtmBtn">최신순</button> |
		<button type="button" id="hitBtn">조회순</button>
	</p>
</div>

<table class="tableComm table1 tableType1 mb20">
	<caption class="">Potential Client 리스트</caption>
	<colgroup>
		<col style="width:5%;">
		<col style="width:35%;">
		<!-- <col style="width:10%;" span="6"> -->
		<col style="width:10%;">
		<col style="width:10%;">
		<col style="width:14%;">
		<col style="width:10%;">
		<col style="width:8%;">
		<col style="width:5%;">
		
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>제목</th>
			<th>업종</th>
			<th>Contact<br>경로</th>
			<th>작성팀</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<c:if test="${result.TOP_YN ne 'Y'}">
				<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			</c:if>
			<c:if test="${result.TOP_YN eq 'Y'}">
				<td  class="red"><c:out value="공통"/></td>
			</c:if>
			<td class="tal"><a href="javascript:view('${result.VC_ID}')"><c:out value="${result.TITLE}"/></a></td>
			<td><c:out value="${result.BIZ_NM}"/></td>
			<td><c:out value="${result.CONTACT_PATH_NM}"/></td>
			<td><c:out value="${result.REG_TEAM_NM}"/></td>
			<td><c:out value="${result.REG_NM}"/></td>
			<td class="thin"><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td class="thin"><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
		</tr>	
		</c:forEach>
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="8" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>

<a href="javascript:excel();" class="btn btn05">리스트 다운로드</a>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>

<div class="tac mb30">
	<button type="button" id="insertBtn" class="btn btnMid btnBlue" style="width:150px;">등록</button>
</div>

<%@include file="/WEB-INF/views/include/footer.jsp"%>