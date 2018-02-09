<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$(this).attr('title','리스트 | 사용자 관리 | M-Library Admin');
	
	
	//라디오버튼
	if("${params.CR_APPOINT_YN}" == "CR_APPOINT_Y" ){
		$('input[type="radio"][id="CR_APPOINT_Y"]').prop('checked',true);
	}else if("${params.CR_APPOINT_YN}" == "CR_APPOINT_N" ){
		$('input[type="radio"][id="CR_APPOINT_N"]').prop('checked',true);
	}
	
	if("${params.KC_APPOINT_YN}" == "KC_APPOINT_Y" ){
		$('input[type="radio"][id="KC_APPOINT_Y"]').prop('checked',true);
	}else if("${params.KC_APPOINT_YN}" == "KC_APPOINT_N" ){
		$('input[type="radio"][id="KC_APPOINT_N"]').prop('checked',true);
	}
	
	if("${params.LOGIN_ABLE_YN}" == "LOGIN_ABLE_Y" ){
		$('input[type="radio"][id="LOGIN_ABLE_Y"]').prop('checked',true);
	}else if("${params.LOGIN_ABLE_YN}" == "LOGIN_ABLE_N" ){
		$('input[type="radio"][id="LOGIN_ABLE_N"]').prop('checked',true);
	}
	
	
			
	//조회조건 콤보
	$('#searchType').val('<c:out value="${params.searchType}"/>');
	$('#searchType').msDropDown().data("dd").set("value", '<c:out value="${params.searchType}"/>');
	
	$('#ListSort').val('<c:out value="${params.searchSort}"/>');
	$('#searchSort').val('<c:out value="${params.searchSort}"/>');
	$('#ListSort').msDropDown().data("dd").set("value", '<c:out value="${params.searchSort}"/>');
	
	$('#searchText').val('<c:out value="${params.searchText}"/>');
	
	$('#ListSort').change(function(){
		$('#searchSort').val($('#ListSort').val());

		search();
	});
	
	$('#searchBtn').click(function(){
		$('#pageNo').val('1');
		search();
	});
	$('#insertBtn').click(function(){
		insert();
	});
	$('#excelBtn').click(function(){
		excel();
	});
});

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberList.do');
	$('#searchForm').submit();
}
function insert(){
	
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberInsert.do');
	$('#searchForm').submit();	
}
function view(mid,cTeamCd,teamCd,cTeam,sTeamCd){
	$('#mid').val(mid);
	$('#cTeamCd').val(cTeamCd);
	$('#sTeamCd').val(sTeamCd);
	$('#teamCd').val(teamCd);
	$('#cTeam').val(cTeam);
	
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberUpdate.do');
	$('#searchForm').submit();
}


//엑셀업로드
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
			 ext=='xls' || ext=='xlsx'){
		}else{
			alert('허용된 파일형식이 아닙니다.');
			$(file).focus();
		return;
		}
	}else{
		alert('허용된 파일형식이 아닙니다.');
		$(file).focus();
		return;
	}
	
	var form = $(
		 "<form  action='/admin/member/memberUploadFile.do' target='hiddenFrame' method='POST' enctype='multipart/form-data' style='display:none'>" 
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
 
function uploadCallBack(spanId,uploadSeq,orgFileNm,count){
	
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
	
	alert("총 "+count+"개의 데이터를 반영 하였습니다.");
	location.reload();
}
function uploadCallBackError(excelErrMsg){
	alert(excelErrMsg);
	

	$('.filebox').removeClass('loading');
	$('.upload-hidden').removeAttr('disabled');
	$('.filebox .btn').removeAttr('disabled');
	
}


function excel(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberListExcel.do');
	$('#searchForm').submit();		
}

</script>

<h2 class="mb50">사용자 관리</h2>

<form  name="searchForm" id="searchForm">
	
	<input type="hidden" id="cTeamCd" name="cTeamCd" value=""/>
	<input type="hidden" id="sTeamCd" name="sTeamCd" value=""/>
	<input type="hidden" id="teamCd" name="teamCd" value=""/>
	<input type="hidden" id="cTeam" name="cTeam" value=""/>
	
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
	<input type="hidden" id="mid" name="mid" value=""/>
	
	<input type="hidden" id="searchSort" name="searchSort" value=""/>
	<fieldset>
		<legend>사용자 관리</legend>
	</fieldset>				
	
	<!-- search box -->
	<div class="bx07 tac mb50">
		<strong class="tit01">조회</strong>
		<select id="searchType" name="searchType" title="검색범위선택" style="width:150px;">
			<option value="" selected>전체</option>
			<option value="regNm">이름</option>
			<option value="team">팀</option>
		</select>
		<input type="text" id="searchText" name="searchText" style="width:27%"  onKeyDown="if(event.keyCode == 13){$('#pageNo').val('1'); search();}"/>
		<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
		<br>
		<br>
		<strong class="tit01">Credential 권한</strong>
		<input type="radio" name="CR_APPOINT_YN" id="CR_APPOINT_ALL" checked value="">
		<label for="LOGIN_ABLE_ALL"><span class="box"></span> 전체</label>
		<input type="radio" name="CR_APPOINT_YN" id="CR_APPOINT_Y"  value="CR_APPOINT_Y">
		<label for="LOGIN_ABLE_Y"><span class="box"></span> 사용</label>
		<input type="radio" name="CR_APPOINT_YN" id="CR_APPOINT_N"  value="CR_APPOINT_N">
		<label for="LOGIN_ABLE_N"><span class="box"></span> 미사용</label>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<strong class="tit01">지식채널 권한</strong>
		<input type="radio" name="KC_APPOINT_YN" id="KC_APPOINT_ALL" checked value="">
		<label for="LOGIN_ABLE_ALL"><span class="box"></span> 전체</label>
		<input type="radio" name="KC_APPOINT_YN" id="KC_APPOINT_Y"  value="KC_APPOINT_Y">
		<label for="LOGIN_ABLE_Y"><span class="box"></span> 사용</label>
		<input type="radio" name="KC_APPOINT_YN" id="KC_APPOINT_N"  value="KC_APPOINT_N">
		<label for="LOGIN_ABLE_N"><span class="box"></span> 미사용</label>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<strong class="tit01">사용/정지</strong>
		<input type="radio" name="LOGIN_ABLE_YN" id="LOGIN_ABLE_ALL" checked value=""> 
		<label for="LOGIN_ABLE_ALL"><span class="box"></span> 전체</label>
		<input type="radio" name="LOGIN_ABLE_YN" id="LOGIN_ABLE_Y"  value="LOGIN_ABLE_Y">
		<label for="LOGIN_ABLE_Y"><span class="box"></span> 사용</label>
		<input type="radio" name="LOGIN_ABLE_YN" id="LOGIN_ABLE_N"  value="LOGIN_ABLE_N">
		<label for="LOGIN_ABLE_N"><span class="box"></span> 정지</label>
		
	</div>
	<!-- search box // -->
</form>

	<div>
		<table>
			<tr>
				<td><p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p></td>
				<td align="right">
					<strong class="tit01">정렬</strong>
					<select id="ListSort" name="ListSort" title="정렬구분선택" style="width:120px;">
						<option value="" selected>없음</option>
						<option value="MID">아이디</option>
						<option value="DIV_NM">팀</option>
						<option value="CR_APPOINT_YN">Credential 권한</option>
						<option value="KC_APPOINT_YN">지식채널권한</option>
						<option value="LOGIN_ABLE_YN">사용/정지</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
	<table class="tableComm table1 tableType1 mb50">
		<caption class="">사용자 관리 리스트</caption>
		<colgroup>
			<!-- 2017-01-10 수정 -->
					<col style="width:9%;">
					<col style="width:6%;">
					<col style="width:8%;">
					<col style="width:18%;">
					<col style="width:7%;">
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:10%;">
					<col style="width:8%;">
					<col style="width:8%;">
					<col style="width:6%;">
					<!-- 2017-01-10 수정 // -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">생년월일</th>
				<th scope="col">이메일</th>
				<th scope="col">직책</th>
				<th scope="col">부문</th>
				<th scope="col">본부</th>
				<th scope="col">팀</th>
				<th scope="col">Credential<br>권한</th>
				<th scope="col">지식채널<br>권한</th>
				<th scope="col">사용/정지</th>
				
				
			</tr>
		</thead>
		<tbody>		
			<c:forEach var="result" items="${listPage.list}" varStatus="status">
				<tr>
					<td><a href="javascript:view('${result.MID}','${result.C_TEAM_CD }','${result.TEAM_CD }','${result.C_TEAM }','${result.S_TEAM_CD }')"><c:out value="${result.MID }"/></a>	</td>
					<td><a href="javascript:view('${result.MID}','${result.C_TEAM_CD }','${result.TEAM_CD }','${result.C_TEAM }','${result.S_TEAM_CD }')"><c:out value="${result.MEMBER_NM }"/></a>	</td>
										
					<td><fmt:formatDate value='${result.BIRTH_DT}' pattern="yyyy-MM-dd"/></td> 
					 
					<td><c:out value="${result.EMAIL }"/></td>
					<td><c:out value="${result.POS_NM }"/></td>
					<td><c:out value="${result.S_TEAM }"/></td>
					<td><c:out value="${result.C_TEAM }"/></td>
					<td><c:out value="${result.TEAM }"/></td>
					<td><c:out value="${result.CR_APPOINT_YN }"/></td>
					<td><c:out value="${result.KC_APPOINT_YN }"/></td>
					
					<c:if test="${result.LOGIN_ABLE_YN eq 'Y' }">
						<td><c:out value="사용"/></td>
					</c:if>
					<c:if test="${result.LOGIN_ABLE_YN ne 'Y' }">
						<td><c:out value="정지"/></td>
					</c:if>
				</tr>	
			</c:forEach>
			<c:if test="${empty listPage.list}">
				<tr>
					<td colspan="11" align="center">검색 결과가 없습니다.</td>
				</tr>
			</c:if> 
		</tbody>
	</table>
<div class="paging">	<c:out value="${listPage.pageString}" escapeXml="false" /></div>

	<h2 class="mb20">사용자 등록</h2>
	<table class="tableComm mb15">
		<caption>사용자 등록</caption>
		<colgroup>
			<col style="width:20%;">
			<col style="width:80%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">구성원 등록(소수)</th>
				<td>
					<button type="button" class="btn btnSmall btnBlue"  id="insertBtn" >등록</button>
				</td>
			</tr>
			<tr>
				<th scope="row">다수 구성원 업로드(다수)</th>
				<td>
					<div class="filebox">	
					  <input class="upload-name" value="" disabled="disabled">
					  <label for="result-comp3">엑셀 업로드</label> 
					  <input type="file" id="result-comp3" class="upload-hidden"/>
					  <button type="button" class="btn btnSmall btnRed ml2" onclick="upload('ATT_NORMAL',this);">저장</button>
					</div>
				</td>
			</tr>
	</tbody>
	</table>

	<a href='/resources/data/excelSample1.xls'><button type="button" class="btn btn05 mb40" >엑셀 서식 다운로드</button></a>
	<button type="button" id="excelBtn" class="btn btn05">구성원 다운로드</button> 
	<span id="ATT_NORMAL"></span>

<iframe id="hiddenFrame" name="hiddenFrame" style="display:none"></iframe>

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
