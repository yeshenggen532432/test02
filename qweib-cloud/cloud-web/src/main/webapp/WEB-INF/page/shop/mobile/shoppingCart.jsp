<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>购物车中心</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp" %>
    <%--<title>收货地址</title>--%>
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

        .my-dj-num {
            position: absolute;
            left: 125px;
            right: 10px;
            bottom: -5px;
            /*bottom: 5px;*/
            color: #8f8f94;
        }

        .my-dj-num .my-dj {
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
    <c:if test="${!empty cartIds}"><%--只有从收藏过来的才有返回--%>
        <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    </c:if>
    <h1 class="mui-title">购物车</h1>
    <a id="delCart" class="mui-icon mui-icon-trash mui-pull-right"></a>
</header>
<div class="mui-content">
    <ul class="mui-table-view" id="list">

        <%--        <li class="mui-table-view-cell mui-media" >
                    <div class="mui-slider-right mui-disabled">
                        <a class="mui-btn mui-btn-red">删除</a>
                    </div>
                    <div class="mui-slider-handle">
                        <div class="mui-checkbox mui-pull-left  my-checkbox">
                            <input type="checkbox" id="check">
                        </div>
                        <img class="mui-media-object mui-pull-left" src="images/60x222260.gif">
                        <div class="my-content mui-clearfix">
                            <h4 class="my-name mui-ellipsis">青岛啤酒</h4>
                            <div class="my-gg-dw">
                                <span class="my-gg">规格：500*24</span>
                                <div class="my-tags mui-clearfix">
                                    <div >件</div>
                                    <div >箱</div>
                                </div>
                            </div>
                            <div class="my-dj-num">
                                <div class="my-dj">￥999</div>
                                <div class="mui-numbox" data-numbox-min='1' data-numbox-max='9'>
                                    <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
                                    <input class="mui-input-numbox" type="number" value="5" />
                                    <button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>--%>

    </ul>

</div>


<div class="mui-table-view my-footer">
    <div class="mui-checkbox mui-left my-allcheck">
        <input name="checkbox1" type="checkbox" id="allcheck">
        <label for="allcheck">全选</label>
    </div>
    <span class="my-sum-money">合计:￥0.00</span>
    <button type="button" class="mui-btn mui-btn-primary mui-pull-right" onclick="javascript:toFillOrder();">去结算
    </button>
</div>

<div id="menu">
    <ul>
        <%-- <li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}"><font class="iconfont">&#xe612;</font><span
                 class="inco_txt">首页</span></a></li>
         <li><a href="<%=basePath %>/web/mainWeb/wareType.html?token=${token}"><font
                 class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
         <li><a class="red"><font class="iconfont" style="color: #3388FF;">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
         <li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}"><font class="iconfont">&#xe62e;</font><span
                 class="inco_txt">我的</span></a></li>--%>
        <li>
            <a href="javascript:toPage('<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}')"><font
                    class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
        <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/wareType.html?token=${token}')"><font
                class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
        <li><a class="red"><font class="iconfont" style="color: #3388FF;">&#xe63e;</font><span
                class="inco_txt">购物车</span></a></li>
        <li><a href="javascript:toPage('<%=basePath %>/web/mainWeb/toMyInfo?token=${token}')"><font class="iconfont">&#xe62e;</font><span
                class="inco_txt">我的</span></a></li>
    </ul>
</div>

<script>
    mui.init();

    $(document).ready(function () {
        //$.wechatShare();//分享
        getShopCartList();
        $("#allcheck").prop("checked", false);
    })

    //批量删除购物车
    mui('header').on('tap', '#delCart', function (e) {
        var chxVals = document.getElementsByName("checkbox");
        var cartIds = "";
        for (var i = 0; i < chxVals.length; i++) {
            if (chxVals[i].checked) {
                var cartId = chxVals[i].getAttribute("cartId");
                if (cartIds == "") {
                    cartIds = cartId;
                } else {
                    cartIds += "," + cartId;
                }
            }
        }
        if (cartIds == "") {
            mui.alert("请选择所要购买的商品");
            return;
        }

        mui.confirm('确认删除该记录？', '温馨提示', ['取消', '确认'], function (e) {
            if (e.index == 1) {
                console.log("cartIds:" + cartIds);
                delShopCart(cartIds);
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
        mui.confirm('确认删除该条记录？', '温馨提示', ['取消', '确认'], function (e) {
            if (e.index == 1) {
                //从数据库删除购物车
                var cartId = elem.getAttribute("cartId");
                delShopCart(cartId);
            } else {
                setTimeout(function () {
                    //$.swipeoutClose(elem);
                }, 0);
            }
        });
    });

    //大小单位切换
    mui("#list").on('tap', '.my-tags div', function (e) {
        //修改单位代码；价格
        var cartId = $(this).parents(".mui-table-view-cell").attr("cartId");
        var warePrice = this.getAttribute('warePrice');
        if (warePrice) {
            $("#warePrice_" + cartId).text("￥" + warePrice);
            $("#warePrice_" + cartId).attr("warePrice", warePrice);
        } else
            $("#warePrice_" + cartId).text("￥暂无");

        //修改样式
        var $tag = $(this);//js对象转jquery对象
        $tag.siblings().removeClass("my-tags-active");
        $tag.addClass("my-tags-active");
        updateCartData(cartId);
    })


    mui('#list').on('input', 'input[type=number]', function () {
        var value = mui($(this).closest('.mui-numbox')).numbox().getValue();
        if (value == null || value == undefined || value == NaN) {
            return;
        }
        updateCartData();
    });

    //单个商品选择时
    mui('#list').on('change', 'input[type=checkbox]', function () {
        sumZje($(this).attr("cartid"));
    });

    //全选
    mui('.my-allcheck').on('change', 'input', function () {
        $("[name='checkbox']").prop("checked", this.checked);
        sumZje();//总金额
    });


    //获取购物车列表
    function getShopCartList() {
        $.ajax({
            url: "<%=basePath%>/web/shopCart/queryShopCartListWeb",
            data: {"token": "${token}", "cartIds": "${cartIds}"},
            type: "POST",
            success: function (json) {
                if (!json.state) {
                    mui.alert(json.message);
                    return false;
                }
                var datas = json.obj;
                if (!datas || datas.length == 0) {
                    toPage("/web/mainWeb/emptyShopping?token=${token}");
                    return;
                }
                var str = "";
                for (var i = 0; i < datas.length; i++) {
                    var data = datas[i];
                    var cartId = data.shopCart.id;//购物车id
                    var wareId = data.wareId;//商品id
                    /*var beUnit=datas[i].beUnit;//大单位或小单位的代码
                    var minUnitCode=datas[i].minUnitCode;//小单位的代码
                    var minUnit = datas[i].minWareGg+datas[i].minUnit;//小单位
                    var maxUnitCode=datas[i].maxUnitCode;//大单位的代码
                    var wareDw = datas[i].wareGg+datas[i].wareDw;//大单位
                    var shopPfPrice = datas[i].shopWarePrice;//大单位
                    var shopLsPrice = datas[i].shopWareLsPrice;
                    var shopCxPrice = datas[i].shopWareCxPrice;
                    var minShopPfPrice = datas[i].shopWareSmallPrice;
                    var minShopLsPrice = datas[i].shopWareSmallLsPrice;
                    var minShopCxPrice = datas[i].shopWareSmallCxPrice;
                    // var wareDj=datas[i].wareDj;//价格
                    var hsNum=datas[i].hsNum;//换算
                    var flag = true;//默认选中大单位
                    //小单位
                    if(beUnit!=null && beUnit!=undefined && beUnit==minUnitCode){
                        flag = false;
                    }*/

                    str += "<li class='mui-table-view-cell mui-media' cartId='" + cartId + "' name='cartLi' >";
                    str += "<div class='mui-slider-right mui-disabled' >";
                    str += "<a class='mui-btn mui-btn-red' cartId='" + cartId + "'>删除</a>";
                    str += "</div>";
                    str += "<div class='mui-slider-handle' >";

                    str += "<div class='mui-checkbox mui-pull-left  my-checkbox'>";
                    str += "<input type='checkbox' name='checkbox' cartId='" + cartId + "' wareId='" + wareId + "'>";
                    str += "</div>";

                    var warePicList = datas[i].defWarePic;
                    var sourcePath = "<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg";
                    if (warePicList)
                        sourcePath = "<%=basePath%>/upload/" + warePicList.picMini;
                    str += "<img class='mui-media-object mui-pull-left' src='" + sourcePath + "' wareId='" + wareId + "'>";

                    str += "<div class='my-content mui-clearfix' >";
                    str += "<h4 class=\"my-name mui-ellipsis\">" + datas[i].wareNm + "</h4>";
                    str += "<div class=\"my-gg-dw\">";
                    //str += "<span class=\"my-gg\">规格:"+datas[i].wareGg+"</span>";
                    str += "<div class=\"my-tags mui-clearfix\">";
                    //-----------单位相关：start----------------
                    var selectUnit = data.shopCart.beUnit;//用户选中单位
                    var selectWareprice = "";//用户选择规格价格
                    var defWarePrice = data.defWarePrice ? data.defWarePrice : "";
                    var defWareLsPrice = data.defWareLsPrice ? data.defWareLsPrice : "";
                    str += "<div unitCode='" + data.defUnitCode + "' warePrice='" + defWarePrice + "' cartId='" + cartId + "' wareLsPrice='" + defWareLsPrice + "'";
                    if (selectUnit == data.defUnitCode) {
                        str += "  class='my-tags-active' ";
                        selectWareprice = defWarePrice;
                    }
                    if (!data.defWareGg) {
                        str += " style='display:none;' ";
                    }
                    str += ">" + data.defWareGg + "</div>";
                    //另一个单位
                    if (data.wareGg) {
                        var warePrice = data.warePrice ? data.warePrice : "";
                        var wareLsPrice = data.wareLsPrice ? data.wareLsPrice : "";
                        str += "<div unitCode='" + data.unitCode + "' warePrice='" + warePrice + "' cartId='" + cartId + "' wareLsPrice='" + wareLsPrice + "'";
                        if (selectUnit == data.unitCode) {
                            str += "  class='my-tags-active' ";
                            selectWareprice = warePrice;
                        }
                        str += ">" + data.wareGg + "</div>"
                    }
                    //-----------单位相关：end----------------

                    str += "</div>";
                    str += "</div>";
                    str += "<div class='my-dj-num'>";


                    var selectWarepriceText = selectWareprice;
                    if (!selectWarepriceText) selectWarepriceText = "暂无";
                    if (!data.putOn) {
                        selectWareprice = "";
                        selectWarepriceText = "已下架";

                    }
                    //------------价格相关：start----------------
                    str += "<div class='my-dj' id='warePrice_" + cartId + "' warePrice='" + selectWareprice + "'>￥" + selectWarepriceText + "</div>";
                    //------------价格相关：end----------------

                    str += "<div class='mui-numbox' data-numbox-min='1'>";
                    str += "<button class='mui-btn mui-btn-numbox-minus' type='button' onclick='onReduce(" + cartId + ");'>-</button>";
                    str += "<input  class='mui-input-numbox' type='number' value='" + datas[i].shopCart.wareNum + "' id='wareNum_" + cartId + "'  onchange='updateNum(" + cartId + ",this);'/>";
                    str += "<button class='mui-btn mui-btn-numbox-plus' type='button' onclick='onPlus(" + cartId + ");'>+</button>";
                    str += "</div>";
                    str += "</div>";
                    str += "</div>";
                    str += "</div>";
                    str += "</li>";
                }
                $("#list").html(str);
                if ("${cartIds}") {
                    $("#allcheck").click();
                }
            },
            error: function (data) {
            }
        });
    }

    //获取购物车列表
    function delShopCart(cartIds) {
        $.ajax({
            url: "<%=basePath%>/web/shopCart/deleteShopCartById",
            data: {"token": "${token}", "ids": cartIds},
            type: "POST",
            success: function (json) {
                if (json.state) {
                    var cartLis = document.getElementsByName("cartLi");
                    var removeList = [];
                    for (var i = 0; i < cartLis.length; i++) {
                        var li = cartLis[i];
                        var cartId = li.getAttribute("cartId");
                        console.log("cartId:" + cartId);
                        console.log("carIds:" + cartIds);
                        if (cartIds.indexOf(cartId) != -1) {
                            removeList.push(li);
                        }
                    }
                    for (var i = 0; i < removeList.length; i++) {
                        var li = removeList[i];
                        li.parentNode.removeChild(li);
                    }
                    sumZje(cartIds);
                }
            },
            error: function (json) {
            }
        });
    }

    //加
    function onPlus(cartId) {
        console.log("onPlus=" + $("#wareNum_" + cartId).val());
        var wareNum = $("#wareNum_" + cartId).val()
        wareNum = parseInt(wareNum) + 1;
        //$("#wareNum_" + cartId).val(wareNum);
        $("#wareNum_" + cartId).attr("value", wareNum);
        updateCartData(cartId);//总金额
        console.log("onPlus1=" + $("#wareNum_" + cartId).val());
    }

    //减
    function onReduce(cartId) {
        console.log(00);
        var wareNum = $("#wareNum_" + cartId).val()
        if (1 == parseInt(wareNum)) {
            return;
        }
        wareNum = parseInt(wareNum) - 1;
        //$("#wareNum_" + cartId).val(wareNum);
        $("#wareNum_" + cartId).attr("value", wareNum);
        ///$("#wareNum_" + cartId).val(wareNum);
        updateCartData(cartId);//总金额
    }

    //手动修改数量
    function updateNum(cartId, th) {
        console.log("updateNum=" + $("#wareNum_" + cartId).val());
        $("#wareNum_" + cartId).attr("value", $("#wareNum_" + cartId).val());
        updateCartData(cartId);//总金额
        console.log("updateNum1=" + $("#wareNum_" + cartId).val());
    }

    //修改数量或切换大小单位时同步到数据库
    function updateCartData(cartId) {
        if (cartId) {
            var wareNum = $("#wareNum_" + cartId).val();
            if (!wareNum) return;
            var beUnit = $(".my-tags-active[cartid=" + cartId + "]").attr("unitCode");
            $.post("/web/shopCart/updateShopCartNumById", {
                "token": "${token}",
                "id": cartId,
                "wareNum": wareNum,
                "beUnit": beUnit
            }, function (data) {
                if (!data.state) {
                    mui.alert(data.message);
                } else {
                    if ($("[name=checkbox][cartid=" + cartId + "]").prop("checked"))
                        sumZje(cartId);
                }
            });
        }
    }

    //统计总金额
    function sumZje(opCartId) {
        var chxVals = document.getElementsByName("checkbox");
        var zje = 0.0;
        var cartIds = "";
        for (var i = 0; i < chxVals.length; i++) {
            if (chxVals[i].checked) {
                var cartId = chxVals[i].getAttribute("cartId");
                chxVals[i].setAttribute("checked", true);
                var wareNum = $("#wareNum_" + cartId).val();
                var warePrice = $("#warePrice_" + cartId).attr("warePrice");
                if (warePrice)
                    zje += parseFloat(wareNum) * parseFloat(warePrice);
                if (cartIds) cartIds += ",";
                cartIds += cartId;
            }
        }
        //获取促销活动
        getReward(cartIds, opCartId);
        $(".my-sum-money").text("合计:￥" + zje.toFixed(2));
    }

    var getReward_look = false;

    //根据购物车IDS获取对应的促销活动
    function getReward(cartIds, opCartId) {
        //$(".mui-select-reward").fadeOut();//移除所有活动
        $(".mui-select-reward").remove();//移除所有活动
        $(".mui-media").removeClass("reward-first-li");
        $(".mui-media").removeClass("reward-last-li");
        $(".mui-media").removeClass("reward-botton-li");
        if (!cartIds || getReward_look) {
            console.log('拦截请求');
            return;
        }
        getReward_look = true;
        $.post("/web/shopBforderMobile/getReward", {"token": "${token}", "cartIds": cartIds}, function (data) {
            if (data && data.state && data.obj) {
                var array = data.obj;
                if (!array) return;
                for (var i = 0; i < array.length; i++) {
                    var prArrary = array[i];
                    var cartIds = prArrary.cartIds;//购物车IDS
                    var rewards = prArrary.rewards;//对应的促销活动
                    var html = "";
                    if (rewards && rewards.length > 0) {
                        html = "<span class='mui-select-reward' style='display:none;'><select name='reward' id='weard_" + cartIds[0] + "'  onchange='changhReward()'>";
                        for (var j = 0; j < rewards.length; j++) {
                            var obj = rewards[j];
                            html += '<option cartIds="' + cartIds + '" itemId="' + obj.id + '"  rewardId="' + obj.rewardId + '" activityType="' + obj.activityType + '" rewardType="' + obj.rewardType + '" rewardMode="' + obj.rewardMode + '" meetAmount="' + obj.meetAmount + '" cash="' + obj.cash + '" discount="' + obj.discount + '">' + obj.memo + '</option>';
                        }
                        html += "</select></span>";
                        if (cartIds && cartIds.length == 1) {//如果是单个商品时直接在头上加入促销规则,否则需要把同类别商品移到一起
                            $(".mui-media[cartid=" + cartIds[0] + "]").before(html);
                        } else {//多个商品同时合并产生促销时
                            var firstObj = $(".mui-media[cartid=" + cartIds[0] + "]");
                            $(firstObj).addClass("reward-first-li");
                            $(firstObj).before(html);//加入活动规则
                            //把其它同一规则的商品移到对应下面成一组
                            var chileHtml = "";
                            for (var j = 1; j < cartIds.length; j++) {
                                var selfLi = $(".mui-media[cartid=" + cartIds[j] + "]");
                                if (j == cartIds.length - 1)
                                    $(selfLi).addClass("reward-last-li");
                                else
                                    $(selfLi).addClass("reward-botton-li");
                                chileHtml += $(selfLi).prop("outerHTML");
                                $(".mui-media[cartid=" + cartIds[j] + "]").remove();
                            }
                            //$(firstObj).fadeIn();
                            $(firstObj).after(chileHtml);
                        }
                    }
                    $(".mui-select-reward").fadeIn(500);//淡入促销活动
                    //reRewardSumZje(obj.rewardType,obj.rewardMode,obj.meetAmount,obj.cash,obj.discount,zje);
                }
            }
            changhReward();
            getReward_look = false;
        });
    }

    //促销活动改变时重新计算金额
    function changhReward() {
        var chxVals = document.getElementsByName("checkbox");
        var zje = 0.0;
        var origPrice = 0.0;
        var rewardCartIds = [];
        for (var i = 0; i < chxVals.length; i++) {
            if (chxVals[i].checked) {
                var cartId = chxVals[i].getAttribute("cartId");
                var weard_ = $("#weard_" + cartId);
                if (weard_ && $(weard_).length) {
                    var rewardAmount = 0.0, rewardNum = 0.0;
                    ;
                    var rewardOption = $(weard_).find("option:selected");
                    var cartIds = $(rewardOption).attr("cartIds");
                    var arr = cartIds.split(",");
                    rewardCartIds = arr;
                    for (var a = 0; a < arr.length; a++) {
                        var roCartId = arr[a];
                        var wareNum = $("#wareNum_" + roCartId).val();
                        var warePrice = $("#warePrice_" + roCartId).attr("warePrice");
                        if (warePrice)
                            rewardAmount += parseFloat(wareNum) * parseFloat(warePrice);
                        rewardNum += parseFloat(wareNum);
                    }
                    origPrice += rewardAmount;
                    zje += reRewardSumZje(rewardOption.attr("activityType"), rewardOption.attr("rewardType"), rewardOption.attr("rewardMode"), rewardOption.attr("meetAmount"), rewardOption.attr("cash"), rewardOption.attr("discount"), rewardAmount, rewardNum);
                } else {
                    if (rewardCartIds && rewardCartIds.length > 0) {
                        var isExistsReward = false;
                        for (var a = 0; a < rewardCartIds.length; a++) {
                            if (rewardCartIds[a] == cartId) {//如果存在促销规则时全部走规则
                                isExistsReward = true;
                                break;
                            }
                        }
                        if (isExistsReward) {
                            continue;
                        } else {
                            rewardCartIds = [];
                        }
                    }
                    var wareNum = $("#wareNum_" + cartId).val();
                    var warePrice = $("#warePrice_" + cartId).attr("warePrice");
                    if (warePrice) {
                        var goodsAmount = parseFloat(wareNum) * parseFloat(warePrice);
                        zje += goodsAmount;
                        origPrice += goodsAmount;
                    }
                }
            }
        }

        /*$(rewardOption).each(function (i,option) {
            var cartIds=$(option).attr("cartIds")
            var ss=cartIds.split(",");
            var rewardAmount=0.0;
            for(var cartId in ss){
                var wareNum = $("#wareNum_" + cartId).val();
                var warePrice = $("#warePrice_" + cartId).attr("warePrice");
                if (warePrice)
                    rewardAmount += parseFloat(wareNum) * parseFloat(warePrice);
            }
            reRewardSumZje(obj.attr("rewardType"), obj.attr("rewardMode"), obj.attr("meetAmount"), obj.attr("cash"), obj.attr("discount"), rewardAmount);
        })*/
        var html = "";
        if (origPrice != zje) {
            html = "<del style='font-size:12px'>" + origPrice.toFixed(2) + "</del> ";
        }
        $(".my-sum-money").html("合计:￥" + html + zje.toFixed(2));
        //reRewardSumZje(obj.attr("rewardType"), obj.attr("rewardMode"), obj.attr("meetAmount"), obj.attr("cash"), obj.attr("discount"), zje);
    }

    //计算促销后金额
    function reRewardSumZje(activityType, rewardType, rewardMode, meetAmount, cash, discount, zje, num) {
        //rewardType 0阶梯优惠1,循环优惠
        //rewardMode 订单优惠类型 0无优惠 1减现金2打折
        var amount = 0.0;
        if (rewardType == 0) {
            if (rewardMode == 1 && cash) {
                amount = zje - cash;
            } else if (rewardMode == 2 && discount) {
                amount = zje * discount / 100;
            }
        } else {
            //类型,0满N件减/送,1满N元减/送
            if (activityType && activityType == 1) {
                var count = parseInt(zje / meetAmount);
                amount = zje - count * cash;
            } else {
                var count = parseInt(num / meetAmount);
                amount = zje - count * cash;
            }
        }
        if (amount == 0) return zje;
        return amount;
    }

    //跳转：下单界面
    /*  function toFillOrder(){
          var cartIds = "";
          $("[name=checkbox]:checked").each(function(i,item){
              if(cartIds)cartIds+=",";
              cartIds+=$(this).attr("cartid");
          });
          if(!cartIds){
              mui.alert("请选择所要购买的商品");
              return;
          }
          window.location.href="<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&cartIds="+cartIds;
    }*/


    /*//跳转：下单界面
    function toFillOrder(){
        var chxVals = document.getElementsByName("checkbox");
        var wareIds = "";
        var wareNums = "";
        var beUnits = "";//计量单位s
        var flag=false;
        for(var i=0;i<chxVals.length;i++){
            if(chxVals[i].checked){
                flag=true;
                var wareId = chxVals[i].getAttribute("wareId");
                var cartId = chxVals[i].getAttribute("cartId");
                var wareNumVal=$("#wareNum_"+cartId).val();
                if(!$(".my-tags-active")[i]){
                    var muihandle=$(chxVals).parents(".mui-slider-handle");
                    mui.alert("请选择所要购买商品规格");
                    return;
                }
                var beUnit=$(".my-tags-active")[i].getAttribute("value");
                if(wareIds == ""){
                    wareIds=wareId;
                    wareNums=wareNumVal;
                    beUnits = beUnit;
                }else{
                    wareIds += ","+wareId;
                    wareNums += ","+wareNumVal;
                    beUnits += ","+beUnit;
                }
            }
        }

        if(!flag){
            mui.alert("请选择所要购买的商品");
            return;
        }
        window.location.href="<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&wareIds="+wareIds+"&wareNums="+wareNums+"&beUnits="+beUnits+"&type=2";
    }*/

    //跳转：下单界面 使用购物车ID提交zzx
    function toFillOrder() {
        var chxVals = document.getElementsByName("checkbox");
        var cartIds = "";
        for (var i = 0; i < chxVals.length; i++) {
            if (chxVals[i].checked) {
                var cartId = chxVals[i].getAttribute("cartId");
                if ($("#warePrice_" + cartId).attr("wareprice")) {
                    if (cartIds) cartIds += ",";
                    cartIds += cartId;
                }
            }
        }
        if (!cartIds) {
            mui.alert("请选择所要购买的商品");
            return;
        }
        var rewardItemIds = "";
        $("[name=reward]").each(function () {
            var option = $(this).find("option:selected");
            var itemId = $(option).attr("itemId");
            if (itemId && itemId != '0') {
                if (rewardItemIds) rewardItemIds += ",";
                rewardItemIds += $(option).attr("itemId");
            }
        });

        toPage("<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&cartIds=" + cartIds + "&rewardItemIds=" + rewardItemIds);
    }

    /**
     * 商品详情
     */
    mui("#list").on('tap', '.mui-media-object', function () {
        var wareId = this.getAttribute('wareId');
        toPage("<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId=" + wareId);
    })
</script>
</body>

</html>
