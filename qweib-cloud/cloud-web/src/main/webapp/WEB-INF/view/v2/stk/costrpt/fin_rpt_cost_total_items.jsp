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
                    <div class="form-horizontal">
                        <div class="form-group" style="margin-bottom:0px;">
                            <input uglcw-model="costType" type="hidden" value="${typeId}" uglcw-role="textbox"/>
                            <input type="hidden" uglcw-model="isNeedPay" value="0" uglcw-role="textbox">
                            <div class="col-xs-3">
                                <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                            </div>
                            <div class="col-xs-3">
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
                         dblclick:function(row){
                           var q = uglcw.ui.bind('.form-horizontal');
                           //q.typeId = row.type_id;
                           q.typeId = row.item_id;
                           q.typeName = row.item_name;
                           uglcw.ui.openTab(q.typeName+'-费用明细项列表统计', '${base}manager/toFinRptCostTotalItemsDetails?'+ $.map(q, function(v, k){
                            return k+'='+(v||'');
                           }).join('&'));
                     },
					loadFilter: {
                      data: function (response) {
                        response.rows.splice(0, 1);
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {total_amt: 0};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[0]
                        }
                        return aggregate;
                      }
                     },
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryCostListTotalItems',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'amt', aggregate: 'SUM'}
                    ],

                    }">

                        <div data-field="item_name" uglcw-options="width:200,footerTemplate: '合  计'">科目名称</div>
                        <div data-field="amt"
                             uglcw-options="width:200, format: '{0:n2}',footerTemplate: '<span style=\cursor: pointer;\' ondblclick=\'toDetail()\'>#=  uglcw.util.toString(data.amt,\'n2\')#</span>'">
                            金额
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

        uglcw.ui.loaded()

    })

    function toDetail() {
        var q = uglcw.ui.bind('.form-horizontal');
        uglcw.ui.openTab('合计-费用明细项列表统计', '${base}manager/toFinRptCostTotalItemsDetails?' + $.map(q, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }


</script>
</body>
</html>
