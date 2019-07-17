<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>비밀번호 재설정 | M-Library</title>

	<!-- MNS Guide -->
	<link rel="stylesheet" type="text/css" href="/resources/css/base.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/jquery.bxslider.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/layout.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/contents.css">

	<script type="text/javascript" src="/resources/vendor/jquery/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/layout.js"></script>

	<!-- selectbox -->
	<script type="text/javascript" src="/resources/js/jquery.dd.js"></script>
	
</head>

<body>
 
<script>

$(document).ready(function(){

});

function changePasswd(){
	
	if($('#passwd').val()==''){
		alert('변경 비밀번호를 입력해 주세요.');
		$('#passwd').focus();
		return;
	}
	
	if($('#passwd').val().length<8){
		alert('비밀번호는 8자 이상이어야 합니다.');
		$('#passwd').focus();
		return;
	}
	
	if($('#rePasswd').val()==''){
		alert('변경 비밀번호 확인을 입력해 주세요.');
		$('#rePasswd').focus();
		return;
	}
	
	if($('#rePasswd').val().length<8){
		alert('비밀번호는 8자 이상이어야 합니다.');
		$('#rePasswd').focus();
		return;
	}
	
	if($('#passwd').val() != $('#rePasswd').val()){
		alert('변경 비밀번호가 일치하지 않습니다.');
		$('#rePasswd').focus();
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/login/newPasswdAction.do",
		cache : false,
		async : false,
		data : $("#authForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('변경되었습니다.');
				location.href="/login/login.do";
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
</script>

<div class="wrap">
	
	<div class="loginWrap">
		<h1><img src="/resources/images/logo2.png" alt="M-Library (Knowledge Magement System)"></h1>
		<h2>비밀번호 재설정</h2>

		<div class="loginBx">
		<fieldset>
			<legend>비밀번호 재설정</legend>
			<form id="authForm">
			<div class="loginTx01 passchg">
				<p><span><label for="passChg">변경 비밀번호</label></span><input type="password" name="passwd" id="passwd" maxlength="20"></p>
				<p><span><label for="rePassChg">변경 비밀번호 확인</label></span><input type="password" name="rePasswd" id="rePasswd" maxlength="20" onKeyDown="if(event.keyCode == 13){changePasswd();}"></p>			
			</div>
			</form>
			<a href="javascript:changePasswd();" class="btn chg_btn btnRed mb25">변경</a>

			<ul class="loginTxList passchg">
				<li>비밀 번호는 영문+숫자+특수문자 8자로 입력하셔야 합니다.</li>
				<li>
					비밀번호 변경 관련 문의 사항은 담당자에게 연락 바랍니다.
					<p class="">- ADMIN 관리자: 김미란     <span class="ml15">문의 메일: <a href="mailto:mrkim@smtown.com">mrkim@smtown.com</a></span></p>
				</li>
			</ul>
		</fieldset>
		</div>
		
	</div>


</div>

</body>
</html>