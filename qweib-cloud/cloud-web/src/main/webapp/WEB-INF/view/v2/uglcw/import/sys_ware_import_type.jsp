<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>商品信息导入-商品明细</title>
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
		<%--1左边：商品分类start--%>
		<div class="layui-col-md2">
			<div class="layui-card">
				<div class="layui-card-header">商品分类</div>
				<div class="layui-card-body">
					<div uglcw-role="tree" id="wareTypeTree"
						 uglcw-options="
						 	expandable: function (node) {
									return node.id == 0 ? true : false;
								},
							url: '${base}manager/syswaretypes',
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#wtype').value(node.id);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
					</div>
				</div>
			</div>
		</div>
		<%--1左边：商品分类end--%>

		<%--2右边：表格start--%>
		<div class="layui-col-md10">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<input type="hidden" uglcw-model="wtype" id="wtype" uglcw-role="textbox">
							<input type="hidden" uglcw-model="mastId" id="mastId" uglcw-role="textbox" value="${mastId}">
							<input type="hidden" uglcw-model="status" uglcw-role="textbox" value="1">
							<div class="col-xs-4">
								<input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
							</div>
							<div class="col-xs-4">
								<input uglcw-model="packBarCode" uglcw-role="textbox" placeholder="大单位条码">
							</div>
							<div class="col-xs-4">
								<input uglcw-model="beBarCode" uglcw-role="textbox" placeholder="小单位条码">
							</div>
							<div class="col-xs-4">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<%--表格：头部end--%>

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
							id:'id',
							pageable: true,
                    		url: '${base}manager/sysWareImportMain/subPage',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="wareCode" uglcw-options="width:80">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:150">商品名称</div>
						<div data-field="py" uglcw-options="width:80">助记码</div>
						<div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
						<div data-field="qualityDays" uglcw-options="width:80">保质期</div>
						<div data-field="wareGg" uglcw-options="width:80">规格</div>
						<div data-field="wareDw" uglcw-options="width:60">大单位</div>
						<div data-field="packBarCode" uglcw-options="width:100">大单位条码</div>
						<div data-field="minUnit" uglcw-options="width:60">小单位</div>
						<div data-field="beBarCode" uglcw-options="width:100">小单位条码</div>
						<div data-field="inPrice" uglcw-options="width:60">采购价</div>
						<div data-field="wareDj" uglcw-options="width:60">批发价</div>
						<div data-field="lsPrice" uglcw-options="width:60">零售价</div>
						<div data-field="tranAmt" uglcw-options="width:80">运输费用</div>
						<div data-field="tcAmt" uglcw-options="width:80">提成费用</div>
						<div data-field="aliasName" uglcw-options="width:100">别名</div>
						<div data-field="asnNo" uglcw-options="width:100">标识码</div>
						<div data-field="fbtime" uglcw-options="width:130">发布时间</div>
						<div data-field="status" uglcw-options="width:80,template: uglcw.util.template($('#status').html())">是否启用</div>
						<div data-field="isCy" uglcw-options="width:80,template: uglcw.util.template($('#isCy').html())">是否常用</div>

					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<%--启用状态--%>
<script id="status" type="text/x-uglcw-template">
	<span>#= data.status == '1' ? '是' : '否' #</span>
</script>
<script id="isCy" type="text/x-uglcw-template">
	<span>#= data.isCy == '1' ? '是' : '否' #</span>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		//ui:初始化
		uglcw.ui.init();

		//查询
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		//重置
		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
			uglcw.ui.get('#grid').reload();
		})

		resize();
		$(window).resize(resize);
		uglcw.ui.loaded();
	})

	var delay;
	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 15;
			var height = $(window).height() - padding - $('.header').height() - 40;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

	//---------------------------------------------------------------------------------------------------------------




</script>
</body>
</html>
