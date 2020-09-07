<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>车辆配送客户细项统计表</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal query">
						<div class="form-group" style="margin-bottom: 10px;">
							<div class="col-xs-3">
								<input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
							</div>
							<div class="col-xs-3">
								<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
							</div>
							<div class="col-xs-3">
								<input type="textbox" uglcw-role="textbox" uglcw-model="vehNo" value="${vehNo}" placeholder="车牌号"/>
							</div>
							<div class="col-xs-3">
								<input type="textbox" uglcw-role="textbox" uglcw-model="driverName" value="${driverName}" placeholder="送货人"/>
							</div>
							<div class="col-xs-3">
								<input type="textbox" uglcw-role="textbox" uglcw-model="customerName" value="${customerName}" placeholder="客户名称"/>
							</div>
							<div class="col-xs-3">
								<input type="textbox" uglcw-role="textbox" uglcw-model="wareNm" value="${wareNm}" placeholder="品名"/>
							</div>
							<div class="col-xs-3">
								<select uglcw-model="billStatus" uglcw-role="combobox" uglcw-options="value:'${billName}'" id="status">
									<option value="">--销售类型--</option>
									<option value="正常销售">正常销售</option>
									<option value="促销折让">促销折让</option>
									<option value="消费折让">消费折让</option>
									<option value="费用折让">费用折让</option>
									<option value="其他销售">其他销售</option>
									<option value="其它出库">其它出库</option>
									<option value="借用出库">借用出库</option>
									<option value="领用出库">领用出库</option>
									<option value="报损出库">报损出库</option>
								</select>
							</div>


							<div class="col-xs-3">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
							</div>
						</div>
						<div class="form-group" style="margin-bottom:0px">
							<div class="col-xs-3">
								<input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="商品名称">
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="layui-card">
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                        autoBind: false,
                        id:'id',
                        aggregate:[
                        	{field: 'outQty', aggregate:'SUM'},
                        	{field: 'tranAmt', aggregate:'SUM'},
                        	{field: 'ioPrice', aggregate:'SUM'}
                        ],
                        loadFilter: {
                        	data: function(response){
                        		if(!response || !response.rows || response.rows.length < 2){
                        			return []
                        		}
                        		response.rows.splice(response.rows.length - 1, 1)
                        		return response.rows || [];
                        	},
                        	aggregates: function(response){
                        		var aggregates  = uglcw.extend({outQty:0, tranAmt: 0, ioPrice: 0}, response.rows[response.rows.length-1]);
                        		return aggregates;
                        	}
                        },
                        dblclick: function(row){
                          showDetail(row.billId, row.billName);
                        },
                        url: '${base}manager/queryVehicleCustomerItemStatPage',
                        criteria: '.query',
                        pageable: true
                    ">
						<div data-field="billNo" uglcw-options="width:200, template: uglcw.util.template($('#bill-no').html()), footerTemplate:'合计：'">单据号</div>
						<div data-field="vehNo" uglcw-options="width:120">车牌号</div>
						<div data-field="driverName" uglcw-options="width:120">送货人</div>
						<div data-field="customerName" uglcw-options="width:120">销售客户</div>
						<div data-field="wareNm" uglcw-options="width:150">品项</div>
						<div data-field="billName" uglcw-options="width:140">销售类型</div>
						<div data-field="unitName" uglcw-options="width:100">单位</div>
						<div data-field="outQty" uglcw-options="width:100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty,\'n2\')#'">发货数量</div>
						<div data-field="tranAmt" uglcw-options="width:100, format: '{0:n2}',  footerTemplate: '#= uglcw.util.toString(data.tranAmt,\'n2\')#'">单位配送费用</div>
						<div data-field="ioPrice" uglcw-options="width:100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.ioPrice,\'n2\')#'">配送费用</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script id="bill-no" type="text/x-uglcw-template">
	<a href="javascript:showDetail(#= data.billId#, '#= data.billName#');" style="color: \\#3343a4;font-size: 12px; font-weight: bold;">#=
		data.billNo#</a>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

	$(function () {
		uglcw.ui.init();
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})
		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
		})
		resize();
		$(window).resize(resize);
		uglcw.ui.loaded()
	})

	var delay;

	function resize() {
		if (delay) {
			clearTimeout(delay);
		}
		delay = setTimeout(function () {
			var grid = uglcw.ui.get('#grid').k();
			var padding = 45;
			var height = $(window).height() - padding - $('.header').height();
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

	function showDetail(id, billName) {
		if(billName === '其它出库'){
			uglcw.ui.openTab('其它出库开票信息'+id, '${base}manager/showstkoutcheck?dataTp=1&billId='+id)
		}else{
			uglcw.ui.openTab('销售发货明细'+id, '${base}manager/toOutList?dataTp=1&billId='+id)
		}

	}
</script>
</body>
</html>
