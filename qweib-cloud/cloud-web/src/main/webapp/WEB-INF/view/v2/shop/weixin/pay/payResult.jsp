<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
<link href="<%=basePath%>/resource/shop/mobile/css/reset.css" rel="stylesheet">
<title>支付成功</title>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
	<div id="wrapper" class="m_pwd">
		<div class="int_title">
			订单
		</div>

		<div class="pay_success topline">
			<div class="pay_s_box">
				<div class="pay_s_b_pic clearfix">
					<p class="pay_pic_text fl">
						<span style="font-size: 0.6rem">订单号 : <font id="orderId" style="font-size: 0.6rem">${orderNo}</font></span>
						<span style="font-size: 0.6rem">订单金额 :<font id="cjje" style="font-size: 0.6rem">${payAmt}</font></span>
					</p>
				</div>
				<div class="pay_btn clearfix">
					<%-- <a href="<%=basePath%>/web/shopBforderMobile/toMyOrder?token=${token}" class="pay_a_btn p_money fl"> 查看订单</a> --%> 
					<a href="<%=basePath%>/web/shopBforderMobile/toOrderDetails?token=${token}&id=${orderId}" class="pay_a_btn p_money fl"> 查看订单</a> 
					<a href="<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}" class="pay_a_btn p_money fr"> 返回首页 </a>
				</div>
			</div>
		</div>

		<script type="text/javascript"
			src="<%=basePath%>/resource/shop/mobile/js/rem.js"></script>
		<script type="text/javascript"
			src="<%=basePath%>/resource/shop/mobile/js/pay_success.js"></script>

		<script type="text/javascript">
			//返回上个界面
		    function onBack(){
		    	history.back();
		    }
			
			$(document).ready(function(){
				//queryShopBforderMobile();
 			})
 			
 			
		</script>
</body>
</html>
