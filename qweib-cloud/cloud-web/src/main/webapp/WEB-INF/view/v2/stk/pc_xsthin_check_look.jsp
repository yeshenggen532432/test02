<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
	<title>驰用T3</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-xs12">
			<div class="layui-card master">
				<div class="layui-card-header btn-group" style="height: 32px;">
					<ul uglcw-role="buttongroup">
						<li onclick="toPrint(${come.id})" class="print" data-icon="check">打印</li>
					</ul>
					<div class="bill-info">
						<span class="no" style="color: green;">
							销售退货收货单 - ${come.voucherNo}
						</span>
						<span class="status" style="color: red;"></span>
					</div>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<input type="hidden" uglcw-model="id" uglcw-role="textbox" id="billId" value="${billId}"/>
						<input type="hidden" uglcw-model="orderId" uglcw-role="textbox" id="orderId" value="${orderId}"/>
						<input type="hidden" uglcw-model="pszd" uglcw-role="textbox" id="pszd" value="${pszd}"/>
						<input type="hidden" uglcw-model="proType" uglcw-role="textbox" id="proType" value="${proType}"/>
						<input type="hidden" uglcw-model="cstId" uglcw-role="textbox" id="cstId" value="${cstId}"/>
						<input type="hidden" uglcw-model="status" uglcw-role="textbox" id="status" value="${status}"/>
						<input type="hidden" uglcw-model="isSUnitPrice" uglcw-role="textbox" id="isSUnitPrice"
							   value="${isSUnitPrice}">
						<div class="form-group">
							<label class="control-label col-xs-3">退货对象</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${come.proName}">
							</div>
							<label class="control-label col-xs-3">单号</label>
							<div class="col-xs-4">
								<input uglcw-role="gridselector" value="${come.billNo}"
									   uglcw-options="click: function(){
											uglcw.ui.openTab('销售退货发票信息' + billId,'${base}manager/showstkin?dataTp=1&billId=${come.inId}');
									   }">
							</div>
							<label class="control-label col-xs-5 col-xs-3">收货仓库</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${come.stkName}">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-3">收货时间</label>
							<div class="col-xs-4">
								<input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" readonly uglcw-validate="required" value="${come.comeTime}">
							</div>
							<label class="control-label col-xs-5 col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${com.vehNo}">
							</div>
							<label class="control-label col-xs-5 col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${come.driverName}">
							</div>
						</div>
						<div class="form-group" style="margin-bottom: 0px;">
							<label class="control-label col-xs-3">备注</label>
							<div class="col-xs-11">
								<textarea  uglcw-role="textbox" readonly>${come.remarks}</textarea>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options='
                          id: "id",
                          height:400,
                          navigatable: true,
					      rowNumber: true,
                          aggregate: [
                            {field: "qty", aggregate: "sum"},
                            {field: "inQty", aggregate: "sum"}
                          ],
                          dataSource: gridDataSource
                        '
					>
						<div data-field="wareCode" uglcw-options="width: 100, footerTemplate: '合计'">产品编号</div>
						<div data-field="wareNm" uglcw-options="width: 150">产品名称</div>
						<div data-field="wareGg" uglcw-options="width: 100">产品规格</div>
						<div data-field="unitName" uglcw-options="width: 80">单位</div>
						<c:if test="${permission:checkUserFieldPdm('stk.stkCome.lookprice')}">
							<div data-field="price" uglcw-options="width: 100">单价</div>
						</c:if>
						<div data-field="productDate" uglcw-options="width: 120">生产日期</div>
						<div data-field="qty" uglcw-options="width: 100, footerTemplate: '#= sum#'">数量</div>
						<div data-field="inQty" uglcw-options="width: 100, footerTemplate: '#= sum#'">收货数量</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	var gridDataSource = ${fns:toJson(warelist)};
	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded();
	});

	var delay;

	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 45;
			var height = $(window).height() - padding - $('.master').height() ;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

	function toPrint(id)
	{
		uglcw.ui.openTab('收货单打印', '${base}manager/showincomeprint?billId=' + id);
	}
</script>
</body>
</html>
