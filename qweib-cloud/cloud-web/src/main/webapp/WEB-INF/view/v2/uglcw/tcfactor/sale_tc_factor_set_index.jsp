<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>业务提成系数设置</title>
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
        <li>按客户类别设置</li>
        <li>按客户等级设置</li>
    </ul>
    <div title="按客户类别设置">
        <iframe src="${base}manager/customerTypeTcFactorList?_sticky=v2"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
    </div>
    <div title="按客户等级设置">
        <iframe src="${base}manager/customerLevelTcFactorwaretype?_sticky=v2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
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