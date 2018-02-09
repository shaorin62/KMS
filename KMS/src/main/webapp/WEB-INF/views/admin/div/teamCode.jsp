<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){
	
	$(this).attr("title", "팀 관리 | M-Library Admin");
	
	$('select[id^=upperCd_]').each(function(){
		$(this).val('<c:out value="${params.upperCd}"/>');
		$(this).msDropDown().data("dd").set("value", '<c:out value="${params.upperCd}"/>');
	});
});

function insertCd(){
	
	if($('#insertCdNm').val()==''){
		alert('팀명을 입력해 주세요');
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

function updateCd(divCd, cdNmId, upperCdId){
	if(!confirm('수정 하시겠습니까?')){
		return;
	}
	
	$("#updateForm input[name=divCd]").val(divCd);
	$("#updateForm input[name=cdNm]").val($('#'+cdNmId).val());
	$("#updateForm input[name=upperCd]").val($('#'+upperCdId).val());
	
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
	<input type="hidden" name="upperCd" value="<c:out value='${params.upperCd}'/>"/>
	<input type="hidden" name="prefix" value="TEA"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="updateForm">
	<input type="hidden" name="upperCd"/>
	<input type="hidden" name="divCd"/>
	<input type="hidden" name="cdNm"/>
</form>

<form id="deleteForm">
	<input type="hidden" name="divCd"/>
</form>

<h3>팀 등록 및 관리</h3>			

<!-- search box -->
<div class="bx07 tac mb50">
	<p class="tx01">
		<strong>본부명</strong>
		<span class="div">&gt;</span>
		<span><c:out value="${center.NM}"/></span>
	</p>
</div>
<!-- search box // -->

<table class="tableComm table1 tableType1 mb50">
	<caption class="">팀 관리 리스트</caption>
	<colgroup>
		<col style="width:28%;">
		<col style="width:28%;">
		<col style="width:24%;">
		<col style="width:10%;">
		<col style="width:10%;">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">본부 선택</th>
			<th scope="col">팀</th>
			<th scope="col">팀코드</th>
			<th scope="col">저장</th>
			<th scope="col">삭제</th>
		</tr>
	</thead>
	<tbody>		
		<tr>
			<td>
			</td>
			<td><input type="text" id="insertCdNm" title="팀" style="width:200px;" class="tac" maxlength="50"></td>
			<td><button type="button" onclick="javascript:insertCd();" class="btn btnSmall btnBlack">추가</button></td>
			<td></td>
			<td></td>
		</tr>
		<c:forEach var="result" items="${teamList}" varStatus="status">
		<tr>
			<td>
				<select title="검색범위선택" id="upperCd_${status.index}" style="width:200px;">
					<c:forEach var="center" items="${centerList}">
						<option value="<c:out value="${center.CD}"/>"><c:out value="${center.NM}"/></option>
					</c:forEach>
				</select>
			</td>
			<td><input type="text" id="cdNm_${status.index}" title="팀" style="width:200px;" class="tac" value="<c:out value="${result.NM}"/>" maxlength="50"></td>
			<td><c:out value="${result.CD}"/></td>
			<td><button type="button" onclick="javascript:updateCd('<c:out value="${result.CD}"/>','cdNm_${status.index}', 'upperCd_${status.index}');" class="btn btnSmall btnRed">저장</button></td>
			<td><button type="button" onclick="javascript:deleteCd('<c:out value="${result.CD}"/>');" class="btn btnSmall btnBlue">삭제</button></td>
		</tr>
		</c:forEach>
		<c:if test="${empty teamList}">
			<tr>
				<td colspan="5" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>				
	</tbody>
</table>

<p class="tac"><a href="/admin/div/centerCode.do" class="btn btnMid btnRed ml10" style="width:180px;">본부관리로 이동</a></p>

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
