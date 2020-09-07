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
		<style type="text/css">
		</style>
	</head>
	<body>
		<%--选择商品查看会员最终执行表--%>
		<div id="tb11">
			<div>
				<div id="colorMember" style="margin: 10px">
					(备注:以下表格颜色区分:
					<span style="color:orange;margin-right: 10px">1.进销存商品基础价;</span>
					<span style="color:#333;margin-right: 10px">2.商城商品基础价;</span>
					<span style="color:blue;margin-right: 10px">3.商城会员等级价格;</span>
					<span style="color:green;">4.商城会员自定义价格</span>
					)
				</div>
				<div>
					<input name="wareId" id="wareId" value="" hidden="true"/>
					<a id="aSelectWare" class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectWare();">选择商品</a>
					<span name="wareNmSpan" id="wareNmSpan" style="font-size: 20px;font-weight: bold;"></span>
				</div>
			</div>
		</div>

		<div class="easyui-tabs" style="width:100%;height:90%" fit="true">
			<div title="常规会员">
				<iframe src="manager/shopEndPrice/toPtEndPriceByWare?wareId=${wareId}" name="ptfrm" id="ptfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
			<div title="员工会员">
				<iframe src="manager/shopEndPrice/toYgEndPriceByWare?wareId=${wareId}" name="ygfrm" id="ygfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
			<div title="进销存客户会员">
				<iframe src="manager/shopEndPrice/toKhEndPriceByWare?wareId=${wareId}" name="khfrm" id="khfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
			</div>
		</div>

		<%--选择商品对话框--%>
		<div id="wareDlg" closed="true" class="easyui-dialog" style="width:500px; height:200px;" title="商品选择" iconCls="icon-edit"></div>

		<script type="text/javascript">
			//弹出“选择商品”对话框
			function dialogSelectWare(){
				$('#wareDlg').dialog({
					title: '商品选择',
					iconCls:"icon-edit",
					width: 800,
					height: 400,
					modal: true,
					href: "<%=basePath %>/manager/shopWare/dialogWareType",
					onClose: function(){
					}
				});
				$('#wareDlg').dialog('open');
			}

			//选择商品-回调
			function callBackFun(wareId,wareNm){
				$('#wareDlg').dialog('close');
				$("#wareId").val(wareId);
				$("#wareNmSpan").text("*"+wareNm+"*最终商品价格");
				queryMember();
			}

			//查询会员
			function queryMember(){
				var wareId = $("#wareId").val();;
				document.getElementById("ptfrm").src="manager/shopEndPrice/toPtEndPriceByWare?wareId="+wareId;
				document.getElementById("ygfrm").src="manager/shopEndPrice/toYgEndPriceByWare?wareId="+wareId;
				document.getElementById("khfrm").src="manager/shopEndPrice/toKhEndPriceByWare?wareId="+wareId;
			}
		</script>
	</body>
</html>
