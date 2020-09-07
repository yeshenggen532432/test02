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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="<%=basePath%>/manager/dialogCollarWarePage" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"  data-options="onDblClickRow: dialogOnDblClickRow">
			<thead>
				<tr>
				    <th field="item_id" hidden="true"  width="140" align="center" >
						明细ID
					</th>
					<th field="main_id" hidden="true" width="140" align="center" >
						主表ID
					</th>
					<th field="ware_id" width="60"  hidden="true" align="center">
						商品ID
					</th>
					<th field="be_unit" width="60" hidden="true" align="center">
						单位
					</th>
					<th field="ware_nm" width="150" align="left">
						领用商品
					</th>
					<th field="ware_dw" width="80" align="center">
						单位
					</th>
					<th field="qty" width="100"  align="center">
						领用数量
					</th>
					<th field="out_qty" width="100"  align="center">
						剩余数量
					</th>
					<th field="bill_no" width="140" align="center" >
						领用单号
					</th>
					<th field="price" width="60" hidden="true" align="center">
						销售价格
					</th>
				</tr>
			</thead>
		</table>
	</body>
</html>
