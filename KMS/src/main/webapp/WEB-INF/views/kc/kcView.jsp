<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){
	$(this).attr('title','상세 | 지식채널 | M-Library');
	
	if(''=='${returnMap.BD_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.');
		goList();
		return;
	}
	$('#listBtn').click(function(){
		goList();
	})
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
	$('#searchForm').prop('action','/kc/kcList.do');
	$('#searchForm').submit();		
}
function update(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/kc/kcUpdate.do');
	$('#searchForm').submit();		
}


function deleteFu(){
	if(!confirm("삭제하시겠습니까?")) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/kc/kcDeleteAction.do",
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

</script>

<h2 class="mb60">지식채널</h2>


<form id="searchForm">
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${returnMap.BD_ID }'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>

</form>


<table class="tableComm mb30">
<caption>지식채널</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:35%;">
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
	<tr>
		<th>제목</th>
		<td colspan="5"><c:out value="${returnMap.TITLE}" />

		</td>
	</tr>
	<tr>
		<th>작성자</th>
		<td>
			<c:out value="${returnMap.MEMBER_NM}" />
		</td>
		<th>작성일</th>
		<td>
			<fmt:formatDate value="${returnMap.REG_DTM}" pattern="yyyy.MM.dd"/>	
		</td>
	</tr>	
	</tbody>
</table>

<table class="tableComm mb30">
	<caption>지식채널</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:65%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
	<tr>
		<th>내용</th>
		<td colspan="3">
			<div class="bx05"  style="width:96%;">
			<c:out value="${fn:replace(returnMap.CONT,lf,'<br/>')}" escapeXml="false"/>
			</div>
		</td>
	</tr>
	<tr>
		<th>URL</th>
		<td><c:out value="${returnMap.LINK_URL}"/>	</td>
		<td class="tar"><a target="_blank" href="${returnMap.LINK_URL}" class="btn btn01 goBtn">Site로 바로가기</a></td>		
	</tr>
</tbody>	
	</table>
	<div class="tac mb60">
				<c:if test="${params.superYn eq 'Y'}">
				<button type="button" class="btn btnMid btnRed" id="deleteBtn" style="width:150px;">삭제</button>
				</c:if>
				<c:if test="${returnMap.REG_ID eq params.mid}">
				<button type="button" class="btn btnMid btnBlue  ml10" id="updateBtn" style="width:150px;">수정</button>
				</c:if>
			</div>
			
<%@include file="/WEB-INF/views/include/footer.jsp"%>