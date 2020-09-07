<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="mobile" uri="/WEB-INF/tlds/mobile.tld" %>
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
		<title>进销存-手机端</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
		<style>
		.menu_show table {
		  width: 100%;
		}
		.menu_show table td {
		  border: 1px solid #f2f2f2;
		  text-align: center;
		  padding: 12px;
		}
		</style>
	</head>
	<body>
		
		<header class="fixed_top">
			
			<h1>报表分析</h1>
		</header>
		
			<div class="menu_show">
				<table>
					<tr style="height: 30px">
						<td style="text-align: left;padding-left: 20px;font-weight: bold;">
							销售报表
						</td>
					</tr>
					<%--<c:if test="${mobile:checkUserMenuPdm('khxstjb',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/saleWebRpt/toCustomerSaleStat?token=${token}">客户销售统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('ywxstjb',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/saleWebRpt/toSaleManSaleStat?token=${token}">业务销售统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('cpxmmltj',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/saleWebRpt/toWareSaleGrossProfitStat?token=${token}">产品销售毛利表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<tr>	
						<td style="text-align: left;padding-left: 20px;font-weight: bold;">
								应收应付帐款
						</td>
					</tr>
						<%--<c:if test="${mobile:checkUserMenuPdm('skdcx',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/arapWebRpt/toYskAmtStat?token=${token}">应收货款统计表</a>
						</td>
					</tr>
						<%--</c:if>--%>
							<%--<c:if test="${mobile:checkUserMenuPdm('skdcx',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/arapWebRpt/toYshkAmtStat?token=${token}">预收货款统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('fkdcx',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/arapWebRpt/toYfkAmtStat?token=${token}">应付货款统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<tr>	
					
						<td style="text-align: left;padding-left: 20px;font-weight: bold;">
								其他往来帐
						</td>
					</tr>
						<%--<c:if test="${mobile:checkUserMenuPdm('wlhksr',token)}">--%>
					<tr style="height: 20px;">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
								<a href="<%=basePath %>/web/orapWebRpt/toQtysAmtStat?token=${token}">其他应收款</a>
						</td>
					</tr>
					<%--</c:if>--%>
						<%--<c:if test="${mobile:checkUserMenuPdm('wlhkzc',token)}">--%>
					<tr style="height: 20px;">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
								<a href="<%=basePath %>/web/orapWebRpt/toQtyfAmtStat?token=${token}">其他应付款</a>
						</td>
					</tr>
					<%--</c:if>--%>
						<%--<c:if test="${mobile:checkUserMenuPdm('fyzfpz',token)}">--%>
					<tr style="height: 20px;">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/orapWebRpt/toDzfCostAmtStat?token=${token}">待支付报销费用</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<tr>
						<td style="text-align: left;padding-left: 20px;font-weight: bold;">
								库存报表
						</td>
					</tr>
					<%--<c:if test="${mobile:checkUserMenuPdm('ckcx',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/stockWebRpt/toWareStockStat?token=${token}">库存查询</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('cprktj',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/stockWebRpt/toWareInStat?token=${token}">产品入库统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('cpcktj',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/stockWebRpt/toWareOutStat?token=${token}">产出库统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('sfchz',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/stockWebRpt/toWareSfcStat?token=${token}">收发存汇总表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<tr>	
						<td style="text-align: left;padding-left: 20px;font-weight: bold;">
								资产报表
						</td>
					</tr>	
					<%--<c:if test="${mobile:checkUserMenuPdm('fytj',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/assetsWebRpt/toCostAssetsStat?token=${token}">经营费用统计表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('lrb',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;">
							<a href="<%=basePath %>/web/assetsWebRpt/toProfitAssetsStat?token=${token}">经营利润表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('zchsb',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;height: 20px">
							<a href="<%=basePath %>/web/assetsWebRpt/toHsAssetsStat?token=${token}">资产汇算表</a>
						</td>
					</tr>
					<%--</c:if>--%>
					<%--<c:if test="${mobile:checkUserMenuPdm('xjrbb',token)}">--%>
					<tr style="height: 20px">
						<td style="text-align: left;padding-left: 30px;font-size: 12px;height: 20px">
							<a href="<%=basePath %>/web/assetsWebRpt/toCashDayStat?token=${token}">现金日报表</a>
						</td>
					</tr>
					<%--</c:if>--%>
				</table>
			</div>
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
</html>