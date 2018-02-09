<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>
<script type="text/javascript">

$(document).ready(function(){
	$(this).attr('title','리스트 | History Archive | M-Library');
	
	$("#searchStart, #searchEnd").datepicker({
	    dateFormat: 'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
	    changeYear: true,
	    changeMonth: true,
	    showOn: 'both',
	    buttonImage: '/resources/images/icon_datepicker.png',
	    buttonText: '날짜입력'
    });
	 
	$('#searchStart').val('<c:out value="${params.searchStart}"/>');
	$('#searchEnd').val('<c:out value="${params.searchEnd}"/>');
	
	$('#searchType').val('<c:out value="${params.searchType}"/>');
	$('#searchType').msDropDown().data("dd").set("value", '<c:out value="${params.searchType}"/>');
	
	$('#searchText').val('<c:out value="${params.searchText}"/>');
	
	if($('#haCateCd').val()=='HAC_00001'){
		$('#searchMediaCd').val('<c:out value="${params.searchMediaCd}"/>');
		$('#searchMediaCd').msDropDown().data("dd").set("value", '<c:out value="${params.searchMediaCd}"/>');
	}
	
	$('#searchBtn').click(function(){
		$('#pageNo').val('1');
		search();
	});
	
	$('#insertBtn').click(function(){
		insert();
	});
})


function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haList.do');
	$('#searchForm').submit();
}

function insert(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haInsert.do');
	$('#searchForm').submit();	
}
function view(haId){
	$('#haId').val(haId);
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haView.do');
	$('#searchForm').submit();
	
}
</script>


<h2 class="mb60">History Archive</h2>
			<ul class="detailTab mb60">
			<c:choose>
					<c:when test="${params.haCateCd eq 'HAC_00001' }">
						<li class="on"><a href="/ha/haList.do?haCateCd=HAC_00001">영상</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/ha/haList.do?haCateCd=HAC_00001">영상</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.haCateCd eq 'HAC_00004' }">
						<li class="on"><a href="/ha/haList.do?haCateCd=HAC_00004">옥외</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/ha/haList.do?haCateCd=HAC_00004">옥외</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.haCateCd eq 'HAC_00003' }">
						<li class="on"><a href="/ha/haList.do?haCateCd=HAC_00003">프로모션</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/ha/haList.do?haCateCd=HAC_00003">프로모션</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.haCateCd eq 'HAC_00002' }">
						<li class="on"><a href="/ha/haList.do?haCateCd=HAC_00002">Data Insight</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/ha/haList.do?haCateCd=HAC_00002">Data Insight</a></li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${params.haCateCd eq 'HAC_00005' }">
						<li class="on"><a href="/ha/haList.do?haCateCd=HAC_00005">뉴스레터</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="/ha/haList.do?haCateCd=HAC_00005">뉴스레터</a></li>
					</c:otherwise>
				</c:choose>
				
			</ul>
			<!-- search box -->
<form id="searchForm">
	<div class="bx01 mb40">
		<div class="search-box">
			<div class="flConts">
				<c:if test="${params.haCateCd eq 'HAC_00001'}">
					<c:set var="line" value="class='line-search'"/>
				</c:if>
				<p ${line}>
					<span class="w320">
					<strong class="tit01">기간</strong>
						<input type="text" id="searchStart" name="searchStart"  style="width:28%" readOnly>
								~
						<input type="text" id="searchEnd" name="searchEnd"  style="width:28%" readOnly>		
					</span>
					
					<select id="searchType" name="searchType" style="width:150px;">
					<c:if test="${params.haCateCd eq 'HAC_00001'}">
				 		<option value="">전체</option>
						<option value="title">제목</option>
						<option value="regNm">작성자</option>
						<option value="clientNm">Client명</option>
						<option value="planTeam">기획부서</option>
						<option value="prodTeam">제작부서</option>
					</c:if>
					<c:if test="${params.haCateCd eq 'HAC_00002' or params.haCateCd eq 'HAC_00003' or params.haCateCd eq 'HAC_00004'  or params.haCateCd eq 'HAC_00005'}">
						<option value="">전체</option>
						<option value="title">제목</option>
						<option value="regNm">작성자</option>
					</c:if>	
					</select>				 
					<input type="text" id="searchText" name="searchText"  onKeyDown="if(event.keyCode == 13){$('#pageNo').val('1'); search();}"/>
					<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>
					<input type="hidden" id="haCateCd" name="haCateCd" value="${params.haCateCd}"/>
					<input type="hidden" id="haId" name="haId" value=""/>
					<button type="button" id="searchBtn" class="btn btnSmall btnBlack">검색</button>
					<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
				</p>
				<c:if test="${params.haCateCd eq 'HAC_00001'}">
					<p class="">
						<span class="w320">
							<strong class="tit01">매체</strong>
								<select id="searchMediaCd" name="searchMediaCd" title="검색범위선택" style="width:150px;">
									<option value="">전체</option>
									<c:forEach var="media" items="${mediaList}" varStatus="status">
										<option value="<c:out value='${media.CD}'/>"><c:out value='${media.NM}'/></option>
									</c:forEach>
							</select>
						</span>
					</p>
				</c:if>
				
			</div>
		</div>	
	</div>
</form>			
			<div class="listinfo">
				<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
			</div>
			
<c:choose>
	<c:when test="${params.haCateCd eq 'HAC_00001'}">
			<!-- list -->
			<div class="bx13 mb40">
				<ul class="haList">
					<c:forEach var="result" items="${listPage.list}" varStatus="status">
					<li>
						<div class="libx">
							
							<c:if test="${result.HA_CATE_CD eq 'HAC_00001'}">
								<a href="javascript:view('${result.HA_ID}')">
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
							<p class="tx1"><strong><a href="javascript:view('${result.HA_ID}')"><c:out value="${result.TITLE}"/></a></strong></p>
							<p class="tx2">
								<strong><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></strong>|
								<span><c:out value="${result.MEDIA_NM}"/></span>
							</p>
						</div>
					</li>
					</c:forEach>
					<c:if test="${empty listPage.list}">
						<li>
							검색결과가 없습니다.
						</li>
					</c:if>
				</ul>
			</div>
			<!-- list // -->
	</c:when>
	<c:otherwise>		
			<!-- list -->
			<table class="tableComm table1 tableType1 mb20">
				<caption class="">Credential 리스트</caption>
				<colgroup>
					<col style="width:9%;">
					<col style="width:46%;">
					<col style="width:15%;">
					<col style="width:15%;">
					<col style="width:15%;">
				</colgroup>
				<thead>
					<tr>
						<th>NO</th>
						<c:if test="${params.haCateCd eq 'HAC_00002' || params.haCateCd eq 'HAC_00004' || params.haCateCd eq 'HAC_00005'}">
							<th>제목</th>
						</c:if>
						<c:if test="${params.haCateCd eq 'HAC_00003'}">
							<th>캠페인</th>
						</c:if>
						<th>팀</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="result" items="${listPage.list}" varStatus="status">
					<tr>
						<td><c:out value="${listPage.totalCount - result.RNUM +1}"/></td>
						<td class="tal"><a href="javascript:view('${result.HA_ID}')"><c:out value="${result.TITLE}"/></a></td>
						<td><c:out value="${result.TEAM_NM}"/></td>
						<td><c:out value="${result.MEMBER_NM}"/></td>
						<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
					</tr>
				</c:forEach>
				<c:if test="${empty listPage.list}">
					<tr>
						<td colspan="5" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:if>
				</tbody>
			</table>
			<!-- list // -->
	</c:otherwise>
</c:choose>

			<!-- paging -->
						<div class="paging">	<c:out value="${listPage.pageString}" escapeXml="false" /></div>
			<!-- paging // -->

			<div class="tac">
				<button type="button"  id="insertBtn" class="btn btnMid btnBlue" style="width:150px;">등록</button>
			</div>

<%@include file="/WEB-INF/views/include/footer.jsp"%>