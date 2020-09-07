<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>进销存客户会员</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
		.xxzf-more{
			font-size: 8px;
			color: red;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<%--2右边：表格start--%>
		<div class="layui-col-md12">
			<%--表格：头部start--%>
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal query">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-4">
								<input uglcw-model="wareId" id="wareId" uglcw-role="textbox" value="${wareId}" type="hidden">
								<input uglcw-model="name" uglcw-role="textbox" placeholder="会员名称">
							</div>
							<div class="col-xs-4">
								<input uglcw-model="mobile" uglcw-role="textbox" placeholder="手机号">
							</div>
							<div class="col-xs-4">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
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
						    responsive:['.header',40],
							id:'id',
                    		url: '${base}manager/shopEndPrice/khEndPriceByWare',
                    		criteria: '.query',
                    	">
						<div data-field="name" uglcw-options="width:150,tooltip:true">会员名称</div>
						<div data-field="oper" uglcw-options="width:130,template: uglcw.util.template($('#oper').html())">操作</div>
						<div data-field="mobile" uglcw-options="width:110">电话</div>
						<div data-field="gradeName" uglcw-options="width:100">会员等级</div>
						<div data-field="customerName" uglcw-options="width:150,tooltip:true">关联客户</div>
						<div data-field="khClose" uglcw-options="width:130,template: uglcw.util.template($('#khClose').html())">关闭进销存客户</div>
						<div data-field="shopWarePrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWarePrice, data: row, wareSource:row.shopWarePriceSource, min:'false'})
								}
								">
							商城批发价(大)
						</div>
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
						<div data-field="shopWareSmallPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallPrice, data: row, wareSource:row.shopWareSmallPriceSource, min:'true'})
								}
								">
							商城批发价(小)
						</div>
						<div data-field="shopWareSmallLsPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallLsPrice, data: row, wareSource:row.shopWareSmallLsPriceSource, min:'true'})
								}
								">
							商城小单位零售价
						</div>
						<%--<div data-field="shopWareSmallCxPrice" uglcw-options="
								width:130,
								template:function(row){
									return uglcw.util.template($('#price').html())({val:row.shopWareSmallCxPrice, data: row, wareSource:row.shopWareSmallCxPriceSource, min:'true'})
								}
								">
							商城小单位促销价
						</div>--%>
						<%--<div data-field="status" uglcw-options="width:100,template: uglcw.util.template($('#status').html())">状态</div>--%>
					</div>
				</div>
			</div>
			<%--表格：end--%>
		</div>
		<%--2右边：表格end--%>
	</div>
</div>

<%--线下支付--%>
<script id="isXxzf" type="text/x-uglcw-template">
	# if(data.isXxzf === 0){ #
	不显示
	# }else if(1 === data.isXxzf){ #
	显示
	# } #
</script>
<%--关闭进销存客户--%>
<script id="khClose" type="text/x-uglcw-template">
	# if(1 === data.khClose){ #
	关闭
	# } #
</script>
<%--操作--%>
<script id="oper" type="text/x-uglcw-template">
	<button onclick="javascript:queryEndPrice(#= data.id#,'#=data.name#');" class="k-button k-info">商品最终执行价</button>
</script>

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
			uglcw.ui.clear('.query');
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.loaded();
	})
	//==========================================================================================

	function queryEndPrice(shopMemberId,name){
		uglcw.ui.openTab(name+"_商品最终执行价","manager/shopEndPrice/toShopEndPriceByShopMember?shopMemberId="+shopMemberId)
	}


</script>
</body>
</html>
