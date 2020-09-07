<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>司机配送列表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
</head>

<body class="easyui-layout">
<div data-options="region:'west',split:true,title:''"
	 style="width:150px;padding-top: 5px;">

	<ul class="easyui-tree">
		<li>
			<span>司机列表</span>
			<ul>
				<c:set var="datas" value="${fns:loadListByParam('stk_driver','id,driver_name','status=1 or status is null')}"/>
				<c:set var="driverId"/>
				<c:forEach items="${datas}" var="data" varStatus="s">
					<c:if test="${s.index eq 0}">
						<c:set var="driverId" value="${data['id']}"/>
					</c:if>
					<li ><a href="javascript:;;" onclick="showMap(${data['id']})">${data['driver_name']}</a></li>
				</c:forEach>
			</ul>
		</li>
	</ul>

</div>
<div id="mainDiv" data-options="region:'center'">
	<iframe src="manager/stkDelivery/driverMap?driverId=${driverId}&psState=${psState}" name="mainfrm" id="mainfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
</div>
<script type="text/javascript">
	function showMap(id){
		window.frames['mainfrm'].document.getElementById('driverId').value=id;
		window.frames['mainfrm'].toquerycmap();
	}
</script>
</body>
</html>
