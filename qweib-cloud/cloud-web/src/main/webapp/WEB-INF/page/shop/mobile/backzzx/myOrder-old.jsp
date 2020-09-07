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
		<title>我的订单</title>
	</head>
	<!-- --------head结束----------- -->
    <!-- --------body开始----------- -->
	<body>
		<div id="wrapper" class="m_pwd">
			<div class="int_title"><span class="int_pic" onclick="onBack();"><img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/></span>我的订单</div>
			<main id="main">
			<ul id="leftWareType">
				<%-- <div class="order">
					<p class="o_txt clearfix">
						编号 : 23456789
						<span class="fr">已发货</span>
					</p>
					<dl class="order_box topline clearfix">
						<dt class="order_pic fl">
							<img src="<%=basePath%>/resource/shop/mobile/images/ddxq/img.png" />
						</dt>
						<dd class="order_txt fr">
							<p class="order_con">Dior/迪奥小姐花漾淡香氛50ml 甜     心女士淡香 EDT 清新甜美</p>
							<span class="order_line">规格：50ml</span>
							<p class="order_number clearfix">1329.0积分<span class="order_add fr">x1</span></p>
						</dd>
					</dl>
					<div class="order_btn topline clearfix">
						<p class="order_t_box clearfix fr">
							<a href="#" class="p_money order_border order_style fl">订单详情</a>
							<a href="#" class="p_money order_border  fr">确认收货</a>
						</p>
					</div>
				</div> --%>
			</ul>
			</main>

			<div id="back_top">
				<a href="#"><img src="<%=basePath%>/resource/shop/mobile/images/xqq/the_top.png" /></a>
			</div>
			
		</div>	
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js" ></script>
		<script type="text/javascript">
				//返回上个界面
			    function onBack(){
			    	history.back();
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
					    	 getOrderList();
					     }
					 }else if(scrollTop<=0){
						//滚动条到达顶部
					 	//滚动条距离顶部的高度小于等于0 TODO
					 }
				});
			    
				$(document).ready(function(){
					getOrderList();
	 			})
	 			//获取订单列表
	 			function getOrderList(){
	     			$.ajax({
						url:"<%=basePath%>/web/shopBforderMobile/queryShopBforderPage",
						/* data:"token=${token}", */
						data : {"token":"${token}","pageNo":pageIndex,"pageSize":6},
						type:"POST",
						success:function(result){
							if(result.state){
								var rows=result.rows;
								var leftWareType="";
								if(rows!=null && rows!=undefined && rows.length>0){
									for(var i=0;i<rows.length;i++){
										leftWareType+="<div class=\"order\">";
										leftWareType+="<p class=\"o_txt clearfix\"> 订单号 :"+rows[i].orderNo;
										leftWareType+="<span class=\"fr\">"+rows[i].orderZt+"</span>";
										leftWareType+="</p>";
										
										var wareList=rows[i].list;
										if(wareList!=null && wareList!=undefined && wareList.length>0){
											leftWareType+="<dl class=\"order_box topline clearfix\">";
											leftWareType+="<dt class=\"order_pic fl\">";
											
											var warePicList=wareList[0].warePicList;
											if(warePicList!=null && warePicList!= undefined && warePicList.length>0){
												var sourcePath= "<%=basePath%>/upload/"+warePicList[0].picMini;
												for (var k=0;k<warePicList.length;k++){
													//1:为主图
													if(warePicList[k].type=='1'){
														sourcePath="<%=basePath%>/upload/"+warePicList[k].picMini;
														break;
													}
												}
												leftWareType+="<img src=\""+sourcePath+"\" />";
											}else{
												//暂无图片
												leftWareType+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" />";
											}
											
											leftWareType+="</dt>";
											leftWareType+="<dd class=\"order_txt fr\">";
											leftWareType+="<p class=\"order_con\">"+wareList[0].wareNm+"</p>";
											leftWareType+="<span class=\"order_line\">规格："+wareList[0].wareGg+"</span>";
											leftWareType+="<p class=\"order_number clearfix\">"+wareList[0].wareDj+"<span class=\"order_add fr\">*"+wareList[0].wareNum+"</span></p>";
											leftWareType+="</dd>";
											leftWareType+="</dl>";
										}
										
										leftWareType+="<div class=\"order_btn topline clearfix\">";
										leftWareType+="<p class=\"order_t_box clearfix fr\">";
										leftWareType+="<a href=\"<%=basePath%>/web/shopBforderMobile/toOrderDetails?token=${token}&id="+rows[i].id+"\" class=\"p_money order_border  fr\">订单详情</a>";
										leftWareType+="</p>";
										leftWareType+="</div>";
										leftWareType+="</div>";
									}
									/* $("#leftWareType").html(leftWareType); */
									$("#leftWareType").append(leftWareType);
				        			pageIndex++;
								}else{
									flag=false;
									var str="<p class=\"notice\">没有更多了！</p>";
									$("#main").append(str);
								}
							}
						},
						error:function (result) {
	         			}
					});
				}
				
		</script>	
			
			
	</body>
</html>
