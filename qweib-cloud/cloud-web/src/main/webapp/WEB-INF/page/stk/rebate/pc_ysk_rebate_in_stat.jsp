<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>付货款管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body onload="initGrid()">
<div id="tb" style="padding:5px;height:auto;">
	往来单位: <input class="easyui-textbox" name="proName" id="proName" style="width:120px;" onkeydown="querydata();"/>

	发票日期: <input class="easyui-textbox" readonly="readonly" name="sdate" id="sdate"  onClick="WdatePicker();"  style="width: 70px;"  />
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"  height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input class="easyui-textbox" name="edate" readonly="readonly" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	返利金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
	到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />
	<br/>
	<a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showPayList();">收纪录</a>
	<a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:toUnitRecPage();">待收款返利单据</a>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>


</div>
<table id="datagrid" fit="true" singleSelect="true"
	   title="" iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="true" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]"
	   data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
</table>


<script type="text/javascript">
	function initGrid()
	{
		var cols = new Array();
		var col = {
			field: 'proId',
			title: 'proId',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);

		var col = {
			field: 'proName',
			title: '往来单位',
			width: 200,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'disAmt',
			title: '返利金额',
			width: 100,
			align:'center',
			formatter:amtformatter

		};
		cols.push(col);


		var col = {
			field: 'payAmt',
			title: '已返金额',
			width: 100,
			align:'center',
			formatter:amtformatter

		};
		cols.push(col);
		var col = {
			field: 'freeAmt',
			title: '核销金额',
			width: 60,
			align:'center',
			formatter:amtformatter

		};
		cols.push(col);
		var col = {
			field: 'totalAmt',
			title: '剩余应收返利',
			width: 120,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		$('#datagrid').datagrid({
					url:'manager/stkRebateIn/queryRebateInStatPage',
					fitColumns:false,
					rownumbers:true,
					pagination:true,
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						proName:$("#proName").val(),
						beginAmt:$("#beginAmt").val(),
						endAmt:$("#endAmt").val()
					},
					columns:[
						cols
					]
				}
		);
	}

	function querydata(){
		$("#datagrid").datagrid('load',{
			url:"manager/stkRebateIn/queryRebateInStatPage",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
			proName:$("#proName").val(),
			beginAmt:$("#beginAmt").val(),
			endAmt:$("#endAmt").val()
		});
	}

	function amtformatter(v,row)
	{
		if(v == null)return "";
		if(v=="0E-7"){
			return "0.00";
		}
		if (row != null) {
			return numeral(v).format("00.00");
		}
	}

	function onDblClickRow(rowIndex, rowData)
	{
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		parent.closeWin('待收款返利单据');
		parent.add('待收款返利单据','manager/stkRebateIn/toRebateInList?sdate=' + sdate + '&edate=' + edate + '&proName=' + rowData.proName);

	}
	function showPayList()
	{
		parent.closeWin('收款记录');
		parent.add('收款记录','manager/queryRecPageByBillId?outType=2&dataTp=1');
	}

	function toUnitRecPage()
	{
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		var proName = $("#proName").val();
		parent.closeWin('待收款返利单据');
		parent.add('待收款返利单据','manager/stkRebateIn/toRebateInList?sdate=' + sdate + '&edate='+ edate +'&proName='+proName);
	}

</script>
</body>
</html>
