<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "수정 | PT Report | M-Library");
	
	$( "#otDt, #ptDt, #docOpenDt, #contStartDt, #contEndDt" ).datepicker({
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
	
	$('#bizCd').val('<c:out value="${pt.BIZ_CD}"/>');
	$('#bizCd').msDropDown().data("dd").set("value", '<c:out value="${pt.BIZ_CD}"/>');
	
	$('#ptTypCd').val('<c:out value="${pt.PT_TYP_CD}"/>');
	$('#ptTypCd').msDropDown().data("dd").set("value", '<c:out value="${pt.PT_TYP_CD}"/>');
	
	$("input[name=ptResultCd][value='${pt.PT_RESULT_CD}']").prop('checked','checked');
	
	$('#otDt,#ptDt,#docOpenDt').change(function(){
		onDateChange(this);
	});
	
	$('#clientBtn').click(function(){
		popClientList();
	});
	
	$('#rivalBtn').click(function(){
		popRivalList();
	});
	
	$('#updateBtn').click(function(){
		update(false);
	});
	
	$('#submitBtn').click(function(){
		update(true);
	});
	
	$('input[name=ptResultCd]').click(function(){
		if($(this).val()=='PTR_F'){
			$('#optainCorp').removeAttr('disabled');
			$('#optainCorp').focus();
		}else{
			$('#optainCorp').val('');
			$('#optainCorp').attr('disabled','disabled');
		}
	});
	$('input[name=ptResultCd]:checked').click();
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});

function onDateChange(obj){
	
	var otDtVal = $('#otDt').val();
	var ptDtVal = $('#ptDt').val();
	var docOpenDtVal = $('#docOpenDt').val();
	
	if($(obj).val()!=''){
		// ot일
		if($(obj).attr('id')=='otDt'){
			if(ptDtVal!='' && otDtVal>=ptDtVal){
				alert('OT일은 PT일 보다 이전 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}
			if(docOpenDtVal!='' && otDtVal>=docOpenDtVal){
				alert('OT일은 문서공개일 보다 이전 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}
		}
		//  pt일
		else if($(obj).attr('id')=='ptDt'){
			if(otDtVal!='' && otDtVal>=ptDtVal){
				alert('PT일은 OT일 보다 이후 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}
			if(docOpenDtVal!='' && ptDtVal>=docOpenDtVal){
				alert('PT일은 문서공개일 보다 이전 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}			
		}
		// docOpen 일
		else if($(obj).attr('id')=='docOpenDt'){
			if(otDtVal!='' && otDtVal>=docOpenDtVal){
				alert('문서공개일은 OT일 보다 이후 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}
			if(ptDtVal!='' && ptDtVal>=docOpenDtVal){
				alert('문서공개일은 PT일 보다 이후 날짜이어야 합니다.');
				$(obj).val(''); $(obj).focus(); return;
			}			
		}		
	}
}

function update(isSubmit){
	
	if( $('#title').val()=='' ){
		alert('제목을 입력하세요.');
		$('#title').focus();
		return;
	}
	
	if( $('input[name=clientCd]').length == 0 ){
		alert('Client를 선택하세요.');
		$('#clientBtn').focus();
		return;
	}
	
	if( $('#item').val()=='' ){
		alert('품목을 입력하세요.');
		$('#item').focus();
		return;
	}

	if( $('#bizCd').val()=='' ){
		alert('업종을 선택하세요.');
		$('#bizCd').focus();
		return;
	}
	
	/*
	if( $('input[name=rivalCd]').length == 0 ){
		alert('참여사를 선택하세요.');
		$('#rivalBtn').focus();
		return;
	}
	*/
	
	if( $('#otDt').val()=='' ){
		alert('OT일을 선택하세요.');
		$('#otDt').focus();
		return;
	}
	
	if( $('#ptDt').val()=='' ){
		alert('PT일을 선택하세요.');
		$('#ptDt').focus();
		return;
	}
	
	if( $('#ptTypCd').val()=='' ){
		alert('PT유형을 선택하세요.');
		$('#ptTypCd').focus();
		return;
	}
	
	/*
	if( $('#adBudget').val()=='' ){
		alert('광고예산을 입력하세요.');
		$('#adBudget').focus();
		return;
	}
	*/
	
	if( $('#coAttend').val()=='' ){
		alert('PT 참여자를 입력하세요.');
		$('#coAttend').focus();
		return;
	}
	
	if( $('#adAttend').val()=='' ){
		alert('광고주담당자를 입력하세요.');
		$('#adAttend').focus();
		return;
	}
	
	/*
	if( $('#contStartDt').val()=='' ){
		alert('계약시작일을 선택하세요.');
		$('#contStartDt').focus();
		return;
	}
	
	if( $('#contEndDt').val()=='' ){
		alert('계약종료일을 선택하세요.');
		$('#contEndDt').focus();
		return;
	}
	
	if( $('#evalStand').val()=='' ){
		alert('평가기준을 입력하세요.');
		$('#evalStand').focus();
		return;
	}
*/

	if( $('#ptCont').val()=='' ){
		alert('PT과제를 입력하세요.');
		$('#ptCont').focus();
		return;
	}
	
	if( $('input[name=ptResultCd]:checked').length == 0 ){
		alert('PT결과를 선택하세요.');
		$('input[name=ptResultCd]').eq(0).focus();
		return;
	}
	
	// 제출인 경우
	if(isSubmit){

		// 결과대기중 상태에서 제출불가
		if($('input[name=ptResultCd]:checked').val()=='PTR_W'){
			alert('결과대기중 상태에서는 제출하실 수 없습니다.');
			$('input[name=ptResultCd]').eq(0).focus();
			return;
		}

		if($('input[name=ATT_PT_01]').length==0){
			alert('광고주 OT과제를 첨부 하세요.');
			$('#result-comp1').focus();
			return;		
		}

		
		if($('input[name=ATT_PT_05]').length==0){
			alert('제출용 기획서를 첨부 하세요.');
			$('#result-comp5').focus();
			return;		
		}
	}
	
	if($('#docOpenDt').val()==''){
		alert('문서공개일을 선택하세요.');
		$('#result-comp5').focus();
		return;			
	}
	
	if(!isSubmit){
		if(!confirm('저장하시겠습니까?')) return;
	}
	if(isSubmit){
		if(!confirm('한번 제출하면 수정하실 수 없습니다.\n제출 하시겠습니까?')) return;
		$('#submitYn').val('Y');
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/pt/ptUpdateAction.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('저장되었습니다.');
				goList();
			}
			else{
				alert(data.msg);
				$('#submitYn').val("<c:out value='${pt.SUBMIT_YN}'/>");
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
			$('#submitYn').val("<c:out value='${pt.SUBMIT_YN}'/>");
		}
	});
	
}

function goList(){
	$('#searchForm').submit();
}

function popClientList(){
	window.open('/popup/popClientList.do', 'popup', 'width=450, height=670, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
}

// 팝업 콜백
function selectClient(clientCd, clientNm){
	$('#spanClient').html(
			'<span class="mTx01">'
				+ ' <input type="hidden" name="clientCd" value="'+clientCd+'"/> '
				+ clientNm 
				+ " <button type='button' onclick='removeSelect(this);'> <img src='/resources/images/btn_del.png' alt='삭제'></button> " 
			+ '</span>'
	);
}

function popRivalList(){
	window.open('/popup/popRivalList.do?spanId=spanRival', 'popup', 'width=450, height=670, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
}

// 팝업 콜백
function selectRival(spanId, rivals){
	$(rivals).each(function(){
		
		// 중복 제거
		var dup = $('input[name=rivalCd][value='+$(this).val()+']');
		if(dup.length==0){
			$('#'+spanId).append(
				'<span class="mTx01">'
					+ '<input type="hidden" name="rivalCd" value="'+$(this).val()+'"/>'
					+ $(this).attr('rivalNm') 
					+ " <button type='button' onclick='removeSelect(this);'><img src='/resources/images/btn_del.png' alt='삭제'></button>" 
				+ ' </span>'
			);
		}
	});
}

function removeSelect(obj){
	if(!confirm('제거 하시겠습니까?')){
		return;
	}
	$(obj).parent().remove();
}

function upload(spanId, obj){
	
	var file = $(obj).parent().find('input[type=file]');
	var newFile = file.clone();
	
	var filePath = $(file).val();
	if(filePath==''){
		alert('업로드할 파일을 선택해 주세요.');
		$(file).focus();
		return;
	}
	//그림 매니저 수정 사항
	if(filePath.lastIndexOf(".")>-1){
		var ext = filePath.substring(filePath.lastIndexOf(".")+1).toLowerCase();

		if(spanId == 'ATT_PT_06'){
			if(
					ext=='avi' || ext=='mp4' || ext=='wmv' || ext=='mpg' || ext=='mpeg' || ext=='mov' 
					|| ext=='jpg' || ext=='png' || ext=='jpeg' || ext=='gif' || ext=='bmp'){
			
			}else{
				alert('제작 시안은 이미지 또는 동영상 파일만 업로드 가능합니다.');
				$(file).focus();
				return;
			}
		}else{
			if(ext=='pdf'){
			}else{
				alert('허용된 파일형식이 아닙니다.pdf 파일만 업로드 가능합니다.');
				$(file).focus();
				return;
			}
		}
	}
	else{
		alert('허용된 파일형식이 아닙니다.');
		$(file).focus();
		return;
	}
	
	var form = $(
		"<form  action='/upload/uploadFile.do' target='hiddenFrame' method='POST' enctype='multipart/form-data' style='display:none'>"
		+	"<input type='hidden' name='spanId' value='"+spanId+"'/>"
		+ "</form>"
	);
	
	$(obj).parent().find('.upload-name').val('');
	$(file).parent().prepend(newFile);
	setFileEventLisner(newFile);
	file.attr('name','uploadFile');
	form.append(file);
	$(form).appendTo('body');
	$(form).submit();
	
	$(obj).parent().addClass('loading');
	$('.upload-hidden').attr('disabled','disabled');
	$('.filebox .btn').attr('disabled','disabled');
}

function setFileEventLisner(fileTarget){
	fileTarget.on('change', function(){  
		if(window.FileReader){  // modern browser
		  var filename = $(this)[0].files[0].name;
		} 
		else {  // old IE
		  var filename = $(this).val().split('/').pop().split('\\').pop();  
		}

		$(this).siblings('.upload-name').val(filename);	
	});
}

function uploadCallBack(spanId,uploadSeq,orgFileNm){
	
	var attach = $(
		"<span> "
		+	" <input type='hidden' name='"+spanId+"' value='"+uploadSeq+"'/> "
		+	orgFileNm
		+	" <button type='button' onclick='removeSelect(this);'><img src='/resources/images/btn_del.png' alt='삭제'></button> "
		+ " </span>"
	);
	
	// 복수개 선택
	if(spanId=='ATT_NORMAL'){
		$('#'+spanId).append(attach);
	}
	// 한개만 선택
	else{
		$('#'+spanId).html(attach);
	}
	
	$('.filebox').removeClass('loading');
	$('.upload-hidden').removeAttr('disabled');
	$('.filebox .btn').removeAttr('disabled');
}

//제출용 기획서 입력시 용량 안내 내용 alert 박그림 매니저 요청 사항 17.3.23
function eventMSG(){
	
	alert('제작 시안 외 모든 파일은  PDF 로 변환하여 업로드 하시기 바랍니다.');
}
</script>

<form id="searchForm" method="GET" action="/pt/ptList.do">
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/> 
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchBizCd" value="<c:out value='${params.searchBizCd}'/>"/>
	<input type="hidden" name="searchPtResultCd" value="<c:out value='${params.searchPtResultCd}'/>"/>
	<input type="hidden" name="searchRivalCd" value="<c:out value='${params.searchRivalCd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="ptId" value="<c:out value='${params.ptId}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<h2 class="mb60">PT Report</h2>

<form id="updateForm">
	<input type="hidden" id="ptId" name="ptId" value="<c:out value='${params.ptId}'/>"/>
<table class="tableComm mb30">
	<caption>PT Report 등록</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:35%;">
		<col style="width:10%;">
		<col style="width:15%;">
		<col style="width:10%;">
		<col style="width:15%;">
	</colgroup>
	<tbody>
		<tr>
			<th>제목 <span class="red">*</span> </th>
			<td colspan="5">
				<input type="text" id="title" name="title" value="<c:out value='${pt.TITLE}'/>" maxlength="100" style="width:98%;" placeholder="Client명을 포함하여 작성"/>
			</td>
		</tr>
		<tr>
			<th>Client명 <span class="red">*</span> </th>
			<td>
				<button type="button" id="clientBtn" class="btn btnSmall btnBlack">검색</button>
				<span id="spanClient">
					<c:if test="${not empty pt.CLIENT_CD}">
						<span class="mTx01">
							<input type="hidden" name="clientCd" value="<c:out value='${pt.CLIENT_CD}'/>"/>
							<c:out value="${pt.CLIENT_NM}"/> 
							<button type="button" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> 
						</span>					
					</c:if>
				</span>
			</td>
			<th>품목 <span class="red">*</span> </th>
			<td>
				<input type="text" id="item" name="item" value="<c:out value='${pt.ITEM}'/>" maxlength="100" style="width:85%;"/>
			</td>
			<th>업종 <span class="red">*</span> </th>
			<td>
				<select id="bizCd" name="bizCd" style="width:90px;">
					<option value="">선택</option>
					<c:forEach var="biz" items="${bizList}" varStatus="status">
						<option value='<c:out value="${biz.CD}"/>'><c:out value="${biz.NM}"/></option>
					</c:forEach>
				</select>
			</td>		
		</tr>
		<tr>
			<th>참여사</th>
			<td colspan="5">
				<button type="button" id="rivalBtn" class="btn btnSmall btnBlack">검색</button>
				<span id="spanRival">
					<c:forEach var="rival" items="${rivalList}" varStatus="status">
						<span class="mTx01">
							<input type="hidden" name="rivalCd" value="<c:out value='${rival.RIVAL_CD}'/>"/>
							<c:out value='${rival.RIVAL_NM}'/>
							<button type="button" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> 
						</span>
					</c:forEach>			
				</span>
			</td>
		</tr>
		<tr>
			<th>OT일 <span class="red">*</span> </th>
			<td>
				<input type="text" id="otDt" name="otDt" value="<fmt:formatDate value='${pt.OT_DT}' pattern='yyyy-MM-dd'/>" readOnly style="width:25%;"/>
			</td>
			<th>PT일 <span class="red">*</span> </th>
			<td>
				<input type="text" id="ptDt" name="ptDt" value="<fmt:formatDate value='${pt.PT_DT}' pattern='yyyy-MM-dd'/>" readOnly style="width:60%;"/>
			</td>
			<th>PT유형 <span class="red">*</span> </th>
			<td>
				<select id="ptTypCd" name="ptTypCd" style="width:90px;">
					<option value="">선택</option>
					<c:forEach var="ptTyp" items="${ptTypList}" varStatus="status">
						<option value='<c:out value="${ptTyp.CD}"/>'><c:out value="${ptTyp.NM}"/></option>
					</c:forEach>
				</select>
			</td>		
		</tr>
		<tr>
			<th>예산</th>
			<td colspan="5">
				<input type="text" id="adBudget" name="adBudget" value="<c:out value='${pt.AD_BUDGET}'/>" maxlength="100" style="width:300px;"/>
			</td>
		</tr>	
		<tr>
			<th>PT 참여자 <span class="red">*</span> </th>
			<td colspan="5">
				<textArea id="coAttend" name="coAttend" title="PT 참여자" style="width:96%; height:50px;" placeholder="[팀명] 이름, [팀명] 이름"><c:out value='${pt.CO_ATTEND}'/></textArea>
			</td>
		</tr>
		<tr>
			<th>광고주담당자 <span class="red">*</span> </th>
			<td colspan="5">
				<textArea id="adAttend" name="adAttend" title="광고주담당자" style="width:96%; height:50px;" placeholder="[팀명] 이름+직함, [팀명] 이름+직함"><c:out value='${pt.AD_ATTEND}'/></textArea>
			</td>
		</tr>	
		<tr>
			<th>계약기간</th>
			<td colspan="2">
				<input type="text" id="contStartDt" name="contStartDt" value="<fmt:formatDate value='${pt.CONT_START_DT}' pattern='yyyy-MM-dd'/>" readOnly style="width:32%;"/>
				~ <input type="text" id="contEndDt" name="contEndDt" value="<fmt:formatDate value='${pt.CONT_END_DT}' pattern='yyyy-MM-dd'/>" readOnly style="width:32%"/>
			</td>
			<th>평가기준</th>
			<td colspan="2">
				<input type="text" id="evalStand" name="evalStand" value="<c:out value='${pt.EVAL_STAND}'/>" maxlength="100" style="width:95.5%;" placeholder="예: 기술 70 / 금액 30"/>
			</td>		
		</tr>
	</tbody>
</table>	

<table class="tableComm mtable1 mb30">
	<caption>PT과제 및 기타사항</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
	<tr>
		<th>PT과제 <span class="red">*</span> </th>
		<td colspan="5">
			<textArea id="ptCont" name="ptCont" title="PT과제" style="width:96%; height:70px;" placeholder="개괄적인 PT과제 내용"><c:out value='${pt.PT_CONT}'/></textArea>
		</td>
	</tr>
	<tr>
		<th>기타사항</th>
		<td colspan="5">
			<textarea id="etcItem" name="etcItem" title="기타사항" style="width:96%; height:70px;" placeholder="PT과제 外 참고사항"><c:out value='${pt.ETC_ITEM}'/></textarea>
		</td>
	</tr>	
	</tbody>
</table>
<table>
	<tr>
		<td width="100px">
			<h3>결과 작성</h3>
		</td>
		<td>
			<h5><font style="color: #2E9AFE;">*제작 시안을 제외한 모든 파일은 PDF 로 업로드 바라며 ,
			<br/> &nbsp; 제작 시안(avi,mp4 등 동영상 파일)은 기획서와 분리하여 '제작 시안' 에 첨부하여 주십시오.</font></h5>
		</td>
	</tr>
</table>
<table class="tableComm mb15">
	<caption>결과 작성</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:50%;">
		<col style="width:15%;">
		<col style="width:20%;">
	</colgroup>
	<tbody>
		<tr>
			<th>PT 결과 <span class="red">*</span> </th>
			<td>
				<div class="inp-radio-set">	
					<c:forEach var="ptResult" items="${ptResultList}" varStatus="status">
						<div class="inp-radio">
							<input type="radio" id="ptResult_<c:out value='${status.index}'/>" name="ptResultCd" value="<c:out value='${ptResult.CD}'/>"/>
							<label for="ptResult_<c:out value='${status.index}'/>"><span class="box"></span> <c:out value='${ptResult.NM}'/></label>
						</div>
					</c:forEach>
				</div>
			</td>
			<th>선정 업체</th>
			<td><input type="text" id="optainCorp" name="optainCorp" value="<c:out value='${pt.OPTAIN_CORP}'/>" disabled style="width:95.5%;" placeholder="실패 시 수주업체 입력"/></td>		
		</tr>	
		<tr>
			<th>광고주 <br>feedback</th>
			<td colspan="3">
				<textArea id="feedback" name="feedback" style="width:96%; height:70px;" placeholder="PT 시 광고주 피드백 내용"><c:out value="${pt.FEEDBACK}"/></textArea>
			</td>
		</tr>
		<tr>
			<th>광고주 OT과제 <span class="red">*</span></th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp1" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp1" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_01',this);">저장</button>
				</div>
				<p id="ATT_PT_01" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_01'}">
							<span>
								<input type="hidden" name="ATT_PT_01" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>
		</tr>
		<tr>
			<th>Fact Book </th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp2" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp2" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_02',this);">저장</button>
				</div>
				<p id="ATT_PT_02" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_02'}">
							<span>
								<input type="hidden" name="ATT_PT_02" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>		
		</tr>
		<tr>
			<th>OT Brief</th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp3" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp3" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_03',this);">저장</button>
				</div>
				<p id="ATT_PT_03" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_03'}">
							<span>
								<input type="hidden" name="ATT_PT_03" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>		
		</tr>
		<tr>
			<th>발표용 기획서</th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp4" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp4" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_04',this);">저장</button>
				</div>
				<p id="ATT_PT_04" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_04'}">
							<span>
								<input type="hidden" name="ATT_PT_04" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>		
		</tr>	
		<tr>
			<th>제출용 기획서 <span class="red">*</span> </th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp5" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp5" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_05',this);">저장</button>
				</div>
				<p id="ATT_PT_05" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_05'}">
							<span>
								<input type="hidden" name="ATT_PT_05" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>		
		</tr>
		<tr>
			<th>제작 시안</th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp6" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp6" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_06',this);">저장</button>
				</div>
				<p id="ATT_PT_06" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_06'}">
							<span>
								<input type="hidden" name="ATT_PT_06" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>
		</tr>
		<tr>
			<th>기타</th>
			<td colspan="3">
				<div class="filebox">
					<input class="upload-name" value="" disabled="disabled">
					<label for="result-comp99" onclick="eventMSG();">파일첨부</label> 
					<input type="file" id="result-comp99" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_PT_99',this);">저장</button>
				</div>
				<p id="ATT_PT_99" class="file">
					<c:forEach var="att" items="${attList}" varStatus="status">
						<c:if test="${att.ATTACH_TYP eq 'ATT_PT_99'}">
							<span>
								<input type="hidden" name="ATT_PT_99" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
							</span>
						</c:if>			
					</c:forEach>
				</p>
			</td>
		</tr>	
	</tbody>		
</table>

<table class="tableComm mb15">
	<caption>결과 작성</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>Lesson<br>Learned</th>
			<td>
				<textarea style="width:96%; height:70px;" disabled placeholder=""><c:out value="${pt.LESSON_LEARNED}"/></textarea>
			</td>
		</tr>
	</tbody>
</table>

<div class="bx01 tac mb40">
	<strong class="black">문서공개일 설정 <span class="red">*</span></strong>
	<input type="text" id="docOpenDt" name="docOpenDt" value="<fmt:formatDate value='${pt.DOC_OPEN_DT}' pattern='yyyy-MM-dd'/>" style="width:25%;" readOnly>
</div>

<c:if test="${pt.REG_ID eq params.mid or pt.SUPER_YN eq 'Y'}">
<div class="tac mb30">
	
	<c:if test="${pt.SUBMIT_YN ne 'Y'}">
		<button type="button" id="updateBtn" class="btn btnMid btnBlue ml10" style="width:150px;">임시 저장</button>
		<input type="hidden" id="submitYn" name="submitYn" value="<c:out value='${pt.SUBMIT_YN}'/>">
		<button type="button" id="submitBtn" class="btn btnMid btnRed ml10" style="width:150px;">제출</button>
	</c:if>
	
	<c:if test="${pt.SUBMIT_YN eq 'Y' and pt.SUPER_YN eq 'Y'}">
		<button type="button" id="updateBtn" class="btn btnMid btnBlue ml10" style="width:150px;">저장</button>
	</c:if>
	
	
</div>
</c:if>

</form>

<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>

<%@include file="/WEB-INF/views/include/footer.jsp"%>