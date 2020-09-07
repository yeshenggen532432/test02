<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>餐饮会员订单</title>
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
                    <input type="hidden" uglcw-model="orderType" value="9" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="promotionId" value="${order.promotionId}" uglcw-role="textbox">
                    <%--<input type="hidden" uglcw-model="tourId" value="${order.tourId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="headTourId" value="${order.headTourId}" uglcw-role="textbox">--%>
                    <input type="hidden" uglcw-model="isPay" value="${order.isPay}" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="shopMemberName" placeholder="会员名称">
                </li>
                <c:if test="${order.isPay !=10}">
                    <li>
                        <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="订单状态">
                            <option value="正常订单">正常订单</option>
                            <c:forEach items="${orderZtMap}" var="ztMap">
                                <option value="${ztMap.key}">${ztMap.value}</option>
                            </c:forEach>
                            <option value="">--订单状态--</option>
                        </select>
                    </li>
                </c:if>
               <%-- <li>
                    <select uglcw-role="combobox" uglcw-model="payType" placeholder="付款类型">
                        <option value="">--付款类型--</option>
                        <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
                            <option value="${payTypeMap.key}"
                                    <c:if test="${order.payType eq payTypeMap.key}">selected</c:if> >${payTypeMap.value}</option>
                        </c:forEach>
                    </select>
                </li>--%>

                <c:if test="${order.orderType==9}"><%--如果是餐饮订单时增加时分秒查询--%>
                    <li>
                        <input uglcw-model="createDate" uglcw-role="datetimepicker" value="${startCreateDate}">
                    </li>
                </c:if>
                <c:if test="${order.orderType!=9}"><%--如果是餐饮订单时增加时分秒查询--%>
                    <li>
                        <input uglcw-model="sdate" uglcw-role="datepicker" value="${sdate}">
                    </li>
                </c:if>
                <li>
                    <input uglcw-model="edate" uglcw-role="datepicker" value="${edate}">
                </li>
                <li>
                    <button id="search" uglcw-role="button" class="k-button k-info">搜索</button>
                    <button id="reset" class="k-button" uglcw-role="button">重置</button>
                </li>
                <li>
                    <input type="checkbox" uglcw-role="checkbox" id="showProducts">
                    <label style="margin-top: 10px;" class="k-checkbox-label" for="showProducts">显示商品</label>
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
                    <%--checkbox: true,--%>
                    url: '${base}manager/shopBforder/page',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">

                <div data-field="address" uglcw-options="width:100,align:'center'">桌号</div>
                <div data-field="orderNo" uglcw-options="
														  width:160,
														  align:'center',
														  template: function(dataItem){
														   return kendo.template($('#orderNo').html())(dataItem);
														  },
                        ">订单号
                </div>
                <%-- <div data-field="status"
                      uglcw-options="width:100,align:'center',template: uglcw.util.template($('#status').html())">状态
                 </div>--%>
                <%--<div data-field="orderZt"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#orderZt').html())">订单状态
                </div>--%>
                <div data-field="shopMemberName" uglcw-options="width:100,align:'center'">下单员</div>
                <div data-field="isPay"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#isPay').html())">付款状态
                </div>
                <%-- <div data-field="payType"
                      uglcw-options="width:100,align:'center',template: uglcw.util.template($('#payType').html())">付款类型
                 </div>--%>
                <%--<div data-field="payTime" uglcw-options="width:100,align:'center'">付款时间</div>--%>

                <div data-field="odtime" uglcw-options="width:100,align:'center'">下单时间
                </div>
                <div data-field="count" uglcw-options="width:700,hidden: true,template: function(data){
                            return kendo.template($('#product-list').html())(data.list);
                         }">商品信息
                </div>
                <%-- <div data-field="zje" uglcw-options="width:100,align:'center'">商品总价</div>
                 <div data-field="promotionCost" uglcw-options="width:100,align:'center'">促销</div>
                 <div data-field="couponCost" uglcw-options="width:100,align:'center'">优惠</div>
                 <div data-field="freight" uglcw-options="width:100,align:'center'">运费</div>--%>
                <div data-field="orderAmount" uglcw-options="width:100,align:'center'">订单应付</div>
                <div data-field="remo" uglcw-options="width:100,align:'center'">备注</div>
               <%-- <div data-field="opt" uglcw-options="width:300,template: uglcw.util.template($('#opt-tpl').html())">操作</div>--%>
            </div>
        </div>
    </div>
</div>

<%--状态--%>
<script id="status" type="text/x-uglcw-template">
    <c:forEach items="${orderStateMap}" var="stateMap">
        #if (data.status ==${stateMap.key}) {#
        ${stateMap.value}
        #}#
    </c:forEach>
</script>

<script type="text/x-uglcw-template" id="opt-tpl">
    <button class="k-button k-info"
            onclick="alert('开发中....');">
        发厨房
    </button>
    <button class="k-button k-info"
            onclick="alert('开发中....');">
        打印
    </button>
    #if (!data.isPay){#
    <button class="k-button k-info"
            onclick="alert('开发中....');">买单
    </button>
    #}#
 <%--   #if (data.doStatus!=1){#
    <button class="k-button k-info"
            onclick="showConfirmPay(#=data.doId#,0)">买单
    </button>
    #}#--%>
    <%--<button class="k-button k-info"
            onclick="payorderquery('#=data.doOrderNo#')">
        查询支付结果
    </button>--%>
</script>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<%@include file="/WEB-INF/view/v2/include/shop-bforder.jsp" %>

<script>
    $(function () {
        uglcw.ui.init();

        //显示商品
        uglcw.ui.get('#showProducts').on('change', function () {
            var checked = uglcw.ui.get('#showProducts').value();
            var grid = uglcw.ui.get('#grid').k();
            var index = grid.options.columns.findIndex(function (column) {
                return column.field == 'count';
            })
            if (checked) {
                grid.showColumn(index)
            } else {
                grid.hideColumn(index);
            }
        })

        uglcw.ui.get('#search').on('click', function () {
            uglcw.ui.get('#grid').reload();
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()

        <c:if test="${order.orderType==9}">
        $('#showProducts').trigger('click');
        </c:if>
    })

</script>
<%@include file="/WEB-INF/view/v2/shop/dining/order/detailPring_include.jsp" %>
</body>
</html>
