<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>客户毛利明细统计</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card">
				<div class="query">
					<input uglcw-role="textbox" uglcw-model="sdate" type="hidden" id="sdate" value="${sdate}"/>
					<input uglcw-role="textbox" uglcw-model="edate" type="hidden" id="edate" value="${edate}"/>
					<input uglcw-role="textbox" uglcw-model="stkUnit" type="hidden" id="stkUnit" value="${stkUnit}"/>
					<input uglcw-role="textbox" uglcw-model="outType" type="hidden" id="outType" value="${outType}"/>
					<input uglcw-role="textbox" uglcw-model="wtype" type="hidden" id="wtype" value="${wtype}"/>
					<input uglcw-role="textbox" uglcw-model="regionId" type="hidden" id="regionId" value="${regionId}"/>
					<input uglcw-role="textbox" uglcw-model="timeType" type="hidden" id="timeType" value="${timeType}"/>
					<input uglcw-role="textbox" uglcw-model="epCustomerName" type="hidden" id="epCustomerName" value="${epCustomerName}"/>
				</div>
				<div class="layui-card-body full">
					<div id="grid" uglcw-role="grid"
						 uglcw-options="
                    autoBind: false,
                    id:'id',
                    url: '${base}manager/queryCstStatDetailPage',
                    criteria: '.query',
                    pageable: true,
                    aggregate:[
                     {field: 'sumQty', aggregate: 'SUM'},
                     {field: 'sumAmt', aggregate: 'SUM'},
                     {field: 'avgPrice', aggregate: 'SUM'},
                     {field: 'sumCost', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'avgAmt', aggregate: 'SUM'},
                     {field: 'rate', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        if(!response || !response.rows || response.rows.length <1){
                            return [];
                        }
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows;
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                            sumQty:0,
                            sumAmt:0,
                            avgPrice:0,
                            discount:0,
                            inputAmt:0,
                            sumCost:0,
                            disAmt:0,
                            avgAmt:0,
                            rate:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
						<div data-field="stkUnit" uglcw-options="width: 120">客户名称</div>
						<div data-field="wareNm" uglcw-options="width: 150,tooltip:true">商品名称</div>
						<div data-field="sumQty"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumQty || 0, \'n2\')#'">
							销售数量
						</div>
						<div data-field="sumAmt"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate:'#= uglcw.util.toString(data.sumAmt || 0, \'n2\')#'">
							销售收入
						</div>
						<div data-field="avgPrice"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgPrice || 0, \'n2\')#'">
							平均单位售价
						</div>
						<div data-field="discount"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.discount || 0, \'n2\')#'">
							整单折扣
						</div>
						<div data-field="sumCost"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.sumCost || 0, \'n2\')#'">
							销售成本
						</div>
						<div data-field="disAmt"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.disAmt || 0, \'n2\')#'">
							销售毛利
						</div>
						<div data-field="avgAmt"
							 uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.avgAmt || 0, \'n2\')#'">
							平均单位毛利
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
			var padding = 40;
			var height = $(window).height() - padding;
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

</script>
</body>
</html>
