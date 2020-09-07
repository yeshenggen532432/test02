<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>第三方支付设置</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask></tag:mask>
<div uglcw-role="tabs">
    <ul>
        <li>微信支付设置</li>
        <li>支付宝设置</li>
    </ul>
    <div title="微信支付设置">
        <iframe src="manager/pos/toPosWxSet?shopNo=${shopNo}"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
    </div>
    <div title="支付宝设置">
        <iframe src="manager/pos/toPosZfbSet?shopNo=${shopNo}" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init()
        var height = $(document).height() - $('ul.k-tabstrip-items').height() - 40;
        $('iframe').each(function (i, iframe) {
            $(iframe).attr('height', height + 'px');
        })
        uglcw.ui.loaded();
    })
</script>
</body>
</html>