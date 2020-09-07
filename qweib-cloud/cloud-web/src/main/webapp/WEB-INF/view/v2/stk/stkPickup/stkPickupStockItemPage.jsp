<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>领料结存明细</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card">
				<div class="layui-card-body full">
					<div class="query">
						<input type="hidden" uglcw-role="textbox" uglcw-model="proId" value="${proId}"/>
						<input type="hidden" uglcw-role="textbox" uglcw-model="wareIds" value="${wareIds}"/>
					</div>
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                        autoBind: true,
                        checkbox: true,
                        id:'id',
                        aggregate:[
							 {field: 'cost_price', aggregate: 'SUM'},
							 {field: 'qty', aggregate: 'SUM'},
							 {field: 'out_qty', aggregate: 'SUM'},
							 {field: '_jcQty', aggregate: 'SUM'},
                    	],
                        loadFilter:{
                        	data:function(response){
                        		if(!response || !response.rows || response.rows.length < 2){
                        			return []
                        		}
                        		response.rows.splice(response.rows.length-1, 1);
                        		$(response.rows).each(function(idx, row){
                        			row._jcQty = parseFloat(row.qty) - parseFloat(row.out_qty);
                        		})
                        		return response.rows || [];
                        	},
                        	aggregates: function(response){
                        		var aggregate = {
                        			cost_price: 0,
                        			qty: 0,
                        			out_qty: 0,
                        			_jcQty: 0,
                        		};
								if (response.rows && response.rows.length > 0) {
									aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
									aggregate._jcQty = parseFloat(aggregate.qty) - parseFloat(aggregate.out_qty);
								}
								return aggregate;
                        	}
                        },
                        dblclick: function(row){
                          uglcw.ui.openTab('领料结存明细', '${base}manager/stkPickup/tostockitempage?proId='+row.pro_id + '&wareIds='+row.ware_id);
                        },
                        url: '${base}manager/stkPickup/stockitempage',
                        criteria: '.query',
                    ">
						<div data-field="pro_name" uglcw-options="width:160">车间</div>
						<div data-field="ware_nm" uglcw-options="width:160">物料名称</div>
						<div data-field="ware_gg" uglcw-options="width:140, footerTemplate: '合计：'">规格</div>
						<div data-field="cost_price"
							 uglcw-options="width:120, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.cost_price,\'n2\')#'">
							平均成本价
						</div>
						<div data-field="qty"
							 uglcw-options="width:120,hidden:true, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.qty,\'n2\')#'">
							领料数量
						</div>
						<div data-field="out_qty"
							 uglcw-options="width:120,hidden:true, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data.out_qty,\'n2\')#'">
							已用数量
						</div>
						<div data-field="_jcQty"
							 uglcw-options="width:120, format:'{0:n2}', footerTemplate: '#= uglcw.util.toString(data._jcQty,\'n2\')#'">
							结存
						</div>
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



	function showDetail(id) {
		uglcw.ui.openTab('生产入库' + id, '${base}manager/stkProduce/show?billId=' + id)
	}

	function add() {
		uglcw.ui.openTab('生产入库', '${base}manager/stkProduce/add?bizType=SCRK');
	}
</script>
</body>
</html>
