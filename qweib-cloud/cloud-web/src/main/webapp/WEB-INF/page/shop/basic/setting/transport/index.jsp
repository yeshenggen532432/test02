<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>运费配置主页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="resource/loadDiv.js"></script>
	<style type="text/css">
	</style>
</head>
<body>

<div id="tt" class="easyui-tabs" style="width:100%;height:90%" fit="true">
	<div title="同城模版">
		<iframe src="/manager/shopSetting/toPage?name=location_transport" name="ptfrm" id="ptfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>


	<div title="城际模版">
		<iframe name="tyfrm" id="tyfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
</div>
<script type="text/javascript">
	$('#tt').tabs({
		border:false,
		onSelect:function(title,index){
			if(title=='城际模版'){
				if(!document.getElementById("tyfrm").src)
				document.getElementById("tyfrm").src="${base}/manager/shopTransport/toList";
			}
		}
	});
</script>
</body>
</html>
