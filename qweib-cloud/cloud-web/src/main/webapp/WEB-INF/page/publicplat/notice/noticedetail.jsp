<%@ page language="java" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>公告管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	<form>
		<div class="box" align="center" style="margin-top: 30px;">
			<p style="font-weight: bolder">${notice.noticeTitle}</p>
			<p style="font-size: 14px;color: #A1A1A1;">${notice.noticeTime}</p>
			<hr align="center" width="80%" style= "border:1 dashed #D3D3D3;" />
		</div>	
		<div style="margin-top: 5px; width: 100%;display:block;word-break: break-all;word-wrap: break-word;">
		<div style="width: 100%;display:block;word-break: break-all;word-wrap: break-word;">
		${notice.noticeContent}
		</div>
	</div>
		<div class="f_reg_but" style="padding-top:50px;margin-left: 40%">
			<input type="button" value="返回" class="b_button" onclick="toback();"/>
		</div>
	</form>
	<script type="text/javascript">
	function toback(){
		location.href="${base}/manager/tonotice";
	}
	</script>
	</body>
</html>
