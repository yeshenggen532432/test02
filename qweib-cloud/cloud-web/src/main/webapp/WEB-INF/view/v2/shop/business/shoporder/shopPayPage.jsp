<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员支付端口统计</title>
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
                    <input uglcw-model="sdate" uglcw-role="datepicker" id="sdate" value="${sdate}">
                </li>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
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
								checkbox: false,
								url: '${base}manager/shopBforder/shopPayPage',
								criteria: '.form-horizontal',
								pageable: true,
								dblclick: dblclick
                    	">
                <div data-field="payType" uglcw-options="width:100,template: uglcw.util.template($('#payType').html())">
                    付款类型
                </div>
                <div data-field="cjje" uglcw-options="width:100">成交金额</div>
                <div data-field="oper" uglcw-options="width:100,template: uglcw.util.template($('#oper').html())">操作</div>
            </div>
        </div>
    </div>
</div>
</div>
</div>

<%--付款状态--%>
<script id="payType" type="text/x-uglcw-template">
    <%--0.没有类型；1.线下支付；2.余额支付；3.微信支付；4.支付宝支付--%>
    # if(0===data.payType){ #
    没有类型
    # }else if(1===data.payType){ #
    线下支付
    # }else if(2===data.payType){ #
    余额支付
    # }else if(3===data.payType){ #
    微信支付
    # }else if(4===data.payType){#
    支付宝支付
    # } #
</script>

<%--明细操作--%>
<script id="oper" type="text/x-uglcw-template">
    <button onclick="javascript:showDetail(#= data.payType #);" class="k-button k-info">明细</button>
</script>

<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>

    $(function () {
        uglcw.ui.init();
        //搜索
        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
            ;
        })
        //重置
        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })
        uglcw.ui.loaded()
    })


    // ======================================================================================================
    //双击事件
    function dblclick(data) {
        showDetail(data.payType);
    }

    //明细
    function showDetail(payType) {
        var sdate = $("#sdate").val();
        var edate = $("#edate").val();
        var url = "${base}manager/shopBforder/toPage?sdate=" + sdate + "&edate=" + edate + "&payType=" + payType;
        uglcw.ui.openTab("会员订单",url);
    }

</script>
</body>
</html>
