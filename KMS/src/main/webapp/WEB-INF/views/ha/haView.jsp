<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){
	$(this).attr('title','상세 | History Archive | M-Library');
	
	if(''=='${ha.HA_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.');
		goList();
		return;
	}
	$('#updateBtn').click(function(){
		update();
	});

	$('#listBtn').click(function(){
		goList();
	});
	$('#deleteBtn').click(function(){
		deleteFu();
	});
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
	
});


function update(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haUpdate.do');
	$('#searchForm').submit();		
}
function goList(){
	///ha/haList.do?haCateCd=HAC_00001
	var str = $('#haCateCd').val();		
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/ha/haList.do?haCateCd='+str);
	$('#searchForm').submit();		
}
function deleteFu(){
	
	if(!confirm("삭제하시겠습니까?")) return;

	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type:"POST",
		url:"/ha/haDeleteAction.do",
		cache:false,
		async:false,
		data:$("#searchForm").serialize(),
		dataType:"json",
		success : function(data){
			if(data.result=='true'){
				alert("삭제되었습니다");
				goList();
			}else{
				alert(data.msg);
			}
		},
		error:function(request,status,errorThrown){
			alert("시스템 오류입니다,잠시 후 다시 시도해 주세요.");
		}
	});
}


</script>



<form id="searchForm">
	<input type="hidden" id="haId" name="haId" value="<c:out value='${params.haId}'/>"/>
	<input type="hidden" id="haCateCd" name="haCateCd" value="<c:out value='${params.haCateCd}'/>"/>
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/>
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="searchMediaCd" value="<c:out value='${params.searchMediaCd}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>

<h2 class="mb60">History Archive</h2>

<table class="tableComm mb30">
	<caption>History Archive</caption> 
	<colgroup>
		<col style="width:15%;">
		<col style="width:25%;">
		<col style="width:15%;">
		<col style="width:15%;">
		<col style="width:15%;">
		<col style="width:15%;">
	</colgroup>
	<tbody>
	
	<tr>
		<th>캠페인명</th>
		<td colspan="5">
			<c:out value="${ha.TITLE}"/>
		</td>
	</tr>
	<tr>
		<th>작성자</th>
		<td>
			<c:out value="${ha.MEMBER_NM}" />
		</td>
		<th>작성일</th>
		<td>
			<fmt:formatDate value="${ha.REG_DTM}" pattern="yyyy.MM.dd"/>	
		</td>
			<th>조회수</th>
		<td>
			<c:out value="${ha.HIT}"/>
		</td>
	</tr>	
	
</tbody>
	</table>

<c:if test="${ha.HA_CATE_CD eq 'HAC_00001'}">
	<div class="haMovie mb70">
		<div class="fl">
			<c:if test="${not empty attList}">
				<c:if test="${ha.HA_CATE_CD eq 'HAC_00001'}">
					<c:choose>
						<c:when test="${fn:endsWith(fn:toLowerCase(attList[0].FILE_PATH),'.mp4')}">
							<video width="466" height="340" controls autoplay="" loop="" preload="auto" >
								<source src="/upload/${attList[0].FILE_PATH}" type="video/mp4" />
								<p class="notMovie detail"><img src="/resources/images/notMovie_large.png" alt="다운로드하여 확인하세요."/></p>
							</video>
						</c:when>
						<c:otherwise>
							<p class="notMovie detail"><img src="/resources/images/notMovie_large.png" alt="다운로드하여 확인하세요."/></p>
						</c:otherwise>
					</c:choose>						
				</c:if>
			</c:if>
		</div>
		<div class="fr">
			<table class="haTable">
				<caption>캠페인 상세내용</caption>
				<colgroup>
					<col style="width:90px;">
					<col style="width:auto;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Client명</th>
						<td><c:out value="${ha.CLIENT_NM}"/></td>
					</tr>
					<tr>
						<th scope="row">ON-Air</th>
						<td><fmt:formatDate value="${ha.ONAIR_START_DT}" pattern="yyyy.MM"/></td>
					</tr>
					<tr>
						<th scope="row">매체</th>
						<td><c:out value="${ha.MEDIA_NM}"/></td>
					</tr>
					<tr>
						<th scope="row">제작부서</th>
						<td><c:out value="${ha.PROD_TEAM_NM}"/></td>
					</tr>
					<tr>
						<th scope="row">기획부서</th>
						<td><c:out value="${ha.PLAN_TEAM_NM}"/></td>
					</tr>
					<tr>
						<th scope="row">프로덕션</th>
						<td><c:out value="${ha.PRODUCTION_CD}"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</c:if>

<table class="tableComm mb30">
	<caption>History Archive</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
	<c:if test="${ha.HA_CATE_CD ne 'HAC_00001'}">
	<tr>
		<th>내용</th>
		<td>
  			<div class="bx05" style="width:95%;">  
 			<c:out value="${ha.CONT}" escapeXml="false"/> 

 			</div> 
		</td>
	</tr>
	</c:if>
	<c:forEach var="att" items="${attList}" varStatus="index" >
	<tr>
		<th>첨부파일</th>
		<td>
			<div class="bx12 dpinblock" style="width:78%;">
				<p class="file">
						<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>"><c:out value="${att.ORG_FILE_NM}"/></a>
				</p>								
			</div>
			
			<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn05">다운로드</a>
		</td>
	</tr>
	</c:forEach> 
	<c:if test="${empty attList}">
	<tr>
		<th>첨부파일</th>
		<td colspan="6" align="center">첨부파일이 없습니다.</td>
	</tr>
	</c:if>
	</tbody>
	</table>
</form>

		
			<div class="tac">
				
				<c:if test="${params.superYn eq 'Y'}">
				<button type="button" class="btn btnMid btnRed" id="deleteBtn" style="width:150px;">삭제</button>
				</c:if>
				<c:if test="${ha.REG_ID eq params.mid}">
				<button type="button" class="btn btnMid btnBlue  ml10" id="updateBtn" style="width:150px;">수정</button>
				</c:if>							
			</div>


<%@include file="/WEB-INF/views/include/footer.jsp"%>
