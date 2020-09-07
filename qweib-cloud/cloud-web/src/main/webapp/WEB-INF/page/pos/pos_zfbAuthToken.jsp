<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
    <link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
    <link href="<%=basePath%>/resource/shop/mobile/css/index.css" rel="stylesheet">
    <title>授权结果</title>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<div id="wrapper" class="m_pwd">
    <div class="int_title">
        授权结果
    </div>

    <div class="pay_success topline">
        <div class="pay_s_box">
            <div class="pay_s_b_pic clearfix">
                <p class="pay_pic_text fl">
                    <span>返回结果 : <font id="msg">${msg}</font></span>
                    <span>appId : <font id="orderId">${appId}</font></span>
                    <span>app_auth_code :<font id="cjje">${app_auth_code}</font></span>
                    <span>app_auth_token : <font id="token1">${app_auth_token}</font></span>
                    <span>app_refresh_token : <font id="token2">${app_refresh_token}</font></span>
                </p>
            </div>
            <div class="pay_btn clearfix">

            </div>
        </div>
    </div>

    <script type="text/javascript"
            src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
    <script type="text/javascript"
            src="<%=basePath%>/resource/shop/mobile/js/pay_success.js"></script>

    <script type="text/javascript">
        //返回上个界面
        function onBack(){

        }

        $(document).ready(function(){
            //queryShopBforderMobile();
        })


    </script>
</body>
</html>
