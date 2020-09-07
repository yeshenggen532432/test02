<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp" %>
    <script>
        var path = '<%=basePath%>';
    </script>


    <link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/shop/mobile/css/pay.css">
    <script src="<%=basePath%>/resource/shop/pay/js/meta.js" type="text/javascript"></script>
    <script src="<%=basePath%>/resource/shop/pay/plugin/layer/layer.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/layer/need/layer.css" rel="stylesheet" type="text/css">

    <!---->
    <script src="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.min.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.css" rel="stylesheet" type="text/css">
    <title>订单提交1</title>
    <style type="text/css">
        #zje {
            color: #ED0012;
            font-size: 0.7rem;
            width: 80px;
        }
    </style>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<div id="wrapper">
    <div class="int_title"><span class="int_pic" onclick="onBack();"><img
            src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/></span>收银台
    </div>
    <span class="span_text fr">${token}</span>
    <div class="m_pwd topline" style="height: auto;">
        <div class="fill_order clearfix">
            <ul class="fill_box">
                <div class="order-bar-wrap" style="display: block;">


                    <div class="order-bar">
                        <span class="JS-pay-tip pay-tip">需支付:</span>
                        <span class="pay-total">
                        <strong class="JS-pay-total">${orderAmount}</strong>
                    </span>
                    </div>
                </div>
            </ul>
        </div>
    </div>
    <div class="JS-page-ct page-ct  position-change" style="height: 845px;">
        <div class="JS-page-scorller"
             style="transition-timing-function: cubic-bezier(0.1, 0.57, 0.1, 1); transition-duration: 0ms; transform: translate(0px, 0px) translateZ(0px); display: block;">

            <ul class="list pay-list jd-pay-list" style="display: block;">


            </ul>
            <h2 href="javascript:void(0);" class="p-title-bar p-other-pay-title-bar" style="display: block;">支付方式</h2>
            <ul class="list pay-list p-other-pay-list" style="display: block;">

                <c:if test="${isXxzf eq 1}">
                    <%--union-pay--%>
                <li class="list-item list-link-item pay-list-item other-pay-list-item other-pay-list-item  otherPayment"
                    style="display: list-item;">
                    <a href="javascript:void(0);" class="pay-list-link">
                        <span class="pay-icon"></span>
                        <span class="title-main">线下支付</span>
                        <span class="title-vice"></span>
                    </a>
                    /li>
                    </c:if>
                    <%--membercard-pay--%>
                <li class="list-item list-link-item pay-list-item other-pay-list-item other-pay-list-item union-pay otherPayment"
                    style="display: list-item;">
                    <a href="javascript:void(0);" class="pay-list-link">
                        <span class="pay-icon"></span>
                        <span class="title-main">使用余额支付</span>
                        <span class="title-vice" id="cardRest">剩余金额：</span>
                    </a>
                </li>
                <li class="list-item list-link-item pay-list-item other-pay-list-item weixin-pay  otherPayment selected"
                    style="display: list-item;">
                    <a href="javascript:void(0);" class="pay-list-link">
                        <span class="pay-icon"></span>
                        <span class="title-main">微信支付</span>
                        <span class="title-vice">仅安装微信6.0.2 及以上版本客户端使用</span>
                    </a>
                </li>
            </ul>
            <div class="PAY_SCROLL_LEFT"></div>
        </div>
    </div>
    <a href="javascript:checkCanPay();" class="btn pay-next confirm-pay" style="display: inline;"
       id="btnSubmit">微信支付${orderAmount}元</a>
</div>
<input type="hidden" id="orderId" value="${orderId}"/>
<input type="hidden" id="totalfee" value="${orderAmount}"/>
<input type="hidden" id="mobile" value="${mobile}"/>
<input type="hidden" id="orderNo" value="${orderNo}"/>
<input type="hidden" id="basePath1" value="<%=basePath%>"/>
<input type="hidden" id="pswMk" value="${pswMk}"/>
<input type="hidden" id="cardAmt" value="${cardAmt}"/>
<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
<script type="text/javascript">

    //返回上个界面
    function onBack() {
        if (document.referrer == null || document.referrer.indexOf("/web/shopBforderMobile/toFillOrder") >= 0) {
            toPage("/web/mainWeb/toShoppingCart?token=${token}");
            return;
        }
        history.back();
    }

    /*$(document).ready(function(){
        $.wechatShare();//分享
     })*/

    //获取默认地址
    function getMemberInfo() {
        var mobile = $("#mobile").val();
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/shopRechargeMobile/getCardInfoByMobile",
            data: "token=${token}&mobile=" + mobile, //提交的数据
            success: function (json) {
                if (json.state) {
                    json = json.obj;
                    var cardAmt = json.cardAmt;
                    var freeCost = json.freeCost;
                    var pswMk = json.pswMk;
                    $("#pswMk").val(pswMk);
                    //$("#cardRest").text("剩余金额：" + cardAmt + "元");
                    var freeCostStr = "";
                    if (freeCost)
                        freeCostStr = "(赠送" + freeCost + "元)";
                    $("#cardRest").text("余额：" + cardAmt + "元" + freeCostStr);
                    $("#cardAmt").val(parseFloat(cardAmt || 0) + parseFloat(freeCost || 0));
                } else {
                    mui.alert(json.msg);
                }
            }
        });
    }

    getMemberInfo();

    function checkCanPay() {
        var orderId = $("#orderId").val();
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/shopBforderMobile/checkOrderIsPay",
            data: "token=${token}&id=" + orderId, //提交的数据
            success: function (json) {
                if (json.state) {
                    toSumbit();

                } else {
                    mui.alert(json.msg);
                }
            }
        });
    }

    function toSumbit() {
        var payType = getPayType();
        if (payType == 0) {
            $.ajax({
                type: "POST",                  //提交方式
                dataType: "json",              //预期服务器返回的数据类型
                url: "<%=basePath%>/web/shopBforderMobile/applyOffline?id=" + $("#orderId").val(),
                data: "id=" + orderId, //提交的数据
                success: function (json) {
                    if (json.state) {
                        toPage("<%=basePath%>/web/shopBforderMobile/toOrderSuccess?id=" + $("#orderId").val());
                    } else {
                        mui.alert(json.message);
                    }
                }
            });
        } else if (payType == 1) {
            //showBox();
            var orderId = $("#orderId").val();
            var totalfee = $("#totalfee").val();
            var mobile = $("#mobile").val();
            //alert(cardAmt);
            var cardAmt = $("#cardAmt").val();
            if (parseFloat(cardAmt) < parseFloat(totalfee)) {
                mui.alert("余额不足");
                return;
            }
            var pswMk = $("#pswMk").val();
            //alert(pswMk);
            if (pswMk == 1)
                toPage("<%=basePath%>/web/shopBforderMobile/toCardComsume?token=${token}&id=" + orderId + "&cardAmt=" + cardAmt);
            else {
                submitCardPay("");
            }
        } else if (payType == 2) {
            submitWxPay();
        }
    }

    function submitWxPay() {
        var orderNo = $("#orderNo").val();
        var totalfee = $("#totalfee").val();
        var mobile = $("#mobile").val();
        var orderId = $("#orderId").val();
        toPage("<%=basePath %>/web/userAuth?token=${token}&orderNo=" + orderNo + "&totalFee=" + totalfee + "&mobile=" + mobile + "&orderId=" + orderId);

    }

    function submitCardPay(psw) {
        var orderId = $("#orderId").val();
        var totalfee = $("#totalfee").val();
        var mobile = $("#mobile").val();
        var orderNo = $("#orderNo").val();
        if (!mobile) {
            mui.alert("手机号不能为空");
            return;
        }
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/cardConsumeProc?token=${token}",
            data: {"orderId": orderId, "totalFee": totalfee,"psw": psw, "orderNo": orderNo}, //提交的数据
            success: function (result) {
                if (result.state) {
                    $("#submit").removeAttr("href");
                    mui.alert("支付成功");
                    toPage("<%=basePath%>/web/shopBforderMobile/toPaySuccess?orderId=" + orderId + "&orderNo=" + orderNo + "&payAmt=" + totalfee);
                }
            },
            error: function () {
                mui.alert("异常！");
            }
        });
    }

    $(".list-item").click(function () {
        //alert( $(this).text());
        var items = $('ul.pay-list').find(".list-item");
        for (var i = 0; i < items.length; i++) {
            if ($(items[i]).hasClass("selected")) $(items[i]).removeClass("selected");
        }
        //if($(this).hasClass("selected"))
        $(this).addClass("selected");
        var totalfee = $("#totalfee").val();

        if (getPayType() == 0) $("#btnSubmit").text("线下支付");
        if (getPayType() == 1) $("#btnSubmit").text("余额支付" + totalfee + "元");
        if (getPayType() == 2) $("#btnSubmit").text("微信支付" + totalfee + "元");

    });


    function getPayType() {
        var isXxzf = "${isXxzf}";
        var items = $('ul.pay-list').find(".list-item");
        for (var i = 0; i < items.length; i++) {
            if ($(items[i]).hasClass("selected")) {
                if ("1" === isXxzf) {
                    return i;
                } else {
                    return (i + 1);
                }
            }
        }
    }

    function showBox() {
        /**
         * init传入参数依次是：正确密码(传空时不对比输入是否正确),密码键盘背景，标题，副标题
         * */
        var rootPath = $("#basePath1").val() + "/resource/shop/pay/images/pwd_keyboard.png";
        alert(rootPath);

        PwdBox.init('123456', rootPath, '请输入支付密码', '安全支付环境，请放心使用！');
        /**
         *res格式：{status:'true或false',password:'用户输入的密码'}
         *
         */
        PwdBox.show(function (res) {
            if (res.status) {
                //重置输入
                var psw = res.password;
                //alert(res.password);
                //关闭并重置密码输入
                PwdBox.reset();
                submitCardPay(psw);
            } else {
                var psw = res.password;
                //alert(res.password);
                //关闭并重置密码输入
                PwdBox.reset();
                submitCardPay(psw);
            }
        });
    }
</script>


</body>


</html>
