<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
 	<head>
		<title>${name}商品列表</title>
		<%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
		<style type="text/css">
		 .lsPrice{
		 	font-size: 6px;
			color: #999;
			margin: 0px 8px;
			text-decoration: line-through;
		 }
		 .mescroll{
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
	<%@include file="/WEB-INF/page/shop/mobile/include/wareDetailComponent.jsp"%>
		<div id="wrapper" class="inner_style">
            <div class="int_title">
	            <span class="int_pic" onclick="onBack();">
	            	<img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/>
	            </span>
	          	<span id="titleNm">${name}</span>
            </div>
					
			<%-- <main id="main">
				<div class="best_Sellers best_top clearfix">
					<ul style="display: block;" class="clearfix best_content" id="wareList">
						<a href="Details_zoom.html">
							<li class="fl border_right">
								<img src="<%=basePath%>/resource/shop/mobile/images/jifen/sp2.png" />
								<span>迷你</span>
								<span class="int_color">86.0积分</span>
							</li>
						</a>
						<a href="Details_zoom.html">
							<li class="fl border_right">
								<img src="<%=basePath%>/resource/shop/mobile/images/jifen/sp2.png" />
								<span>迷你智能电饭煲HYFG-1016</span>
								<span class="int_color">86.0积分</span>
							</li>
						</a>
					</ul>
				</div>
				<!-- <p class="notice">没有更多商品了！</p> -->
			</main> --%>
			
			<div id="mescroll" class="mescroll">
				<div class="best_Sellers best_top clearfix">
					<ul style="display: block;" class="clearfix best_content" id="wareList">
					</ul>
				</div>
			</div>
		
		<div id="back_top">
			<a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/xqq/the_top.png" /></a>
		</div>
		
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/swiper.min.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/index.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/inner.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js" ></script>
		<script type="text/javascript">
			//返回上个界面
		    function onBack(){
		    	history.back();
		    }
			/*$(document).ready(function() {
				$.wechatShare();//分享
			})*/
			
		    var mescroll;
 			$(function(){
 				//创建MeScroll对象
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
 			});
			
	 		//获取商品列表
 			function getWareList(pageNum,pageSize){
 				var token = "${token}";
 				var wareType = "${wareType}";
 				var groupId = "${groupId}";
     			$.ajax({
					url:"<%=basePath%>/web/shopWareMobile/getWareList",
					data : {"token":token,"wareType":wareType,"groupId":groupId,"pageNo":pageNum,"pageSize":pageSize},
					type:"POST",
					success:function(json){
						if(json.state){
							if(pageNum==1){
								mescroll.clearDataList();
								$("#wareList").html("");
								//滚动列表到指定位置y=0,则回到列表顶部; 如需滚动到列表底部,可设置y很大的值,比如y=99999t时长,单位ms,默认300; 如果不需要动画缓冲效果,则传0
								mescroll.scrollTo( 0, 300);
							}
							var datas = json.obj.rows;
							var wareList="";
							if(datas!=null&&datas!=undefined&&datas.length>0){
								for(var i=0;i<datas.length;i++){
									var wareId=datas[i].wareId;
									//wareList+="<a href='javaScript:toWareDetails("+wareId+");'>";
									wareList += "<li class='fl border_right' onclick='toWareDetails(" + wareId + ")'>";
									var sourcePath="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg";
									var defWarePic=datas[i].defWarePic;
									if(defWarePic){
										sourcePath= "<%=basePath%>/upload/"+defWarePic.picMini;
									}
									wareList+="<img src='"+sourcePath+"' style='height: 180px;border-radius: 2px;'/>";
									/*var warePicList=datas[i].warePicList;
									if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
										var sourcePath= "<%=basePath%>/upload/"+warePicList[0].pic;
										for (var k=0;k<warePicList.length;k++){
											//1:为主图
											if(warePicList[k].type=='1'){
												sourcePath="<%=basePath%>/upload/"+warePicList[k].pic;
												break;
											}
										}
										wareList+="<img src='"+sourcePath+"' style='height: 180px;border-radius: 2px;'/>";
									}else{
										//暂无图片
										wareList+="<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' style='height: 180px;border-radius: 2px;'/>";
									}
									*/
									wareList+="<div class='ellipsis_one'><span>"+datas[i].wareNm+"</span></div>";

									//--------------价格相关start---------------
									/*var source = json.source;//1普通会员；2员工会员；3进销存客户会员
									if("3"==source){
										wareList += "<span class='int_color'>￥"+datas[i].shopWarePrice+"</span>";
										var shopWareLsPrice = datas[i].shopWareLsPrice;
										if(shopWareLsPrice != null && shopWareLsPrice!=undefined && shopWareLsPrice!=''){
											wareList += "<span class='lsPrice'>￥"+datas[i].shopWareLsPrice+"</span>";
										}
									}else{
										var shopWareLsPrice = datas[i].shopWareLsPrice;
										if(shopWareLsPrice != null && shopWareLsPrice != undefined){
											wareList+="<span class='int_color'>￥"+datas[i].shopWareLsPrice+"</span>";
										}
									}*/
									var defWarePrice=datas[i].defWarePrice;
									if(!defWarePrice)defWarePrice="未设置";
									wareList+="<span class='int_color'>￥"+defWarePrice+"</span>";
									wareList += '<span style="float:right;width:25px;" class="my-cart-item" warePrice="' + datas[i].defWarePrice + '" wareId="' + datas[i].wareId + '" beUnit="' + datas[i].defUnitCode + '" ><span class="mui-icon iconfont icon-gouwuche"></span></span>';
									//--------------价格相关end---------------
									wareList+="</li>";
									//wareList+="</a>";
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


			/* function toWareDetails(wareId) {
				 window.location.href = "<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+wareId;
			 }*/
		</script>
		
		
	</body>
</html>
