<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	$(this).attr('title','등록 | ADMIN 사용자 관리 | M-Library Admin');
	
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
	//admin radio 스위칭처리
	/* $('input[type="checkbox"][name="swCheck"]').click(function(){
		if($(this).prop('checked')){
			$('input[type="checkbox"][name="swCheck"]').prop('checked',false);
			$(this).prop('checked',true);
		}
	}); */
	$("#mid").change(function(){
		
		// 세션체크
		if( sessionCheck() == false ) { sessionOut(); return; }
		
		$.ajax({
			type : "POST",
			 url : "/admin/member/admMidCheckAction.do", 
			cache : false,
			async : false,
			data : $("#insertForm").serialize(),
			dataType : "json",				
			success : function(data) {		
				if(data){
			
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
		
	});	
});	

//저장초기
function insert(){
	
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
	
	if( $('#mid').val()=='' ||  $('#mid').val()== null ){
		alert('사원ID를 입력하세요.'+$('#mid').val());
		$('#mid').focus();
		return;
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
		  alert("비밀번호 길이는  8~20자리  입니다.");
		  $('#passwd').focus();
		  return false;
		 }
		 if(pw.search(/₩s/) != -1){
		  alert("비밀번호에는  공백이 들어갈수 없습니다..");
		  $('#passwd').focus();
		  return false;
		 } 
		 if(num < 0){
		  alert("비밀번호 입력은 영문/숫자/특수문자 혼합 사용입니다.");
		  $('#passwd').focus();
		  return false;
		 }
		 if(eng < 0){
			 alert("비밀번호 입력은 영문/숫자/특수문자 혼합 사용입니다.");
			  $('#passwd').focus();
			  return false;
		 }
		 if(spe < 0 ){
			 alert("비밀번호 입력은 영문/숫자/특수문자 혼합 사용입니다.");
			  $('#passwd').focus();
			  return false;
		 }
	}//
	
	if($("#loginAbleY").is(":checked")){
		$('#loginAbleYn').val("Y");
	}else 	if($("#loginAbleN").is(":checked")){
		$('#loginAbleYn').val("N");
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/member/admMidCheckAction.do",
		cache : false,
		async : false,
		data : $("#insertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data){
				
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
	
	if(!confirm('입력 하시겠습니까?')) return;
	
	$.ajax({
		type : "POST",
		url : "/admin/member/admMemberInsertAction.do",
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
	$('#searchForm').prop('action','/admin/member/admMemberList.do');
	$('#searchForm').submit();
}


</script>

<form  action="" name=searchForm id="searchForm">
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>	
</form>		
		<h2 class="mb50">ADMIN 사용자 관리</h2>

		<form  action="" name="insertForm" id="insertForm">
			<input type="hidden" name="loginAbleYn" id="loginAbleYn" value="" >
			
			<fieldset>
				<legend>ADMIN 사용자 관리</legend>
			</fieldset>				
			
			<h3>ADMIN 사용자 등록 정보</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="memberNm"><strong class="tit02">이름</strong></label>
						<input type="text" name="memberNm" id="memberNm" style="width:50%;" value=""  maxlength="20">
					</li>
					<li>
						<label for="email"><strong class="tit02">이메일</strong></label>
						<input type="text" name="email" id="email" style="width:50%;" value=""  maxlength="40">
					</li>
				</ul>
			</div>
			
			<h3>ADMIN 설정 정보</h3>
			<div class="bx07 mb50">
				<ul class="admList admList01">
					<li>
						<label for="mid"><strong class="tit02">아이디</strong></label>
						<input type="text" name="mid" id="mid" style="width:50%;" value=""  maxlength="20">
					</li>
					<li>
						<label for="passwd"><strong class="tit02">비밀번호</strong></label>
						<input type="password"  id="passwd" name="passwd" class="" style="width:50%;" maxlength="20">	<!-- 2016-12-13 수정 -->
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
									<input type="radio" name="swCheck" id="loginAbleY" checked>
									<label for="loginAbleY"><span class="box"></span> 사용</label>
								 </div>
							</li>
							<li class="">
								 <div class="inp-radio">
									<input type="radio" name="swCheck" id="loginAbleN">
									<label for="loginAbleN"><span class="box"></span> 사용정지</label>
								 </div>
							</li>
						</ul>
					</div>
				</div>
				
			</div>
		</form>

			<div class="tac">
				<button type="button" class="btn btnMid btnGray ml10" id="insertBtn" style="width:150px;">저장</button>
			</div>

	<!-- Container // -->

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
