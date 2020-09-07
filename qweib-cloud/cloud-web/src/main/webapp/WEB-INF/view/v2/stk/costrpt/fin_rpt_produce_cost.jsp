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
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
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
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                       aggregates: function (response) {
                        var aggregate = {};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     },
                      responsive:['.header',40],
                    id:'id',
                    url: 'manager/finRptProduceCost',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'qc_amt', aggregate: 'SUM'},
                     {field: 'in_amt', aggregate: 'SUM'},
                     {field: 'out_amt', aggregate:'SUM'},
                     {field: 'qm_amt', aggregate: 'SUM'},
                    ],

                    }">

                <div data-field="pro_name"
                     uglcw-options="width:200,footerTemplate: '合  计'">部门
                </div>
                <div data-field="qc_amt"
                     uglcw-options="width:200,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.qc_amt,\'n2\')#'">
                    期初余额
                </div>
                <div data-field="in_amt"
                     uglcw-options="width:200,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.in_amt,\'n2\')#'">
                    本期增加
                </div>
                <div data-field="out_amt"
                     uglcw-options="width:200,format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.out_amt,\'n2\')#'">
                    本期减少
                </div>
                <div data-field="qm_amt"
                     uglcw-options="width:200, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.qm_amt,\'n2\')#'">
                    期末余额
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
        uglcw.ui.loaded()
    })


</script>
</body>
</html>
