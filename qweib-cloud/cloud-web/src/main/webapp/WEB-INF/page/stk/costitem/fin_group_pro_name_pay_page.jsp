<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>企微宝</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>


</head>

<body onload="initGrid()">
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
	   title="" iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="false" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
	<thead>
	<tr>

	</tr>
	</thead>
</table>

<div id="tb" style="padding:5px;height:auto">
	<div style="margin-bottom:5px">
	</div>
	<div>
		付款对象: <input name="proName" id="proName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		付款日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
		<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		-
		<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
		<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

		状态: <select name="status" id="status">
		<option value="">全部</option>
		<option value="0">暂存</option>
		<option value="1" selected>已审核</option>
		<option value="2">作废</option>
		<option value="3">被冲红单</option>
		<option value="4">冲红单</option>
	</select>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
	</div>
</div>

<script type="text/javascript">
	function initGrid()
	{


		var cols = new Array();
		var col = {
			field: 'proName',
			title: '付款对象',
			width:200,
			align:'center'

		};
		cols.push(col);

		var col = {
			field: 'payAmt',
			title: '付款金额',
			width: 150,
			align:'center'

		};
		cols.push(col);

		$('#datagrid').datagrid({
					url:"manager/queryGroupProNamePayPage",
					queryParams:{
						proName:$("#proName").val(),
						status:$("#status").val(),
						sdate:$("#sdate").val(),
						edate:$("#edate").val()
					},
					columns:[
						cols
					]
				}
		);
	}

	function queryorder(){
		$("#datagrid").datagrid('load',{
			url:"manager/queryGroupProNamePayPage",
			proName:$("#proName").val(),
			status:$("#status").val(),
			sdate:$("#sdate").val(),
			edate:$("#edate").val()
		});
	}

	function toQuery(e){
		var key = window.event?e.keyCode:e.which;
		if(key==13){
			queryorder();
		}
	}

	function onDblClickRow(rowIndex, rowData)
	{
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		var status = $("#status").val();
		parent.parent.closeWin(rowData.proName+'_付款单据');
		parent.parent.add(rowData.proName+'_付款单据','manager/toFinPayHis?sdate='+sdate+'&edate='+edate+'&status='+status+'&proName=' + rowData.proName);

	}


</script>
</body>
</html>
