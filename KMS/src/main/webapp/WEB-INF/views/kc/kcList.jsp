<%@ page language="java" session="true"
	contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript">

	$(document).ready(function() {
		$(this).attr('title','리스트 | 지식채널 | M-Library');
		
		$('#insertBtn').click(function() {
			insert();
		});
	})
	function goPage(pageNo) {
		$('#pageNo').val(pageNo);
		search();
	}
	function search() {
		$('#searchForm').prop('method', 'GET');
		$('#searchForm').prop('action', '/kc/kcList.do');
		$('#searchForm').submit();
	}

	function insert() {
		$('#searchForm').prop('method', 'GET');
		$('#searchForm').prop('action', '/kc/kcInsert.do');
		$('#searchForm').submit();
	}
	function view(bdId) {
		$('#bdId').val(bdId);
		$('#searchForm').prop('method', 'GET');
		$('#searchForm').prop('action', '/kc/kcView.do');
		$('#searchForm').submit();

	}
	function newWindow(url) {
		window.open(url, '_blank');
	}

</script>


<h2 class="mb60">지식채널</h2>

<form id="searchForm">
	<input type="hidden" id="pageNo" name="pageNo"	value="<c:out value='${listPage.currentPage}'/>" />
	 <input		type="hidden" id="bdId" name="bdId" value="" />
</form>
<ul class="knowChen">
	<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<li>
			<p class="pic"><a href="javascript:view('${result.BD_ID}')"><img src="/upload${result.FILE_PATH}" alt="" style="width: 150px; height: 100px;"></a></p>
			<div class="siteTx">
				<p class="tit"><a href="javascript:view('${result.BD_ID}')"><c:out	value="${result.TITLE}" /></a></p>
				<p class="tx1 ellipsis multiline"><c:out value="${result.CONT}" /></p>
				
				
				<a href="#" onClick="newWindow('${result.LINK_URL}')" class="btn btn01 goBtn">바로가기</a>
			</div>
		</li>
	</c:forEach>
	<c:if test="${empty listPage.list}">
		<li>
			<p class="tx1" align="center">검색 결과가 없습니다.</p>
		</li>
	</c:if>
</ul>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>

<c:if test="${params.kcAppointYn eq 'Y'}">
	<div class="tac">
		<button type="button" id="insertBtn" class="btn btnMid btnBlue"
			style="width: 150px;">등록</button>
	</div>
</c:if>


<%@include file="/WEB-INF/views/include/footer.jsp"%>