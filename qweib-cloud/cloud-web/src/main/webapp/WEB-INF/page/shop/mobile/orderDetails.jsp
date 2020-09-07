<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>收货地址</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <style type="text/css">
        .mui-media {
            font-size: 14px;
        }

        .mui-table-view .mui-media-object {
            max-width: initial;
            width: 90px;
            height: 70px;
        }

        .meta-info {
            position: absolute;
            left: 115px;
            right: 15px;
            top: 40px;
            color: #8f8f94;
        }

        .meta-info .ware-gg,
        .meta-info .ware-num {
            display: inline-block;
        }

        .meta-info .ware-gg {
            width: 70%;
            font-size: 12px;
            color: #8f8f94;
        }

        .meta-info .ware-num {
            float: right;
            width: 30%;
            text-align: right;
            font-size: 12px;
            color: #8f8f94;
        }

        .mui-table-view:before,
        .mui-table-view:after {
            height: 0;
        }

        .mui-content > .mui-table-view:first-child {
            margin-top: 1px;
        }

        .ware-dj {
            position: absolute;
            left: 115px;
            right: 15px;
            bottom: 8px;
            color: red;
            font-size: 14px;
        }

        .mui-pull-right, .mui-pull-left {
            font-size: 14px;
            color: #666666;
        }

        .mui-pull-right {
            font-size: 14px;
            color: #333333;
        }

        .order-remo {
            font-size: 12px;
            color: red;
            margin: 10px;
        }

        .my-h4 {
            font-size: 16px;
            color: #333333;
            font-weight: 500;
        }


    </style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">订单详情</h1>
</header>


<div class="mui-content ">
    <form action="" name="savefrm" id="savefrm" method="post">

        <ul class="mui-table-view" style="margin-bottom: 5px">
            <li class="mui-table-view-cell">
                <h4 id="shr-tel" class="my-h4"></h4>
                <p id="address" class="mui-ellipsis"></p>
            </li>
        </ul>

        <ul class="mui-table-view">
            <li class="mui-table-view-cell" style="margin-bottom: 1px">
                <span class="mui-pull-left" id="order-no"></span>
                <span class="mui-pull-right" id="order-state"></span>
            </li>
        </ul>

        <ul id="wareList" class="mui-table-view">
            <%--<li class="mui-table-view-cell mui-media" >
                <img class="mui-media-object mui-pull-left" src="item.cover">
                <div class="mui-media-body">
                    <h4 class="mui-ellipsis" >青岛啤酒</h4>
                </div>
                <div class="meta-info">
                    <p class="ware-gg">规格：500ml*12</p>
                    <p  class="ware-num">*77</p>
                </div>
                <p class="ware-dj">$999</p>
            </li>--%>
        </ul>

        <ul class="mui-table-view" style="margin-top: 10px">
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">商品总价</span>
                <span class="mui-pull-right" id="zje"></span>
            </li>
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">促销总额</span>
                <span class="mui-pull-right" id="promotionCost"></span>
            </li>
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">商品净总价</span>
                <span class="mui-pull-right" id="cjje"></span>
            </li>
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">运费</span>
                <span class="mui-pull-right" id="freight"></span>
            </li>
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">快递</span>
                <span class="mui-pull-right" id="transportNameLook"></span>
                <span class="mui-pull-right" id="transportCode" disabled></span>
                <span class="mui-pull-right" id="transportName"></span>
            </li>
            <li class="mui-table-view-cell">
                <span class="mui-pull-left">送货时间</span>
                <span class="mui-pull-right" id="shTime"></span>
            </li>
            <span id="otherHtml">

            </span>
            <li class="mui-table-view-cell">
                <span class="mui-pull-right" id="orderAmount"></span>
            </li>
        </ul>

        <ul class="mui-table-view">
            <div class="order-remo"></div>
        </ul>

    </form>
</div>

<script>
    mui.init();
    $(document).ready(function () {
        //$.wechatShare();//分享
        getOrderInfo();
    })
    var orderStateMap = {0: "已取消", 1: "待支付", 2: "待发货", 3: "待收货", 4: "已完成"};

    //获取订单信息
    function getOrderInfo() {
        $.ajax({
            url: "<%=basePath%>/web/shopBforderMobile/queryShopBforderDetail",
            data: "token=${token}&orderId=${id}",
            type: "POST",
            success: function (result) {
                if (result.state) {
                    var str = "";
                    var order = result.obj;
                    var detailList = order.list;
                    if (detailList != null && detailList != undefined && detailList.length > 0) {
                        for (var i = 0; i < detailList.length; i++) {
                            var sysBforderPicList = detailList[i].warePicList;
                            str += "<li class='mui-table-view-cell mui-media' onclick='detail(" + detailList[i].wareId + ");' >";
                            if (sysBforderPicList != null && sysBforderPicList != undefined && sysBforderPicList.length > 0) {
                                var sourcePath = "<%=basePath%>/upload/" + sysBforderPicList[0].picMini;
                                for (var k = 0; k < sysBforderPicList.length; k++) {
                                    //1:为主图
                                    if (sysBforderPicList[k].type == '1') {
                                        sourcePath = "<%=basePath%>/upload/" + sysBforderPicList[k].picMini;
                                        break;
                                    }
                                }
                                str += "<img class='mui-media-object mui-pull-left' src='" + sourcePath + "'>";
                            } else {
                                //暂无图片
                                str += "<img class='mui-media-object mui-pull-left' src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' />";
                            }
                            //str += "<img class='mui-media-object mui-pull-left' src=\"item.cover\">";
                            str += "<div class='mui-media-body'>";
                            str += "<h4 class='my-h4 mui-ellipsis' >" + detailList[i].detailWareNm + "</h4>";
                            str += "</div>";
                            str += "<div class='meta-info'>";
                            str += "<p class='ware-gg'>规格：" + detailList[i].detailWareGg + "&nbsp;" + detailList[i].wareDw + "</p>";
                            str += "<p  class='ware-num'>X" + detailList[i].wareNum + "</p>";
                            str += "</div>";
                            var piceStr = detailList[i].wareDj;
                            if (detailList[i].wareDjOriginal && detailList[i].wareDjOriginal != detailList[i].wareDj) {
                                piceStr = "<del style='font-size: 13px;'>" + detailList[i].wareDjOriginal + "</del>&nbsp;" + detailList[i].wareDj;
                            }
                            str += "<p class='ware-dj'>￥" + piceStr + "</p>";
                            str += "</li>";
                        }
                    }
                    $("#wareList").html(str);
                    $("#zje").html("￥" + order.zje);
                    var promotionCost = order.promotionCost;
                    if (!promotionCost) promotionCost = "0";
                    $("#promotionCost").html("-￥" + promotionCost);
                    var freight = order.freight;
                    if (!freight)
                        freight = "0";
                    $("#freight").html("+￥" + freight);
                    $("#transportName").html(order.transportName ? order.transportName + " : " : '');
                    if (order.transportCode) {
                        $("#transportCode").html('<a href="tel:' + order.transportCode + '">' + order.transportCode + '</a>');
                        $("#transportNameLook").html('<a href="https://m.kuaidi100.com/result.jsp?nu=' + order.transportCode + '">&nbsp;&nbsp;&nbsp;在线查询</a>');
                    }
                    $("#shTime").html(order.shTime);

                    if (order.distributionMode) {
                        var otherHtml = makeOtherHtml('配送方式', order.distributionMode == 2 ?   '自提':'邮寄');
                        if (order.distributionMode == 2) {
                            otherHtml += makeOtherHtml('提货人', order.takeName);
                            otherHtml += makeOtherHtml('提货电话', order.takeTel);
                        }
                        $("#otherHtml").html(otherHtml);
                    }

                    $("#cjje").html("￥" + order.cjje);
                    var orderAmountStr = "共" + order.list.length + "种商品，实付款 ￥" + order.orderAmount;
                    if (order.status == 1)
                        orderAmountStr += '<br/><div style="text-align:right;"><button type="button" class="mui-btn mui-btn-primary" onclick="javascript:toPay(' + order.id + ');">确认支付</button></div>';
                    $("#orderAmount").html(orderAmountStr);
                    if (order.remo) {
                        $(".order-remo").html("备注:" + order.remo);
                    }
                    if (order.cancelRemo)
                        $(".order-remo").append("<br/>取消原因:" + order.cancelRemo);

                    $("#shr-tel").text(order.shr + "  " + order.tel);
                    $("#address").html(order.address);
                    $("#order-no").text("订单号：" + order.orderNo);
                    $("#order-state").text(orderStateMap[order.status]);
                }

            },
            error: function (result) {
                mui.toast("异常");
            }
        });
    }

    var otherHtml = ' <li class="mui-table-view-cell"><span class="mui-pull-left">{{name}}</span><span class="mui-pull-right">{{value}}</span></li>'

    function makeOtherHtml(name, value) {
        return otherHtml.replace('{{name}}', name).replace('{{value}}', value);
    }

    //支付
    function toPay(orderId) {
        toPage("<%=basePath%>/web/shopBforderMobile/toOrderPay?token=${token}&id=" + orderId);
    }

    function detail(id) {
        toPage("<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId=" + id);
    }
</script>

</body>
</html>
