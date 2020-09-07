<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>空购物车</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
</head>
<!-- --------head结束----------- -->

<!-- --------body开始----------- -->
<body>
<div id="wrapper">
    <div class="m_pwd topline">
        <div class="empty">
            <div class="e_content">
                <img src="<%=basePath%>/resource/shop/mobile/images/shopingcart_03.png">
                <span>购物车空空如也，不如</span>
                <%--<a href="<%=basePath %>/web/mainWeb/toIndex" class="e_btn">去首页逛逛</a>--%>
                <a href="javascript:toPage('<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}')"
                   class="e_btn">去首页逛逛</a>
            </div>
        </div>
    </div>

    <!--menu  start-->
    <div id="menu">
        <ul>
            <%--<li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}" ><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
            <li><a href="<%=basePath %>/web/mainWeb/wareType.html?token=${token}" ><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
            <li><a class="red"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
            <li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}" ><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>--%>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}')"><font
                    class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/wareType.html?token=${token}')"><font
                    class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
            <li><a class="red"><font class="iconfont" style="color: #3388FF;">&#xe63e;</font><span
                    class="inco_txt">购物车</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toMyInfo?token=${token}')"><font
                    class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
        </ul>
    </div>
    <!--menu  end-->
</div>

<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/menu.js"></script>
</body>
</html>