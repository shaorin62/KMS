<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<html>
<head>
	<title>Home</title>
</head>
<body>
<script src="//www.google.com/jsapi"></script>
<script>
var data = [
  ['원소', '밀도'],
  ['구리', 8.94],
  ['은', 10.49],
  ['금', 19.30],
  ['백금', 21.45],
];
var options = {
  title: '귀금속 밀도 (단위: g/cm³)',
  width: 500, height: 500
};
google.load('visualization', '1.0', {'packages':['corechart']});
google.setOnLoadCallback(function() {
  var chart = new google.visualization.ColumnChart(document.querySelector('#chart_div'));
  chart.draw(google.visualization.arrayToDataTable(data), options);
});
</script>
<div id="chart_div"></div>

<div>
<video src="http://techslides.com/demos/sample-videos/small.mp4" controls></video>
</div>

<c:out value="${test.COUNT}"/>

</body>
</html>
