<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>본인확인 | M-Library</title>

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

	$('#selfAuthBtn').click(function(){
		selfAuth();
	});
	
	$('#cancelBtn').click(function(){
		location.href='/login/login.do';
	});
	
});

function selfAuth(){
	$.ajax({
		type : "POST",
		url : "/login/selfAuthAction.do",
		cache : false,
		async : false,
		data : $("#authForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('본인확인에 성공하였습니다.');
				location.href="/login/newPasswd.do";
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
		<h2>본인확인</h2>
			<div class="loginBx">
			<fieldset>
				<legend>본인확인</legend>
				<form id="authForm">
				<div class="loginTx01">
					<p><span><label for="mid">아이디</label></span><input type="text" name="mid" id="mid" maxlength="20"></p>
					<p><span><label for="birthDt">생년월일</label></span><input type="text" name="birthDt" id="birthDt" maxlength="8"></p>
					<p><span><label for="email">이메일</label></span><input type="text" name="email" id="email" maxlength="100" onKeyDown="if(event.keyCode == 13){selfAuth();}"></p>			
				</div>
				</form>
				
				<p class="tac mb25">
					<button id="selfAuthBtn" class="btn btnMid btnRed" style="width:150px;">확인</button>
					<button id="cancelBtn" class="btn btnMid btnBlack" style="width:150px;">취소</button>
				</p>

				<ul class="loginTxList">
					<li>생년월일/이메일로 본인확인이 완료되면 비밀번호를 변경하실 수 있습니다.</li>
					<li>
						비밀번호 변경 관련 문의 사항은 담당자에게 연락 바랍니다.
						<p class="">- ADMIN 관리자: 박예린     <span class="ml15">문의 메일: <a href="mailto:yerin.park@smtown.com">yerin.park@smtown.com</a></span></p>
					</li>
				</ul>
			</fieldset>
			</div>
	</div>


</div>

</body>
</html>