<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$(this).attr('title','수정 | 사용자 관리 | M-Library Admin');
	
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
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'], 
		buttonText: '날짜입력'
    });
	
	/* $("input[name=mid]").keyup(function(event){ 
		   if (!(event.keyCode >=37 && event.keyCode<=40)) {
		    var inputVal = $(this).val();
		    $(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
		   }
	 });
	 */	
	$('#mainBtn').click(function(){
		goMain();
	})
	$('#updateBtn').click(function(){
		update();
	});
	$('#updatePwinitBtn').click(function(){
		updatePwinit();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	//superadmin radio 스위칭처리
	/* $('input[type="checkbox"][name="swCheck"]').click(function(){
		if($(this).prop('checked')){
			$('input[type="checkbox"][name="swCheck"]').prop('checked',false);
			$(this).prop('checked',true);
		}
		});
		 */
});
//저장초기
function update(){
	/* 
	if( $('#mid').val() == '' ||  $('#mid').val()== null ){
		alert('사원ID를 입력하세요.'+$('#mid').val());
		$('#mid').focus();
		return;
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
		$("input[name=divCd]").val('${params.sTeamCd}');
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

	if( $('#memberNm').val()=='' ){
		alert('사원명을 입력하세요.');
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
	if($("#superY").is(":checked")){
		$("#superYn").val("Y");
	}else{
		$("#superYn").val("N");
	}
	
	if(!confirm('수정 하시겠습니까?')) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/member/memberUpdateAction.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('수정되었습니다.');
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


//패스워드 초기화
function updatePwinit(){

	//패스워드 초기화
	if(!confirm('패스워드를 초기화 하시겠습니까? \n패스워드는 생년월일 8 자리로 초기화 됩니다.' )) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	$.ajax({
		type : "POST",
		url : "/admin/member/memberUpdatepwinit.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('수정되었습니다.');
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
	
	/* $.ajax({
		type : "POST",
 		url : "/admin/member/memberUpdatepwinit.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('초기화 되었습니다.');
				goList();
			}
			else{
				alert(data.msg);
			}
		},
		error : function(request, status, errorThrown) {
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});	 */	
			
}	

function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/memberList.do');
	$('#searchForm').submit();
}
//본부변경
function changeCteamCdFunc() {
	
	$.ajax({
		type : "POST",
		url : "/admin/member/changeCteamAction.do",
		cache : false,
		async : false,
		data : $("#updateForm").serialize(),
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
	html += '<select title="검색범위선택" style="width:150px;" id="divCd" name="divCd">';
	html += '<option value="">없음</option>';
	$.each(retdata, function(index,entry){
		
		if(entry.CD == ''){
		}else{
			html += '<c:if test="${params.teamCd =='+entry.CD+'}">';
			html += '<option value="'+entry.CD+'" selected>' + entry.NM + '</option>';
			html += '	</c:if>';
			html += '<c:if test="${params.teamCd != '+entry.CD+'}">';
			html += '<option value="'+entry.CD+'">' + entry.NM + '</option>';
			html += '</c:if>';	
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
<form id="searchForm">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" id="mid" name="mid" value="<c:out value='${params.mid}'/>"/>
	<input type="hidden" id="searchType" name="searchType" value=""/>
	<input type="hidden" id="searchText" name="searchText" value=""/>
</form>

<form  name="updateForm" id="updateForm">
	<input type="hidden"  name="divCd" value=""/>
	<input type="hidden"  name="superYn" id="superYn" value=""/>
			<fieldset>
				<legend>사용자 정보 등록</legend>
			</fieldset>				
			
			<h3>구성원 정보 등록</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="mid"><strong class="tit02">아이디(사번)</strong></label>
						<input type="text" name="mid" id="mid" style="width:150px;" value="${resultMap.MID }" readOnly maxlength="7">
					</li>
					<li>
						<label for="birthDt"><strong class="tit02">생년월일<br>(YYYYMMDD)</strong></label>
						<input type="text" name="birthDt" id="birthDt" class="" style="width:150px;"  value='${resultMap.BIRTH_DT }' readOnly/>
						
					</li>
					<li>
						<label for="memberNm"><strong class="tit02">이름</strong></label>
						<input type="text" name="memberNm" id="memberNm" style="width:150px;" value="${resultMap.MEMBER_NM }" maxlength="20">
					</li>
					<li>
						<label for="email"><strong class="tit02">이메일</strong></label>
						<input type="text" name="email" id="email" style="width:150px;" value="${resultMap.EMAIL }" maxlength="40">
					</li>
				</ul>
			</div>
			
			<h3>구성원 소속 등록</h3>
			<div class="bx07 mb50">
				<ul class="admList admList02">
					<li class="div tac">
						<label for="cTeamCd"><strong class="tit01" >본부</strong></label>
						<select title="검색범위선택" style="width:150px;" id="cTeamCd" name="cTeamCd"  onChange="javascript:changeCteamCdFunc()">
							<option value="">없음</option>
							<c:forEach var="category" items="${cTeamCdList}" varStatus="status">
								<c:if test="${params.cTeamCd == category.CD}">
									<option value="${category.CD }" selected>${category.NM }</option>
								</c:if>
								<c:if test="${params.cTeamCd != category.CD}">
									<option value="${category.CD }">${category.NM }</option>
								</c:if>	
							</c:forEach>	
						</select>
					</li>
					<li class="div tac">
					<span id="ajaxReturn">
						<label for="divCd"><strong class="tit01">팀</strong></label>
						
						<select title="검색범위선택" style="width:150px;" id="divCd">
							<option value="">없음</option>		  
							<c:forEach var="category" items="${selectOnlyTeamCodeList}" varStatus="status">
								<c:if test="${params.teamCd == category.CD}">
									<option value="${category.CD }" selected>${category.NM }</option>
								</c:if>
								<c:if test="${params.teamCd != category.CD}">
									<option value="${category.CD }">${category.NM }</option>
								</c:if>	
							</c:forEach>	
						</select>
						
					</span>
					</li>
					<li class="tac">
						<label for="posCd"><strong class="tit01">직책</strong></label>
						<select title="검색범위선택" style="width:150px;" id="posCd" name="posCd">
							<c:forEach var="category" items="${posCdList}" varStatus="status">
								<c:if test="${resultMap.POS_CD == category.CD}">
									<option value="${category.CD }" selected>${category.NM }</option>
								</c:if>
								<c:if test="${resultMap.POS_CD != category.CD}">
									<option value="${category.CD }">${category.NM }</option>
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
						<c:choose>
							<c:when test="${resultMap.CR_APPOINT_YN eq 'Y' }">
								<input type="checkbox" name="crAppointYn" id="crAppointYn" checked>
								<label for="crAppointYn"><span class="box"></span> Credential 사용</label>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="crAppointYn" id="crAppointYn" >
							<label for="crAppointYn"><span class="box"></span> Credential 사용</label>
							</c:otherwise>
						</c:choose>
							
						</div>
					</li>
					<li class="tac">
						<div class="inp-check">
						<c:choose>
							<c:when test="${resultMap.KC_APPOINT_YN eq 'Y' }">
								<input type="checkbox" name="kcAppointYn" id="kcAppointYn" checked >
								<label for="kcAppointYn"><span class="box"></span> 지식채널 사용</label>
							</c:when>
							<c:otherwise>
								<input type="checkbox" name="kcAppointYn" id="kcAppointYn" >
								<label for="kcAppointYn"><span class="box"></span> 지식채널 사용</label>
							</c:otherwise>	
						</c:choose>	
						</div>
					</li>
					<li class="">
						<div class="inp-check">
							<c:choose>
								<c:when test="${resultMap.LOGIN_ABLE_YN  eq 'N' }">
									<input type="checkbox" name="loginAbleYn" id="loginAbleYn" checked>
									<label for="loginAbleYn"><span class="box"></span> 사용안함</label>
								</c:when>
								<c:otherwise>
									<input type="checkbox" name="loginAbleYn" id="loginAbleYn"  >
									<label for="loginAbleYn"><span class="box"></span> 사용안함</label>
								</c:otherwise>
							</c:choose>
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
								<c:if test="${resultMap.SUPER_YN  eq 'Y' }">
									<input type="radio" name="swCheck" id="superY" checked>
									<label for="superY"><span class="box"></span> 사용</label>
								</c:if>	
								<c:if test="${resultMap.SUPER_YN  ne 'Y' }">
									<input type="radio" name="swCheck" id="superY">
									<label for="superY"><span class="box"></span> 사용</label>
								</c:if>
								 </div> 
							</li>
							<li class="">
								 <div class="inp-radio">
								<c:if test="${resultMap.SUPER_YN  eq 'N' }">
									<input type="radio" name="swCheck" id="superN" checked>
									<label for="superN"><span class="box"></span> 사용안함</label>
								</c:if>	
								<c:if test="${resultMap.SUPER_YN  ne 'N' }">
									<input type="radio" name="swCheck" id="superN" >
									<label for="superN"><span class="box"></span> 사용안함</label>
								</c:if>
								 </div>
							</li>
						</ul>
					</div>	
				</div>
			

		</form>

			<div class="tac">
				<button type="button" class="btn btnMid btnBlue ml10" id="updateBtn" style="width:150px;">수정</button>
				<button type="button" class="btn btnMid btnBlue ml10" id="updatePwinitBtn" style="width:150px;">비밀번호초기화</button>
			</div>


		
 	</div>
	<!-- Container // -->



<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
