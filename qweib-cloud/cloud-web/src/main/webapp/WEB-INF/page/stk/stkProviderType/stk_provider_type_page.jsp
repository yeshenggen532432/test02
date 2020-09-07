<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>供应商类别列表</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
		<script type="text/javascript" src="resource/dtree.js"></script>
		<style>
	    </style>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/stkProviderType/pages" title="供应商类别列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: eidt">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="name" width="120" align="center">
						名称
					</th>
					<th field="remark" width="120" align="center">
						备注
					</th>

				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		     名称: <input name="name" id="name" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toAdd();">添加</a>

		</div>
		<script type="text/javascript">
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkProviderType/pages",
					name:$("#name").val()
				});
			}
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			//添加
			function toAdd(){
				parent.closeWin('供应商类别新增');
				parent.add('供应商类别新增','manager/stkProviderType/edit');
			}
			function eidt(rowIndex, rowData){
				parent.closeWin('供应商类别信息' + rowData.id);
				parent.add('供应商类别信息' + rowData.id,'manager/stkProviderType/edit?id=' + rowData.id);
			}
		</script>
	</body>
</html>
