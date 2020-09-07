<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>卡宝包</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/thorder/thorderDetailPage?orderId=${orderId}" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="10" align="center" hidden="true">
						订单详情id
					</th>
					<th field="wareNm" width="100" align="center">
						商品名称
					</th>
					<th field="wareGg" width="60" align="center">
						规格
					</th>
					<th field="wareDw" width="60" align="center">
						单位
					</th>
					<th field="wareNum" width="60" align="center">
						数量
					</th>
					<th field="wareDj" width="60" align="center">
						单价
					</th>
					<th field="xsTp" width="60" align="center">
						销售类型
					</th>
					<th field="wareZj" width="60" align="center">
						总价
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		</div>
		<script type="text/javascript">
		</script>
	</body>
</html>
