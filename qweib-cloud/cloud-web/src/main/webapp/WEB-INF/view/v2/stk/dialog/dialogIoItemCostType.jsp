<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>选择费用科目</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body >
	
	<table width="100%" height="100%" border="0" cellpadding="0"
			 cellspacing="0" class="tree">
			<tr valign="top" align="left">
				<td align="left"  id="wd" style="width: 200px;" height="100%" >
				<table id="costTypeId" class="easyui-datagrid" fit="true" singleSelect="true"
					url="<%=basePath%>/manager/queryIoTypeList" title=""  border="false" rownumbers="true"
			 		fitColumns="true" data-options="onClickRow: onClickRow1">
					<thead>
					<tr>
				    <th field="id" width="80" align="center" hidden="true">
						编号
					</th>
					 <th field="typeName" width="100" align="center">
						科目名称
					</th>
					</tr>
					</thead>
					</table>
		</td>
		 <td valign="top" align="left">
				<table id="itemgrid" class="easyui-datagrid" fit="true" singleSelect="true"
						url="<%=basePath%>/manager/queryUseIoItemList" title="" iconCls="icon-save" border="false" rownumbers="true"
				 		fitColumns="true" data-options="onDblClickRow: dialogCostOnDblClickRow">
						<thead>
						<tr>
					    <th field="id" width="80" align="center" hidden="true">
							编号
						</th>
						 
						<th field="itemName" width="150" align="center">
							明细科目名称
						</th>
						<th field="typeName" width="150" align="center">
							科目名称
						</th>
						</tr>
						</thead>
						</table>
		</td>
		</tr>
	</table>	
	</body>
</html>