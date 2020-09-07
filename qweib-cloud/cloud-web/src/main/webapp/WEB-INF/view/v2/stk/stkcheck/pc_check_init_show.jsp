<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>初始化库存</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.k-grid-toolbar .info{
			display: inline-flex;
			margin-top: 5px;
		}
		.k-grid-toolbar .info .item{
			color: #000;
			margin-left: 10px;
			line-height: 24px;
		}

		.k-grid-toolbar .info .item label:after{
			content: ':';
		}
	</style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-body full">
			<div class="query">
				<input type="hidden" uglcw-role="textbox" uglcw-model="billId" value="${billId}"/>
				<input type="hidden" uglcw-role="textbox" uglcw-model="stkId" value="${stkId}"/>
			</div>
			<div id="grid" uglcw-role="grid"
				 uglcw-options="
                    loadFilter:{
                        data: function(response){
                            return response.list || [];
                        }
                    },
                    toolbar: kendo.template($('#toolbar').html()),
                    url: '${base}manager/queryCheckSub',
                    criteria: '.query',
                    ">
				<div data-field="wareCode" uglcw-options="width:120,tooltip: true, editable: false">商品编码</div>
				<div data-field="wareNm" uglcw-options="width:120, tooltip: true, editable: false">商品名称</div>
				<div data-field="wareGg" uglcw-options="width:90, editable: false">规格</div>
				<div data-field="unitName" uglcw-options="width:100, editable: false">大单位</div>
				<div data-field="qty" uglcw-options="width:120, format: '{0:n2}', schema:{type: 'number'}">大单位数量
				</div>
				<div data-field="price" uglcw-options="width:120, format: '{0:n2}', schema:{type: 'number'}">大单位价格
				</div>
				<div data-field="minUnit" uglcw-options="width:100, editable: false">小单位</div>
				<div data-field="minQty" uglcw-options="width:120, format: '{0:n2}', schema:{type: 'number'}">
					小单位数量
				</div>
				<div data-field="sunitPrice" uglcw-options="width:120, format: '{0:n2}', schema:{type: 'number'}">小单位价格
				</div>
				<div data-field="hsNum" uglcw-options="width:90, format:'{0:n2}', editable: false">换算数量</div>
				<div data-field="disQty" uglcw-options="width:90, format:'{0:n2}', editable: false">初始数量</div>
				<div data-field="produceDate" uglcw-options="width: 150">生产日期
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/x-uglcw-template" id="toolbar">
	<div class="info">
		<div class="item">
			<label>初始化时间</label>
			<span>${checkTime}</span>
		</div>
		<div class="item">
			<label>初始化仓库</label>
			<span>${stkName}</span>
		</div>
		<div class="item">
			<label>盘点人</label>
			<span>${staff}</span>
		</div>
		<div class="item">
			<label>单据状态</label>
			<span><c:if test="${status eq -2}">
				暂存
			</c:if>
		<c:if test="${status eq 0}">
			已审批
		</c:if>
		<c:if test="${status eq -2}">
			已作废
		</c:if></span>
		</div>
	</div>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded();
	});
</script>
</body>
</html>
