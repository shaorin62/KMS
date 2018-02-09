<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript">

$(document).ready(function(){
	$(this).attr("title", "적립포인트 | M-Library");
});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/pt/ptList.do');
	$('#searchForm').submit();
}

</script>

<form id="searchForm">
</form>

<h2 class="mb60">적립포인트</h2>


<div class="bx14 mb50 savePoint">
	<strong class="tit">적립포인트</strong>
	<strong class="point"><span><fmt:formatNumber value="${sumPoint}" groupingUsed="true" /></span>P</strong>
</div>

<form id="searchForm">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
</form>

<!-- 포인트 적립/차감 이력 list -->
<h3 class="count">포인트 적립/차감 이력</h3>

<table class="tableComm table1 tableType1 mb40">
	<caption class="">포인트 적립/차감 이력 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:9%;">
		<col style="width:18%;">
		<col style="width:40%;">
		<col style="width:13%;">
		<col style="width:13%;">
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>적립일</th>
			<th>구분</th>
			<th>게시물 제목</th>
			<th>적립/차감포인트</th>
			<th>적립/차감 유형</th>
		</tr>
	</thead>
	<tbody>		
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><c:out value="${result.POINT_GUBUN_NM}"/></td>
			<td class="tal">
				<c:choose>
					<c:when test="${result.TB eq 'VC'}">
						<a href="/virtual/vcView.do?vcId=<c:out value="${result.BID}"/>"><c:out value="${result.TITLE}"/></a>
					</c:when>
					<c:when test="${result.TB eq 'PT'}">
						<a href="/pt/ptView.do?ptId=<c:out value="${result.BID}"/>"><c:out value="${result.TITLE}"/></a>
					</c:when>	
					<c:when test="${result.TB eq 'TR'}">
						<a href="/tr/trView.do?bdId=<c:out value="${result.BID}"/>"><c:out value="${result.TITLE}"/></a>
					</c:when>		
					<c:when test="${result.TB eq 'HA'}">
						<a href="/ha/haView.do?haId=<c:out value="${result.BID}"/>"><c:out value="${result.TITLE}"/></a>
					</c:when>												
				</c:choose>
			</td>
			<td><fmt:formatNumber value="${result.POINT}" groupingUsed="true" />P</td>
			<td><c:out value="${result.POINT_CLASS_NM}"/></td>
		</tr>	
		</c:forEach>
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="6" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>			
	</tbody>
</table>



<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>
<!-- 포인트 적립/차감 이력 // -->


<%@include file="/WEB-INF/views/include/footer.jsp"%>