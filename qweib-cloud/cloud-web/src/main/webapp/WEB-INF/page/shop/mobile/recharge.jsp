<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>充值页面</title>
	<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
	<style>

		*{
			margin: 0;
			padding: 0;
			-webkit-box-sizing: border-box;
			box-sizing: border-box;
		}

		ul.account_ul li {
			width: 25%;
			height: 55px;
			list-style: none;
			float: left;
		}

		a.account_a {
			height: 45px;
			position: relative;
			display: block;
			width: 85%;
			margin: 5px auto;
			text-decoration: none;
			border: solid 1px #3388FF;
			border-radius: 5px;
			text-align: center;
		}
		li .account_txt {
			display: block;
			text-align: center;
			font-size: 12px;
			color: #3388FF;
			margin: 0;
		}

		li.mui-active a{
			background-color: #3388FF;
		}

		li.mui-active .account_txt{
			color: #FFFFFF;
		}

		.my-pay-fs{
			background-color: #FFFFFF;
			margin-top: 10px;
		}
		.my-pay-fs p{
			font-size: 16px;
			color: #333333;
			line-height: 30px;
			padding-left: 20px;
			margin: 0;
		}
		.mui-icon-weixin{
			color: #00B700;
			margin-right: 5px;
		}
		.mui-table-view-cell a{
			font-size: 14px;
		}

		.mui-btn-block{
			padding: 8px;
			margin-top: 20px;
		}

	</style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
	<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
	<h1 class="mui-title">账户充值</h1>
</header>

<div class="mui-content">

	<ul class="account_ul" id="rechargeAmounts">
		<%--<li class="account_li mui-pull-left">
			<a href="#" class="account_a">
				<p class="account_txt mui-ellipsis">30积分</p>
				<p class="account_txt">售价30元</p>
			</a>
		</li>--%>
	</ul>

	<div class="my-pay-fs">
		<p>支付方式</p>
		<ul class="mui-table-view mui-table-view-radio">
			<li class="mui-table-view-cell mui-selected">
				<a class="mui-navigate-right"><span class="mui-icon mui-icon-weixin" style="color: #00B700;"></span>微信支付</a>
			</li>
			<%--<li class="mui-table-view-cell">
				<a class="mui-navigate-right">只在夜间开启</a>
			</li>
			<li class="mui-table-view-cell">
				<a class="mui-navigate-right">关闭</a>
			</li>--%>
		</ul>
	</div>

	<input type="hidden" id="mobile" value="${mobile}" />
	<input type="hidden" id="token" value="${token}" />
	<input type="hidden" id="orderNo" />

	<div class="mui-content-padded">
		<%--<button id="save" type="button" class="mui-btn mui-btn-primary mui-btn-block" >确认充值</button>--%>
	</div>


</div>

<script>
	mui.init();

	mui(".account_ul").on('tap','li',function(){
		//修改样式
		var $tag=$(this);//js对象转jquery对象
		$tag.siblings().removeClass("mui-active");
		$tag.addClass("mui-active");

		var id = this.getAttribute("value");
		var czAmount = this.getAttribute("czAmount");
		toSumbitPay(id,czAmount);
	})

	$(document).ready(function(){
		//$.wechatShare();//分享
		queryRechargeAmountList();
	})

	//获取充值面额列表
	function queryRechargeAmountList(){
		$.ajax({
			url:"<%=basePath%>/web/shopRechargeMobile/queryRechargeAmountList",
			data:{"token":"${token}"},
			type:"POST",
			success:function(json){
				if(json.state){
					var datas = json.obj;
					var str="";
					if(datas!=null && datas!= undefined && datas.length>0){
						for(var i=0;i<datas.length;i++){
/*						<li class="account_li mui-pull-left">
									<a href="#" class="account_a">
									<p class="account_txt mui-ellipsis">30积分</p>
							<p class="account_txt">售价30元</p>
									</a>
									</li>*/

							var data=datas[i];
							str += "<li class='account_li mui-pull-left' value='"+data.id+"' czAmount='"+data.czAmount+"'>";
							str += "<a  class='account_a'>";
							str += "<p class='account_txt'>"+data.czAmount+"元</p>";
							str += "<p class='account_txt'>赠送："+data.zsAmount+"元</p>";
							str += "</a>";
							str += "</li>";
						}
						$("#rechargeAmounts").html(str);
					}
				}
			}
		})
	}

	//添加；修改公用：以id区分
	function toSumbitPay(id,czAmount){

		//var mobile=$("#mobile").val();
		//var token = $("#token").val();
		/*if (mobile=="" || mobile==null){
			mui.alert("参数错误");
			return;
		}*/

		$.ajax({
			type: "POST",
			dataType: "json",
			url: "<%=basePath %>/web/shopRechargeMobile/addRechargePayLog",
			data: {"rechargeId":id }, //提交的数据
			success: function (result) {
				if(result!=null && result.state){
					//alert("充值成功");
					//history.back();
					$("#orderNo").val(result.obj);
					submitWxPay(czAmount);
				}
			},
			error : function() {
				mui.alert("异常！");
			}
		});
	}

	function submitWxPay(czAmount)
	{
		var token = $("#token").val();
		var orderNo = $("#orderNo").val();
		var mobile = $("#mobile").val();
		<%--window.location.href = "<%=basePath %>/web/userAuth?orderNo=" + orderNo + "&totalFee=" + this.czAmount + "&mobile=" + mobile + "&orderId=0";--%>
		toPage("<%=basePath %>/web/userAuth?token=${token}&orderNo=" + orderNo + "&totalFee=" + czAmount + "&mobile=" + mobile + "&orderId=0");
	}



</script>

</body>
</html>

