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

<body >

<div >
	<%--<div style="color:red;margin: 5px 0">--%>
		<%--(备注:以下表格颜色区分:--%>
		<%--<span style="color:orange;margin-right: 10px">1.进销存商品基础价;</span>--%>
		<%--<span style="color:#333;margin-right: 10px">2.商城商品基础价;</span>--%>
		<%--<span style="color:blue;margin-right: 10px">3.商城会员等级价格;</span>--%>
		<%--<span style="color:green;">4.商城会员自定义价格</span>--%>
		<%--)--%>
	<%--</div>--%>
	<input name="shopMemberId" id="shopMemberId" value="" hidden="true"/>
	<input name="wareType" id="wareType" value="" hidden="true"/>
	<%--<div>--%>
		<%--<a id="aSelectMember" class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:dialogSelectMember();">选择会员</a>--%>
		<%--<span name="shopMemberName" id="shopMemberName" style="font-size: 20px;font-weight: bold;"></span>--%>
	<%--</div>--%>
</div>

<div class="easyui-layout" fit="true">
	<div data-options="region:'west',split:true,title:'商品分类树'"
		 style="width:150px;padding-top: 5px;">
		<ul id="waretypetree" class="easyui-tree"
			data-options="url:'manager/shopWareType/queryShopWaretypesByShopQy',animate:true,dnd:true,onClick: function(node){
					toShowWare(node.id);
				},onDblClick:function(node){
					$(this).tree('toggle', node.target);
				}">
		</ul>
	</div>

	<div id="wareTypeDiv" data-options="region:'center'">
		<iframe src="manager/shopEndPrice/toShopEndPricePageByShopMember?shopMemberId=${shopMemberId}" name="warefrm" id="warefrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
	</div>
</div>

<script type="text/javascript">
	//点击商品分类树查询
	function toShowWare(id){
		$("#wareType").val(id);
		document.getElementById("warefrm").src="${base}/manager/shopEndPrice/toShopEndPricePageByShopMember?wareType="+id+"&shopMemberId=${shopMemberId}";
	}

</script>
</body>
</html>
