<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "다운로드이력 상세 | 다운로드 이력 관리 | M-Library Admin");
	
	$('#searchBtn').click(function(){
		$('#pageNo').val('1');
		search();
	});
	
});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/download/downloadViewList.do');
	$('#searchForm').submit();
}

</script>

<h2 class="mb50">다운로드이력</h2>

<form id="searchForm">
	<input type="hidden" id="mid" name="mid" value="<c:out value='${params.mid}'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
</form>

<fieldset>
	<legend>다운로드이력</legend>
</fieldset>

<div class="bx07 mb50">
	<ul class="admList admList01">
		<li class="div tac">
			<strong class="tit03">구성원정보</strong>
			<strong class="tx01"><span><c:out value="${listPage.list[0].MEMBER_NM}"/></span>(<span><c:out value="${listPage.list[0].REG_ID}"/></span>)</strong>
		</li>
		<li class="tac">
			<strong class="tit03">다운로드 건수</strong>
			<strong class="tx01 red"><span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span> <span>건</span></strong>
		</li>
	</ul>
</div>

<div class="listinfo">
	<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
</div>

<table class="tableComm table1 tableType1 mb15">
	<caption class="">다운로드이력 리스트</caption>
	<colgroup>
		<col style="width:7%;">
		<col style="width:10%;">
		<col style="width:28%;">
		<col style="width:35%;">
		<col style="width:10%;">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">NO</th>
			<th scope="col">메뉴 구분</th>
			<th scope="col">게시물 제목</th>
			<th scope="col">파일명</th>
			<th scope="col">다운로드일</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			<td><c:out value="${result.BNM}"/></td>
			<td class=""><c:out value="${result.TITLE}"/></td>
			<td>
				<p class="file">
					<a href="/upload/${result.FILE_PATH}"><c:out value="${result.ORG_FILE_NM}"/></a>
				</p>
			</td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
		</tr>
		</c:forEach>
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="7" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>	
	</tbody>
</table>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>


<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
