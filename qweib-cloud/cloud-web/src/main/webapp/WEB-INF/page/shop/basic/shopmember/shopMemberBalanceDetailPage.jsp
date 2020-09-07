<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>会员余额明细</title>
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
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false" border="false"
	<%--url="manager/shopMemberIo/queryShopMemberIoPage?cardId=${cardId}" --%>
	rownumbers="true" fitColumns="false" pagination="true"
	pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
	<thead>
		<%--<tr>--%>
			<%--<th field="id" checkbox="true"></th>--%>
			<%--<th field="ioFlag" width="100" align="center"  formatter="formatterIoFlag">--%>
				<%--类型--%>
			<%--</th>--%>
			<%--<th field="ioTimeStr" width="120" align="center">--%>
				<%--时间--%>
			<%--</th>--%>
			<%--<th field="leftAmt" width="100" align="center">--%>
				<%--余额--%>
			<%--</th>--%>
			<%--<th field="cardPay" width="100" align="center" formatter="amtformatter">--%>
				<%--卡支付--%>
			<%--</th>--%>
			<%--<th field="cashPay" width="100" align="center" formatter="amtformatter">--%>
				<%--现金支付--%>
			<%--</th>--%>
			<%--<th field="wxPay" width="100" align="center" formatter="amtformatter">--%>
				<%--银行卡支付--%>
			<%--</th>--%>
			<%--<th field="cashPay" width="100" align="center" formatter="amtformatter">--%>
				<%--微信支付--%>
			<%--</th>--%>
			<%--<th field="zfbPay" width="100" align="center" formatter="amtformatter">--%>
				<%--支付宝支付--%>
			<%--</th>--%>
			<%--<th field="inputCash" width="100" align="center" formatter="formatterInputCash">--%>
				<%--充值金额--%>
			<%--</th>--%>
			<%--<th field="freeCost" width="100" align="center" formatter="formatterFreeCost">--%>
				<%--赠送金额--%>
			<%--</th>--%>
			<%--&lt;%&ndash;<th field="docNo" width="100" align="center">&ndash;%&gt;--%>
				<%--&lt;%&ndash;订单号&ndash;%&gt;--%>
			<%--&lt;%&ndash;</th>&ndash;%&gt;--%>
		<%--</tr>--%>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	-
	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>

	类型: <select name="ioFlags" id="ioFlags">
				<option value="1,2,5">全部</option>
				<option value="1">充值</option>
				<option value="2">消费</option>
				<option value="5">退卡</option>
			</select>
	 <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>

<%--js--%>
<script type="text/javascript">
	initGrid();
	function initGrid(){
		var cols = new Array();
		var col = {
			field: 'id',
			title: 'id',
			width: 50,
			align:'center',
			hidden:'true'
		};
		cols.push(col);
		var col = {
			field: 'ioFlag',
			title: '类型',
			width: 135,
			align:'center',
			formatter:formatterIoFlag
		};
		cols.push(col);
		var col = {
			field: 'ioTimeStr',
			title: '充值时间',
			width: 135,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'inputCash',
			title: '<b>充值金额</b>',
			width: 80,
			align:'center',
			formatter:formatterInputCash
		};
		cols.push(col);
		var col = {
			field: 'freeCost',
			title: '赠送金额',
			width: 80,
			align:'center',
			formatter:formatterFreeCost
		};
		cols.push(col);
		var col = {
			field: 'cashPay',
			title: '现金充值',
			width: 80,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'bankPay',
			title: '银行卡充值',
			width: 80,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'wxPay',
			title: '微信充值',
			width: 80,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'zfbPay',
			title: '支付宝充值',
			width: 100,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'cardPay',
			title: '<b>消费</b>',
			width: 80,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);
		var col = {
			field: 'leftAmt',
			title: '<b>余额</b>',
			width: 100,
			align:'center'

		};
		cols.push(col);

		$('#datagrid').datagrid({
			url:"manager/shopMemberIo/queryShopMemberIoPage?cardId=${cardId}",
			queryParams:{
				sdate:$("#sdate").val(),
				edate:$("#edate").val(),
				ioFlags:$("#ioFlags").val(),
			},
			columns:[
				cols
			]}
		);
	}




	//查询会员
	function query(){
		$("#datagrid").datagrid('load',{
			url:"manager/shopMemberIo/queryShopMemberIoPage?cardId=${cardId}",
			sdate:$("#sdate").val(),
			edate:$("#edate").val(),
			ioFlags:$("#ioFlags").val(),
		});
	}

	//总余额
	function formatterIoFlag(val,row){
		var str = '';
		if(val == '1'){
			str = '充值'
		}else if(val == '2'){
			str = '消费'
		}else if(val == '5'){
			str = '退卡'
		}
		return str;
	}
	function amtformatter(val,row){
		if(val == '0'){
			val = ''
		}
		return val;
	}
	function formatterInputCash(val,row){
		//消费不显示
		var ioFlag = row.ioFlag;
		if(ioFlag == '2'){
			val = ''
		}
		return val;
	}

	function formatterFreeCost(val,row){
		//消费不显示
		var ioFlag = row.ioFlag;
		if(ioFlag == '2'){
			val = ''
		}
		return val;
	}



</script>
</body>
</html>
