<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户价格档案-对应客户</title>
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
				<div class="layui-card-header">库存商品类</div>
				<div class="layui-card-body">
					<div uglcw-role="tree" id="tree"
						 uglcw-options="
							url: '${base}manager/companyStockWaretypes',
							expandable:function(node){return node.id == '0'},
							loadFilter:function(response){
							$(response).each(function(index,item){
							if(item.text=='根节点'){
							    item.text='库存商品类'
							}
							})
							return response;
							},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#click-flag').value(0);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
					</div>
				</div>
			</div>
		</div>
		<div class="uglcw-layout-content">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<input type="hidden" uglcw-model="wtype" id="wareType" uglcw-role="textbox">
							<input type="hidden" uglcw-model="customerId" id="customerId" uglcw-role="textbox" value="${customerId}">
							<div class="col-xs-4">
								<input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
							</div>
							<div class="col-xs-4">
								<input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
							<div class="col-xs-10" style="padding-top: 5px">
								<span style="background-color:#000000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商品原价
								<span style="background-color:rebeccapurple">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户类型价
								<span style="background-color:#4db3ff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户等级价
								<span style="background-color:green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户商品价
								<span style="background-color:red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>客户调价
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
						 responsive:['.header',40],
							id:'id',
							query: function(params){
							if(uglcw.ui.get('#click-flag').value()==1){
								delete params['wtype']
							}
							return params;
							},
							pageable: true,
                    		url: '${base}manager/customerExecWarePricePage',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="wareCode" uglcw-options="width:100">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:150,tooltip:true">商品名称</div>
						<div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
						<div data-field="wareGg" uglcw-options="width:110,tooltip:true">规格</div>
						<div data-field="wareDw" uglcw-options="width:60">大单位</div>
						<div data-field="minUnit" uglcw-options="width:60">小单位</div>
						<div data-field="wareDj" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.wareDj, data: row, field:'wareDj', wareSource:row.pfPriceType})
								}
								">
						</div>
						<%--<div data-field="lsPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_lsPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.lsPrice, data: row, field:'lsPrice', wareSource:row.lsPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="fxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_fxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.fxPrice, data: row, field:'fxPrice', wareSource:row.fxPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="cxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_cxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.cxPrice, data: row, field:'cxPrice', wareSource:row.cxPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<div data-field="sunitPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.sunitPrice, data: row, field:'sunitPrice', wareSource:row.minPfPriceType})
								}
								">
						</div>
						<%--<div data-field="minLsPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minLsPrice, data: row, field:'minLsPrice', wareSource:row.minLsPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="minFxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minFxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minFxPrice, data: row, field:'minFxPrice', wareSource:row.minFxPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="minCxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minCxPrice, data: row, field:'minCxPrice', wareSource:row.minCxPriceType})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<div data-field="maxHisGyPrice" uglcw-options="width:100">历史干预价(大)</div>
						<div data-field="minHisGyPrice" uglcw-options="width:100">历史干预价(小)</div>
						<div data-field="maxHisPfPrice" uglcw-options="width:100

                                <%--template:function(row){--%>
									<%--return uglcw.util.template($('#hisPrice').html())({val:row.maxHisPfPrice, data: row, field:'maxHisPfPrice', wareSource:row.pfPriceType})--%>
								<%--}--%>
                        ">新历史价(大)</div>
						<div data-field="minHisPfPrice" uglcw-options="width:100">最新历史价(小)</div>
						<div data-field="maxHisPfPrices" uglcw-options="width:100">历史价信息(大)</div>
						<div data-field="minHisPfPrices" uglcw-options="width:100">历史价信息(小)</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script id="header_inPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('inPrice');">大单位采购价</span>
</script>
<script id="header_pfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('wareDj');">批发价(大)</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('lsPrice');">大单位零售价</span>
</script>
<script id="header_fxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('fxPrice');">大单位分销价</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('cxPrice');">大单位促销价</span>
</script>
<script id="header_minInPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minInPrice');">小单位采购价</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('sunitPrice');">批发价(小)</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minLsPrice');">小单位零售价</span>
</script>
<script id="header_minFxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minFxPrice');">小单位分销价</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minCxPrice');">小单位促销价</span>
</script>
<script id="price" type="text/x-uglcw-template">
	# if(val!=null && val!=undefined && val!="" && val!="undefined"){ #
	# }else{ #
	# val = "" #
	# } #

	# if(wareSource == 0){ #
	<span style="color: \\#000;">#= val #</span>
	# }else if(wareSource == 1){ #
	<span style="color: rebeccapurple;">#= val #</span>
	# }else if(wareSource == 2){ #
	<span style="color: \\#4db3ff;">#= val #</span>
	# }else if(wareSource == 3){ #
	<span style="color: green;">#= val #</span>
	# } else if(wareSource == 4){ #
	<span style="color: red;">#= val #</span>
	# } #


</script>

<script id="hisPrice" type="text/x-uglcw-template">
    # if(wareSource == 4){ #
    <span style="color: red;">#= val #</span>
    # }else{ #
    #= val #
    # } #
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {

		//ui:初始化
		uglcw.ui.init();

		//查询
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#click-flag').value(1);
			uglcw.ui.get('#grid').reload();
		})

		//重置
		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
			uglcw.ui.get('#grid').reload();
		})
		//设置tree高度
		var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
		$("#tree").height(treeHeight + "px");
		uglcw.ui.loaded();
	})

</script>
</body>
</html>
