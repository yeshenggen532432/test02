<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>往来借款初始化导入</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>
	<body>
	<div id="easyTabs" class="easyui-tabs" style="width:auto;height: 550px">
		<div title="供应商借款初始化">
			<iframe  name="wljkfrm0" id="wljkfrm0" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="客户借款初始化">
			<iframe  name="wljkfrm1" id="wljkfrm1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="员工借款初始化">
			<iframe  name="wljkfrm2" id="wljkfrm2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
	</div>
	</body>
	<script type="text/javascript">
		$('#easyTabs').tabs({
			border:false,
			onSelect:function(title){
				if(title=="供应商借款初始化"){
					document.getElementById("wljkfrm0").src='${base}manager/finInitQtWlMain/toWljkPage?proType=0&bizType=CSHGYSJC';
				}else if(title=="客户借款初始化"){
					document.getElementById("wljkfrm1").src='${base}manager/finInitQtWlMain/toWljkPage?proType=2&bizType=CSHKHJC';
				}else if(title=="员工借款初始化"){
					document.getElementById("wljkfrm2").src='${base}manager/finInitQtWlMain/toWljkPage?proType=1&bizType=CSHYGJC';
				}
			}});
	</script>
</html>
