<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%@page import="net.sf.json.JSONException" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="org.springframework.context.ApplicationContext" %>
<%@page import="org.springframework.context.support.ClassPathXmlApplicationContext" %>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta HTTP-EQUIV="pragma" CONTENT="no-cache"> 
		<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate"> 
		<meta HTTP-EQUIV="expires" CONTENT="0">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>公众号未配置</title>
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<style>
   		 	tr{cursor: pointer;}
   		 	.newColor{background-color: skyblue}
		</style>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
</script>
	<body>
		<div id="userInfo" >
			<p>公众号未配置</p><BR/>
		</div>
	</body>
</html>