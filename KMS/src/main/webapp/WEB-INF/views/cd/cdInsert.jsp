<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];

$(document).ready(function(){
	$(this).attr('title','등록 | Credential | M-Library');
	
	$("#insertBtn").click(function(){
		insert();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});

	// 스마트 에디터 초기화
	initSE();
});//

function insert(){
	
	if( $('#title').val()=='' ){
		alert('제목을 입력하세요.');
		$('#title').focus();
		return;
	}
	
	
	//에디터내용가져오기
	$('#cont').val(oEditors.getById["ir1"].getIR());
	

	 if( $('#cont').val()=='<p><br></p>' ){
		alert('내용을 입력하세요.');
		$('#ir1').focus();
		return;
	} 
	
	
	if(!confirm("저장하시겠습니까?")) return;
	 
	if($("#trCateCd").val() == 'BIZ_00000'){
		$("#topYn").val('Y');
	}else{
		$("#topYn").val('N');
	}

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/cd/cdInsertAction.do",
		cache:false,
		async:false,
		data:$("#insertForm").serialize(),
		dataType:"json",
		success : function(data){
			if(data.result=='true'){
				alert("저장되었습니다");
				goTrList();
			}else{
				alert(data.msg);
			}
		},
		error:function(request,status,errorThrown){
			alert("시스템 오류입니다,잠시 후 다시 시도해 주세요.");
		}
	});
}
	

function goTrList(){
	$('#searchForm').prop('method','GET');
	$("#searchForm").prop("action","/cd/cdList.do");
	$("#searchForm").submit();
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

		if(
			ext=='jpg' || ext=='png' || ext=='jpeg' || ext=='gif' || ext=='bmp'
			|| ext=='avi' || ext=='mpg' || ext=='mpeg' || ext=='hwp'
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
		"<span>"
		+	"<input type='hidden' name='"+spanId+"' value='"+uploadSeq+"'/>"
		+	orgFileNm
		+"<button type='button' title='삭제' onclick='removeSelect(this);'><img src='/resources/images/btn_del.png' alt='삭제'></button>"
		+ "</span>"
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


</script>

<h2 class="mb60">Credential </h2>
 
<form id="searchForm" >
	<input type="hidden" id="mid" name="mid" value="<c:out value='${params.mid}'/>"/>
	
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${params.BD_ID }'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" id="sendTrCateCd" name="sendTrCateCd"  value="<c:out value='${params.pageNo}'/>"/>
	
</form>

<form name="insertForm" id="insertForm">
	<input type="hidden" id="topYn" name="topYn" value=""/>
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${params.bid}'/>"/>
	
	<table  class="tableComm mb30">
	<caption>Credential</caption>
		<colgroup>
			<col style="width:15%;">
			<col style="width:85%;">
		</colgroup>
		<tbody>
			<tr>
				<th>제목<span class="*"></span></th>
				<td>
				<input type="text" id="title" name="title" value="" maxlength="100" style="width:98%;"/>
				</td>
			</tr>
			<tr><th>업종<span class="*"></span></th>
				<td>
					<select id="trCateCd" name="trCateCd" style="width:150px">
						<option value="BIZ_00000">공통</option>
						<c:forEach var="category" items="${trCateCdList}" varStatus="status">
							<option value='<c:out value="${category.CD}"/>'><c:out value="${category.NM}"/></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>내용 <span class="red">*</span></th>
				<td>
					<textarea name="tr-feed" title="Trend Report 내용" id="ir1" style="width:96%; height:300px;"></textarea>
					<input type="hidden" id="cont" name="cont" value=""/>
				</td>
			</tr>
			<tr>
				<th rowspan="3">첨부파일</th>
				<td>
					<div class="filebox">
					  <input class="upload-name"  value="" disabled="disabled" style="width:68.3%;"/>
					  <label for="tr-comp1">파일첨부</label> 
					  <input type="file" id="tr-comp1" class="upload-hidden"/>
					  <button type="button" class="btn btnSmall btnRed ml2" onclick="upload('ATT_NORMAL',this);">저장</button>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<span id="ATT_NORMAL"></span>
				</td>
			</tr>
		</tbody>
	</table>
</form>

<div class="tac">
	<button type="button" class="btn btnMid btnBlue" id="insertBtn" style="width:150px;">저장</button>
</div>

<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>

<%@include file="/WEB-INF/views/include/footer.jsp"%>
