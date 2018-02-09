<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "공통 코드 관리 | 코드 관리 | M-Library Admin");
	
	$('#upperCd').val('<c:out value="${params.upperCd}"/>');
	$('#upperCd').msDropDown().data("dd").set("value", '<c:out value="${params.upperCd}"/>');
	if($('#upperCd').val()!=''){
		$('#spanCdNm').text($('#upperCd option:selected').text());
	}
	
	$('#upperCd').change(function(){
		search();
	});	

});

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/code/commonCode.do');
	$('#searchForm').submit();
}

function insertCd(){
	
	if($('#insertCdNm').val()==''){
		alert('코드명을 입력해 주세요');
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
		url : "/admin/code/insertCodeAction.do",
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

function updateCd(admCd, cdNmId){
	if(!confirm('수정 하시겠습니까?')){
		return;
	}
	
	$("#updateForm input[name=admCd]").val(admCd);
	$("#updateForm input[name=cdNm]").val($('#'+cdNmId).val());
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/code/updateCodeAction.do",
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

function deleteCd(admCd){
	if(!confirm('삭제 하시겠습니까?')){
		return;
	}
	
	$("#deleteForm input[name=admCd]").val(admCd);
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/code/deleteCodeAction.do",
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

<h2 class="mb50">코드 관리</h2>

<fieldset>
	<legend>코드 관리</legend>
</fieldset>

<form id="insertForm">
	<input type="hidden" name="upperCd" value="${params.upperCd}"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="updateForm">
	<input type="hidden" name="upperCd" value="${params.upperCd}"/>
	<input type="hidden" name="admCd"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="deleteForm">
	<input type="hidden" name="upperCd" value="${params.upperCd}"/>
	<input type="hidden" name="admCd"/>
</form>

<form id="searchForm">
<table class="tableComm mb50">
	<caption>코드 선택</caption>
	<colgroup>
		<col style="width:20%;">
		<col style="width:80%;">
	</colgroup>
	<tbody>
		<tr>
			<th scope="row">코드 선택</th>
			<td>
				<select id="upperCd" name="upperCd" title="검색범위선택" style="width:200px;">
					<option value="CLIENT_CD">Client명</option>
					<option value="BIZ_CD">업종</option>
					<option value="CONTACT_PATH_CD">Contact경로</option>
					<option value="RIVAL_CD">참여사</option>
					<option value="PT_TYP_CD">PT Report : PT유형</option>
					<option value="MEDIA_CD">History Archive : 매체</option>
				</select>
			</td>
		</tr>
	</tbody>
</table>
</form>

<table class="tableComm table1 tableType1">
	<caption class="">코드 관리 리스트</caption>
	<colgroup>
		<col style="width:50%;">
		<col style="width:30%;">
		<col style="width:10%;">
		<col style="width:10%;">
	</colgroup>
	<thead>
		<tr>
			<th scope="col"><span id="spanCdNm">코드명</span></th>
			<th scope="col">코드</th>
			<th scope="col">저장</th>
			<th scope="col">삭제</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${not empty params.upperCd}">
		<tr>
			<td><input type="text" id="insertCdNm" title="Client 명 입력" style="width:250px;" class="tac" maxlength="50"></td>
			<td><button type="button" onclick="javascript:insertCd();" class="btn btnSmall btnBlack">추가</button></td>
			<td></td>
			<td></td>
		</tr>
		</c:if>
		<c:forEach var="result" items="${codeList}" varStatus="status">
		<tr>
			<td><input type="text" id="cdNm_${status.index}" title="Client 명 입력" style="width:250px;" class="tac" value="<c:out value="${result.NM}"/>" maxlength="50"></td>
			<td><c:out value="${result.CD}"/></td>
			<td><button type="button" onclick="javascript:updateCd('<c:out value="${result.CD}"/>','cdNm_${status.index}');" class="btn btnSmall btnRed">저장</button></td>
			<td><button type="button" onclick="javascript:deleteCd('<c:out value="${result.CD}"/>');" class="btn btnSmall btnBlue">삭제</button></td>
		</tr>
		</c:forEach>
		<c:if test="${empty codeList}">
			<tr>
				<td colspan="4" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>			
	</tbody>
</table>


<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
