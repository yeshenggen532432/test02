<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="base" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>下载页</title>
	<meta content="target-densitydpi=device-dpi,width=640" name="viewport"> 
	<!-- uc强制竖屏 -->
    <meta name="screen-orientation" content="portrait">
    <!-- QQ强制竖屏 -->
    <meta name="x5-orientation" content="portrait">
	<link rel="stylesheet" href="${base }/resource/loadpage/css/reset.css">
	<link rel="stylesheet" href="${base }/resource/loadpage/css/base.css">
	<script type="text/javascript" src="${base }/resource/loadpage/js/zepto.min.js"></script>
</head>
<script type="text/javascript">
	// 判断是否是微信
    function isWeixn(){
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i)=="micromessenger") {
        return true;
    } else {
        return false;
     }
    }
	function toload(tp){
		var isWeix = isWeixn();
	    if(isWeix){
	    	$("#alertCon").show();
	    }else{
	    	if(tp=='2'){//安卓
	    		location.href="${android}";
	    	}else if(tp=='1'){//ios
	    		alert(411);
	    		// 判断系统版本号是否大于 6
				var version = navigator.userAgent.match(/OS [7-9]_\d[_\d]* like Mac OS X/i);
				if(version!=null&&typeof version !='undefined'){
					var test = version.toString();
					test = test.substring(test.indexOf(' '),test.indexOf('like'));
					var firstNum = test.substring(0,test.indexOf('_'));
					var secondeNum;
					if(test.length == 7){
						secondeNum=test.substring(test.indexOf('_')+1,test.lastIndexOf('_'));
					}else{
						secondeNum=test.substring(test.indexOf('_')+1);
					}
					if(parseInt(firstNum) == 7&& parseInt(secondeNum) >= 1){
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=https://cnlife.xmhx.com/CnlifeApp.plist";
					}else if(parseInt(firstNum) >= 8){
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=https://cnlife.xmhx.com/CnlifeApp.plist";
					}else{
						document.getElementById('iphoneUrl').href="itms-services://?action=download-manifest&amp;url=http://cnlife.xmhx.com/CnlifeApp.plist";
					}
				}
	    	}
	    }
	}
	
	//关闭定位框
	function toclose(){
		$("#alertCon").hide();
	}
</script>
<body>
	<div class="wrap">
		<header cleafix>
			<a href="" title=""></a>
			<img src="${base }/resource/loadpage/image/font.png" alt="" title="">
		</header>
		<div class="load clearfix">
			<h2>企微宝客户端下载</h2>
			<img src="${base }/resource/loadpage/image/onload.png" alt="" title="">
		</div>
		<div class="load-list clearfix">
			<div class="list">
				<a id="iphoneUrl" href="javascript:;" onclick="toload('1');" title=""><span>iphone下载</span></a>
				<c:if test="${empty type}">
					<a id="anda" href="javascript:;" onclick="toload('2');" title=""><span>安卓下载</span></a>
				</c:if>
			</div>
			<p>微信用户请点击右上角用浏览器下载</p>
		</div>
	</div>
	<div class="alert-con" id="alertCon">
		<button onclick="toclose();"></button>
    </div>
	<script type="text/javascript" src="${base }/resource/loadpage/js/MetaHandler.js"></script>
</body>
</html>