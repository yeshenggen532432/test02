<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户等级商品类别价格比例设置</title>
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
	<div class="uglcw-layout-container">
		<div class="uglcw-layout-fixed" style="width:200px">
			<div class="layui-card">
				<div class="layui-card-header">设置商品类别价格折扣率(${sysQdtype.rate}%) <span style="color: red">注：红色表示下级类别有设置折扣率</span></div>
				<div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
					<div uglcw-role="tree" id="tree"
						 uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							template:uglcw.util.template($('#type_rate_template').html()),
							expandable:function(node){
							return node.id == '0'
							},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#grid').reload();
                       		},
                       		dataBound: function(){
                       			uglcw.ui.init('#tree');
                       				if(count==0){
										querySubTypeRateList();
										count++;
									}
                       			laodData();
                       		}
                    	">
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script id="type_rate_template" type="text/x-uglcw-template">
	<span  id="type_${relaId}_#= item.id#_span">#=item.text#</span>
	#if(item.id!=0){#
	&nbsp;<input id="type_${relaId}_#= item.id#" class="itemRateClass" uglcw-role="numeric" style="width:80px;" uglcw-options="min:0, max: 1000"  onchange="changeRate(this,'#= item.id#')"    />%
	#}#
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		//ui:初始化
		uglcw.ui.init();
		//设置tree高度
		uglcw.ui.loaded();

	})

	var count=0;

	function changeRate(o,itemId) {
		$.ajax({
			url: "manager/updateCustomerTypeWareTypeRate",
			type: "post",
			data: "relaId=${relaId}&typeId=" + itemId + "&rate=" + o.value,
			success: function (data) {
				if (data == '1') {
					uglcw.ui.info('更新成功!');
				} else {
					uglcw.ui.error("操作失败");
				}
			}
		});
	}
	function laodData()
	{
		var path = "${base}/manager/qdTypeRateList";
		var relaId = '${relaId}';
		if(relaId==""){
			return;
		}
		$.ajax({
			url: path,
			type: "POST",
			data : {"relaId":relaId},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					var list = json.rows;
					if(list){
						$.map(list, function (item) {
							if(item.rate!=''&&item.rate!=0){
								//$("#type_"+item.relaId+"_"+item.waretypeId).val(item.rate);
								uglcw.ui.get("#type_"+item.relaId+"_"+item.waretypeId).value(item.rate);

							}
						})
					}
				}
			}
		});
	}

	function querySubTypeRateList()
	{
		var path = "${base}/manager/querySubTypeRateList";
		var relaId = '${relaId}';
		if(relaId==""){
			return;
		}
		$.ajax({
			url: path,
			type: "POST",
			data : {"relaId":relaId},
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					var list = json.rows;
					if(list){
						$.map(list, function (item) {

							$("#type_"+item.relaId+"_"+item.waretypeId+"_span").css("color","red");
						})
					}
				}
			}
		});
	}



</script>
</body>
</html>
