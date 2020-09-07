<%--
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
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
	$(function () {
		//var wid=$("#wid").val();
		//var openId=$("#openId").val();
		var wid="${wid}";
		var openId="${openId}";
        var nickName="${nickName}";
        var picUrl="${picUrl}";
        var sexStr="${sexStr}";
        var country="${country}";
        var province="${province}";
        var city="${city}";
		var postUrl_url="/web/wxlogin";
		var msg=$.ajax({
			url:postUrl_url,
            data:{"openId":openId,"companyId":wid,
				"nickName":nickName,"picUrl":picUrl,"sexStr":sexStr,
				"country":country,"province":province,"city":city},
            type:"post",
			async:false
		});
	    var json=$.parseJSON( msg.responseText ) ;
		window.location.href =json.url;
	});
	</script>
</html>--%>
