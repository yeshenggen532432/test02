<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>会员余额列表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
	url="manager/shopMember/page?opeCount=1" border="false"
	rownumbers="true" fitColumns="false" pagination="true" data-options="onDblClickRow: onDblClickRow"
	pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
	<thead>
		<tr>
			<th field="id" checkbox="true"></th>
			<th field="name" width="80" align="center" >
				会员名称
			</th>
			<th field="mobile" width="100" align="center">
				电话
			</th>
			<th field="inputCash" width="100" align="center">
				充值金额
			</th>
			<th field="freeCost" width="100" align="center">
				赠送金额
			</th>
			<th field="sumAmount" width="100" align="center" formatter="formatterSumAmount">
				总余额
			</th>
			<th field="sumCost" width="100" align="center">
				总消费
			</th>
			<th field="sumInput" width="100" align="center">
				总充值
			</th>
		</tr>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	 会员名称: <input name="name" id="name" style="width:100px;height: 20px;" />
	 手机号: <input name="mobile" id="mobile" style="width:100px;height: 20px;"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
</div>

<%--js--%>
<script type="text/javascript">
	//查询会员
	function query(){
		$("#datagrid").datagrid('load',{
			url:"manager/shopMember/page?opeCount=1",
			   name:$("#name").val(),
			   mobile:$("#mobile").val()
		});
	}

	//总余额
	function formatterSumAmount(val,row){
		var inputCash = row.inputCash;
		var freeCost = row.freeCost;//赠送金额
		var sumAmount = 0;
		if(inputCash!=null && inputCash!=undefined && inputCash!='undefined' && inputCash!=''){
			sumAmount += parseFloat(inputCash);
		}
		if(freeCost!=null && freeCost!=undefined && freeCost!='undefined' && freeCost!=''){
			sumAmount += parseFloat(freeCost);
		}
		return sumAmount;
	}

	function onDblClickRow(index, row){
		var mId = row.memId;
		var name = row.name;
		var url = "manager/shopMemberIo/toShopMemberBalanceDetailPage?mId="+mId;
		parent.closeWin(name+'_会员余额明细');
		parent.add(name+'_会员余额明细',url);
	}



</script>
</body>
</html>
