<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">

var oEditors = [];

$(document).ready(function(){
	$(this).attr('title','수정 | Trend Report | M-Library');
	
	$("#searchStart").datepicker({
        altFormat:  "yy-mm-dd",
        altField:   "#searchStart", // alt
        changeYear: true,
        yearRange:  "2010:2023",
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNamesMin:   ["일", "월", "화", "수", "목", "금", "토",]

    });
	$('#listBtn').click(function(){
		goList();
	});
	$('#mainBtn').click(function(){
		goMain();
	});
	$('#updateBtn').click(function(){
		update();
	});

	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	// 스마트 에디터 초기화
	initSE();
});//
function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/tr/trList.do');
	$('#searchForm').submit();
}

function goMain(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/main/main.do');
	$('#searchForm').submit();		
}
function update(){
	if( $('#title').val()=='' ){
		alert('제목을 입력하세요.');
		$('#title').focus();
		return;
	}

	$('#cont').val(oEditors.getById["ir1"].getIR());


	 if( $('#cont').val()=='<p><br></p>' ){
		alert('내용을 입력하세요.');
		$('#ir1').focus();
		return;
	} 
	
	/* 슈퍼어디민일경우  */
	if($("input:checkbox[id='impview']").is(":checked") == true   ){
			$("#topYn").val('Y');
	}else{
			$("#topYn").val('N');
	}
	
	if(!confirm('수정 하시겠습니까?')) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/tr/trUpdateAction.do",
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
			|| ext=='avi' || ext=='mpg' || ext=='mpeg' 
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
<h2 class="mb60">Trend Report </h2>

<form id="searchForm">
	<input type="hidden" id="bid" name="bid" value="${resultMap.BD_ID}">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	
	<input type="hidden" id="searchText" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" id="searchType" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" id="searchStart" name="searchStart" value="<c:out value='${params.searchStart}'/>"/>
	<input type="hidden" id="searchEnd" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" id="orderBy" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" id="sendTrCateCd" name="sendTrCateCd" value="<c:out value='${params.sendTrCateCd}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<form id="updateForm" >
	<input type="hidden" id="bdId" name="bdId" value="<c:out value='${resultMap.BD_ID }'/>"/>
	<input type="hidden" id="topYn" name="topYn" value=""/>
	
	
<table class="tableComm mb40">
	<caption>Trend Report</caption>
	<colgroup>
			<col style="width:15%;">
			<col style="width:20%;">
			<col style="width:15%;">
			<col style="width:20%;">
			<col style="width:15%;">
			<col style="width:auto;">
	</colgroup>
	<tbody >
			<tr>
				<th>제목 <span class="red">*</span></th>
				<td colspan="5">
					<input type="text" id="title" name="title"  maxlength="100" style="width:98%;" value="${resultMap.TITLE}">
				</td>
			</tr>
			<tr>
				<th>작성팀</th>
				<td>
					<c:out value="${resultMap.TEAM_NM}"/>	
				</td>
				<th>작성자</th>
				<td>
					<c:out value="${resultMap.MEMBER_NM}" />
				</td>
				<th>작성일</th>
				<td>	<fmt:formatDate value="${resultMap.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			</tr>	
			<tr>
				<th>카테고리</th>
				<td colspan="3">
						<select id="trCateCd" name="trCateCd" style="width:150px">
								<c:forEach var="category" items="${trCateCdList}" varStatus="status">
									<c:if test="${resultMap.TR_CATE_CD == category.CD}">
										<option value='${category.CD}' selected>${category.NM}</option>
									</c:if>
									<c:if test="${resultMap.TR_CATE_CD != category.CD}">
										<option value='${category.CD}'>${category.NM}</option>
									</c:if>
								</c:forEach>
						</select>
				</td>
				<th>조회수</th>
				<td>
					<c:out value="${resultMap.HIT}"/>
				</td>
			</tr>
			<c:if test="${params.superYn eq 'Y' }">	
					<tr>
						<th><strong class="red">중요 노출</strong></th>
						<td>
							<div class="inp-check">
							<c:if test="${resultMap.TOP_YN eq 'Y' }">
								<input type="checkbox" name="impview" id="impview" checked="checked">
							</c:if>	
							<c:if test="${resultMap.TOP_YN ne 'Y' }">
								<input type="checkbox" name="impview" id="impview">
							</c:if>
								<label for="impview"><span class="box"></span> 상단 중요 노출</label>
							</div>
						</td>
					</tr>
				</c:if>	
			<tr>
				<th>내용<span class="red">*</span> </th>
				<td colspan="5">
					<textArea style="width:100%; height:300px" id="ir1" rows="10" cols="100"><c:out value="${resultMap.CONT}" escapeXml="false"/></textArea>
					<input type="hidden" id="cont" name="cont" value=""/>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="5">
					<div class="filebox">
							<input class="upload-name" value="" disabled="disabled"  style="width:68.5%;"/>
							<label for="result-comp">파일첨부</label> 
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
<div class="tac">
	<button type="button" class="btn btnMid btnBlue" id="updateBtn" style="width:150px;">저장</button>
</div>



<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>

<%@include file="/WEB-INF/views/include/footer.jsp"%>