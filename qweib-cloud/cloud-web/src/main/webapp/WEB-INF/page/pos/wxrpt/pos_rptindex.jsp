<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>老板助手</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
<style type="text/css">

body{
    overflow-x:hidden;
    height: 100%;
    /*开启moblie网页快速滚动和回弹的效果*/
    -webkit-overflow-scrolling: touch;
    font-size: 12px;
    font-family: "微软雅黑";
    overflow-x: hidden;
    -webkit-text-size-adjust: none !important;
}
*{
    margin: 0;
    padding: 0;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}

.my_info{
    width: 100%;
    height: 180px;
    max-height: 196px;
    min-height: 176px;
    position: relative;
    background-color: #3388FF;
}
.my_info img{
    width: 100%;
    height: 100%;
    position: relative;
}
.my_info .my_mian{
    position: absolute;
    left: 0px;
    bottom: 0px;
    right: 0px;
    top: 0px;
    margin: auto;
    width: 40%;
    height: 125px;
}
.my_info .my_mian P.my_pic{
    width: 55%;
    margin: 0 auto;
    border-radius: 50%;
}

.my_info .my_mian P.my_pic img{
    border-radius: 50%;
}
.my_info  span{
    width: 100%;
    display: inline-block;
    line-height: 22px;
    text-align: center;
    color: #fff;
}
.my_info  span.my_number{
    font-size: 16px;
    margin-top: 4px;
    vertical-align: center;
}
.my_info  span.my_amount{
    font-size: 14px;
    margin-top: 4px;
}

.mui-table-view-cell a{
    font-size: 13px;
    color: #696969;
}

.iconfont{
    font-size: 18px;
    color: #333333;
    margin-right: 5px;
}

/*==================tabbar======================*/
#menu {
    width: 100%;
    height: 44px;
    position: fixed;
    left: 0px;
    bottom: 0px;
    background: #fff;
    box-shadow: 0 -3px 5px #ccc;
    z-index: 1000;
}
#menu ul {
    width: 100%;
    list-style: none;
    height: 44px;
}
#menu ul *{
    margin: 0;
    padding: 0;
}
#menu ul li {
    width: 25%;
    float: left;
}
#menu ul li a{
    display: block;
    width: 100%;
    color: #333;
    text-decoration: none;
}
#menu ul li a.red {
    color: #3388FF;
    -webkit-transition: .3s color;
    transition: .3s color;
}
#menu ul li a font.iconfont {
    font-size: 18px;
}
#menu ul li a span {
    display: block;
    line-height: 8px;
}
/*.icon-fukuanma{
    font-size: 24px;
    color: white;
    margin-left: 5px;
    vertical-align: center;
}*/

    html, body { color:#222; font-family:Microsoft YaHei, Helvitica, Verdana, Tohoma, Arial, san-serif; margin:0; padding: 0; text-decoration: none; }

    img { border:0; }

    ul { list-style: none outside none; margin:0; padding: 0; }

    body {

        background-color:#eee;

    }

    body .mainmenu:after { clear: both; content: " "; display: block; }



    body .mainmenu li{

        float:left;

        margin-left: 2.5%;

        margin-top: 2.5%;

        width: 30%;

        border-radius:3px;

        overflow:hidden;    }



    body .mainmenu li a{ display:block;

        color:#FFF;

        text-align:center }

    body .mainmenu li a b{

        display:block; height:80px;    }

    body .mainmenu li a img{

        margin: 15px auto 15px;

        width: 50px;

        height: 50px;    }



    body .mainmenu li a span{ display:block; height:30px;

        line-height:30px;background-color:#FFF;

        color: #999; font-size:14px; }



    body .mainmenu li:nth-child(8n+1) {background-color:#36A1DB}

    body .mainmenu li:nth-child(8n+2) {background-color:#678ce1}

    body .mainmenu li:nth-child(8n+3) {background-color:#8c67df}

    body .mainmenu li:nth-child(8n+4) {background-color:#84d018}

    body .mainmenu li:nth-child(8n+5) {background-color:#14c760}

    body .mainmenu li:nth-child(8n+6) {background-color:#f3b613}

    body .mainmenu li:nth-child(8n+7) {background-color:#ff8a4a}

    body .mainmenu li:nth-child(8n+8) {background-color:#fc5366}

</style>

</head>

<body>

<div class="mui-content">
    <div class="mui-page-content">
        <div class="mui-scroll-wrapper">
            <div class="mui-scroll">
                <div class="my_info">
                    <%--<img src="<%=basePath%>/resource/shop/mobile/images/my/bj.png" />--%>
                    <div class="my_mian">
                        <p class="my_pic">
                            <a href="javaScript:;">
                                <%--<img src="<%=basePath%>/resource/shop/mobile/images/my/my_03.png" />--%>
                                <img src="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg" />
                            </a>
                        </p>
                        <span class="my_number" onclick="javaScript:toPaymentCode();">${tel}
                            <input type="hidden" id="cardId" value="${cardId}">
							<%--<i class="mui-icon iconfont icon-fukuanma"></i>--%>
						</span>
                        <span class="my_amount"></span>
                    </div>
                </div>
                <ul class="mainmenu">

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb01.png" /></b><span>单据查询</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb02.png" /></b><span>收银汇总</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb03.png" /></b><span>商品销售排行</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb04.png" /></b><span>发卡记录</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb05.png" /></b><span>充值记录</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb06.png" /></b><span>扣款记录</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb06.png" /></b><span>零售毛利表</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb07.png" /></b><span>会员档案</span></a></li>

                    <li><a href="/" ><b><img src="<%=basePath %>/resource/posstyle/images/tb08.png" /></b><span>公告</span></a></li>

                </ul>
            </div>
        </div>
    </div>
</div>



<!-- 欢迎大家关注我的博客！如有疑问,请加QQ群：135430763共同学习！ -->

</body>

</html>