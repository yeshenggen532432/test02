<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<c:set var="base" value="<%=basePath%>" />
<meta http-equiv="X-UA-Compatible" content="IE=8">
<meta HTTP-EQUIV="pragma" CONTENT="no-cache"> 
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate"> 
<meta HTTP-EQUIV="expires" CONTENT="0">
<script type="text/javascript" src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
<%--<script type="text/javascript" src="<%=basePath%>/static/qwbui/jquery/jquery.min.js"></script>--%>

<script type="text/javascript" src="<%=basePath%>/resource/jquery.easyui.min.js"></script>
 <%-- <script type="text/javascript" src="<%=basePath%>/resource/easyui/js/jquery.easyui.min.js"></script> --%>
<script type="text/javascript" src="<%=basePath%>/resource/formValidator/formValidator-4.1.3.js"></script>

<%-- <link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/themes/icon.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/cxxwwss/style.css"> --%>

 <link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/easyui/icon.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/css/style.css">
<link rel="stylesheet" href="<%=basePath%>/resource/kindeditor/themes/default/default.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>/static/qwbui/layui/css/layui.mobile.css">
<!-- <link rel="icon" href="resource/ico/favicon.ico" type="image/x-icon" /> -->
<link rel="icon" href="<%=basePath%>/resource/ico/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="<%=basePath%>/resource/ico/favicon.ico" type="image/x-icon" />
<script type="text/javascript" src="<%=basePath%>/resource/formValidator/formValidatorRegex.js"></script>
<script type="text/javascript" src="<%=basePath%>/resource/common.js"></script>
<script type="text/javascript" src="<%=basePath%>/resource/showMsg.js"></script>
<script src="<%=basePath%>/static/qwbui/layui/layui.js"></script>
<script>
 $(function(){

 })
 function getToken(callback) {
  $.ajax({
   url: '${base}web/im/token?token=',
   type: 'get',
   dataType: 'json',
   success: function (response) {
    if (response.success) {
     callback(response.data)
    }
   }
  })
 }


 function startIM() {
  getToken(function (token) {
   imLayer = layer.open({
    id: 'qwbim',
    shade: false,
    closable: false,
    resizable: true,
    type: 2,
    content: 'http://localhost:8082/qwbim?token=' + token + '#/client?targetId=285&title=企微宝客服',
    area: ['400px', '600px'],
    maxmin: true,
    title: '欢迎咨询企微宝客服'
   })
  });
 }
</script>
<script>
 var CTX = '${base}',_STICKY='${_sticky}';
</script>
<%@include file="/WEB-INF/page/include/handleFile.jsp"%>