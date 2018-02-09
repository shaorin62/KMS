<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "상세 | Potential Client | M-Library");
	
	if(''=='${vc.VC_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.');
		goList();
		return;
	}
	
	$('#updateBtn').click(function(){
		update();
	});
	
	$('#deleteBtn').click(function(){
		deleteVc();
	});

	$('#commentBtn').click(function(){
		comment();
	});
	
	$('#fuInsertBtn').click(function(){
		fuInsert();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});

function update(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/virtual/vcUpdate.do');
	$('#searchForm').submit();		
}

function deleteVc(){
	
	if(!confirm('삭제하시겠습니까?')){
		return;
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/virtual/vcDeleteAction.do",
		cache : false,
		async : false,
		data : $("#searchForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('삭제되었습니다.');
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
	$('#searchForm').submit();
}

function comment(){
	
	if( $('#directorComment').val()=='' ){
		alert('내용을 입력하세요.');
		$('#directorComment').focus();
		return;
	}
	
	if(!confirm('저장하시겠습니까?')) return;	
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/virtual/commentUpdateAction.do",
		cache : false,
		async : false,
		data : $("#commentForm").serialize(),
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

function fuInsert(){
	
	if( $('#fuCont').val()=='' ){
		alert('내용을 입력하세요.');
		$('#fuCont').focus();
		return;
	}
	
	if(!confirm('저장하시겠습니까?')) return;
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/virtual/fuInsertAction.do",
		cache : false,
		async : false,
		data : $("#fuInsertForm").serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('저장되었습니다.');
				location.reload();
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

<form id="searchForm" method="GET" action="/virtual/vcList.do">
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/> 
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchBizCd" value="<c:out value='${params.searchBizCd}'/>"/>
	<input type="hidden" name="searchContactCd" value="<c:out value='${params.searchContactCd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="vcId" value="<c:out value='${params.vcId}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
</form>

<h2 class="mb60">Potential Client</h2>

<table class="tableComm mb30">
	<caption>Potential Client</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:258px;">
		<col style="width:100px;">
		<col style="width:258px;">
	</colgroup>
	<tbody>
		<tr>
			<th>제목 </th>
			<td colspan="3">
				<c:out value="${vc.TITLE}"/>
			</td>
		</tr>
		<tr>
			<th>예상빌링 </th>
			<td>
				<c:out value="${vc.BILLING}"/>
			</td>
			<th>업종 </th>
			<td>
				<c:out value="${vc.BIZ_NM}"/>
			</td>
		</tr>
		<tr>
			<th>최초<br>Contact일 </th>
			<td>
				<fmt:formatDate value="${vc.CONTACT_DT}" pattern="yyyy-MM-dd"/>
			</td>
			<th>Contact<br>경로 </th>
			<td>
				<c:out value="${vc.CONTACT_PATH_NM}"/>
			</td>
		</tr>
		<tr>
			<th>당사참석자 </th>
			<td colspan="3">
				<c:out value="${vc.CO_ATTEND}"/>
			</td>
		</tr>
		<tr>
			<th>광고주 참석자 </th>
			<td colspan="3">
				<c:out value="${vc.AD_ATTEND}"/>
			</td>
		</tr>
	</tbody>
	
</table>

<form id="commentForm">
<table class="tableComm mtable1 mb30">
	<caption>내용 및 본부장 의견</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>내용 </th>
			<td>
				<div class="bx05">
					<c:out value="${vc.CONT}" escapeXml="false"/>
				</div>
			</td>
		</tr>
		<tr>
			<th>본부장<br>의견</th>
			<td>
				<c:choose>
					<c:when test="${vc.AUTH_YN eq 'Y' and loginVO.posCd eq 'POS_00020'}">
						<input type="hidden" name="vcId" value="<c:out value='${params.vcId}'/>"/>
						<textarea name="directorComment" title="본부장의견" class="fuTextarea" placeholder="본부장 의견 자유롭게 작성"><c:out value="${vc.DIRECTOR_COMMENT}"/></textArea>
						<button type="button" id="commentBtn" class="btn btnGray2" style="width:98px; height:68px; line-height:68px;">저장</button>
					</c:when>
					<c:otherwise>
						<div class="bx05">
							<c:out value="${fn:replace(vc.DIRECTOR_COMMENT,lf,'<br/>')}" escapeXml="false"/>
						</div>					
					</c:otherwise>
				</c:choose>		
			</td>
		</tr>
	</tbody>
</table>
</form>

<h3>문서 열람자</h3>

<table class="tableComm mb15">
	<caption>문서 열람자</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>부문장</th>
			<td>
				<span id="span1">
					<c:forEach var="auth" items="${authList}" varStatus="status">
						<c:if test="${auth.POS_CD eq 'POS_00010'}">
							<span class="mTx01">
								<input type="hidden" name="authMid" value="<c:out value='${auth.MID}'/>"/>
								<c:out value="${auth.MEMBER_NM}"/> 
								<!-- <button type="button" title="삭제" onclick="removeMember(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>  -->
							</span>
						</c:if>
					</c:forEach>
				</span>
			</td>
		</tr>
		<tr>
			<th>본부장/그룹장</th>
			<td>
				<span id="span2">
					<c:forEach var="auth" items="${authList}" varStatus="status">
						<c:if test="${auth.POS_CD eq 'POS_00020' or auth.POS_CD eq 'POS_00030' or auth.POS_CD eq 'POS_00040'}">
							<span class="mTx01">
								<input type="hidden" name="authMid" value="<c:out value='${auth.MID}'/>"/>
								<c:out value="${auth.MEMBER_NM}"/> 
								<!-- <button type="button" title="삭제" onclick="removeMember(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button> -->
							</span>
						</c:if>
					</c:forEach>
				</span>
			</td>
		</tr>
		<tr>
			<th>팀장/PL</th>
			<td>
				<span id="span3">
					<c:forEach var="auth" items="${authList}" varStatus="status">
						<c:if test="${auth.POS_CD eq 'POS_00050' or auth.POS_CD eq 'POS_00060'}">
							<span class="mTx01">
								<input type="hidden" name="authMid" value="<c:out value='${auth.MID}'/>"/>
								<c:out value="${auth.MEMBER_NM}"/> 
								<!-- <button type="button" title="삭제" onclick="removeMember(this);"><img src="/resources/images/btn_del.png" alt="삭제"></button>  -->
							</span>
						</c:if>
					</c:forEach>
				</span>
			</td>
		</tr>
	</tbody>
</table>

<div id="viewDiv">
	<div class="tac mb30">
		<c:if test="${vc.SUPER_YN eq 'Y'}">
			<button type="button" id="deleteBtn" class="btn btnMid btnRed" style="width:150px;">삭제</button>
		</c:if>
		<c:if test="${vc.REG_ID eq params.mid}">
			<button type="button" id="updateBtn" class="btn btnMid btnBlue ml10" style="width:150px;">수정</button>
		</c:if>
	</div>
</div>

<c:if test="${fn:length(fuList) > 0 or vc.REG_ID eq params.mid}">
<form id="fuInsertForm">
<table class="tableComm mtable1">
	<caption>Flow Up</caption>
	<colgroup>
		<col style="width:100px;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>F/U</th>
			<td>
				<c:forEach var="fu" items="${fuList}" varStatus="status">
					<div class="bx05 mb10">
						<c:out value='${status.index+1}'/>차 F/U<br/>
						<c:out value="${fn:replace(fu.FU_CONT,lf,'<br/>')}" escapeXml="false"/>
					</div>
				</c:forEach>
				<c:if test="${vc.REG_ID eq params.mid}">
					<input type="hidden" name="vcId" value="<c:out value='${params.vcId}'/>"/>
					<textarea id="fuCont" name="fuCont" title="<c:out value='${fn:length(fuList)+1}'/>차 F/U" class="fuTextarea" placeholder="<c:out value='${fn:length(fuList)+1}'/>차 F/U"></textarea>
					<button type="button" id="fuInsertBtn" class="btn btnGray2" style="width:98px; height:68px; line-height:68px;">등록</button>
				</c:if>	
			</td>
		</tr>
	</tbody>
</table>
</form>
</c:if>

<%@include file="/WEB-INF/views/include/footer.jsp"%>