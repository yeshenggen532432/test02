<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品详情</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>商品详情</title>--%>
    <style>
        .mui-content {
            padding-bottom: 40px;
        }

        #slider {
            width: 100%;
            position: relative;
            margin-top: 0px;
            overflow: hidden;
            height: 300px;
            text-align: center;
            background-color: white;
        }

        #slider img {
            height: 300px;
            width: auto;
        }

        .my-title-price {
            background-color: #FFFFFF;
            padding: 5px 10px;
            border-top: solid 1px #EEEEEE;
            border-bottom: solid 1px #EEEEEE;
            margin-bottom: 10px;
        }

        .my-title {
            font-size: 14px;
            color: #333333;
            line-height: 24px;
            margin: 0;
            padding: 0;
            font-weight: 400;
        }

        .my-price {
            font-size: 12px;
            color: red;
            line-height: 20px;
            margin: 0;
            padding: 0;
        }

        .my-price #lsPrice {
            font-size: 10px;
            color: #999;
            margin: 0px 8px;
            text-decoration: line-through;
        }

        .my-dw-num-box {
            padding: 5px 10px;
            background-color: white;
            margin-bottom: 10px;
        }

        .my-dw-box {
            display: flex;
        }

        .my-dw {
            display: inline-block;
            width: 60px;
            font-size: 12px;
            color: #999999;
            padding-top: 8px;
        }

        .my-tags {
            flex: 1;
        }

        .my-tags > div {
            height: 24px;
            float: left;
            margin: 5px;
            line-height: 24px;
            padding: 0px 12px;
            border-radius: 4px;
            border: 1px solid #3388FF;
            color: #3388FF;
            font-size: 12px;
        }

        .my-tags-active {
            background: #3388FF !important;
            color: #FFFFFF !important;
        }


        .table {
            width: 100%;
            height: 100%;
            display: table;
            table-layout: fixed;

            border-top: 1px solid #f1f1f1;
            background-color: #fff;
            text-align: center;
            font-size: 12px;
            box-shadow: 0 -1px 3px 3px rgba(0, 0, 0, 0.1);
        }

        .table-cell {
            display: table-cell;
        }

        .my-bottom-left {
            vertical-align: middle;
            width: 14%;
            border-right: 1px #dadada solid;
        }

        .my-bottom-left i {
            display: block;
            margin-right: auto;
            margin-left: auto;
        }

        .my-bottom-right {
            vertical-align: middle;
            border-right: 1px #dadada solid;
            color: #fff;
            font-size: 15px;
        }

        .bg-orange {
            background-color: #ff9000;
        }

        .bg-red {
            background-color: #f15151;
        }

        .bg-ash {
            background-color: #C7C7C7;
        }

        /*红点提示 用于内部有数字*/
        .hint-num {
            position: relative;
        }

        .hint-num span {
            position: absolute;
            top: -5px;
            right: 4px;
        }

        .mui-badge {
            font-size: 10px;
        }

        .my-ware-desc-title {

        }

        #wareDetail {
            background-color: #FFFFFF;
        }

        #wareDetail * {
            margin: 0;
            padding: 0;
            list-style: none;
            max-width: 100%;
            white-space: pre-line;
            word-break: break-all;
        }

        .favorite {
            color: sandybrown;
        }

        html {
            position: relative;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }

        body {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: scroll;
        }
    </style>
</head>

<!-- --------body开始----------- -->
<body>
<div class="mui_head"></div>
<%--<header class="mui-bar mui-bar-nav">
	<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
	<h1 class="mui-title">商品详情</h1>
</header>--%>

<div class="mui-content">
    <%--图片--%>
    <div id="slider" class="mui-slider">
        <%--<div class="mui-slider-group mui-slider-loop">--%>
        <%--<!-- 额外增加的一个节点(循环轮播：第一个节点是最后一张轮播) -->--%>
        <%--<div class="mui-slider-item mui-slider-item-duplicate">--%>
        <%--<a href="#">--%>
        <%--<img src="<%=basePath %>/resource/shop/mobile/images/images/banner3.jpg">--%>
        <%--</a>--%>
        <%--</div>--%>
        <%--<!-- 第一张 -->--%>
        <%--<div class="mui-slider-item">--%>
        <%--<a href="#">--%>
        <%--<img src="<%=basePath %>/resource/shop/mobile/images/images/wareImg.jpg">--%>
        <%--</a>--%>
        <%--</div>--%>
        <%--<!-- 第二张 -->--%>
        <%--<div class="mui-slider-item">--%>
        <%--<a href="#">--%>
        <%--<img src="<%=basePath %>/resource/shop/mobile/images/images/wareImg.jpg">--%>
        <%--</a>--%>
        <%--</div>--%>
        <%--<!-- 第三张 -->--%>
        <%--<div class="mui-slider-item">--%>
        <%--<a href="#">--%>
        <%--<img src="<%=basePath %>/resource/shop/mobile/images/images/wareImg.jpg">--%>
        <%--</a>--%>
        <%--</div>--%>
        <%--<!-- 额外增加的一个节点(循环轮播：最后一个节点是第一张轮播) -->--%>
        <%--<div class="mui-slider-item mui-slider-item-duplicate">--%>
        <%--<a href="#">--%>
        <%--<img src="<%=basePath %>/resource/shop/mobile/images/images/wareImg.jpg">--%>
        <%--</a>--%>
        <%--</div>--%>
        <%--</div>--%>
        <%--<div class="mui-slider-indicator">--%>
        <%--<div class="mui-indicator mui-active"></div>--%>
        <%--<div class="mui-indicator"></div>--%>
        <%--<div class="mui-indicator"></div>--%>
        <%--<div class="mui-indicator"></div>--%>
        <%--</div>--%>
    </div>

    <div>
        <%--商品名称；价格--%>
        <div class="my-title-price">
            <p id="wareNm" class="my-title">xxx</p>
            <p class="my-price">
                <span id="wareDj"></span>
                <span id="lsPrice"></span>
                <a style="color:grey" href="javascript:addFavorite();" class="mui-pull-right my-favorite"><span
                        class="mui-icon iconfont" style="font-size: 20px"></span></a>
            </p>
            <div id="rewardIndex" style="padding-top: 8px;border-top: solid 1px #EEEEEE;font-size:14px;display: none;">
                <a href="#rewardList"> 促销:xxx>>></a>
            </div>
        </div>
        <div id="rewardList" class="mui-popover mui-popover-action mui-popover-bottom mui-active"
             style="display: none;">
            <ul class="mui-table-view list">
                <%-- <li class="mui-table-view-cell">
                     <a href="#">拍照或录像</a>
                 </li>
                 <li class="mui-table-view-cell">
                     <a href="#">选取现有的</a>
                 </li>--%>
            </ul>
            <ul class="mui-table-view">
                <li class="mui-table-view-cell">
                    <a href="#rewardList"><b>取消</b></a>
                </li>
            </ul>
        </div>
        <div class="my-dw-num-box">
            <div>
                <div class="my-dw-box">
                    <div class="my-dw">
                        <span>单　　位：</span>
                    </div>
                    <div class="my-tags" id="tags">
                        <%--<div id="kkk">件</div>
                        <div id="xxxx">箱</div>--%>
                    </div>
                </div>
            </div>
            <div>
                <div class="my-dw">
                    <span>购买数量:</span>
                </div>
                <div class="mui-numbox" data-numbox-min='1' style="width: 150px;height: 30px;">
                    <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
                    <input id="wareNum" class="mui-input-numbox" type="number"/>
                    <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
                </div>
            </div>
        </div>
    </div>

    <div class="my-ware-desc">
        <div class="my-ware-desc-title mui-table-view">
            <li class="mui-table-view-cell">
                商品描述
            </li>
        </div>
        <div id="wareDetail" class="my-ware-desc-content">

        </div>
    </div>

</div>

<!-- 底部悬浮 -->
<div class="my-bottom-fixed" id="footerDivPutOn">
    <footer class="table">
        <a href="javascript:toIndex();" class="table-cell my-bottom-left"><i class="mui-icon mui-icon-home"></i></a>
        <a href="javascript:toShoppingCart();" class="table-cell my-bottom-left"><i
                class="mui-icon-extra mui-icon-extra-cart hint-num"><span class="cartcount mui-badge mui-badge-danger"
                                                                          style="display: none"></span></i></a>
        <a href="javascript:addShopCart();" class="table-cell my-bottom-right bg-orange">加入购物车</a>
        <a href="javascript:toFillOrder();" class="table-cell my-bottom-right bg-red">立即购买</a>
    </footer>
</div>

<div class="my-bottom-fixed" id="footerDivNoPutOn" style="display: none">
    <footer class="table">
        <a href="javascript:toIndex();" class="table-cell my-bottom-left"><i class="mui-icon mui-icon-home"></i></a>
        <a href="javascript:toShoppingCart();" class="table-cell my-bottom-left "><i
                class="mui-icon-extra mui-icon-extra-cart hint-num"><span class="cartcount mui-badge mui-badge-danger"
                                                                          style="display: none"></span></i></a>
        <a href="javascript:" class="table-cell my-bottom-right bg-ash">已下架</a>
    </footer>
</div>

<script>
    var manualShare = true;
    mui.init();
    var win = window;
    //监听后退事件
    if (window.parent.backClick) {
        win = window.parent;
        history.pushState(null, null, document.URL);//去除历史记录
        //监听返回
        window.addEventListener("popstate", function (e) {
            window.parent.backClick();
        }, false);
    }

    $(document).ready(function () {
        var ua = window.navigator.userAgent.toLowerCase();//验证是否在微信中打开
        if (!(ua.match(/MicroMessenger/i) == 'micromessenger' || ua.match(/_SQ_/i) == '_sq_')) {
            var html = '<header class="mui-bar mui-bar-nav">\n' +
                '<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>\n' +
                '<h1 class="mui-title">商品详情</h1>\n' +
                '</header>';
            $(".mui_head").html(html);
        }
        getWareDetails();
        getCartCount();
    })

    /**
     * 获取商品详情
     */
    function getWareDetails() {
        $.ajax({
            url: "<%=basePath%>/web/shopWareMobile/getWareDetails",
            data: "token=${token}&wareId=${wareId}&companyId=${companyId}",
            type: "POST",
            success: function (json) {
                if (json.state) {
                    json = json.obj;
                    var shopRewardItemVoList = json.shopRewardItemVoList;
                    if (shopRewardItemVoList && shopRewardItemVoList.length > 0) {
                        $("#rewardIndex").css("display", "");
                        $("#rewardIndex a").text(shopRewardItemVoList[0].memo + " >>");
                        $(shopRewardItemVoList).each(function (i, item) {
                            var html = ' <li class="mui-table-view-cell">' + item.memo + '</li>';
                            $("#rewardList .list").append(html)
                        });
                    }

                    var data = json.sysWare;
                    if (data != null) {
                        //修改父标题
                        if (window.parent) {
                            window.parent.document.title = data.wareNm;
                        }
                        if (!data.putOn) {//如果商品下架
                            $("#footerDivPutOn").css("display", "none");
                            $("#footerDivNoPutOn").css("display", "");
                        }
                        $("#wareNm").text(data.wareNm);
                        var wareDesc = data.wareDesc && data.wareDesc != 'null' ? data.wareDesc : "无";
                        $("#wareDetail").html(wareDesc);

                        //商品是否收藏过
                        var favoriteClass = 'icon-star';
                        if (data.isFavorite)
                            favoriteClass = "favorite icon-xingxing";
                        $(".my-favorite span").addClass(favoriteClass);
                        //----商品价格：start----
                        var defWarePrice, defWareLsPrice, warePrice, wareLsPrice;
                        if (data.defWarePrice)
                            $("#wareDj").text("￥" + data.defWarePrice);
                        if (data.defWareLsPrice && data.defWareLsPrice != data.defWarePrice)
                            $("#lsPrice").text("￥" + data.defWareLsPrice);
                        if (!data.defWarePrice && !data.defWareLsPrice)
                            $("#wareDj").text("￥未设置");
                        //----商品价格：end-----

                        //-----切换单位:start----
                        var dwstr = "";
                        //默认单位
                        var defWarePrice = data.defWarePrice ? data.defWarePrice : "";
                        var defWareLsPrice = data.defWareLsPrice ? data.defWareLsPrice : "";
                        dwstr += "<div unitCode='" + data.defUnitCode + "' warePrice='" + defWarePrice + "' wareLsPrice='" + defWareLsPrice + "'";
                        if (!data.defWareGg) {
                            dwstr += " style='display:none;' ";
                        }
                        dwstr += " class='my-tags-active'>" + data.defWareGg + "</div>";
                        //另一个单位
                        if (data.wareGg) {
                            var warePrice = data.warePrice ? data.warePrice : "";
                            var wareLsPrice = data.wareLsPrice ? data.wareLsPrice : "";
                            dwstr += "<div unitCode='" + data.unitCode + "' warePrice='" + warePrice + "'  wareLsPrice='" + wareLsPrice + "'>" + data.wareGg + "</div>"
                        }
                        $("#tags").html(dwstr);
                        //-----切换单位:end----

                        //------------图片start+分享-----------
                        var shareTitle = data.wareNm;
                        var shareLogo = "<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg";
                        var shareDesc = "商品规格：" + data.defWareGg;

                        var leftWareType = "";
                        var waretypePicList = data.warePicList;
                        if (waretypePicList != null && waretypePicList != undefined && waretypePicList.length > 0) {
                            shareLogo = '<%=basePath%>/upload/' + waretypePicList[0].picMini;

                            leftWareType += "<div class=\"mui-slider-group mui-slider-loop\">";
                            <!-- 额外增加的一个节点(循环轮播：第一个节点是最后一张轮播) -->
                            leftWareType += "<div class=\"mui-slider-item mui-slider-item-duplicate\">";
                            leftWareType += " <a href=\"javascript:;\">";
                            leftWareType += "<img src='<%=basePath%>/upload/" + waretypePicList[waretypePicList.length - 1].picMini + "' >";
                            leftWareType += "</a>";
                            leftWareType += "</div>";
                            for (var i = 0; i < waretypePicList.length; i++) {
                                leftWareType += "<div class='mui-slider-item'>";
                                leftWareType += " <a href=\"javascript:;\">";
                                leftWareType += "<img src='<%=basePath%>/upload/" + waretypePicList[i].picMini + "' >";
                                leftWareType += "</a>";
                                leftWareType += "</div>";
                            }
                            <!-- 额外增加的一个节点(循环轮播：最后一个节点是第一张轮播) -->
                            leftWareType += "<div class=\"mui-slider-item mui-slider-item-duplicate\">";
                            leftWareType += " <a href=\"javascript:;\">";
                            leftWareType += "<img src='<%=basePath%>/upload/" + waretypePicList[0].picMini + "' >";
                            leftWareType += "</a>";
                            leftWareType += "</div>";
                            //外层
                            leftWareType += "</div>";

                            //点
                            leftWareType += "<div class='mui-slider-indicator'>";
                            for (var i = 0; i < waretypePicList.length; i++) {
                                if (i == 0) {
                                    leftWareType += "<div class='mui-indicator mui-active'></div>";
                                } else {
                                    leftWareType += "<div class='mui-indicator'></div>";
                                }
                            }
                            leftWareType += "</div>";
                            //赋值
                            $(".mui-slider").html(leftWareType);

                        } else {
                            //这边其实使用"暂无图片"
                            leftWareType += "<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\"/>";
                            $(".mui-slider").html(leftWareType);
                        }
                        //获得slider插件对象
                        var gallery = mui('.mui-slider');
                        gallery.slider({
                            interval: 0//自动轮播周期，若为0则不自动播放，默认为0；
                        });
                        //------------图片end-----------
                        share(shareTitle, shareDesc, shareLogo);
                    }
                }
            }
        });
    }


    mui("#tags").on('tap', 'div', function () {
        //修改单位代码；价格
        var warePrice = this.getAttribute('warePrice');
        var wareLsPrice = this.getAttribute('wareLsPrice');
        if (warePrice)
            $("#wareDj").text("￥" + warePrice);
        if (wareLsPrice && wareLsPrice !=warePrice)
            $("#lsPrice").text("￥" + wareLsPrice);

        //修改样式
        var $tag = $(this);//js对象转jquery对象
        $tag.siblings().removeClass("my-tags-active");
        $tag.addClass("my-tags-active");
    })

    /**
     * 添加购物车
     */
    function addShopCart(type) {
        var wareNum = $("#wareNum").val();
        var unitCode = $(".my-tags-active").attr("unitCode");
        var warePrice = $(".my-tags-active").attr("warePrice");

        if (!warePrice) {
            mui.toast("此商品还没设置价格");
            return false;
        }
        $.ajax({
            url: "<%=basePath%>/web/shopCart/addShopCartWeb",
            data: {"token": "${token}", "wareId": "${wareId}", "wareNum": wareNum, "beUnit": unitCode, "type": type},
            type: "POST",
            success: function (json) {
                if (json.state) {
                    json = json.obj;
                    if (type) {
                        win.location.href = "<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&cartIds=" + json.cartId + "&companyId=" + getWid();
                        return;
                    }
                    if (json.add) {
                        mui.toast("添加购物车成功");
                        cartcount++;
                        $(".cartcount").html(cartcount);
                        $(".cartcount").show();
                    }
                    if (json.update) {
                        mui.toast("此商品已添加到购物车");
                    }
                } else {
                    if (json.code && json.code == 444) {
                        win.location.href = "<%=basePath%>/web/mainWeb/toWeixinRegister?token=${token}&companyId=" + getWid();
                    } else {
                        mui.toast(json.message);
                    }
                }
            }
        });
    }

    /**
     * 确认订单-界面
     */
    function toFillOrder() {
        addShopCart(1);
    }

    /**
     * 购物车-界面
     */
    function toShoppingCart() {
        win.location.href = "<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}&companyId=" + getWid();
    }

    /**
     * 首页-界面
     */
    function toIndex() {
        win.location.href = "<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}";
    }


    /**
     * 获取购物车数量
     */
    var cartcount = 0;//购物车数据
    function getCartCount() {
        $.ajax({
            url: "<%=basePath%>/web/shopCart/queryShopCartCount",
            data: {"token": "${token}"},
            type: "POST",
            success: function (json) {
                if (json.state) {
                    cartcount = json.obj;
                    if (cartcount === 0) {
                        $(".cartcount").hide();
                    } else {
                        $(".cartcount").html(cartcount);
                        $(".cartcount").show();
                    }
                }
            },
            error: function (data) {
            }
        });
    }

    //分享
    function share(title, desc, logo) {
        var shareData = {
            title: title, // 分享标题
            desc: desc, // 分享描述
            link: getShareLink(), // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: logo, // 分享图标
            success: function () {
            }
        }
        if (window.parent && window.parent.length > 0 && window.parent.changeParentShare) {
            window.parent.changeParentShare(shareData);
        } else {
            wechatShare(shareData);
        }
    }

    //加入收藏
    function addFavorite() {
        var wareId = "${wareId}";
        var spanXing = $(".my-favorite span");

        var url = "";
        var isSave = false;
        var data = {"token": "${token}", "wareId": wareId};
        if ($(spanXing).hasClass("favorite")) {
            url = "<%=basePath%>/web/shopWareFavoriteMobile/deleteWareFavorite";
            data.wareIds = wareId;
        } else {
            url = "<%=basePath%>/web/shopWareFavoriteMobile/addWareFavorite";
            isSave = true;
        }
        $.ajax({
            url: url,
            data: data,
            type: "POST",
            success: function (json) {
                mui.toast(json.message);
                if (json.state) {
                    if (isSave) {
                        $(spanXing).removeClass("icon-star");
                        $(spanXing).addClass("favorite");
                        $(spanXing).addClass("icon-xingxing");
                    } else {
                        $(spanXing).removeClass("favorite");
                        $(spanXing).removeClass("icon-xingxing");
                        $(spanXing).addClass("icon-star");
                    }
                    if (window.parent && window.parent.length > 0 && typeof window.parent.updateFavoriteClass == 'function') {
                        window.parent.updateFavoriteClass(isSave, wareId);
                    }
                }
            }
        });
    }
</script>

</body>
</html>
