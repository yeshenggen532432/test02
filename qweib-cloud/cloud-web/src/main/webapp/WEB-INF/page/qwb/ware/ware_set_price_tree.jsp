<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商品价格设置菜单树</title>
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
			<div class="easyui-accordion" data-options="border:false,fit:true">
				<div title="库存商品类" data-options="iconCls:'icon-application-cascade'" style="padding:5px;">
					<ul id="waretypetree" class="easyui-tree"
						data-options="url:'${base}manager/waretypes?isType=0',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,0);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
					</ul>
				</div>
				<div title="原辅材料类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
					<ul id="waretypetree1" class="easyui-tree"
						data-options="url:'${base}manager/waretypes?isType=1',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,1);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
					</ul>
				</div>

				<div title="低值易耗品类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
					<ul id="waretypetree2" class="easyui-tree"
						data-options="url:'${base}manager/waretypes?isType=2',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,2);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
					</ul>
				</div>
				<div title="固定资产类" data-options="iconCls:'icon-application-form-edit'" style="padding:5px;">
					<ul id="waretypetree3" class="easyui-tree"
						data-options="url:'${base}manager/waretypes?isType=3',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id,3);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
					</ul>
				</div>
			</div>
		</div>
		<div id="wareTypeDiv" data-options="region:'center'">
			<iframe src="manager/toWareSetPricePage" name="warefrm" id="warefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
			function toShowWare(id,isType){
				document.getElementById("warefrm").src="${base}/manager/toWareSetPricePage?isType="+isType+"&wtype="+id;
			}
		</script>
	</body>
</html>