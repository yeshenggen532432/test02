<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
		<div id="easyTabs" class="easyui-tabs" style="width:auto;height:550px">
			 <div title="待付报销单据" >
				 <iframe src="${base}/manager/toFinPayPage" name="costForm" id="costForm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			 </div>
			  <div title="待审付款单据">
			  		<iframe src="${base}/manager/toFinPayUnAudit" name="payForm1" id="payForm1" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			  </div>
			<div title="按付款对象统计">
				<iframe src="${base}/manager/toGroupProNamePayPage" name="payFormProName" id="payFormProName" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>

			<div title="按费用项目统计">
				<iframe src="${base}/manager/toGroupItemNamePayPage" name="payFormItemName" id="payFormItemName" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>

			<div title="付款单据列表">
				<iframe src="${base}/manager/toFinPayHis" name="payForm2" id="payForm2" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
		</div>

	</body>
</html>
