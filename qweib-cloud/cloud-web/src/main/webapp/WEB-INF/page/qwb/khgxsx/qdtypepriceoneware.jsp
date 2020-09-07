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
		<style type="text/css">
			td {height: 25px}
		</style>
	</head>
	<body class="easyui-layout">
	<div style="height: 200px; overflow: auto;">
		<table>
			<c:forEach var="title" items="${typeList}" >
				<tr>
					<td width="100px">${title.qdtpNm}:</td>
					<td>
						<c:set var="flag" value="0"/>
						<c:forEach var="price" items="${typePriceList}">
							<c:if test="${title.id eq price.relaId}">
								<input type='hidden' id='type_price_Id_${wareId}_${title.id}' value="${price.id}"/>
								<input onchange="changeWareTypePrice(${wareId},${title.id})" id='type_Price_${wareId}_${title.id}' value="${price.price}" />
								<c:set var="flag" value="1"/>
							</c:if>
						</c:forEach>
						<c:if test="${flag eq 0}">
							<input type='hidden' id='type_price_Id_${wareId}_${title.id}' />
							<input onchange="changeWareTypePrice(${wareId},${title.id})" id='type_Price_${wareId}_${title.id}' />
						</c:if>

					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
		<script type="text/javascript">
		    function changeWareTypePrice(wareId,typeId){
		    	var typePriceId = document.getElementById("type_price_Id_"+wareId+"_"+typeId).value;
				var typePrice =  document.getElementById("type_Price_"+wareId+"_"+typeId).value;
				$.ajax({
					url:"manager/updateQdTypePrice",
					type:"post",
					data:"id="+typePriceId+"&wareId="+wareId+"&price="+typePrice+"&relaId="+typeId,
					success:function(data){
						if(data!='0'){
							if(typePriceId==""){
								document.getElementById("type_price_Id_"+wareId+"_"+typeId).value=data;
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
