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
		<div class="layui-col-md3">
			<div class="col-xs-4">
				<input type="hidden" uglcw-model="typeId" value=${typeId} id="typeId" uglcw-role="textbox">
				<input type="hidden" uglcw-model="itemId" value=${itemId} id="itemId" uglcw-role="textbox">
			</div>
			<div class="layui-card">
				<div class="layui-card-header" style="color:#000079;padding-top: 2px;font-weight:bold;">
					科目列表
				</div>
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="{
                    id:'id',
                    url: 'manager/queryIncomeTypeListTemplate'
                    }">
						<div data-field="typeName">科目名称</div>

					</div>
				</div>
			</div>
		</div>
		<div class="layui-col-md9">
			<div class="layui-card">
				<div class="layui-card-header" style="color:#000079;padding-top: 2px;font-weight:bold;">
					明细科目
				</div>

				<div class="layui-card-body full">
					<form style="display: none" class="query">
						<input type="hidden" uglcw-role="textbox" uglcw-model="typeId">
					</form>

					<div id="itemgrid" uglcw-role="grid"
						 uglcw-options="{
                    id:'id',
                    url: 'manager/queryIncomeItemListTemplate',
                    criteria: '.query',
                    }">


						<div data-field="itemName" uglcw-options="width:400">明细科目名称</div>
						<div data-field="remarks" uglcw-options="width:400">备注</div>

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

		uglcw.ui.get('#grid').on('change', function (e) {
			var row = this.dataItem(this.select());//获取所有的数据
			console.log(row);//输出信息
			uglcw.ui.bind('.query', {typeId: row.id});//绑定id
			uglcw.ui.get('#itemgrid').reload(); //加载数据
		})


		uglcw.ui.loaded()

		var delay1, delay2
		resize('#grid', delay1);
		resize('#itemgrid', delay2);

		$(window).resize(function () {
			resize('#grid', delay1);
			resize('#itemgrid', delay2);
		})

	})

	var delay;

	function resize(el, delay) {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get(el).k();
			var padding = 85;
			var height = $(window).height() - padding;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

</script>
</body>
</html>