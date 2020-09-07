<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>杂费结算余额表</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .row-color-blue {
            color: blue;
            text-decoration: line-through;
            font-weight: bold;
        }

        .row-color-pink {
            color: #FF00FF !important;
            font-weight: bold;
        }

        .row-color-red {
            color: red  !important;
            font-weight: bold;
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
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                        </li>
                        <li>
                            <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">

                        </li>
                        <li>
                            <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                        </li>

                    </ul>
                </div>
            </div>
            <div class="layui-card">
                <div class="layui-card-body full">
                    <div id="grid" uglcw-role="grid"
                         uglcw-options="{
                         loadFilter: {
                         data: function (response) {
                         response.rows.splice( response.rows.length - 1, 1);
                         return response.rows || []
                       },
                       aggregates: function (response) {
                         var aggregate = {
                                inAmt:0,
                                outAmt:0
                         };
                       if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
                       }
                        return aggregate;
                       }
                     },
                      dblclick: onDblClickRow,
                    pageable: true,
                    responsive:['.header',40],
                    url: 'manager/stkExtrasCarryOver/queryExtrasFeeBalancePage',
                    criteria: '.form-horizontal',
                      aggregate:[
                     {field: 'in_amt', aggregate: 'SUM'},
                     {field: 'out_amt', aggregate: 'SUM'}
                    ],
                    }">
                        <div data-field="bill_no" uglcw-options="width:170,tooltip: true">单号</div>
                        <div data-field="submit_time"
                             uglcw-options="width:160,footerTemplate: '合计：'">日期
                        </div>
                        <div data-field="pro_name" uglcw-options="width:160,tooltip: true">杂费单位</div>
                        <div data-field="in_amt"
                             uglcw-options="width:120,footerTemplate: '#= uglcw.util.toString(data.in_amt,\'n2\')#'">增加杂费
                        </div>
                        <div data-field="out_amt"
                             uglcw-options="width:120,footerTemplate: '#= uglcw.util.toString(data.out_amt,\'n2\')#'">摊销
                        </div>
                        <div data-field="left_amt" uglcw-options="width:120">结余</div>
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
        uglcw.ui.loaded()
    })

    function onDblClickRow(row) {
        var url = "";
        if(row.biz_type=='ZFJC' ){
             url = 'manager/stkExtrasCarryOver/show?billId=' + row.bill_id;
        }else if(row.biz_type=='CGZF'){
            url = 'manager/stkExtrasFee/show?billId=' + row.bill_id;
        }else if(row.biz_type=='ZFHK'){
            url = 'manager/showStkPayMast?billId=' + row.bill_id;
        }
        uglcw.ui.openTab("详细", url);
    }

</script>
</body>
</html>
