<%@ page language="java" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>移动端应用管理主页</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
  </head>
  <body>
  	<div class="easyui-layout" fit="true">
		<div data-options="region:'west',split:true,title:'应用树'" style="width:220px;">
			<div id="divHYGL" style="overflow: auto;">
				<ul id="applyUl" class="easyui-tree" fit="true" data-options="
					url:'manager/querySysApplyAll',
					onBeforeExpand:function(node,param){
						$('#applyUl').tree('options').url='manager/querySysApplyAll?leftId='+node.id;
					},
					onClick:function(node,param){
						document.getElementById('rigFrame').src='manager/updateApplyIndex?leftId='+node.id;
					}">
				</ul>
			</div>
		</div>
		<div data-options="region:'center'">
			<iframe src="manager/updateApplyIndex" frameborder="0"
					scrolling="no" name="rigFrame" id="rigFrame" width="100%" height="100%"></iframe>
		</div>
	</div>
	<script type="text/javascript">
		function reloadApplyTree(){
		    $('#applyUl').tree({
		        url:'manager/querySysApplyAll'
		    });
		}
	</script>
  </body>
</html>
