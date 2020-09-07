<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>车销库存统计</title>
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
			<div class="layui-card header">
				<div class="layui-card-body">
					<ul class="uglcw-query form-horizontal">
						<li>
							<input type="hidden" id="isType" uglcw-model="isType" uglcw-role="textbox">
							<input type="hidden" uglcw-model="waretype" id="wareType" uglcw-role="textbox">
							<input type="hidden" uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
						</li>
						<li>
							<tag:select2  name="stkId" id="stkId"
										tableName="stk_storage"
										headerKey=""
										headerValue="--请选择--"
										whereBlock="sale_Car=1 and (status=1 or status is null)"
										displayKey="id"
										displayValue="stk_name">
							</tag:select2>
						</li>
						<li>
							<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
							<button id="reset" class="k-button" uglcw-role="button">重置</button>
						</li>
					</ul>
				</div>
			</div>
			<div class="layui-card">
					<div class="layui-card-body full">
						<div id="grid" uglcw-role="grid"
							 uglcw-options="{
								responsive:['.header',40],
								id:'id',
							    toolbar: uglcw.util.template($('#toolbar').html()),
								url: '${base}manager/queryStorageCarGroupList',
							    dblclick: function(row){
									showItems(row);
								},
								criteria: '.form-horizontal',
								}">
							<div data-field="stkName" uglcw-options="width:150, tooltip:true">仓库名称
							</div>
							<div data-field="sumQty"
								 uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right'">车载数量
							</div>
							<div data-field="minSumQty"
								 uglcw-options="width:140, format: '{0:n2}',titleAlign:'center',align:'right'">车载数量(小)
							</div>
							<div data-field="op" uglcw-options="width:140, template: uglcw.util.template($('#opt-tpl').html())">操作</div>
							<div data-field="">&nbsp;</div>
						</div>
					</div>
				</div>
			</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>

<script type="text/x-uglcw-template" id="toolbar">
		<a role="button" class="k-button k-button-icontext"
		   href="javascript:showBackHis();">
			<span class="k-icon k-i-preview"></span>回库历史
		</a>
</script>

<script id="opt-tpl" type="text-x-uglcw-template">
	<button class="k-button k-success" onclick="stockBack(#=data.stkId#,'#=data.stkName#')"><i class="k-icon"></i>回库
	</button>

</script>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
			uglcw.ui.get('#gird').reload();
		})
		uglcw.ui.loaded()
	})

	function showBackHis() {
		uglcw.ui.openTab("回库历史", '${base}/manager/stkMove/topage?billType=2');
	}

	function showItems(data) {
		uglcw.ui.openTab(data.stkName+'_明细', '${base}manager/toStockCarWareType?stkId=' + data.stkId);
	}

	function stockBack(stkId,stkName){
		uglcw.ui.openTab('车销回库', '${base}manager/stkMove/add?billType=2&stkId='+stkId+'&stkName='+stkName);
	}
</script>
</body>
</html>
