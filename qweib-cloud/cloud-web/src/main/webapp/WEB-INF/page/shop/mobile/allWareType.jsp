<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
 	<head>
		<title>全部商品分类</title>
		<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
	</head>
	<!-- --------head结束----------- -->
    <!-- --------body开始----------- -->
<body>
	<div id="wrapper">
		<div class="int_title"><span class="int_pic" onclick="onBack();"><img src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png"/></span>全部分类</div>
		
		<!-- 商品一级分类 开始 -->
		<div id="nav">
			<div class="int_nav clearfix">
				<ul class="swiper-wrapper swiper_wrappcon" id="waretypeNav">
				</ul>
			</div>
		</div>
		
	</div>
	
	<script type="text/javascript">
		//返回上个界面
	    function onBack(){
	    	history.back();
	    }
	
		$(document).ready(function(){
			getWaretypeList();
			//$.wechatShare(null);//分享统一分享JS处理
 		})
 		
 		//根据waretypeIds获取商品一级分类列表
		function getWaretypeList(){
   			$.ajax({
			url:"<%=basePath%>/web/shopWaretypeMobile/getWareTypesByOne",
			data:{"token":"${token}","companyId":"${companyId}"},
			type:"POST",
			success:function(json){
				if(json.state){
					var datas = json.list;
					var leftWareType="";
					if(datas!=null && datas!= undefined && datas.length>0){
						//第一页：8个
						leftWareType+="<li class=\"swiper-slide\">";
						for(var i=0;i<datas.length;i++){
							var waretypePicList=datas[i].waretypePicList;
							/*if(i==7){
								//第八个："全部分类"
								<%--leftWareType+="<a href=\"<%=basePath %>/web/shopWaretypeMobile/toAllWaretpye\">";--%>
								leftWareType+="<a href=\"<%=basePath %>/web/shopWaretypeMobile/toAllWaretpye?token=${token}\">";
								leftWareType+="<img src=\"<%=basePath %>/resource/shop/mobile/images/8.png\" />";
							}else{*/
								<%--leftWareType+="<a href=\"<%=basePath %>/web/shopWareMobile/toInnerPage?wareType="+datas[i].waretypeId+"\">";--%>
								leftWareType += "<a href=\"javascript:toPage('<%=basePath %>/web/shopWareMobile/toInnerPage?token=${token}&wareType=" + datas[i].waretypeId + "')\">";
								if(waretypePicList!=null && waretypePicList!= undefined && waretypePicList.length>0){
									leftWareType+="<img src=\"<%=basePath%>/upload/"+waretypePicList[0].pic+"\" />";
								}else{
									leftWareType+="<img src=\"<%=basePath %>/resource/shop/mobile/images/1.png\" />";
								}
							//}
							leftWareType+="<span>"+datas[i].waretypeNm+"</span>";
							leftWareType+=" </a>";
	        			}
						leftWareType+="</li>";
					}
					$("#waretypeNav").html(leftWareType);
				}
			},
			error:function (data) {
       		}
		});
	}
 		
		
		
	</script>

	<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/rem.js" ></script>
	<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/swiper.min.js" ></script>
	<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/index.js" ></script>
	<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/inner.js" ></script>
	<script type="text/javascript" src="<%=basePath%>/resource/shop/mobile/js/pay_success.js" ></script>
	
</body>
</html>
