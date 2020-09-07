<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>支付设置</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <%@include file="/WEB-INF/page/include/source.jsp"%>
    <script type="text/javascript" src="resource/loadDiv.js"></script>
</head>
<body>
<div class="easyui-tabs" style="width:100%;height:100%" fit="true">
    <div title="微信支付设置">
        <iframe src="manager/pos/toPosWxSet?shopNo=${shopNo}"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
    </div>
    <div title="支付宝设置">
        <iframe src="manager/pos/toPosZfbSet?shopNo=${shopNo}" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
    </div>


</div>
</body>
</html>
