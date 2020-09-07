<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
    <title>促销商品列表</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp" %>
    <style type="text/css">
        .lsPrice {
            font-size: 6px;
            color: #999;
            margin: 0px 8px;
            text-decoration: line-through;
        }

        .mescroll {
            position: fixed;
            top: 44px;
            bottom: 0;
            height: auto;
        }
    </style>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<%--商品记忆功能引入--%>
<%@include file="/WEB-INF/page/shop/mobile/include/wareDetailComponent.jsp" %>
<div id="wrapper" class="inner_style">
    <div class="int_title">
	            <span class="int_pic" onclick="history.back()">
	            	<img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/>
	            </span>
        <span id="titleNm">促销商品列表</span>
    </div>

    <div id="mescroll" class="mescroll">
        <div class="best_Sellers best_top clearfix">
            <ul style="display: block;" class="clearfix best_content" id="wareList">
            </ul>
        </div>
    </div>

    <div id="back_top">
        <a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/xqq/the_top.png"/></a>
    </div>

    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/swiper.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/index.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/inner.js"></script>
    <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js"></script>
    <script type="text/javascript">
        //返回上个界面
        /*$(document).ready(function () {
            $.wechatShare();//分享
        })*/

        var mescroll;
        $(function () {
            //创建MeScroll对象
            mescroll = new MeScroll("mescroll", {
                down: {
                    use: false,//如果配置false,则不会初始化下拉刷新的布局
                },
                up: {
                    auto: true, //是否在初始化时以上拉加载的方式自动加载第一页数据; 默认false
                    isBounce: false, //此处禁止ios回弹,解析(务必认真阅读,特别是最后一点): http://www.mescroll.com/qa.html#q10
                    callback: upCallback, //上拉回调,此处可简写; 相当于 callback: function (page) { upCallback(page); }
                    toTop: { //配置回到顶部按钮
                        src: "<%=basePath %>/resource/shop/mobile/images/xqq/the_top.png", //默认滚动到1000px显示,可配置offset修改
                    },
                    htmlNodata: "<p class='upwarp-nodata'> -- 没有更多数据 -- </p>",
                }
            });

            /*上拉加载的回调 page = {num:1, size:10}; num:当前页 从1开始, size:每页数据条数 */
            function upCallback(page) {
                //联网加载数据
                getListDataFromNet(page.num, page.size);
            }

            function getListDataFromNet(pageNum, pageSize) {
                getWareList(pageNum, pageSize);
            }

        });

        //获取商品列表
        function getWareList(pageNum, pageSize) {
            $.ajax({
                url: "<%=basePath%>/web/shopRewardMobile/getWareListPage",
                data: {"token": "${token}", "rewardId": "${rewardId}", "pageNo": pageNum, "pageSize": pageSize},
                type: "POST",
                success: function (json) {
                    if (json.state && json.obj) {
                        if (pageNum == 1) {
                            mescroll.clearDataList();
                            $("#wareList").html("");
                            //滚动列表到指定位置y=0,则回到列表顶部; 如需滚动到列表底部,可设置y很大的值,比如y=99999t时长,单位ms,默认300; 如果不需要动画缓冲效果,则传0
                            mescroll.scrollTo(0, 300);
                        }
                        var datas = json.obj.rows;
                        var wareList = "";
                        if (datas != null && datas != undefined && datas.length > 0) {
                            for (var i = 0; i < datas.length; i++) {
                                var wareId = datas[i].wareId;
                                wareList += "<a href='javaScript:toWareDetails(" + wareId + ");'>";
                                wareList += "<li class='fl border_right'>";
                                var sourcePath = "<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg";
                                var defWarePic = datas[i].defWarePic;
                                if (defWarePic) {
                                    sourcePath = "<%=basePath%>/upload/" + defWarePic.picMini;
                                }
                                wareList += "<img src='" + sourcePath + "' style='height: 180px;border-radius: 2px;'/>";
                                wareList += "<div class='ellipsis_one'><span>" + datas[i].wareNm + "</span></div>";
                                var defWarePrice = datas[i].defWarePrice;
                                if (!defWarePrice) defWarePrice = "未设置";
                                wareList += "<span class='int_color'>￥" + defWarePrice + "</span>";
                                //--------------价格相关end---------------
                                wareList += "</li>";
                                wareList += "</a>";
                            }
                            $("#wareList").append(wareList);
                        }
                        mescroll.endSuccess(datas.length);
                    }else{
                        alert(json.message);
                        history.back();
                    }
                },
                error: function (data) {
                    mescroll.endErr();
                }
            });
        }


        /* function toWareDetails(wareId) {
             window.location.href = "<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+wareId;
			 }*/
    </script>


</body>
</html>
