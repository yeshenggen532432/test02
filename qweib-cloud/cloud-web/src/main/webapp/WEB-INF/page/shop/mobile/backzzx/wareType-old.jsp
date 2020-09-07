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
		<title>分类</title>
	</head>
	<!-- --------head结束----------- -->
    <!-- --------body开始----------- -->
<body style="-webkit-text-size-adjust: 100%!important;">
	<div id="wrapper">
	
			<!--头部搜索框 start-->
			<div class="wf-search" id="search" >
				<header>
					<div class="jd-logo">
		       			<img src="<%=basePath%>/resource/shop/mobile/images/logo.png"/>
					</div>
					<div class="search" style="padding-right:8px;" onclick="search();">
						<form>	
							<span class="sprite-icon"></span>
							<input type="search" placeholder="商品名称" disabled="disabled"/>
						</form>
					</div>
					<%-- <div class="login">
						<a href="Receipt_address.html" id="loginmain">
							北京
							<font class="login_icon">
								<img src="<%=basePath%>/resource/shop/mobile/images/login_icon.png" />
							</font>
						</a>
					</div> --%>
				</header>
			</div>
			<!--头部搜索框 end-->
			<div class="Integral_mall clearfix">
				<div class="integ_box topline clearfix">
					<!--列表左边 start-->
					<div class="integ_left fl">
						<ul class="integ_ul" id="leftWareType">
							<%-- 
							<li class="integ_li integ_back">
								积分商城
								<p class="integ_border"></p>
							</li>
							<p class="integ_top topline"></p>
							--%>	
						
						</ul>
					</div>
					<!--列表左边 end-->
					<!--列表右边 start-->
					<div class="integ_right clearfix fr" id="rightWareType">
						<%--
						<ul class="integ_main clearfix" style="display: block;">
							<a href="Inner_page.html">
								<li class="integ_con fl">
									<img src="<%=basePath%>/resource/shop/mobile/images/fenlei/fenlei-03.png">
									<span class="integ_text">生活家电</span>
								</li>
							</a>
						</ul>
							<ul class="integ_main clearfix" >
					 --%>
					
					</div>
				</div>
				<!--列表右边 end-->
				
				</div>
			</div>	
			
		<!--menu  start-->
		<div id="menu">
			<ul>
				<li><a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}" ><font class="iconfont">&#xe612;</font><span class="inco_txt">首页</span></a></li>
				<li><a class="red"><font class="iconfont">&#xe660;</font><span class="inco_txt">分类</span></a></li>
				<li><a href="<%=basePath %>/web/mainWeb/toShoppingCart?token=${token}"><font class="iconfont index">&#xe63e;</font><span class="inco_txt">购物车</span></a></li>
				<li><a href="<%=basePath %>/web/mainWeb/toMyInfo?token=${token}" ><font class="iconfont">&#xe62e;</font><span class="inco_txt">我的</span></a></li>
			</ul>
		</div> 
		<!--menu  end-->
		
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/fill_name.js"></script>
		<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/menu.js" ></script>
		<%-- <script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/top.js" ></script> --%>
		<script type="text/javascript">
			$(document).ready(function(){
				$.wechatShare();//分享
				getWareTypes();
 			})
 			//获取商品分类列表
 			function getWareTypes(){
     			$.ajax({
					url:"<%=basePath%>/web/shopWareMobile/getWareTypes",
					data:"token=${token}",
					type:"get",
					success:function(json){
						if(json.state){
							var datas = json.list;
							var leftWareType="";
							var rightWareType="";
							if(datas!=null&&datas!=undefined&&datas.length>0){
								for(var i=0;i<datas.length;i++){
									var left = "topline";
									if(i==0){
										left = "integ_back";
									}
									leftWareType+="<li class=\"integ_li "+left+"\">";
									leftWareType+=""+datas[i].waretypeNm+"";
									leftWareType+="<p class=\"integ_border\"></p>";
									leftWareType+="</li>";
									
									if(datas[i].list2!=null){
										var size2 = datas[i].list2.length;
										var temp="";
										if(i==0){
											temp="style=\"display: block;\"";
										}
										rightWareType+="<ul class=\"integ_main clearfix\" "+temp+">";
			        					for(var j = 0;j<size2;j++){
			        					    var waretypeId=datas[i].list2[j].waretypeId;
			        					    var waretypeNm=datas[i].list2[j].waretypeNm;
			        					    var waretypePicList=datas[i].list2[j].waretypePicList;
				    						<%--rightWareType+="<a href=\"<%=basePath %>/web/shopWareMobile/toInnerPage?wareType="+waretypeId+"&wareTypeNm="+waretypeNm+"\">";--%>
				    						rightWareType+="<a href=\"<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&wareType="+waretypeId+"&wareTypeNm="+waretypeNm+"\">";
				    						rightWareType+="<li class=\"integ_con fl\">";
				    						
				    						if(waretypePicList!=null && waretypePicList!= undefined && waretypePicList.length>0){
				    							rightWareType+="<img src=\"<%=basePath%>/upload/"+waretypePicList[0].picMini+"\" style=\"padding:5px;\"/>";
											}else{
												rightWareType+="<img src=\"<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg\" style=\"padding:5px;\"/>";
											}
				    						rightWareType+="<span class=\"integ_text\">"+datas[i].list2[j].waretypeNm+"</span>";
				    						rightWareType+="</li>";
				    						rightWareType+="</a>";
			        					}
			        					rightWareType+="</ul>";
									}else{
										rightWareType+="<ul class=\"integ_main clearfix\" ></ul>";
									}
			        			}
								leftWareType+="<p class=\"integ_top topline\"></p>";
								rightWareType+="<ul class=\"integ_main clearfix\" ></ul>";
							}
							$("#leftWareType").html(leftWareType);
							$("#rightWareType").html(rightWareType);
							
							var $li_btn = $(".Integral_mall .integ_box .integ_left ul.integ_ul li.integ_li");
							var $ul_box = $(".Integral_mall .integ_box .integ_right ul.integ_main");
							var $p_con =  $(".Integral_mall .integ_box .integ_left ul.integ_ul li.integ_li p");
							var index = 0;
							$li_btn.bind("click",function(){
								$(this).addClass("integ_back").siblings().removeClass("integ_back");
								index = $(this).index();
								$p_con.hide();
								$(this).find("p").show();
								$ul_box.eq(index).fadeIn().siblings().fadeOut();
							});
						}
					},
					error:function (data) {
         			}
				});
			 }
			
			//搜索
 			function search(){
 				<%--window.location.href="<%=basePath %>/web/mainWeb/toSearch";--%>
 				window.location.href="<%=basePath %>/web/mainWeb/toSearch?token=${token}";
 			}
		</script>	
			
			
			
	</body>
</html>
