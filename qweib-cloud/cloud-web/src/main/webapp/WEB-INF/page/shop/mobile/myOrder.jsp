<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的订单</title>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp" %>
    <style>
        .mescroll {
            position: fixed;
            top: 90px;
            bottom: 0;
            height: auto;
        }

        .sfk {
            line-height: 30px;
            height: 30px;
            font-size: 14px;
            text-align: right;
            margin-right: 10px;
        }
p{
    margin-bottom: 0px!important;
}

    </style>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
<div id="wrapper" class="m_pwd">
    <div class="int_title"><span class="int_pic" onclick="onBack();"><img
            src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/></span>我的订单
    </div>

    <main id="main">
        <div class="orchard_content clearfix">
            <div class="orchard_main_con clearfix" id="add_color">
                <ul class="seasonal">
                    <li onclick="itemClick('');" class="orchard_color">全部订单<p class="season_border"
                                                                              style="opacity: 1;"></p></li>
                    <li onclick="itemClick(1);">待支付<p class="season_border"></p></li>
                    <li onclick="itemClick(2);">待发货<p class="season_border"></p></li>
                    <li onclick="itemClick(3);">待收货<p class="season_border"></p></li>
                    <li onclick="itemClick(4);">已完成<p class="season_border"></p></li>
                    <%--<li onclick="itemClick(5);">已取消<p class="season_border"></p></li>--%>
                    <!-- 1:全部订单;2:待支付;3:待收货;4:已完成;5:待发货；已取消 -->
                </ul>
            </div>
        </div>
        <div id="mescroll" class="mescroll">
            <ul id="leftWareType"></ul>
        </div>
    </main>

    <div id="back_top">
        <a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/xqq/the_top.png"/></a>
    </div>
</div>

<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js"></script>
<script type="text/javascript">

    window.onload = function () {
        var oAdd = document.getElementById("add_color");
        var oLi = oAdd.getElementsByTagName("li");
        var oP = oAdd.getElementsByTagName("p");
        var leng = oLi.length;
        for (var i = 0; i < leng; i++) {
            oLi[i].add = i;
            oLi[i].addEventListener("touchend", function () {
                for (var j = 0; j < leng; j++) {
                    oLi[j].className = "";
                    oLi[j].lastChild.style.opacity = "0";
                }
                this.className = "orchard_color";
                this.lastChild.style.opacity = "1";
            }, false);
        }

        //加载更多
        initMescroll();
    }

    var mescroll;//创建MeScroll对象
    function initMescroll() {
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
                empty: {
                    tip: "暂无相关数据~", //提示
                    btntext: "去逛逛 >", //按钮,默认""
                    btnClick: function () {//点击按钮的回调,默认null
                        alert("点击了按钮,具体逻辑自行实现");
                    }
                },
            }
        });

        /*上拉加载的回调 page = {num:1, size:10}; num:当前页 从1开始, size:每页数据条数 */
        function upCallback(page) {
            //联网加载数据
            getListDataFromNet(orderState, page.num, page.size);
        }

        function getListDataFromNet(orderState, pageNum, pageSize) {
            getOrderList(orderState, pageNum, pageSize);
        }

        //==============加载更多：结束==================
    }

    //返回上个界面
    function onBack() {
        history.back();
    }

    /*$(document).ready(function(){
        $.wechatShare();//分享
    })*/

    var orderState = "";//<!-- 1:全部订单;2:待支付;3:待发货;4:待收货;5:待评价 -->
    function itemClick(i) {
        if (orderState != i) {
            //更改列表条件
            orderState = i;
            //重置列表数据
            mescroll.resetUpScroll();
            //隐藏回到顶部按钮
            mescroll.hideTopBtn();
        }
    }

    var orderStateMap = {0: "已取消", 1: "待支付", 2: "待发货", 3: "待收货", 4: "已完成"};

    //获取订单列表
    function getOrderList(orderState, pageNum, pageSize) {
        $.ajax({
            url: "<%=basePath%>/web/shopBforderMobile/queryShopBforderPage2",
            data: {"token": "${token}", "pageNo": pageNum, "pageSize": pageSize, "orderState": orderState},
            type: "POST",
            success: function (result) {
                if (result.state) {
                    //console.log("pageNum:"+pageNum);
                    //console.log("result:"+result.rows);
                    if (pageNum == 1) {
                        mescroll.clearDataList();
                        $("#leftWareType").html("");
                        //滚动列表到指定位置y=0,则回到列表顶部; 如需滚动到列表底部,可设置y很大的值,比如y=99999t时长,单位ms,默认300; 如果不需要动画缓冲效果,则传0
                        mescroll.scrollTo(0, 300);
                    }
                    result = result.obj;
                    var datas = result.rows;
                    var leftWareType = "";
                    if (datas != null && datas != undefined && datas.length > 0) {
                        for (var i = 0; i < datas.length; i++) {
                            //------订单状态的判断：开始--------
                            var status = datas[i].status;//0 取消1,待支付,2已支付待发货,3已发货待收货,4已完成
                            var orderZt = orderStateMap[status];
                            /*var status = 1;
                            var isPay = datas[i].isPay;
                            var isSend = datas[i].isSend;
                            var isFinish = datas[i].isFinish;
                            if(isFinish!=null && isFinish!=undefined && isFinish==1){
                                status=4;
                                orderZt="已完成";
                            }else if(isFinish!=null && isFinish!=undefined && isFinish==-1){
                                status=5;
                                orderZt="已取消";
                            }else if(isPay && isPay==10){
                                status=5;
                                orderZt="已退款";
                            }else{
                                if(isSend!=null && isSend!=undefined && isSend==1){
                                    status=3;
                                    orderZt="待收货";
                                }else{
                                    if(isPay!=null && isPay!=undefined && isPay==1){
                                        status=5;
                                        orderZt="待发货";
                                    }else{
                                        status=2;
                                        orderZt="等待支付";
                                    }
                                }
                            }*/
                            //------订单状态的判断：结束--------


                            leftWareType += "<div class=\"order\">";
                            leftWareType += "<p class=\"o_txt clearfix\"> 订单号 :" + datas[i].orderNo;
                            leftWareType += "<span class=\"fr\">" + orderZt + "</span>";
                            leftWareType += "</p>";

                            var id = datas[i].id;
                            datas[i].list.forEach(function (item, i) {
                                leftWareType += "<dl class=\"order_box topline clearfix\" onclick=\"orderDetail(" + id + ");\" >";
                                leftWareType += "<dt class=\"order_pic fl\">";

                                var sysBforderPicList = item.warePicList;
                                if (sysBforderPicList != null && sysBforderPicList != undefined && sysBforderPicList.length > 0) {
                                    var sourcePath = "<%=basePath%>/upload/" + sysBforderPicList[0].picMini;
                                    for (var k = 0; k < sysBforderPicList.length; k++) {
                                        //1:为主图
                                        if (sysBforderPicList[k].type == '1') {
                                            sourcePath = "<%=basePath%>/upload/" + sysBforderPicList[k].picMini;
                                            break;
                                        }
                                    }
                                    leftWareType += "<img src=\"" + sourcePath + "\" />";
                                } else {
                                    //暂无图片
                                    leftWareType += "<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" />";
                                }

                                leftWareType += "</dt>";
                                leftWareType += "<dd class=\"order_txt fr\">";
                                leftWareType += "<p class=\"order_con\">" + item.detailWareNm + "</p>";
                                leftWareType += "<span class=\"order_line\">规格：" + item.detailWareGg + " " + item.wareDw2 + "</span>";
                                var piceStr = item.wareDj;
                                if (item.wareDjOriginal && item.wareDjOriginal != item.wareDj) {
                                    piceStr = "<del style='font-size: 13px;'>" + item.wareDjOriginal + "</del>&nbsp;" + item.wareDj;
                                }
                                leftWareType += "<p class=\"order_number clearfix\">￥" + piceStr + "<span class=\"order_add fr\">X" + item.wareNum + "</span></p>";
                                leftWareType += "</dd>";
                                leftWareType += "</dl>";
                            });


                            /* <div class="topline">
                                <p class="sfk">共2件商品，实付款：￥33</p>
                            </div> */
                            leftWareType += "<div class='topline'>";
                            var freight = "";
                            if (datas[i].freight) freight = "(含运费:" + datas[i].freight + ")";
                            leftWareType += "<p class='sfk'>共" + datas[i].list.length + "种商品，" + "实付款：￥" + datas[i].orderAmount + freight + "</p>";
                            leftWareType += "</div>";

                            //'订单详情'和'确认收货'
                            // topline
                            leftWareType += "<div class='order_btn clearfix'>";
                            leftWareType += "<p class='order_t_box clearfix fr'>";
                            ////0 取消1,待支付,2已支付待发货,3已发货待收货,4已完成
                            if (status == 1) {
                                leftWareType += "<a href='javaScript:toPay(" + datas[i].id + ");' class='p_money order_border fr'>去支付</a>";
                                leftWareType += "<a href='javaScript:toCancel(" + datas[i].id + ");' class='p_money order_border fr'>取消</a>";
                            } else if (status == 2) {
                                //leftWareType+="<a href='#' class='p_money order_border'>订单详情</a>";
                                leftWareType += "<a href='javaScript:orderDetail(" + datas[i].id + ");' class='p_money order_border fr'>订单详情</a>";
                            } else if (status == 3) {
                                //leftWareType+="<a href='#' class='p_money order_border fl'>再次购买</a>";
                                leftWareType += "<a href='javaScript:reveiveGoods(" + datas[i].id + ");' class='p_money order_border fr'>确认收货</a>";
                            } else {
                                leftWareType += "<a href='javaScript:buy(" + datas[i].id + ");' class='p_money order_border fr'>再次购买</a>";
                            }
                            leftWareType += "</p>";
                            leftWareType += "</div>";

                            leftWareType += "</div>";

                        }
                        /* $("#leftWareType").html(leftWareType); */
                        if (leftWareType)
                            $("#leftWareType").append(leftWareType);
                        mescroll.endSuccess(datas.length);
                    } else {
                        mescroll.endSuccess(0);
                    }
                }
            },
            error: function (result) {
                mescroll.endErr();
            }
        });
    }

    function orderDetail(id) {
        toPage("<%=basePath%>/web/shopBforderMobile/toOrderDetails?token=${token}&id=" + id);
    }

    //支付
    function toPay(orderId) {
        toPage("<%=basePath%>/web/shopBforderMobile/toOrderPay?token=${token}&id=" + orderId);
    }

    //确认收货
    function toCancel(id) {
        if (window.confirm('确定取消吗？')) {
            $.ajax({
                url: "<%=basePath%>/web/shopBforderMobile/toCancel",
                data: {"token": "${token}", "id": id},
                type: "POST",
                success: function (result) {
                    if (result != null && result.state) {
                        alert(result.message);
                        //重置列表数据
                        mescroll.resetUpScroll();
                        //隐藏回到顶部按钮
                        mescroll.hideTopBtn();
                    } else {
                        alert(result.msg || result.message);
                    }
                }
            })
            return true;
        } else {
            return false;
        }
    }

    //确认收货
    function reveiveGoods(id) {
        if (window.confirm('确定收货吗？')) {
            $.ajax({
                url: "<%=basePath%>/web/shopBforderMobile/updateShopBforderIsfinish",
                data: {"token": "${token}", "id": id},
                type: "POST",
                success: function (result) {
                    if (result != null && result.state) {
                        alert("收货成功");
                        //重置列表数据
                        mescroll.resetUpScroll();
                        //隐藏回到顶部按钮
                        mescroll.hideTopBtn();
                    } else {
                        alert("收货失败");
                    }
                }
            })
            return true;
        } else {
            return false;
        }
    }

    //再次购买
    function buy(orderId) {
        $.ajax({
            url: "<%=basePath%>/web/shopCart/addShopCartWebByOrder",
            data: {"token": "${token}", "orderId": orderId},
            type: "POST",
            success: function (result) {
                if (result.state)
                    toPage("<%=basePath%>/web/mainWeb/toShoppingCart?token=${token}");
                else
                    alert(result.message);
            }
        });
    }
</script>


</body>
</html>
