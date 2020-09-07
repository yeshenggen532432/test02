<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>企微宝</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="<%=basePath%>/resource/dtree.js"></script>
	<style type="text/css">
		.ts{
			color:red;
			font-size:16px;
		}
	</style>
</head>

<body class="easyui-layout">
	<div style="margin: 10px">
		<span class="ts">请勾选商城要启用的商品分类；可在菜单项"商城管理"->"商品分类"中修改</span>
	</div>
	
	<ul id="waretypeTreeWindow" class="easyui-tree" data-options="url:'manager/shopWareType/shopWaretypes',animate:true,checkbox:true"></ul>
	
	<div style="margin: 10px">
		<a class="easyui-linkbutton" href="javascript:savepower();">保存</a>
	</div>

	<script type="text/javascript">
		
		//===============================================================================
			
		//保存
		function savepower(){
			//选中
			var cIds='';
			var nodes1 = $("#waretypeTreeWindow").tree('getChecked', 'checked');
			if(nodes1!=null){
				for(var i=0; i<nodes1.length; i++){
					if (cIds != '') cIds += ',';
					cIds += nodes1[i].id;
				}
			}
			//部分选中
			var iIds='';
			var nodes2 = $("#waretypeTreeWindow").tree('getChecked', 'indeterminate');
			if(nodes2!=null){
				for(var i=0; i<nodes2.length; i++){
					if (iIds != '') iIds += ',';
					iIds += nodes2[i].id;
				}
			}
			$.ajax({
				url : "manager/shopWareType/updateWaretypeShopQY",
				type : "post",
				data : {"cIds":cIds,"iIds":iIds},
				success : function(json) {
					if('1'==json){
						alert("修改成功");
						window.location.reload()//刷新当前页面.
					}else{
						alert("修改失败");
					}
				}
			});
		}
		
	</script>
</body>
</html>
