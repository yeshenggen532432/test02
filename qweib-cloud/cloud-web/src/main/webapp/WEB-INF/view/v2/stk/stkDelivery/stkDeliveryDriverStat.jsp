<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<title>司机配送情况--已经生成发货单</title>
	<%@include file="/WEB-INF/view/v2/include/header-kendo.jsp" %>
	<style>
		tr {
			background-color: #FFF;
			height: 30px;
			vertical-align: middle;
			padding: 3px;
		}
		td {
			padding-left: 10px;
		}
		.title_class{
			padding-left: 20px;
		}
	</style>
</head>
<body>
<tag:mask></tag:mask>
<div class="layui-fluid">
	<div class="layui-card">
		<div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:['.header', 75]" id="container">


			<div uglcw-role="tabs">
				<ul>
					<li>配送概况</li>
					<li>商品概况</li>
				</ul>
				<div>
					<table  border="1"
							cellpadding="0" cellspacing="1">
						<tr>
							<td style="text-align: center;width: 220px;">
								司机
							</td>
							<td style="text-align: center;width: 160px">
								数量
							</td>
							<td style="text-align: center;width: 100px">

							</td>
						</tr>
						<c:set var="driverSumQty" value="0"/>
						<c:forEach items="${datas}" var="data">
							<tr>
								<td style="text-align: left;padding-left: 12px;font-weight: bold">
										${data["driver_name"]}
								</td>
								<td style="text-align: right;padding-right: 12px;font-weight: bold">
									<fmt:formatNumber value='${data["out_qty"] }' pattern="#,#00.0#"/>
									<c:set var="driverSumQty" value="${driverSumQty+data['out_qty']}"/>
								</td>
								<td class="title_class"><a onclick="showItems(${data["driver_id"]})" id="showWare${data["driver_id"]}">显示商品</a></td>
							</tr>
							<c:forEach items="${data.items}" var="item">
								<tr class="item_class_${data["driver_id"]}" style="display: none">
									<td style="text-align: left;padding-left: 12px">
										&nbsp;&nbsp;&nbsp;&nbsp;${item["ware_nm"]}
									</td>
									<td style="text-align: right;padding-right: 12px">
										<fmt:formatNumber value='${item["out_qty"] }' pattern="#,#00.0#"/>
									</td>
									<td class="title_class">${item["unit_name"]}</td>
								</tr>
							</c:forEach>
						</c:forEach>
						<tr>
							<td style="text-align: left;padding-left: 12px;font-weight: bold">
								合计
							</td>
							<td style="text-align: right;padding-right: 12px;font-weight: bold">
								<fmt:formatNumber value='${driverSumQty }' pattern="#,#00.0#"/>
							</td>
							<td ></td>
						</tr>
					</table>
				</div>
				<div>
					<table  border="1"
							cellpadding="0" cellspacing="1">
						<tr>
							<td style="text-align: center;width: 220px;">
								商品名称
							</td>
							<td style="text-align: center;width: 160px">
								数量
							</td>
							<td style="text-align: center;width: 100px">
								单位
							</td>
						</tr>
						<c:set var="wareSumQty" value="0"/>
						<c:forEach items="${wareDatas}" var="data">
							<tr>
								<td style="text-align: left;padding-left: 12px;font-weight: bold">
										${data["ware_nm"]}
								</td>
								<td style="text-align: right;padding-right: 12px;font-weight: bold">
									<fmt:formatNumber value='${data["out_qty"] }' pattern="#,#00.0#"/>
									<c:set var="wareSumQty" value="${wareSumQty+data['out_qty']}"/>
								</td>
								<td class="title_class">${data["unit_name"]}</td>
							</tr>
						</c:forEach>
						<tr>
							<td style="text-align: left;padding-left: 12px;font-weight: bold">
								合计
							</td>
							<td style="text-align: right;padding-right: 12px;font-weight: bold">
								<fmt:formatNumber value='${wareSumQty}' pattern="#,#00.0#"/>
							</td>
							<td class="title_class"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();
		uglcw.ui.loaded()
	})
	function showItems(id){
		var display = $(".item_class_"+id).css('display');
		if (display == 'none') {
			$(".item_class_"+id).show();
			$("#showWare"+id).text('隐藏商品');
		} else {
			$(".item_class_"+id).hide();
			$("#showWare"+id).text('显示商品');
		}
	}
</script>
</body>
</html>
