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
						<input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="{
                    id:'id',
                    url: 'manager/queryAccountListTemplate',
                    criteria: '.form-horizontal',
                    }">

						<div data-field="accTypeName" uglcw-options="width:140">账号类型</div>
						<div data-field="accNo" uglcw-options="width:140">账号</div>
						<div data-field="bankName" uglcw-options="width:120">其它</div>
						<div data-field="remarks" uglcw-options="width:120">备注</div>

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
			var height = $(window).height() - padding - $('.header').height();
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}




</script>
</body>
</html>
