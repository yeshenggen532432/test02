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
		<title>进销存</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
		
		<header class="fixed_top">
			
			<h1>进销存</h1>
		</header>
		
		<div class="home">
			<div class="main_show">
				<table>
					<tr>
						<td class="col1">
							<a href="stkinQuery?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon5.png"/>
								<p>采购单</p>
							</a>
						</td>
						<td class="col2">
							<a href="stkQuery?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>库存查询</p>
							</a>
						</td>
						<td>
							<a href="toWillOut?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon3.png"/>
								<p>销售单</p>
							</a>
						</td>
					</tr>
					<tr>
						<td class="col3">
							<a href="stkinMng?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon7.png"/>
								<p>收货管理</p>
							</a>
						</td>
						<td class="col2">
							<a href="queryInStat?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>入库统计</p>
							</a>
						</td>
						<td class="col4">
							<a href="stkoutmng?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon6.png"/>
								<p>发货管理</p>
							</a>
						</td>
					</tr>
					<tr>
						<td class="col1">
							<a href="stkPayMng?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>付款管理</p>
							</a>
						</td>
						<td class="col2">
							<a href="queryOutStat?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>出库统计</p>
							</a>
						</td>
						<td>
							<a href="stkRecMng?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>收款管理</p>
							</a>
						</td>
					</tr>
					
					<tr>
						<td class="col1">
							<a href="querystksummary?token=${token}">
								<img src="<%=basePath %>/resource/stkstyle/img/icon4.png"/>
								<p>收发存</p>
							</a>
						</td>
						<td class="col2">
							
						</td>
						<td>
							
						</td>
					</tr>
				</table>
			</div>
			
		</div>
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
</html>