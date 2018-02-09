<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];

$(document).ready(function(){
	$(this).attr('title','등록 | 지식채널 | M-Library');
	
	$('#mainBtn').click(function(){
	goMain();
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
});//
//미리보기
function resetFormElement(e) {
e.wrap('<form>').closest('form').get(0).reset(); 
e.unwrap();
}

function goList(){
$('#searchForm').prop('method','GET');
$("#searchForm").prop("action","/kc/kcList.do");
$("#searchForm").submit();
}

function insert(){
	
	if( $('#title').val()=='' ){
		alert('제목을 입력하세요.');
		$('#title').focus();
		return;
	}
	
	
	 if( $('#cont').val()=='' ){
			alert('내용을 입력하세요.');
			$('#cont').focus();
			return;
		} 
	if( 
			$('#linkUrl').val()=='http://' 
			||  $('#linkUrl').val()=='https://' 
			||  $('#linkUrl').val()=='HTTP://' 
			||  $('#linkUrl').val()=='HTTPS://' 
			|| $('#linkUrl').val()==''
		){
		alert('URL을 입력하세요.');
		$('#linkUrl').focus();
		return;
	}
	if( $('input[type="hidden"][name="reView"]').val()=='' ){
		alert('썸네일을 등록하세요.');
		$('#upload-name').focus();
		return;
	}
	
	
	if(!confirm('입력 하시겠습니까?')) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/kc/kcInsertAction.do",
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
	
		if(
			ext=='jpg' || ext=='png' || ext=='jpeg' || ext=='gif' || ext=='bmp'
			){
			
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

function uploadCallBack(spanId,uploadSeq,orgFileNm,filePath){
	//일시정지
	var then,now;
	then=new Date().getTime();
	now=then;
	while((now-then)<1500){
		now=new Date().getTime();
	}
	
	$("#ATT_NORMAL").val(uploadSeq);
	$("#reView").val(uploadSeq);
	
	 var bid =  $("#bid").val();

	 var attach = $(
	 		"<span> "
	 		+ "<p class='pic'>"
	 		+  "<img src='/upload/"+filePath+"'  style='width:150px;height:100px;' >"
	 		+ "</p>"
	 		+	" <input type='hidden' name='"+spanId+"' value='"+uploadSeq+"'/> "
	 		+	orgFileNm
	 		+ " </span>"
	 		
	 	);
	 $('#'+spanId).html(attach);

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

<h2 class="mb60">지식채널</h2>
<form id="searchForm">
 	
</form>
<form name="oneImgForm" id="oneImgForm">
<input type="hidden" id="oneImgNo" name="oneImgNo" value=""/>
<input type="hidden" id="reView" name="reView" value=""/>
</form>

<form name="insertForm" id="insertForm">
<input type="hidden" id="bdId" name="bdId" value="<c:out value='${params.bid}'/>"/>

<table class="tableComm mb30">
	<caption>지식채널</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:85%;">
	</colgroup>
	<tbody>
		<tr>
			<th>제목 <span class="red">*</span></th>
			<td colspan="5"><input type="text" name="title" id="title" style="width:98%;"></td>
		</tr>
		<tr>
			<th>내용 <span class="red">*</span></th>
			<td>
				<textArea style="width:96.5%;  height:300px" id="cont" name="cont" rows="10" cols="100"></textarea>
				
			</td>
		</tr>
		<tr>
			<th>URL입력 <span class="red">*</span> </th>
			<td colspan="5"><input type ="text" id="linkUrl" name="linkUrl" maxlength="100" style="width:98%;" value="http://">	</td>
		</tr>
		
		<tr>
			<th>썸네일 등록 <span class="red">*</span> </th>
			<td>
				<div class="filebox">
					<input class="upload-name" id="upload-name" value="" disabled="disabled" style="width:68%;">
					<label for="tr-comp1">파일첨부</label> 
					<input type="file" id="tr-comp1" class="upload-hidden" />
					<button type="button" class="btn btnSmall btnRed ml2" onclick="upload('ATT_NORMAL',this);">저장</button>
				</div>
				
			</td>
		</tr>
		<tr>
			<th style="height:100px;">미리보기</th>
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