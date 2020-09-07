<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="mobile" uri="/WEB-INF/tlds/mobile.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + (request.getServerPort() != 80 ? ":" + request.getServerPort() : "") + request.getContextPath();
%>
<meta charset="UTF-8">
<meta name="Keywords" content="">
<meta name="Description" content="">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
<script>
var _basePath = '<%= basePath%>';
</script>
<c:set var="_ctx" value="${conf['static.domain']}"/>

<link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/css/index.css" rel="stylesheet">
<script src="<%=basePath%>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript"></script>
<script src="<%=basePath%>/resource/shop/mobile/js/tool.js?v=2020011901" type="text/javascript"></script>
<%--分享--%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
<script src="<%=basePath%>/resource/shop/mobile/js/wechat.share.js?v=2020011901" type="text/javascript"></script>

<link href="<%=basePath%>/resource/shop/mobile/css/swiper.min.css" rel="stylesheet">
<script src="<%=basePath%>/resource/shop/mobile/js/swiper.min.js" type="text/javascript"></script>

<link href="<%=basePath%>/resource/shop/mobile/css/mescroll.min.css" rel="stylesheet">
<script src="<%=basePath%>/resource/shop/mobile/js/mescroll.min.js" type="text/javascript"></script>

<link href="<%=basePath%>/resource/shop/mobile/css/mui.css" rel="stylesheet">
<script src="<%=basePath%>/resource/shop/mobile/js/mui.js" type="text/javascript"></script>

<link href="<%=basePath%>/resource/shop/mobile/css/icons-extra.css" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/css/iconfont.css?v=20190706" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/iconfont/iconfont.css?v=20190706" rel="stylesheet">

<script src="<%=basePath%>/resource/alloy-lever.js?v=1"></script>
<script>
    $(function () {
        /*手机端页面可以输出log*/
        AlloyLever.config({
            cdn: '//cdn.bootcss.com/vConsole/3.2.2/vconsole.min.js',  //vconsole的CDN地址
            entry: "body"         //请点击这个DOM元素6次召唤vConsole。//你可以通过AlloyLever.entry('#entry2')设置多个机关入口召唤神龙
        });
    });
</script>




