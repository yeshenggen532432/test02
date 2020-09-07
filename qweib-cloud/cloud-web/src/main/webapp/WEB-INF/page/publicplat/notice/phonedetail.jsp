<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <META content="IE=10.000" http-equiv="X-UA-Compatible">
	<META http-equiv="Content-Type" content="text/html; charset=utf-8">     
	<META name="viewport" content="width=device-width-32px initial-scale=1.0 maximum-scale=1.0 user-scalable=0"> 
	<META http-equiv="X-UA-Compatibility" content="IE=Edge">     
	<META name="format-detection" content="telephone=yes">
    <base href="<%=basePath%>">
    <title></title>
  </head>
  <body>
  	<div align="center" style="margin-top: 30px;width: auto;">
  		<c:if test="${state==false}">
  			<font color="red">${msg}</font>
  		</c:if>
  	</div>	
	<c:if test="${state==true}">
	<div align="center" style="margin-top: 30px;">
		<p style="font-weight: bolder">${notice.noticeTitle}</p>
		<p style="font-size: 14px;color: #A1A1A1;">${notice.noticeTime}</p>
		<hr align="center" width="80%" style= "border:1 dashed #D3D3D3;" />
	</div>	
	<div style="margin-top: 5px; width: 100%;display:block;word-break: break-all;word-wrap: break-word;">
		<div style="width: 100%;display:block;word-break: break-all;word-wrap: break-word;">
		${notice.noticeContent}
		</div>
	</div>	
	</c:if>
  </body>
</html>
