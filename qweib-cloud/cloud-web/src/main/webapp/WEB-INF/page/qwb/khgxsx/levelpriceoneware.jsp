<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商品对应客户等级价格</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
			td {height: 25px}
		</style>

	</head>

	<body class="easyui-layout">
	<div style="height: 200px; overflow: auto;">
	<table>
		<c:forEach var="title" items="${levelList}" >
			<tr>
				<td width="100px">${title.khdjNm}:</td>
				<td>
					<c:set var="flag" value="0"/>
					<c:forEach var="price" items="${levelPriceList}">
						<c:if test="${title.id eq price.levelId}">
							<input type='hidden' id='level_price_Id_${wareId}_${title.id}' value="${price.id}"/>
							<input onchange="changeWareLevelPrice(${wareId},${title.id})" id='level_Price_${wareId}_${title.id}' value="${price.price}" />
							<c:set var="flag" value="1"/>
						</c:if>
					</c:forEach>
					<c:if test="${flag eq 0}">
						<input type='hidden' id='level_price_Id_${wareId}_${title.id}' />
						<input onchange="changeWareLevelPrice(${wareId},${title.id})" id='level_Price_${wareId}_${title.id}' />
					</c:if>

				</td>
			</tr>
		</c:forEach>
	</table>
	</div>
		<script type="text/javascript">
			function changeWareLevelPrice(wareId,levelId){
				var levelPriceId = document.getElementById("level_price_Id_"+wareId+"_"+levelId).value;
				var levelPrice =  document.getElementById("level_Price_"+wareId+"_"+levelId).value;
				$.ajax({
					url:"manager/updateLevelPrice",
					type:"post",
					data:"id="+levelPriceId+"&wareId="+wareId+"&price="+levelPrice+"&levelId="+levelId,
					success:function(data){
						if(data!='0'){
							if(levelPriceId==""){
								document.getElementById("level_price_Id_"+wareId+"_"+levelId).value=data;
							}
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			}
		</script>
	</body>
</html>
