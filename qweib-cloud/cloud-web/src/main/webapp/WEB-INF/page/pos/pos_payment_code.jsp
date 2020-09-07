<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
    <title></title>
    <style>
        body{
            background-color: #00a6fb;
        }
        #qrcode{
            width:100px;
            height:100px;
            margin:15px auto;
        }
        .mui-content{
            background-color: #00a6fb;
        }
        .box{
            margin: 10px;
            background-color: #FFF;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
        }
        .title{
            height: 40px;
            padding: 0 10px;
            text-align: left;
            background-color: #FEFEFE;
            -webkit-border-radius: 5px 5px 0 0;
            -moz-border-radius: 5px 5px 0 0;
            border-radius: 5px 5px 0 0;
        }
        .title h3{
            height: 40px;
            line-height: 40px;
            font-size: 16px;
            color: #00a6fb;
        }
        .content a{
            display: block;
            margin-top: 10px;
            height: 25px;
            line-height: 25px;
            font-size: 14px;
            color: #333333;
        }
        .footer{
            height: 40px;
            padding: 0 10px;
            text-align: left;
            background-color: #FEFEFE;
            -webkit-border-radius: 0 0 5px 5px;
            -moz-border-radius: 0 0 5px 5px;
            border-radius: 0 0 5px 5px;
        }
        .footer p{
            line-height: 40px;
            font-size: 14px;
            color: #999999;
        }

    </style>
</head>
<!-- --------head结束----------- -->

<!-- --------body开始----------- -->
<body>
<div>
    <header class="mui-bar mui-bar-nav">
        <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
        <h1 class="mui-title">付款码</h1>
    </header>

    <div class="mui-content mui-text-center">
        <div class="box">
            <div class="title">
                <h3>向商家付款</h3>
            </div>
            <div class="content">
                <a href="javaScript:showPaymentCode();">点击可查看付款码数字</a>
                <img id="imgcode" />
                <div id="qrcode"/></div>
        </div>
        <div class="footer">
            <p class="amount">余额：0元</p>
        </div>
    </div>

</div>
</div>
</body>

<script>
    mui.init();
    //付款码
    var paymentCode = "${paymentCode}";

    $(document).ready(function () {
        //$.wechatShare();//分享
        setCode(paymentCode);
        getCardInfo();
    })

    /**
     * 设置条形码和二维码
     */
    function setCode(code){
        JsBarcode("#imgcode", code, {
            //format: "CODE39",//选择要使用的条形码类型
            // width:3,//设置条之间的宽度
            height:70,//高度
            displayValue:false,//是否在条形码下方显示文字
            //text:"456",//覆盖显示的文本
            //fontOptions:"bold italic",//使文字加粗体或变斜体
            //font:"fantasy",//设置文本的字体
            // textAlign:"left",//设置文本的水平对齐方式
            // textPosition:"top",//设置文本的垂直位置
            // textMargin:5,//设置条形码和文本之间的间距
            // fontSize:15,//设置文本的大小
            // background:"#eee",//设置条形码的背景
            //lineColor:"#2196f3",//设置条和文本的颜色。
            margin:0//设置条形码周围的空白边距
        });
        //$("#imgcode").JsBarcode("I'm huangenai!");
        //JsBarcode("#imgcode", "20170715152058515");//or $("#imgcode").JsBarcode("I'm huangenai!");

        var qrcode = new QRCode(document.getElementById("qrcode"), {
            width: 100,
            height: 100,
            correctLevel: 3
        });
        qrcode.makeCode(code);
    }

    /**
     * 显示付款码
     */
    function showPaymentCode() {
        //付款码数字仅用于支付时向收银员展示，请勿泄露以防诈骗
        mui.alert(""+paymentCode);
    }

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
                    $(".amount").text("余额：" + cardAmt + "元");
                }else{
                    //alert(json.msg);
                }
            }
        });
    }

</script>


</html>
