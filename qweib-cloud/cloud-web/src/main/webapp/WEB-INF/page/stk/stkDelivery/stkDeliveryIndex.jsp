<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>销售物流配送管理</title>
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
		<div title="待发货销售发票" >
			<iframe src="${base}/manager/stkDelivery/toStkOutPageForDelivery" name="stkOutFrm" id="stkOutFrm" frameborder="0" marginheight="0" marginwidth="0"  width="100%" height="100%"></iframe>
		</div>
		<div title="待分配">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=0&status=-2" name="deliveryfrm0" id="deliveryfrm0" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="待接收">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=1&status=-2" name="deliveryfrm1" id="deliveryfrm1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="已接收">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=2&status=-2" name="deliveryfrm2" id="deliveryfrm2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="配送中">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=3&status=-2" name="deliveryfrm3" id="deliveryfrm3" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="已收货">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=4&status=-2" name="deliveryfrm4" id="deliveryfrm4" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="已生成发货单">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=6&status=1" name="deliveryfrm6" id="deliveryfrm6" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="配送终止">
			<iframe src="${base}/manager/stkDelivery/toPage?psState=5&status=-2" name="deliveryfrm5" id="deliveryfrm5" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<div title="配送单列表">
			<iframe src="${base}/manager/stkDelivery/toPage" name="deliveryfrm" id="deliveryfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>

		<div title="司机路线图">
			<iframe src="${base}/manager/stkDelivery/toDriverMap" name="driverfrm" id="driverfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>

	</div>
	</body>
</html>
