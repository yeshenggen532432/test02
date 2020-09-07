<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户价格档案-选择商品-客户列表信息</title>
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

			<%--表格：start--%>
			<div class="layui-card">
				<div class="form-horizontal">
					<input type="hidden" uglcw-model="wareId" id="wareId" uglcw-role="textbox" value="${sysWare.wareId}">
					<input type="hidden" uglcw-model="wareDj" id="wareDj" uglcw-role="textbox" value="${sysWare.wareDj}">
					<input type="hidden" uglcw-model="lsPrice" id="lsPrice" uglcw-role="textbox" value="${sysWare.lsPrice}">
					<input type="hidden" uglcw-model="fxPrice" id="fxPrice" uglcw-role="textbox" value="${sysWare.fxPrice}">
					<input type="hidden" uglcw-model="cxPrice" id="cxPrice" uglcw-role="textbox" value="${sysWare.cxPrice}">
					<input type="hidden" uglcw-model="sunitPrice" id="sunitPrice" uglcw-role="textbox" value="${sysWare.sunitPrice}">
					<input type="hidden" uglcw-model="minLsPrice" id="minLsPrice" uglcw-role="textbox" value="${sysWare.minLsPrice}">
					<input type="hidden" uglcw-model="minFxPrice" id="minFxPrice" uglcw-role="textbox" value="${sysWare.minFxPrice}">
					<input type="hidden" uglcw-model="minCxPrice" id="minCxPrice" uglcw-role="textbox" value="${sysWare.minCxPrice}">
				</div>
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
							id:'id',
							<%--checkbox:true,--%>
							pageable: true,
                    		url: '${base}manager/customerGroupWarePriceList',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="khCode" uglcw-options="width:100">客户编码</div>
						<div data-field="khNm" uglcw-options="width:150,tooltip:true">客户名称</div>
						<div data-field="linkman" uglcw-options="width:100">负责人</div>
						<div data-field="tel" uglcw-options="width:150">负责人电话</div>
						<div data-field="mobile" uglcw-options="width:150">负责人手机</div>
						<div data-field="address" uglcw-options="width:300,tooltip:true">地址</div>
					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {

		//ui:初始化
		uglcw.ui.init();

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
			//设置tree高度
			var treeHeight = $(window).height()-$("div.layui-card-header").height()-60;
			$("#tree").height(treeHeight + "px");
		}, 200)
	}

	//---------------------------------------------------------------------------------------------------------------





</script>
</body>
</html>
