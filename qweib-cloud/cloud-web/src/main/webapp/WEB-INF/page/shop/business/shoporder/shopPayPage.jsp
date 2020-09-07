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
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body onload="initGrid()">
<table id="datagrid" fit="true" singleSelect="true"
	   title="" iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="true" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]"
	   data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
</table>
<div id="tb" style="padding:5px;height:auto;">
	下单日期: <input class="easyui-textbox" readonly="readonly" name="sdate" id="sdate"  onClick="WdatePicker();"  style="width: 70px;"  />
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16"  height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input class="easyui-textbox" name="edate" readonly="readonly" id="edate"  onClick="WdatePicker();" style="width: 70px;" value="${edate}" />
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
</div>

<script type="text/javascript">
	function initGrid(){
		var cols = new Array();
		// var col = {
		// 	field: 'proId',
		// 	title: 'proId',
		// 	width: 100,
		// 	align:'center',
		// 	hidden:true
		// };
		// cols.push(col);

		var col = {
			field: 'payType',
			title: '付款类型',
			width: 200,
			align:'center',
			formatter:formatterPayType
		};
		cols.push(col);
		var col = {
			field: 'cjje',
			title: '成交金额',
			width: 100,
			align:'center',
		};
		cols.push(col);

		$('#datagrid').datagrid({
					url:'manager/shopBforder/shopPayPage',
					fitColumns:false,
					rownumbers:true,
					pagination:true,
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
					},
					columns:[
						cols
					]
				}
		);
	}

	//付款类型
	function formatterPayType(val,row){
		var payType = row.payType;
		var str = "";
		//0.没有类型；1.线下支付；2.余额支付；3.微信支付；4.支付宝支付
		if(0===payType){
			str = "没有类型";
		}else if(1===payType){
			str = "线下支付";
		}else if(2===payType){
			str = "余额支付";
		}else if(3===payType){
			str = "微信支付";
		}else if(4===payType){
			str = "支付宝支付";
		}
		return str;
	}

	//查询数据
	function querydata(){
		$("#datagrid").datagrid('load',{
			url:"manager/shopBforder/shopPayPage",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
		});
	}

	function onDblClickRow(index, row){
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		var payType = row.payType;
		var url = "manager/shopBforder/toPage?sdate="+sdate+"&edate="+edate+"&payType="+payType;
		parent.closeWin('会员订单');
		parent.add('会员订单',url);

	}
</script>


</body>
</html>
