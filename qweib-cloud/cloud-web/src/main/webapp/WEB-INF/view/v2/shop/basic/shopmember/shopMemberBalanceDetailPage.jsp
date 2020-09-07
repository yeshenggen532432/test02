<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>会员余额明细</title>
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
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-4">
								<select uglcw-role="combobox" uglcw-model="ioFlags" placeholder="类型">
									<option value="1,2,5">--类型--</option>
									<option value="1">充值</option>
									<option value="2">消费</option>
									<option value="5">退卡</option>
								</select>
							</div>
							<div class="col-xs-4">
								<input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
							</div>
							<div class="col-xs-4">
								<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
							</div>
							<div class="col-xs-4">
								<input type="hidden" uglcw-model="cardId" value="${cardId}" uglcw-role="textbox">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                    <%--toolbar: kendo.template($('#toolbar').html()),--%>
							id:'id',
							checkbox: true,
							url: 'manager/shopMemberIo/queryShopMemberIoPage',
							criteria: '.form-horizontal',
							pageable: true
                    ">
						<div data-field="ioFlag" uglcw-options="width:100, template: uglcw.util.template($('#ioFlag').html())">类型</div>
						<div data-field="ioTimeStr" uglcw-options="width:150">时间</div>
						<div data-field="leftAmt" uglcw-options="width:100">余额</div>
						<div data-field="inputCash" uglcw-options="width:100, template: uglcw.util.template($('#inputCash').html())">充值金额</div>
						<div data-field="freeCost" uglcw-options="width:100, template: uglcw.util.template($('#freeCost').html())">赠送金额</div>
						<div data-field="cardPay" uglcw-options="width:100, template: uglcw.util.template($('#cardPay').html())">卡支付</div>
						<div data-field="cashPay" uglcw-options="width:100, template: uglcw.util.template($('#cashPay').html())">现金支付</div>
						<div data-field="bankPay" uglcw-options="width:100, template: uglcw.util.template($('#bankPay').html())">银行卡支付</div>
						<div data-field="wxPay" uglcw-options="width:100, template: uglcw.util.template($('#wxPay').html())">微信支付</div>
						<div data-field="zfbPay" uglcw-options="width:100, template: uglcw.util.template($('#zfbPay').html())">支付宝</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%--toolbar--%>
<%--<script type="text/x-kendo-template" id="toolbar">--%>
	<%--<a role="button" href="javascript:toZf();" class="k-button k-button-icontext">--%>
		<%--<span class="k-icon k-i-minus"></span>作废--%>
	<%--</a>--%>
	<%--<a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">--%>
		<%--<span class="k-icon k-i-delete"></span>删除--%>
	<%--</a>--%>
<%--</script>--%>

<%--启用状态--%>
<script id="ioFlag" type="text/x-uglcw-template">
	# if(data.ioFlag=='1'){ #
	充值
	# }else if(data.ioFlag=='2'){ #
	消费
	# }else if(data.ioFlag=='3'){ #
	退卡
	# } #
</script>
<script id="inputCash" type="text/x-uglcw-template">
	# if(data.ioFlag != '2'){ #
	<span>#= data.inputCash #</span>
	# } #
</script>
<script id="freeCost" type="text/x-uglcw-template">
	# if(data.ioFlag != '2'){ #
	<span>#= data.freeCost #</span>
	# } #
</script>
<script id="cardPay" type="text/x-uglcw-template">
	# if(data.cardPay != '0'){ #
	<span>#= data.cardPay #</span>
	# } #
</script>
<script id="cashPay" type="text/x-uglcw-template">
	# if(data.cashPay != '0'){ #
	<span>#= data.cashPay #</span>
	# } #
</script>
<script id="bankPay" type="text/x-uglcw-template">
	# if(data.bankPay != '0'){ #
	<span>#= data.bankPay #</span>
	# } #
</script>
<script id="wxPay" type="text/x-uglcw-template">
	# if(data.wxPay != '0'){ #
	<span>#= data.wxPay #</span>
	# } #
</script>
<script id="zfbPay" type="text/x-uglcw-template">
	# if(data.zfbPay != '0'){ #
	<span>#= data.zfbPay #</span>
	# } #
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();

		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();;
		})

		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
		})

		resize();
		$(window).resize(resize)
		uglcw.ui.loaded()
	})

	var delay;
	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 55;
			var height = $(window).height() - padding - $('.header').height() ;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}



</script>
</body>
</html>
