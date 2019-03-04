<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){
	
	$(this).attr('title','상세 | Trend Report | M-Library');
	
	if(''=='${returnMap.BD_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.');
		goList();
		return;
	}
	/* $('#mainBtn').click(function(){
		goMain();
	}) */
	$('#updateBtn').click(function(){
		update();
	});

	$('#deleteBtn').click(function(){
		deleteFu();
	});
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});
function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trList.do');   
	$('#searchForm').submit();		
}

function update(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trUpdate.do');
	$('#searchForm').submit();		
}

function deleteFu(){
	if(!confirm("삭제하시겠습니까?")) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/tr/trDeleteAction.do",
		cache:false,
		async:false,
		data:$("#searchForm").serialize(),
		dataType:"json",
		success : function(data){
			if(data.result=='true'){
				alert("삭제되었습니다");
				goList();
			}else{
				alert(data.msg);
			}
		},
		error:function(request,status,errorThrown){
			alert("시스템 오류입니다,잠시 후 다시 시도해 주세요.");
		}
	});
}

function streamDocPop(viewInfo){
	var win = "";
	var width = 1600, height = 800 ;
	var left = (screen.width - width) / 2 ;
	var top = (screen.height - height) / 2 ;
	//팝업 노출 
	win = window.open("http://${ctx }:3001/streamdocs/viewer.html?viewInfo=" + viewInfo, 'popup','width=' + width +  ', height=' + height +  ', left=' + left +  ', top=' + top + ',scrollbars=no,toolbars=no,location=no');
	
	return false;
}



</script>

<form id="searchForm">
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${returnMap.BD_ID }'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	
	<input type="hidden" id="searchText" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" id="searchType" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" id="searchStart" name="searchStart" value="<c:out value='${params.searchStart}'/>"/>
	<input type="hidden" id="searchEnd" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" id="orderBy" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" id="sendTrCateCd" name="sendTrCateCd" value="<c:out value='${params.sendTrCateCd}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
	
	<h2 class="mb60">Trend Report </h2>


			<table class="tableComm mb30">
				<caption>Trend Report</caption>
				<colgroup>
					<col style="width:15%;">
					<col style="width:20%;">
					<col style="width:15%;">
					<col style="width:20%;">
					<col style="width:15%;">
					<col style="width:auto;">
				</colgroup>
				<tbody>
					<tr>
						<th >제목</th>
						<td colspan="5"><c:out value="${returnMap.TITLE}"/></td>
					</tr>
					<tr>
						<th >작성팀</th>
						<td>		<c:out value="${returnMap.TEAM_NM}"/></td>
						
						<th >작성자</th>
						<td>	<c:out value="${returnMap.MEMBER_NM}" /></td>
						<th >작성일</th>
						<td>	<fmt:formatDate value="${returnMap.REG_DTM}" pattern="yyyy.MM.dd"/></td>
					</tr>
					<tr>
						<th >카테고리</th>
						<td colspan="3"> <c:out value="${returnMap.TR_CATE_NM}"/></td>
						<th >조회수</th>
						<td><c:out value="${returnMap.HIT}"/></td>
					</tr>
				</tbody>
			</table>

			<table class="tableComm mb30">
				<caption>Trend Report<caption>
				<colgroup>
					<col style="width:15%;">
					<col style="width:auto;">
				</colgroup>
				<tbody>
					<tr>
						<th >내용</th>
						<td>
							<div class="bx05">
							<c:out value="${returnMap.CONT}" escapeXml="false"/>
							</div>
						</td>
					</tr>
					<c:forEach var="att" items="${attList}" varStatus="index" >
					<tr>
						<th >첨부파일</th>
						<td>
							<div class="bx12 dpinblock">
								<p class="file">
									<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>"><c:out value="${att.ORG_FILE_NM}"/></a>
								</p>								
							</div>
							<!--  Trend Report 카테고리가 셀럽 파워리포트가 아닐 경우 다운로드 --> 
							<c:if test="${returnMap.TR_CATE_CD ne 'TRC_00006'}">
								<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn05">다운로드</a>
							</c:if>
							
							<!--  Trend Report 카테고리가 셀럽 파워리포트일 경우 스트림닥스 뷰어 이용 -->
							<c:if test="${returnMap.TR_CATE_CD eq 'TRC_00006'}">
								<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
								<c:if test="${params.superYn eq 'Y'}">
									<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn05">저장</a>
								</c:if>
							</c:if>
										
						</td>
					</tr>
					</c:forEach> 
					<c:if test="${empty attList}">
					<tr>
						<th >첨부파일</th>
						<td colspan="6" align="center">첨부파일이 없습니다.</td>
					</tr>
					</c:if>
				</tbody>
			</table>
</form>

			<div class="tac mb60">

				<c:if test="${params.superYn eq 'Y'}">
				<button type="button" class="btn btnMid btnRed" id="deleteBtn" style="width:150px;">삭제</button>
				</c:if>
				<c:if test="${returnMap.REG_ID eq params.mid}">
				<button type="button" class="btn btnMid btnBlue  ml10" id="updateBtn" style="width:150px;">수정</button>
				</c:if>
			</div>
			


<%@include file="/WEB-INF/views/include/footer.jsp"%>
