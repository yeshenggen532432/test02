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
	往来类型:
	<input id="proTypeAll" type="radio" name="proType" onchange="querydata();" checked="checked" value="-1"/>全部
	<input id="proType0" type="radio" name="proType" onchange="querydata();" value="0"/>供应商
	<input id="proType2" type="radio" name="proType" onchange="querydata();" value="2"/>客户
	<input id="proType1" type="radio" name="proType" onchange="querydata();" value="1"/>员工
	<input id="proType3" type="radio" name="proType" onchange="querydata();" value="3"/>其它往来
	<input id="proType4" type="radio" name="proType" onchange="querydata();" value="4"/>会员
	往来单位: <input class="easyui-textbox" name="proName" id="proName" value="${proName}" style="width:120px;" onkeydown="querydata();"/>
	发票单号: <input class="easyui-textbox" name="billNo" id="billNo" style="width:120px;" onkeydown="querydata();"/>
	发票日期: <input class="easyui-textbox" name="sdate" id="sdate"  onClick="WdatePicker();"  value="${sdate}"  style="width: 70px;"  />
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"   height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input class="easyui-textbox" name="edate" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>

</div>
<table id="datagrid" fit="true" singleSelect="true"
	   title="" iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="true" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]"
	   toolbar="#tb">

</table>
<script type="text/javascript">
	function initGrid()
	{
		var cols = new Array();
		var col = {
			field: 'pro_id',
			title: 'pro_id',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);
		var col = {
			field: 'bill_no',
			title: '发票单号',
			width: 140,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'pro_name',
			title: '往来单位',
			width: 200,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'dis_amt',
			title: '发票金额',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: 'dis_amt1',
			title: '发货金额',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: 'occ_amt',
			title: '已收金额',
			width: 100,
			align:'center',
			formatter:amtformatter

		};
		cols.push(col);
		var col = {
			field: 'free_amt',
			title: '核销金额',
			width: 60,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: 'sum_amt',
			title: '欠款金额',
			width: 120,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var proType=$('input:radio[name="proType"]:checked').val();
		$('#datagrid').datagrid({
					url:'manager/queryYsYfUnionItemsPage',
					fitColumns:false,
					rownumbers:true,
					pagination:true,
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						proName:$("#proName").val(),
						proType:proType,
						billNo:$("#billNo").val()
					},
					columns:[
						cols
					],
					rowStyler:function(index,row){
						if (row.dis_amt<0||row.io_mark==-1){
							return 'color:red;';
						}
					}
				}
		);
	}
	function querydata(){
		var proType=$('input:radio[name="proType"]:checked').val();
		$("#datagrid").datagrid('load',{
			url:"manager/queryYsYfUnionItemsPage",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
			proName:$("#proName").val(),
			proType:proType,
			billNo:$("#billNo").val()
		});
	}

	function amtformatter(v,row)
	{
		if(v == null)return "";
		if(v=="0E-7"){
			return "0.00";
		}
		if (row != null) {
			if(v==""){
				v=0;
			}
			var amt = v;
			if(row.io_mark!=undefined){
			 amt =	parseFloat(v)*parseFloat(row.io_mark)
			}
			return numeral(amt).format("0,0.00");
		}
	}
</script>
</body>
</html>
