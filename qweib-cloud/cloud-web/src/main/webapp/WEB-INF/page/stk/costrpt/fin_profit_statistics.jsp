<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>利润表</title>

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
		</style>
	</head>
	<body >
		<div id="tb" >
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
			<form action="manager/toFinProfitstatistics" name="toFinProfitstatisticsfrm" id="toFinProfitstatisticsfrm" method="post">
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			</form>
			<table width="600px" border="1" 
					cellpadding="0" cellspacing="1" >
			<tr>
			<td style="font-weight: bold;color: blue;">一.销售毛利</td>
			<td colspan="2" style="color:${datas["saleMargin"]>0?'blue':'red'}">
			<fmt:formatNumber value='${datas["saleMargin"]}'  pattern="#,#00.0#"></fmt:formatNumber></td>
			</tr>
			<tr>
			<td width="150px">1.产品销售收入</td> 
			<td width="150px" >
			<a href="javascript:;;" style="color: black" onclick="showDetail(1,'')"><fmt:formatNumber value='${datas["saleAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td>其中门店收入(${datas["saleShopAmt"]})</td>
			</tr>
			<tr>
			<td>2.产品销售成本</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(2,'')"><fmt:formatNumber value='${datas["saleCostAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td>其中门店成本(${datas["saleShopCostAmt"]})</td>
			</tr>
			<tr>
			<td>3.产品折扣</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(3,'')"><fmt:formatNumber value='${datas["saleDiscount"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td>其中门店折扣(${datas["saleShopDiscount"]})</td>
			</tr>
			<c:set var="costAmtSum" value="0"/>
			<tr>
			<td  style="font-weight: bold;color: blue;">二.费用合计</td>
			<td colspan="2" style="color:red;"><a href="javascript:;;" style="color: black" onclick="showDetail(4,'')"><span id="costSumAmt"></span></a></td>
			</tr>
			<c:forEach items="${datas['costOut'] }" var="items" varStatus="s">
			<tr>
				<td>${s.index+1 }.${items['type_name'] }</td>
				<td >
				<a href="javascript:;;" style="color: black" onclick="showDetail(4,${items['type_id'] })"><fmt:formatNumber value='${items["total_amt"] }' pattern="#,#00.0#"/></a>
				</td>
				<c:set var="costAmtSum" value="${costAmtSum+items['total_amt']}"/>
				<td></td>
			</tr>
			</c:forEach>
			<script>
				document.getElementById("costSumAmt").innerHTML="<fmt:formatNumber value='${costAmtSum}' pattern='#,#00.0#'/>";
			</script>
			<tr>
			<td  style="font-weight: bold;color: blue;">三.其他净收入</td>
			<td colspan="2" style="color:${(datas["qtSaleMargin"]+datas["qtSlSumAmt"])>0?'blue':'red'}">
			
			<fmt:formatNumber value='${datas["qtSaleMargin"]+datas["qtSlSumAmt"]}' pattern="#,#00.0#"/></td>
			</tr>
			<tr>
			<td>1.其它销售收入</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(5,'')"><fmt:formatNumber value='${datas["qtSaleAmt"] }' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>2.其它销售成本</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(6,'')">
			<fmt:formatNumber value='${datas["qtCostAmt"] }' pattern="#,#00.0#"/>
			</a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>3.其它销售净收入</td> 
			<td>
			<fmt:formatNumber value='${datas["qtSaleMargin"]}' pattern="#,#00.0#"/>
			</td> 
			<td>其它销售收入-其它销售成本</td>
			</tr>
			<tr>
			<td>4.其他收入项目</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(7,'')">
			<fmt:formatNumber value='${datas["qtSlSumAmt"] }' pattern="#,#00.0#"/>
			</a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td style="font-weight: bold;color: blue;">四.经营毛利</td>
			
			<td style="color:${(datas["saleMargin"]+datas["qtSaleMargin"]+datas["qtSlSumAmt"]-costAmtSum)>0?'blue':'red'}">
			<fmt:formatNumber value='${datas["saleMargin"]+datas["qtSaleMargin"]+datas["qtSlSumAmt"]-costAmtSum}' pattern="#,#00.0#"/>
			</td>
			<td>销售收入+其它销售净收入+其他收入项目-费用报销</td>
			</tr>
			</table>
		</div>
	</body>
	<script>
	function query(){
		document.getElementById("toFinProfitstatisticsfrm").submit();
	}
	function showDetail(type,costType){
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();
		var tabName ="";
		 //typeId:1 产品销售收入
		 //typeId:2 产品销售成本
		 //typeId:3 产品折扣
		 //typeId:4 费用合计
		 //typeId:5 其它销售收入
		 //typeId:6 其它销售成本
		 //typeId:7 其他收入项目
		if(type==1){
			tabName = "产品销售收入";
		}else if(type==2){
			tabName = "产品销售成本";
		}else if(type==3){
			tabName = "产品折扣";
		}else if(type==4){
			tabName = "费用项目";
		}else if(type==5){
			tabName = "其它销售收入";
		}else if(type==6){
			tabName = "其它销售成本";
		}else if(type==7){
			tabName = "其他收入项目";
		}
		parent.closeWin('利润明细_' + tabName);
    	parent.add('利润明细_' + tabName,'manager/toFinProfitstatisticsItems?sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type);
	}
	</script>
</html>
