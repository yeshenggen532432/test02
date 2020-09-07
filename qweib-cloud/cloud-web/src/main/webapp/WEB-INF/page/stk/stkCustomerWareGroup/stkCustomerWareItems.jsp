<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<base href="<%=basePath%>"/>
<c:set var="base" value="<%=basePath%>" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>打印列设置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript" src="${base}resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<style>
			tr{background-color:#FFF;height:30px;vertical-align:middle; padding:3px;}
			td{padding-left:10px;}
		</style>
	</head>
	<body style="text-align: center;">
			<table style="width: 300px" border="1" 
					cellpadding="0" cellspacing="1" id="wareItemsTab" >
			<tr style="font-weight: bold;">
			<td style="width: 40px">序号</td> 
			<td  style="width: 80px">商品名称</td> 
			<td style="width: 80px ">操作</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
			<td>${s.index+1 }
			</td> 
			<td>
				<input id="id" name="id" type="hidden" value="${data.id }"/>
				<input name="wareId" id="wareId"  type="hidden" value="${data.wareId }"/>
				<input name="wareNm" id="wareNm" readonly="readonly" value="${data.wareNm }" type="text" style="border: 0px solid #ddd;" />
			</td> 
			<td><a href="javascript:;;" onclick="toDelItems(${data.id },this)">删除</a></td>
			</tr>
			</c:forEach>
			</table>
	</body>
</html>
