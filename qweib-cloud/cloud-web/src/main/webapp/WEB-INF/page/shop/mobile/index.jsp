<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
    <title>${shopConfigSet.name}</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp" %>
    <link href="<%= basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
    <style type="text/css">
        /*img {*/
        /*border: 0;*/
        /*display: inline;*/
        /*width: auto;*/
        /*vertical-align: middle;*/
        /*}*/

        .lsPrice {
            font-size: 6px;
            color: #999;
            margin: 0px 8px;
            text-decoration: line-through;
        }

        .mescroll {
            position: fixed;
            top: 0px;
            bottom: 50px;
            height: auto;
        }

        .subscribe {
            padding: 5px;
            border-radius: 2px;
            background-color: #f3f5f7;
            color: #3388FF;
            position: absolute;
            z-index: 1;
            right: 8px;
            top: 6px;
            display: none;
        }

        .best_Sellers ul li span.int_color {
            color: #fa4802
        }

        .img_list {
            display: inline;
            width: auto;
            height: 180px;
            max-width: 180px !important;
            overflow: hidden;

        }

        .img_span {
            font-size: 0;
            width: 100%;
            height: 180px;
            display: table-cell;
            text-align: center;
            vertical-align: middle;
        }


        .img_div {
            /*display: table-cell;*/
            height: 180px;
            width: 100%;
            text-align: center;
            /*vertical-align: middle;*/
            overflow: hidden;
            position: relative;
            border-radius: 4px 4px 0 0;
        }

        .secskill-content ul li a img {
            display: inline-block;
            width: auto;
        }

        .img_img {
            /* width: auto; */
            max-width: 100%;
            /* max-height: 100%; */
            height: 100%;
            width: auto;
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .img_div2 {
            height: 110px;
            width: 82%;
            text-align: center;
            overflow: hidden;
            position: relative;
            border-radius: 4px 4px 0 0;
            margin-left: 8px;
        }

        .img_img2 {
            height: 100%;
            width: auto;
            max-width: 100%;
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .secskill-content ul li p.secskill-main {
            width: 82%;
            position: absolute;
            left: 6px;
            bottom: 0px;
            font-size: 0.4rem;
            text-align: left;
            color: #fff;
            line-height: 25px;
            height: 25px;
            padding: 0 3px;
            margin: 0 3px;
            background: rgba(0, 0, 0, 0.5);
        }

        .jd-logo img {
            border: 0;
            display: block;
            width: 100%;
            vertical-align: middle;
        }


    </style>
</head>
<!-- --------head结束----------- -->

<!-- --------body开始----------- -->
<body style="-webkit-text-size-adjust: 100%!important;">
<%--商品记忆功能引入--%>
<%@include file="/WEB-INF/page/shop/mobile/include/wareDetailComponent.jsp" %>
<div id="wrapper">
    <!--头部搜索框 start-->
    <div class="wf-search" id="search">
        <header>
            <div class="jd-logo">

                <img src="<%=basePath%>/resource/shop/mobile/images/logo.png"/>
            </div>

            <div class="search" style="padding-right:8px;"
                 onclick="toPage('<%=basePath %>/web/mainWeb/toSearch?token=${token}')">
                <form>
                    <span class="sprite-icon"></span>
                    <input type="search" placeholder="商品名称" disabled="disabled"/>
                </form>

                <span class="subscribe" onclick="javaScript:toWxSubscribe();">立即关注</span>
            </div>

        </header>
    </div>
    <!--头部搜索框 end-->
    <div id="mescroll" class="mescroll">

        <!--banner start-->
        <div style="position: relative;">
            <div id="slider">
                <div class="swiper-container clearfix">
                    <ul class="swiper-wrapper">
                        <%-- <!-- 无banner图，显示默认 -->
                         <c:if test="${empty shopMallInfo.bannerList}">
                             <li class="swiper-slide"><a href="Orchard_fragrance.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner1.png"/></a></li>
                             <li class="swiper-slide"><a href="Birthday_zone.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner2.jpg"/></a></li>
                             <li class="swiper-slide"><a href="Integral_mall.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner3.jpg"/></a></li>
                         </c:if>
                         <!-- 有banner图 -->
                         <c:if test="${!empty shopMallInfo.bannerList}">
                             <c:forEach items="${shopMallInfo.bannerList}" var="banner" varStatus="s">
                                 &lt;%&ndash;style="width:100%;height:150px"&ndash;%&gt;
                                 <li class="swiper-slide"><img src="<%=basePath%>/upload/${banner.pic}" ></li>
                             </c:forEach>
                         </c:if>--%>
                    </ul>
                </div>
                <div class="swiper-pagination"></div>
            </div>

            <!-- 企业logo图 -->
            <div id="logo" style="position: absolute;z-index: 1;bottom: 15px;left: 10px;">
                <%--<c:if test="${!empty shopMallInfo.logo}">
                    <img src="<%=basePath%>/upload/${shopMallInfo.logo}"
                         style="width:45px;height:45px;display:inline;border-radius: 5px;"/>
                </c:if>
                <c:if test="${!empty shopMallInfo.name}">
                    <span style="color:white;font-size:15px;padding-left: 8px">${shopMallInfo.name}</span>
                </c:if>--%>
            </div>

        </div>
        <!--banner end-->

        <!-- 商品一级分类 开始 -->
        <div id="nav">
            <div class="int_nav clearfix">
                <ul class="swiper-wrapper swiper_wrappcon">
                    <li class="swiper-slide" style="padding-bottom: 0px">
                        <a href="javascript:toPage('<%=basePath%>/web/shopWareFavoriteMobile/toWareFavoritePage?token=${token}')">
                            <img src="<%=basePath%>/resource/shop/mobile/images/index/favorite.png"/>
                            <span>我的收藏</span>
                        </a>
                        <a href="javascript:toPage('<%=basePath%>/web/shopMemberHistory/toListPage?token=${token}')">
                            <img src="<%=basePath%>/resource/shop/mobile/images/index/history.png"/>
                            <span>我的足迹</span>
                        </a>
                        <a href="javascript:toPage('<%=basePath%>/web/shopBforderMobile/toMyOrder?token=${token}')">
                            <img src="<%=basePath%>/resource/shop/mobile/images/index/order.png"/>
                            <span>我的订单</span>
                        </a>
                        <a href="javascript:toPage('<%=basePath%>/web/shopRewardMobile/toIndex?token=${token}')">
                            <img src="<%=basePath%>/resource/shop/mobile/images/index/reword.png"/>
                            <span>促销</span>
                        </a>
                    </li>
                </ul>
                <ul class="swiper-wrapper swiper_wrappcon" id="waretypeNav">
                    <%--<li class="swiper-slide">
                        <a href="Inner_page.html">
                            <img src="<%=basePath%>/resource/shop/mobile/images/jifen/icon1.png"/>
                            <span>积分商城</span>
                        </a>
                    </li>
                    <li class="swiper-slide">
                        <a href="Inner_page.html">
                            <img src="<%=basePath%>/resource/shop/mobile/images/jifen/icon1.png"/>
                            <span>积分商城1</span>
                        </a>
                    </li>--%>
                </ul>
                <!-- <div class="swiper-pagination"></div> -->
            </div>
        </div>
        <!-- 商品一级分类 结束 -->


        <%-- <c:forEach items="${mobile:queryListByParam('sys_ware','*',\"(status='1' or status='') and put_on='1'\",token)}" var="map">
            ${map['ware_id'] }:${map['ware_nm'] }
        </c:forEach> --%>
        <%--${mobile:queryListByParam('sys_ware','*','',token)} --%>

        <!--生日专区 end-->
        <main style="padding:5px 0px;">
            <ul id="leftWareType">
                <%-- <!-- 111 -->
                <div class="floor clearfix">
                    <div class="floor-container">
                        <div class="title-wrap">
                            <span class="sprite-icon secskill-icon fl"></span>
                            <h2 class="secskill-title fl">最新上映</h2>
                            <a href="Media.html">
                                <div class="secskill-more fr">
                                    <span>查看更多</span>
                                    <span class="sprite-icon"></span>
                                </div>
                            </a>
                        </div>
                        <div class="secskill-content">
                            <ul class="swiper-wrapper">
                                <li class="swiper-slide">
                                    <a href="Quick_ticket.html"><img src="<%=basePathResource %>/images/move/index_11.png" /></a>
                                    <p class="secskill-main clearfix"><span class="secskill-title-con">美国队长3</span><span class="secskill-number">8.0</span></p>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div> --%>
            </ul>

            <div class="floor clearfix">
                <div class="floor-container" id="model1">
                </div>
            </div>
            <div class="floor clearfix">
                <div class="floor-container" id="model2">
                </div>
            </div>
            <div class="floor clearfix">
                <div class="floor-container" id="model3">
                </div>
            </div>
        </main>

        <!-- <main id="main">
            <div class="best_Sellers best_top clearfix">
                <ul style="display: block;" class="clearfix best_content" id="wareList">
                </ul>
            </div>
        </main> -->

        <div class="best_Sellers best_top clearfix">
            <ul style="display: block;" class="clearfix best_content" id="wareList">
            </ul>
        </div>
    </div>

    <!--menu  start-->
    <div id="menu">
        <ul>
            <li><a class="red"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/wareType.html?token=${token}&companyId=${companyId}')"><font
                    class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}&companyId=${companyId}')"><font
                    class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toMyInfo?token=${token}')"><font
                    class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
            <%--<li><a class="red"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/wareType.html"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/toShoppingCart"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/toMyInfo" ><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>--%>
        </ul>
    </div>
    <!--menu  end-->
</div>

<script type="text/javascript" src="<%=basePath %>/resource/shop/mobile/js/rem.js"></script>
<script type="text/javascript" src="<%=basePath %>/resource/shop/mobile/js/swiper.min.js"></script>
<script type="text/javascript">

    $('.btn2').click(function () {
        wx.openLocation({
            latitude: 22.545538, // 纬度，浮点数，范围为90 ~ -90。如果是动态获取的数据，使用parseFloat()处理数据
            longitude: 114.054565, // 经度，浮点数，范围为180 ~ -180。如果是动态获取的数据，使用parseFloat()处理数据；
            name: '这里填写位置名', // 位置名
            address: '位置名的详情说明', // 地址详情说明
            scale: 10, // 地图缩放级别,整形值,范围从1~28。默认为最大
        });
    })


    /*  if('${token}')
        sessionStorage.setItem("token", "${token}");*/
    if('${companyId}')
        setCache("companyId", "${companyId}");
    if('${wid}')
        setCache("wid", "${wid}");
    var mescroll;//创建MeScroll对象
    $(document).ready(function () {
        scanDining();//是否扫码进入餐桌

        indexData();
        //doWxSubscribe();//关注公众号

        //getWaretypeList();//根据waretypeIds获取商品一级分类列表
        getWareGroupList();//获取分组列表数据
        //getWareList();//全部商品
        //$.wechatShare(null);//分享统一分享JS处理

        //==============加载更多：开始==================
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

        //==============加载更多：结束==================

        /**
         * 添加购物车
         */
        mui("#wareList").on("tap", ".my-cart-item", function () {
            var warePrice = this.getAttribute("warePrice");
            if (!warePrice || warePrice == "undefined") {
                mui.alert("此商品还没设置价格");
                return false;
            }
            var wareId = this.getAttribute("wareId");
            var beUnit = this.getAttribute("beUnit");
            var wareNum = 1;
            $.ajax({
                url: "<%=basePath%>/web/shopCart/addShopCartWeb",
                data: {"token": "${token}", "wareId": wareId, "wareNum": wareNum, "beUnit": beUnit},
                type: "POST",
                success: function (json) {
                    if (json.state) {
                        json = json.obj;
                        if (json.add) {
                            mui.toast("添加购物车成功");
                        }
                        if (json.update) {
                            mui.toast("此商品已添加到购物车");
                        }
                    } else {
                        if (json.code && json.code == 444) {
                            toPage("<%=basePath%>/web/mainWeb/toWeixinRegister?token=${token}");
                        } else {
                            mui.toast(json.message);
                        }
                    }
                }
            });
            event.stopPropagation();
        })
    })

    //是否扫码进入餐桌
    function scanDining() {
        var _diningid = getQueryVariable('diningid');
        if (_diningid && _diningid != 'null') {
            setCache("diningid", _diningid);
            $.ajax({
                url: "<%=basePath%>/web/shopDiningTable/seateding?diningid=" + _diningid,
                type: "POST",
                success: function (json) {
                    if (json.state) {
                        var obj = json.obj;
                        if (obj.isNew) {
                            var selects = [];
                            for (var i = 1; i <= 10; i++) {
                                selects.push('<span onclick="setPromptVal(' + i + ')">' + i + '</span>');
                            }
                            var str = selects.join("&nbsp;&nbsp;");
                            mui.prompt('<div style="color: blue;">' + str + '</div>', '1', "就餐人数", null, function (data) {
                                if (data.index) {
                                    $.ajax({
                                        url: "<%=basePath%>/web/shopDiningTable/updatePeopleNumber?diningid=" + _diningid + "&peopleNumber=" + data.value,
                                        type: "POST",
                                        success: function (json) {
                                            if (json.state) {
                                                mui.toast("新开桌成功" + obj.name + ",人数" + data.value);
                                            } else {
                                                mui.alert(json.message);
                                            }
                                        }
                                    });
                                }
                            }, 'div');
                        } else {
                            mui.toast("欢迎加入" + obj.name);
                        }
                    } else {
                        mui.alert(json.message);
                    }
                }
            });
        }
    }

    function setPromptVal(va) {
        $('.mui-popup-input input').val(va);
    }


    //首页数据
    function indexData() {
        $.ajax({
            url: "<%=basePath%>/web/mainWeb/indexData",
            data: {
                "token": "${token}",
                "companyId": "${companyId}"
            },
            type: "POST",
            success: function (json) {
                if (json.state && json.obj) {
                    //验证是否关注公众号
                    doWxSubscribe(json.obj.subscribe);
                    var shopConfigSet = json.obj.shopConfigSet;
                    document.title = shopConfigSet.name;
                    var bannerText = '';
                    <!-- 无banner图，显示默认 -->
                    if (!shopConfigSet.bannerList || shopConfigSet.bannerList.length == 0) {
                        bannerText += '<li class="swiper-slide"><a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/images/qwb.png"/></a></li>';
                        bannerText += '<li class="swiper-slide"><a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/images/banner1.png"/></a></li>';
                    } else {
                        $(shopConfigSet.bannerList).each(function (i, item) {
                            bannerText += '<li class="swiper-slide"><img src="<%=basePath%>/upload/' + item.pic + '" ></li>';
                        });
                    }
                    $("#slider .swiper-wrapper").html(bannerText);
                    var logoText = '';
                    if (shopConfigSet.logo) {
                        setCache("shareLogo", '<%=basePath%>/upload/' + shopConfigSet.logo);
                        logoText += '<img id="shareImg" src="<%=basePath%>/upload/' + shopConfigSet.logo + '"style="width:45px;height:45px;display:inline;border-radius: 5px;"/>';
                    } else {
                        setCache("shareTitle", '');
                    }
                    if (shopConfigSet.name) {
                        logoText += '<span style="color:white;font-size:15px;padding-left: 8px">' + shopConfigSet.name + '</span>';
                        setCache("shareLogo", '<%=basePath%>/upload/' + shopConfigSet.logo);
                    } else {
                        setCache("shareTitle", '');
                    }
                    $("#logo").html(logoText);
                    //首页推荐分类
                    getWaretypeList(json.obj.sysWaretypeList);

                    setBannerSwiper();//设置轮播图的滚动
                } else {
                    alert(json.message);
                }
            },
            error: function (data) {
            }
        });
    }

    //设置banner的滚动
    function setBannerSwiper() {
        var mySwiper = new Swiper('.swiper-container', {
            autoplay: 2000,//可选选项，自动滑动，手指触屏滑动会停止自动轮播
            autoplayDisableOnInteraction: false,//手指触屏滑动之后，重新开启自动轮播
            initialSlide: 0,//初始显示的li的索引
            speed: 1000,//滑动的速度
            observer: true,//当li节点被修改的时候自动更新Swiper
            observeParents: true,//当容器container宽度改变的时候(window.onresize或者自适应)自动更新Swiper
            grabCursor: true,//鼠标抓手形状，触屏看不到
            pagination: '.swiper-pagination',//下面的图标跟随切换
            loop: true,//无缝轮播 自动在li列表的前面添加最后一个，在li列表后面添加第一个
        })
    }

    //根据waretypeIds获取商品一级分类列表
    function getWaretypeList(datas) {
        var leftWareType = "";
        if (datas != null && datas != undefined && datas.length > 0) {
            //小于4个不显示
            if (datas != null && datas != undefined && datas.length >= 4) {
                //第一页：8个
                leftWareType += "<li class=\"swiper-slide\">";
                for (var i = 0; i < datas.length; i++) {
                    var waretypePicList = datas[i].waretypePicList;
                    if (i <= 6) {
                        leftWareType += "<a href=\"javascript:toPage('<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&wareType=" + datas[i].waretypeId + "')\">";
                        if (waretypePicList != null && waretypePicList != undefined && waretypePicList.length > 0) {
                            leftWareType += "<img src='<%=basePath%>/upload/" + waretypePicList[0].pic + "' style='border-radius: 5px;'/>";
                        } else {
                            leftWareType += "<img src='<%=basePath %>/resource/shop/mobile/images/1.png' style='border-radius: 5px;'/>";
                        }
                        leftWareType += "<span>" + datas[i].waretypeNm + "</span>";
                    }
                    if (i >= 6) {
                        //第八个："全部分类"
                        leftWareType += "<a href=\"javascript:toPage('<%=basePath %>/web/mainWeb/wareType.html')\">";
                        leftWareType += "<img src='<%=basePath %>/resource/shop/mobile/images/8.png' style='border-radius: 5px;'/>";
                        leftWareType += "<span>全部分类</span>";
                        break;
                    }
                    leftWareType += " </a>";
                }
                leftWareType += "</li>";

            }
        }
        $("#waretypeNav").html(leftWareType);
    }

    //获取商品分组列表
    function getWareGroupList() {
        $.ajax({
            url: "<%=basePath%>/web/shopWareGroupWeb/queryWareGroupList2",
            data: {"token": "${token}", "companyId": "${companyId}", "modelGroupIds": "${modelGroupIds}"},
            type: "POST",
            success: function (json) {
                if (json.state) {
                    var datas = json.obj;
                    var leftWareType = "";
                    if (datas != null && datas != undefined && datas.length > 0) {
                        for (var i = 0; i < datas.length; i++) {
                            var wareList = datas[i].mobileSysWareList;
                            //判断少于3个不显示
                            if (wareList != null && wareList != undefined && wareList.length >= 3) {
                                leftWareType += "<div class='floor clearfix'>";
                                leftWareType += "<div class='floor-container'>";
                                leftWareType += "<div class='title-wrap'>";
                                leftWareType += "<span class='sprite-icon secskill-icon fl'></span>";
                                leftWareType += "<h2 style='font-size:0.7rem' class='secskill-title fl'>" + datas[i].name + "</h2>";
                                leftWareType += "<a href=\"javascript:toPage('<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&groupId=" + datas[i].id + "')\">";
                                leftWareType += "<div class='secskill-more fr'>";
                                leftWareType += "<span style='font-size:0.6rem;margin-right:5px'>查看更多</span>";
                                leftWareType += "<span class='sprite-icon'></span>";
                                leftWareType += "</div>";
                                leftWareType += "</a>";
                                leftWareType += "</div>";
                                leftWareType += "<div class='secskill-content'>";
                                leftWareType += "<ul class='swiper-wrapper'>";

                                //-------------------------图片start----------------------------------
                                if (wareList != null && wareList != undefined && wareList.length > 0) {
                                    for (var j = 0; j < wareList.length; j++) {

                                        //-------------------------图片start----------------------------------
                                        leftWareType += "<li class='swiper-slide'>";
                                        leftWareType += "<a href='javaScript:toWareDetails(" + wareList[j].wareId + ")'>";
                                        var defWarePic = wareList[j].defWarePic;
                                        if (defWarePic) {
                                            var sourcePath = "<%=basePath%>/upload/" + defWarePic.picMini;
                                            leftWareType += "<div class='img_div2'>";
                                            leftWareType += "<img src='" + sourcePath + "' class='img_img2'/>";
                                            leftWareType += "</div>";
                                            // leftWareType+="<img src='"+sourcePath+"' style='height:110px;border-radius: 2px;'/>";
                                        } else {
                                            leftWareType += "<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' style='height:110px;border-radius: 2px;'/>";
                                        }

                                        leftWareType += "</a>";
                                        //------------------价格相关：start---------------------
                                        leftWareType += "<p class='secskill-main clearfix'>";
                                        leftWareType += "<span class='secskill-title-con'>" + wareList[j].wareNm + "</span>";

                                        /* if("3"==source){
                                             var shopWarePrice = wareList[j].shopWarePrice;
                                             if(shopWarePrice != null && shopWarePrice != undefined){
                                                 leftWareType+="<span class='secskill-number'>￥"+wareList[j].shopWarePrice+"</span>";
                                             }
                                         }else{
                                             var shopWareLsPrice = wareList[j].shopWareLsPrice;
                                             if(shopWareLsPrice != null && shopWareLsPrice != undefined){
                                                 leftWareType+="<span class='secskill-number'>￥"+wareList[j].shopWareLsPrice+"</span>";
                                             }
                                         }*/
                                        /* var source = json.source;//1普通会员；2员工会员；3进销存客户会员
                                         var shopWarePrice;
                                          if("3"==source){
                                              if (wareList[j].shopWarePriceDefault == 0) {
                                                  shopWarePrice = wareList[j].shopWarePrice;
                                              }else{
                                                  shopWarePrice = wareList[j].shopWareSmallPrice;
                                              }
                                          }else{
                                              if (wareList[j].shopWarePriceDefault == 0) {
                                                  shopWarePrice = wareList[j].shopWareLsPrice;
                                              }else{
                                                  shopWarePrice = wareList[j].shopWareSmallLsPrice;
                                              }
                                          }*/

                                        var defWarePrice = wareList[j].defWarePrice;
                                        if (!defWarePrice) defWarePrice = "未设置";
                                        if (defWarePrice)
                                            leftWareType += "<span class='secskill-number'>￥" + defWarePrice + "</span>";
                                        leftWareType += "</p>";
                                        //------------------价格相关：start---------------------
                                        leftWareType += "</li>";
                                    }
                                }
                                //-------------------------图片end----------------------------------

                                leftWareType += "</ul>";
                                leftWareType += "</div>";
                                leftWareType += "</div>";
                                leftWareType += "</div>";
                            }

                        }
                    }
                    $("#leftWareType").html(leftWareType);
                }
                //处理列表左右滑动的
                var mySwiper = new Swiper('.secskill-content', {
                    initialSlide: 0,//初始显示的li的索引
                    speed: 1000,//滑动的速度
                    observer: true,//当li节点被修改的时候自动更新Swiper
                    observeParents: true,//当容器container宽度改变的时候(window.onresize或者自适应)自动更新Swiper
                    slidesPerView: 3,//'auto'
                });
            },
            error: function (data) {
            }
        });
    }

    //滚动条到页面底部加载更多案例
    var flag = true;
    var pageIndex = 1;
    $(window).scroll(function () {
        var scrollTop = $(this).scrollTop();    //滚动条距离顶部的高度
        var scrollHeight = $(document).height();   //当前页面的总高度
        var clientHeight = $(this).height();    //当前可视的页面高度
        if (scrollTop + clientHeight >= scrollHeight) {   //距离顶部+当前高度 >=文档总高度 即代表滑动到底部
            //滚动条到达底部
            if (flag) {
                getWareList();
            }
        } else if (scrollTop <= 0) {
            //滚动条到达顶部
            //滚动条距离顶部的高度小于等于0 TODO
        }
    });

    //获取全部商品列表
    function getWareList(pageNum, pageSize) {
        var wareType = "";
        var groupId = "";
        $.ajax({
            url: "<%=basePath%>/web/mallShop/getWareList",
            data: {
                "token": "${token}",
                "companyId": "${companyId}",
                "wareType": wareType,
                "groupId": groupId,
                "pageNo": pageNum,
                "pageSize": pageSize
            },
            type: "POST",
            success: function (json) {
                if (json.state) {
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
                            //wareList += "<a href='javaScript:toWareDetails(" + wareId + ")'>";
                            wareList += "<li class='fl border_right' onclick='toWareDetails(" + wareId + ")'>";

                            //--------------图片相关start--------------
                            var defWarePic = datas[i].defWarePic;
                            if (defWarePic) {
                                var sourcePath = "<%=basePath%>/upload/" + defWarePic.picMini;
                                // style='height: 180px;border-radius: 2px;'
                                // wareList+="<div style='height: 180px;width: 100%;text-align: center'>";
                                wareList += "<div class='img_div'>";
                                // wareList+="<span class='img_span'>";
                                wareList += "<img src='" + sourcePath + "' class='img_img'/>";
                                // wareList+="</span>";
                                wareList += "</div>";
                                // wareList+="</div>";
                            } else {
                                wareList += "<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' style='height: 180px;border-radius: 2px;'/>";
                            }
                            //--------------图片相关end--------------

                            wareList += "<div class='ellipsis_one'><span>" + datas[i].wareNm + "</span></div>";

                            //--------------价格相关start---------------
                            var source = json.source;//1普通会员；2员工会员；3进销存客户会员
                            /*  if("3"==source){
                                  wareList += "<span class='int_color'>￥"+datas[i].shopWarePrice+"</span>";
                                  var shopWareLsPrice = datas[i].shopWareLsPrice;
                                  if(shopWareLsPrice != null && shopWareLsPrice!=undefined && shopWareLsPrice!=''){
                                      wareList += "<span class='lsPrice'>￥"+datas[i].shopWareLsPrice+"</span>";
                                  }
                              }else{
                                  var shopWareLsPrice = datas[i].shopWareLsPrice;
                                  if(shopWareLsPrice == null && shopWareLsPrice == undefined){
                                      wareList+="<span class='int_color'></span>";
                                  }else{
                                      wareList+="<span class='int_color'>￥"+shopWareLsPrice+"</span>";
                                  }
                              }*/
                            var defWarePrice = datas[i].defWarePrice;
                            var defWareLsPrice = datas[i].defWareLsPrice;
                            defWarePrice = defWarePrice ? defWarePrice : "暂无";
                            if (defWarePrice)
                                wareList += "<span class='int_color'>￥" + defWarePrice + "</span>";

                            if (defWareLsPrice)
                                wareList += "<span class='lsPrice'>￥" + defWareLsPrice + "</span>";
                            wareList += '<span style="float:right;width:25px;" class="my-cart-item" warePrice="' + datas[i].defWarePrice + '" wareId="' + datas[i].wareId + '" beUnit="' + datas[i].defUnitCode + '" ><span class="mui-icon iconfont icon-gouwuche"></span></span>';
                            //wareList +="<span class='mui-icon iconfont icon-gouwuche' style='width:30px;float: right'></span>";
                            //--------------价格相关end---------------
                            wareList += "</li>";
                            //wareList += "</a>";
                        }
                        $("#wareList").append(wareList);
                    }
                    mescroll.endSuccess(datas.length);
                }
            },
            error: function (data) {
                mescroll.endErr();
            }
        });
    }

    function doWxSubscribe(subscribe) {
        if (!subscribe) {
            $(".subscribe").show();
        }
    }

    //公众号
    function toWxSubscribe() {
        event.stopPropagation();
        toPage("<%=basePath %>/web/mainWeb/toWxSubscribe?token=${token}");
    }
</script>
<%--<script src="https://yzf.qq.com/xv/web/static/chat_sdk/yzf_chat.min.js"></script>
<script>
    //参数说明
    //sign：公司渠道唯一标识，复制即可，无需改动
    //uid：用户唯一标识，如果没有则不填写，默认为空
    //data：用于传递用户信息，最多支持5个，参数名分别为c1,c2,c3,c4,c5；默认为空
    //selector：css选择器(document.querySelector, 如#btnid .chat-btn等)，用于替换默认的常驻客服入口
    //callback(type, data): 回调函数,type表示事件类型， data表示事件相关数据
    //type支持的类型：newmsg有新消息，error云智服页面发生错误， close聊天窗口关闭
    window.yzf && window.yzf.init({
        sign: '37ef9b97d02307932a1099ea49b7b46bfc2c916ac709d7b03b50623919eafe055cf61b8f1a5738aa22e16589ded3a02281bccc',
        uid: '',
        data: {
            c1: '',
            c2: '',
            c3: '',
            c4: '',
            c5: ''
        },
        selector: '',
        callback: function (type, data) {
        }
    })
    //window.yzf.close() 关闭1已打开的回话窗口
</script>
<link rel="stylesheet" type="text/css" href="<%=basePath%>/static/qwbui/layui/css/layui.mobile.css">--%>
<script src="<%=basePath%>/static/qwb/qwb.im.service.js"></script>
<script>
    $(function () {
       /* initIM(function (token) {
            qwb_service.init({
                url: '<%=basePath%>/qwbim?token=' + token + '#/client?targetId=${tenantId}&title=${shopConfigSet.name}'
            })
        })*/
    });

    function initIM(callback) {
        var mallToken = '${param.token}';
        if (mallToken) {
            $.ajax({
                url: '<%=basePath%>/web/im/token',
                type: 'get',
                data: {
                    token: mallToken
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        callback(response.data)
                    }
                }
            })
        } else {
           var imToken = localStorage.getItem('qwb.im.guest.token');
            if (imToken) {
                return callback(imToken);
            }
            $.ajax({
                url: '<%=basePath%>/api/im/token/anonymous',
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify({
                    tenantId: '${tenantId}',
                }),
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        localStorage.setItem('qwb.im.guest.token', response.data);
                        callback(response.data)
                    }
                }
            })
        }
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
</body>
</html>
