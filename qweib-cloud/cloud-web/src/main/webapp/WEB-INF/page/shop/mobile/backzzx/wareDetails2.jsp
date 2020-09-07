<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    String basePath3 = request.getScheme()+"://"+request.getServerName();
%>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
<head>
    <meta charset="UTF-8">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
    <%--<title>商品详情</title>--%>
    <style>
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
        .my-title-price{
            background-color: #FFFFFF;
            padding: 5px 10px;
            border-top: solid 1px #EEEEEE;
            border-bottom: solid 1px #EEEEEE;
            margin-bottom: 10px;
        }
        .my-title{
            font-size: 14px;
            color: #333333;
            line-height: 24px;
            margin: 0;
            padding: 0;
            font-weight: 400;
        }
        .my-price{
            font-size: 12px;
            color: red;
            line-height: 20px;
            margin: 0;
            padding: 0;
        }
        .my-price #lsPrice{
            font-size: 10px;color: #999;margin: 0px 8px;text-decoration: line-through;
        }

        .my-dw-num-box{
            padding: 5px 10px;
            background-color: white;
            margin-bottom: 10px;
        }
        .my-dw-box{
            display: flex;
        }
        .my-dw{
            display: inline-block;
            width: 60px;
            font-size: 12px;
            color: #999999;
            padding-top: 8px;
        }
        .my-tags{
            flex: 1;
        }
        .my-tags > div{
            height:24px;
            float:left;
            margin:5px;
            line-height:24px;
            padding:0px 12px;
            border-radius:4px;
            border:1px solid #3388FF;
            color:#3388FF;
            font-size:12px;
        }
        .my-tags-active{background:#3388FF !important; color:#FFFFFF !important;}


        .table{
            width:100%;
            height: 100%;
            display:table;
            table-layout:fixed;

            border-top: 1px solid #f1f1f1;
            background-color:#fff;
            text-align:center;
            font-size: 12px;
            box-shadow: 0 -1px 3px 3px rgba(0, 0, 0, 0.1);
        }

        .table-cell{
            display:table-cell;
        }
        .my-bottom-left{
            vertical-align:middle;
            width: 14%;
            border-right:1px #dadada solid;
        }
        .my-bottom-left i{
            display: block;
            margin-right: auto;
            margin-left: auto;
        }
        .my-bottom-right{
            vertical-align:middle;
            border-right:1px #dadada solid;
            color: #fff;
            font-size: 15px;
        }
        .bg-orange{
            background-color: #ff9000;
        }
        .bg-red{
            background-color: #f15151;
        }

        /*红点提示 用于内部有数字*/
        .hint-num{ position: relative;}
        .hint-num span{
            position: absolute;
            top: -5px;
            right: 4px;
        }
        .mui-badge{
            font-size: 10px;
        }

        .my-ware-desc-title{

        }

        #wareDetail{
            background-color: #FFFFFF;
        }

        #wareDetail *{
            margin: 0;
            padding: 0;
            list-style: none;
        }



    </style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
    <a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
    <h1 class="mui-title">商品详情</h1>
</header>

<div class="mui-content">
    <%--图片--%>
    <div id="slider" class="mui-slider" >
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
            <p id="wareNm" class="my-title">青岛啤酒</p>
            <p  class="my-price">
                <span id="wareDj"></span>
                <span id="lsPrice"></span>
            </p>
        </div>
        <%--单位；数量--%>
        <div class="my-dw-num-box">
            <div >
                <div class="my-dw-box">
                    <div class="my-dw">
                        <span >单　　位：</span>
                    </div>
                    <div class="my-tags" id="tags">
                        <%--<div id="kkk">件</div>
                        <div id="xxxx">箱</div>--%>
                    </div>
                </div>
            </div>
            <div >
                <div class="my-dw">
                    <span>购买数量:</span>
                </div>
                <div class="mui-numbox" data-numbox-min='1' style="width: 150px;height: 30px;">
                    <button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
                    <input id="wareNum" class="mui-input-numbox" type="number" />
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
<div class="my-bottom-fixed">
    <footer class="table">
        <a href="javascript:toIndex();" class="table-cell my-bottom-left"><i class="mui-icon mui-icon-home"></i></a>
        <a href="javascript:toShoppingCart();" class="table-cell my-bottom-left"><i class="mui-icon-extra mui-icon-extra-cart hint-num"><span id="cartcount" class="mui-badge mui-badge-danger"></span></i></a>
        <a href="javascript:addShopCart();" class="table-cell my-bottom-right bg-orange">加入购物车</a>
        <a href="javascript:toFillOrder();" class="table-cell my-bottom-right bg-red">立即购买</a>
    </footer>
</div>

<script>
    mui.init();

    $(document).ready(function(){
        getWareDetails();
        getCartCount();
    })

    /**
     * 获取购物车数量
     */
    var cartcount;//购物车数据
    function getCartCount() {
        cartcount = ${cartcount==null?0:cartcount};
        if(cartcount === 0){
            $("#cartcount").hide();
        }else{
            $("#cartcount").html(cartcount);
        }
    }

    /**
     * 获取商品详情
     */
    function getWareDetails(){
        $.ajax({
            url:"<%=basePath%>/web/shopWareMobile/getWareDetails",
            data:"token=${token}&wareId=${wareId}",
            type:"POST",
            success:function(json){
                if(json.state){
                    var data = json.sysWare;
                    if(data!=null){
                        var $wareNm = $("#wareNm");
                        var $wareDj = $("#wareDj");
                        var $lsPrice = $("#lsPrice");
                        var $wareGg = $("#wareGg");
                        var $wareDw = $("#wareDw");
                        $wareNm.text(data.wareNm);
                        $wareDj.text("￥"+data.wareDj);
                        if(data.lsPrice!=null && data.lsPrice!=undefined){
                            $lsPrice.text("￥"+data.lsPrice);
                        }
                        $wareGg.text("商品规格："+data.wareGg);
                        //----商品详情----
                        $("#wareDetail").html(data.wareDesc);

                        //-----切换单位----
                        var dwstr="";
                        dwstr += "<div title='max' value='"+data.maxUnitCode+"' class='my-tags-active'>"+data.wareDw+"</div>"
                        var minUnit = data.minUnit;
                        if(minUnit!=null && minUnit!=undefined && minUnit!='S'){
                            dwstr += "<div title='min' value='"+data.minUnitCode+"'>"+data.minUnit+"</div>"
                        }
                        $("#tags").html(dwstr);

                        wareDj=data.wareDj;//单价
                        hsNum=data.hsNum;//换算比例
                        beUnit=data.maxUnitCode;//计量单位
                        lsPrice=data.lsPrice;//零售价

                        //------------图片start+分享-----------
                        var shareTitle = "";
                        var shareDesc = "";
                        var shareLogo = "";
                        shareTitle = data.wareNm;
                        shareDesc = "商品规格："+data.wareGg;

                        var leftWareType="";
                        var waretypePicList=data.warePicList;
                        if(waretypePicList!=null && waretypePicList!= undefined && waretypePicList.length>0){
                            shareLogo= waretypePicList[0];

                            leftWareType += "<div class=\"mui-slider-group mui-slider-loop\">";
                            <!-- 额外增加的一个节点(循环轮播：第一个节点是最后一张轮播) -->
                            leftWareType += "<div class=\"mui-slider-item mui-slider-item-duplicate\">";
                            leftWareType += " <a href=\"#\">";
                            leftWareType += "<img src='<%=basePath%>/upload/"+waretypePicList[waretypePicList.length-1].pic+"' >";
                            leftWareType += "</a>";
                            leftWareType += "</div>";
                            for(var i=0;i<waretypePicList.length;i++){
                                leftWareType += "<div class='mui-slider-item'>";
                                leftWareType += " <a href=\"#\">";
                                leftWareType += "<img src='<%=basePath%>/upload/"+waretypePicList[i].pic+"' >";
                                leftWareType += "</a>";
                                leftWareType += "</div>";
                            }
                            <!-- 额外增加的一个节点(循环轮播：最后一个节点是第一张轮播) -->
                            leftWareType += "<div class=\"mui-slider-item mui-slider-item-duplicate\">";
                            leftWareType += " <a href=\"#\">";
                            leftWareType += "<img src='<%=basePath%>/upload/"+waretypePicList[0].pic+"' >";
                            leftWareType += "</a>";
                            leftWareType += "</div>";
                            //外层
                            leftWareType += "</div>";

                            //点
                            leftWareType += "<div class='mui-slider-indicator'>";
                            for(var i=0;i<waretypePicList.length;i++){
                                if(i==0){
                                    leftWareType += "<div class='mui-indicator mui-active'></div>";
                                }else{
                                    leftWareType += "<div class='mui-indicator'></div>";
                                }
                            }
                            leftWareType += "</div>";
                            //赋值
                            $(".mui-slider").html(leftWareType);

                        }else{
                            //这边其实使用"暂无图片"
                            leftWareType += "<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\"/>";
                            $(".mui-slider").html(leftWareType);
                        }
                        //获得slider插件对象
                        var gallery = mui('.mui-slider');
                        gallery.slider({
                            interval:0//自动轮播周期，若为0则不自动播放，默认为0；
                        });
                        //------------图片end-----------

                        share(shareTitle,shareDesc,shareLogo);
                    }
                }


            }
        });
    }

    var beUnit="";//计量单位
    var hsNum;//换算比例
    var wareDj;//单价
    var lsPrice;//零售价

    mui("#tags").on('tap','div',function(){
        //修改单位代码；价格
        var title = this.getAttribute('title');
        beUnit = this.getAttribute('value');
        if('max' == title){
            $("#wareDj").text("￥"+wareDj);
            if(lsPrice!=null && lsPrice!=undefined){
                $("#lsPrice").text("￥"+lsPrice);
            }
        }else{
            $("#wareDj").text("￥"+(wareDj/hsNum).toFixed(2));
            if(lsPrice!=null && lsPrice!=undefined){
                $("#lsPrice").text("￥"+(lsPrice/hsNum).toFixed(2));
            }
        }

        //修改样式
        var $tag=$(this);//js对象转jquery对象
        $tag.siblings().removeClass("my-tags-active");
        $tag.addClass("my-tags-active");
    })


    /**
     * 添加购物车
     */
    function addShopCart(){
        var wareNum=$("#wareNum").val();
        $.ajax({
            url:"<%=basePath%>/web/shopCart/addShopCartWeb",
            data:{"token":"${token}","wareId":"${wareId}","wareNum":wareNum,"beUnit":beUnit},
            type:"POST",
            success:function(json){
                if(json.state){
                    if(json.add){
                        mui.toast("添加购物车成功");
                        cartcount++;
                        $("#cartcount").html(cartcount);
                        $("#cartcount").show();
                    }
                    if(json.update){
                        mui.toast("此商品已添加到购物车");
                    }
                }else{
                    if(json.registerState){
                        <%--window.location.href="<%=basePath%>/web/mainWeb/toWeixinRegister";--%>
                        window.location.href="<%=basePath%>/web/mainWeb/toWeixinRegister?token=${token}";
                    }
                }
            }
        });
    }

    /**
     * 确认订单-界面
     */
    function toFillOrder(){
        var wareNum=$("#wareNum").val();
        <%--window.location.href="<%=basePath%>/web/shopBforderMobile/toFillOrder?wareIds=${wareId}&wareNums="+wareNum+"&beUnits="+beUnit+"&type=1";--%>
        window.location.href="<%=basePath%>/web/shopBforderMobile/toFillOrder?token=${token}&wareIds=${wareId}&wareNums="+wareNum+"&beUnits="+beUnit+"&type=1";
    }
    /**
     * 购物车-界面
     */
    function toShoppingCart(){
        <%--window.location.href="<%=basePath %>/web/mainWeb/toShoppingCart";--%>
        window.location.href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}";
    }
    /**
     * 首页-界面
     */
    function toIndex(){
        window.location.href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}";
    }

    function share(title,desc,logo) {
        var url = window.location.href.toString();
        var tokenP= "token="+'${token}';
        if(url.endsWith(tokenP)){
            url = url.replace('?'+tokenP,'');
        }else{
            url = url.replace(tokenP+'&','');
        }
        //判断当前的url是否包含companyId,没有拼接companyId;
        if(url.indexOf("companyId") == -1){
            url += "&companyId=${companyId}";
        }
        var link = "<%=basePath3%>/web/wx/share?redirectUri="+encodeURIComponent(url)+"&gsId=${companyId}";
        var shareData = {
            title: title, // 分享标题
            desc: desc, // 分享描述
            link: link, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
            imgUrl: logo, // 分享图标
            success: function () {
            }
        }
        $.wechatShare(shareData);
    }



</script>

</body>
</html>
