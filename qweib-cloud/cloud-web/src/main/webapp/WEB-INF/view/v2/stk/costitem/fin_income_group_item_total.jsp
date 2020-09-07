<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>其它收入统计</title>
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
                    <ul class="uglcw-query form-horizontal" id="export">
                        <li>
                            <input uglcw-role="textbox" uglcw-model="itemName" placeholder="明细科目名称">
                        </li>
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
                      total: function (response) {
                        return response.total;
                      },
                      aggregates: function (response) {
                        var aggregate = {
                        	recamt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     },
                      dblclick:function(row){
                       var q = uglcw.ui.bind('.form-horizontal');


                       q.itemName = row.itemName;
                       uglcw.ui.openTab('其它收入收款明细', '${base}manager/toIncomeStatItemPage?'+ $.map(q, function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                     responsive:['.header',40],
                    id:'id',
                    url: 'manager/queryIncomeGroupItemPage',
                    pageable: true,
                    rowNumber: true,
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'recAmt', aggregate: 'SUM'}
                    ]

                    }">
                        <div data-field="typeName" uglcw-options="width:200,footerTemplate: '合  计'">科目名称</div>
                        <div data-field="itemName" uglcw-options="width:200">明细科目名称</div>
                        <div data-field="recAmt"
                             uglcw-options="width:200, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString(data.recAmt,\'n2\')#'">
                            收款金额
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


</script>
</body>
</html>
