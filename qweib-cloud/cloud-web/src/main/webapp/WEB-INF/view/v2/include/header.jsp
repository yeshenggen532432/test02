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
<link rel="stylesheet" href="${base}/static/uglcs/layui/css/layui.css" media="all">
<link rel="stylesheet" href="${base}/static/uglcs/layui/css/modules/laydate/laydatePro.css" media="all">
<link rel="stylesheet" href="${base}/static/uglcs/style/admin.css" media="all">