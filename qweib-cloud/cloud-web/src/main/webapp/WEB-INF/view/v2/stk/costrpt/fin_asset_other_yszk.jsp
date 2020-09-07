<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
	<title>驰用T3</title>
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
		<div class="layui-col-md12">
			<div class="layui-card header">
				<div class="layui-card-body">
					<div class="form-horizontal" id="export">
						<div class="form-group" style="margin-bottom:0px;">
							<input uglcw-role="textbox"  uglcw-model="proName" type="hidden">
							<input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
							<input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
							<input type="hidden" uglcw-model="sdate" uglcw-role="textbox" value="${sdate}">
							<div class="col-xs-4">
								<input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
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
						 uglcw-options="{
					loadFilter: {
                      data: function (response) {
                        response.rows.splice(0, 1);
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[0]);
                        }
                        return aggregate;
                      }
                     },
					   dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       q.proId = row.proId;
                       q.proName=row.proName;
                       uglcw.ui.openTab('应回款统计明细'+q.proId, '${base}manager/toFinOutTotalItem?'+ $.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                    },
                    id:'id',
                    url: 'manager/queryFinOutTotal',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'needPay', aggregate: 'SUM'}
                    ],

                    }">

						<div data-field="proName" uglcw-options="width:160,footerTemplate: '合  计'">往来单位</div>

						<div data-field="needPay"
							 uglcw-options="width:120, format: '{0:n2}',footerTemplate: '#=uglcw.util.toString(data.needPay,\'n2\')#'">应回款金额
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

		uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
			uglcw.ui.get('#grid').k().dataSource.read();
		})

		uglcw.ui.get('#reset').on('click', function () {    //重置
			uglcw.ui.clear('.form-horizontal');
		})
		resize();
		$(window).resize(resize)
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

</script>
</body>
</html>
