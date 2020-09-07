<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>库存明细</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="stkQuery?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>库存明细</h1>
		</header>
		
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="token" id="stkId" value="0"/>
			
		</div>
		
		
		<div class="sctb">
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							<td align="center" style = "WIDTH:100px;">入库日期</td>
							<td align="center" style = "WIDTH:100px;">产品名称</td>
							<td align="center" style = "WIDTH:80px;">单位</td>
							<td align="center" style = "WIDTH:80px;">数量</td>
							<td align="center" style = "WIDTH:50px;">进货价格</td>
							<td align="center" style = "WIDTH:80px;">生产日期</td>
						</tr>
					</thead>
					<tbody id="dataList">
					<c:forEach items="${warelist}" var="item" >
						<tr>
							
							<td>${item.inTimeStr}</td>
							<td>${item.wareNm}</td>
							<td>${item.unitName}</td>
							<td>${item.qty}</td>
							<td>${item.inPrice}</td>
							<td>${item.productDate}</td>
						</tr>
					</c:forEach>
						
						
						
					</tbody>
					
				</table>
			</div>
		</div>
		
		
		
		<div class="had_box" id="warehouse_bhad">
			<div class="mask"></div>
			<div class="lib_box" id="stkdict">
				<ul>
					<li>一号仓库</li>
					<li>二号仓库</li>
					<li>三号仓库</li>
					<li>四号仓库</li>
					<li>五号仓库</li>
				</ul>
			</div>
		</div>
		
		<div class="had_box" id="bill_status">
			<div class="mask"></div>
			<div class="lib_box" id="statusList">
				<ul>
					<li>全部状态</li>
					<li>未审</li>
					<li>已审</li>
					<li>作废</li>
					
				</ul>
			</div>
		</div>
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		
		
		
		
	</script>
</html>