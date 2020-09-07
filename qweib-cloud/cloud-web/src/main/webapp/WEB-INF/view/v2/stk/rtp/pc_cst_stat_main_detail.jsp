<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	
	<style>
	body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, pre, code, form, input, textarea,select, fieldset, legend, p, span, label, blockquote,table, th, td, object,html{margin:0;padding:0;}
	.tableList{margin:0 auto; font-size:12px;text-align: center;}
	.tableList thead tr{background-color:#f0faff;height:30px; font-size:12px;}
	.tableList tr.thead {background-color:#f0faff;height:30px; font-size:15px;}
	
	.TableLine{background-color: #f5f5f5; height:28px;font: bold;font-size:14px;text-align: left}
	.TableLine1{background-color: #ffffff; height:28px;font: bold;font-size:12px;}
	.tableList1{margin:0 auto; font-size:12px;text-align: center;border-color:dark;}
	table{margin:0 auto;}
	</style>
	<script type="text/javascript">
function amtformatter(v)
{
	if(v==""){
		return "";
	}
	if(v=="0E-7"){
		return "0.00";
	}
       document.write(numeral(v).format("0,0.00"));
}
</script>
	</head>
	<body >
		
			<table width="100%"  align="center" border="1"
					cellpadding="0" cellspacing="0" class="tableList">
			<tr class="thead">
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td width="15%">&nbsp;&nbsp;客户名称</td> 
			<td width="9%">&nbsp;&nbsp;所属二批</td> 
			<td width="8%">&nbsp;&nbsp;销售数量</td> 
			<td width="8%">销售收入</td> 
			<td width="8%">平均单位售价</td> 
			<td width="8%">整单折扣 </td>
			<td width="10%">销售成本</td>
			<td width="8%">其它促销赠送</td> 
			
			<td width="8%">销售毛利</td> 
			<td width="8%">平均单位毛利</td> 
			</tr>
			<c:forEach items="${mainDatas }" var="d" varStatus="s">
			<tr height="30" class="TableLine" style="text-align:left">
			<td>
			${s.index+1 }
			</td> 
			<td style="text-algin:left">
				${d.stkUnit }
			</td> 
			<td style="text-algin:left">
				${d.epCustomerName }
			</td> 
			<td >
				<fmt:formatNumber value="${d.sumQty }"  pattern="0.00"/>
			</td> 
			<td>
				<fmt:formatNumber value="${d.sumAmt }"  pattern="0.00"/>
			</td> 
			<td>
				<fmt:formatNumber value="${d.avgPrice }"  pattern="0.00"/>
			</td> 
			<td>
				<fmt:formatNumber value="${d.discount }"  pattern="0.00"/>
			 </td>
			<td>
				<fmt:formatNumber value="${d.sumCost }"  pattern="0.00"/>
			</td>
			<td>
				<fmt:formatNumber value="${d.sumFree }"  pattern="0.00"/>
			</td> 
			
			<td>
				<fmt:formatNumber value="${d.disAmt }"  pattern="0.00"/>
			</td> 
			<td>
				<fmt:formatNumber value="${d.avgAmt }"  pattern="0.00"/>
			</td> 
			</tr>
			<c:if test="${d.stkUnit ne '合计:' }">
			<tr>
				<td colspan="1">&nbsp;</td>
				<td colspan="10">
				&nbsp;
				<table  width="100%"  align="center" border="1"
					cellpadding="0" cellspacing="0" class="tableList1">
				<c:forEach items="${detailDatas }" var="detail">
				<c:if test="${detail.stkUnit eq d.stkUnit and detail.epCustomerName eq d.epCustomerName }">
					<tr height="30" class="TableLine1" style="text-align:left">
						<td  colspan="2" width="24%">
							${detail.wareNm }
						</td> 
						<td  width="10%">
							<fmt:formatNumber value="${detail.sumQty }"  pattern="0.00"/>
						</td> 
						<td  width="8%">
							<fmt:formatNumber value="${detail.sumAmt }"  pattern="0.00"/>
						</td> 
						<td  width="10%">
							<fmt:formatNumber value="${detail.avgPrice }"  pattern="0.00"/>
						</td> 
						<td  width="8%">
							<fmt:formatNumber value="${detail.discount }"  pattern="0.00"/>
						 </td>
						<td  width="10%">
							<fmt:formatNumber value="${detail.sumCost }"  pattern="0.00"/>
						</td>
						<td  width="8%">
							<fmt:formatNumber value="${detail.sumFree }"  pattern="0.00"/>
						</td> 
						<td  width="10%">
							<fmt:formatNumber value="${detail.disAmt }"  pattern="0.00"/>
						</td> 
						<td  width="10%">
							<fmt:formatNumber value="${detail.avgAmt }"  pattern="0.00"/>
						</td> 			
					</tr>	
				</c:if>
				</c:forEach>
				</table>
				</td>
			</tr>
			</c:if>
			</c:forEach>
			</table>
	</body>
</html>
