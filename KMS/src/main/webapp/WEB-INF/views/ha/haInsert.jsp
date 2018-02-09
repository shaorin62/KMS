<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];
 
$(document).ready(function(){
	$(this).attr('title','등록 | History Archive | M-Library');
	
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
	
	$("#insertBtn").click(function(){
		insert();
	});
	
	$("#haCateCd").change(function(){
		onCateChange();
	});
	
	$('#haCateCd').val('<c:out value="${params.haCateCd}"/>');
	$('#haCateCd').msDropDown().data("dd").set("value", '<c:out value="${params.haCateCd}"/>');

	// 스마트 에디터 초기화
	initSE();
	
	setLayer();

});//

function insert(){

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
	
	if(!confirm("저장하시겠습니까?")) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/ha/haInsertAction.do",
		cache:false,
		async:false,
		data:$("#insertForm").serialize(),
		dataType:"json",
		success : function(data){
			if(data.result=='true'){
				alert("저장되었습니다");
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
	
function goList(){
	$('#searchForm').prop('method','GET');
	$("#searchForm").prop("action","/ha/haList.do");
	$("#searchForm").submit();
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

//에디터
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

//파일업로드관련
function removeSelect(obj){
	if(!confirm('제거 하시겠습니까?')){
		return;
	}
	$(obj).parent().remove();
}

function upload(spanId,obj){
	$(".upload-name").val("");
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
			|| ext=='avi' || ext=='mpg' || ext=='mpeg' || ext=='mov' || ext=='mp4' || ext=='wmv' || ext=='hwp'
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
	
	var attach = $(
		"<span> "
		+	" <input type='hidden' name='"+spanId+"' value='"+uploadSeq+"'/> "
		+	orgFileNm
		+" <button type='button' title='삭제' onclick='removeSelect(this);'><img src='/resources/images/btn_del.png' alt='삭제'></button> "
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

function setLayer(){
	
	// 영상/인쇄 이면
	if($('#haCateCd').val()=='HAC_00001'){

		// 영상/인쇄 입력영역 활성화
		$('#trCate').siblings().each(function(){
			$(this).show();
			$(this).find('input, select').removeAttr('disabled');
		});

		// 내용 비활성화
		$('#cont').parent().parent().hide();
		$('#cont').attr("disabled","disabled");
		
		// 제목 플레이스 홀더
		$('#title').attr('placeholder','SK텔레콤 기업PR 하반기 캠페인');
		
		// 첨부파일 필수
		$('#attStar').show();
		
		$('#fileDesc').html('※ 맨 처음 등록된 파일이 리스트에 게시됩니다.');
	}
	else{
		
		// 영상/인쇄 입력영역 비활성화
		$('#trCate').siblings().each(function(){
			$(this).hide();
			$(this).find('input, select').attr('disabled','disabled');
		});

		// 내용 활성화
		$('#cont').parent().parent().show();
		$('#cont').removeAttr("disabled");
		
		// 제목 플레이스 홀더
		$('#title').attr('placeholder','SK텔레콤 기업PR 하반기 캠페인');
		
		// 첨부파일 필수 해제
		$('#attStar').hide();
		
		$('#fileDesc').html('&nbsp;');
	}
}

function onCateChange(){
	// 영상/인쇄 이면
	if($('#haCateCd').val()=='HAC_00001'){
		if($('#searchForm input[name=haCateCd]').val()!='HAC_00001'){
			$('#searchForm input[name=haCateCd]').val($("#haCateCd").val());
			$('#searchForm').attr('action','/ha/haInsert.do');
			$('#searchForm').submit();
		}
	}
	// 영상/인쇄가 아니면
	if($('#haCateCd').val()!='HAC_00001'){
			$('#searchForm input[name=haCateCd]').val($("#haCateCd").val());
			$('#searchForm').attr('action','/ha/haInsert.do');
			$('#searchForm').submit();
		//}
	}
}
</script>


<h2 class="mb60">History Archive</h2>

<form id="searchForm">
	<input type="hidden" name="haCateCd" value="<c:out value='${params.haCateCd}'/>"/>
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/>
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="searchMediaCd" value="<c:out value='${params.searchMediaCd}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<form name="insertForm" id="insertForm">

<table class="tableComm mb60">
	<caption>History Archive</caption>
	<colgroup>
	<c:if test="${params.haCateCd eq 'HAC_00001'}">
		<col style="width:16.3%;">
		<col style="width:35%;">
		<col style="width:15%;">
		<col style="width:35%;">

	</c:if>
	<c:if test="${params.haCateCd eq 'HAC_00002' || params.haCateCd eq 'HAC_00003' || params.haCateCd eq 'HAC_00004' || params.haCateCd eq 'HAC_00005'}">
		<col style="width:6.9%;">
		<col style="width:35%;">
		<col style="width:15%;">
		<col style="width:35%;">
	</c:if>
	</colgroup>
	<tbody>
		<tr id="trCate">
		<th >카테고리 <span class="red">*</span> </th>
			<td colspan="3">
				<select id="haCateCd" name="haCateCd" style="width:150px;" title="카테고리선택">
						<c:forEach var="category" items="${haCateCdList}" varStatus="status">
							<option value='<c:out value="${category.CD}"/>'><c:out value="${category.NM}"/></option>
						</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>Client명 <span class="red">*</span> </th>
			<td>
				<button type="button" id="clientBtn" class="btn btnSmall btnBlack">선택</button>
				<span id="spanClient">
				</span>				
			</td>
			<th>ON-Air <span class="red">*</span> </th>
			<td>
				<input type="text" id="onairStartDt" name="onairStartDt" style="width:35%;" readOnly/>
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
				</span>
			</td>
		</tr>
		<tr>
			<th>제작부서 <span class="red">*</span> </th>
			<td>
				<button type="button" id="prodTeamBtn" class="btn btnSmall btnBlack">선택</button>
				<span id="prodTeam">
				</span>
			</td>
			<th>프로덕션 </th>
			<td>
				<input type="text" id="productionCd" name="productionCd" style="width:94%;" placeholder="프로덕션명"/>
			</td>
		</tr>
	</tbody>
</table>



<table class="tableComm mb10">
	<caption>캠페인명 및 첨부파일</caption>
	<colgroup>
		<col style="width:10%;">
		<col style="width:50%;">
		<col style="width:15%;">
		<col style="width:20%;">

	</colgroup>
	<tbody>
	
		<tr>
		<c:if test="${params.haCateCd eq 'HAC_00004' || params.haCateCd eq 'HAC_00005'}">
			<th>제목 <span class="red">*</span> </th>
		</c:if>
		<c:if test="${params.haCateCd eq 'HAC_00003'}">
			<th>캠페인명 <span class="red">*</span> </th>
		</c:if>
			<td colspan="5"><input type="text" id="title" name="title" value="" maxlength="100" style="width:98%;"/>
			</td>
		</tr>
		<tr>
			<th>내용<span class="red">*</span> </th>
			<td>
				<textarea name="tr-feed" title="Trend Report 내용" id="ir1" style="width:96%; height:300px;"></textarea>
				<input type="hidden" id="cont" name="cont" value=""/>
			</td>
		</tr>
		<tr>
			<th rowspan="5">첨부파일<span id="attStar" class="red">*</span></th>
			<td>
				<div class="filebox">
				  <input class="upload-name"  value="" disabled="disabled" style="width:67.5%;"/>
				  
				  <label for="tr-comp1">파일첨부</label> 
				  <input type="file" id="tr-comp1" class="upload-hidden"/>
				  <button type="button" class="btn btnSmall btnRed ml2" onclick="upload('ATT_NORMAL',this);">저장</button>
				</div>
				<p id="ATT_NORMAL"></p>
			</td>
		</tr>
		
	</tbody>
</table>
</form>	
<p id="fileDesc" class="mb30">
	※ 맨 처음 등록된 파일이 리스트에 게시됩니다.
</p>
	
			<div class="tac">
				<button type="button" class="btn btnMid btnBlue" id="insertBtn" style="width:150px;">저장</button>
			</div>

<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>


<%@include file="/WEB-INF/views/include/footer.jsp"%>
