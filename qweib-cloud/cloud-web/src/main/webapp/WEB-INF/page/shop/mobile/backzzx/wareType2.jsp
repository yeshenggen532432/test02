<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	<style>
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
		/*==================tabbar======================*/




		.mui-row.mui-fullscreen>[class*="mui-col-"] {
			height: 100%;
		}
		.mui-segmented-control .mui-control-item {
			line-height: 50px;
			width: 100%;
		}
		.mui-segmented-control.mui-segmented-control-inverted .mui-control-item.mui-active {
			background-color: #fff;
		}
		.mui-table-view-cell>a:not(.mui-btn) {
			position: relative;
			display: block;
			overflow: hidden;
			margin: -11px 0;
			padding: 10px 10px 10px 5px;
			white-space: nowrap;
			text-overflow: ellipsis;
			color: #333333;
            font-size: 14px;
		}
		.mui-table-view-chevron .mui-table-view-cell>a:not(.mui-btn) {
			margin-right: -75px;
		}
		ul {
			width: initial;
		}

		.mui-scroll-wrapper {
			left: 34%;
			z-index: 0;
			top: 44px;
			width: 66%;
		}

		/*=================右边列表======================*/
		.my-name{
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
			margin-left: 5px;
			margin-right: 5px;
		}

		.mui-table-view .mui-media-object.mui-pull-left {
			margin-right: 5px;
		}

		.my-dj-num {
			position: absolute;
			left: 90px;
			right: 10px;
			bottom: 5px;
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

		.mui-content>.mui-table-view:first-child {
			margin-top: 1px;
		}
		.mui-checkbox.mui-left input[type=checkbox]{
			left: 5px;
			right: 5px;
			top: 50%;
			margin-top: -14px;
		}
		.mui-table-view-cell{
			padding-left: 0px;
		}

		.my-content{
		}

		.my-gg-dw {
			position: absolute;
			left: 90px;
			right: 10px;
			top: 34px;
			color: #8f8f94;
		}
		.my-gg-dw .my-gg{
			font-size: 12px;
			color: #666666;
		}
		.mui-numbox{
			width: 100px;
			height: 25px;
			float: right;
			padding: 0 10px;
		}
		.mui-numbox [class*=btn-numbox]{
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

		.my-cart-item{
			width: 30px;
			height: 30px;
			text-align: right;
		}

        /*红点提示 用于内部有数字*/
        .hint-num {
            margin-right: -10px;
            margin-left: -10px;
            padding-right: 10px;
            padding-left: 10px;
            font-size: 24px;
            position: relative;
            z-index: 20;
            padding-top: 10px;
            padding-bottom: 10px;
        }
        .hint-num span{
            position: absolute;
            top: 5px;
            right: 5px;
            font-size: 10px;
        }

        .icon-gouwuche1{
            font-size: 16px;
            color: #555555;
        }
	</style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
	<h1 class="mui-title">分类</h1>
	<a href="javascript:toShoppingCart();" class="mui-icon-extra mui-icon-extra-cart hint-num mui-pull-right">
        <span id="cartcount" class="mui-badge mui-badge-danger"></span>
    </a>
</header>
<%--mui-row mui-fullscreen--%>
<div class="mui-content mui-row mui-fullscreen">
	<div class="mui-col-xs-4">
		<div id="segmentedControls" class="mui-segmented-control mui-segmented-control-inverted mui-segmented-control-vertical">
			<ul class="mui-table-view mui-table-view-chevron parent-ul" id="leftList">
				<%--<li class="mui-table-view-cell mui-collapse mui-active">
					<a class="mui-navigate-right" href="#">企微宝软件12345678</a>
					<ul class="mui-table-view mui-table-view-chevron  child-ul">
						<li class="mui-table-view-cell"><a class="mui-navigate-right" href="#">软件年费</a>
						</li>
						<li class="mui-table-view-cell"><a class="mui-navigate-right" href="#">服务费</a>
						</li>
					</ul>
				</li>
				<li class="mui-table-view-cell mui-collapse">
					<a class="mui-navigate-right" href="#">企微宝硬件</a>
					<ul class="mui-table-view mui-table-view-chevron child-ul">
						<li class="mui-table-view-cell"><a class="mui-navigate-right" href="#">PC方案</a>
						</li>
						<li class="mui-table-view-cell"><a class="mui-navigate-right" href="#">手机方案</a>
						</li>
						<li class="mui-table-view-cell"><a class="mui-navigate-right" href="#">TV方案</a>
						</li>
					</ul>
				</li>--%>
			</ul>
		</div>
	</div>
	<div id="pullrefresh" class="mui-scroll-wrapper" style="border-left: 1px solid #c8c7cc;">
		<div class="mui-scroll">
			<ul class="mui-table-view" id="rightList">
				<%--<li class="mui-table-view-cell mui-media" >
					<img class="mui-media-object mui-pull-left" src="images/60x222260.gif">
					<div class="my-content">
						<h4 class="my-name mui-ellipsis">青岛啤酒</h4>
						<div class="my-gg-dw">
							<span class="my-gg">规格：500*24</span>
						</div>
						<div class="my-dj-num">
							<div class="my-dj">￥999</div>
							<a class="mui-pull-right"><span class="mui-icon mui-icon-contact"></span></a>
&lt;%&ndash;							<div class="mui-numbox" data-numbox-min='1' data-numbox-max='9'>
								<button class="mui-btn mui-btn-numbox-minus" type="button">-</button>
								<input class="mui-input-numbox" type="number" value="1" />
								<button class="mui-btn mui-btn-numbox-plus" type="button">+</button>
							</div>&ndash;%&gt;
						</div>
					</div>
				</li>--%>
			</ul>
		</div>
	</div>
</div>

<div id="menu">
	<ul>
		<li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}"><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
		<li><a class="red"><font class="iconfont" style="color: #3388FF;">&#xe660;</font><span class="inco_txt">分类</span></a></li>
		<li><a href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}"><font class="iconfont" >&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
		<li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}"><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
	</ul>
</div>

<script>
	mui.init({
		pullRefresh: {
			container: '#pullrefresh',
			up: {
				auto:true,
				contentrefresh: '正在加载...',
				callback: pullupRefresh
			}
		}
	});
	mui("#leftList").on("tap",".parent-ul li.mui-collapse",function(event){
		var CLASS_ACTIVE = "mui-active";
		var isExpand = false;
		var classList = this.classList;
		var ul = this.parentNode;

		if (classList.contains('mui-collapse')) {
			if (!classList.contains(CLASS_ACTIVE)) { //展开时,需要收缩其他同类
				var collapse = this.parentNode.querySelector('.mui-collapse.mui-active');
				if (collapse) {
					collapse.classList.remove(CLASS_ACTIVE);
				}
				isExpand = true;
			}
			classList.toggle(CLASS_ACTIVE);
			if (isExpand) {
				//触发展开事件
				mui.trigger(this, 'expand');

				var id = this.getAttribute("id")
				console.log(id);
				resetPullRefresh(id);
			}
		}
		event.stopPropagation()
	})

	mui("#leftList").on("tap",".child-ul li.mui-table-view-cell",function(){
		var id = this.getAttribute("id")
		console.log(id);
		resetPullRefresh(id);
		event.stopPropagation()
	})


	function resetPullRefresh(id){
		pageNO = 1;
		pageSize = 10;
		wareType = id;
		pullupRefresh();
	};

    $(document).ready(function(){
		$.wechatShare(null);//分享
        getWareTypes();
		getCartCount();
		$.wechatShare();//分享
    })
    //获取商品分类列表
    function getWareTypes(){
        $.ajax({
            url:"<%=basePath%>/web/shopWaretypeMobile/getWareTypes",
            data:{"token":"${token}"},
            type:"POST",
            success:function(json){
                if(json.state){
                    var datas = json.list;
                    var str = "";
                    if(datas != null && datas != undefined && datas.length>0){
                        //第一层：根目录：没有实际作用
                        for(var k = 0; k<datas.length;k++){
                            var parent = datas[k].children;
                            if(parent != null && parent != undefined && parent.length>0){
                                //第二层
                                for(var i = 0; i<parent.length;i++){
                                    str += '<li class="mui-table-view-cell mui-collapse" id="'+parent[i].id+'">';
                                    str += '<a class="mui-navigate-right" href="#">'+parent[i].text+'</a>';
                                    str += '<ul class="mui-table-view mui-table-view-chevron  child-ul">';
                                    var children = parent[i].children;
                                    if(children != null && children != undefined && children.length>0){
                                        //第三层：
                                        for(var j = 0; j<children.length;j++){
                                            str += '<li class="mui-table-view-cell" id="'+children[j].id+'"><a class="mui-navigate-right" href="#">'+children[j].text+'</a>';
                                            str += '</li>';
                                        }
                                    }
                                    str += '</ul>';
                                    str += '</li>';
                                }
                            }
                        }
                        $("#leftList").html(str);
                    }
                }
            },
            error:function (data) {
            }
        });
    }

	var pageNO = 1 ;
	var pageSize = 10 ;
	var wareType = "";
	//获取商品列表
	function pullupRefresh(){
		$.ajax({
			url:"<%=basePath%>/web/shopWareMobile/getWareList",
			data : {"token":"${token}","wareType":wareType,"pageNo":pageNO,"pageSize":pageSize},
			type:"POST",
			success:function(json){
				if(json.state){
					if(pageNO==1){
						$("#rightList").html("");
					}
					var str="";
					var datas = json.rows;
					if(datas!=null && datas!=undefined && datas.length>0){
						pageNO++;
						for(var i=0;i<datas.length;i++){
                            var wareId = datas[i].wareId;
							str += '<li class="mui-table-view-cell mui-media" id="'+wareId+'">';

                            var warePicList=datas[i].warePicList;
                            if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
                                var sourcePath= "<%=basePath%>/upload/"+warePicList[0].picMini;
                                for (var k=0;k<warePicList.length;k++){
                                    //1:为主图
                                    if(warePicList[k].type=='1'){
                                        sourcePath="<%=basePath%>/upload/"+warePicList[k].picMini;
                                        break;
                                    }
                                }
                                str += '<img class="mui-media-object mui-pull-left" src="'+sourcePath+'">';
                            }else{
                                //暂无图片
                                str +='<img class="mui-media-object mui-pull-left" src="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg">';
                            }

							//str += '<img class="mui-media-object mui-pull-left" src="images/60x222260.gif">';
							str += '<div class="my-content">';
							str += '<h4 class="my-name mui-ellipsis">'+datas[i].wareNm+'</h4>';
							str += '<div class="my-gg-dw">';
							str += '<span class="my-gg">规格：'+datas[i].wareGg+'</span>';
							str += '</div>';
							str += '<div class="my-dj-num">';
							str += '<div class="my-dj">￥'+datas[i].wareDj+'</div>';
							str += '<a class="mui-pull-right my-cart-item" wareId="'+datas[i].wareId+'" beUnit="'+datas[i].maxUnitCode+'"><span class="mui-icon iconfont icon-gouwuche1"></span></a>';
							str += '</div>';
							str += '</div>';
							str += '</li>';
						}
						$("#rightList").append(str);

						var isEnd = false;
						if(datas.length<10){
							isEnd = true;
						}
						mui('#pullrefresh').pullRefresh().endPullupToRefresh(isEnd);//参数为true代表没有更多数据了。
					}

				}else{
					mui('#pullrefresh').pullRefresh().endPullupToRefresh(false);
					mui.toast(json.msg);
				}
			},
			error:function (data) {
				mui('#pullrefresh').pullRefresh().endPullupToRefresh(false);
			}
		});
	}

	/**
	 * 获取购物车数量
	 */
	var cartcount = 0;//购物车数据
	function getCartCount() {
		$.ajax({
			url:"<%=basePath%>/web/shopCart/queryShopCartCount",
			data : {"token":"${token}"},
			type:"POST",
			success:function(json){
				if(json.state){
					cartcount = json.obj;
					if(cartcount === 0){
						$("#cartcount").hide();
					}else{
						$("#cartcount").html(cartcount);
					}
				}
			},
			error:function (data) {
			}
		});
	}

	/**
	 * 添加购物车
	 */
	mui("#rightList").on("tap","a.my-cart-item",function(){
		var wareId = this.getAttribute("wareId");
		var beUnit = this.getAttribute("beUnit");
		var wareNum = 1;
		console.log(wareId);
		console.log(beUnit);
		console.log(wareNum);
		$.ajax({
			url:"<%=basePath%>/web/shopCart/addShopCartWeb",
			data:{"token":"${token}","wareId":wareId,"wareNum":wareNum,"beUnit":beUnit},
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
		event.stopPropagation();
	})

    /**
     * 购物车-界面
     */
    function toShoppingCart(){
        <%--window.location.href="<%=basePath %>/web/mainWeb/toShoppingCart";--%>
        window.location.href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}";
    }

    /**
     * 商品详情
     */
    mui("#rightList").on('tap','li.mui-table-view-cell',function () {
        var wareId = this.getAttribute('id');
        window.location.href="<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+wareId;
        <%--window.location.href="<%=basePath%>/web/shopWareMobile/toWareDetails?&wareId="+wareId;--%>
    })

</script>

</body>

</html>

