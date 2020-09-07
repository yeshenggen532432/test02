<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
	<title>其他应收帐款初始化</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		.product-grid td {
			padding: 0;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div uglcw-role="tabs">
	<ul>
		<li>供应商借款初始化</li>
		<li>客户借款初始化</li>
		<li>员工借款初始化</li>
	</ul>
	<div title="供应商借款初始化">
		<iframe src="${base}manager/finInitQtWlMain/toWljkPage?proType=0&bizType=CSHGYSJC"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
	<div title="客户借款初始化">
		<iframe src="${base}manager/finInitQtWlMain/toWljkPage?proType=2&bizType=CSHKHJC" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
	<div title="员工借款初始化">
		<iframe src="${base}manager/finInitQtWlMain/toWljkPage?proType=1&bizType=CSHYGJC"  frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init()
		var height = $(document).height() - $('ul.k-tabstrip-items').height() - 40;
		$('iframe').each(function (i, iframe) {
			$(iframe).attr('height', height + 'px');
		})
		uglcw.ui.loaded();
	})
</script>
</body>
</html>