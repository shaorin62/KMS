<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript">

$(document).ready(function(){
	$(this).attr('title','상세 | Credential | M-Library');
	
	if(''=='${returnMap.BD_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.');
		goList();
		return;
	}
	$('#listBtn').click(function(){
		goList();
	});
	$('#mainBtn').click(function(){
		goMain();
	});
	$('#updateBtn').click(function(){
		update();
	});

	$('#deleteBtn').click(function(){
		deleteFu();
	});
	$('#downloadFileBtn').click(function(){
		downloadFile();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
});
function goMain(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/main/main.do');
	$('#searchForm').submit();		
}
function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/cd/cdList.do');
	$('#searchForm').submit();		
}
function update(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/cd/cdUpdate.do');
	$('#searchForm').submit();		
}

function deleteFu(){
	if(!confirm("삭제하시겠습니까?")) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/cd/cdDeleteAction.do",
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

function downloadFile(){
if(!confirm("다운로드 하시겠습니까?")) return;
	
	$.ajax({
		type:"POST",
		url:"/cd/cdDownLoadAction.do",
		cache:false,
		async:false,
		data:$("#searchForm").serialize(),
		dataType:"json",
		success : function(data){
			if(data.result=='true'){
				alert("다운로드 되되었습니다");
			}else{
				alert(data.msg);
			}
		},
		error:function(request,status,errorThrown){
			alert("시스템 오류입니다,잠시 후 다시 시도해 주세요.");
		}
	});
			
}



</script>



<form id="searchForm" >
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${returnMap.BD_ID }'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" id="sendTrCateCd" name="sendTrCateCd"  value="<c:out value='${params.pageNo}'/>"/>

	<h2 class="mb60">Credential</h2>

	<table class="tableComm mb30">
		<caption>Credential</caption>
			<colgroup>
				<col style="width:15%;">
				<col style="width:35%;">
				<col style="width:15%;">
				<col style="width:auto;">
			</colgroup>
		<tbody>
		<tr>
			<th>제목</th>
			<td colspan="5">
				<c:out value="${returnMap.TITLE}"/>
			</td>
		</tr>
		<tr> 
			<th>업종</th>
			<td colspan="3">
				<c:if test="${returnMap.TR_CATE_CD eq 'BIZ_00000'}">
				공통
				</c:if>
				<c:out value="${returnMap.TR_CATE_NM}"/>
			</td>
			<th>작성일</th>
			<td>
				<fmt:formatDate value="${returnMap.REG_DTM}" pattern="yyyy.MM.dd"/>	
			</td>
		</tr>
		</tbody>
	</table>
	
	<table class="tableComm mb30">
		<caption>Credential</caption>
			<colgroup>
				<col style="width:15%;">
				<col style="width:auto;">
		</colgroup>
		
		<tbody>
		<tr>
			<th>내용</th>
			<td>
				<div class="bx05">
				<c:out value="${returnMap.CONT}" escapeXml="false"/>
				</div>
			</td>
		</tr>
		<c:forEach var="att" items="${attList}" varStatus="index" >
			<tr>
				<th>첨부파일</th>
				<td>
					<div class="bx12 dpinblock">
						<p class="file">
							
								<c:choose>
									<c:when test="${empty att.ORG_FILE_NM}">
									<center>첨부파일이 없습니다.</center>
									</c:when>
									<c:otherwise>
									<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>"><c:out value="${att.ORG_FILE_NM}"/></a>
									</c:otherwise>
								</c:choose>
						</p>								
					</div>
					<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn05">다운로드</a>
				</td>
			</tr>
		</c:forEach> 
					<c:if test="${empty attList}">
					<tr>
						<th>첨부파일</th>
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
