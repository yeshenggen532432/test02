<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>预收款统计</title>
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
    <div class="layui-card">
        <div class="layui-card-body full">
            <ul class="uglcw-query form-horizontal">
                <li>
                    <input type="hidden" uglcw-model="ioType" value="${ioType}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="amtType" value="${amtType}" uglcw-role="textbox">

                    <input uglcw-role="textbox" uglcw-model="unitName" placeholder="往来单位">
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
            <div id="grid" uglcw-role="grid"
                 uglcw-options="
                    lockable: false,
                    rowNumber:true,
                    pageable: true,
					loadFilter: {
                      data: function (response) {
                        response.rows.splice( response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {sumAmt: 0};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate, response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     },
                       dblclick:function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                         q.unitId = row.unitId;
                         q.unitName = row.unitName;
                         delete q['ioType'];
                       uglcw.ui.openTab('往来单位预收明细', '${base}manager/toFinPreInUnitDetail?'+$.map(q,function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    id:'id',
                    url: 'manager/queryFinPreInUnitStat',
                     criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'sumAmt', aggregate: 'SUM'}
                    ]">
                <div data-field="unitName" uglcw-options="footerTemplate: '合  计:'">往来单位</div>
                <div data-field="sumAmt"
                     uglcw-options="format: '{0:n2}',footerTemplate: '#=uglcw.util.toString( data.sumAmt,\'n2\')#'">预收款余额</div>
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
