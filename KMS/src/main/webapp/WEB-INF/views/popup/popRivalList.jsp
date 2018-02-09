<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/popHeader.jsp"%>

<script>

$(document).ready(function(){

	$(this).attr("title", "참여사 선택 popup | M-Library");
	
	$('#searchBtn').click(function(){
		search();
	});
	
	$('#selectBtn').click(function(){
		select();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});

function search(){
	$('#searchForm').submit();
}

function select(){
	var rivals = $('input[name="rivalCd"]:checked');

	if(rivals.length==0){
		alert('등록하실 대상을 선택해 주세요.');
		return;
	}
	
	$(rivals).each(function(){
		$(this).attr('rivalNm', $(this).parent().find('input[name="rivalNm"]').val());
	});
	
	opener.selectRival($('#spanId').val(), rivals);
	window.close();
}
</script>

<div class="popHeader">
	<h1>참여사 선택</h1>
	<button type="button" class="to-close" onclick="window.close();"><img src="/resources/images/icon_close.png" alt="팝업 닫기"></button>
</div>

<form id="searchForm">
<div class="tac mt25">
	<strong class="black mr10">참여사</strong>
	<input type="hidden" id="spanId" name="spanId" value="<c:out value='${params.spanId}'/>"/>
	<input type="text" name="searchText" style="width:170px" value="<c:out value='${params.searchText}'/>"/>
	<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
</div>
</form>

<!-- 여백 없을시, popContentWrap클래스에 type2 클래스 추가 -->
<div class="popContentWrap" id="contentWrap">
	<div class="tableScoll">
	
		<table class="tableComm table1 tablePop1">
			<caption class="">문서 열람자 선택</caption>
			<colgroup>
				<col style="width:20%;">
				<col style="width:80%;">
			</colgroup>
			<thead>
				<tr>
					<th></th>
					<th>참여사</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="rival" items="${rivalList}" varStatus="status">
				<tr>
					<td class="tal">
						<div class="inp-check">
							<input type="checkBox" id="rival_<c:out value='${status.index}'/>" name="rivalCd" value="<c:out value='${rival.CD}'/>"/>
							<label for="rival_<c:out value='${status.index}'/>"><span class="box"></span></label>
							<input type="hidden" name="rivalNm" value="<c:out value='${rival.NM}'/>"/>
						</div>
					</td>
					<td>
						<c:out value='${rival.NM}'/>
					</td>
				</tr>
				</c:forEach>
				<c:if test="${empty rivalList}">
					<tr>
						<td colspan="4" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>		
			</tbody>
		</table>

	</div>

	<div class="tac mt40">
		<button type="button" id="selectBtn" class="btn btnMid btnBlue">등록</button>
	</div>
</div>

<%@include file="/WEB-INF/views/include/popFooter.jsp"%>