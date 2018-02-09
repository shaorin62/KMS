<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/common.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title></title>

	<!-- MNS Guide -->
	<link rel="stylesheet" type="text/css" href="/admin/resources/css/base.css">
	<link rel="stylesheet" type="text/css" href="/admin/resources/css/style.css">

	<script type="text/javascript" src="/admin/resources/vendor/jquery/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/admin/resources/js/admin.js"></script>

	<!-- selectbox -->
	<script type="text/javascript" src="/admin/resources/js/jquery.dd.js"></script>

	<!-- jquery-ui -->	
	<link type=text/css rel="stylesheet" href="/resources/jquery-ui/jquery-ui.min.css"/>
	<script type="text/javascript" src="/resources/jquery-ui/jquery-ui.min.js"></script>

	<script type="text/javascript">
		$(document).ready(function(){
			
			$('textArea, input[type=text]').blur(function(){
				var value = $.trim($(this).val());
				$(this).val(value);
			});
			
		});
		
		function sessionCheck(){
			var sessionCheckResult = false;
			$.ajax({
				url : "/login/isLogin.do",
				cache : false,
				type : "POST",
				async : false,
				
				success : function(data){
					sessionCheckResult = data;
				}
			});
			
			return sessionCheckResult;
		}

		function sessionOut() {
			alert('로그인 세션이 만료되었습니다.\n다시 로그인 해주십시오.');
			location.href = "/";
		}		
	</script>
</head>
<body>

<div class="wrap">
	
	<!-- header -->
	<div class="headWrap">
	<div class="head">
		<h1><a href="/admin/member/memberList.do"><img src="/admin/resources/images/logo.png" alt="M-Library (Knowledge Management System)"></a></h1>
		
		<!-- GNB -->
		<p class="gNav">
			<span class="mr10"><strong><c:out value="${loginVO.memberNm}"/></strong>님 안녕하세요!</span>
			<span><button type="button" class="btn btnMiny" onclick="location.href='/login/logout.do';">로그아웃</button></span>
		</p>
		<!-- GNB //-->




		<!-- LNB -->
		<ul class="mainLnb">
			<li class="dropdown">
				<a href="#" class="dropbtn">M-Library 사용자관리</a>
				<div class="dropdown-content">
					<a href="/admin/member/memberList.do">사용자관리</a>
					<a href="/admin/div/centerCode.do">팀관리</a>
				</div>
			</li>
			<li class="dropdown">
				<a href="#" class="dropbtn">코드 관리</a>
				<div class="dropdown-content">
					<a href="/admin/code/commonCode.do">코드 관리</a>
				</div>
			</li>
			<li class="dropdown">
				<a href="#" class="dropbtn">통계</a>
				<div class="dropdown-content">
					<a href="/admin/stat/statList.do">통계 조회</a>
					<!--
					<a href="#">PT Report 등록 현황</a>
					-->
				</div>
			</li>
			<li class="dropdown">
				<a href="#" class="dropbtn">포인트관리</a>
				<div class="dropdown-content">
					<a href="/admin/point/pointList.do">사용이력 조회</a>
					<a href="/admin/point/pointMemberList.do">사용자 포인트 조회</a>
					<a href="/admin/point/pointSet.do">포인트 설정</a>
				</div>
			</li>
			<li class="dropdown">
				<a href="#" class="dropbtn">다운로드 이력관리</a>
				<div class="dropdown-content">
					<a href="/admin/download/top10List.do">PT 탑10 다운로더</a>
					<a href="/admin/download/downloadList.do">다운로드 이력</a>
				</div>
			</li>
			<li class="dropdown">
				 <a href="/admin/member/admMemberList.do" class="dropbtn">ADMIN 사용자 관리</a>
			</li>
		</ul>
		<!-- LNB //-->

	</div>
	
</div>
	<!-- header // -->




	<!-- Container -->
	<div class="container admin">