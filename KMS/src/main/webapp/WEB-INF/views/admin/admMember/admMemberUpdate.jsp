<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$(this).attr('title','수정 | ADMIN 사용자 관리 | M-Library Admin');
		
	$('#mainBtn').click(function(){
		goMain();
	})
	$('#updateBtn').click(function(){
		update();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	$('#passwd').click(function(){
		$('#passwd').val('');
	});
	
	//superadmin radio 스위칭처리
	/* $('input[type="checkbox"][name="swCheck"]').click(function(){
		if($(this).prop('checked')){
			$('input[type="checkbox"][name="swCheck"]').prop('checked',false);
			$(this).prop('checked',true);
		}
		}); */
		
});
//저장초기
function update(){
	
	
	if( $('#memberNm').val()=='' ){
		alert('사원명을 입력하세요.');
		$('#memberNm').focus();
		return;
	}
	if( $('#email').val()=='' ){
		alert('이메일을 입력하세요.');
		$('#email').focus();
		return;
	}	
	if( $('#passwd').val()=='PaSsWoRd' || $('#passwd').val()=='' || $('#passwd').val()==null){
		if(!confirm('비밀변호가 변경되지 않았습니다.기존 비밀변호를 사용하시겠습니까?')) {
			$('#passwd').focus();
			return;
		}
	}
	//암호설정
	var pw=$('#passwd').val();
	var num="";
	var eng="";
	var spe="";
	if( $('#passwd').val() =='' ){
		alert('비밀번호를 입력하세요.');
		$('#passwd').focus();
		return;
	}else{
		 num = pw.search(/[0-9]/g);
		 eng = pw.search(/[a-z]/ig);
		 spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
		 
		 if(pw.length < 8 || pw.length > 20){ 
		  alert("비밀번호 길이는 8~20 입니다..");
		  $('#passwd').focus();
		  return false;
		 }
		 if(pw.search(/₩s/) != -1){
		  alert("비밀번호에 공백이 들어갈수 없습니다.");
		  $('#passwd').focus();
		  return false;
		 } 
		 if(num < 0){
		  alert("비밀번호는  영문/숫자/특수문자 혼합 사용 입니다.");
		  $('#passwd').focus();
		  return false;
		 }
		 if(eng < 0){
			 alert("비밀번호는  영문/숫자/특수문자 혼합 사용 입니다.");
			  $('#passwd').focus();
			  return false;
		 }
		 if(spe < 0 ){
			 alert("비밀번호는  영문/숫자/특수문자 혼합 사용 입니다.");
			  $('#passwd').focus();
			  return false;
		 }
	}//
	
	if($("#admY").is(":checked")){
		$("#loginAbleYn").val("Y");
	}else{
		$("#loginAbleYn").val("N");
	}
	
	$('#admPasswd').val($('#passwd').val());
	
	if(!confirm('수정 하시겠습니까?')) return;
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/member/admMemberUpdateAction.do",
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

function goList(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/member/admMemberList.do');
	$('#searchForm').submit();
}

</script>

<form id="searchForm">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
</form>

<form  name="updateForm" id="updateForm">
	<input type="hidden"  name="loginAbleYn" id="loginAbleYn" value=""/>
	<input type="hidden"  name="admPasswd" id="admPasswd" value=""/>
	<input type="hidden"  name="birthDt" id="birthDt" value="${resultMap.BIRTH_DT}"/>


		<h2 class="mb50">ADMIN 사용자 관리</h2>
			<fieldset>
				<legend>ADMIN 사용자 관리</legend>
			</fieldset>				
			
			<h3>ADMIN 사용자 등록 정보</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="memberNm"><strong class="tit02">이름</strong></label>
						<input type="text" name="memberNm" id="memberNm" style="width:50%;" value="${resultMap.MEMBER_NM }" maxlength="20">
					</li>
					<li>
						<label for="email"><strong class="tit02">이메일</strong></label>
						<input type="text" name="email" id="email" style="width:50%;" value="${resultMap.EMAIL }" maxlength="40">
					</li>
				</ul>
			</div>
			
			<h3>ADMIN 설정 정보</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="mid"><strong class="tit02">아이디</strong></label>
						<input type="text" name="mid" id="mid" style="width:50%;" value="${resultMap.MID }" readOnly>
					</li>
					<li>
						 <label for="passwd"><strong class="tit02">비밀번호</strong></label>
						<input type="password"  id="passwd" name="passwd" value="PaSsWoRd"  style="width:50%;"  maxlength="20">	<!-- 2016-12-13 수정 -->
					</li>
				</ul>
			</div>
			
			<!-- 2016-12-09 수정 -->
			<div class="adminHalf">
				<div class="fc">
						<h3>ADMIN 사용 권한</h3>
					<div class="bx07 mb50">
						<ul class="admList admList01">
							<li class="tar">
								 <div class="inp-radio mr50"> 
								
									<c:if test="${resultMap.LOGIN_ABLE_YN eq 'Y' }">
										<input type="radio" name="swCheck" id="admY" checked>
										<label for="admY"><span class="box"></span>사용</label>
									</c:if>
									<c:if test="${resultMap.LOGIN_ABLE_YN ne 'Y' }">
										<input type="radio" name="swCheck" id="admY" >
										<label for="admY"><span class="box"></span>사용</label>
									</c:if>
								 </div>
							</li>
							<li class="tal">
								<div class="inp-radio mr50"> 
								<c:if test="${resultMap.LOGIN_ABLE_YN eq 'N' }">
									<input type="radio" name="swCheck" id="admN" checked>
									<label for="admN"><span class="box"></span> 사용정지</label>
								</c:if>
								<c:if test="${resultMap.LOGIN_ABLE_YN ne 'N' }">
									<input type="radio" name="swCheck" id="admN">
									<label for="admN"><span class="box"></span> 사용정지</label>
								</c:if>	
								 </div> 
							</li>
						</ul>
					</div>
				</div>
				
			</div>
		</form>

			<div class="tac">
				 <button type="button" class="btn btnMid btnBlue ml10" id="updateBtn" style="width:150px;">수정</button>
			</div>



<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
