<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
    <%--<title>收货地址</title>--%>
    <style>
        body{
            overflow-x:hidden;
            height: 100%;
            /*开启moblie网页快速滚动和回弹的效果*/
            -webkit-overflow-scrolling: touch;
            font-size: 12px;
            font-family: "微软雅黑";
            overflow-x: hidden;
            -webkit-text-size-adjust: none !important;
        }
        *{
            margin: 0;
            padding: 0;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
        }

        .my_info{
            width: 100%;
            height: 180px;
            max-height: 196px;
            min-height: 176px;
            position: relative;
            background-color: #3388FF;
        }
        .my_info img{
            width: 100%;
            height: 100%;
            position: relative;
        }
        .my_info .my_mian{
            position: absolute;
            left: 0px;
            bottom: 0px;
            right: 0px;
            top: 0px;
            margin: auto;
            width: 40%;
            height: 125px;
        }
        .my_info .my_mian P.my_pic{
            width: 55%;
            margin: 0 auto;
            border-radius: 50%;
        }

        .my_info .my_mian P.my_pic img{
            border-radius: 50%;
        }
        .my_info  span{
            width: 100%;
            display: inline-block;
            line-height: 22px;
            text-align: center;
            color: #fff;
        }
        .my_info  span.my_number{
            font-size: 16px;
            margin-top: 4px;
            vertical-align: center;
        }
        .my_info  span.my_amount{
            font-size: 14px;
            margin-top: 4px;
        }

        .mui-table-view-cell a{
            font-size: 13px;
            color: #696969;
        }

        .iconfont{
            font-size: 18px;
            color: #333333;
            margin-right: 5px;
        }

        /*==================tabbar======================*/
        #menu {
            width: 100%;
            height: 44px;
            position: fixed;
            left: 0px;
            bottom: 0px;
            background: #fff;
            box-shadow: 0 -3px 5px #ccc;
            z-index: 1000;
        }
        #menu ul {
            width: 100%;
            list-style: none;
            height: 44px;
        }
        #menu ul *{
            margin: 0;
            padding: 0;
        }
        #menu ul li {
            width: 25%;
            float: left;
        }
        #menu ul li a{
            display: block;
            width: 100%;
            color: #333;
            text-decoration: none;
        }
        #menu ul li a.red {
            color: #3388FF;
            -webkit-transition: .3s color;
            transition: .3s color;
        }
        #menu ul li a font.iconfont {
            font-size: 18px;
        }
        #menu ul li a span {
            display: block;
            line-height: 8px;
        }
        /*.icon-fukuanma{
            font-size: 24px;
            color: white;
            margin-left: 5px;
            vertical-align: center;
        }*/
    </style>
</head>
<!-- --------body开始----------- -->
<body>

<div class="mui-content">
    <div class="mui-page-content">
        <div class="mui-scroll-wrapper">
            <div class="mui-scroll">
                <div class="my_info">
                    <%--<img src="<%=basePath%>/resource/shop/mobile/images/my/bj.png" />--%>
                    <div class="my_mian">
                        <p class="my_pic">
                            <a href="javaScript:;">
                                <%--<img src="<%=basePath%>/resource/shop/mobile/images/my/my_03.png" />--%>
                                <img src="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg" />
                            </a>
                        </p>
                        <span class="my_number" onclick="javaScript:toPaymentCode();">${tel}
							<%--<i class="mui-icon iconfont icon-fukuanma"></i>--%>
						</span>
                        <span class="my_amount"></span>
                    </div>
                </div>
                <ul class="mui-table-view mui-table-view-chevron" style="margin-top: 10px">
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toPaymentCode();" class="mui-navigate-right"><span class="mui-icon iconfont icon-fukuanma"></span>出示付款码1</a>
                    </li>
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toPosMyTicket();" class="mui-navigate-right"><span class="mui-icon iconfont icon-icon--copy"></span>我的优惠券</a>
                    </li>
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toAddress();" class="mui-navigate-right"><span class="mui-icon iconfont icon-dizhi"></span>收货地址</a>
                    </li>
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toRecharge();" class="mui-navigate-right"><span class="mui-icon iconfont icon-chongzhi"></span>账户充值</a>
                    </li>
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toUpdatePayPwd();" class="mui-navigate-right"><span class="mui-icon iconfont icon-mima"></span>余额支付密码设置</a>
                    </li>
                    <li class="mui-table-view-cell">
                        <a href="javaScript:toRechargeList();" class="mui-navigate-right"><span class="mui-icon iconfont icon-chongzhijilu1"></span>充值记录</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

<%--<nav class="mui-bar mui-bar-tab">
	<a class="mui-tab-item" href="javaScript:toIndex();">
		<span class="mui-icon mui-icon-home"></span>
		<span class="mui-tab-label">首页</span>
	</a>
	<a class="mui-tab-item" href="javaScript:toFeilei();">
		<span class="mui-icon mui-icon-bars"></span>
		<span class="mui-tab-label">分类</span>
	</a>
	<a class="mui-tab-item" href="javaScript:toShopCart();">
		<span class="mui-icon mui-icon-chatboxes"></span>
		<span class="mui-tab-label">购物车</span>
	</a>
	<a class="mui-tab-item  mui-active" href="#">
		&lt;%&ndash;javaScript:toMy();&ndash;%&gt;
		<span class="mui-icon mui-icon-person"></span>
		<span class="mui-tab-label">我的</span>
	</a>
</nav>--%>

<div id="menu">
    <ul>

    </ul>
</div>

<script>
    mui.init();
    $(document).ready(function () {
        getCardInfo();//获取“卡信息”-‘余额’
        //$.wechatShare();//分享
    })

    /**
     * 获取“卡信息”-‘余额’
     */
    function getCardInfo(){
        var mobile = ${tel};
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/getCardInfoByMobile",
            data: "token=${token}&mobile=" + mobile, //提交的数据
            success: function (json) {
                if(json.state){
                    var cardAmt = json.cardAmt;
                    $(".my_amount").text("余额：" + cardAmt + "元");
                }
            }
        });
    }

    function toPaymentCode(){
        <%--window.location.href = '<%=basePath %>/web/shopRechargeMobile/toPaymentCode';--%>
        window.location.href = '<%=basePath %>/web/toPaymentCode?token=${token}';
    }
    function toPosMyTicket() {
        window.location.href = '<%=basePath %>/web/toPosMyTicket?token=${token}';
    }
    //
    function toMyOrder(){
        <%--window.location.href = '<%=basePath%>/web/shopBforderMobile/toMyOrder';--%>
        window.location.href = '<%=basePath%>/web/shopBforderMobile/toMyOrder?token=${token}';
    }
    function toAddress(){
        <%--window.location.href = '<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?type=1';--%>
        window.location.href = '<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?token=${token}&type=1';
    }
    function toRecharge(){
        <%--window.location.href = '<%=basePath %>/web/shopRechargeMobile/toRecharge';--%>
        window.location.href = '<%=basePath %>/web/shopRechargeMobile/toRecharge?token=${token}';
    }
    function toUpdatePayPwd(){
        <%--window.location.href = '<%=basePath %>/web/shopRechargeMobile/toUpdatePayPwd';--%>
        window.location.href = '<%=basePath %>/web/shopRechargeMobile/toUpdatePayPwd?token=${token}';
    }
    function toRechargeList(){
        <%--window.location.href = '<%=basePath %>/web/shopRechargeMobile/toRechargeList';--%>
        window.location.href = '<%=basePath %>/web/shopRechargeMobile/toRechargeList?token=${token}';
    }

</script>

</body>
</html>
