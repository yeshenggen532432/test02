<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>应付货款报表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query query">
                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input uglcw-model="proName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" placeholder="结束时间" value="${edate}">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-card">
        <div class="layui-card-body full">
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    responsive:['.header',40],
                    id:'id',
                    dblclick: function(row){
                         var query = uglcw.ui.bind('.query');
                         query.proName=row.proName;
                         query.proType=row.proType;
                         uglcw.ui.openTab('应付货款', '${base}manager/finRptYfkUnitItems?' + $.map(query, function (v, k) {
                            return k + '=' + (v);
                        }).join('&'));
                    },
                    criteria: '.uglcw-query',
                    url: '${base}manager/queryYfkUnitStat',
                    aggregate:[
                     {field: 'totalAmt', aggregate: 'SUM'},
                     {field: 'disAmt', aggregate: 'SUM'},
                     {field: 'disAmt1', aggregate: 'SUM'},
                     {field: 'freeAmt', aggregate: 'SUM'},
                     {field: 'payAmt', aggregate: 'SUM'}
                    ],
                    loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	totalAmt: 0,
                        	disAmt: 0,
                        	disAmt1: 0,
                        	freeAmt: 0,
                        	payAmt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1]);
                        }
                        return aggregate;
                      }
                     },
                    pageable: true,
                    ">
                <div data-field="proName" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt#'">销售金额
                </div>
                <div data-field="disAmt1"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.disAmt1#'">发货金额
                </div>
                <div data-field="payAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.payAmt#'">已付金额
                </div>
                <div data-field="freeAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.freeAmt#'">核销金额
                </div>
                <div data-field="totalAmt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.totalAmt#'">应付金额
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
            uglcw.ui.clear('.uglcw-query');
        })
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
