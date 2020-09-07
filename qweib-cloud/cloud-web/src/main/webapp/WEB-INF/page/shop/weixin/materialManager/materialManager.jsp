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
	</head>
	<body class="easyui-layout" fit="true">
		<div data-options="region:'west',split:true,title:'功能导航'" style="width:200px;">
			<iframe name="leftframe" id="leftframe" src="/manager/WeixinConfig/materialManagerLeft" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%">
			</iframe>
		</div>
		<div data-options="region:'center'">
			<iframe name="mainiframe" id="mainiframe" src="" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		  $(function(){
			  toImageManager();
		  })  
		  //图片管理
		   function toImageManager(){
			  var url="/manager/WeixinConfig/toImageMaterialPage";
			   mainiframe.location.href=url;
		   }
		  //图文管理
		   function toNewsManager(){
			   var url="/manager/WeixinConfig/toNewsMaterialPage";
			   mainiframe.location.href=url;
		   }
		   //微信公众平台图片管理
		   function toWeixinImageManager(){
			   var url="/manager/WeixinConfig/toWeixinImageMaterialPage";
			   mainiframe.location.href=url;
		   }
		   //微信公众平台图文管理
		   function toWeixinNewsManager(){
			   var url="/manager/WeixinConfig/toWeixinNewsMaterialPage";
			   mainiframe.location.href=url;
		   }
		   
		</script>
	</body>
</html>
