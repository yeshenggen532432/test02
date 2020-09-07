<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
    <title>错误页面</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>

    <script src="<%=basePath%>/resource/shop/pay/js/meta.js" type="text/javascript"></script>
    <script src="<%=basePath%>/resource/shop/pay/plugin/layer/layer.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/layer/need/layer.css" rel="stylesheet" type="text/css">

    <!---->
    <script src="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.min.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.css" rel="stylesheet" type="text/css">
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

    /*$(document).ready(function(){
        $.wechatShare();//分享
    })*/

</script>


</body>


</html>
