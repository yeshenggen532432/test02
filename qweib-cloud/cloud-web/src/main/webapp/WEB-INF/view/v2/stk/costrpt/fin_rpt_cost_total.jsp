<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>费用统计</title>
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
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
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

                     dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');
                       q.typeId = row.type_id;
                       q.typeName = row.type_name;
                       uglcw.ui.openTab(q.typeName+'-费用明细项统计', '${base}manager/toFinRptCostTotalItems?'+ $.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                      responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryCostListTotal',
                    criteria: '.form-horizontal',


                    }">

                <div data-field="type_name" uglcw-options="width:200, template: '<span>#= data.type_name#</span>'">科目名称
                </div>
                <div data-field="total_amt"
                     uglcw-options="width:200, format: '{0:n2}'">金额
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
