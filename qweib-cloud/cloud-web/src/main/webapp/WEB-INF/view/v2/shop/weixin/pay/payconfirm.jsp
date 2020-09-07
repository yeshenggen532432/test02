<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String picPath="";
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<script>
 	var path = '<%=basePath%>';
 	</script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <script src="<%=basePath%>/resource/shop/pay/js/jquery.2.1.4.min.js" type="text/javascript"></script>
    <script src="<%=basePath%>/resource/shop/pay/js/meta.js" type="text/javascript"></script>
    <script src="<%=basePath%>/resource/shop/pay/plugin/layer/layer.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/layer/need/layer.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/resource/shop/pay/css/webcss.css" rel="stylesheet" type="text/css">
    <link href="<%=basePath%>/resource/shop/pay/css/new_page.css" rel="stylesheet" type="text/css">
    <!---->
    <script src="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.min.js" type="text/javascript"></script>
    <link href="<%=basePath%>/resource/shop/pay/plugin/passwordBox/passwordBox.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
		<script type="text/javascript">
		
		function onBridgeReady(){
			
			WeixinJSBridge.invoke(
				      'getBrandWCPayRequest', {
				    	  "appId":"${appid}",     //公众号名称，由商户传入     
				           "timeStamp":"${timeStamp}",         //时间戳，自1970年以来的秒数     
				           "nonceStr":"${nonceStr}", //随机串     
				           "package":"${packageValue}",     
				           "signType":"MD5",         //微信签名方式：     
				           "paySign":"${sign}" //微信签名 
				      },
				      function(res){
				    	// 使用以下方式判断前端返回,微信团队郑重提示：res.err_msg将在用户支付成功后返回    ok，但并不保证它绝对可靠。 
				    		if(res.err_msg == "get_brand_wcpay_request:ok") {
				        	   alert("支付成功");
				        	   window.location.href="<%=basePath%>/web/success?token=${token}&orderId=${orderId}" + "&orderNo=${orderNo}"  +  "&payAmt=${totalFee}" + "&billType=0";
				           }else if(res.err_msg == "get_brand_wcpay_request:fail"){
				       			alert('支付失败');
				       		}else if(res.err_msg == "get_brand_wcpay_request:cancel"){
				       			alert('支付取消');
				       		}else{
				       			alert(res.err_msg);
				       		}
				   }); 
			   
			}
		
		if (typeof('WeixinJSBridge') == "undefined"){
			alert(11);
			   if( document.addEventListener ){
			       document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
			   }else if (document.attachEvent){
			       document.attachEvent('WeixinJSBridgeReady', onBridgeReady); 
			       document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
			   }
			}else{ 
				
			   //onBridgeReady();
			}	  	
		</script>	
    <title>Title</title>
</head>
<body style="background: #f5f5f5">
<div class="pub-head">
    <a class="back" href="#"></a>
    <p>微信支付</p>
</div>
<!---->
<div class="buying">
    <div class="buying-wrap">
        <div class="buying-top">
           
            <p>支付金额: ${totalFee}元</p>
            <p>订单号: ${orderNo}</p>
        </div>
        <div class="buying-bottom">
           
        </div>
    </div>
</div>
<p class="h30_gray"></p>
<div class="release-btn blue2">
    <a href="#" onclick="javascript:onBridgeReady();return false;">支付</a>
</div>
<!---->
<input type="hidden" id="orderId" value="${orderId}" />
<input type="hidden" id="totalFee" value="${totalFee}" />
<input type="hidden" id="mobile" value="${mobile}" />
<input type="hidden" id="orderNo" value="${orderNo}" />
<input type="hidden" id="token" value="${token}" />

<script>
    //弹出输入支付密码
    
</script>


</body>
</html>