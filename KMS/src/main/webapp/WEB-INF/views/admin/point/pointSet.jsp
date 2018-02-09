<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>

$(document).ready(function(){

	$(this).attr("title", "포인트 설정 | 포인트 관리 | M-Library Admin");
	
	$('#poiVcReg').val('<c:out value="${pointSet.POI_VC_REG}"/>');
	$('#poiPtSubmit').val('<c:out value="${pointSet.POI_PT_SUBMIT}"/>');
	$('#poiTrView').val('<c:out value="${pointSet.POI_TR_VIEW}"/>');
	$('#poiTrReg').val('<c:out value="${pointSet.POI_TR_REG}"/>');
	$('#poiOtherView').val('<c:out value="${pointSet.POI_OTHER_VIEW}"/>');
	$('#poiOtherReg').val('<c:out value="${pointSet.POI_OTHER_REG}"/>');
	$('#poiHaReg').val('<c:out value="${pointSet.POI_HA_REG}"/>');
	
	$('#updateBtn').click(function(){
		update();
	});
	
});

function update(){
	
	if(!confirm('수정하시겠습니까?')){
		return;
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/point/pointSetAction.do",
		cache : false,
		async : false,
		data : $('#updateForm').serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('수정되었습니다.');
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

<h2 class="mb50">포인트 설정</h2>

<fieldset>
	<legend>포인트 설정</legend>
</fieldset>

<form id="updateForm">
<div class="bx07 mb50">
	<ul class="admList">
		<li class="tac mb15">
			<label for="poiVcReg"><strong class="tit04">Potential Client 등록 포인트</strong></label>
			<input type="text" id="poiVcReg" name="poiVcReg" style="width:30%;"> <strong>P</strong>
		</li>
		<li class="tac mb15">
			<label for="poiPtSubmit"><strong class="tit04">PT Report 제출 포인트</strong></label>
			<input type="text" id="poiPtSubmit" name="poiPtSubmit" style="width:30%;"> <strong>P</strong>
		</li>
		<li class="tac mb15">
			<label for="poiTrView"><strong class="tit04">Trend Report 열람 포인트</strong></label>
			<input type="text" id="poiTrView" name="poiTrView" style="width:30%;"> <strong>P</strong>
		</li>
		<li class="tac mb15">
			<label for="poiTrReg"><strong class="tit04">Trend Report 등록 포인트</strong></label>
			<input type="text" id="poiTrReg" name="poiTrReg" style="width:30%;"> <strong>P</strong>
		</li>
		<!-- 2016-12-13 추가 -->
		<li class="tac mb15">
			<label for="poiOtherView"><strong class="tit04">타사자료 열람 포인트</strong></label>
			<input type="text" id="poiOtherView" name="poiOtherView" style="width:30%;"> <strong>P</strong>
		</li>
		<li class="tac mb15">
			<label for="poiOtherReg"><strong class="tit04">타사자료 등록 포인트</strong></label>
			<input type="text" id="poiOtherReg" name="poiOtherReg" style="width:30%;"> <strong>P</strong>
		</li>
		<!-- 2016-12-13 추가 // -->

		<li class="tac">
			<label for="poiHaReg"><strong class="tit04">History Archive 등록 포인트</strong></label>
			<input type="text" name="poiHaReg" id="poiHaReg" style="width:30%;"> <strong>P</strong>
		</li>
	</ul>
</div>
</form>

<div class="tac">
	<button type="button" id="updateBtn" class="btn btnMid btnRed" style="width:150px;">저장</button>
</div>

<div class="admNotice">
	<p class="tit">포인트 설정 유의사항</p>
	<ul class="">
		<li>1. Potential Client / PT Report / History Archive는 구성원 등록 시 제공되는 포인트 입니다.</li>
		<li>2. Trend Report는 등록 후 다른 구성원이 게시물 내에 첨부파일을 다운 받을 경우 작성자에게 제공 되는 포인트 입니다.</li>
		<li>3. 상기 입력값을 입력하지 않는 경우 해당 메뉴의 포인트 적립이 되지 않습니다.</li>
	</ul>
</div>

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
