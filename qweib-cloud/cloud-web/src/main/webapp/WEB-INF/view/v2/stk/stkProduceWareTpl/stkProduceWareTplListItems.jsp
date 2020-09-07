<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>生产材料标准配置表</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                  			  url: '${base}manager/stkProduceWareTpl/listItems?relaWareId=${relaWareId}'
                    ">
						<div data-field="relaWareNm">主产品</div>
						<div data-field="wareNm">关联材料</div>
						<div data-field="wareGg">规格</div>
						<div data-field="qty">配比数量</div>
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
