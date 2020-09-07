<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"> 
<meta content="email=no,telephone=no" name="format-detection"/>
<title>问卷调查</title>
<%@include file="/WEB-INF/page/include/source.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link href="resource/wj/css/basic.css" type="text/css" rel="stylesheet">
</head>
<script type="text/javascript">
	function toResult(qid){
		window.href = "web/toqueryratio?problemId="+qid;
	}
	$(function()
		window.href = "web/toqueryratio?problemId="+qid;
	});
</script>
<body>
<div class="jieguo">
  <ul>
   <c:forEach items="${rows}" var="row" varStatus="i">
   		<li>Q${i.count }.${row.title }:${row.content}<span ><a href="web/toqueryratio?problemId=${row.qid }" style="color: white;">结果</a></span></li>
   </c:forEach>
  </ul>
</div>
</body>
</html>
