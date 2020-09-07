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
    <script src="${_ctx}/resource/shop/mobile/js/tool.js?v=2020011901" type="text/javascript"></script>
    <%--<title>Title</title>--%>
</head>
<body style="background: #f5f5f5">
<div class="pub-head">
    <a class="back" href="#"></a>
    <p>余额支付</p>
</div>
<!---->
<div class="buying">
    <div class="buying-wrap">
        <div class="buying-top">
            <h3>${mobile} FM</h3>
           
            <p>剩余金额: ${cardAmt}</p>
            <p>本次消费: ${totalFee}</p>
            <p>订单号: ${orderNo}</p>
        </div>
        <div class="buying-bottom">
           
        </div>
    </div>
</div>
<p class="h30_gray"></p>
<div class="release-btn blue2">
    <a href="#" onclick="pay()">支付</a>
</div>
<!---->
<input type="hidden" id="orderId" value="${orderId}" />
<input type="hidden" id="totalFee" value="${totalFee}" />
<input type="hidden" id="mobile" value="${mobile}" />
<input type="hidden" id="orderNo" value="${orderNo}" />

<script>
    //弹出输入支付密码
    function pay(){
        /**
         * init传入参数依次是：正确密码(传空时不对比输入是否正确),密码键盘背景，标题，副标题
         * */
        PwdBox.init('123456','/images/pwd_keyboard.png','请输入支付密码','安全支付环境，请放心使用！');
        /**
         *res格式：{status:'true或false',password:'用户输入的密码'}
         *
         */
        PwdBox.show(function(res){
            if(res.status){
                //重置输入
                //alert(res.password);
                //关闭并重置密码输入
                submitCardPay(res.password);
                PwdBox.reset();
            }else{
				/*alert(res.password);
                alert(JSON.stringify(arguments));              
                layer.open({
                    content: '密码不正确'
                    ,skin: 'msg'
                    ,time: 2 
                });*/
            	submitCardPay(res.password);
            	PwdBox.reset();
            }
        });
    }
    
    function submitCardPay(psw)
	{
		var orderId = $("#orderId").val();
		var totalFee = $("#totalFee").val();
		var mobile = $("#mobile").val();		
		var orderNo = $("#orderNo").val();
		if (mobile=="" || mobile==null){
			alert("参数错误");
			return;
		}
		
		
        $.ajax({
            type: "POST",                  //提交方式
            dataType: "json",              //预期服务器返回的数据类型
            url: "<%=basePath %>/web/cardConsumeProc?token=${token}",
            data:{"orderId":orderId,"totalFee":totalFee,"psw":psw,"orderNo":orderNo}, //提交的数据
            success: function (result){
                if(result.state){
	                $("#submit").removeAttr("href");//去掉a标签中的href属性
	                //备注：按钮变灰色
	                alert("支付成功");
	                //window.location.href="<%=basePath%>/web/shopBforderMobile/toOrderPay?token=${token}&id="+orderId;
                    toPage("<%=basePath%>/web/shopBforderMobile/toPaySuccess?token=${token}&orderId="+orderId + "&orderNo=" + orderNo  + "&payAmt=" + totalFee);
                }else{
                    alert(result.msg);
                }
            },
            error : function() {
                alert("异常！");
            }
        });
	}
</script>


</body>
</html>