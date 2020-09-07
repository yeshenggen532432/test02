<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>

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
			<ul id="grouptree" class="easyui-tree">
				<c:if test="${not empty wareGroupList}">
					<c:forEach items="${wareGroupList }" var="wareGroup">
						<li><a href="javascript:;;" onclick="toShowWareGroup('${wareGroup.id}')">${wareGroup.name}</a></li>
					</c:forEach>
				</c:if>
			</ul>
			<!-- 原来的url:manager/shopWareType/waretypes -->
			<ul id="waretypetree" class="easyui-tree"
				data-options="url:'manager/shopWareType/queryShopWaretypesByShopQy',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
			</ul>
		</div>
		<div id="wareTypeDiv" data-options="region:'center'">
			<iframe src="manager/shopWare/toPage" name="warefrm" id="warefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
			//点击商品分类树查询
			function toShowWare(id){
				document.getElementById("warefrm").src="${base}/manager/shopWare/toPage?wtype="+id+"&groupIds="+"";
				//移除点击后样式
				$('#grouptree').find('.tree-node-selected').removeClass('tree-node-selected');
			}
			function toShowWareGroup(id){
				document.getElementById("warefrm").src="${base}/manager/shopWare/toPage?groupIds="+id+"&wtype="+"";
				//移除点击后样式
				$('#waretypetree').find('.tree-node-selected').removeClass('tree-node-selected');
			}
		</script>
	</body>
</html>
