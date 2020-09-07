<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户商品价格设置</title>
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
<%--							<input type="hidden" uglcw-role="textbox" id="type" uglcw-model="type" value="0"/>--%>
							<div class="col-xs-4">
								<input uglcw-model="wareNm" uglcw-role="textbox" placeholder="商品名称">
							</div>
							<div class="col-xs-4">
								<input type="checkbox" class="k-checkbox"
									   uglcw-value="1"
									   uglcw-role="checkbox" uglcw-model="type"
									   id="showType">
								<label style="margin-left: 10px;" class="k-checkbox-label" for="showType">过滤自定义价格的商品</label>

							</div>
							<div class="col-xs-4" style="width: 250px">
								<input type="hidden" uglcw-role="textbox"id="click-flag" value="0"/>
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
<%--								<button id="customsearch" uglcw-role="button" class="k-button k-info">过滤自定义价格的商品</button>--%>
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
								delete params['isType']
								delete params['wtype']
							}
							return params;
							},
							pageable: true,
                    		url: '${base}manager/customerPriceSetWarePage',
                    		criteria: '.form-horizontal',
						    loadFilter:{
									data: function(response){
									  var datas = response.rows || [];
                                      var wareMap = response.wareMap||{};
                                     datas = $.map(datas, function (item) {
										var wareId = item.wareId;
										var ware = wareMap[wareId];
										//console.log(ware);
										item.tempWareDj = ware.wareDj;
										item.tempSunitPrice = ware.sunitPrice;
 									    return item;
                                      })
                                      //console.log(datas);
									  return datas;
									}
								}
                    	">
						<div data-field="wareCode" uglcw-options="width:100">商品编码</div>
						<div data-field="wareNm" uglcw-options="width:100">商品名称</div>
						<div data-field="waretypeNm" uglcw-options="width:100">所属分类</div>
						<div data-field="wareGg" uglcw-options="width:80">规格</div>
						<div data-field="wareDw" uglcw-options="width:60">大单位</div>
						<div data-field="minUnit" uglcw-options="width:60">小单位</div>
						<div data-field="wareDj" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_pfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.wareDj, data: row, field:'wareDj'})
								}
								">
						</div>
						<%--<div data-field="lsPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_lsPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.lsPrice, data: row, field:'lsPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="fxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_fxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.fxPrice, data: row, field:'fxPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="cxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_cxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.cxPrice, data: row, field:'cxPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<div data-field="sunitPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minPfPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.sunitPrice, data: row, field:'sunitPrice'})
								}
								">
						</div>
						<%--<div data-field="minLsPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minLsPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minLsPrice, data: row, field:'minLsPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="minFxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minFxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minFxPrice, data: row, field:'minFxPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<%--<div data-field="minCxPrice" uglcw-options="--%>
								<%--width:120,--%>
								<%--headerTemplate: uglcw.util.template($('#header_minCxPrice').html()),--%>
								<%--template:function(row){--%>
									<%--return uglcw.util.template($('#price').html())({val:row.minCxPrice, data: row, field:'minCxPrice'})--%>
								<%--}--%>
								<%--">--%>
						<%--</div>--%>
						<div data-field="maxHisGyPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_maxHisGyPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.maxHisGyPrice, data: row, field:'maxHisGyPrice'})
								}
								">
						</div>

						<div data-field="minHisGyPrice" uglcw-options="
								width:120,
								headerTemplate: uglcw.util.template($('#header_minHisGyPrice').html()),
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.minHisGyPrice, data: row, field:'minHisGyPrice'})
								}
								">
						</div>

						<%--<div data-field="maxHisPfPrice" uglcw-options="width:100">最新历史价(大)</div>--%>
						<%--<div data-field="minHisPfPrice" uglcw-options="width:100">最新历史价(小)</div>--%>
						<%--<div data-field="maxHisPfPrices" uglcw-options="width:100">历史价信息(大)</div>--%>
						<%--<div data-field="minHisPfPrices" uglcw-options="width:100">历史价信息(小)</div>--%>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script id="header_inPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('inPrice');">大单位采购价✎</span>
</script>
<script id="header_pfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('wareDj');">批发价(大)✎</span>
</script>
<script id="header_lsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('lsPrice');">大单位零售价✎</span>
</script>
<script id="header_fxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('fxPrice');">大单位分销价✎</span>
</script>
<script id="header_cxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('cxPrice');">大单位促销价✎</span>
</script>
<script id="header_minInPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minInPrice');">小单位采购价✎</span>
</script>
<script id="header_minPfPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('sunitPrice');">批发价(小)✎</span>
</script>
<script id="header_minLsPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minLsPrice');">小单位零售价✎</span>
</script>
<script id="header_minFxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minFxPrice');">小单位分销价✎</span>
</script>
<script id="header_minCxPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minCxPrice');">小单位促销价✎</span>
</script>

<script id="header_maxHisGyPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('maxHisGyPrice');">历史干预价(大)✎</span>
</script>
<script id="header_minHisGyPrice" type="text/x-uglcw-template">
	<span onclick="javascript:operatePrice('minHisGyPrice');">历史干预价(小)✎</span>
</script>

<script id="price" type="text/x-uglcw-template">
	# var wareId = data.wareId #
	# if(val == null || val == undefined || val === '' || val== "undefined"){ #
	# 	val = "" #
	# } #
	<input class="#=field#_input k-textbox" name="#=field#_input" uglcw-role="numeric" uglcw-validate="number" style="height:25px;width:60px;display:none" onchange="changePrice(this,'#= field #',#= wareId #)"  value='#= val #'>
	<span class="#=field#_span" id="#=field#_span_#=wareId#" >#= val #</span>

	# if(field=='wareDj'){ #
	(<span class="tempWareDj_span" id="tempWareDj_org_span_#=wareId#" >#=data.tempWareDj#</span>)
	# } #
	# if(field=='sunitPrice'){ #
	(<span class="tempSunitPrice_span" id="tempSunitPrice_org_span_#=wareId#" >#=data.tempSunitPrice #</span>)
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
			// uglcw.ui.get('#type').value(0);
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.get('#showType').on('change', function () {
			// var checked = uglcw.ui.get('#showType').value();
			// if (checked) {
			// } else {
			// }
			uglcw.ui.get('#click-flag').value(1);
			uglcw.ui.get('#grid').reload();
		});

		// uglcw.ui.get('#customsearch').on('click', function () {
		// 	uglcw.ui.get('#click-flag').value(1);
		// 	//uglcw.ui.get('#type').value(1);
		// 	uglcw.ui.get('#grid').reload();
		// })

		//设置tree高度
		var treeHeight = $(window).height() - $("div.layui-card-header").height() - 60;
		$("#tree").height(treeHeight + "px");
		uglcw.ui.loaded();
	})


	//---------------------------------------------------------------------------------------------------------------

	function operatePrice(field) {
		var display =$("."+field+"_input").css('display');
		if(display == 'none'){
			$("."+field+"_input").show();
			$("."+field+"_span").hide();
		}else{
			$("."+field+"_input").hide();
			$("."+field+"_span").show();
		}
	}

	function changePrice(o,field,wareId){
		if(isNaN(o.value)){
			uglcw.ui.toast("请输入数字")
			return;
		}
		$.ajax({
			url: "${base}manager/updateCustomerPriceWarePrice",
			type: "post",
			data: "customerId=${customerId}&wareId=" + wareId + "&price=" + o.value+"&field="+field,
			success: function (data) {
				if (data == '1') {
					$("#"+field+"_span_"+wareId).text(o.value);
				} else {
					uglcw.ui.toast("价格保存失败");
				}
			}
		});
	}


</script>
</body>
</html>
