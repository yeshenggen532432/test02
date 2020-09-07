<%@ page contentType="text/html; charset=UTF-8"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
System.out.println("in jsapi.jsp");
%>
<!DOCTYPE html>
<html>
	<head>
		<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
		<script type="text/javascript">
		
		function onBridgeReady(){
			alert(22);
			alert("appid:${appid}" );
			alert("timeStamp:${timeStamp}");
			alert("nonceStr:${nonceStr}");
			alert("package:${packageValue}");
			alert("paySign:${sign}");
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
				      if(res.err_msg == "get_brand_wcpay_request:ok" ){
				      // 使用以上方式判断前端返回,微信团队郑重提示：
				            //res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
				            alert("ok");
				      } 
				      else
				    	  {
				    	  alert("error111");
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
				alert(123);
			   //onBridgeReady();
			}	  	
		</script>	
	    <title>订单-支付</title>
	</head>
<body onload="payclick()">
<div>
<button type="button" id="paybtn"  onclick="javascript:onBridgeReady();return false;">Click Me!</button>
</div>
	<script type="text/javascript">
		
		function payclick()
		{
			//style= "display:none"
			alert(2345);
			//$("#paybtn").click();
			onBridgeReady();
			return false;
		}
		//$("#paybtn").onclick();
	</script>
</body>
</html>
