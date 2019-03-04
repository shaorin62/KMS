<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	
	$(this).attr('title','리스트 | Trend Report | M-Library');
	
	$("#searchStart, #searchEnd").datepicker({
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
})


function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	
	//$('#sendTrCateCd').val($("#trCateCd").val());
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trList.do');
	$('#searchForm').submit();
}

function insert(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trInsert.do');
	$('#searchForm').submit();	
}
function view(bdId){
	$('#bdId').val(bdId);
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trView.do');
	$('#searchForm').submit();
	
}
</script>


<h2 class="mb60">Trend Report</h2>
			<!-- 탭 구성  -->
			<ul class="detailTab mb60">
			<!-- 
				<c:choose>
					<c:when test="${params.trCateCd eq 'TRC_00001' }">
						<li class="on"><a href="/tr/trList.do?trCateCd=TRC_00001">타사자료</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/tr/trList.do?trCateCd=TRC_00001">타사자료</a></li>
					</c:otherwise>
				</c:choose>
			-->
				<c:choose>
					<c:when test="${params.trCateCd eq 'TRC_00002' or  params.trCateCd eq 'TRC_00003'}">
						<li class="on"><a href="/tr/trList.do?trCateCd=TRC_00002">광고/마케팅</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/tr/trList.do?trCateCd=TRC_00002">광고/마케팅</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.trCateCd eq 'TRC_00004' }">
						<li class="on"><a href="/tr/trList.do?trCateCd=TRC_00004">미디어</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/tr/trList.do?trCateCd=TRC_00004">미디어</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.trCateCd eq 'TRC_00006' }">
						<li class="on"><a href="/tr/trList.do?trCateCd=TRC_00006">셀럽파워리포트</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/tr/trList.do?trCateCd=TRC_00006">셀럽파워리포트</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.trCateCd eq 'TRC_00005' }">
						<li class="on"><a href="/tr/trList.do?trCateCd=TRC_00005">기타</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/tr/trList.do?trCateCd=TRC_00005">기타</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
			<!-- 탭 구성 종료 -->

<form id="searchForm">
	<div class="bx01 mb70">
		<div class="search-box">
			<div class="flConts">
				<p class="line-search">
				<!-- 검색날짜 -->
					<span class="w320">
					<strong class="tit01">기간</strong>
						<input type="text" id="searchStart" name="searchStart"  style="width:28%" readonly="readonly">
								~
						<input type="text" id="searchEnd" name="searchEnd"  style="width:28%" readonly="readonly">		
					</span>
		
					<select id="searchType" name="searchType" style="width:150px" >
						<option value="">전체</option>
						<option value="title">제목</option>
						<option value="regNm">작성자</option>
					</select>				 
					<input type="text" id="searchText" name="searchText"  onKeyDown="if(event.keyCode == 13){$('#pageNo').val('1'); search();}"/>
					<input type="hidden" id="orderBy" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
					<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
					<input type="hidden" id="bdId" name="bdId" value=""/>
					<input type="hidden" id="sendTrCateCd" name="sendTrCateCd" value=""/>
					<input type="hidden" id="trCateCd" name="trCateCd" value="${params.trCateCd}"/>
					<button type="button" id="searchBtn" class="btn btnSmall btnBlack" >검색</button>
					<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
					
					
				</p>
				<!--  
				<p class="">	
					<span class="w320">
						<strong class="tit01">카테고리</strong>
						<select id="trCateCd" name="trCateCd" style="width:150px">
							<option value="">전체</option>
							<c:forEach var="category" items="${trCateCdList}" varStatus="status">
							<c:if test="${params.sendTrCateCd == category.CD}">
								<option value='<c:out value="${category.CD}"/>' selected><c:out value="${category.NM}"/></option>
							</c:if>	
							<c:if test="${params.sendTrCateCd != category.CD}">
							<option value='<c:out value="${category.CD}"/>' ><c:out value="${category.NM}"/></option>
							</c:if>	
							</c:forEach>
							
						</select>
						</span>
				</p>
				-->		
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
	<caption class="">Trend Report</caption>
		<colgroup>
			<col style="width:5%;">
			<col style="width:35%;">
			<col style="width:10%;" span="6">
		</colgroup>
		<thead>
			<tr>
				<th>NO</th>
				<th>제목</th>
				<th>카테고리</th>
				<th>작성자</th>
				<th>작성팀</th>
				<th>작성일</th>
				<th>조회</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="result" items="${listPage.list}" varStatus="status">
			<tr>
				<c:if test="${result.TOP_YN ne 'Y'}">
				<td><c:out value="${listPage.totalCount - result.RNUM +1}"/></td>
				</c:if>
				<c:if test="${result.TOP_YN eq 'Y'}">
				<td  class="red"><c:out value="공통"/></td>
				</c:if>
				
				<td class="tal"><a href="javascript:view('${result.BD_ID}')"><c:out value="${result.TITLE}"/></a></td>
				
				<c:if test="${result.TOP_YN eq 'Y'}">
				<td class="red"><c:out value="${result.TR_CATE_NM}"/></td>
				</c:if>
				<c:if test="${result.TOP_YN ne 'Y'}">
				<td ><c:out value="${result.TR_CATE_NM}"/></td>
				</c:if>
				<td><c:out value="${result.MEMBER_NM}"/></td>
				<td><c:out value="${result.TEAM_NM}"/></td>
				<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
				<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
			</tr>
			</c:forEach>
			<c:if test="${empty listPage.list}">
				<tr>
					<td colspan="6" align="center">검색 결과가 없습니다.</td>
				</tr>
			</c:if>
	</tbody>
</table>

<div class="paging">	<c:out value="${listPage.pageString}" escapeXml="false" /></div>

<div class="tac mb30">
	<button type="button" id="insertBtn" class="btn btnMid btnBlue" style="width:150px;">등록</button>
</div>

<%@include file="/WEB-INF/views/include/footer.jsp"%>