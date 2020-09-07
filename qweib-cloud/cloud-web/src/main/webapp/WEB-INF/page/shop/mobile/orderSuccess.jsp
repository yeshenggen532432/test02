<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- --------head开始----------- -->
<head>
<title>下单成功</title>
	<%@include file="/WEB-INF/page/shop/mobile/include/source.jsp"%>
</head>
<!-- --------head结束----------- -->
<!-- --------body开始----------- -->
<body>
	<div id="wrapper" class="m_pwd">
		<div class="int_title">
			<span class="int_pic" onclick="onBack();"><img
				src="<%=basePath%>/resource/shop/mobile/images/jifen/left.png" /></span>订单
		</div>

		<div class="pay_success topline">
			<div class="pay_s_box">
				<div class="pay_s_b_pic clearfix">
					<p class="pay_pic_text fl">
						<span style="font-size: 0.6rem">订单号 : <font id="orderId" style="font-size: 0.6rem"></font></span>
						<span style="font-size: 0.6rem">订单金额 :<font id="orderAmount" style="font-size: 0.6rem"></font></span>
					</p>
				</div>
				<div class="pay_btn clearfix">
					<%--<a href="<%=basePath%>/web/shopBforderMobile/toOrderDetails?id=${orderId}" class="pay_a_btn p_money fl"> 查看订单</a>--%>
					<%--<a href="<%=basePath %>/web/mainWeb/toIndex" class="pay_a_btn p_money fr"> 返回首页 </a>--%>
					<a href="javascript:toPage('<%=basePath%>/web/shopBforderMobile/toOrderDetails?token=${token}&id=${orderId}')" class="pay_a_btn p_money fl"> 查看订单</a>
					<a href="javascript:toPage('<%=basePath %>/web/mainWeb/toIndex?token=${token}&companyId=${companyId}')" class="pay_a_btn p_money fr"> 返回首页 </a>
				</div>
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
				//$.wechatShare();//分享
				queryShopBforderMobile();
 			})
 			
 			//获取默认地址
 			function queryShopBforderMobile(){
 				$.ajax({
			            type: "POST",                  //提交方式
			            dataType: "json",              //预期服务器返回的数据类型
			            url: "<%=basePath%>/web/shopBforderMobile/queryShopBforderDetail",
						data : {
							token : "${token}",
							orderId : ${orderId}
						}, //提交的数据
						success : function(json) {
							if (json.state) {
								$("#orderId").text("" + json.obj.orderNo);
								$("#orderAmount").text("" + json.obj.orderAmount);
							}
						}
					});
			}
		</script>
</body>
</html>
