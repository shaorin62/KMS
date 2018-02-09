<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "상세 | PT Report | M-Library");
	
	if(''=='${pt.PT_ID}'){
		alert('존재하지 않거나 삭제된 게시물 입니다.!');
		goList();
		return;
	}
	
	$( "#docOpenDt" ).datepicker({
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
	
	$('#excelBtn').click(function(){
		excel();
	});	
	
	$('#updateBtn').click(function(){
		update();
	});
	
	$('#deleteBtn').click(function(){
		deletePt();
	});
	
	$('#lessonBtn').click(function(){
		lesson();
	});
});

function excel(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/pt/ptViewExcel.do');
	$('#searchForm').submit();		
}

function update(){ 	
	//수퍼 어드민의 경우 제출 상관없이 수정 가능하도록 지정 박그림 매니저님 요청
	if('${pt.SUPER_YN}'=='Y'){
		$('#searchForm').prop('method','GET');
		$('#searchForm').prop('action','/pt/ptUpdate.do');
		$('#searchForm').submit();
	}else if('${pt.SUBMIT_YN}'=='Y'){
		$('#viewDiv').hide();
		$('#updateDiv').show();
	}else{
		$('#searchForm').prop('method','GET');
		$('#searchForm').prop('action','/pt/ptUpdate.do');
		$('#searchForm').submit();
	}
}

function deletePt(){
	
	if(!confirm('삭제하시겠습니까?')){
		return;
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/pt/ptDeleteAction.do",
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
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.!');
		}
	});	
}

function goList(){
	$('#searchForm').submit();
}

function lesson(){
	
	if( $('#lessonLearned').val()=='' ){
		alert('내용을 입력하세요.');
		$('#lessonLearned').focus();
		return;
	}
	
	if(!confirm('저장하시겠습니까?')) return;	
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/pt/lessonUpdateAction.do",
		cache : false,
		async : false,
		data : $("#lessonForm").serialize(),
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

function rePt(){
	
	if(!confirm('재PT를 작성하시겠습니까?')) return;
	
	$('#upperPtId').val('${params.ptId}');
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/pt/ptInsert.do');
	$('#searchForm').submit();
}

function docOpenDt(){
	
	if( $('#docOpenDt').val()=='' ){
		alert('문서공개일을 선택 하세요.');
		$('#docOpenDt').focus();
		return;
	}
	
	if(!confirm('저장하시겠습니까?')) return;	
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/pt/docOpenDtUpdateAction.do",
		cache : false,
		async : false,
		data : $("#docOpenDtForm").serialize(),
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
			console.log(errorThrown);
			console.log(status);
			alert('시스템 오류입니다. 잠시 후 다시 시도해 주세요.');
		}
	});	
}


function streamDocPop(viewInfo){
		var win = "";
		var width = 1600, height = 800 ;
		var left = (screen.width - width) / 2 ;
		var top = (screen.height - height) / 2 ;
		//팝업 노출 
		win = window.open("http://${ctx }:3001/streamdocs/viewer.html?viewInfo=" + viewInfo, 'popup','width=' + width +  ', height=' + height +  ', left=' + left +  ', top=' + top + ',scrollbars=no,toolbars=no,location=no');
		
		return false;
}

function streamDocPop2(viewInfo){
	var win = "";
	var width = 1600, height = 800 ;
	var left = (screen.width - width) / 2 ;
	var top = (screen.height - height) / 2 ;
	//팝업 노출 
	win = window.open("http://${ctx }:3000/view?id=" + viewInfo, 'popup','width=' + width +  ', height=' + height +  ', left=' + left +  ', top=' + top + ',scrollbars=no,toolbars=no,location=no');

	return false;
}
</script>

<form id="searchForm" method="GET" action="/pt/ptList.do">
	<input type="hidden" name="searchStart" value="<c:out value='${params.searchStart}'/>"/> 
	<input type="hidden" name="searchEnd" value="<c:out value='${params.searchEnd}'/>"/>
	<input type="hidden" name="searchBizCd" value="<c:out value='${params.searchBizCd}'/>"/>
	<input type="hidden" name="searchPtResultCd" value="<c:out value='${params.searchPtResultCd}'/>"/>
	<input type="hidden" name="searchRivalCd" value="<c:out value='${params.searchRivalCd}'/>"/>
	<input type="hidden" name="searchType" value="<c:out value='${params.searchType}'/>"/>
	<input type="hidden" name="searchText" value="<c:out value='${params.searchText}'/>"/>
	<input type="hidden" name="orderBy" value="<c:out value='${params.orderBy}'/>"/>
	<input type="hidden" name="pageNo" value="<c:out value='${params.pageNo}'/>"/>
	<input type="hidden" name="ptId" value="<c:out value='${params.ptId}'/>"/>
	<input type="hidden" name="searchRegId" value="<c:out value="${params.searchRegId}"/>"/>
	<input type="hidden" id="upperPtId" name="upperPtId"/>
	<input type="hidden" id="ptCateCd" name="ptCateCd" value="<c:out value="${params.ptCateCd}"/>"/>
</form>

<h2 class="mb60">PT Report</h2>

<table class="tableComm mb30">
	<caption>PT Report 등록</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:35%;">
		<col style="width:10%;">
		<col style="width:15%;">
		<col style="width:10%;">
		<col style="width:15%;">
	</colgroup>
	<tbody>
		<tr>
			<th>제목 </th>
			<td colspan="5">
				<c:out value='${pt.TITLE}'/>
			</td>
		</tr>
		<tr>
			<th>Client명 </th>
			<td>
				<c:out value="${pt.CLIENT_NM}"/>
			</td>
			<th>품목 </th>
			<td>
				<c:out value="${pt.ITEM}"/>
			</td>
			<th>업종 </th>
			<td>
				<c:out value="${pt.BIZ_NM}"/>
			</td>		
		</tr>
		<tr>
			<th>참여사</th>
			<td colspan="5">
				<c:forEach var="rival" items="${rivalList}" varStatus="status">
					<c:if test="${status.index > 0}">,</c:if>
					<c:out value='${rival.RIVAL_NM}'/>
				</c:forEach>			
			</td>
		</tr>
		<tr>
			<th>OT일 </th>
			<td>
				<fmt:formatDate value='${pt.OT_DT}' pattern='yyyy-MM-dd'/>
			</td>
			<th>PT일 </th>
			<td>
				<fmt:formatDate value='${pt.PT_DT}' pattern='yyyy-MM-dd'/>
			</td>
			<th>PT유형 </th>
			<td>
				<c:out value="${pt.PT_TYP_NM}"/>
			</td>		
		</tr>	
		<tr>
			<th>예산</th>
			<td colspan="5">
				<c:out value='${pt.AD_BUDGET}'/>
			</td>
		</tr>	
		<tr>
			<th>PT 참여자 </th>
			<td colspan="5">
				<c:out value="${fn:replace(pt.CO_ATTEND,lf,'<br/>')}" escapeXml="false"/>
			</td>
		</tr>
		<tr>
			<th>광고주담당자 </th>
			<td colspan="5">
				<c:out value="${fn:replace(pt.AD_ATTEND,lf,'<br/>')}" escapeXml="false"/>
			</td>
		</tr>	
		<tr>
			<th>계약기간</th>
			<td colspan="2">
				<c:if test="${not empty pt.CONT_START_DT}">
					<fmt:formatDate value='${pt.CONT_START_DT}' pattern='yyyy-MM-dd'/>
				</c:if>
				<c:if test="${not empty pt.CONT_END_DT}">
					~ <fmt:formatDate value='${pt.CONT_END_DT}' pattern='yyyy-MM-dd'/>
				</c:if>
			</td>
			<th>평가기준</th>
			<td colspan="2">
				<c:out value="${pt.EVAL_STAND}"/>
			</td>		
		</tr>							
	</tbody>
</table>

<table class="tableComm mtable1 mb30">
	<caption>PT과제 및 기타사항</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>PT내용</th>
			<td>
				<div class="bx05">
					<c:out value="${fn:replace(pt.PT_CONT,lf,'<br/>')}" escapeXml="false"/>
				</div>
			</td>
		</tr>	
		<tr>
			<th>기타사항</th>
			<td>
				<div class="bx05">
					<c:out value="${fn:replace(pt.ETC_ITEM,lf,'<br/>')}" escapeXml="false"/>
				</div>
			</td>
		</tr>
	</tbody>
</table>

<h3>결과 작성</h3>

<table class="tableComm mb40">
	<caption>결과 작성</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:50%;">
		<col style="width:15%;">
		<col style="width:20%;">
	</colgroup>
	<tbody>
		<tr>
			<th>PT 결과 </th>
			<td>
				<c:out value="${pt.PT_RESULT_NM}"/>
			</td>
			<th>선정 업체</th>
			<td>
				<c:out value='${pt.OPTAIN_CORP}'/>
			</td>
		</tr>
		<tr>
			<th>광고주 <br>feedback</th>
			<td colspan="3">
				<div class="bx05">
					<c:out value="${fn:replace(pt.FEEDBACK,lf,'<br/>')}" escapeXml="false"/>
				</div>
			</td>
		</tr>
		<tr>
			<th>광고주 OT과제</th>
			<td colspan="3">
				<c:set var="i" value="0"/>	
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_01'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3001/streamdocs/viewer.html?viewInfo=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>
			</td>
		</tr>
		<tr>
			<th>Fact Book</th>
			<td colspan="3">
				<c:set var="i" value="0"/>	
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_02'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3001/streamdocs/viewer.html?viewInfo=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>	
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>					
			</td>
		</tr>	
		<tr>
			<th>OT Brief</th>
			<td colspan="3">
				<c:set var="i" value="0"/>
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_03'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3001/streamdocs/viewer.html?viewInfo=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>			
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>						
			</td>
		</tr>	
		<tr>
			<th>발표용 기획서</th>
			<td colspan="3">
				<c:set var="i" value="0"/>
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_04'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3001/streamdocs/viewer.html?viewInfo=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>			
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>					
			</td>
		</tr>
		<tr>
			<th>제출용 기획서</th>
			<td colspan="3">
				<c:set var="i" value="0"/>
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_05'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3001/streamdocs/viewer.html?viewInfo=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>			
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>						
			</td>
		</tr>		
		<tr>
			<th>제작 시안</th>
			<td colspan="3">
				<c:set var="i" value="0"/>
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_06'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3000/view?id=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<%-- <a href="http://${ctx }:3000/view?id=<c:out value='${att.Viewinfo}'/>" class="btn btn05">다운로드</a> --%>
						<a href="#" class="btn btn05" onclick="streamDocPop2('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>			
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>						
			</td>
		</tr>	
		<tr>
			<th>기타</th>
			<td colspan="3">
				<c:set var="i" value="0"/>
				<c:forEach var="att" items="${attList}" varStatus="status">
					<c:if test="${att.ATTACH_TYP eq 'ATT_PT_99'}">
						<div class="bx12 dpinblock">
							<p class="file">
								<a href="http://${ctx }:3000/view?id=<c:out value='${att.Viewinfo}'/>">
									<c:out value="${att.ORG_FILE_NM}"/>
								</a>
							</p>
						</div>
						<a href="#" class="btn btn05" onclick="streamDocPop('<c:out value='${att.Viewinfo}'/>')">보기</a>
						<c:if test="${pt.SUPER_YN eq 'Y'}">
							<a href="/upload/downloadFile.do?bid=<c:out value='${att.BID}'/>&uploadSeq=<c:out value='${att.UPLOAD_SEQ}'/>" class="btn btn01 goBtn">download</a>
						</c:if>
						<c:set var="i" value="${i+1}"/>
					</c:if>			
				</c:forEach>
				<c:if test="${i eq 0}">
					<div class="bx12">
						<p class="file">
							파일없음
						</p>
					</div>						
				</c:if>					
			</td>
		</tr>													
	</tbody>
</table>

<form id="lessonForm">
<table class="tableComm mb15">
	<caption>결과 작성</caption>
	<colgroup>
		<col style="width:15%;">
		<col style="width:auto;">
	</colgroup>
	<tbody>
		<tr>
			<th>Lesson<br>Learned</th>
			<td>
				<c:choose>
					<c:when test="${
						loginVO.posCd eq 'POS_00010' 
						or loginVO.posCd eq 'POS_00020' 
						or loginVO.posCd eq 'POS_00030' 
						or loginVO.posCd eq 'POS_00040' 
						or loginVO.posCd eq 'POS_00050' 
						or loginVO.posCd eq 'POS_00060'}">
						
						<input type="hidden" name="ptId" value="<c:out value='${params.ptId}'/>"/>
						<textArea name="lessonLearned" title="Lesson Learned" class="fuTextarea"><c:out value="${pt.LESSON_LEARNED}"/></textArea>
						<button type="button" id="lessonBtn" class="btn btnGray2" style="width:98px; height:68px; line-height:68px;">저장</button>
					</c:when>
					<c:otherwise>
						<div class="bx05">
							<c:out value="${fn:replace(pt.LESSON_LEARNED,lf,'<br/>')}" escapeXml="false"/>
						</div>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</tbody>
</table>
</form>

<!-- 수퍼 어드민 문서 공개일 노출  및 수정이 가능 -->
<c:if test="${pt.SUPER_YN eq 'Y'}">
	<div class="bx01 tac mb40">
			<strong class="black">문서공개일</strong>
		<input  type="text" id="docOpenDtView" name="docOpenDtView" value="<fmt:formatDate value='${pt.DOC_OPEN_DT}' pattern='yyyy-MM-dd'/>" style="width:25%;" disabled="disabled" >
	</div>
</c:if>

<div id="viewDiv">
	<button type="button" id="excelBtn" class="btn btn05 mb40">작성 내용 엑셀 다운로드</button>
	
	<div class="tac mb30">
		<c:if test="${pt.SUPER_YN eq 'Y'}">
			<button type="button" id="deleteBtn" class="btn btnMid btnRed" style="width:150px;">삭제</button>
		</c:if>
		<%-- <c:if test="${pt.REG_ID eq params.mid}"> --%>
		<c:if test="${pt.SUPER_YN eq 'Y'}">
			<button type="button" id="updateBtn" class="btn btnMid btnBlue ml10" style="width:150px;">수정</button>
		</c:if>
	</div>
</div>

<%-- <c:if test="${pt.REG_ID eq params.mid and pt.SUBMIT_YN eq 'Y'}"> --%>
<c:if test="${pt.SUPER_YN eq 'Y'}">
<div id="updateDiv" style="display:none">
	<form id="docOpenDtForm">
	<div class="bx01 tac mb40">
		<strong class="black">문서공개일 설정 <span class="red">*</span></strong>
		<input type="hidden" name="ptId" value="<c:out value='${params.ptId}'/>"/>
		<input type="text" id="docOpenDt" name="docOpenDt" value="<fmt:formatDate value='${pt.DOC_OPEN_DT}' pattern='yyyy-MM-dd'/>" style="width:25%;" readOnly>
	</div>
	</form>
	<div class="tac mb30">
		<c:if test="${pt.PT_RESULT_CD eq 'PTR_R' and pt.CHILD_PT_CNT eq 0}">
		<button type="button" class="btn btnMid btnBlue" style="width:150px;" onclick="rePt();">재PT 작성</button>
		</c:if>
		<button type="button" class="btn btnMid btnRed ml10" style="width:150px;" onclick="docOpenDt();">문서공개일 수정</button>
	</div>
</div>
</c:if>

<%@include file="/WEB-INF/views/include/footer.jsp"%>