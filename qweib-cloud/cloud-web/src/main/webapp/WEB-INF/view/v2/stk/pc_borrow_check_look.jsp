<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
	<title>借出出库发货单</title>
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
						<li onclick="toPrint(${stkSend.id})" class="print" data-icon="check">打印</li>
					</ul>
					<div class="bill-info">
						<span class="no" style="color: green;">
							借出出库单-${stkSend.voucherNo}-<c:if test="${stkSend.status eq 2 }"><span style="color: red">作废单</span></c:if><c:if test="${stkSend.status ne 2 }"><span style="color: green">正常单</span></c:if>
						</span>
						<span class="status" style="color: red;"></span>
					</div>
				</div>
				<div class="layui-card-body">
					<form class="form-horizontal" uglcw-role="validator">
						<div class="form-group">
							<label class="control-label col-xs-3">单据单号</label>
							<div class="col-xs-4">
								<input uglcw-role="gridselector" value="${stkSend.billNo}"
									   uglcw-options="click: function(){
											uglcw.ui.openTab('借出出库单据信息','${base}manager/showstkout?dataTp=1&billId=${stkSend.outId}');
									   }">
							</div>
							<label class="control-label col-xs-3">发货时间</label>
							<div class="col-xs-4">
								<input uglcw-role="datetimepicker" uglcw-options="format: 'yyyy-MM-dd HH:mm'" readonly uglcw-validate="required" value="${stkSend.sendTime}">
							</div>
							<label class="control-label col-xs-5 col-xs-3">发货仓库</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${stkSend.stkName}">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-xs-3">借款对象</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${stkSend.khNm}">
							</div>

							<label class="control-label col-xs-5 col-xs-3">车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${stkSend.vehNo}">
							</div>
							<label class="control-label col-xs-5 col-xs-3">司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机</label>
							<div class="col-xs-4">
								<input uglcw-role="textbox" readonly uglcw-validate="required" value="${stkSend.driverName}">
							</div>
						</div>
						<div class="form-group" style="margin-bottom: 0px;">
							<label class="control-label col-xs-3">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
							<div class="col-xs-11">
								<textarea  uglcw-role="textbox" readonly>${stkSend.remarks}</textarea>
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
                            {field: "outQty", aggregate: "sum"}
                          ],
                          dataSource:${fns:toJson(subList)}
                        '
					>
						<div data-field="wareCode" uglcw-options="width: 150, footerTemplate: '合计'">产品编号</div>
						<div data-field="wareNm" uglcw-options="width: 150">产品名称</div>
						<div data-field="wareGg" uglcw-options="width: 150">产品规格</div>
						<div data-field="unitName" uglcw-options="width: 120">单位</div>
						<c:if test="${permission:checkUserFieldPdm('stk.stkSend.lookprice')}">
							<div data-field="price" uglcw-options="width: 150">单价</div>
						</c:if>
						<div data-field="qty" uglcw-options="width: 150, footerTemplate: '#= sum#'">单据数量</div>
						<div data-field="outQty" uglcw-options="width: 150, footerTemplate: '#= sum#'">收货数量</div>
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
		uglcw.ui.openTab('借出出库发货单打印', '${base}manager/showstksendprint?dataTp=1&billId=' + id);
	}


</script>
</body>
</html>
