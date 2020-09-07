<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <title>其他应付帐款初始化</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }
    </style>
</head>
<body>
<tag:mask/>
<div class="layui-fluid">
    <div uglcw-role="tabs">
        <ul>
            <li>借入供应商初始化</li>
            <li>借入客户初始化</li>
            <li>借入员工初始化</li>
        </ul>
        <div title="借入供应商初始化">
            <iframe src="${base}manager/finInitQtJrMain/toWljrPage?proType=0&bizType=CSHGYSJR" frameborder="0"
                    marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
        <div title="借入客户初始化">
            <iframe src="${base}manager/finInitQtJrMain/toWljrPage?proType=2&bizType=CSHKHJR" frameborder="0"
                    marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
        <div title="借入员工初始化">
            <iframe src="${base}manager/finInitQtJrMain/toWljrPage?proType=1&bizType=CSHYGJR" frameborder="0"
                    marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        uglcw.ui.init()
        var height = $(document).height() - $('ul.k-tabstrip-items').height() - 60;
        $('iframe').each(function (i, iframe) {
            $(iframe).attr('height', height + 'px');
        })
        uglcw.ui.loaded();
    })
</script>
</body>
</html>