<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<title>业务员客户细项统计表</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-row layui-col-space15">
		<div class="layui-col-md12">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal">
						<div class="form-group" style="margin-bottom: 0px;">
							<div class="col-xs-3">
								<input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
							</div>
							<div class="col-xs-3">
								<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
							</div>
							<div class="col-xs-3">
								<select uglcw-model="billName" id="xsTp" uglcw-role="combobox">
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
									<option value="销售退货">销售退货</option>
								</select>
							</div>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="driverName" value="${driverName}" placeholder="业务员"/>
							</div>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="wareNm" placeholder="品名" value="${wareNm}"/>
							</div>
							<div class="col-xs-3">
								<input uglcw-role="textbox" uglcw-model="customerName" value="${customerName}" placeholder="客户名称"/>
							</div>
							<div class="col-xs-6">
								<button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
								<button id="reset" class="k-button" uglcw-role="button">重置</button>
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
                    url: '${base}manager/querySaleCustomerStatPage',
                    criteria: '.form-horizontal',
                    pageable: true,
                    aggregate:[
                     {field: 'outQty', aggregate: 'SUM'},
                     {field: 'ioPrice', aggregate: 'SUM'}
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
                            outQty:0,
                            ioPrice:0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     }

                    ">
						<div data-field="billNo" uglcw-options="width: 100,footerTemplate: '合  计'">单据号</div>
						<div data-field="driverName" uglcw-options="width: 100">业务员</div>
						<div data-field="customerName" uglcw-options="width: 140,tooltip: true">销售客户</div>
						<div data-field="wareNm" uglcw-options="width: 100">品项</div>
						<div data-field="billName" uglcw-options="width: 100">销售类型</div>
						<div data-field="unitName" uglcw-options="width: 100">单位</div>
						<div data-field="outQty" uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.outQty || 0, \'n2\')#'">发货数量</div>
						<div data-field="tcAmt" uglcw-options="width: 100, format: '{0:n2}'">单位提成费用</div>
						<div data-field="ioPrice" uglcw-options="width: 100, format: '{0:n2}', footerTemplate: '#= uglcw.util.toString(data.ioPrice || 0, \'n2\')#'">提成额</div>
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
		uglcw.ui.get('#search').on('click', function () {
			uglcw.ui.get('#grid').reload();
		})

		uglcw.ui.get('#reset').on('click', function () {
			uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}', driverName: '${driverName}', customerName: '${customerName}', wareNm: '${wareNm}' });
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
			var padding = 55;
			var height = $(window).height() - padding - $('.header').height();
			grid.setOptions({
				height: height,
				autoBind: true
			})
		}, 200)
	}

	function showMainDetail() {
		var q = uglcw.ui.bind('.form-horizontal');
		uglcw.ui.openTab('查看客户毛利明细', '${base}manager/queryCstStatDetailList?' + $.map(q, function (v, k) {
			return k + '=' + (v || '');
		}).join('&'));
	}

	function exportExcel() {
	}

	function editRptData() {
		var query = uglcw.ui.bind('.form-horizontal');
		uglcw.ui.openTab('编辑业务员客户统计表', "${base}manager/querySaleCustomerStatList?" + $.map(query, function (v, k) {
			return k + '=' + (v || '');
		}).join('&'));
	}

</script>
</body>
</html>
