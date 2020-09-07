<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
		<script src="<%=basePath%>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
		<title>搜索</title>
		
		<style type="text/css">
			
			/*说明*/
			/* .mescroll .notice{
				font-size: 14px;
				padding: 20px 0;
				border-bottom: 1px solid #eee;
				text-align: center;
				color:#555;
			} */
			/*列表*/
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
	<body style="-webkit-text-size-adjust: 100%!important;">
		<div id="wrapper">
			<!--头部搜索框 start-->
			<div class="wf-search" id="search" >
				<header>
					<div class="jd-logo">
		       			<span onclick="onBack();">
			            	<img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png" style="width:35px;height: 35px;padding: 10px"/>
			            </span>
					</div>
					<div class="search">
						<form>	
							<span class="sprite-icon"></span>
							<input type="search" placeholder="商品名称" id="keycode">
						</form>
					</div>
					<div class="login">
						<span onclick="search();">搜索</span>
					</div>
				</header>
			</div>

			<!-- <div id="main" style="padding-top: 40px">
				<div class="fill_main" id="wareList">
				</div>
			</div> -->
			
			<div id="mescroll" class="mescroll">
				<div class="fill_main" id="wareList">
						
				</div>
			</div>
		</div>

		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/fill_name.js"></script>
		<script type="text/javascript">
			//返回上个界面
		    function onBack(){
		    	history.back();
		    }
			$(document).ready(function() {
				$.wechatShare();//分享
			})
 			
 			//搜索
 			function search(){
 				var serchstr=$("#keycode").val();
 				if(serchstr==null || serchstr==undefined || serchstr==''){
 					alert("请输入关键字");
 					return;
 				}
 				/* mescroll.setPageNum(1);
 				mescroll.setPageSize(10);
				getWareList(1,10); */
				/* 重置列表为第一页 (常用于列表筛选条件变化或切换菜单时重新刷新列表数据)
				内部实现: 把page.num=1,再主动触发up.callback
				isShowLoading 是否显示进度布局; 
				1.默认null,不传参,则显示上拉加载的进度布局 
				2.传参true, 则显示下拉刷新的进度布局
				3.传参false,则不显示上拉和下拉的进度 (常用于静默更新列表数据) */
				mescroll.resetUpScroll( null );
			 }
 			
 			//获取商品列表
 			function getWareList(pageNum,pageSize){
 				var serchstr=$("#keycode").val();
	               $.ajax({
						url:"<%=basePath%>/web/shopWareMobile/getWareList",
						data:{"token":"${token}","wareNm":serchstr,"pageNo":pageNum,"pageSize":pageSize},
						type:"POST",
						success:function(json){
							if(pageNum==1){
								mescroll.clearDataList();
								$("#wareList").html("");
								//滚动列表到指定位置y=0,则回到列表顶部; 如需滚动到列表底部,可设置y很大的值,比如y=99999t时长,单位ms,默认300; 如果不需要动画缓冲效果,则传0
								mescroll.scrollTo( 0, 300);
							}
							if(json.state){
								var datas = json.rows;
								var wareList="";
								if(datas!=null&&datas!=undefined&&datas.length>0){
									for(var i=0;i<datas.length;i++){
										var wareId=datas[i].wareId;
										wareList += "<div onclick='jump("+wareId+");'>";
									    wareList += "<dl class='fill_dl clearfix'>";
									    wareList += "<dt class='fill_p_pic fl'>";
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
											wareList+="<img src='"+sourcePath+"'/>";
										}else{
											//暂无图片
											wareList+="<img src='<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg' />";
										}
										wareList += "</dt>";
									    wareList += "<dd class='fill_p_text fr'>";
									    wareList += "<input class='fill_p_con'  readonly='readonly' type='text' value='"+datas[i].wareNm+"'/>";
									    wareList += "<p class='fill_p'>规格："+datas[i].wareGg+"</p>";
										//--------------价格相关start---------------
										var source = json.source;//1普通会员；2员工会员；3进销存客户会员
										if("3"==source){
											wareList += "<input readonly='readonly' type='text'  class='fill_int' value='"+datas[i].shopWarePrice+"'/>";
										}else{
											wareList += "<input readonly='readonly' type='text'  class='fill_int' value='"+datas[i].shopWareLsPrice+"'/>";
											// var shopWareLsPrice = datas[i].shopWareLsPrice;
											// if(shopWareLsPrice != null && shopWareLsPrice != undefined){
											// }
										}
										//--------------价格相关end---------------

									    wareList += "</dd>";
									    wareList += "</dl>";
									    wareList += "</div>";
				        			}
									$("#wareList").append(wareList);
								}
								mescroll.endSuccess(datas.length);
							}
						},
						error:function(){
							mescroll.endErr();
						}
					});
				
			 }
 			
 			//跳转到商品详情
 			function jump(wareId){
 				<%--window.location.href="<%=basePath%>/web/shopWareMobile/toWareDetails?wareId="+wareId;--%>
 				window.location.href="<%=basePath%>/web/shopWareMobile/toWareDetails?token=${token}&wareId="+wareId;
 			}
 			
 			var mescroll;
 			$(function(){
 				//创建MeScroll对象
 				 mescroll= new MeScroll("mescroll", {
 					down:{
 						use:false,//如果配置false,则不会初始化下拉刷新的布局
 					},
 					up: {
 						auto: false, //是否在初始化时以上拉加载的方式自动加载第一页数据; 默认false
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
 				
 			});
		</script>

	</body>
</html>
