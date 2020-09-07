<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>会员订单</title>
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
                    <c:set var="orderType" value="${order.orderType==null?1:order.orderType}"/>
                    <select uglcw-role="combobox" uglcw-model="orderType" placeholder="订单类型" uglcw-options="clearButton:false">
                        <option value="">--全部订单--</option>
                        <c:forEach items="${orderTypeMap}" var="typeMap">
                            <option value="${typeMap.key}" <c:if test="${order.orderType==typeMap.key}">selected</c:if>>${typeMap.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <input type="hidden" uglcw-model="promotionId" value="${order.promotionId}" uglcw-role="textbox">
                    <%--<input type="hidden" uglcw-model="tourId" value="${order.tourId}" uglcw-role="textbox">
                    <input type="hidden" uglcw-model="headTourId" value="${order.headTourId}" uglcw-role="textbox">--%>
                    <input type="hidden" uglcw-model="isPay" value="${order.isPay}" uglcw-role="textbox">
                    <input uglcw-model="orderNo" uglcw-role="textbox" placeholder="订单号">
                </li>
                <li>
                    <input uglcw-model="khNm" uglcw-role="textbox" placeholder="客户名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="shopMemberName" placeholder="会员名称">
                </li>
                <li>
                    <input uglcw-role="textbox" uglcw-model="address" placeholder="地址">
                </li>
                <c:if test="${order.isPay !=10}">
                    <li>
                        <select uglcw-role="combobox" uglcw-model="orderZt" placeholder="审核状态">
                            <option value="正常订单">正常订单</option>
                            <c:forEach items="${orderZtMap}" var="ztMap">
                                <option value="${ztMap.key}">${ztMap.value}</option>
                            </c:forEach>
                            <option value="">--订单状态--</option>
                        </select>
                    </li>
                </c:if>
                <li>
                    <select uglcw-role="combobox" uglcw-model="payType" placeholder="付款类型">
                        <option value="">--付款类型--</option>
                        <c:forEach items="${orderPayTypeMap}" var="payTypeMap">
                            <option value="${payTypeMap.key}"
                                    <c:if test="${order.payType eq payTypeMap.key}">selected</c:if> >${payTypeMap.value}</option>
                        </c:forEach>
                    </select>
                </li>
                <li>
                    <select uglcw-role="combobox" uglcw-model="distributionMode" placeholder="配送方式">
                        <option value="0">--配送方式--</option>
                        <option value="1">快递</option>
                        <option value="2">自提</option>


                    </select>
                </li>
                <li>
                    <tag:select2 name="stkId" id="stkId" tableName="stk_storage"
                                 whereBlock="status=1 or status is null"
                                 headerKey="" headerValue="--选择仓库--"
                                 displayKey="id" displayValue="stk_name"/>
                </li>

                <c:if test="${order.orderType==9}"><%--如果是餐饮订单时增加时分秒查询--%>
                    <li>
                        <input uglcw-model="createDate" uglcw-role="datetimepicker" value="${startCreateDate}">
                    </li>
                </c:if>
                <c:if test="${order.orderType!=9}"><%--如果是餐饮订单时增加时分秒查询--%>
                    <li>
                        <input uglcw-model="sdate" uglcw-role="datepicker" value="${param.sdate}">
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
                    toolbar: kendo.template($('#toolbar').html()),
                    id:'id',
                    checkbox: true,
                    url: '${base}manager/shopBforder/page',
                    criteria: '.form-horizontal',
                    pageable: true
                    ">
                <div data-field="status"
                     uglcw-options="width:100,align:'center',template: uglcw.util.template($('#status').html())">订单状态
                </div>
                <jsp:include page="/WEB-INF/view/v2/include/order_detail_include.jsp"/>
            </div>
        </div>
    </div>
</div>
<%--toolbar--%>
<script type="text/x-uglcw-template" id="toolbar">
    <c:if test="${order.isPay !=10}">
        <a role="button" href="javascript:toZf();" class="k-button k-button-icontext" title="未支付和线下支付订单才能作废">
            <span class="k-icon k-i-cancel"></span>作废
        </a>
        <%--<a role="button" href="javascript:toDel();" class="k-button k-button-icontext k-grid-add-other">
            <span class="k-icon k-i-delete"></span>删除
        </a>--%>

        <c:if test="${order.isPay !=0 && permission:checkUserFieldPdm('shop.order.refund')}">
            <a role="button" href="javascript:toTk();" class="k-button k-button-icontext k-grid-add-other">
                <span class="k-icon k-i-cancel"></span>退款并作废
            </a>
        </c:if>
    </c:if>
    <c:if test="${order.isPay == 0 && order.payType==3}">
        <a role="button" href="javascript:verifyWechatPayment();" class="k-button k-button-icontext k-grid-add-other">
            <span class="k-icon k-i-cancel"></span>同步微信验证是否支付成功
        </a>
    </c:if>
</script>
<%--状态--%>
<script id="status" type="text/x-uglcw-template">
    <c:forEach items="${orderStateMap}" var="stateMap">
        #if (data.status ==${stateMap.key}) {#
        ${stateMap.value}
        #}#
    </c:forEach>
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
            ;
        })

        uglcw.ui.get('#reset').on('click', function () {
            uglcw.ui.clear('.form-horizontal');
        })

        uglcw.ui.loaded()

        <c:if test="${order.orderType==9}">
        $('#showProducts').trigger('click');
        </c:if>
    })

    <c:if test="${permission:checkUserFieldPdm('shop.order.refund')}">
    //退款作废订单
    function toTk() {
        var id = "";
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (!rows || rows.length == 0) {
            uglcw.ui.toast("请勾选你要操作的行！");
            return false;
        }
        if (rows.length > 1) {
            uglcw.ui.toast("请勿多选订单！");
            return false;
        }
        if (rows[0].isPay != 1) {
            uglcw.ui.toast("该订单未付款，不能退款");
            return;
        }
        if (rows[0].orderZt == '已作废') {
            uglcw.ui.toast("该订单已作废，不能再退款");
            return;
        }
        if (rows[0].payType == 0 || rows[0].payType == 1) {
            uglcw.ui.toast("非线上支付订单，不能申请退款并作废");
            return;
        }
        id = rows[0].id;
        if (id) {
            uglcw.ui.confirm("确认想要退款作废记录吗？", function () {
                uglcw.ui.confirm("资金将原路退回用户？", function () {
                    $.ajax({
                        url: "/manager/shopBforder/doRefund",
                        data: "orderId=" + id,
                        type: "post",
                        success: function (data) {
                            if (data.state) {
                                uglcw.ui.success(data.message);
                                uglcw.ui.get('#grid').reload();
                            } else {
                                uglcw.ui.error(data.message);
                            }
                        }
                    });
                });
            });
        } else {
            uglcw.ui.toast("请选择要退款作废的数据");
        }
    }

    </c:if>

    //同步微信验证是否支付成功
    function verifyWechatPayment() {
        var id = "";
        var rows = uglcw.ui.get('#grid').selectedRow();
        if (!rows || rows.length == 0) {
            uglcw.ui.toast("请勾选你要操作的行！");
            return false;
        }
        if (rows.length > 1) {
            uglcw.ui.toast("请勿多选订单！");
            return false;
        }
        if (rows[0].isPay == 1) {
            uglcw.ui.toast("该订单已付款，不能继续操作");
            return;
        }
        if (rows[0].orderZt == '已作废') {
            uglcw.ui.toast("该订单已作废，不能再退款");
            return;
        }
        if (rows[0].payType != 3) {
            uglcw.ui.toast("非微信支付订单，不能继续操作");
            return;
        }
        var orderNo = rows[0].orderNo;
        console.log(orderNo);
        if (orderNo) {
            uglcw.ui.confirm("验证微信是否收到货款,请耐心等待返回结果!", function () {
                $.ajax({
                    url: "/manager/shopBforder/doVerifyWechatPayment",
                    data: "orderNo=" + orderNo,
                    type: "post",
                    success: function (data) {
                        if (data.state) {
                            uglcw.ui.success(data.message);
                            uglcw.ui.get('#grid').reload();
                        } else {
                            uglcw.ui.error(data.message);
                        }
                    }
                });
            });
        } else {
            uglcw.ui.toast("请选择要作废的数据");
        }
    }
</script>
</body>
</html>
