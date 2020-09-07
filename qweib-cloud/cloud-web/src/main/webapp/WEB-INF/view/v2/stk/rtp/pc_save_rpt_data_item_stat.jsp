<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal" id="export">
						<input type="hidden" uglcw-model="id" value="${id}" uglcw-role="textbox">
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="{
					responsive:[60],
                    id:'id',
                    url: 'manager/querySaveRptDataStatItemPage',
					criteria: '.form-horizontal',
			<%--		 loadFilter: {
						 data: function (response) {
						 response.rows.splice( response.rows.length - 1, 1);
						 return response.rows || []
						 },
						 aggregates: function (response) {
							  var aggregate = {
								  sumQty:0,
								  sumAmt:0
							   };
					if (response.rows && response.rows.length > 0) {
							 aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1]);
					}
					  return aggregate;
					}
					},
					 aggregate:[
							{field: 'outQty', aggregate: 'SUM'},
							{field: 'unitAmt', aggregate: 'SUM'},
							{field: 'sumAmt', aggregate: 'SUM'}
					  ],--%>
                    }">

						<div data-field="driverName" uglcw-options="width:160">配送车辆</div>
						<div data-field="customerName" uglcw-options="width:160">销售客户</div>
						<div data-field="wareNm" uglcw-options="width:140">品项</div>
						<div data-field="billName" uglcw-options="width:140">销售类型</div>
						<div data-field="unitName" uglcw-options="width:140">单位</div>
						<div data-field="outQty" uglcw-options="width:140<%--,footerTemplate: '#= data.outQty#'--%>">发货数量</div>
						<div data-field="unitAmt" uglcw-options="width:140<%--,footerTemplate: '#= data.unitAmt#'--%>">单位配送费用</div>
						<div data-field="sumAmt" uglcw-options="width:120<%--,footerTemplate: '#= data.sumAmt#'--%>">配送费用
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded()
	})

</script>
</body>
</html>
