<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body class="easyui-layout">
	<input type="hidden" id="typeId" value=${typeId} />
	<input type="hidden" id="itemId" value=${itemId} />
		<div style="margin-top:10px"> 
		</div>
		</div>
		<div data-options="region:'west',split:true,title:'往来类别'"
			style="width:300px;padding-top: 5px;">
			<table id="costTypeId" class="easyui-datagrid" fit="true" singleSelect="true"
					url="manager/queryIoTypeListTemplate" title="" iconCls="icon-save" border="false" rownumbers="true"
			 		fitColumns="true" data-options="onClickRow: onClickRow1">
					<thead>
					<tr>
				    <th field="id" width="80" align="center" hidden="true">
						编号
					</th>
					 <th field="typeName" width="100" align="center">
						类别名称
					</th>
					</tr>
					</thead>
			
					</table>
			
		</div>
		<div id="wareTypeDiv" data-options="region:'center'" title="费用信息">
			<table id="itemgrid" class="easyui-datagrid" fit="true" singleSelect="true"
					url="manager/queryIoItemListTemplate" title="" iconCls="icon-save" border="false" rownumbers="true"
			 		fitColumns="true" >
					<thead>
					<tr>
				    <th field="id" width="80" align="center" hidden="true">
						编号
					</th>
					 
					<th field="itemName" width="150" align="center">
						项目名称
					</th>
					
					 <th field="remarks" width="150" align="center">
						备注
					</th>
					</tr>
					</thead>
			
					</table>
		</div>
		
		<script type="text/javascript">
			function onClickRow1(index, row){
				
				queryItem(row.id);
			}

			function queryItem(typeId){
				$("#itemgrid").datagrid('load',{
					url:"manager/queryIoItemListTemplate",
					typeId:typeId
				});
			}
		</script>
	</body>
</html>
