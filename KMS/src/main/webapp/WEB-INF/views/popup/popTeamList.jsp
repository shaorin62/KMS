<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/popHeader.jsp"%>

<script>

$(document).ready(function(){

	$(this).attr("title", "팀 선택 popup | M-Library");
	
	$('#searchBtn').click(function(){
		search();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});

function search(){
	$('#searchForm').submit();
}

function select(clientCd, clientNm){
	opener.selectTeam($('#spanId').val(),clientCd, clientNm);
	window.close();
}
</script>

<div class="popHeader">
	<h1>팀 선택</h1>
	<button type="button" class="to-close" onclick="window.close();"><img src="/resources/images/icon_close.png" alt="팝업 닫기"></button>
</div>

<form id="searchForm">
	<input type="hidden" id="spanId" name="spanId" value="<c:out value='${params.spanId}'/>"/>
<div class="tac mt25">
	<strong class="black mr10">팀명</strong>
	<input type="text" name="searchText" style="width:170px" value="<c:out value='${params.searchText}'/>"/>
	<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
</div>
</form>

<!-- 여백 없을시, popContentWrap클래스에 type2 클래스 추가 -->
<div class="popContentWrap" id="contentWrap">
	<div class="tableScoll">
	
		<table class="tableComm table1 tablePop1">
			<caption class="">Client 선택</caption>
			<colgroup>
				<col style="width:100%;">
			</colgroup>
			<thead>
				<tr>
					<th>Client명</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="team" items="${teamList}" varStatus="status">
				<tr>
					<td>
						<input type="hidden" value="<c:out value='${team.CD}'/>"/>
						<a href="javascript:select('${team.CD}','${team.NM}');">
							<c:out value="${team.NM}"/>
						</a>
					</td>
				</tr>
				</c:forEach>
				<c:if test="${empty teamList}">
					<tr>
						<td align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>
			</tbody>		
		</table>

	</div>
</div>

<%@include file="/WEB-INF/views/include/popFooter.jsp"%>