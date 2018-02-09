<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
var midName = "";
$(document).ready(function(){
	$(this).attr('title','등록 | 사용자 관리 | M-Library Admin');
	
	//이메일 추후 변경요청시 사용할것
	/* $('#selectEmail').change(function(){
		   $("#selectEmail option:selected").each(function () {
		        if($(this).val()== '1'){ //직접입력일 경우
		             $("#str_email02").val('');                        //값 초기화
		             $("#str_email02").attr("disabled",false); //활성화
		        }else{ //직접입력이 아닐경우
		             $("#str_email02").val($(this).text());      //선택값 입력
		             $("#str_email02").attr("disabled",true); //비활성화
		        }
		   });
		});

 */
		
	$('#searchType').val('<c:out value="${params.searchType}"/>');
	//$('#searchType').msDropDown().data("dd").set("value", '<c:out value="${params.searchType}"/>');  
	$('#searchText').val('<c:out value="${params.searchText}"/>');
	
	$("#birthDt").datepicker({
        dateFormat: "yymmdd",
        constrainInput: true,
        changeYear: true,
        changeMonth: true,
        yearRange:  "1940:2023",
        buttonImage: '/resources/images/icon_datepicker.png',
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNamesMin:   ["일", "월", "화", "수", "목", "금", "토",],
        showOn: 'both',
        buttonImage: '/resources/images/icon_datepicker.png',
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] 
    });
	
	$("input[name=mid]").keyup(function(event){ 
		   if (!(event.keyCode >=37 && event.keyCode<=40)) {
		    var inputVal = $(this).val();
		    $(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
		   }
	 });
	$('#mainBtn').click(function(){
		goMain();
	})
	$('#insertBtn').click(function(){
		insert();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});
	
//사원번호체크
function checkMidFunc(obj){
	midName = $(obj).val();
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/member/midCheckAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data){
					
			}
			else{
				midName = "";
				alert('동일한 사원ID가 존재합니다.');
				$('#mid').focus();
				return;
				
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});		
}
//저장초기
function insert(){
	$('#mid').val(midName);
	
	if( $('#mid').val()=='' ||  $('#mid').val()== null ){
		alert('사원ID를 입력하세요.'+$('#mid').val());
		$('#mid').focus();
		return;
	}
	 
	
	$.ajax({
		type : "POST",
		url : "/admin/member/midCheckAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data){
				goInsertAction();
			}
			else{
				alert('동일한 사원ID가 존재합니다.');
				$('#mid').focus();
				return;
				
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});		
}	

//저장
function goInsertAction(){	

	if( $('#birthDt').val()=='' ){
		alert('생일을 입력하세요.');
		$('#birthDt').focus();
		return;
	}
	if( $('#memberNm').val()=='' ){
		alert('이름을 입력하세요.');
		$('#memberNm').focus();
		return;
	}
	
	if( $('#email').val()=='' ){
		alert('이메일을 입력하세요.');
		$('#email').focus();
		return;
	}else{
		  var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		   if(!regEmail.test($('#email').val())) {
               alert('이메일 주소가 유효하지 않습니다');
               $('#email').focus();
               return false;
           }
	} 	
	/* 추후 이메일 입력형식을 바꿔달라 할때를 위한 준비 01 */
	/* if( $('#str_email01').val()=='' ){
		alert('이메일을 입력하세요.');
		$('#str_email01').focus();
		return;
	}else{
		var totMail = $('#str_email01').val()+"@"+$('#str_email02').val();
		  var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		   if( !regEmail.test(totMail) ) {
               alert('이메일 주소가 유효하지 않습니다');
               $('#str_email01').focus();
               return false;
           }
		   $('#str_email01').val(totMail);
	}
	 */
	
	//.본부장/부문장을 제외하곤 팀선택을 하게끔/구릅장/실장
	var ifPosCd = $("#posCd option:selected").val();
	var ifDivCd = $("#divCd option:selected").val();
	var ifCteamCd = $("#cTeamCd option:selected").val();
	
	
	if( ifPosCd == 'POS_00010' || ifPosCd == 'POS_00020' || ifPosCd == 'POS_00030' || ifPosCd == 'POS_00040'){
		
	}else if(ifDivCd == null || ifDivCd == '' || ifDivCd =='undefined'){
		alert("팀을 선택 하세요.");
		return;
	}
	//본부장/그룹장/실장이 본수선택을 안했을경우
	if(ifPosCd == 'POS_00020' || ifPosCd == 'POS_00030' || ifPosCd == 'POS_00040'){//본부장
		if(ifCteamCd == null || ifCteamCd == '' || ifCteamCd =='undefined'){
			alert("본부를 선택 하세요.");
			return;
		}
	}
	//직책이 본부장이거나부문장이면 수동으로 div_cd에 코드를 삽입하여 제어한다
	if(ifPosCd == 'POS_00020' || ifPosCd == 'POS_00030' || ifPosCd == 'POS_00040'){//본부장
		$("input[name=divCd]").val($("#cTeamCd").val());
	}else if(ifPosCd == 'POS_00010'){//부문장
		$("input[name=divCd]").val('SEC_00001');
	}else{
		$("input[name=divCd]").val(ifDivCd);
	}

	if($("#crAppointYn").is(":checked")){
		$("#crAppointYn").val("Y");
	}else{
		$("#crAppointYn").val("N");
	}
	if($("#kcAppointYn").is(":checked")){
		$("#kcAppointYn").val("Y");
	}else{
		$("#kcAppointYn").val("N");
	}
	if($("#loginAbleYn").is(":checked")){
		$("#loginAbleYn").val("N");
	}else{
		$("#loginAbleYn").val("Y");
	}
	if($("#superY").is(":checked")){
		$("#superYn").val("Y");
	}else{
		$("#superYn").val("N");
	}
	
	
	if(!confirm('입력 하시겠습니까?')) return;
	
	$.ajax({
		type : "POST",
		url : "/admin/member/memberInsertAction.do",
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
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberList.do');
	$('#searchForm').submit();
}
//본부변경
function changeCteamCdFunc(selectObj) {
	
	$.ajax({
		type : "POST",
		url : "/admin/member/changeCteamAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success :successFunc,
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});		
}

function successFunc(retdata){
	var html="";
	$("#ajaxReturn").empty();
	
	html += '<label for="divCd"><strong class="tit01">팀</strong></label>';
	html += '<select title="검색범위선택" style="width:200px;" id="divCd" name="divCd">';
	html += '<option value="">없음</option>';
	$.each(retdata, function(index,entry){
		
		if(entry.CD == ''){
		}else{
			html += '<option value="'+entry.CD+'">' + entry.NM + '</option>';	
		}
		
	});
	html += '</select>';
	$('#ajaxReturn').html(html);
	
	$('#divCd').msDropDown();
}



</script>


	<!-- Container -->
	 <div class="container admin">
		<h2 class="mb50">사용자 관리</h2>
<form id="searchForm" name="searchForm">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" id="mid" name="mid" value="<c:out value='${params.mid}'/>"/>
	<input type="hidden" id="searchType" name="searchType" value=""/>
	<input type="hidden" id="searchText" name="searchText" value=""/>
</form>
<form  name="insertForm" id="insertForm">
	<input type="hidden"  name="divCd" value=""/>
	<input type="hidden"  name="superYn" id="superYn" value=""/>
	<!-- 다른 이메일기능 사용시01 -->
	<!-- <input type="hidden"  name="email" id="email" value=""/> -->
			<fieldset>
				<legend>사용자 정보 등록</legend>
			</fieldset>				
			
			<h3>구성원 정보 등록</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="mid"><strong class="tit02">아이디(사번)</strong></label>
						<input type="text" name="mid" id="mid" style="width:200px;" value="" onblur="checkMidFunc(this)"  maxlength="20" >
					</li>
					<li >
						<label for="birthDt"><strong class="tit02">생년월일<br>(YYYYMMDD)</strong></label>
						<input type="text" name="birthDt" id="birthDt" class="" style="width:200px;" value="" readOnly >
					</li>
					<li>
						<label for="memberNm"><strong class="tit02">이름</strong></label>
						<input type="text" name="memberNm" id="memberNm" style="width:200px;" value=""  maxlength="20">
					</li>
 					<li>
						<label for="email"><strong class="tit02">이메일</strong></label>
						<input type="text" name="email" id="email" style="width:200px;" value=""  style="ime-mode: disabled;"  maxlength="40">
					</li>
					
 					<!-- 추후 이메일 형식의 변경 요청이 들어올때를 위한 준비01 -->
<!--  					<li>
 						<label for="email"><strong class="tit02">이메일</strong></label>
 						<input type="text" name="str_email01" id="str_email01" style="width:120px"> @
						<input type="text" name="str_email02" id="str_email02" style="width:120px;" disabled value="naver.com">
						<select style="width:120px;margin-right:10px" name="selectEmail" id="selectEmail">
						     <option value="1">직접입력</option>
							<option value="naver.com" selected>naver.com</option>
						     <option value="hanmail.net">hanmail.net</option>
						     <option value="hotmail.com">hotmail.com</option>
						     <option value="nate.com">nate.com</option>
						     <option value="yahoo.co.kr">yahoo.co.kr</option>
							<option value="empas.com">empas.com</option>
						     <option value="dreamwiz.com">dreamwiz.com</option>
						     <option value="freechal.com">freechal.com</option>
						     <option value="lycos.co.kr">lycos.co.kr</option>
						     <option value="korea.com">korea.com</option>
							<option value="gmail.com">gmail.com</option>
						     <option value="hanmir.com">hanmir.com</option>
						     <option value="paran.com">paran.com</option>
						</select>
 					</li>
 -->				</ul>
			</div>
			
			<h3>구성원 소속 등록</h3>
			<div class="bx07 mb50">
				<ul class="admList admList02">
					<li class="div tac">
						<label for="cTeamCd"><strong class="tit01" >본부</strong></label>
						<select title="검색범위선택" style="width:200px;" id="cTeamCd" name="cTeamCd" onChange="javascript:changeCteamCdFunc(this)">
								<option value="">없음</option>
							<c:forEach var="category" items="${cTeamCdList}" varStatus="status">
								 	<option value="${category.CD }">${category.NM }</option>
							</c:forEach>	
						</select>
					</li>
					<li class="div tac">
					<span id="ajaxReturn">
						<label for="divCd"><strong class="tit01">팀</strong></label>
						<select title="검색범위선택" style="width:200px;" id="divCd" name="divCd">
									  <option value="">없음</option>
						</select>
					</span>
					</li>
					<li class="tac">
						<label for="posCd"><strong class="tit01">직책</strong></label>
						<select title="검색범위선택" style="width:150px;" id="posCd" name="posCd">
							<c:forEach var="category" items="${posCdList}" varStatus="status">
							<c:if test="${params.posCd eq category.CD }">
									<option value="${category.CD }" selected>${category.NM }</option>
							</c:if>		
							<c:if test="${params.posCd ne category.CD }">
									<option value="${category.CD }" >${category.NM }</option>
							</c:if>
							</c:forEach>		
						</select>
					</li>
				</ul>
			</div>

			<h3>등록 권한</h3>
			<div class="bx07 mb50">
				<ul class="admList admList02">
					<li class="tar">
						<div class="inp-check">
							<input type="checkbox" name="crAppointYn" id="crAppointYn" >
							<label for="crAppointYn"><span class="box"></span> Credential 사용</label>
							
						</div>
					</li>
					<li class="tac">
						<div class="inp-check">
								<input type="checkbox" name="kcAppointYn" id="kcAppointYn" >
								<label for="kcAppointYn"><span class="box"></span> 지식채널 사용</label>
						</div>
					</li>
					<li class="">
						<div class="inp-check">
									<input type="checkbox" name="loginAbleYn" id="loginAbleYn" >
									<label for="loginAbleYn"><span class="box"></span> 사용안함</label>
						</div>
					</li>
				</ul>
			</div>
			<div class="fr">
					<h3 class="red">SUPER ADMIN 권한 설정</h3>
					<div class="bx07 mb50">
						<ul class="admList admList01">
							<li class="tar">
								 <div class="inp-radio mr50">
									<input type="radio" name="swCheck" id="superY">
									<label for="superY"><span class="box"></span> 사용</label>
								 </div>
							</li>
							<li class="">
								 <div class="inp-radio"> 
									<input type="radio" name="swCheck" id="superN" checked>
									<label for="superN"><span class="box"></span> 사용안함</label>
								 </div>
							</li>
						</ul>
					</div>	
				</div>


		</form>

			<div class="tac">
				<button type="button" class="btn btnMid btnGray ml10" id="insertBtn" style="width:150px;">저장</button>
			</div>


		
 	</div>
	<!-- Container // -->



<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
