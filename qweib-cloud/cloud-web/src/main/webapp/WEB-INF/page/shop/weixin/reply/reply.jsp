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
		<script src="<%=basePath%>/resource/clipboard.min.js"></script>
		<script type="text/javascript" src="resource/jquery.upload.js"></script>
		<style type="text/css">
		#tb{
			//background-color:#F4F4F4;
			background-color:rgb(224,236,255);
		}
		</style>
	</head>
	<body class="easyui-layout" fit="true">

		<div data-options="region:'west',split:true,title:'功能导航'" style="width:200px;">
			<iframe name="leftframe" id="leftframe" src="/manager/weiXinReply/toReplyLeft" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%">
			</iframe>
		</div>
		<div data-options="region:'center'">
			<iframe name="mainiframe" id="mainiframe" src="" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		  $(function(){
			  toSubscribeReply();
		  })  
		   function toSubscribeReply(){
			   //打开自定义被关注回复页面
			    var url="/manager/weiXinReply/toSubscribeReply";
			    mainiframe.location.href=url;	
		   }
		  function toReceiveReply(){
			   //打开自定义收到消息回复页面
			    var url="/manager/weiXinReply/toReceiveReply";
			    mainiframe.location.href=url;	
		   }
		  function toKeywordReply(){
			     //打开自定义关键词分页页面
			    var url="/manager/weiXinReply/toKeywordReply";
			    mainiframe.location.href=url;	
		   }
		  
		</script>
	</body>
</html>
