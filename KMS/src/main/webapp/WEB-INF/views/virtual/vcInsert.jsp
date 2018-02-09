<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];

$(document).ready(function(){

	$(this).attr("title", "등록 | Potential Client | M-Library");
	
	$( "#contactDt" ).datepicker({
	    dateFormat: 'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
	    changeYear: true,
	    changeMonth: true,
	    showOn: 'both',
	    buttonImage: '/resources/images/icon_datepicker.png',
	    buttonText: '날짜입력'
	});
	
	$('#insertBtn').click(function(){
		insert();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});

	// 스마트 에디터 초기화
	initSE();
});

function insert(){
	
	if( $('#title').val()=='' ){
		alert('제목을 입력하세요.');
		$('#title').focus();
		return;
	}
	
	if( $('#billing').val()=='' ){
		alert('예상빌링을 입력하세요.');
		$('#billing').focus();
		return;
	}
	
	if( $('#bizCd').val()=='' ){
		alert('업종을 선택하세요.');
		$('#bizCd').focus();
		return;
	}
	
	if( $('#contactDt').val()=='' ){
		alert('최초 Contact일을 선택하세요.');
		$('#contactDt').focus();
		return;
	}

	if( $('#contactPathCd').val()=='' ){
		alert('Contact 경로를 선택하세요.');
		$('#contactPathCd').focus();
		return;
	}
	
	if( $('#coAttend').val()=='' ){
		alert('당사 참석자를 입력하세요.');
		$('#coAttend').focus();
		return;
	}
	
	if( $('#adAttend').val()=='' ){
		alert('광고주 참석자를 입력하세요.');
		$('#adAttend').focus();
		return;
	}
	
	$('#cont').val(oEditors.getById["ir1"].getIR());

	if( $('#cont').val()=='' ){
		alert('내용을 입력하세요.');
		$('#ir1').focus();
		return;
	}
	
	if($('input[name="authMid"]').length<1){
		alert('문서 열람자를 선택하세요.');
		return;
	}
	
	if($('#span1 input[name="authMid"]').length<1){
		alert('문서 열람자 선택 중 부문장님을 선택해 주세요.');
		return;
	}
	
	if($('#span2 input[name="authMid"]').length<1 && $('#span3 input[name="authMid"]').length<1){
		alert('문서 열람자 선택 중 본부장님이나 팀장님을 선택해 주세요.');
		return;
	}
	
	/* 상단 노출일 경우   */
	if($("input:checkbox[id='impview']").is(":checked") == true   ){
			$("#topYn").val('Y');
	}else{
			$("#topYn").val('N');
	}
	
	
	if(!confirm('저장하시겠습니까?')) return;
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/virtual/vcInsertAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('저장되었습니다.');
				goList();
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

function goList(){
	$('#searchForm').submit();
}

function popMemberList(posLevel, spanId){
	window.open('/popup/popMemberList.do?posLevel='+posLevel+'&spanId='+spanId, 'agree7', 'width=450, height=670, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
}

// 팝업 콜백
function selectMember(spanId, mids){
	$(mids).each(function(){
		
		// 중복 제거
		var dup = $('input[name=authMid][value='+$(this).val()+']');
		if(dup.length==0){
			$('#'+spanId).append(
					'<span class="mTx01">'
					+ '<input type="hidden" name="authMid" value="'+$(this).val()+'"/> '
					+ $(this).attr('memberNm')
					+ ' <button type="button" title="삭제" onclick="removeMember(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>'
				+ '</span>'
			);
		}
	});
}

function removeMember(obj){
	if(!confirm('제거 하시겠습니까?')){
		return;
	}
	$(obj).parent().remove();
}

function initSE(){
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "ir1",
	    sSkinURI: "/resources/se2/SmartEditor2Skin.html",
	    fCreator: "createSEditor2",
	    htParams:{ // 스마트 에디터 내용변경 Fn 제거
	    	fOnBeforeUnload:function(){}
	    }	    
	});
}
</script>

<form id="searchForm" method="GET" action="/virtual/vcList.do">
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/> 
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchBizCd" value="<c:out value='${params.searchBizCd}'/>"/>
	<input type="hidden" name="searchContactCd" value="<c:out value='${params.searchContactCd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="vcId" value="<c:out value='${params.vcId}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<h2 class="mb60">Potential Client</h2>

<form id="insertForm">
	<input type="hidden" id="topYn" name="topYn" value=""/>
<table class="tableComm mb30">
	<caption>Potential Client 등록</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:258px;">
		<col style="width:100px;">
		<col style="width:258px;">
	</colgroup>
	<tbody>
		<tr>
			<th>제목 <span class="red">*</span> </th>
			<td colspan="3">
				<input type="text" id="title" name="title" value="" maxlength="100" style="width:581px;" placeholder="Client명을 포함하여 작성">
			</td>
		</tr>
		<tr>
			<th>예상빌링 <span class="red">*</span> </th>
			<td>
				<input type="text" id="billing" name="billing" maxlength="100" title="도/예상빌링" style="width:233px;">
			</td>
			<th>업종 <span class="red">*</span> </th>
			<td>
				<select id="bizCd" name="bizCd" style="width:233px;">
					<option value="">선택</option>
					<c:forEach var="biz" items="${bizList}" varStatus="status">
						<option value='<c:out value="${biz.CD}"/>'><c:out value="${biz.NM}"/></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>최초<br>Contact일 <span class="red">*</span> </th>
			<td>
				<input type="text" id="contactDt" name="contactDt" readOnly/>
			</td>
			<th>Contact<br>경로 <span class="red">*</span> </th>
			<td>
				<select id="contactPathCd" name="contactPathCd" title="Contact 경로" style="width:233px;">
					<option value="">선택</option>
					<c:forEach var="contact" items="${contactPathList}" varStatus="status">
						<option value='<c:out value="${contact.CD}"/>'><c:out value="${contact.NM}"/></option>
					</c:forEach>
				</select>			
			</td>
		</tr>
		<tr>
			<th>당사참석자 <span class="red">*</span> </th>
			<td colspan="3">
				<input type="text" id="coAttend" name="coAttend" maxlength="100" style="width:581px;" placeholder="[팀명] 이름, [팀명] 이름"/>
			</td>
		</tr>
		<tr>
			<th>광고주 참석자 <span class="red">*</span> </th>
			<td colspan="3">
				<input type="text" id="adAttend" name="adAttend" maxlength="100" style="width:581px;" placeholder="[팀명] 이름+직책, [팀명] 이름+직책"/>
			</td>
		</tr>
			
		<!-- 상단 공통 노출 박그림 매니저 요청 20170502 -->
		<c:if test="${params.superYn eq 'Y' }">
			<tr>
				<th ><strong class="red">공통노출</strong></th>
				<td colspan="3">
					<div class="inp-check">
						<input type="checkbox" name="impview" id="impview">
						<label for="impview"><span class="box"></span> 상단공통노출</label>
					</div>
				</td>
			</tr>
		</c:if>
		
	</tbody>
</table>

<table class="tableComm mtable1 mb30">
	<caption>내용 및 본부장 의견</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>내용 <span class="red">*</span> </th>
			<td>
				<textArea style="width:100%; height:300px" id="ir1" style="width:96%; height:70px;"></textArea>
				<input type="hidden" id="cont" name="cont" value=""/>
			</td>
		</tr>
		<tr>
			<th>본부장<br>의견</th>
			<td>
			<textarea title="본부장 의견" style="width:96%; height:70px;" placeholder="본부장 의견 자유롭게 작성" disabled></textarea></td>
		</tr>
	</tbody>
</table>

<h3>문서 열람자 선택</h3>

<table class="tableComm mb15">
	<caption>문서 열람자 선택</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>부문장</th>
			<td>
				<button type="button" class="btn btnSmall btnBlack" onClick="popMemberList('1','span1');">검색</button>
				<span id="span1">
					<c:forEach var="auth" items="${authList}" varStatus="status">
						<c:if test="${auth.POS_CD eq 'POS_00010'}">
							<span class="mTx01">
								<input type="hidden" name="authMid" value="<c:out value='${auth.MID}'/>"/>
								<c:out value="${auth.MEMBER_NM}"/> 
								<button type="button" title="삭제" onclick="removeMember(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>
					</c:forEach>
				</span>
			</td>
		</tr>
		<tr>
			<th>본부장/그룹장</th>
			<td>
				<button type="button" class="btn btnSmall btnBlack" onClick="popMemberList('2','span2');">검색</button>
				<span id="span2">
				</span>
			</td>
		</tr>
		<tr>
			<th>팀장/PL</th>
			<td>
				<button type="button" class="btn btnSmall btnBlack" onClick="popMemberList('3','span3');">검색</button>
				<span id="span3">
				</span>
			</td>
		</tr>
	</tbody>
</table>

<p class="mb30">※ 본인 상위 직책자 선택 필수</p>

<div class="tac mb30">
	<button type="button" id="insertBtn" class="btn btnMid btnRed" style="width:150px;">저장</button>
</div>

</form>

<%@include file="/WEB-INF/views/include/footer.jsp"%>