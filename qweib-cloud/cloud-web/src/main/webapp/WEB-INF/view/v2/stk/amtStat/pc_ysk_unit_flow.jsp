<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>应收流水---客户往来对账单</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal query">
                <li>
                    <input type="hidden" uglcw-model="unitId" value="${unitId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="proType" value="${proType}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="shopId" value="${shopId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="showPre" value="${showPre}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="showXsth" value="${showXsth}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="inTypes" value="${inTypes}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="shopId" value="${shopId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="unitName" uglcw-role="textbox" value="${unitName}" placeholder="往来单位" readonly>
                </li>
                <li>
                    <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}" readonly>
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}" readonly>
                </li>
                <%--<li>--%>
                    <%--<input uglcw-model="epCustomerName" uglcw-role="textbox" placeholder="所属二批">--%>
                <%--<li>--%>
                    <%--<tag:select2 name="shopId" id="shopId" value="${shopId}" tableName="sys_chain_store"--%>
                                 <%--displayKey="id" displayValue="store_name" placeholder="所属连锁店"/>--%>
                <%--</li>--%>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="print" uglcw-role="button" class="k-button k-info">打印</button>
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
                       <%--var q = uglcw.ui.bind('.query');--%>
                       <%--q.epcustomername=row.epcustomername--%>
                       <%--q.unitName=row.unitname;--%>
                       <%--q.proType=row.protype;--%>
                       <%--q.unitId=row.unitid;--%>
                       <%--uglcw.ui.openTab('待收款单据', '${base}manager/toUnitRecPage?'+ $.map(q, function(v, k){--%>
                      <%--return k + '=' + (v);--%>
                       <%--}).join('&'));--%>
                    },
                    url: '${base}manager/queryYsUnitFlowPage',
                    criteria: '.query',
                    pageable: true,
                    ">
                <div data-field="bill_name"
                     uglcw-options="width:120">类型
                </div>
                <div data-field="bill_time"
                     uglcw-options="width:120">日期
                </div>
                <div data-field="bill_no"
                     uglcw-options="width:140">单号
                </div>
                <div data-field="unit_name" uglcw-options="width:160">往来单位</div>
                <div data-field="in_amt"
                     uglcw-options="width:120, format: '{0:n2}'">增加
                </div>
                <div data-field="out_amt"
                     uglcw-options="width:120, format: '{0:n2}'">减少
                </div>
                <div data-field="left_amt"
                     uglcw-options="width:120">结余
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //显示商品
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })
        uglcw.ui.get("#print").on("click",function(){
            var q = uglcw.ui.bind('.query');
            uglcw.ui.openTab(q.unitName+'_应收流水打印', '${base}manager/toYsUnitFlowList?'+ $.map(q, function(v, k){
                return k + '=' + (v);
            }).join('&'));
        })
        uglcw.ui.loaded()
    })

    function search() {
        uglcw.ui.get('#grid').reload();
    }

</script>
</body>
</html>
