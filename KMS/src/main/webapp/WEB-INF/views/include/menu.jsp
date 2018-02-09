<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- Left -->
<div class="leftWrap">
	<ul class="leftMenu">
		<li><a href="/virtual/vcList.do">Potential Client</a></li>
		<li><a href="/pt/ptList.do">PT Report</a></li>
		<li><a href="/tr/trList.do">Trend Report</a></li>
		<li><a href="/cd/cdList.do">Credential</a></li>
		<li><a href="/ha/haList.do?haCateCd=HAC_00001">History Archive</a></li>
		<li><a href="/kc/kcList.do">지식 채널</a></li>
	</ul>

	<div class="leftMyinfo">
		<p class="tx1"><strong><c:out value="${loginVO.memberNm}"/></strong> 님 반갑습니다.</p>
		<button type="button" class="btn btnMiny" onclick="location.href='/login/logout.do';">로그아웃</button>

		<div class="tx2group">
			<p class="pb6"><a href="/main/mySearch.do"><span>내가 쓴글</span><strong><fmt:formatNumber value="${docCnt}" groupingUsed="true" />회</strong></a></p>
			<p><a href="/main/myPointList.do"><span>적립포인트</span><strong><fmt:formatNumber value="${sumPoint}" groupingUsed="true" />P</strong></a></p>
		</div>
	</div>

	<p class="leftmaster"><a href="mailTo:yerin.park@smtown.com">관리자 문의</a></p>

</div>
<!-- Left // -->