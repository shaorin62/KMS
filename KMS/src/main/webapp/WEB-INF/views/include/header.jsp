<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/common.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

	<title></title>
	
	<!-- MNS Guide -->
	<link rel="stylesheet" type="text/css" href="/resources/css/base.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/jquery.bxslider.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/layout.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/contents.css">
	
	<!-- 구글 웹 로그 분석 -->
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
	
	  ga('create', 'UA-72767280-3', 'auto');
	  ga('send', 'pageview');
	</script>

	<script type="text/javascript" src="/resources/vendor/jquery/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/layout.js"></script>
	
	<!-- selectbox -->
	<script type="text/javascript" src="/resources/js/jquery.dd.js"></script>
	
	<!-- jquery-ui -->	
	<link type=text/css rel="stylesheet" href="/resources/jquery-ui/jquery-ui.min.css"/>
	<script type="text/javascript" src="/resources/jquery-ui/jquery-ui.min.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function(){
			
			if(location.pathname.indexOf('/virtual/')==0){
				$('.leftMenu li').eq(0).attr('class','on');
			}else if(location.pathname.indexOf('/pt/')==0){
				$('.leftMenu li').eq(1).attr('class','on');
			}else if(location.pathname.indexOf('/tr/')==0){
				$('.leftMenu li').eq(2).attr('class','on');
			}else if(location.pathname.indexOf('/cd/')==0){
				$('.leftMenu li').eq(3).attr('class','on');
			}else if(location.pathname.indexOf('/ha/')==0){
				$('.leftMenu li').eq(4).attr('class','on');
			}else if(location.pathname.indexOf('/kc/')==0){
				$('.leftMenu li').eq(5).attr('class','on');
			}
			
			$('#gSearchBtn').click(function(){
				gSearch();
			});
			
			$('textArea, input[type=text]').blur(function(){
				var value = $.trim($(this).val());
				
				//에디터에 자동으로 들어가는 코드는 제거
				if(value=='<p><br></p>'){
					value = '';
				}
				
				$(this).val(value);
			});
			
		});
		
		function gSearch(){
			if($('#gSearchText').val()==''){
				alert('검색어를 입력해 주세요.');
				return;
			}
			$('#gSearchForm').submit();			
		}
		
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
			<h1><a href="/main/main.do"><img src="/resources/images/logo.png" alt="M-Library"></a></h1>
			<!-- GNB -->
			<form id="gSearchForm" action="/main/search.do">
			<p class="headerSearch">
				<select id="gSearchType" name="searchType" style="width:130px;" class="ml7">
					<option value="">전체</option>
					<option value="title">제목</option>
					<option value="regNm">작성자</option>
					<option value="clientNm">client명</option>
				</select>
				<input type="text" id="gSearchText" name="searchText" title="검색" placeholder="검색" class="msearch" style="width:190px;" onKeyDown="if(event.keyCode == 13){gSearch();}"/>
				<button type="button" id="gSearchBtn" title="검색하기" class="headerSearchBtn"><img src="/resources/images/icon_search.png" alt="검색하기"></button>
			</p>
			</form>
			<!-- GNB //-->
		</div>
	</div>

	<!-- Container -->
	<div class="container">
	
		<%@include file="/WEB-INF/views/include/menu.jsp"%>

		<!-- contents -->
		<div class="mContents">
