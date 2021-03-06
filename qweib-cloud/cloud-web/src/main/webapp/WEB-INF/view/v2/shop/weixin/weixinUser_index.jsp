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
		<title>微信用户</title>
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/login/js/jquery-ui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcstkout.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
		<script src="<%=basePath %>/resource/select/js/jquery.autocompleter.js"></script>
		<script src="<%=basePath %>/resource/pingyin.js"></script>
		<style>
   		 	tr{cursor: pointer;}
   		 	.newColor{background-color: skyblue}
		</style>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
</script>
	<body>
	<%
	if(session.getAttribute("name")==null || session.getAttribute("name")=="")
	{
		String name= request.getParameter("name");
		name=new String(name.getBytes("ISO-8859-1"),"UTF-8"); 
		 
	    
	    if(name !=null && null !="")
	    {
	    	session.setAttribute("name",name);
	    }
	}
	
   
	%>
		<div id="userInfo" >
			<p>驰用T3商城首页</p>
				
			<%
			if(session.getAttribute("name") !=null  ){
				if(session.getAttribute("name").toString().length()>0){
					%>
					<p><%=session.getAttribute("name")%>,您已经注册！</p>
					<%
					}
				else{
					%>
					<p>您是未注册用户！</p>
					<%
				}

			}
			%>

			</div>
		</div>
		
	</body>
	<script type="text/javascript">

	</script>
	
</html>