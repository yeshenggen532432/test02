<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>利润表明细</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<style>
			tr{background-color:#FFF;height:30px;vertical-align:middle; padding:3px;}
			td{padding-left:10px;}
			.trClass{background-color: pink;font-weight: bold;}
		</style>
	</head>
	<body >
		<div id="tb" >
		<c:set var="totalAmt" value="0"/>
		<c:if test="${typeId eq '1' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
			<%--
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>商品名称</td>
				<td>销售数量</td>
				<td>销售价格</td>
				<td>销售金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['stk_unit'] }</td>
				<td>${data['ware_nm'] }</td>
				<td>${data['out_qty'] }</td>
				<td>${data['io_price'] }</td>
				<td>
				<fmt:formatNumber value="${data['out_qty']*data['io_price'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['out_qty']*data['io_price']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr>
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr> --%>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_name'] }</td>
				<td>${data['sale_amt'] }</td>
			</tr>
			</c:forEach>
			</table>
		</c:if>	
		<c:if test="${typeId eq '2' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
			<%--	
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>商品名称</td>
				<td>销售数量</td>
				<td>成本价格</td>
				<td>成本金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['stk_unit'] }</td>
				<td>${data['ware_nm'] }</td>
				<td>${data['out_qty'] }</td>
				<td>${data['in_price'] }</td>
				<td>
				<fmt:formatNumber value="${data['out_qty']*data['in_price'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['out_qty']*data['in_price']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			 --%>	
			 <c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_name'] }</td>
				<td>${data['cost_amt'] }</td>
			</tr>
			</c:forEach>
			</table>
		</c:if>	
		<c:if test="${typeId eq '3' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>折扣金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['kh_nm'] }</td>
				<td>${data['discount'] }
				<c:set var="totalAmt" value="${totalAmt+data['discount']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td>
					<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</c:if>	
		<c:if test="${typeId eq '4' }">
			<table width="50%" border="1" 
					cellpadding="0" cellspacing="1" >
			<%--	
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>费用科目</td>
				<td>费用金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['pro_name'] }</td>
				<td>${data['item_name'] }</td>
				<td>${data['amt'] }
				<c:set var="totalAmt" value="${totalAmt+data['amt']}"/>
				</td>			
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td>
					<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			 --%>	
			 <tr class="trClass">
				<td>序号</td>
				<td>费用科目</td>
				<td>费用金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['item_name'] }</td>
				<td>${data['amt'] }
				<c:set var="totalAmt" value="${totalAmt+data['amt']}"/>
				</td>			
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td>
					<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</c:if>	
		</div>
		<c:if test="${typeId eq '5' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
			<%-- 	
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>商品名称</td>
				<td>销售数量</td>
				<td>销售价格</td>
				<td>销售金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['stk_unit'] }</td>
				<td>${data['ware_nm'] }</td>
				<td>${data['out_qty'] }</td>
				<td>${data['io_price'] }</td>
				<td>
				<fmt:formatNumber value="${data['out_qty']*data['io_price'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['out_qty']*data['io_price']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			--%>	
			<tr class="trClass">
				<td>序号</td>
				<td>往来单位</td>
				<td>销售金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['stk_unit'] }</td>
				<td>
				<fmt:formatNumber value="${data['sale_amt'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['sale_amt']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</c:if>	
		<c:if test="${typeId eq '6' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
				<%--	
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>商品名称</td>
				<td>销售数量</td>
				<td>成本价格</td>
				<td>成本金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['stk_unit'] }</td>
				<td>${data['ware_nm'] }</td>
				<td>${data['out_qty'] }</td>
				<td>${data['in_price'] }</td>
				<td>
				<fmt:formatNumber value="${data['out_qty']*data['in_price'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['out_qty']*data['in_price']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			 --%>
			 <tr class="trClass">
				<td>序号</td>
				<td>往来单位</td>
				<td>成本金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['stk_unit'] }</td>
				<td>
				<fmt:formatNumber value="${data['cost_amt'] }" pattern="#,#00.0#"/>
				<c:set var="totalAmt" value="${totalAmt+data['cost_amt']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</c:if>	
		
		<c:if test="${typeId eq '7' }">
			<table width="70%" border="1" 
					cellpadding="0" cellspacing="1" >
					<%-- 
			<tr class="trClass">
				<td>序号</td>
				<td>单据号</td>
				<td>往来单位</td>
				<td>其他项目</td>
				<td>金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['bill_no'] }</td>
				<td>${data['kh_nm'] }</td>
				<td>${data['item_name'] }</td>
				<td>${data['amt'] }
				<c:set var="totalAmt" value="${totalAmt+data['amt']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td></td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			--%>
			<tr class="trClass">
				<td>序号</td>
				<td>其他项目</td>
				<td>金额</td>
			</tr>
			<c:forEach items="${datas }" var="data" varStatus="s">
			<tr>
				<td>${s.index+1}</td>
				<td>${data['item_name'] }</td>
				<td>${data['amt'] }
				<c:set var="totalAmt" value="${totalAmt+data['amt']}"/>
				</td>
			</tr>
			</c:forEach>
			<tr style="color: green">
				<td>合计</td>
				<td></td>
				<td>
				<fmt:formatNumber value="${totalAmt }" pattern="#,#00.0#"/>
				</td>
			</tr>
			</table>
		</c:if>
		</div>
	</body>
</html>
<script type="text/javascript">
function showBillNo(type,billId){
	
}


</script>
