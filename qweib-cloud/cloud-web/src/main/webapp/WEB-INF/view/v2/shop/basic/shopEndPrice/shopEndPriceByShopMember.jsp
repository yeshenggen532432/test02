<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>商品最终执行价</title>
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
		<%--1左边：商品分类start--%>
		<div class="layui-col-md2">
			<div class="layui-card">
				<div class="layui-card-header">商品分类</div>
				<div class="layui-card-body">
					<div uglcw-role="tree" id="tree"
						 uglcw-options="
						 	lazy: false,
							url: '${base}manager/shopWareNewType/shopWaretypesExists',
							expandable:function(node){return node.id == '0'},
							select: function(e){
								var node = this.dataItem(e.node);
								uglcw.ui.get('#wareType').value(node.id);
								uglcw.ui.get('#grid').reload();
                       		}
                    	">
					</div>
				</div>
			</div>
		</div>
		<%--1左边：商品分类end--%>

		<%--2右边：表格start--%>
		<div class="layui-col-md10">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-4">
								<input uglcw-model="shopMemberId" id="shopMemberId" uglcw-role="textbox" value="${shopMemberId}" type="hidden">
								<input uglcw-model="wareType" id="wareType" uglcw-role="textbox" value="${wareType}" type="hidden">
								<input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
							</div>
							<div class="col-xs-4">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
							<div class="col-xs-12">
								<span style="background-color:orange">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>进销存商品基础价
								<span style="background-color:#333333">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城商品基础价
								<span style="background-color:blue">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城会员等级价格
								<span style="background-color:green">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>商城会员自定义价格
							</div>
						</div>
					</div>
				</div>
			</div>
			<%--表格：头部end--%>

			<%--表格：start--%>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
							id:'id',
							checkbox:true,
							pageable: true,
                    		url: '${base}manager/shopEndPrice/shopWareEndPricePageByShopMemberId',
                    		criteria: '.form-horizontal',
                    	">
						<div data-field="wareNm" uglcw-options="width:200">商品名称</div>
						<div data-field="wareGg" uglcw-options="width:150">规格</div>
				<c:if test="${'0'==source || '3'==source}">
						<div data-field="shopWarePrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, wareSource:row.shopWarePriceSource, min:'false'})
								}
								">
							商城批发价(大)
						</div>
				</c:if>
						<div data-field="shopWareLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareLsPrice, data: row, wareSource:row.shopWareLsPriceSource, min:'false'})
								}
								">
							商城零售价(大)
						</div>
						<%--<div data-field="shopWareCxPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareCxPrice, data: row, wareSource:row.shopWareCxPriceSource, min:'false'})
								}
								">
							商城大单位促销价
						</div>--%>
				<c:if test="${'0'==source || '3'==source}">
						<div data-field="shopWareSmallPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, wareSource:row.shopWareSmallPriceSource, min:'true'})
								}
								">
							商城批发价(小)
						</div>
				</c:if>
						<div data-field="shopWareSmallLsPrice" uglcw-options="
								width:120,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, wareSource:row.shopWareSmallLsPriceSource, min:'true'})
								}
								">
							商城零售价(小)
						</div>
						<%--<div data-field="shopWareSmallCxPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallCxPrice, data: row, wareSource:row.shopWareSmallCxPriceSource, min:'true'})
								}
								">
							商城小单位促销价
						</div>--%>
					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<script id="price" type="text/x-uglcw-template">
	# if(val!=null && val!=undefined && val!="" && val!="undefined"){ #
	#if('true' == min){ #
	# val = val.toFixed(2) #
	# } #
	# }else{ #
	# val = "" #
	# } #

	# if(wareSource == 1){ #
	<span style="color: orange;">#= val #</span>
	# }else if(wareSource == 2){ #
	<span style="color: \\#333;">#= val #</span>
	# }else if(wareSource == 3){ #
	<span style="color: blue;">#= val #</span>
	# }else if(wareSource == 4){ #
	<span style="color: green;">#= val #</span>
    # }else{ #
    #= val #
    #}#
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		//ui:初始化
		uglcw.ui.init();

		//查询
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		//重置
		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal');
			uglcw.ui.get('#grid').reload();
		})

		//resize();
		//$(window).resize(resize);
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
			var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
			$("#tree").height(treeHeight + "px");
		}, 200)
	}

	//---------------------------------------------------------------------------------------------------------------



</script>
</body>
</html>
