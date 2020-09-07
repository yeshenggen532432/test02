<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货款管理</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">

                <li>
                    <input type="hidden" uglcw-model="jz" value="1" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="proType" value="" uglcw-role="textbox">
                    <input uglcw-model="unitName" uglcw-role="textbox" placeholder="往来单位">
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" placeholder="开始时间" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="所属二批">
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

                       var q = uglcw.ui.bind('.query');
                       q.epcustomername=row.epcustomername
                       q.unitName=row.unitname;
                       q.proType=row.protype;
                       q.unitId=row.unitid;
                       q.beginAmt = 0;
                       q.endAmt = 0;
                       uglcw.ui.openTab(q.unitName+'_应收流水', '${base}manager/toYsUnitFlowPage?'+ $.map(q, function(v, k){
                          return k + '=' + (v);
                       }).join('&'));

                       <%--var q = uglcw.ui.bind('.query');--%>
                       <%--q.epcustomername=row.epcustomername--%>
                       <%--q.unitName=row.unitname;--%>
                       <%--q.proType=row.protype;--%>
                       <%--uglcw.ui.openTab('应收账款明细', '${base}manager/finRptYskUnitItems?'+ $.map(q, function(v, k){--%>
                      <%--return k + '=' + (v);--%>
                       <%--}).join('&'));--%>
                    },
                    url: '${base}manager/queryYskUnitStat',
                    aggregate:[
                     {field: 'disamt', aggregate: 'SUM'},
                     {field: 'disamt1', aggregate: 'SUM'},
                     {field: 'recamt', aggregate: 'SUM'},
                     {field: 'freeamt', aggregate: 'SUM'},
                     {field: 'sumamt', aggregate: 'SUM'}
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
                        	disamt: 0,
                        	disamt1: 0,
                        	recamt: 0,
                        	freeamt: 0,
                        	sumamt: 0
                        };
                        if (response.rows && response.rows.length > 0) {
                            aggregate = response.rows[response.rows.length - 1]
                        }
                        return aggregate;
                      }
                     },
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="unitname" uglcw-options="width:180,tooltip: true, footerTemplate: '合计'">往来单位</div>
                <div data-field="disamt"
                     uglcw-options="width:120,hidden:true,format: '{0:n2}', footerTemplate: '#= data.disamt || 0#'">销售金额
                </div>
                <div data-field="disamt1"
                     uglcw-options="width:120,hidden:true, format: '{0:n2}', footerTemplate: '#= data.disamt1 || 0#'">发货金额
                </div>
                <div data-field="recamt"
                     uglcw-options="width:120,hidden:true, format: '{0:n2}', footerTemplate: '#= data.recamt || 0#'">已收金额
                </div>
                <div data-field="freeamt"
                     uglcw-options="width:120,hidden:true, format: '{0:n2}', footerTemplate: '#= data.freeamt || 0#'">核销金额
                </div>
                <div data-field="sumamt"
                     uglcw-options="width:120, format: '{0:n2}', footerTemplate: '#= data.sumamt || 0#'">欠款金额
                </div>
                <div data-field="epcustomername" uglcw-options="width:150">所属二批</div>
            </div>
        </div>
    </div>
</div>
<script type="text/x-uglcw-template" id="op-tpl">
    <button class="k-button k-info" onclick="toAutoRec(#= data.unitid#, '#= data.unitname#', #= data.sumamt#)">收款
    </button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal', {sdate: '${sdate}', edate: '${edate}'});
        })
        uglcw.ui.loaded()
    })

    function toUnitRecPage() {
        var query = uglcw.ui.bind('.query');
        uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?' + $.map(query, function (v, k) {
            return k + '=' + (v || '');
        }).join('&'));
    }

</script>
</body>
</html>
