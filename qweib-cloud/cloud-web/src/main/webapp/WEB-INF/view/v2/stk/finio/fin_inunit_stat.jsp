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
    <div class="layui-card">
        <div class="layui-card-body full">
            <div class="form-horizontal">
                <div class="form-group" style="margin-bottom:10px;">
                    <input type="hidden" uglcw-model="ioType" value="${ioType}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="amtType" value="${amtType}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="titleName" value="${titleName}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="sdate" value="${sdate}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="edate" value="${edate}" uglcw-role="textbox">
                </div>
            </div>
            <div id="grid" uglcw-role="grid"
                 uglcw-options="{
					loadFilter: {
                      data: function (response) {
                        response.rows.splice(response.rows.length - 1, 1);
                        return response.rows || []
                      },
                      aggregates: function (response) {
                        var aggregate = {sumAmt: 0};
                        if (response.rows && response.rows.length > 0) {
                            aggregate = uglcw.extend(aggregate,response.rows[response.rows.length - 1])
                        }
                        return aggregate;
                      }
                     },
                      dblclick:function(row){
                        var q = uglcw.ui.bind('.form-horizontal');
                         q.unitId = row.unitId;
                         delete q['titleName'];
                         delete q['ioType'];
                       uglcw.ui.openTab('供应商付款明细', '${base}manager/toFinInUnitDetail?'+$.map(q,function(v, k){
                        return k+'='+(v||'');
                       }).join('&'));
                     },
                    id:'id',
                    url: 'manager/queryFinInUnitStat',
                    criteria: '.form-horizontal',
                     aggregate:[
                     {field: 'sumAmt', aggregate: 'SUM'}
                    ],

                    }">
                <div data-field="unitName" uglcw-options="width:200,footerTemplate: '合  计'">往来单位</div>
                <div data-field="sumAmt"
                     uglcw-options="width:200, format: '{0:n2}',footerTemplate: '#= uglcw.util.toString( data.sumAmt,\'n2\')#'">${titleName}
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init();
        uglcw.ui.loaded()
    })

</script>
</body>
</html>
