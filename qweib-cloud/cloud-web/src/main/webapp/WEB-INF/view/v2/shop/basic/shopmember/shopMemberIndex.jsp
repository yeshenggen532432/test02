<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商城会员信息</title>
    <%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
    <style>
        .product-grid td {
            padding: 0;
        }

        .layui-card-body {
            position: relative;
            padding: 10px;
            line-height: 24px;
        }

        .k-panelbar .k-tabstrip>.k-content, .k-tabstrip>.k-content {
            position: static;
            border-style: solid;
            border-width: 1px;
            margin: 0;
            padding: 0;
            zoom: 1;
        }

    </style>
</head>
<body>
<tag:mask></tag:mask>
<%--<div class="layui-fluid">--%>
    <%--<div class="layui-row layui-col-space15">--%>
    <%--</div>--%>
<%--</div>--%>

<div class="layui-col-md12">
    <div class="layui-card">
        <div class="layui-card-body">
            <div uglcw-role="tabs">
                <ul >
                    <li>常规会员</li>
                    <li>员工会员</li>
                    <li>进销存客户会员</li>
                    <li>门店会员</li>
                    <li>自提店长</li>
                    <li>联盟商家</li>
                </ul>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?source=1" id="iframe1" name="iframe1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?source=2&memberType=1" id="iframe2" name="iframe2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?source=3" id="iframe3" name="iframe3" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?source=4" id="iframe4" name="iframe4" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?memberType=2" id="iframe5" name="iframe5" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
                <div>
                    <iframe src="manager/shopMember/toShopMemberPage?memberType=4" id="iframe6" name="iframe6" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
    $(function () {
        //ui:初始化
        uglcw.ui.init();

        resize();
        $(window).resize(resize);
        uglcw.ui.loaded();
    })

    var delay;
    function resize() {
        if (delay) {
            clearTimeout(delay);
        }
        delay = setTimeout(function () {
            var height =$(window).height();
            var iframeHeight = height-90;
            $('#iframe1').height(iframeHeight+"px");
            $('#iframe2').height(iframeHeight+"px");
            $('#iframe3').height(iframeHeight+"px");
            $('#iframe4').height(iframeHeight+"px");
            $('#iframe5').height(iframeHeight+"px");
            $('#iframe6').height(iframeHeight+"px");
            // var padding = 15;
            // var height = $(window).height() - padding - $('.header').height() - 40;
            // grid.setOptions({
            // 	height: height,
            // 	autoBind: true
            // })
        }, 200)
    }

    //-----------------------------------------------------------------------------------------


</script>
</body>
</html>
