<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>

	<body>
			<input type="hidden" name="wareId" id="wareId" value="${wareId}"/>
			<input type="hidden" name="customerId" id="customerId" value="${customerId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="<%=basePath%>/manager/dialogCustomerWarePricePage?wareId=${wareId}&customerId=${customerId}" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"  >
			<thead>
				<tr>
					<th field="ware_nm" width="150" align="left">
						销售商品
					</th>
					<th field="ware_dw" width="80" align="center">
						销售单位
					</th>
					<th field="price" width="60" align="center">
						销售价格
					</th>
				</tr>
			</thead>
		</table>
	</body>
</html>
