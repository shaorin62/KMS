<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript">

$(document).ready(function(){
	$(this).attr("title", "리스트 | 내가 쓴 글 | M-Library");
});

function more(action){
	$('#searchForm').attr('action',action);
	$('#searchForm').submit();
}

function view(table, value){
	
	var name = '';
	var action = '';
	switch(table){
		case 'vc': name="vcId"; action='/virtual/vcView.do'; break;
		case 'pt': name="ptId"; action='/pt/ptView.do'; break;
		case 'tr': name="bdId"; action='/tr/trView.do'; break;
		case 'ha': name="haId"; action='/ha/haView.do'; break;
	}
	
	$('#searchForm').attr('action',action);
	$('#searchForm').append(
		$("<input type='hidden' name='"+name+"' value='"+value+"'/>")
	);
	$('#searchForm').submit();
}
</script>

<form id="searchForm">
	<input type="hidden" name="searchRegId" value="<c:out value="${loginVO.mid}"/>"/>
</form>

<h2 class="mb60">내가 쓴 글</h2>

<!-- Potential Client list -->
<div class="listinfo">
	<h3 class="count">Potential Client (<fmt:formatNumber value="${vcPage.totalCount}" groupingUsed="true" />건)</h3>
	<p class="sort"><a href="javascript:more('/virtual/vcList.do');" class="btn btnMiny">+ More</a></p>
</div>
<table class="tableComm table1 tableType1 mb40">
	<caption class="">Potential Client 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:45%;">
		<col style="width:12%;">
		<col style="width:12%;">
		<col style="width:12%;">
		<col style="width:12%;">
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>제목</th>
			<th>업종</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${vcPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${vcPage.totalCount - result.RNUM + 1}"/></td>
			<td class="tal"><a href="javascript:view('vc','${result.VC_ID}');"><c:out value="${result.TITLE}"/></a></td>
			<td><c:out value="${result.BIZ_NM}"/></td>
			<td><c:out value="${result.REG_NM}"/></td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
		</tr>	
		</c:forEach>
		<c:if test="${empty vcPage.list}">
			<tr>
				<td colspan="6" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>
<!-- Potential Client list // -->


<!-- PT Report list -->
<div class="listinfo">
	<h3 class="count">PT Report (<fmt:formatNumber value="${ptPage.totalCount}" groupingUsed="true" />건)</h3>
	<p class="sort"><a href="javascript:more('/pt/ptList.do');" class="btn btnMiny">+ More</a></p>
</div>
<table class="tableComm table1 tableType1 mb40">
	<caption class="">PT Report 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:34%;">
		<col style="width:10%;">
		<col style="width:10%;">
		<col style="width:11%;">
		<col style="width:10%;">
		<col style="width:10%;">
		<col style="width:8%;">
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>제목</th>
			<th>업종</th>
			<th>Client명</th>
			<th>PT결과</th>
			<th>작성상태</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${ptPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${ptPage.totalCount - result.RNUM + 1}"/></td>
			<td class="tal"><a href="javascript:view('pt','${result.PT_ID}');"><c:out value="${result.TITLE}"/></a></td>
			<td><c:out value="${result.BIZ_NM}"/></td>
			<td><c:out value="${result.CLIENT_NM}"/></td>
			<td><c:out value="${result.PT_RESULT_NM}"/></td>
			<td>
				<c:choose>
					<c:when test="${result.SUBMIT_YN eq 'Y'}">제출</c:when>
					<c:otherwise>임시저장</c:otherwise>
				</c:choose>
			</td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
		</tr>	
		</c:forEach>
		<c:if test="${empty ptPage.list}">
			<tr>
				<td colspan="8" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>		
	</tbody>
</table>
<!-- PT Report list // -->


<!-- Trend Report list -->
<div class="listinfo">
	<h3 class="count">Trend Report (<fmt:formatNumber value="${trPage.totalCount}" groupingUsed="true" />건)</h3>
	<p class="sort"><a href="javascript:more('/tr/trList.do');" class="btn btnMiny">+ More</a></p>
</div>
<table class="tableComm table1 tableType1 mb40">
	<caption class="">Trend Report 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:39%;">
		<col style="width:11%;">
		<col style="width:11%;">
		<col style="width:12%;">
		<col style="width:11%;">
		<col style="width:9%;">
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
		<c:forEach var="result" items="${trPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${trPage.totalCount - result.RNUM +1}"/></td>
			<td class="tal"><a href="javascript:view('tr','${result.BD_ID}')"><c:out value="${result.TITLE}"/></a></td>
			<td><c:out value="${result.TR_CATE_NM}"/></td>
			<td><c:out value="${result.MEMBER_NM}"/></td>
			<td><c:out value="${result.TEAM_NM}"/></td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
		</tr>
		</c:forEach>
		<c:if test="${empty trPage.list}">
			<tr>
				<td colspan="7" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>		
	</tbody>	
</table>


<!-- History Archive list -->
<div class="listinfo">
	<h3 class="count">History Archive (<fmt:formatNumber value="${haPage.totalCount}" groupingUsed="true" />건)</h3>
	<p class="sort"><a href="javascript:more('/ha/haList.do');" class="btn btnMiny">+ More</a></p>
</div>
<table class="tableComm table1 tableType1 mb40">
	<caption class="">History Archive 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:45%;">
		<col style="width:12%;">
		<col style="width:12%;">
		<col style="width:12%;">
		<col style="width:12%;">
	</colgroup>
	<thead>
		<tr>
			<th>NO</th>
			<th>캠페인명</th>
			<th>팀</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${haPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${haPage.totalCount - result.RNUM +1}"/></td>
			<td class="tal"><a href="javascript:view('ha','${result.HA_ID}')"><c:out value="${result.TITLE}"/></a></td>
			<td><c:out value="${result.TEAM_NM}"/></td>
			<td><c:out value="${result.MEMBER_NM}"/></td>
			<td><fmt:formatDate value="${result.UPD_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
		</tr>
		</c:forEach>
		<c:if test="${empty haPage.list}">
			<tr>
				<td colspan="6" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>
<!-- History Archive list // -->

<div class="tac mb30">
	<button type="button" class="btn btnMid btnBlue" style="width:150px;" onclick="javascript:location.href='/main/main.do;'">메인</button>
</div>

<%@include file="/WEB-INF/views/include/footer.jsp"%>