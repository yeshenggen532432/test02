<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>微信素材管理</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link href="${base}resource/shop/weixin/css/menuConfigLeftBar.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
			<div title="微信素材管理" data-options="" style="">
				<dl class="menuConfigLeftBar">
					<dd>
						<a href="javascript:parent.toImageManager();">图片管理</a>	
					</dd>
					<dd>
						<a href="javascript:parent.toNewsManager();">图文管理</a>	
					</dd>
					<dd>
						<a href="javascript:parent.toWeixinImageManager();">微信公众平台图片管理</a>	
					</dd>
					<dd>
						<a href="javascript:parent.toWeixinNewsManager();">微信公众平台图文管理</a>	
					</dd>
				</dl>
			</div>
	</body>
</html>
