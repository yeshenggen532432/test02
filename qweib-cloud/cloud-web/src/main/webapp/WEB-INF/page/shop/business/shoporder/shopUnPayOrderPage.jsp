<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>待支付订单</title>

	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script type="text/javascript" src="${base}/resource/shop/pc/js/bforder.js"></script>
</head>
<body>
	<table id="datagrid"  fit="true" singleSelect="true" iconCls="icon-save" border="false"
		rownumbers="true" fitColumns="false" pagination="true"
		nowrap="false",
		pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
	</table>
	<div id="tb" style="padding:5px;height:auto">
		<input id="payType" type="hidden" value="${order.payType}"/>
		订单号: <input name="orderNo" id="orderNo" style="width:120px;height: 20px;" value="${order.orderNo}" onkeydown="toQuery(event);"/>
		客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		会员名称: <input name="shopMemberName" id="shopMemberName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		下单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
					-
				 <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
					<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		订单状态: <select name="orderZt" id="orderZt">
					<option value="">全部</option>
					<c:forEach items="${orderZtMap}" var="ztMap" varStatus="status">
						<option value="${ztMap.key}" <c:if test="${orderZtIndex==status.index}">selected</c:if>>${ztMap.value}</option>
					</c:forEach>
				</select>
		仓库：<tag:select name="stkId" id="stkId" tableName="stk_storage" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="stk_name"/>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toZf();">作废</a>
		<%--<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a--%>
		<%--<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toShow();">修改</a>--%>
	</div>
	<script type="text/javascript">
		//查询订单
		function queryorder(){
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
				field: 'orderNo',
				title: '订单号',
				width: 135,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'orderZt',
				title: '订单状态',
				width: 75,
				align:'center',
				formatter:formatOrderZt
			};
			cols.push(col);
			var col = {
				field: 'payType',
				title: '付款类型',
				width: 70,
				align:'center',
				formatter:formatterPayType
			};
			cols.push(col);
			var col = {
				field: 'pszd',
				title: '配送指定',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'oddate',
				title: '下单日期',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'odtime',
				title: '时间',
				width: 80,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'shTime',
				title: '送货时间',
				width: 120,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'khNm',
				title: '客户名称',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'shopMemberName',
				title: '会员名称',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'count',
				title: '商品信息',
				width: 520,
				align:'center',
				formatter:formatterSt
			};
			cols.push(col);
			var col = {
				field: 'zje',
				title: '总金额',
				width: 60,
				align:'center',
			};
			cols.push(col);
			var col = {
				field: 'zdzk',
				title: '整单折扣',
				width: 60,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'cjje',
				title: '成交金额',
				width: 60,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'remo',
				title: '备注',
				width: 200,
				align:'center',
				nowrap:false
			};
			cols.push(col);
			var col = {
				field: 'shr',
				title: '收货人',
				width: 80,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'tel',
				title: '电话',
				width: 100,
				align:'center'
			};
			cols.push(col);
			var col = {
				field: 'address',
				title: '电话',
				width: 275,
				align:'center'
			};
			cols.push(col);
			$('#datagrid').datagrid({
				url:"manager/shopBforder/unPayOrderPage",
				nowrap:false,
				cache:false,
				border: false,
				rownumbers: true,
				striped : true,
				fixed:true,
				queryParams:{
					payType:$("#payType").val(),
					orderNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					shopMemberName:$("#shopMemberName").val(),
					orderZt:$("#orderZt").val(),
					pszd:$("#pszd").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					stkId:$("#stkId").val()
				},
				columns:[cols]
			});
			//$('#datagrid').datagrid('reload');
		}

		if('${order.orderNo}'!=""){
			queryorder();
		}

		//付款类型
		function formatterPayType(val,row){
			<c:forEach items="${orderPayTypeMap}" var="payTypeMap">
			if(val==${payTypeMap.key}){
				if(val==0){
					return "<a href='javascript:updatePayType("+row.id+")' title='修改为线下支付类型'>${payTypeMap.value}</span>";
				}
				return "${payTypeMap.value}";
			}
			</c:forEach>
		}
	</script>

</body>
</html>
