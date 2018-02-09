<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/admin/include/header.jsp"%>

<script>
$(document).ready(function(){

	$(this).attr("title", "사용이력 조회 상세 | 포인트 관리 | M-Library Admin");
	
	$('#saveBtn').click(function(){
		save();
	});
	
	$('#useBtn').click(function(){
		use();
	});
	
});

function save(){

	var form = $('#saveForm');
	
	if($(form).find('select[name=pointTyp]').val()==''){
		alert('적립항목을 선택하세요');
		$(form).find('select[name=pointTyp]').focus();
		return;
	}
	
	if($(form).find('input[name=point]').val()==''){
		alert('적립포인트를 입력하세요');
		$(form).find('select[name=point]').focus();
		return;		
	}
	
	if(!confirm('적립하시겠습니까?')){
		return;
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/point/pointSaveAction.do",
		cache : false,
		async : false,
		data : $(form).serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('적립되었습니다.');
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

function use(){

	var form = $('#useForm');
	
	if($(form).find('select[name=pointTyp]').val()==''){
		alert('차감항목을 선택하세요');
		$(form).find('select[name=pointTyp]').focus();
		return;
	}
	
	if($(form).find('input[name=point]').val()==''){
		alert('차감포인트를 입력하세요');
		$(form).find('select[name=point]').focus();
		return;		
	}
	
	if(!confirm('차감하시겠습니까?')){
		return;
	}
	
	// 세션체크
	if( sessionCheck() == false ) { sessionOut(); return; }
	
	$.ajax({
		type : "POST",
		url : "/admin/point/pointSaveAction.do",
		cache : false,
		async : false,
		data : $(form).serialize(),
		dataType : "json",				
		success : function(data) {		
			if(data.result=='true'){
				alert('차감되었습니다.');
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

function goPage(pageNo){
	$('#pageNo').val(pageNo);
	search();
}

function search(){
	$('#searchForm').prop('method','GET');
	$('#searchForm').prop('action','/admin/point/pointViewList.do');
	$('#searchForm').submit();
}

</script>

<form id="searchForm">
	<input type="hidden" id="mid" name="mid" value="<c:out value='${params.mid}'/>"/>
	<input type="hidden" id="pageNo" name="pageNo" value="<c:out value='${listPage.currentPage}'/>"/>	
</form>

<h2 class="mb50">사용 이력 조회 <span class="adminH2">|</span> <span class="red">상세</span></h2>

<fieldset>
	<legend>사용 이력 조회 상세</legend>
</fieldset>


<div class="bx07 mb50 adminDetail">
	<ul class="admList">
		<li class="layer1">
			<p class="mb15">
				<strong class="tit03">구성원정보</strong>
				<strong class="tx01"><span><c:out value="${member.MEMBER_NM}"/></span>(<span><c:out value="${member.MID}"/></span>)</strong>
			</p>
			<p class="">
				<strong class="tit03">소속 정보</strong>
				<strong class="tx01"><span><c:out value="${member.CENTER_NM}"/></span>
				<c:if test="${not empty member.TEAM_NM}">
					<span class="ml10 mr10">|</span> <span> <c:out value="${member.TEAM_NM}"/></span>
				</c:if>
				</strong>
			</p>
			
		</li>
		<li class="layer2">
			<strong class="tit03">적립포인트</strong>
			<strong class="tx01 red"><span><fmt:formatNumber value="${sumPoint}" groupingUsed="true" /></span> <span>P</span></strong>
			<button type="button" class="btn btnSmall btnBlue ml20" id="btnAdmPlus">적립</button>
			<button type="button" class="btn btnSmall btnRed ml5" id="btnAdmMinus">차감</button>

			<!-- layerpop 적립 포인트 입력 -->
			<form id="saveForm">
			<div class="layerp layerp1">
				<strong class="tit05">적립 포인트 입력</strong>
				<input type="hidden" name="mid" value="<c:out value='${member.MID}'/>"/>
				<select title="검색범위선택" style="width:150px;" name="pointTyp">
					<option value="">전체</option>
					<c:forEach var="regTyp" items="${regTypList}" varStatus="status">
					<option value="<c:out value="${regTyp.POINT_TYP}"/>"><c:out value="${regTyp.POINT_GUBUN_NM}"/></option>
					</c:forEach>					
				</select>
				<input type="text" name="point" title="적립 포인트 입력" style="width:90px;"> P
				<button type="button" id="saveBtn" class="btn btnSmall btnBlue ml15">적용</button>
				<button type="button" title="닫기" class="closeBtn"><img src="/resources/images/btn_del.png" alt="닫기"></button>	<!-- 2016-12-12 추가 -->
			</div>
			</form>
			<!-- layerpop 적립 포인트 입력 // -->

			<!-- layerpop 차감 포인트 입력 -->
			<form id="useForm">
			<div class="layerp layerp2">
				<strong class="tit05">차감 포인트 입력</strong>
				<input type="hidden" name="mid" value="<c:out value='${member.MID}'/>"/>
				<select title="검색범위선택" style="width:150px;" name="pointTyp">
					<option value="">전체</option>
					<c:forEach var="useTyp" items="${useTypList}" varStatus="status">
					<option value="<c:out value="${useTyp.POINT_TYP}"/>"><c:out value="${useTyp.POINT_GUBUN_NM}"/></option>
					</c:forEach>						
				</select>
				<input type="text" name="point" title="적립 포인트 입력" style="width:90px;"> P
				<button type="button" id="useBtn" class="btn btnSmall btnBlue ml15">적용</button>
				<button type="button" title="닫기" class="closeBtn"><img src="/resources/images/btn_del.png" alt="닫기"></button>	<!-- 2016-12-12 추가 -->
			</div>
			</form>
			<!-- layerpop 차감 포인트 입력 // -->
		</li>
		
	</ul>
</div>

<div class="listinfo">
	<p class="count">전체 <span><fmt:formatNumber value="${listPage.totalCount}" groupingUsed="true" /></span>건</p>
</div>

<table class="tableComm table1 tableType1 mb15">
	<caption class="">통계조회 리스트</caption>
	<colgroup>
		<col style="width:12%;">
		<col style="width:22%;" span="4">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">NO</th>
			<th scope="col">적립일자</th>
			<th scope="col">메뉴명</th>
			<th scope="col">적립유형</th>
			<th scope="col">적립 포인트</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="result" items="${listPage.list}" varStatus="status">
		<tr>
			<td><c:out value="${listPage.totalCount - result.RNUM + 1}"/></td>
			<td><fmt:formatDate value="${result.REG_DTM}" pattern="yyyy.MM.dd"/></td>
			<td><c:out value="${result.POINT_GUBUN_NM}"/></td>	<!-- 2016-12-13 left 정렬 : class="tal" 추가 -->
			<td><c:out value="${result.POINT_CLASS_NM}"/></td>
			<td><fmt:formatNumber value="${result.POINT}" groupingUsed="true" /></td>
		</tr>
		</c:forEach>
		<c:if test="${empty listPage.list}">
			<tr>
				<td colspan="5" align="center">검색 결과가 없습니다.</td>
			</tr>
		</c:if>			
	</tbody>
</table>

<div class="paging">
	<c:out value="${listPage.pageString}" escapeXml="false" />
</div>

<%@include file="/WEB-INF/views/admin/include/footer.jsp"%>
