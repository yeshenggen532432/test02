<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>微信公众号配置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<link href="${base}resource/shop/weixin/css/menuConfigLeftBar.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
			<div title="微信公众号配置" data-options="" style="">
				<dl class="menuConfigLeftBar">
					<dd>
						<a href="javascript:parent.toUpdateConfig();">公众号配置</a>	
					</dd>
					<dd>
						<a href="javascript:parent.toUpdatePayConfig();">公众号支付配置</a>	
					</dd>
					<dd>
						<a href="javascript:parent.toSetCustomerService();">客服人员分配</a>
					</dd>
					<dd>
						<a href="javascript:parent.registerWeixinHelp();">如何注册微信公众平台账号</a>	
					</dd>
					<dd>
						<a href="javascript:parent.configAppidAppsecretHelp();">如何配置appid与appsecret</a>	
					</dd>
					<dd>
						<a href="javascript:parent.configUrlTokenHelp();">如何配置url与token</a>	
					</dd>
				</dl>
			</div>
	</body>
</html>
