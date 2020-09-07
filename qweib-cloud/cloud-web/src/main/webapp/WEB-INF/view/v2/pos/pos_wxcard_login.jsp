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
<!--<div id="userInfo" >
		 <p>驰用T3商城首页</p>
			<input type="hidden" id="wid"  value="<%= request.getAttribute("wid").toString()%>" >
			<input type="hidden" id="openId"  value="<%= request.getAttribute("openId").toString()%>">
			</div>
		</div>-->
</body>
<script type="text/javascript">
    $(function () {
        //var wid=$("#wid").val();
        //var openId=$("#openId").val();
        var wid="<%= request.getAttribute("wid").toString()%>";
        var openId="<%= request.getAttribute("openId").toString()%>";
        var getUrl_url="/web/wxcardlogin?openId="+openId+"&companyId="+wid;
        var msg=$.ajax({url:getUrl_url,async:false});
        var json=$.parseJSON( msg.responseText ) ;
        window.location.href =json.url;
    });
</script>
</html>