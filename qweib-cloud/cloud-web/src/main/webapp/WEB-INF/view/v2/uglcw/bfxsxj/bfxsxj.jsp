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
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="{
                    id:'id',
                    url: '${base}manager/queryBfxsxjPage?mid=${mid}&cid=${cid}&xjdate=${xjdate}',
                    criteria: '.form-horizontal',
                    pageable: true,

                    }">
						<div data-field="inDate" uglcw-options="
                        width:50, selectable: true, type: 'checkbox', locked: true,
                        headerAttributes: {'class': 'uglcw-grid-checkbox'}
                        "></div>
						<div data-field="wareNm" uglcw-options="width:100">品项</div>
						<div data-field="dhNum" uglcw-options="{width:100}">到货量</div>
						<div data-field="sxNum" uglcw-options="{width:120}">实销量</div>
						<div data-field="kcNum" uglcw-options="{width:100}">库存量</div>
						<div data-field="ddNum" uglcw-options="{width:180}">订单数</div>
						<div data-field="xstp" uglcw-options="{width:160}">售销类型</div>
						<div data-field="xxd" uglcw-options="{width:160,
						template: uglcw.util.template($('#formatterSt').html())}">新鲜度</div>
						<div data-field="remo" uglcw-options="{width:120}">备注</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script id="formatterSt" type="text/x-kendo-template">
	#if(data.xxd>0){#
	 临期 #= data.xxd#
	#}else{#
	 正常
	#}#
</script>
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
			var height = $(window).height() - padding ;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}



</script>
</body>
</html>
