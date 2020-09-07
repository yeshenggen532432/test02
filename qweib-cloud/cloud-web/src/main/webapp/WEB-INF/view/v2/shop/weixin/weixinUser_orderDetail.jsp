<%--
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%@ page import="com.qweib.shop.util.JiaMiCodeUtil"  %>
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
		<title></title>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';
</script>
	<body>
	</body>
	<script type="text/javascript">
	$(function(){
		var openId="<%= request.getParameter("openId")%>";
		var companyId="<%= JiaMiCodeUtil.decode(request.getParameter("companyId"))%>";
		var orderId="<%=request.getParameter("orderId")%>";
		var getToken_url="/web/wxlogin?openId="+openId+"&companyId="+companyId; 
		var msg=$.ajax({url:getToken_url,async:false});
	    var json=$.parseJSON( msg.responseText ) ; 
	    if(json.state){
	    	var token=json.token;
	    	var orderDetail_url="<%=basePath%>/web/shopBforderMobile/toOrderDetails?token="+token+"&id="+orderId;
	    	window.location.href =orderDetail_url;
	    }
	});
	</script>
</html>--%>
