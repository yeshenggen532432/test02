<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
<!-- --------head开始----------- -->
<head>
    <script>
        var path = '<%=basePath%>';
    </script>
    <meta charset="UTF-8">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <!--  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">-->
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
    <link href="<%=basePath%>/resource/shop/mobile/css/index.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>/resource/shop/mobile/css/pay.css">
    <script src="<%=basePath%>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>

    <script src="<%=basePath%>/resource/shop/pay/js/meta.js" type="text/javascript"></script>
    <script src="<%=basePath%>/resource/shop/pay/plugin/layer/layer.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/layer/need/layer.css" rel="stylesheet" type="text/css">

    <!---->
    <script src="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.min.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.css" rel="stylesheet" type="text/css">
    <title>订单提交失败</title>
    <style type="text/css">
        #zje{
            color: #ED0012;
            font-size: 0.7rem;
            width:80px;
        }
    </style>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<div id="wrapper">
    <div class="int_title"><span class="int_pic" onclick="onBack();"><img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/></span>错误提醒</div>
    <span class="span_text fr">${token}</span>

    <div class="JS-page-ct page-ct  position-change" style="height: 845px;">
        <div class="JS-page-scorller" style="transition-timing-function: cubic-bezier(0.1, 0.57, 0.1, 1); transition-duration: 0ms; transform: translate(0px, 0px) translateZ(0px); display: block;">

            <ul class="list pay-list jd-pay-list" style="display: block;">


            </ul>
            <h2 href="javascript:void(0);" class="p-title-bar p-other-pay-title-bar" style="display: block;">${msg }</h2>

            <div class="PAY_SCROLL_LEFT"></div>
        </div>
    </div>
</div>
<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
<script type="text/javascript">

    //返回上个界面
    function onBack(){

        history.back();
    }

   /* $(document).ready(function(){
        $.wechatShare();//分享
    })*/

</script>


</body>


</html>
