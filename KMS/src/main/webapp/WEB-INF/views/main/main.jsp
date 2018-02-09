<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/common.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta name="author" content="SK MNS" >
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<title>M-Library</title> 
	
	<!-- MNS Guide -->
	<link rel="stylesheet" type="text/css" href="/resources/css/base.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/jquery.bxslider.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/layout.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/contents.css">

	<script type="text/javascript" src="/resources/vendor/jquery/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/layout.js"></script>
	
	<!-- selectbox -->
	<script type="text/javascript" src="/resources/js/jquery.dd.js"></script>
	
	<!-- jquery-ui -->	
	<link type=text/css rel="stylesheet" href="/resources/jquery-ui/jquery-ui.min.css"/>
	<script type="text/javascript" src="/resources/jquery-ui/jquery-ui.min.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function(){
			
			$('#gSearchBtn').click(function(){
				gSearch();
			});
			
			$('textArea').blur(function(){
				var value = $.trim($(this).val());
				$(this).val(value);
			});
			
			$('input[type=text]').blur(function(){
				var value = $.trim($(this).val());
				$(this).val(value);
			});
			
			/*
			var popview = getCookie('pop1');
			
			if(popview != "noView1"){
				var width = 580, height = 670 ;
				var left = (screen.width - width) / 2 ;
				var top = (screen.height - height) / 2 ;
				//팝업 노출 
				window.open('/popup/pop1.do', 'popup','width=' + width +  ', height=' + height +  ', left=' + left +  ', top=' + top + ',scrollbars=no,toolbars=no,location=no');

			}
			*/
			//-----------------팝업 생성 및 쿠키 설정

		});
		
		
		
		function gSearch(){
			if($('#gSearchText').val()==''){
				alert('검색어를 입력해 주세요.');
				return;
			}
			$('#gSearchForm').submit();			
		}	
		
		
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
		
	</script>
</head>
<body>

<div class="wrap main">

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
		<div class="mainWrap">

<script type="text/javascript">

function view(table, value){
	
	var name = '';
	var action = '';
	switch(table){
		case 'vc': name="vcId"; action='/virtual/vcView.do'; break;
		case 'pt': name="ptId"; action='/pt/ptView.do'; break;
		case 'tr': name="bdId"; action='/tr/trView.do'; break;
		case 'kc': name="bdId"; action='/kc/kcView.do'; break;
		case 'ha': name="haId"; action='/ha/haView.do'; break;
	}
	
	$('#searchForm').attr('action',action);
	$('#searchForm').append(
		$("<input type='hidden' name='"+name+"' value='"+value+"'/>")
	);
	$('#searchForm').submit();
}

</script>

<!-- mainContents -->
<div class="mainContents">
		
	<form id="searchForm">
		<input type="hidden" name="searchType" value=""/>
		<input type="hidden" name="searchText" value=""/>
	</form>
	
	<div class="mainBody line">
		<a href="/pt/ptList.do"><h2>PT Report <span>&gt;</span></h2></a>
		<table class="tbList">
			<caption>PT Report</caption>
			<colgroup>
				<col style="width:70%;">
				<col style="width:16%;">
				<col style="width:14%;">
			</colgroup>
			<tbody>
				<c:forEach var="result" items="${ptPage.list}" varStatus="status">
				<tr>
					<th scope="row">
						<a href="javascript:view('pt','${result.PT_ID}');">
							<c:if test="${result.LVL>1}">
								<c:forEach var="i" begin="2" end="${result.LVL}">
									&nbsp;&nbsp;
								</c:forEach>
								└
							</c:if>						
							<c:out value="${result.TITLE}"/>
						</a>
					</th>
					<td><c:out value="${result.REG_TEAM_NM}"/></td>
					<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
				</tr>
				</c:forEach>
				<c:if test="${empty ptPage.list}">
					<tr>
						<td colspan="3" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>					
			</tbody>
		</table>
	</div>
	
	<div class="mainBody line">
		<a href="/tr/trList.do"><h2>Trend Report <span>&gt;</span></h2></a>
		<table class="tbList">
			<caption>Trend Report</caption>
			<colgroup>
				<col style="width:70%;">
				<col style="width:16%;">
				<col style="width:14%;">
			</colgroup>
			<tbody>
				<c:forEach var="result" items="${trPage.list}" varStatus="status">
				<tr>
					<th scope="row"><a href="javascript:view('tr','${result.BD_ID}')"><c:out value="${result.TITLE}"/></a></th>
					<td><fmt:formatNumber value="${result.HIT}" groupingUsed="true" /></td>
					<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
				</tr>
				</c:forEach>
				<c:if test="${empty trPage.list}">
					<tr>
						<td colspan="3" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>					
			</tbody>
		</table>
	</div>

	<!-- 일반 구성원 -->	
	<c:if test="${loginVO.posCd eq 'POS_00100'}">
	<div class="mainBody">
		<a href="/kc/kcList.do"><h2>지식채널 <span>&gt;</span></h2></a>
		<ul class="mainPicList">
			<c:forEach var="result" items="${kcPage.list}" varStatus="status">
			<li <c:if test="${status.index eq 2}">class="mr0"</c:if> >
				<p class="pic"><a href="javascript:view('kc','${result.BD_ID}');"><img src="/upload/${result.FILE_PATH}" alt="" align="middle" style="width: 150px; height: 100px;"></a></p>
				<p class="tx1"><a href="javascript:view('kc','${result.BD_ID}');"><c:out value="${result.TITLE}"/></a></p>
				<p class="tx2"><a href="<c:out value="${result.LINK_URL}"/>" target="_blank">바로가기 &gt;</a></p>
			</li>
			</c:forEach>
		</ul>
	</div>
	</c:if>
	
	<!-- 직책자 -->
	<c:if test="${loginVO.posCd eq 'POS_00010' or loginVO.posCd eq 'POS_00020' or loginVO.posCd eq 'POS_00030' or loginVO.posCd eq 'POS_00040' or loginVO.posCd eq 'POS_00050' or loginVO.posCd eq 'POS_00060'}">
	<div class="mainBody">
		<a href="/virtual/vcList.do"><h2>Potential Client <span>&gt;</span></h2></a>
		<table class="tbList">
			<caption>Potential Client</caption>
			<colgroup>
				<col style="width:70%;">
				<col style="width:16%;">
				<col style="width:14%;">
			</colgroup>
			<tbody>
				<c:forEach var="result" items="${vcPage.list}" varStatus="status">
				<tr>
					<th scope="row"><a href="javascript:view('vc','${result.VC_ID}')"><c:out value="${result.TITLE}"/></a></th>
					<td><c:out value="${result.REG_TEAM_NM}"/></td>
					<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
				</tr>
				</c:forEach>
				<c:if test="${empty vcPage.list}">
					<tr>
						<td colspan="3" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>					
			</tbody>
		</table>
	</div>
	</c:if>

</div>
<!-- mainContents // -->

<!-- mainRight -->
<div class="mainRight">
	<div class="mrConts">
		<a href="/ha/haList.do"><h2>History Archive <span>&gt;</span></h2></a>

		<c:forEach var="result" items="${haPage.list}" varStatus="status">
		<div class="mainMovie mb13">
			
			<c:if test="${result.HA_CATE_CD eq 'HAC_00001'}">
				<a href="javascript:view('ha','${result.HA_ID}')">
					<c:choose>
						<c:when test="${fn:endsWith(fn:toLowerCase(result.FILE_PATH),'.mp4')}">
							<video width="184" height="105">
								<source src="/upload/${result.FILE_PATH}" type="video/mp4"/>
								<p class="notMovie"><img src="/resources/images/notMovie_small.png" alt="다운로드하여 확인하세요."/></p>
							</video>
						</c:when>
						<c:otherwise>
							<p class="notMovie"><img src="/resources/images/notMovie_small.png" alt="다운로드하여 확인하세요."/></p>
						</c:otherwise>
					</c:choose>
				</a>
			</c:if>
			<c:if test="${result.HA_CATE_CD eq 'HAC_00002'}">
				<a href="javascript:view('ha','${result.HA_ID}')"><img src="/upload/${result.FILE_PATH}" width="184" height="105"/></a>
			</c:if>
							
			<p class="tx1"><strong><a href="javascript:view('ha','${result.HA_ID}')"><c:out value="${result.TITLE}"/></a></strong></p>
			<p class="tx2">
				<strong><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></strong>|
				<span><c:out value="${result.MEDIA_NM}"/></span>
			</p>
		</div>
		</c:forEach>

	</div>
</div>
<!-- mainRight // -->
	
	</div>
	<!-- Container // -->

</div>

</body>
</html>