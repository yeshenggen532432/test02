<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>单个商品销售投入费用项目</title>
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
			<c:forEach var="title" items="${autoList}" >
				<tr>
					<td width="100px">${title.name}:</td>
					<td>
						<c:set var="flag" value="0"/>
						<c:forEach var="price" items="${autoPriceList}">
							<c:if test="${title.id eq price.autoId}">
								<input type='hidden' id='auto_price_Id_${wareId}_${title.id}' value="${price.id}"/>
								<input onchange="changeWareAutoPrice(${wareId},${title.id})" id='auto_Price_${wareId}_${title.id}' value="${price.price}" />
								<c:set var="flag" value="1"/>
							</c:if>
						</c:forEach>
						<c:if test="${flag eq 0}">
							<input type='hidden' id='auto_price_Id_${wareId}_${title.id}' />
							<input onchange="changeWareAutoPrice(${wareId},${title.id})" id='auto_Price_${wareId}_${title.id}' />
						</c:if>

					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
		<script type="text/javascript">
		    function changeWareAutoPrice(wareId,autoId){
		    	var autoPriceId = document.getElementById("auto_price_Id_"+wareId+"_"+autoId).value;
				var autoPrice =  document.getElementById("auto_Price_"+wareId+"_"+autoId).value;
				$.ajax({
					url:"manager/updateAutoPrice",
					type:"post",
					data:"id="+autoPriceId+"&wareId="+wareId+"&price="+autoPrice+"&autoId="+autoId,
					success:function(data){
						if(data!='0'){
							if(autoPriceId==""){
								document.getElementById("auto_price_Id_"+wareId+"_"+autoId).value=data;
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
