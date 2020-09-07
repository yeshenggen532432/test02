<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商城会员地址列表</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
		
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopMemberAddress/page?hyId=${hyId }" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="name" width="100" align="center">
						会员名称
					</th>
					<th field="linkman" width="100" align="center">
						联系人
					</th>
					<th field="mobile" width="100" align="center" >
						手机号
					</th>
					<th field="address" width="200" align="center">
						地址
					</th>
				</tr>
			</thead>
		</table>
	</div>
		
		<script type="text/javascript">
		    
			   
		</script>
	</body>
</html>
