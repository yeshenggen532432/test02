<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的收藏</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <style type="text/css">
        body {
            overflow-x: hidden;
            height: 100%;
            /*开启moblie网页快速滚动和回弹的效果*/
            -webkit-overflow-scrolling: touch;
            font-size: 12px;
            font-family: "微软雅黑";
            overflow-x: hidden;
            -webkit-text-size-adjust: none !important;
        }

        * {
            margin: 0;
            padding: 0;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
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

        #menu ul * {
            margin: 0;
            padding: 0;
        }

        #menu ul li {
            width: 25%;
            float: left;
        }

        #menu ul li a {
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

        /*==================tabbar======================*/
        .mui-bar-nav ~ .mui-content {
            padding-bottom: 88px;
        }

        .my-name {
            font-size: 14px;
            font-weight: normal;
            color: #333333;
        }

        .mui-media {
            font-size: 14px;
        }

        .mui-table-view .mui-media-object {
            max-width: initial;
            width: 80px;
            height: 70px;
        }

        .my-dj-price {
            position: absolute;
            left: 125px;
            right: 10px;
            bottom: -5px;
            /*bottom: 5px;*/
            color: #8f8f94;
        }

        .my-dj-price .my-dj {
            display: inline-block;
            color: red;
            vertical-align: middle;
            font-size: 12px;
        }


        .mui-table-view:before,
        .mui-table-view:after {
            height: 0;
        }

        .mui-content > .mui-table-view:first-child {
            margin-top: 1px;
        }

        .mui-table-view-cell.mui-checkbox.mui-left {
            padding-left: 38px;
        }

        .mui-checkbox.mui-left input[type=checkbox] {
            left: 5px;
            right: 5px;
            top: 50%;
            margin-top: -14px;
        }

        .mui-table-view-cell {
            padding-left: 0px;
        }

        .my-content {
        }

        .my-gg-dw {
            position: absolute;
            left: 125px;
            right: 10px;
            top: 25px;
            /*top: 34px;*/
            color: #8f8f94;
        }

        .my-gg-dw .my-gg {
            font-size: 12px;
            color: #666666;
        }

        .mui-numbox {
            width: 100px;
            height: 25px;
            float: right;
            padding: 0 10px;
        }

        .mui-numbox [class*=btn-numbox] {
            font-size: 18px;
            font-weight: 400;
            line-height: 100%;
            position: absolute;
            top: 0;
            overflow: hidden;
            width: 33px;
            height: 100%;
            padding: 0;
            color: #555;
            border: none;
            border-radius: 0;
            background-color: #f9f9f9;
        }

        .my-tags {
            float: right;
        }

        .my-tags > div {
            height: 20px;
            float: left;
            margin: 0 0 0 5px;
            line-height: 20px;
            padding: 0px 10px;
            border-radius: 4px;
            border: 1px solid #3388FF;
            color: #3388FF;
            font-size: 12px;
        }

        .my-tags-active {
            background: #3388FF !important;
            color: #FFFFFF !important;
        }

        .my-footer {
            position: fixed;
            bottom: 44px;
            left: 0;
            right: 0;
            height: 44px;
        }

        .my-allcheck {
            display: inline-block;
            width: 75px;
            height: 100%;
        }

        .my-checkbox {
            display: inline-block;
            width: 40px;
            height: 70px;
        }

        .my-checkbox input[type=checkbox] {
            top: 50%;
            margin-top: -14px;
            right: 7px;
        }

        .my-allcheck input[type=checkbox] {
            top: 6px;
            right: 7px;
        }

        .mui-checkbox.mui-left label {
            padding-right: 10px;
            padding-left: 35px;
            padding-top: 10px;
            font-size: 12px;
            color: #666666;
        }

        .mui-btn {
            height: 100%;
        }

        .my-sum-money {
            font-size: 14px;
            color: red;
        }

        .mui-select-reward {
            padding: 0px;
            width: 100%;
            float: right;
            line-height: 25px;
            font-size: 14px;
            height: 25px;
        }

        .reward-first-li {
            border-top: dashed 1px #afab15;
            border-left: dashed 1px #afab15;
            border-right: dashed 1px #afab15;
        }

        .reward-botton-li {
            border-left: dashed 1px #afab15;
            border-right: dashed 1px #afab15;
        }

        .reward-last-li {
            border-left: dashed 1px #afab15;
            border-right: dashed 1px #afab15;
            border-bottom: dashed 1px #afab15;
        }
    </style>


</head>
<!-- --------body开始----------- -->
<body>

<header class="mui-bar mui-bar-nav">
    <h1 class="mui-title">我的收藏</h1>
    <a id="delCart" class="mui-icon mui-icon-trash mui-pull-right"></a>
</header>
<div class="mui-content">
    <div class="empty" style="display: none;">
        <div class="e_content">
            <span>收藏夹空空如也，</span>

            <a href="javascript:toPage('<%=basePath%>/web/mainWeb/wareType.html?token=${token}')" class="e_btn">去收藏</a>
        </div>
    </div>
    <ul class="mui-table-view" id="list">
    </ul>
</div>

<div class="mui-table-view my-footer">
    <div class="mui-checkbox mui-left my-allcheck">
        <input name="checkbox1" type="checkbox" id="allcheck">
        <label for="allcheck">全选</label>
    </div>
    <%--<span class="my-sum-money">合计:￥0.00</span>--%>
    <div class="mui-pull-right" style="margin: 5px;">
        <button type="button" class="mui-btn mui-btn-primary " onclick="javascript:addCarts(1);">立即下单
        </button>&nbsp;&nbsp;
        <button type="button" class="mui-btn mui-btn-primary-addCart mui-pull-right" onclick="javascript:addCarts(0);">加购物车
        </button>
    </div>
</div>

<div id="menu">
    <ul>
        <%--<li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}"><font class="iconfont">&#xe612;</font><span
                class="inco_txt">首页</span></a></li>
        <li><a href="<%=basePath %>/web/mainWeb/wareType.html?token=${token}"><font
                class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
        <li><a href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}&companyId=${companyId}"><font
                class="iconfont">&#xe63e;</font><span
                class="inco_txt">购物车</span></a></li>
        <li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}"><font class="iconfont">&#xe62e;</font><span
                class="inco_txt">我的</span></a></li>--%>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}')"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/wareType.html?token=${token}')"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}')"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
            <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toMyInfo?token=${token}')"><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
    </ul>
</div>

<script>
    mui.init();

    $(document).ready(function () {
        //$.wechatShare();//分享
        queryWareFavoriteList();
        $("#allcheck").prop("checked", false);
    })

    //批量删除收藏
    mui('header').on('tap', '#delCart', function (e) {
        var chxVals = document.getElementsByName("checkbox");
        var wareIds = "";
        for (var i = 0; i < chxVals.length; i++) {
            if (chxVals[i].checked) {
                var wareId = chxVals[i].getAttribute("wareId");
                if (wareIds != "")
                    wareIds += ",";
                wareIds += wareId;
            }
        }
        if (wareIds == "") {
            mui.alert("请选择所要移出收藏的商品");
            return;
        }

        mui.confirm('确认移出收藏记录？', '温馨提示', ['取消', '确认'], function (e) {
            if (e.index == 1) {
                console.log("cartIds:" + wareIds);
                deleteWareFavorite(wareIds);
            } else {
                setTimeout(function () {
                    //$.swipeoutClose(li);
                }, 0);
            }
        });
    });

    //删除购物车
    $('#list').on('tap', '.mui-btn-red', function (event) {
        var elem = this;
        mui.confirm('确认移出收藏记录？', '温馨提示', ['取消', '确认'], function (e) {
            if (e.index == 1) {
                //从数据库删除购物车
                var wareId = elem.getAttribute("wareId");
                deleteWareFavorite(wareId);
            }
        });
    });

    //大小单位切换
    mui("#list").on('tap', '.my-tags div', function (e) {
        var warePrice = this.getAttribute('warePrice');
        var warePriceText = "暂无";
        if (warePrice) {
            warePriceText = warePrice;
        }
        $(this).parents(".my-content").find(".my-dj").text("￥" + warePriceText);

        //修改样式
        var $tag = $(this);//js对象转jquery对象
        $tag.siblings().removeClass("my-tags-active");
        $tag.addClass("my-tags-active");
    })

    //全选
    mui('.my-allcheck').on('change', 'input', function () {
        $("[name='checkbox']").prop("checked", this.checked);
    });


    /**
     * 添加购物车
     */
    mui("#list").on("tap", "a.my-cart-item", function () {
        var wareGg = $(this).parents("li").find(".my-tags-active");
        var warePrice = $(wareGg).attr("warePrice");
        if (!warePrice || warePrice == "undefined") {
            mui.alert("此商品还没设置价格");
            return false;
        }
        var wareId = $(wareGg).attr("wareId");
        var beUnit = $(wareGg).attr("beUnit");
        var cartId = addCart(wareId, beUnit,0);
        if (cartId) {
            mui.toast("加入成功");
        } else {
            mui.toast("加入失败");
        }
        event.stopPropagation();
    })

    function addCart(wareId, beUnit,type) {
        var cartId = "";
        $.ajax({
            url: "<%=basePath%>/web/shopCart/addShopCartWeb",
            data: {"token": "${token}", "wareId": wareId, "wareNum": 1, "beUnit": beUnit,"type":type},
            type: "POST",
            async: false,
            success: function (json) {
                if (json.state) {
                    cartId = json.obj.cartId;
                }
            }
        });
        return cartId;
    }


    //获取购物车列表
    function queryWareFavoriteList() {
        $("#list").html("");
        $.ajax({
            url: "<%=basePath%>/web/shopWareFavoriteMobile/queryWareFavoritePage",
            data: "token=${token}",
            type: "POST",
            success: function (json) {
                if (json.state) {
                    var datas = json.obj.rows;
                    var str = "";
                    if (datas != null && datas != undefined && datas.length > 0) {
                        for (var i = 0; i < datas.length; i++) {
                            var data = datas[i];
                            var wareId = data.wareId;//商品id

                            str += "<li class='mui-table-view-cell mui-media' name='cartLi' >";
                            str += "<div class='mui-slider-right mui-disabled' >";
                            str += "<a class='mui-btn mui-btn-red' wareId='" + wareId + "'>移出</a>";
                            str += "</div>";
                            str += "<div class='mui-slider-handle' >";

                            str += "<div class='mui-checkbox mui-pull-left  my-checkbox'>";
                            str += "<input type='checkbox' name='checkbox' wareId='" + wareId + "'>";
                            str += "</div>";

                            var warePicList = data.defWarePic;
                            var sourcePath = "<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg";
                            if (warePicList)
                                sourcePath = "<%=basePath%>/upload/" + warePicList.picMini;
                            str += "<img class='mui-media-object mui-pull-left' src='" + sourcePath + "' wareId='" + wareId + "'>";

                            str += "<div class='my-content mui-clearfix' >";
                            str += "<h4 class=\"my-name mui-ellipsis\">" + data.wareNm + "</h4>";
                            str += "<div class=\"my-gg-dw\">";
                            str += "<div class=\"my-tags mui-clearfix\">";

                            //-----------单位相关：start----------------
                            var defWarePrice = data.defWarePrice ? data.defWarePrice : "";
                            var defWareLsPrice = data.defWareLsPrice ? data.defWareLsPrice : "";
                            str += "<div beUnit='" + data.defUnitCode + "' warePrice='" + defWarePrice + "' wareId='" + wareId + "' wareLsPrice='" + defWareLsPrice + "'";
                            str += "  class='my-tags-active' ";
                            str += ">" + data.defWareGg + "</div>";
                            //另一个单位
                            if (data.wareGg) {
                                var warePrice = data.warePrice ? data.warePrice : "";
                                var wareLsPrice = data.wareLsPrice ? data.wareLsPrice : "";
                                str += "<div beUnit='" + data.unitCode + "' warePrice='" + warePrice + "' wareId='" + wareId + "' wareLsPrice='" + wareLsPrice + "'";
                                str += ">" + data.wareGg + "</div>"
                            }
                            //-----------单位相关：end----------------

                            str += "</div>";
                            str += "</div>";
                            str += "<div class='my-dj-price'>";


                            var selectWarepriceText = "";
                            if (!defWarePrice) selectWarepriceText = "暂无";
                            if (!data.putOn) {
                                selectWarepriceText = "已下架";

                            }
                            //------------价格相关：start----------------
                            str += "<div class='my-dj'>￥" + defWarePrice + selectWarepriceText + "</div>";
                            //------------价格相关：end----------------

                            //str += "<div class='mui-numbox' data-numbox-min='1'>";
                            //str += "<button class='mui-btn mui-btn-numbox-minus' type='button' onclick='onReduce(" + 0 + ");'>-</button>";
                            str += '<a href="javascript:;" class="mui-pull-right my-cart-item"><span class="mui-icon iconfont icon-gouwuche1"></span></a>';
                            //str += "<button class='mui-btn mui-btn-numbox-plus' type='button' onclick='onPlus(" + 0 + ");'>+</button>";
                            //str += "</div>";
                            str += "</div>";
                            str += "</div>";
                            str += "</div>";
                            str += "</li>";
                        }
                        $("#list").html(str);
                    }else{
                        $(".empty").css("display","");
                    }
                }
            },
            error: function (data) {
            }
        });
    }

    //获取购物车列表
    function deleteWareFavorite(wareIds) {
        $.ajax({
            url: "<%=basePath%>/web/shopWareFavoriteMobile/deleteWareFavorite",
            data: {"token": "${token}", "wareIds": wareIds},
            type: "POST",
            success: function (json) {
                mui.toast(json.message);
                if (json.state) {
                    queryWareFavoriteList();
                }
            },
            error: function (json) {
            }
        });
    }

    //跳转：下单界面 使用购物车ID提交zzx
    function addCarts(type) {
        var objs=[];
        $("[type=checkbox]:checked").each(function (i,item) {
            if($(this).attr("wareid")){
                var wareGg = $(this).parents("li").find(".my-tags-active");
                var warePrice = $(wareGg).attr("warePrice");
                if (warePrice) {
                    var wareId = $(wareGg).attr("wareId");
                    var beUnit = $(wareGg).attr("beUnit");
                    var obj={};
                    obj.wareId=wareId;
                    obj.beUnit=beUnit;
                    objs.push(obj)
                }
            }
        })

        if (objs.length==0) {
            mui.alert("请选择所要购买的商品");
            return;
        }

       /* var text=$(".mui-btn-primary-addCart").text();
        mui(".mui-btn-primary-addCart").button("loading");
        $(".mui-btn-primary-addCart").attr("disabled",true);*/

       var cartIds=[];
        $(objs).each(function (i,item) {
            var cartId = addCart(item.wareId, item.beUnit,type);
            if (cartId) {
                cartIds.push(cartId);
                mui.toast("加入成功");
            } else {
                mui.toast("加入失败");
            }
        });
        if(cartIds.length>0&&type==1)
            window.location.href = "<%=basePath%>/web/mainWeb/toShoppingCart?token=${token}&cartIds="+cartIds.join(",");
        /*$(".mui-btn-primary-addCart").text(text);
        $(".mui-btn-primary-addCart").attr("disabled",false);*/

    }
    /**
     * 商品详情
     */
    mui("#list").on('tap', '.mui-media-object', function () {
        var wareId = this.getAttribute('wareId');
        window.location.href = "<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId=" + wareId;
    })
</script>
</body>

</html>
