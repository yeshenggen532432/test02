<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>选择商品类别树</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body class="easyui-layout">
	<table width="100%" height="100%" border="0" cellpadding="0"
			 cellspacing="0" class="tree">
			<tr valign="top" align="left">
				<td align="left"  id="wd" style="width: 130;" height="100%" >
		<div data-options="region:'west',split:true,title:'商品分类树'"
			style="width:130px;padding-top: 5px;">
			<ul id="waretypetree" class="easyui-tree"
				data-options="url:'${base}/manager/companyWaretypes',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
			</ul>
		</div>
	</td>
	 <td valign="top" align="left">
			<iframe src="${base}/manager/toDialogWareGroupPage" name="warefrm" id="warefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</td>
	</tr>
	</table>	
		<script type="text/javascript">
			var  wareList = new Array();
			//点击商品分类树查询
			function toShowWare(id){
				document.getElementById("warefrm").src="${base}/manager/toDialogWareGroupPage?waretype="+id;
			}
		</script>
	</body>
</html>
