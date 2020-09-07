<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员分页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
	<body>
	<div class="easyui-tabs" id="easyui-tabs" style="width:100%;height:100%" fit="true">
		<div title="常规会员">
			<iframe src="manager/shopMember/toShopMemberPage?source=1" id="iframe1" name="iframe1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="员工会员">
			<iframe  id="iframe2"  name="iframe2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="进销存客户会员">
			<iframe  id="iframe3" name="iframe3"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="门店会员">
			<iframe  id="iframe4" name="iframe4"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
	</div>
	</body>
</html>
<script type="text/javascript">
	$('#easyui-tabs').tabs({
		border:false,
		onSelect:function(title){
			if(title=="常规会员"){
				document.getElementById("iframe1").src="${base}manager/shopMember/toShopMemberPage?source=1";
			}else if(title=="员工会员"){
				document.getElementById("iframe2").src="${base}manager/shopMember/toShopMemberPage?source=2";
			}else if(title=="进销存客户会员"){
				document.getElementById("iframe3").src="${base}manager/shopMember/toShopMemberPage?source=3";
			}else if(title=="门店会员"){
				document.getElementById("iframe4").src="${base}manager/shopMember/toShopMemberPage?source=4";
			}
	}});
</script>
