<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商品类别</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body class="easyui-layout">
		<div data-options="region:'west',split:true,title:'商品分类树'"
			style="width:150px;padding-top: 5px;">
			<ul id="waretypetree" class="easyui-tree"
				data-options="url:'manager/waretypes',animate:true,dnd:true,onClick: function(node){
					toShowStockWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
			</ul>
		</div>
		<div id="wareTypeDiv" data-options="region:'center'" title="收发存商品信息">
			<iframe src="manager/querysfcstksummary?waretype=0" name="stockWarefrm" id="stockWarefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
			//点击商品分类树查询
			function toShowStockWare(id){
				document.getElementById("stockWarefrm").src="${base}/manager/querysfcstksummary?waretype="+id;
			}
		</script>
	</body>
</html>
