<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"> 
<meta content="email=no,telephone=no" name="format-detection"/>
<title>问卷结果</title>
<%@include file="/WEB-INF/page/include/source.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link href="resource/css/wj.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="wjbox">
	<div class="wj_tit clearfix" align="center">问卷结果</div> 
  <c:forEach items="${rows}" var="row" varStatus="i">
	<div class="wj_tit clearfix"><p>${i.count }.${row.title }:${row.content}</p><a href="web/toqueryratio?problemId=${row.qid }" class="wj_jieguo">结果</a></div>  		
  </c:forEach>
  	  <div class="wj_tijiao">
 	<table width="100%">
  		<tr>
  			<c:if test="${pageNo>1}">
				<td><a href="web/listQuestionnaire?pageNo=${pageNo-1 }" >上一题</a></td>
			</c:if>
  			<c:if test="${pageNo>1&&pageCount>=pageNo+1}">
				<td>&nbsp;</td>
			</c:if>
		  	<c:if test="${pageCount>=pageNo+1}">
		  		<td><a href="web/listQuestionnaire?pageNo=${pageNo+1 }" >下一题</a></td>
			</c:if>
		</tr>
	</table>
	</div>
</div>
</body>
</html>
