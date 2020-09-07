<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户等级商品类别提成系数设置</title>
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
				<div class="layui-card-header">
					<c:if test="${type eq 1}">
						业务提成按数量系数
					</c:if>
					<c:if test="${type eq 2}">
						业务提成按收入系数
					</c:if>
					<c:if test="${type eq 3}">
						业务提成按毛利系数
					</c:if>
				</div>
				</div>
				<div class="layui-card-body" uglcw-role="resizable" uglcw-options="responsive:[75]">
					<div uglcw-role="tree" id="tree"
						 uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							template:uglcw.util.template($('#type_rate_template').html()),
							expandable:function(node){return node.id == '0'},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#grid').reload();
                       		},
                       		dataBound: function(){
                       			uglcw.ui.init('#tree');
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
	#=item.text#
	#if(item.id!=0){#
	&nbsp;<input id="type_${relaId}_#= item.id#" uglcw-role="numeric" style="width:80px;" uglcw-options="min:0, max: 100"  onchange="changeRate(this,'#= item.id#')"    /><c:if test="${type eq 2}"></c:if>
    <c:if test="${type eq 3}"></c:if>
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

	function changeRate(o,itemId) {
		var field ='saleQtyTcRate';
		if('${type}'==2){
			field ='saleProTcRate';
		}else if('${type}'==3){
			field ='saleGroTcRate';
		}
		$.ajax({
			url: "manager/updateCustomerTypeWareTypeTcRate",
			type: "post",
			data: "relaId=${relaId}&typeId=" + itemId + "&field="+field+"&rate=" + o.value,
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
		var path = "${base}/manager/qdTypeTcRateList";
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
							if('${type}'==1){
								if(item.saleQtyTcRate!=''&&item.saleQtyTcRate!=0&&item.saleQtyTcRate!=undefined){
									uglcw.ui.get("#type_"+item.relaId+"_"+item.waretypeId).value(item.saleQtyTcRate);
								}
							}else if('${type}'==2){
								if(item.saleProTcRate!=''&&item.saleProTcRate!=0&&item.saleProTcRate!=undefined){
									uglcw.ui.get("#type_" + item.relaId + "_" + item.waretypeId).value(item.saleProTcRate);
								}
							}else if('${type}'==3){
								if(item.saleGroTcRate!=''&&item.saleGroTcRate!=0&&item.saleGroTcRate!=undefined){
									uglcw.ui.get("#type_" + item.relaId + "_" + item.waretypeId).value(item.saleGroTcRate);
								}
							}

						})
					}
				}
			}
		});
	}

</script>
</body>
</html>
