<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>功能菜单主页</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
  </head>
  <body>
  	<div class="easyui-layout" fit="true">
		<div data-options="region:'west',split:true,title:'菜单树'" style="width:220px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="menuUl" class="easyui-tree" fit="true" data-options="
					url:'manager/querySysMenuAll',
					onBeforeExpand:function(node,param){
						$('#menuUl').tree('options').url='manager/querySysMenuAll?id='+node.id;
					},
					onClick:function(node,param){
						document.getElementById('rigFrame').src='manager/updateMenuIndex?leftId='+node.id;
					}">
				</ul>
			</div>
		</div>
		<div data-options="region:'center'">
			<iframe src="manager/updateMenuIndex" frameborder="0"
					scrolling="no" name="rigFrame" id="rigFrame" width="100%" height="100%"></iframe>
		</div>
	</div>
	<script type="text/javascript">
		function reloadMenuTree(){
		    $('#menuUl').tree({
		        url:'manager/querySysMenuAll'
		    });
		}
	</script>
  </body>
</html>
