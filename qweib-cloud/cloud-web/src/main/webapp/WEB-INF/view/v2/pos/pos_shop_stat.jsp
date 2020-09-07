<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>各门店报表-营业汇总</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div class="layui-card header">
        <div class="layui-card-body">
            <ul class="uglcw-query form-horizontal" id="export">
                <li>
                    <input type="hidden" uglcw-model="shopNo" uglcw-role="textbox" value="${param.shopNo}">

                    <input uglcw-model="startTime" uglcw-role="datepicker" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="endTime" uglcw-role="datepicker" value="${edate}">
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
                    responsive:['.header',40],
                    id:'id',
                    url: 'manager/pos/queryShopStatList',
                    criteria: '.form-horizontal',
                    query: function(param){
                        param.endTime+=' 23:59:59';
                        return param;
                    },
                    }">

                <div data-field="shopName" uglcw-options="width:120">店铺名称</div>
                <div data-field="billQty" uglcw-options="width:120">结单数量</div>
                <div data-field="totalSale" uglcw-options="width:120,format: '{0:n2}'">总营业额</div>
                <div data-field="saleCash" uglcw-options="width:120,format: '{0:n2}'">营业现金</div>
                <div data-field="saleBank" uglcw-options="width:120,format: '{0:n2}'">银行卡</div>
                <div data-field="saleTicket" uglcw-options="width:80,format: '{0:n2}'">抵用券</div>
                <div data-field="saleCard" uglcw-options="width:80,format: '{0:n2}'">会员卡</div>
                <div data-field="saleWx"
                     uglcw-options="width:120,format: '{0:n2}'">微信支付
                </div>
                <div data-field="saleZfb" uglcw-options="width:120,format: '{0:n2}'">支付宝</div>
                <div data-field="cancelQty" uglcw-options="width:120">撤单单数</div>
                <div data-field="cancelAmt" uglcw-options="width:120,format: '{0:n2}'">撤单金额</div>
                <div data-field="returnQty" uglcw-options="width:120">退货单数</div>
                <div data-field="returnAmt" uglcw-options="width:120,format:'{0:n2}'">退货金额</div>
                <div data-field="newCards" uglcw-options="width:120">发卡数量</div>
                <div data-field="cardCost" uglcw-options="width:120,format:'{0:n2}'">工本费</div>
                <div data-field="inputAmt" uglcw-options="width:120,format:'{0:n2}'">充值金额</div>
                <div data-field="freeCost" uglcw-options="width:120,format:'{0:n2}'">赠送金额</div>
                <div data-field="inputCash" uglcw-options="width:120,format:'{0:n2}'">充值现金</div>
                <div data-field="inputBank" uglcw-options="width:120,format:'{0:n2}'">银行卡</div>
                <div data-field="inputWx" uglcw-options="width:120,format:'{0:n2}'">充值微信</div>
                <div data-field="inputZfb" uglcw-options="width:120,format: '{0:n2}'">充值支付宝</div>
                <div data-field="rtnCardQty" uglcw-options="width:120">退卡次数</div>
                <div data-field="rtnCardAmt" uglcw-options="width:120,format: '{0:n2}'">退卡金额</div>
                <div data-field="totalCash" uglcw-options="width:120,format: '{0:n2}'">现金汇总</div>
                <div data-field="totalBank" uglcw-options="width:120,format: '{0:n2}'">银行卡汇总</div>
                <div data-field="totalWx" uglcw-options="width:120,format: '{0:n2}'">微信汇总</div>
                <div data-field="totalZfb" uglcw-options="width:120,format:' {0:n2}'">支付宝汇总</div>
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
