<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>收货款管理</title>
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
	客户类型: <select name="customerType" id="customerType" style="width: 100px;"></select>
	业务类型：
	<select id="saleType" name="saleType" onchange="querydata()">
		<option value="">全部</option>
		<option value="001">传统业务类</option>
		<option value="003">线上商城</option>
	</select>
	往来单位: <input class="easyui-textbox" name="khNm" id="khNm" style="width:120px;" onkeydown="querydata();"/>
	发票日期: <input class="easyui-textbox" readonly="readonly" name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 70px;"  />
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"  height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input class="easyui-textbox" name="edate" readonly="readonly" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	返利金额范围:<input name="beginAmt" id="beginAmt" onkeyup="CheckInFloat(this)" style="width:60px;" />
	到<input name="endAmt" onkeyup="CheckInFloat(this)" id="endAmt" style="width:60px;" />
	所属二批: <input class="easyui-textbox" name="epCustomerName" id="epCustomerName" style="width:120px;" onkeydown="querydata();"/>
	<br/>
	<a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:showPayList();">付款纪录</a>
	<a class="easyui-linkbutton" iconCls="icon-redo" href="javascript:toUnitRecPage();">待付款返利单据</a>
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
			field: 'cstId',
			title: 'cstId',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);

		var col = {
			field: 'khNm',
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
			field: 'recAmt',
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
			title: '剩余应付返利',
			width: 120,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'epCustomerName',
			title: '所属二批',
			width: 150,
			align:'center'
		};
		cols.push(col);
		$('#datagrid').datagrid({
					url:'manager/stkRebateOut/queryRebateOutStatPage',
					fitColumns:false,
					rownumbers:true,
					pagination:true,
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						epCustomerName:$("#epCustomerName").val(),
						khNm:$("#khNm").val(),
						beginAmt:$("#beginAmt").val(),
						endAmt:$("#endAmt").val(),
						customerType:$("#customerType").val(),
						saleType:$("#saleType").val()
					},
					columns:[
						cols
					]
				}
		);
	}

	function querydata(){
		$("#datagrid").datagrid('load',{
			url:"manager/stkRebateOut/queryRebateOutStatPage",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
			khNm:$("#khNm").val(),
			beginAmt:$("#beginAmt").val(),
			endAmt:$("#endAmt").val(),
			epCustomerName:$("#epCustomerName").val(),
			customerType:$("#customerType").val(),
			saleType:$("#saleType").val()
		});
	}

	function amtformatter(v,row)
	{
		if(v == null)return "";
		if(v=="0E-7"){
			return "0.00";
		}
		if (row != null) {
			return numeral(v).format("0,0.00");
		}
	}

	function onDblClickRow(rowIndex, rowData)
	{
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		parent.closeWin('待付款返利单据');
		parent.add('待付款返利单据','manager/stkRebateOut/toRebateOutPayList?sdate=' + sdate + '&edate=' + edate + '&khNm=' + rowData.khNm+'&epCustomerName='+rowData.epCustomerName );

	}
	function showPayList()
	{
		parent.closeWin('付款记录');
		parent.add('付款记录','manager/queryPayPageByBillId?dataTp=1&inType=2');
	}
	function toUnitRecPage()
	{
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		var epCustomerName = $("#epCustomerName").val();
		var khNm = $("#khNm").val();
		parent.closeWin('待付款返利单据');
		parent.add('待付款返利单据','manager/stkRebateOut/toRebateOutPayList?sdate=' + sdate + '&edate='+ edate +'&khNm='+khNm+'&epCustomerName='+epCustomerName+'' );
	}

	function loadCustomerType(){
		$.ajax({
			url:"manager/queryarealist1",
			type:"post",
			success:function(data){
				if(data){
					var list = data.list1;
					var img="";
					img +='<option value="">--请选择--</option>';
					for(var i=0;i<list.length;i++){
						if(list[i].qdtpNm!=''){
							img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						}
					}
					$("#customerType").html(img);
				}
			}
		});
	}
	loadCustomerType();
</script>
</body>
</html>