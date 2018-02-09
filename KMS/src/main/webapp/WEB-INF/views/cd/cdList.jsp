<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript">

$(document).ready(function(){
	$(this).attr('title','리스트 | Credential | M-Library');
	
	$("#searchStart").datepicker({
        altFormat:  "yy-mm-dd",
        altField:   "#searchStart", // alt
        changeYear: true,
        yearRange:  "2010:2023",
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNamesMin:   ["일", "월", "화", "수", "목", "금", "토",]

    });
	
	$("#searchEnd").datepicker({
        altFormat:  "yy-mm-dd",
        altField:   "#searchEnd", // alt
        changeYear: true,
        yearRange:  "2010:2023",
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNamesMin:   ["일", "월", "화", "수", "목", "금", "토",]

    });		
	$('#updDtmBtn').click(function(){
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
	$('#sendTrCateCd').val($("#trCateCd").val());
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/cd/cdList.do');
	$('#searchForm').submit();
}

function insert(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/cd/cdInsert.do');
	$('#searchForm').submit();	
}
function view(bdId){
	$('#bdId').val(bdId);
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/cd/cdView.do');
	$('#searchForm').submit();
	
}
</script>
 
<h2 class="mb60">Credential</h2>
			<!-- search box -->
	<form id="searchForm">
		<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
		<input type="hidden" id="bdId" name="bdId" value=""/>
		<input type="hidden" id="sendTrCateCd" name="sendTrCateCd" value=""/>
				
		<div class="bx01 mb70">
			<div class="search-box">
				<strong class="tit01">업종</strong>
				<select title="검색범위선택" style="width:150px;" id="trCateCd" name="trCateCd"  >
					<c:choose>
						<c:when test="${'BIZ_00000' == params.sendTrCateCd}">
						<option value="">전체</option>
						<option value="BIZ_00000" selected>공통</option>
							<c:forEach var="category" items="${trCateCdList}" varStatus="status">
									<option value='<c:out value="${category.CD}"/>' ><c:out value="${category.NM}"/></option>
							</c:forEach>
						</c:when>
						<c:otherwise>
						<option value="">전체</option>
						<option value="BIZ_00000" >공통</option>
							<c:forEach var="category" items="${trCateCdList}" varStatus="status">
								<c:if test="${params.sendTrCateCd == category.CD}">
									<option value='<c:out value="${category.CD}"/>' selected><c:out value="${category.NM}"/></option>
								</c:if>	
								<c:if test="${params.sendTrCateCd != category.CD}">
									<option value='<c:out value="${category.CD}"/>' ><c:out value="${category.NM}"/></option>
								</c:if>	
							</c:forEach>	
						</c:otherwise>
					</c:choose>
				</select>
				<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
			</div>	
		</div>
	</form>		

<div class="listinfo">
	<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
</div>

<table class="tableComm table1 tableType1 mb20">
	<caption class="">Credential</caption>
	<colgroup>
		<col style="width:9%;">
		<col style="width:16%;">
		<col style="width:60%;">
		<col style="width:15%;">
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>업종</th>
			<th>제목</th>
			<th>작성일</th>
		</tr>
	</thead>
	
	<tbody>
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
			<tr>
				<td><c:out value="${listPage.totalCount - result.RNUM +1}"/></td>
				<c:choose>
				
				<c:when test="${result.TR_CATE_CD eq 'BIZ_00000'}">
					<td class="red"><c:out value="공통"/></td>
				</c:when>
				
				 <c:otherwise>
					<td><c:out value="${result.TR_CATE_NM}"/></td>
				</c:otherwise>
				
				</c:choose>
				
				<td class="tal"><a href="javascript:view('${result.BD_ID}')"><c:out value="${result.TITLE}"/></a></td>						
				<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			</tr>
		</c:forEach>
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="6" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>
			<!-- list // -->
<div class="paging">	<c:out value="${listPage.pageString}" escapeXml="false" /></div>
		<c:if test="${'Y' eq params.crAppointYn}">
			<div class="tac mb30">
				<button type="button" id="insertBtn" class="btn btnMid btnBlue" style="width:150px;">등록</button>
			</div>
		</c:if>

<%@include file="/WEB-INF/views/include/footer.jsp"%>