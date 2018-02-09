<%@ page language="java" session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/WEB-INF/views/include/popHeader.jsp"%>

<script>

$(document).ready(function(){

	$(this).attr("title", "M-Library 서버 이관 긴급공지");
	
	$('#searchBtn').click(function(){
		search();
	});
	
	$('input[type=text]').blur(function(){
		var value = $.trim($(this).val());
		$(this).val(value);
	});
	
});

function search(){
	$('#searchForm').submit();
}

function select(clientCd, clientNm){
	opener.selectClient(clientCd, clientNm);
	window.close();
}

function setCookie(cName, cValue,cDay){

	var expire = new Date();
	
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/' ; 
	
	if(typeof cDay != 'undefined'){
		cookies += ';expire=' + expire.toGMTString() + ';';
	}
	
	document.cookie = cookies;
	
	window.close()
	
}
</script>
<div>
	<img src="/resources/images/pop1.png">
</div>
<div align="left">
	<button  type="button" class="to-close" onclick="setCookie('pop1','noView1',1);" >
		<h1>  ★하루 동안 다시 보지않기 클릭!</h1>
	</button>
</div>
</form>
