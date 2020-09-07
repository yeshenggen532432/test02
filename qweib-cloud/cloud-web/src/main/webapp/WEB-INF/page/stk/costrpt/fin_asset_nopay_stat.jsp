<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>资产汇算表-待付费用</title>
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
				<td>科目类别</td>
				<td>科目名称</td>
				<td>需报销</td>
				<td>已报销</td>
			</tr>		
			<c:set var="totalInAmt" value="0"/>
			<c:set var="totalOutAmt" value="0"/>
			<c:forEach items="${datas }" var="data">		
			<tr>
			<td>${data['type_name'] }</td>
			<td>${data['item_name'] }</td>
			<td>
			<fmt:formatNumber value='${data["in_amt"]}' pattern="#,#00.0#"/>
			</td>
			<td>
			<fmt:formatNumber value='${data["out_amt"]}' pattern="#,#00.0#"/>
			</td>
			<c:set var="totalInAmt" value="${totalInAmt+data['in_amt']}"/>
			<c:set var="totalOutAmt" value="${totalOutAmt+data['out_amt']}"/>
			</tr>
			</c:forEach>
			<tr>
				<td>合计</td>
				<td></td>
				<td style="color: green">
				<fmt:formatNumber value='${totalInAmt}' pattern="#,#00.0#"/>
				</td>
				<td style="color: green">
				<fmt:formatNumber value='${totalOutAmt}' pattern="#,#00.0#"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td style="color: green">
				</td>
				<td style="color: red;font-weight: bold;">
				<fmt:formatNumber value='${totalInAmt-totalOutAmt }' pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
			
		</div>
	</body>
	<script>
	function query(){
		document.getElementById("toFinAssetstatisticsfrm").submit();
	}
	</script>
</html>
