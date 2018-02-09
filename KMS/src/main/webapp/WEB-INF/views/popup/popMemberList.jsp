<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/popHeader.jsp"%>

<script>

$(document).ready(function(){

	$(this).attr("title", "문서 열람자 선택 popup | M-Library");
	
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
	var mids = $('input[name="mid"]:checked');

	if(mids.length==0){
		alert('등록하실 대상을 선택해 주세요.');
		return;
	}
	
	$(mids).each(function(){
		$(this).attr('memberNm', $(this).parent().find('input[name="memberNm"]').val());
	});
	
	opener.selectMember($('#spanId').val(), mids);
	window.close();
}
</script>

<div class="popHeader">
	<h1>문서 열람자 선택</h1>
	<button type="button" class="to-close" onclick="window.close();"><img src="/resources/images/icon_close.png" alt="팝업 닫기"></button>
</div>

<form id="searchForm">
<div class="tac mt25">
	<strong class="black mr10">이름</strong>
	<input type="hidden" name="posLevel" value="<c:out value='${params.posLevel}'/>"/>
	<input type="hidden" id="spanId" name="spanId" value="<c:out value='${params.spanId}'/>"/>	
	<input type="text" name="searchText" style="width:170px" value="<c:out value='${params.searchText}'/>">
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
				<col style="width:20%;">
				<col style="width:20%;">
				<col style="width:40%;">
			</colgroup>
			<thead>
				<tr>
					<th></th>
					<th>직급</th>
					<th>이름</th>
					<th>소속</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="member" items="${memberList}" varStatus="status">
				<tr>
					<td class="tal">
						<div class="inp-check">
							<input type="checkBox" id="mid_<c:out value='${status.index}'/>" name="mid" value="<c:out value="${member.MID}"/>"/>
							<label for="mid_<c:out value='${status.index}'/>"><span class="box"></span></label>
							<input type="hidden" name="memberNm" value="<c:out value="${member.MEMBER_NM}"/>"/>
						</div>
					</td>
					<td><c:out value="${member.POS_NM}"/></td>
					<td><c:out value="${member.MEMBER_NM}"/></td>
					<td><c:out value="${member.DIV_NM}"/></td>
				</tr>
				</c:forEach>
				<c:if test="${empty memberList}">
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