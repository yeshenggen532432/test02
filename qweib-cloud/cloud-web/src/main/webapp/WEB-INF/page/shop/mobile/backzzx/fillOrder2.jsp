<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<%@include file="/WEB-INF/page/shop/mobile/include/source2.jsp"%>
<head>
	<meta charset="UTF-8">
	<meta name="Keywords" content="">
	<meta name="Description" content="">
	<meta name="format-detection" content="telephone=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0,minimum-scale=1.0">
	<%--<title>收货地址</title>--%>
	<style type="text/css">
		input{
			border: none;
			outline: none;
			font-size: 14px;
			color: #333333;
		}
		.mui-media {
			font-size: 14px;
		}

		.mui-table-view .mui-media-object {
			max-width: initial;
			width: 90px;
			height: 70px;
		}

		.meta-info {
			position: absolute;
			left: 115px;
			right: 15px;
			top: 40px;
			color: #8f8f94;
		}

		.meta-info .author,
		.meta-info .time {
			display: inline-block;
		}

		.meta-info .author {
			width: 70%;
			font-size: 12px;
			color: #8f8f94;
		}

		.meta-info .time {
			float: right;
			width: 30%;
			text-align: right;
			font-size: 12px;
			color: #8f8f94;
		}

		.mui-table-view:before,
		.mui-table-view:after {
			height: 0;
		}

		.mui-content>.mui-table-view:first-child {
			margin-top: 1px;
		}

		.meta-money {
			position: absolute;
			left: 115px;
			right: 15px;
			bottom: 8px;
			color: red;
			font-size: 12px;
		}

		.mui-content{
			padding-bottom: 40px;
		}

		.my-footer{
			position: fixed;
			bottom: 0;
			left: 0;
			right: 0;
			height: 40px;
		}
		.red{
			color: red;
			font-size: 16px;
		}

		#shr{
			display: inline-block;
			width: 60px;
		}
		#tel{
			display: inline-block;
		}
		input#address{
			display: block;
			width: 100%;
			font-size: 12px;
			color: #8f8f94;
		}
		#hasAddress{
			display: none;
		}

	</style>
</head>

<!-- --------body开始----------- -->
<body>
<header class="mui-bar mui-bar-nav">
	<a class="mui-action-back mui-icon mui-icon-left-nav mui-pull-left"></a>
	<h1 class="mui-title">订单提交</h1>
</header>


<div class="mui-content ">
	<form action="" name="savefrm" id="savefrm" method="post">

		<ul class="mui-table-view mui-table-view-chevron" onclick="javaScript:toAddress();">
			<li class="mui-table-view-cell">
				<a class="mui-navigate-right" href="javaScript:toAddress();">
					<div class="mui-media-body" id="hasAddress">
						<div>
							<input id="shr" name="shr" value = "${sysBforder.shr}" class='mui-ellipsis' readonly="readonly">
							<input id="tel" name="tel" value = "${sysBforder.tel}" class='mui-ellipsis' readonly="readonly">
						</div>
						<input id="address" name="address" value = "${sysBforder.address}" class='mui-ellipsis' readonly="readonly">
					</div>
					<div class="mui-media-body" id="noaddress">
						设置收货地址
					</div>
				</a>
			</li>
		</ul>

		<ul class="mui-table-view">
			<c:forEach items="${sysBforder.list}" var="item" varStatus="s" >
				<li class="mui-table-view-cell mui-media" >
						<%--<img class="mui-media-object mui-pull-left" src="item.cover">--%>
					<c:choose>
						<c:when test="${ not empty item.warePicList}">
							<!-- set设置中间变量 flag 默认第一张，有主图显示主图-->
							<c:set var="flag" value="0"/>
							<c:forEach items="${item.warePicList}" var="pic"  >
								<c:if test="${pic.type eq 1 }">
									<img class="mui-media-object mui-pull-left" src="<%=basePath%>/upload/${pic.picMini}">
									<c:set var="flag" value="1"/>
								</c:if>
							</c:forEach>
							<c:if test="${flag eq 0 }">
								<img class="mui-media-object mui-pull-left" src="<%=basePath%>/upload/${item.warePicList[0].picMini}">
							</c:if>
						</c:when>
						<c:otherwise>
							<img class="mui-media-object mui-pull-left" src="<%=basePath%>/resource/shop/mobile/images/ic_normal.jpg">
						</c:otherwise>
					</c:choose>
					<div class="mui-media-body">
						<input id="wareNm${s.index }" name="list[${s.index }].wareNm" readonly="readonly"  value="${item.wareNm}" class="mui-ellipsis" />
					</div>
					<div class="meta-info">
						<div class="author">规格：${item.wareGg}</div>
						<input id="wareNum${s.index }" name="list[${s.index }].wareNum" readonly="readonly" value="${item.wareNum}" class="time"/>
					</div>
					<input id="wareDj${s.index }" name="list[${s.index }].wareDj" readonly="readonly"  value = "${item.wareDj}" class="meta-money" /><input id="wareId${s.index }" type="hidden" name="list[${s.index }].wareId" value = "${item.wareId}"/>

						<%--一些隐藏数据--%>
					<input id="xsTp${s.index }" type="hidden" name="list[${s.index }].xsTp" value = "${item.xsTp}"/>
					<input id="wareDw${s.index }" type="hidden" name="list[${s.index }].wareDw" value = "${item.wareDw}"/>
					<input id="beUnit${s.index }" type="hidden" name="list[${s.index }].beUnit" value = "${item.beUnit}"/>
					<input id="wareZj${s.index }" type="hidden" name="list[${s.index }].wareZj" value = "${item.wareZj}"/>

				</li>
			</c:forEach>
		</ul>

		<nav class="mui-table-view my-footer">
			<li class="mui-table-view-cell">
            <span class="red">
                实付款:￥
                <input id="zje" name="zje" readonly="readonly" value="${sysBforder.zje}" class="red"/>
            </span>
				<button type="button" class="mui-btn mui-btn-primary" onclick="javascript:toSumbit();">确认提交</button>
			</li>
		</nav>

	</form>
</div>



<script>
	mui.init();

	$(document).ready(function(){
		$.wechatShare();//分享
		//解决ios返回页面无法刷新的问题-start
		var isPageHide = false;
		window.addEventListener('pageshow', function () {
			if (isPageHide) {
				window.location.reload();
			}
		});
		window.addEventListener('pagehide', function () {
			isPageHide = true;
		});
		//解决ios返回页面无法刷新的问题-end

		getDefaultAddress();
		//总金额显示保留两位小数
		var zje=${sysBforder.zje};
		$("#zje").val(zje.toFixed(2));
	})

	//获取默认地址
	function getDefaultAddress(){
		$.ajax({
			type: "POST",                  //提交方式
			dataType: "json",              //预期服务器返回的数据类型
			url: "<%=basePath %>/web/shopMemberAddressMobile/queryMemberDefaultAddress",
			data: "token=${token}", //提交的数据
			success: function (json) {
				if(json.state){
					var $shr=$("#shr");
					var $tel=$("#tel");
					var $address=$("#address");
					$shr.val(json.linkman);
					$tel.val(json.mobile);
					$address.val(json.address);

					$('#hasAddress').show();
					$('#noaddress').hide()
				}else{
					$('#hasAddress').hide();
					$('#noaddress').show();
				}
			}
		});
	}

	/**
	 *跳到收货地址
	 */
	function toAddress() {
		<%--window.location.href = '<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?type=2';--%>
		window.location.href = '<%=basePath %>/web/shopMemberAddressMobile/toReceiptInfo?token=${token}&type=2';
	}

	/**
	 * 提交
	 */
	function toSumbit(){
		var shr=$("#shr").val();
		var tel=$("#tel").val();
		var address=$("#address").val();
		if (shr=="" || shr==null || tel=="" || tel==null){
			mui.alert("请设置收货地址");
			return;
		}

		$.ajax({
			type: "POST",                  //提交方式
			dataType: "json",              //预期服务器返回的数据类型
			url: "<%=basePath %>/web/shopBforderMobile/addOrder?token=${token}&type=${type}",
			data: $('#savefrm').serialize(), //提交的数据
			success: function (result){
				if(result.state){
					<%--window.location.href="<%=basePath%>/web/shopBforderMobile/toOrderPay?id="+result.orderId;--%>
					window.location.href="<%=basePath%>/web/shopBforderMobile/toOrderPay?token=${token}&id="+result.orderId;
				}
			},
			error : function() {
				mui.toast("异常！");
			}
		});
	}



</script>

</body>
</html>
