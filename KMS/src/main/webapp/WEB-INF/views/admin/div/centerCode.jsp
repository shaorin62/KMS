<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){
	$(this).attr("title", "팀 관리 | M-Library Admin");
});

function view(upperCd){
	location.href = '/admin/div/teamCode.do?upperCd='+upperCd;
}

function insertCd(){
	
	if($('#insertCdNm').val()==''){
		alert('본부명을 입력해 주세요');
		$('#insertCdNm').focus();
		return;
	}
	
	if(!confirm('추가 하시겠습니까?')){
		return;
	}
	
	$("#insertForm input[name=cdNm]").val($('#insertCdNm').val());
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/div/insertDivAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('저장되었습니다.');
				location.reload();
			}
			else{
				alert(data.msg);
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});
}

function updateCd(divCd, cdNmId){
	if(!confirm('수정 하시겠습니까?')){
		return;
	}
	
	$("#updateForm input[name=divCd]").val(divCd);
	$("#updateForm input[name=cdNm]").val($('#'+cdNmId).val());
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/div/updateDivAction.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('저장되었습니다.');
				location.reload();
			}
			else{
				alert(data.msg);
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});	
}

function deleteCd(divCd){
	if(!confirm('삭제 하시겠습니까?')){
		return;
	}
	
	$("#deleteForm input[name=divCd]").val(divCd);
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/div/deleteDivAction.do",
		cache : false,
		async : false,
		data : $("#deleteForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('삭제되었습니다.');
				location.reload();
			}
			else{
				alert(data.msg);
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});		
}
</script>

<h2 class="mb50">팀 관리</h2>

<fieldset>
	<legend>팀 관리</legend>
</fieldset>

<form id="insertForm">
	<input type="hidden" name="upperCd" value="SEC_00001"/>
	<input type="hidden" name="prefix" value="CEN"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="updateForm">
	<input type="hidden" name="divCd"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="deleteForm">
	<input type="hidden" name="divCd"/>
</form>

<h3>본부 등록 및 관리</h3>

<table class="tableComm table1 tableType1">
	<caption class="">본부 관리 리스트</caption>
	<colgroup>
		<col style="width:50%;">
		<col style="width:30%;">
		<col style="width:10%;">
		<col style="width:10%;">
	</colgroup>
	<thead>
		<tr>
			<th scope="col"><span id="spanCdNm">본부명</span></th>
			<th scope="col">본부코드</th>
			<th scope="col">저장</th>
			<th scope="col">삭제</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input type="text" id="insertCdNm" title="Client 명 입력" style="width:250px;" class="tac" maxlength="50"></td>
			<td><button type="button" onclick="javascript:insertCd();" class="btn btnSmall btnBlack">추가</button></td>
			<td></td>
			<td></td>
		</tr>
		<c:forEach var="result" items="${centerList}" varStatus="status">
		<tr>
			<td><input type="text" id="cdNm_${status.index}" title="본부명 입력" style="width:250px;" class="tac" value="<c:out value="${result.NM}"/>" maxlength="50"></td>
			<td><a href="javascript:view('<c:out value="${result.CD}"/>');"><c:out value="${result.CD}"/></a></td>
			<td><button type="button" onclick="javascript:updateCd('<c:out value="${result.CD}"/>','cdNm_${status.index}');" class="btn btnSmall btnRed">저장</button></td>
			<td><button type="button" onclick="javascript:deleteCd('<c:out value="${result.CD}"/>');" class="btn btnSmall btnBlue">삭제</button></td>
		</tr>
		</c:forEach>
		<c:if test="${empty centerList}">
			<tr>
				<td colspan="4" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>			
	</tbody>
</table>


<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
