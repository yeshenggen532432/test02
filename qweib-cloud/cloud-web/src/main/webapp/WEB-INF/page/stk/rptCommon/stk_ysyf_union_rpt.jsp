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
	往来单位: <input class="easyui-textbox" name="proName" id="proName" style="width:120px;" onkeydown="querydata();"/>
	发票日期: <input class="easyui-textbox" name="sdate" id="sdate" readonly="readonly"  onClick="WdatePicker();" value="${sdate}" style="width: 70px;"  />
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input class="easyui-textbox" name="edate" id="edate"  readonly="readonly" onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>

</div>
<table id="datagrid" fit="true" singleSelect="true"
	   title="" iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="true" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]"
	   toolbar="#tb" data-options="onDblClickRow: onDblClickRow">

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
			field: 'pro_name',
			title: '往来单位',
			width: 200,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'qc_amt',
			title: '期初余额',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);


		var col = {
			field: '_bq_rec_amt',
			title: '本期应收',
			width: 100,
			align:'center',
			formatter:amtformatterBqYsAmt
		};
		cols.push(col);

		var col = {
			field: 'sale_rec_amt',
			title: '销售应收',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: 'init_rec_amt',
			title: '初始化应收',
			width: 100,
			align:'center',
			formatter:amtformatter

		};
		cols.push(col);

		var col = {
			field: '_bq_pay_amt',
			title: '本期应付',
			width: 100,
			align:'center',
			formatter:amtformatterBqYfAmt
		};
		cols.push(col);

		var col = {
			field: 'cg_pay_amt',
			title: '采购应付',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: 'init_pay_amt',
			title: '初始化应付',
			width: 120,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'qm_amt',
			title: '期末余额',
			width: 120,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var proType=$('input:radio[name="proType"]:checked').val();
		$('#datagrid').datagrid({
					url:'manager/queryYsYfUnionPage',
					fitColumns:false,
					rownumbers:true,
					pagination:true,
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						proName:$("#proName").val(),
						proType:proType
					},
					columns:[
						cols
					]
			}
		);
	}
	function querydata(){
		var proType=$('input:radio[name="proType"]:checked').val();
		$("#datagrid").datagrid('load',{
			url:"manager/queryYsYfUnionPage",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
			proName:$("#proName").val(),
			proType:proType
		});
	}

	function amtformatterBqYsAmt(v,row){

     var amt = row.sale_rec_amt+row.init_rec_amt;
     return "<a  href='javascript:;;' onclick='showBqYs(\""+row.pro_id+"\",\""+row.pro_name+"\")'>"+numeral(amt).format("0,0.00")+"</a>";
	}

	function amtformatterBqYfAmt(v,row){

		var amt = row.cg_pay_amt+row.init_pay_amt;
		return "<a  href='javascript:;;' onclick='showBqYf(\""+row.pro_id+"\",\""+row.pro_name+"\")'>"+numeral(amt).format("0,0.00")+"</a>";
	}

	/**
	 * 查看应收单据
	 * @param proId
	 * @param proName
	 */
	function showBqYs(proId,proName) {
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		parent.closeWin('待收款单据');
		parent.add('待收款单据','manager/toUnitRecPage?sdate=' + sdate + '&edate=' + edate + '&unitName=' + proName);
	}

	/**
	 * 查看应付单据
	 * @param proId
	 * @param proName
	 */
	function showBqYf(proId,proName) {

		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		parent.closeWin('待付款单据');
		parent.add('待付款单据','manager/toUnitPayPage?dataTp=1&sdate='+ sdate + '&edate=' + edate + '&proName=' + proName);

	}


	function amtformatterSumAmt(v,row)
	{
		var dis_amt = row.dis_amt;
		var occ_amt = row.occ_amt;
		var free_amt = row.free_amt;
		var amt = dis_amt-occ_amt-free_amt;
		return numeral(amt).format("0,0.00");
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
		parent.closeWin('应收应付账款明细');
		parent.add('应收应付账款明细','manager/toQueryYsYfUnionItemsPage?sdate='+ sdate + '&edate=' + edate + '&proName=' + rowData.pro_name);

	}

</script>
</body>
</html>
