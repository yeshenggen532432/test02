<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>出库</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
	<header class="fixed_top">
		<a href="stkPayMng?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>核销</h1>
		</header>
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="proId" id="proId" value="${proId}"/>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
		<div class="order_count">
			<ul>
				<li>
					收款对象
					<div class="order_mes fr">
						${proName} 
					</div>
				</li>
				<li>
					已付款 &nbsp;&nbsp;<a style="color:red;width:60px">${payAmt}</a>&nbsp;&nbsp; 还需收&nbsp;&nbsp;<a style="color:red;width:60px">${needPay}</a>
					
				</li>
				<li>
					 核销金额
					<div class="order_mes fr">
						<span><input type="text" placeholder="请点击输入" id="cashpay" style="text-align:right" value ="${needPay}"/></span>
					</div>
				</li>
				
				
			</ul>
			<div class="order_mark">
				<input type="text" name="remarks" id="remarks" value="" placeholder="备注（最多输入100个字）"/>
			</div>
			<div class="order_btn2 clearfix">
				<!--  <a href="javascript:;"><img src="<%=basePath %>/resource/stkstyle/img/icon21.png"/>2017-07-30</a>
				<a href="javascript:;"><img src="<%=basePath %>/resource/stkstyle/img/icon21.png"/>SKD2017070001.A</a>-->
			</div>
		</div>
		<div class="bottom_fixed_btn">
			
			<div class="item"><a href="javascript:submitPay();">保存</a></div>
		</div>
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	function submitPay()
	{		
		var billId = $("#billId").val();
		var cash = $("#cashpay").val();
		
		var remarks = $("#remarks").val();
		//alert(billId);
		var needPay = ${needPay};
					
		if(parseFloat(needPay)< parseFloat(cash))
		{
			alert("支付金额不能大于应付金额");
			return;
		}
		
		var path = "updateFreeAmt";
		var token = $("#tmptoken").val();
		if (!confirm('是否确定核销？'))return;
		$.ajax({
	        url: path,
	        type: "POST",
	        data : {"token":token,"billId":billId,"remarks":remarks,"freeAmt":cash},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        	
	        	if(json.state){
	        		
	        		alert("提交成功");
	        		window.location.href='stkPayMng?token=' + token;
	        	}
	        	else
	        	{
	        		alert(json.msg);
	        	}
	        }
	    });
	}
	</script>
</html>