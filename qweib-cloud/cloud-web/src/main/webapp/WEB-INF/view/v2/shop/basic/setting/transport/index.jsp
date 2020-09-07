<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>运费配置主页</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}

		.layui-card-body {
			position: relative;
			padding: 10px;
			line-height: 24px;
		}

		.k-panelbar .k-tabstrip>.k-content, .k-tabstrip>.k-content {
			position: static;
			border-style: solid;
			border-width: 1px;
			margin: 0;
			padding: 0;
			zoom: 1;
		}

	</style>
</head>
<body>
<tag:mask></tag:mask>
<%--<div class="layui-fluid">--%>
<%--<div class="layui-row layui-col-space15">--%>
<%--</div>--%>
<%--</div>--%>

<div class="layui-col-md12">
	<div class="layui-card">
		<div class="layui-card-body">
			<div uglcw-role="tabs">
				<ul >
					<li>同城模版</li>
					<li>城际模版</li>
					<%--<li>配送方式</li>--%>
				</ul>
				<div>
					<iframe src="${base}/manager/shopSetting/toPage?name=location_transport" id="iframe1" name="iframe1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
				</div>
				<div>
					<iframe src="${base}/manager/shopTransport/toList" id="iframe2" name="iframe2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
				</div>
				<%--<div>
					<iframe src="${base}/manager/shopSetting/toPage?name=distribution_mode" id="iframe3" name="iframe1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
				</div>--%>
			</div>
		</div>
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
			var height =$(window).height();
			var iframeHeight = height-90;
			$('#iframe1').height(iframeHeight+"px");
			$('#iframe2').height(iframeHeight+"px");
			$('#iframe3').height(iframeHeight+"px");
			// var padding = 15;
			// var height = $(window).height() - padding - $('.header').height() - 40;
			// grid.setOptions({
			// 	height: height,
			// 	autoBind: true
			// })
		}, 200)
	}

	//-----------------------------------------------------------------------------------------


</script>
</body>
</html>
