<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>资产汇算表-商品库存</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<style>
			tr{background-color:#FFF;height:30px;vertical-align:middle; padding:3px;}
			td{padding-left:10px;}
		</style>
	</head>
	<body >
		<div id="tb" >
			<table width="600px" border="1" 
					cellpadding="0" cellspacing="1" >
			<tr style="font-size: 12px;font-weight: bold;">
			    <td>仓库</td>
				<td>商品名称</td>
				<td>单位</td>
				<td>数量</td>
				<td>成本</td>
			</tr>		
			<c:set var="totalQty" value="0"/>
			<c:set var="totalAmt" value="0"/>
			<c:forEach items="${datas }" var="data">		
			<tr>
			<td>${data['stk_name'] }</td>
			<td>${data['ware_nm'] }</td>
			<td>${data['unit_name'] }</td>
			<td>
			<fmt:formatNumber value='${data["sumqty"]}' pattern="#,#00.0#"/>
			</td>
			<td>
			<fmt:formatNumber value='${data["sumamt"]}' pattern="#,#00.0#"/>
			</td>
			<c:set var="totalQty" value="${totalQty+data['sumqty']}"/>
			<c:set var="totalAmt" value="${totalAmt+data['sumamt']}"/>
			</tr>
			</c:forEach>
			<tr>
				<td>合计</td>
				<td></td>
				<td></td>
				<td style="color: green">
				<fmt:formatNumber value='${totalQty}' pattern="#,#00.0#"/>
				</td>
				<td style="color: green">
				<fmt:formatNumber value='${totalAmt}' pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</div>
	</body>
</html>
