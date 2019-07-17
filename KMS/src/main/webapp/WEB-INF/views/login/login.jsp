<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>로그인 | M-Library</title>

	<!-- MNS Guide -->
	<link rel="stylesheet" type="text/css" href="/resources/css/base.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/jquery.bxslider.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/layout.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/contents.css">

	<script type="text/javascript" src="/resources/vendor/jquery/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/layout.js"></script>
	<script type="text/javascript" src="/resources/js/ShortCut.js"></script>

	<!-- selectbox -->
	<script type="text/javascript" src="/resources/js/jquery.dd.js"></script>
	
</head>

<body>

<script>

$(document).ready(function(){
	
	
	/*
	//공지를 위한 팝업 처리
	var popview = getCookie('pop1');
	
	if(popview != "noView1"){ 
		var width = 590, height = 290 ;
		var left = (screen.width - width) / 2 ;
		var top = (screen.height - height) / 2 ;
		//팝업 노출 
		window.open('/popup/pop1.do', 'popup','width=' + width +  ', height=' + height +  ', left=' + left +  ', top=' + top + ',scrollbars=no,toolbars=no,location=no');

	}
	//공지를 위한 팝업 처리 끝
	*/
	
	
	

	$('#loginBtn').click(function(){
		login();
	});

	
});

function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}



function login(){
	
	if($('#mid').val()==''){
		alert('아이디를 입력해 주세요.');
		$('#mid').focus();
		return;
	}
	
	if($('#passwd').val()==''){
		alert('비밀번호를 입력해 주세요.');
		$('#passwd').focus();
		return;
	}
	
	//아이디 대소문자 구분
	var changeID; 
	changeID = $('#mid').val();
	$('#mid').val(changeID.toUpperCase());
	
	
	$.ajax({
		type : "POST",
		url : "/login/loginAction.do",
		cache : false,
		async : false,
		data : $("#loginForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				if(data.admYn=='Y'){
					location.href="/admin/member/memberList.do";
				}
				else{
					if(data.initYn=='Y'){
						location.href="/login/selfAuth.do";
					}
					else{
						location.href="/main/main.do";	
					}
				}
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

function createIcon(){
	  if(confirm("바탕화면에 바로가기를 만드시겠습니까?")){
			var WshShell = new ActiveXObject("WScript.Shell");
			Desktoptemp = WshShell.Specialfolders("Desktop");
			
			var sIconNm = "M-Library";
			var sName 	= WshShell.CreateShortcut(Desktoptemp + "\\" + sIconNm + ".URL");
			sName.TargetPath = "http://mlb.smtown.com";
			sName.Save();
	  }
}

function setCookie(cName, cValue,cDay){

	var expire = new Date();
	
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/' ; 
	
	if(typeof cDay != 'undefined'){
		cookies += ';expire=' + expire.toGMTString() + ';';
	}
	
	document.cookie = cookies;
	
	
}

</script>

<div class="wrap">
	<div class="loginWrap">
		<h1><button type="button" onclick="setCookie('pop1','',-1);"><img src="/resources/images/logo2.png" alt="M-Library (Knowledge Magement System)" > </button></h1>
		<h2>로그인</h2>

		<div class="loginBx">
		<fieldset>
			<legend>로그인</legend>
			<form id="loginForm">
			<div class="loginTx01">
				<p><span><label for="mid">아이디</label></span><input type="text" name="mid" id="mid" maxlength="20" style="IME-MODE:disabled"></p>
				<p><span><label for="passwd">비밀번호</label></span><input type="password" name="passwd" id="passwd" maxlength="20" onKeyDown="if(event.keyCode == 13){login();}"></p>
			</div>
			</form>
			
			<a href="javascript:login();" class="btn login_btn btnRed">로그인</a>

			<p class="loginTx02">
				<a href="/login/selfAuth.do">비밀번호 재설정</a> |
				<!--  <a href="mailTo:mrkim@smtown.com">비밀번호 문의</a> |-->
				<a href="javascript:createIcon();"><span class="red">바로가기만들기</span> </a>
			</p>

			<ul class="loginTxList">
				<li><span class="red">M-Library</span> 시스템 사용은 <span class="red">사내망</span> 내에서만 가능합니다.</li>
				<li>아이디는 사번이며, 최초 비밀번호는 생년월일 8자리 입니다.</li>
				<li><img style="width: 60 px; height: 40px;" src="/resources/images/explorer.png" alt="M-Library (Knowledge Magement System)" >
					M-Library 는 IE 에서 에러가 발생 될 수 있습니다.</li>
				<li>
					기타 문의 사항은  ADMIN 관리자에게 문의 바랍니다.
					<p class="">- ADMIN 관리자: 김미란P.     <span class="ml15">문의 메일: <a href="mailto:mrkim@smtown.com">mrkim@smtown.com</a></span></p>
				</li>
			</ul>
		</fieldset>
		</div>
	</div>


</div>

</body>
</html>