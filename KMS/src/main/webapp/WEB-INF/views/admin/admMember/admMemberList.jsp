<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$(this).attr('title','리스트 | ADMIN 사용자 관리 | M-Library Admin');

	$('#insertBtn').click(function(){
		insert();
	});
	
	

});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/admMemberList.do');
	$('#searchForm').submit();
}
function insert(){
	
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/admMemberInsert.do');
	$('#searchForm').submit();	
}
function view(mid){
	$('#mid').val(mid);
	
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/admMemberUpdate.do');
	$('#searchForm').submit();
}
</script>

<h2 class="mb50">ADMIN 사용자 관리</h2>

<form  name="searchForm" id="searchForm">
	
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
	<input type="hidden" id="mid" name="mid" value=""/>
	
	<fieldset>
		<legend>ADMIN 사용자 관리</legend>
	</fieldset>				
	
</form>

	<div class="listinfo">
		<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
	</div>
	<table class="tableComm table1 tableType1 mb50">
		<caption class="">ADMIN 사용자 관리 리스트</caption>
		<colgroup>
			<col style="width:20%;">
			<col style="width:20%;">
			<col style="width:20%;">
			<col style="width:20%;">
			<col style="width:20%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">이메일</th>
				<th scope="col">사용여부</th>
				<th scope="col">등록일</th>
			</tr>
		</thead>
		<tbody>		
			<c:forEach var="result" items="${listPage.list}" varStatus="status">
				<tr>
					<td class="tac"><a href="javascript:view('${result.MID}')"><c:out value="${result.MID }"/></a>	</td>
					<td class="tac"><a href="javascript:view('${result.MID}')"><c:out value="${result.MEMBER_NM }"/></a>	</td>
					<td class="tac"><c:out value="${result.EMAIL }"/></td>
					<td class="tac"><c:out value="${result.LOGIN_ABLE_YN }"/></td>
					<td class="tac"><fmt:formatDate  value="${result.REG_DTM }" pattern="yyyy.MM.dd"/></td>
					
				</tr>	
			</c:forEach>
			<c:if test="${empty listPage.list}">
				<tr>
					<td colspan="6" align="center">검색 결과가 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>
	<%-- <div class="paging">
		<c:out value="${listPage.pageString}" escapeXml="false" />
	</div> --%>

<div class="tac mb30">
	<button type="button" id="insertBtn" class="btn btnMid btnBlue" style="width:150px;">등록</button>
</div>


<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
