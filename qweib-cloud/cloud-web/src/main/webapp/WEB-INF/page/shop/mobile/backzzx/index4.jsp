<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
<!-- --------head开始----------- -->
<head>
    <meta charset="UTF-8">
    <meta name="Keywords" content="">
    <meta name="Description" content="">
    <meta name="format-detection" content="telephone=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
    <link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
    <link href="<%=basePath%>/resource/shop/mobile/css/index.css" rel="stylesheet">
    <title>首页</title>
    <style type="text/css">
        img {
            border: 0;
            display: inline;
            width: auto;
            vertical-align: middle;
        }

        .lsPrice{
            font-size: 6px;
            color: #999;
            margin: 0px 8px;
            text-decoration: line-through;
        }
        .mescroll{
            position: fixed;
            top: 0px;
            bottom: 50px;
            height: auto;
        }
        .subscribe{
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
        .best_Sellers ul li span.int_color{
            color: #fa4802
        }

        .img_list{
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
            background: rgba(0,0,0,0.5);
        }

        .jd-logo img{
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
<div id="wrapper" >
    <!--头部搜索框 start-->
    <div class="wf-search" id="search" >
        <header>
            <div class="jd-logo">
                <!-- 固定企微宝logo图 -->
                <%-- <c:if test="${!empty shopMallInfo.logo}">
                     <img src="<%=basePath%>/upload/${shopMallInfo.logo}" />
                </c:if>
                   <c:if test="${empty shopMallInfo.logo}">
                       <img src="<%=basePath%>/resource/shop/mobile/images/logo.png"/>
                   </c:if> --%>
                <img src="<%=basePath%>/resource/shop/mobile/images/logo.png"/>
            </div>

            <div class="search" style="padding-right:8px;" onclick="search();">
                <form>
                    <span class="sprite-icon"></span>
                    <input type="search" placeholder="商品名称" disabled="disabled"/>
                </form>

                <span class="subscribe" onclick="javaScript:toWxSubscribe();">立即关注</span>
            </div>
            <%-- <div class="login">
                <a id="loginmain">
                    厦门
                    <font class="login_icon">
                        <img src="<%=basePath %>/resource/shop/mobile/images/login_icon.png" />
                    </font>
                </a>
            </div> --%>
        </header>
    </div>
    <!--头部搜索框 end-->
    <div id="mescroll" class="mescroll">

        <!--banner start-->
        <div style="position: relative;">
            <div id="slider">
                <div class="swiper-container clearfix">
                    <ul class="swiper-wrapper">
                        <!-- 无banner图，显示默认 -->
                        <c:if test="${empty shopMallInfo.bannerList}">
                            <li class="swiper-slide"><a href="Orchard_fragrance.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner1.png"/></a></li>
                            <li class="swiper-slide"><a href="Birthday_zone.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner2.jpg"/></a></li>
                            <li class="swiper-slide"><a href="Integral_mall.html"><img src="<%=basePath %>/resource/shop/mobile/images/images/banner3.jpg"/></a></li>
                        </c:if>
                        <!-- 有banner图 -->
                        <c:if test="${!empty shopMallInfo.bannerList}">
                            <c:forEach items="${shopMallInfo.bannerList}" var="banner" varStatus="s">
                                <%--style="width:100%;height:150px"--%>
                                <li class="swiper-slide"><img src="<%=basePath%>/upload/${banner.pic}" ></li>
                            </c:forEach>
                        </c:if>
                    </ul>
                </div>
                <div class="swiper-pagination"></div>
            </div>

            <!-- 企业logo图 -->
            <div id="logo" style="position: absolute;z-index: 1;bottom: 15px;left: 10px;">
                <c:if test="${!empty shopMallInfo.logo}">
                    <img src="<%=basePath%>/upload/${shopMallInfo.logo}" style="width:45px;height:45px;display:inline;border-radius: 5px;"/>
                </c:if>
                <c:if test="${!empty shopMallInfo.name}">
                    <span style="color:white;font-size:15px;padding-left: 8px">${shopMallInfo.name}</span>
                </c:if>
            </div>

        </div>
        <!--banner end-->

        <!-- 商品一级分类 开始 -->
        <div id="nav">
            <div class="int_nav clearfix">
                <ul class="swiper-wrapper swiper_wrappcon" id="waretypeNav">
                    <%-- <li class="swiper-slide">
                        <a href="Inner_page.html">
                            <img src="<%=basePath%>/resource/shop/mobile/images/jifen/icon1.png" />
                            <span>积分商城</span>
                        </a>
                    </li>
                    <li class="swiper-slide">
                        <a href="Inner_page.html">
                            <img src="<%=basePath%>/resource/shop/mobile/images/jifen/icon1.png" />
                            <span>积分商城1</span>
                        </a>
                    </li> --%>
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
            <ul id="leftWareType" >
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
            <li><a href="<%=basePath %>/web/mainWeb/wareType.html?token=${token}"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
            <li><a href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
            <li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}" ><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
            <%--<li><a class="red"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/wareType.html"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/toShoppingCart"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>--%>
            <%--<li><a href="<%=basePath %>/web/mainWeb/toMyInfo" ><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>--%>
        </ul>
    </div>
    <!--menu  end-->
</div>

<script type="text/javascript" src="<%=basePath %>/resource/shop/mobile/js/rem.js" ></script>
<script type="text/javascript" src="<%=basePath %>/resource/shop/mobile/js/swiper.min.js" ></script>
<script type="text/javascript">

    var mescroll;//创建MeScroll对象
    $(document).ready(function(){
        doWxSubscribe();//关注公众号
        $.wechatShare(null);//分享;
        setBannerSwiper();//设置轮播图的滚动
        getWaretypeList();//根据waretypeIds获取商品一级分类列表
        getWareGroupList();
        getWareList();//全部商品
        //子模块
        var groupId_1="${shopMallInfo.mGroup1}";
        var groupId_2="${shopMallInfo.mGroup2}";
        var groupId_3="${shopMallInfo.mGroup3}";
        var modelWareids_1="${shopMallInfo.modelWareids1}";
        var modelWareids_2="${shopMallInfo.modelWareids2}";
        var modelWareids_3="${shopMallInfo.modelWareids3}";
        if(groupId_1!=null && groupId_1!=''){
            getModelWareList(groupId_1,'1',modelWareids_1);
        }
        if(groupId_2!=null && groupId_2!=''){
            getModelWareList(groupId_2,'2',modelWareids_2);
        }
        if(groupId_3!=null && groupId_3!=''){
            getModelWareList(groupId_3,'3',modelWareids_3);
        }

        //==============加载更多：开始==================
        mescroll= new MeScroll("mescroll", {
            down:{
                use:false,//如果配置false,则不会初始化下拉刷新的布局
            },
            up: {
                auto: true, //是否在初始化时以上拉加载的方式自动加载第一页数据; 默认false
                isBounce: false, //此处禁止ios回弹,解析(务必认真阅读,特别是最后一点): http://www.mescroll.com/qa.html#q10
                callback: upCallback, //上拉回调,此处可简写; 相当于 callback: function (page) { upCallback(page); }
                toTop:{ //配置回到顶部按钮
                    src : "<%=basePath %>/resource/shop/mobile/images/xqq/the_top.png", //默认滚动到1000px显示,可配置offset修改
                },
                htmlNodata:"<p class='upwarp-nodata'> -- 没有更多数据 -- </p>",
            }
        });
        /*上拉加载的回调 page = {num:1, size:10}; num:当前页 从1开始, size:每页数据条数 */
        function upCallback(page){
            //联网加载数据
            getListDataFromNet(page.num, page.size);
        }
        function getListDataFromNet(pageNum,pageSize) {
            getWareList(pageNum,pageSize);
        }
        //==============加载更多：结束==================
    })

    //设置banner的滚动
    function setBannerSwiper(){
        var mySwiper = new Swiper ('.swiper-container', {
            autoplay: 2000,//可选选项，自动滑动，手指触屏滑动会停止自动轮播
            autoplayDisableOnInteraction : false,//手指触屏滑动之后，重新开启自动轮播
            initialSlide :0,//初始显示的li的索引
            speed : 1000,//滑动的速度
            observer:true,//当li节点被修改的时候自动更新Swiper
            observeParents:true,//当容器container宽度改变的时候(window.onresize或者自适应)自动更新Swiper
            grabCursor : true,//鼠标抓手形状，触屏看不到
            pagination : '.swiper-pagination',//下面的图标跟随切换
            loop : true,//无缝轮播 自动在li列表的前面添加最后一个，在li列表后面添加第一个
        })
    }

    //根据waretypeIds获取商品一级分类列表
    function getWaretypeList(){
        $.ajax({
            url:"<%=basePath%>/web/shopWaretypeMobile/getWareTypesByOne",
            data:{"token":"${token}","companyId":"${companyId}","waretypeIds":"${shopMallInfo.waretype}","type":"1"},
            type:"POST",
            success:function(json){
                if(json.state){
                    var datas = json.list;
                    var leftWareType="";
                    if(datas!=null && datas!= undefined && datas.length>0){
                        //小于4个不显示
                        if(datas!=null && datas!= undefined && datas.length>=4){
                            //第一页：8个
                            leftWareType+="<li class=\"swiper-slide\">";
                            for(var i=0;i<datas.length;i++){
                                var waretypePicList=datas[i].waretypePicList;
                                if(i==7){
                                    //第八个："全部分类"
                                    leftWareType+="<a href=\"<%=basePath %>/web/shopWaretypeMobile/toAllWaretpye?token=${token}\">";
                                    leftWareType+="<img src=\"<%=basePath %>/resource/shop/mobile/images/8.png\" style=\"border-radius: 5px;\"/>";
                                }else{
                                    leftWareType+="<a href=\"<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&wareType="+datas[i].waretypeId+"\">";
                                    if(waretypePicList!=null && waretypePicList!= undefined && waretypePicList.length>0){
                                        leftWareType+="<img src=\"<%=basePath%>/upload/"+waretypePicList[0].pic+"\" style=\"border-radius: 5px;\"/>";
                                    }else{
                                        leftWareType+="<img src=\"<%=basePath %>/resource/shop/mobile/images/1.png\" style=\"border-radius: 5px;\"/>";
                                    }
                                }
                                leftWareType+="<span>"+datas[i].waretypeNm+"</span>";
                                leftWareType+=" </a>";
                            }
                            leftWareType+="</li>";

                        }
                    }
                    $("#waretypeNav").html(leftWareType);
                }
            },
            error:function (data) {
            }
        });
    }

    //获取商品分组列表
    function getWareGroupList(){
        $.ajax({
            url:"<%=basePath%>/web/shopWareGroupWeb/queryWareGroupList2",
            data:{"token":"${token}","companyId":"${companyId}","modelGroupIds":"${modelGroupIds}"},
            type:"POST",
            success:function(json){
                if(json.state){
                    var datas = json.list;
                    var leftWareType="";
                    if(datas!=null && datas!= undefined && datas.length>0){
                        for(var i=0;i<datas.length;i++){
                            var wareList=datas[i].wareList;
                            //判断少于3个不显示
                            if(wareList!=null && wareList!= undefined && wareList.length>=3){
                                leftWareType+="<div class='floor clearfix'>";
                                leftWareType+="<div class='floor-container'>";
                                leftWareType+="<div class='title-wrap'>";
                                leftWareType+="<span class='sprite-icon secskill-icon fl'></span>";
                                leftWareType+="<h2 style='font-size:0.7rem' class='secskill-title fl'>"+datas[i].name+"</h2>";
                                leftWareType+="<a href='javascript:groupMore("+datas[i].id+");'>";
                                leftWareType+="<div class='secskill-more fr'>";
                                leftWareType+="<span style='font-size:0.6rem;margin-right:5px'>查看更多</span>";
                                leftWareType+="<span class='sprite-icon'></span>";
                                leftWareType+="</div>";
                                leftWareType+="</a>";
                                leftWareType+="</div>";
                                leftWareType+="<div class='secskill-content'>";
                                leftWareType+="<ul class='swiper-wrapper'>";

                                //-------------------------图片start----------------------------------
                                if(wareList!=null && wareList!= undefined && wareList.length>0){
                                    for(var j=0;j<wareList.length;j++){
                                        leftWareType+="<li class='swiper-slide'>";
                                        leftWareType+="<a href='javaScript:toWareDetails("+wareList[j].wareId+")'>";
                                        var warePicList=wareList[j].warePicList;
                                        if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
                                            var sourcePath= "<%=basePath%>/upload/"+warePicList[0].pic;
                                            for (var k=0;k<warePicList.length;k++){
                                                //1:为主图
                                                if(warePicList[k].type=='1'){
                                                    sourcePath="<%=basePath%>/upload/"+warePicList[k].pic;
                                                    break;
                                                }
                                            }

                                            leftWareType+="<div class='img_div2'>";
                                            leftWareType+="<img src='"+sourcePath+"' class='img_img2'/>";
                                            leftWareType+="</div>";
                                            // leftWareType+="<img src='"+sourcePath+"' style='height:110px;border-radius: 2px;'/>";
                                        }else{
                                            leftWareType+="<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' style='height:110px;border-radius: 2px;'/>";
                                        }
                                        leftWareType+="</a>";
                                        //------------------价格相关：start---------------------
                                        leftWareType+="<p class='secskill-main clearfix'>";
                                        leftWareType+="<span class='secskill-title-con'>"+wareList[j].wareNm+"</span>";
                                        var source = json.source;//1普通会员；2员工会员；3进销存客户会员
                                        if("3"==source){
                                            var shopWarePrice = wareList[j].shopWarePrice;
                                            if(shopWarePrice != null && shopWarePrice != undefined){
                                                leftWareType+="<span class='secskill-number'>￥"+wareList[j].shopWarePrice+"</span>";
                                            }
                                        }else{
                                            var shopWareLsPrice = wareList[j].shopWareLsPrice;
                                            if(shopWareLsPrice != null && shopWareLsPrice != undefined){
                                                leftWareType+="<span class='secskill-number'>￥"+wareList[j].shopWareLsPrice+"</span>";
                                            }
                                        }
                                        leftWareType+="</p>";
                                        //------------------价格相关：start---------------------
                                        leftWareType+="</li>";
                                    }
                                }
                                //-------------------------图片end----------------------------------

                                leftWareType+="</ul>";
                                leftWareType+="</div>";
                                leftWareType+="</div>";
                                leftWareType+="</div>";
                            }

                        }
                    }
                    $("#leftWareType").html(leftWareType);
                }
                //处理列表左右滑动的
                var mySwiper = new Swiper('.secskill-content', {
                    initialSlide :0,//初始显示的li的索引
                    speed : 1000,//滑动的速度
                    observer:true,//当li节点被修改的时候自动更新Swiper
                    observeParents:true,//当容器container宽度改变的时候(window.onresize或者自适应)自动更新Swiper
                    slidesPerView : 3,//'auto'
                });
            },
            error:function (data) {
            }
        });
    }

    //商品分组更多
    function groupMore(groupId){
        window.location.href="<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&groupId="+groupId;
    }

    //滚动条到页面底部加载更多案例
    var flag=true;
    var	pageIndex = 1;
    $(window).scroll(function(){
        var scrollTop = $(this).scrollTop();    //滚动条距离顶部的高度
        var scrollHeight = $(document).height();   //当前页面的总高度
        var clientHeight = $(this).height();    //当前可视的页面高度
        if(scrollTop + clientHeight >= scrollHeight){   //距离顶部+当前高度 >=文档总高度 即代表滑动到底部
            //滚动条到达底部
            if(flag){
                getWareList();
            }
        }else if(scrollTop<=0){
            //滚动条到达顶部
            //滚动条距离顶部的高度小于等于0 TODO
        }
    });

    //获取全部商品列表
    function getWareList(pageNum,pageSize){
        var wareType = "";
        var groupId = "";
        $.ajax({
            url:"<%=basePath%>/web/shopWareMobile/getWareList",
            data : {"token":"${token}","companyId":"${companyId}","wareType":wareType,"groupId":groupId,"pageNo":pageNum,"pageSize":pageSize},
            type:"POST",
            success:function(json){
                if(json.state){
                    if(pageNum==1){
                        mescroll.clearDataList();
                        $("#wareList").html("");
                        //滚动列表到指定位置y=0,则回到列表顶部; 如需滚动到列表底部,可设置y很大的值,比如y=99999t时长,单位ms,默认300; 如果不需要动画缓冲效果,则传0
                        mescroll.scrollTo( 0, 300);
                    }
                    var datas = json.rows;
                    var wareList="";
                    if(datas != null && datas != undefined && datas.length>0){
                        for(var i=0;i<datas.length;i++){
                            var wareId = datas[i].wareId;
                            wareList+="<a href='javaScript:toWareDetails("+wareId+")'>";
                            wareList+="<li class='fl border_right'>";

                            //--------------图片相关start--------------
                            var warePicList=datas[i].warePicList;
                            if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
                                var sourcePath= "<%=basePath%>/upload/"+warePicList[0].pic;
                                for (var j=0;j<warePicList.length;j++){
                                    //1:为主图
                                    if(warePicList[j].type=='1'){
                                        sourcePath="<%=basePath%>/upload/"+warePicList[j].pic;
                                        break;
                                    }
                                }
                                // style='height: 180px;border-radius: 2px;'
                                // wareList+="<div style='height: 180px;width: 100%;text-align: center'>";
                                wareList+="<div class='img_div'>";
                                // wareList+="<span class='img_span'>";
                                wareList+="<img src='"+sourcePath+"' class='img_img'/>";
                                // wareList+="</span>";
                                wareList+="</div>";
                                // wareList+="</div>";
                            }else{
                                wareList+="<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' style='height: 180px;border-radius: 2px;'/>";
                            }
                            //--------------图片相关end--------------

                            wareList+="<div class='ellipsis_one'><span>"+datas[i].wareNm+"</span></div>";

                            //--------------价格相关start---------------
                            var source = json.source;//1普通会员；2员工会员；3进销存客户会员
                            if("3"==source){
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

                            }
                            //--------------价格相关end---------------
                            wareList+="</li>";
                            wareList+="</a>";
                        }
                        $("#wareList").append(wareList);
                    }
                    mescroll.endSuccess(datas.length);
                }
            },
            error:function (data) {
                mescroll.endErr();
            }
        });
    }

    //查询子模块下的商品列表
    function getModelWareList(groupId,type,modelWareids){
        $.ajax({
            url:"<%=basePath%>/web/shopWareMobile/getWareListByWareIds",
            data:{"token":"${token}","companyId":"${companyId}","wareIds":modelWareids,"groupId":groupId},
            type:"POST",
            success:function(json){
                if(json.state){
                    if(type=='1'){
                        showModel1(json,groupId);
                    }else if(type=='2'){
                        showModel2(json,groupId);
                    }else if(type=='3'){
                        showModel3(json,groupId);
                    }
                }
            }
        });
    }

    function showModel1(json,groupId){
        var datas=json.list;
        if(datas!=null && datas!= undefined && datas.length>=4){
            var str="";
            str+="<div class=\"title-wrap\">";
            str+="<span class=\"sprite-icon secskill-icon fl\"></span>";
            str+="<h2 class=\"secskill-title fl\">"+json.groupNm+"</h2>";
            str+="<a href=\"javascript:groupMore("+groupId+");\">";
            str+="<div class=\"secskill-more fr\">";
            str+="<span>查看更多</span>";
            str+="<span class=\"sprite-icon\"></span>";
            str+="</div>";
            str+="</a>";
            str+="</div>";
            str+="<div class=\"floor-container morencon\" style=\"height: 200px;\">";
            str+="<div class=\"left\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[0].wareId+"\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[0].wareId+")'>";
            //图片一
            var warePicList0=datas[0].warePicList;
            if(warePicList0!=null && warePicList0!= undefined && warePicList0.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList0[0].pic;
                for (var k=0;k<warePicList0.length;k++){
                    //1:为主图
                    if(warePicList0[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList0[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 200px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 200px;\"/></a>";
            }

            str+="</div>";
            str+="<div class=\"right\">";
            str+="<div class=\"top \" >";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[1].wareId+"\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[1].wareId+")'>";
            //图片二
            var warePicList1=datas[1].warePicList;
            if(warePicList1!=null && warePicList1!= undefined && warePicList1.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList1[0].pic;
                for (var k=0;k<warePicList1.length;k++){
                    //1:为主图
                    if(warePicList1[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList1[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            }
            str+="</div>";
            str+="<div class=\"bottom\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[2].wareId+"\" class=\"line\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[2].wareId+")'>";
            //图片三
            var warePicList2=datas[2].warePicList;
            if(warePicList2!=null && warePicList2!= undefined && warePicList2.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList2[0].pic;
                for (var k=0;k<warePicList2.length;k++){
                    //1:为主图
                    if(warePicList2[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList2[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            }
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[3].wareId+"\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[3].wareId+")'>";
            //图片三
            var warePicList3=datas[3].warePicList;
            if(warePicList3!=null && warePicList3!= undefined && warePicList3.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList3[0].pic;
                for (var k=0;k<warePicList3.length;k++){
                    //1:为主图
                    if(warePicList3[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList3[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            str+="</div>";
            str+="</div>";
            str+="</div>";

            $("#model1").html(str);
        }
    }

    function showModel2(json,groupId){
        var datas=json.list;
        if(datas!=null && datas!= undefined && datas.length>=3){
            var str="";
            str+="<div class=\"title-wrap\">";
            str+="<span class=\"sprite-icon secskill-icon fl\"></span>";
            str+="<h2 class=\"secskill-title fl\">"+json.groupNm+"</h2>";
            str+="<a href=\"javascript:groupMore("+groupId+");\">";
            str+="<div class=\"secskill-more fr\">";
            str+="<span>查看更多</span>";
            str+="<span class=\"sprite-icon\"></span>";
            str+="</div>";
            str+="</a>";
            str+="</div>";
            str+="<div class=\"floor-container\">";
            str+="<div class=\"left\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[0].wareId+"\" class=\"line\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[0].wareId+")' class=\"line\">";
            //图片一
            var warePicList0=datas[0].warePicList;
            if(warePicList0!=null && warePicList0!= undefined && warePicList0.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList0[0].pic;
                for (var k=0;k<warePicList0.length;k++){
                    //1:为主图
                    if(warePicList0[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList0[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 200px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 200px;\"/></a>";
            };
            str+="</div>";
            str+="<div class=\"right\">";
            str+="<div class=\"top\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[1].wareId+"\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[1].wareId+")' >";
            //图片二
            var warePicList1=datas[1].warePicList;
            if(warePicList1!=null && warePicList1!= undefined && warePicList1.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList1[0].pic;
                for (var k=0;k<warePicList1.length;k++){
                    //1:为主图
                    if(warePicList1[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList1[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            str+="</div>";
            str+="<div class=\"top topline\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[2].wareId+"\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[2].wareId+")' >";
            //图片三
            var warePicList2=datas[2].warePicList;
            if(warePicList2!=null && warePicList2!= undefined && warePicList2.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList2[0].pic;
                for (var k=0;k<warePicList2.length;k++){
                    //1:为主图
                    if(warePicList2[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList2[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            str+="</div>";
            str+="</div>";
            str+="</div>";
            $("#model2").html(str);
        }
    }

    function showModel3(json,groupId){
        var datas=json.list;
        if(datas!=null && datas!= undefined && datas.length>=4){
            var str="";
            str+="<div class=\"title-wrap\">";
            str+="<span class=\"sprite-icon secskill-icon fl\"></span>";
            str+="<h2 class=\"secskill-title fl\">"+json.groupNm+"</h2>";
            str+="<a href=\"javascript:groupMore("+groupId+");\">";
            str+="<div class=\"secskill-more fr\">";
            str+="<span>查看更多</span>";
            str+="<span class=\"sprite-icon\"></span>";
            str+="</div>";
            str+="</a>";
            str+="</div>";
            str+="<div class=\"floor-container center clearfix\">";
            str+="<div class=\"floor_left\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[0].wareId+"\" class=\"line\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[0].wareId+")' class=\"line\" >";
            //图片一
            var warePicList0=datas[0].warePicList;
            if(warePicList0!=null && warePicList0!= undefined && warePicList0.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList0[0].pic;
                for (var k=0;k<warePicList0.length;k++){
                    //1:为主图
                    if(warePicList0[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList0[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[1].wareId+"\" class=\"topline\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[1].wareId+")' class=\"line\" >";
            //图片二
            var warePicList1=datas[1].warePicList;
            if(warePicList1!=null && warePicList1!= undefined && warePicList1.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList1[0].pic;
                for (var k=0;k<warePicList1.length;k++){
                    //1:为主图
                    if(warePicList1[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList1[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            str+="</div>";
            str+="<div class=\"foor_right\">";
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[2].wareId+"\" class=\"line\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[2].wareId+")' class=\"line\" >";
            //图片三
            var warePicList2=datas[2].warePicList;
            if(warePicList2!=null && warePicList2!= undefined && warePicList2.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList2[0].pic;
                for (var k=0;k<warePicList2.length;k++){
                    //1:为主图
                    if(warePicList2[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList2[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            <%--str+="<a href=\"<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+datas[3].wareId+"\" class=\"topline\">";--%>
            str+="<a href='javaScript:toWareDetails("+datas[3].wareId+")' class=\"line\" >";
            //图片四
            var warePicList3=datas[3].warePicList;
            if(warePicList3!=null && warePicList3!= undefined && warePicList3.length>0){
                var sourcePath= "<%=basePath%>/upload/"+warePicList3[0].pic;
                for (var k=0;k<warePicList3.length;k++){
                    //1:为主图
                    if(warePicList3[k].type=='1'){
                        sourcePath="<%=basePath%>/upload/"+warePicList3[k].pic;
                        break;
                    }
                }
                str+="<img src=\""+sourcePath+"\" style=\"height: 100px;\"/></a>";
            }else{
                //暂无图片
                str+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"height: 100px;\"/></a>";
            };
            str+="</div>";
            str+="</div>";
            $("#model3").html(str);
        }
    }

    //搜索
    function search(){
        window.location.href="<%=basePath %>/web/mainWeb/toSearch?token=${token}";
    }
    function doWxSubscribe() {
        var subscribe = "${subscribe}"
        if("false"==subscribe){
            $(".subscribe").show();
        }
    }
    //公众号
    function toWxSubscribe(){
        event.stopPropagation();
        window.location.href="<%=basePath %>/web/mainWeb/toWxSubscribe?token=${token}";
    }
    function toWareDetails(wareId){
        window.location.href="<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+wareId+"&companyId=${companyId}";
    }


</script>
</body>
</html>
