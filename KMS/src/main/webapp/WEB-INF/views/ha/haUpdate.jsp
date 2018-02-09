<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];

$(document).ready(function(){
	$(this).attr('title','수정 | History Archive | M-Library');
	
	$("#onairStartDt").datepicker({
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
	
	$('#clientBtn').click(function(){
		popClientList();
	});
	
	$('#planTeamBtn').click(function(){
		popTeamList('planTeam');
	});
	
	$('#prodTeamBtn').click(function(){
		popTeamList('prodTeam');
	});
	
	$('#updateBtn').click(function(){
		update();
	});

	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});

	// 영상/인쇄 이면
	if($('#haCateCd').val()=='HAC_00001'){
		$('#mediaCd').val('<c:out value="${ha.MEDIA_CD}"/>');
		$('#mediaCd').msDropDown().data("dd").set("value", '<c:out value="${ha.MEDIA_CD}"/>');
		
		// 제목 플레이스 홀더
		$('#title').attr('placeholder','SK텔레콤 기업PR 하반기 캠페인');
	}

	// 영상/인쇄가 아니면
	if($('#haCateCd').val()!='HAC_00001'){
		// 스마트 에디터 초기화
		initSE();		
		
		// 제목 플레이스 홀더
		$('#title').attr('placeholder','캠페인/행사명');
	}
});//


function update(){
	
	// 영상/인쇄 이면
	if($('#haCateCd').val()=='HAC_00001'){
		
		if($('input[name=clientCd]').length==0){
			alert('Client명을 선택하세요.');
			$('#clientBtn').focus();
			return;			
		}
		
		if( $('#onairStartDt').val()=='' ){
			alert('ON-Air 날짜를 선택하세요.');
			$('#onairStartDt').focus();
			return;
		}
		
		if( $('#mediaCd').val()=='' ){
			alert('매체를 선택하세요.');
			$('#mediaCd').focus();
			return;
		}
		
		if($('input[name=planTeam]').length==0){
			alert('기획부서를 선택하세요.');
			$('#planTeamBtn').focus();
			return;			
		}
		
		if($('input[name=prodTeam]').length==0){
			alert('제작부서를 선택하세요.');
			$('#prodTeamBtn').focus();
			return;			
		}
		
		/* if( $('#productionCd').val()=='' ){
			alert('프로덕션을 입력하세요.');
			$('#productionCd').focus();
			return;
		} */ 
	}
	
	if( $('#title').val()=='' ){
		alert('캠페인명을 입력하세요.');
		$('#title').focus();
		return;
	}

	// 영상/인쇄가 아니면
	if($('#haCateCd').val()!='HAC_00001'){
		$('#cont').val(oEditors.getById["ir1"].getIR());
		if( $('#cont').val()=='' || $('#cont').val()=='<p><br></p>' ){
			alert('내용을 입력하세요.');
			$('#ir1').focus();
			return;
		}
	}
	
	// 영상/인쇄 이면
	if($('#haCateCd').val()=='HAC_00001'){
		if($('input[name=ATT_NORMAL]').length==0){
			alert('파일을 첨부 하세요.');
			$('#result-comp').focus();
			return;		
		}
	}
	
	if(!confirm('수정 하시겠습니까?')) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/ha/haUpdateAction.do",
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
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});		
	
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
function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haList.do');
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

function popTeamList(spanId){
	window.open('/popup/popTeamList.do?spanId='+spanId, 'popup', 'width=450, height=670, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbars=yes');
}

// 팝업 콜백
function selectTeam(spanId, teamCd, teamNm){
	$('#'+spanId).html(
			'<span class="mTx01">'
				+ ' <input type="hidden" name="'+spanId+'" value="'+teamCd+'"/> '
				+ teamNm 
				+ " <button type='button' onclick='removeSelect(this);'> <img src='/resources/images/btn_del.png' alt='삭제'></button> " 
			+ '</span>'
	);
}

/* 파일업로드 */
function upload(spanId, obj){
	var NBID=$("#bid").val();
	
	var file = $(obj).parent().parent().find('input[type=file]');
	var newFile = file.clone();
	
	var filePath = $(file).val();
	if(filePath==''){
		alert('업로드할 파일을 선택해 주세요.');
		$(file).focus();
		return;
	}
	
	if(filePath.lastIndexOf(".")>-1){
		var ext = filePath.substring(filePath.lastIndexOf(".")+1).toLowerCase();

		if($('#haCateCd').val()=='HAC_00001'){
			if(ext=='avi' || ext=='mpg' || ext=='mpeg' || ext=='mov' || ext=='mp4' || ext=='wmv'){
				
			}
			else{
				alert('영상 파일만 업로드 하실수 있습니다.');
				$(file).focus();
				return;				
			}
		}		
		
		if(
			ext=='jpg' || ext=='png' || ext=='jpeg' || ext=='gif' || ext=='bmp'
			|| ext=='avi' || ext=='mpg' || ext=='mpeg' || ext=='mov' || ext=='mp4' || ext=='wmv'
			|| ext=='doc' || ext=='docx' || ext=='ppt' || ext=='pptx' || ext=='xls' || ext=='xlsx' || ext=='pdf'){
			
		}else{
			alert('허용된 파일형식이 아닙니다.');
			$(file).focus();
			return;
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
	var bid =  $("#bid").val();
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
//파일삭제

function removeSelect(obj){
	if(!confirm('제거 하시겠습니까?')){
		return;
	}
	$(obj).parent().remove();
}

</script>

<h2 class="mb60">History Archive</h2>

<form id="searchForm">
	<input type="hidden" id="haCateCd" name="haCateCd" value="<c:out value='${params.haCateCd}'/>"/>
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/>
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="searchMediaCd" value="<c:out value='${params.searchMediaCd}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<form id="updateForm" >
	<input type="hidden" id="haId" name="haId" value="<c:out value='${ha.HA_ID }'/>"/>

<c:if test="${ha.HA_CATE_CD eq 'HAC_00001'}">
<table class="tableComm mb60">
	<caption>History Archive</caption>
	<colgroup>
			<col style="width:6.5%;">
			<col style="width:35%;">
			<col style="width:15%;">
			<col style="width:35%;">
	</colgroup>
	<tbody>
		<tr id="trCate">
			<th>카테고리 <span class="red">*</span> </th>
			<td colspan="3">
				<c:out value="${ha.HA_CATE_NM}"/> 
			</td>
		</tr>	
		<tr>
			<th>Client명 <span class="red">*</span> </th>
			<td>
				<button type="button" id="clientBtn" class="btn btnSmall btnBlack">선택</button>
				<span id="spanClient">
					<c:if test="${not empty ha.CLIENT_CD}">
						<span class="mTx01">
							<input type="hidden" name="clientCd" value="<c:out value='${ha.CLIENT_CD}'/>"/>
							<c:out value="${ha.CLIENT_NM}"/> 
							<button type="button" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> 
						</span>					
					</c:if>
				</span>
			</td>
			<th>ON-Air <span class="red">*</span> </th>
			<td>
				<input type="text" id="onairStartDt" name="onairStartDt" style="width:35%;" value='<fmt:formatDate value="${ha.ONAIR_START_DT}" pattern="yyyy-MM-dd"/>' readOnly/>
			</td>
		</tr>
		<tr>
			<th>매체 <span class="red">*</span> </th>
			<td>
				<select id="mediaCd" name="mediaCd" title="업종" style="width:90px;">
					<option value="">선택</option>
					<c:forEach var="media" items="${mediaList}" varStatus="status">
						<option value="<c:out value='${media.CD}'/>"><c:out value='${media.NM}'/></option>
					</c:forEach>
				</select>
			</td>
			<th>기획부서 <span class="red">*</span></th>
			<td>
				<button type="button" id="planTeamBtn" class="btn btnSmall btnBlack">선택</button>
				<span id="planTeam">
					<c:if test="${not empty ha.PLAN_TEAM}">
						<span class="mTx01">
							<input type="hidden" name="planTeam" value="<c:out value='${ha.PLAN_TEAM}'/>"/>
							<c:out value="${ha.PLAN_TEAM_NM}"/> 
							<button type="button" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> 
						</span>					
					</c:if>
				</span>				
			</td>
		</tr>
		<tr>
			<th>제작부서 <span class="red">*</span> </th>
			<td>
				<button type="button" id="prodTeamBtn" class="btn btnSmall btnBlack">선택</button>
				<span id="prodTeam">
					<c:if test="${not empty ha.PROD_TEAM}">
						<span class="mTx01">
							<input type="hidden" name="prodTeam" value="<c:out value='${ha.PROD_TEAM}'/>"/>
							<c:out value="${ha.PROD_TEAM_NM}"/> 
							<button type="button" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> 
						</span>					
					</c:if>
				</span>	
			</td>
			<th>프로덕션</th>
			<td>
				<input type="text" id="productionCd" name="productionCd" style="width:94%;" placeholder="프로덕션명" value="<c:out value='${ha.PRODUCTION_CD}'/>">
			</td>
		</tr>
	</tbody>
</table>
</c:if>
	
<table class="tableComm mb10">
	<caption>캠페인명 및 첨부파일</caption>

	<colgroup>
			<col style="width:15%;">
			<col style="width:auto;">
			<!-- <col style="width:50%;">
			<col style="width:15%;">
			<col style="width:20%;"> -->
	</colgroup>
	<tbody>	
	<tr>
		<th>캠페인명 <span class="red">*</span> </th>
		<td colspan="3">
			<input type="text" id="title" name="title"  maxlength="100" style="width:98%;" value="${ha.TITLE}">
		</td>
	</tr>
	<c:if test="${ha.HA_CATE_CD ne 'HAC_00001'}">
		<tr>
			<th>내용<span class="red">*</span></th>
			<td colspan="3">
				<textArea style="width:100%; height:300px" id="ir1" rows="10" cols="100"><c:out value="${ha.CONT}" escapeXml="false"/></textArea>
				<input type="hidden" id="cont" name="cont" value=""/>
			</td>
		</tr>
	</c:if>
	<tr>
		<th>첨부파일 
			<c:if test="${ha.HA_CATE_CD eq 'HAC_00001'}">
				<span class="red">*</span>
			</c:if>
		</th>
		<td colspan="5">
			<div class="filebox">
					<input class="upload-name" value="" disabled="disabled" style="width:68.5%;"/>
					
					<label for="result-comp" >파일첨부</label> 
					<input type="file" id="result-comp" class="upload-hidden">
					<button type="button" class="btn btnSmall btnRed" onclick="upload('ATT_NORMAL',this);">저장</button>
			</div>
			<span id="ATT_NORMAL" class="file">
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_NORMAL'}">
						<span>
							<input type="hidden" name="ATT_NORMAL" value="<c:out value='${att.UPLOAD_SEQ}'/>"/>
								<c:out value="${att.ORG_FILE_NM}"/>
								
								<button type="button" title="삭제" onclick="removeSelect(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>
								</span>
						</c:if>			
				</c:forEach>
			</span>
		</td>
	</tr>
</tbody>
	</table>
</form>
<p id="fileDesc" class="mb30">
	<c:if test="${params.haCateCd eq 'HAC_00001'}">
	※ 맨 처음 등록된 파일이 리스트에 게시됩니다.
	</c:if>
	&nbsp;
</p>

<div class="tac">
	<button type="button" class="btn btnMid btnBlue" id="updateBtn" style="width:150px;">저장</button>
</div>




<form id="uploadForm">
	<input type="hidden" id="uploadSeq" name="uploadSeq" value=""/>
	<input type="hidden" id="spanId" name="spanId" value=""/>
	<input type="hidden" id="bid" name="bid" value="${ha.HA_ID}"/>
</form>
<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>

<%@include file="/WEB-INF/views/include/footer.jsp"%>