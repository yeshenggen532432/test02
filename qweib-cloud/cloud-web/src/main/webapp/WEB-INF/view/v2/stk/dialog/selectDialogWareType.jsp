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
				<td align="left"  id="wd" style="width: 130px;" height="100%" >
		<div data-options="region:'west',split:true,title:'商品分类树'"
			style="width:130px;padding-top: 5px;">
			<ul id="waretypetree" class="easyui-tree"
				data-options="url:'${base}/manager/waretypes',animate:true,dnd:true,onDblClick: function(node){
					selectWareType(node.id,node.text);
				}">
			</ul>
		</div>
	</td>
	</tr>
	</table>
		<script type="text/javascript">
			var  wareList = new Array();
			//点击商品分类树查询
			function selectWareType(id,name){
                window.parent.$('#wareTypeDlg').dialog('close');
                window.parent.setWareType(id,name);
			}
		</script>
	</body>
</html>
