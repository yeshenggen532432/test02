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

<%--mui框架--%>
<link href="<%=basePath%>/resource/shop/mobile/css/mui.css" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/css/icons-extra.css" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/css/iconfont.css?v=20190706" rel="stylesheet">
<link href="<%=basePath%>/resource/shop/mobile/iconfont/iconfont.css?v=20190706" rel="stylesheet">

<%--jquery--%>
<script src="<%=basePath%>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript"></script>
<script src="<%=basePath%>/resource/shop/mobile/js/tool.js?v=2020011901" type="text/javascript"></script>
<%--分享--%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
<script src="<%=basePath%>/resource/shop/mobile/js/wechat.share.js?v=2020011901" type="text/javascript"></script>

<script src="<%=basePath%>/resource/shop/mobile/js/mui.js" type="text/javascript"></script>
<%--<script src="${_ctx}/resource/shop/mobile/js/update.js" type="text/javascript"></script>--%>

<%--条形码--%>
<script src="<%=basePath%>/resource/shop/mobile/js/JsBarcode.all.min.js" type="text/javascript"></script>
<%--二维码--%>
<script src="<%=basePath%>/resource/shop/mobile/js/qrcode.js" type="text/javascript"></script>

<link href="<%=basePath%>/resource/shop/mobile/css/index.css?v=20190718" rel="stylesheet">

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
<link rel="stylesheet" type="text/css" href="<%=basePath%>/static/qwbui/layui/css/layui.mobile.css">
<script src="<%=basePath%>/static/qwbui/layui/layui.js"></script>
<script>
    $(function () {

    })

    function getToken(callback) {
        $.ajax({
            url: '<%=basePath%>/web/im/token?token=',
            type: 'get',
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    callback(response.data)
                }
            }
        })
    }


    function startIM() {
        getToken(function (token) {
            imLayer = layer.open({
                id: 'qwbim',
                shade: false,
                closable: false,
                resizable: true,
                type: 2,
                content: 'http://localhost:8082/qwbim?token=' + token + '#/client?targetId=285&title=企微宝客服',
                area: ['400px', '600px'],
                maxmin: true,
                title: '欢迎咨询企微宝客服'
            })
        });
    }
</script>