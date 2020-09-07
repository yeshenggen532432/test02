<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>"/>
		<title>登录</title>
	</head>

	<body>
		<script type="text/javascript">
			var windowFrm = window;
			for(var i=0;i<4;i++){
				if(windowFrm.parent==undefined){
					break;
				}else{
					windowFrm = windowFrm.parent;
				}
			}
			windowFrm.location.href="<%=basePath%>manager/login";
		</script>
	</body>
</html>
