<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>资产汇算表</title>

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
		<form action="manager/toFinAssetstatistics" name="toFinAssetstatisticsfrm" id="toFinAssetstatisticsfrm" method="post">
			日期:
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			</form>
			<table width="600px" border="1" 
					cellpadding="0" cellspacing="1" >
					<%--
					accAmt
					wkaccAmt--现金等价物

					yshkAmt
					qtysAmt

					wlyfAmt--预付款

					spkcAmt
					yfclkcAmt--原辅材料
					dzyhkcAmt--低值易耗品
					gdzchkcAmt--固定资产

					qtwzAmt

					 --%>
			<tr>
			<td style="font-weight: bold;color: blue;">一.资产合计</td>
			<td colspan="2" style="color:${(datas["accAmt"]+datas["wkaccAmt"]+datas["wlyfAmt"]+datas["yshkAmt"]-datas["yfflAmt"]+datas["qtysAmt"]+datas["gdzckcAmt"]+datas["dzyhkcAmt"]+datas["yfclkcAmt"]+datas["spkcAmt"]+datas["qtwzAmt"]+datas["ztkcAmt"]+datas["produceCostAmt"]+datas["pickUpCostAmt"])>0?'blue':'red'}">
				<fmt:formatNumber value='${datas["accAmt"]+datas["wkaccAmt"]+datas["wlyfAmt"]+datas["yshkAmt"]-datas["yfflAmt"]+datas["qtysAmt"]+datas["gdzckcAmt"]+datas["dzyhkcAmt"]+datas["yfclkcAmt"]+datas["spkcAmt"]+datas["qtwzAmt"]+datas["ztkcAmt"]+datas["produceCostAmt"]+datas["pickUpCostAmt"]}'  pattern="#,#00.0#"></fmt:formatNumber>
			</td>
			</tr>
			<tr>
			<td width="150px">1.货币资金</td> 
			<td width="150px">
			<a href="javascript:;;" style="color: black" onclick="showDetail(1,'',1)"><fmt:formatNumber value='${datas["accAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
				<td width="150px">2.现金等价物</td>
				<td width="150px">
					<a href="javascript:;;" style="color: black" onclick="showDetail(1,'',4)"><fmt:formatNumber value='${datas["wkaccAmt"]}' pattern="#,#00.0#"/></a>
				</td>
				<td></td>
			</tr>
			<tr>
			<td>3.应收货款</td>
			<td>
			<fmt:formatNumber value='${datas["yshkAmt"]-datas["yfflAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td>
			应收账：<a href="javascript:;;" style="color: black" onclick="showDetail(2,'')"><fmt:formatNumber value='${datas["yshkAmt"]}' pattern="#,#00.0#"/></a>
			-
			应付返利<a href="javascript:;;" style="color: black" onclick="showDetail(21,'')"><fmt:formatNumber value='${datas["yfflAmt"]}' pattern="#,#00.0#"/></a>
			</td>
			</tr>
			<tr>
			<td>4.其他应收款</td>
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(3,'')"></a><fmt:formatNumber value='${datas["qtysAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
				<td>5.预付款</td>
				<td>
					<a href="javascript:;;" style="color: black" onclick="showDetail('wlyf','')"><fmt:formatNumber value='${datas["wlyfAmt"]}' pattern="#,#00.0#"/></a>
				</td>
				<td></td>
			</tr>
			<tr>
			<td>6.商品库存</td>
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',0)"><fmt:formatNumber value='${datas["spkcAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
				<td>7.原辅材料</td>
				<td>
					<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',1)"><fmt:formatNumber value='${datas["yfclkcAmt"]}' pattern="#,#00.0#"/></a>
				</td>
				<td></td>
			</tr>
			<tr>
			<td>8.其他物资</td><%--低值易耗--%>
			<td>
				<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',2)"><fmt:formatNumber value='${datas["dzyhkcAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>9.在途库存</td>
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(16,'')"><fmt:formatNumber value='${datas["ztkcAmt"]}' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>10.在产品</td>
			<td>
				<fmt:formatNumber value='${datas["produceCostAmt"]+datas["pickUpCostAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td>制造费用余：<fmt:formatNumber value='${datas["produceCostAmt"]}' pattern="#,#00.0#"/>&nbsp;领料结余成本:<fmt:formatNumber value='${datas["pickUpCostAmt"]}' pattern="#,#00.0#"/></td>
			</tr>
			<tr>
				<td>11.固定资产</td>
				<td>
					<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',3)"><fmt:formatNumber value='${datas["gdzckcAmt"]}' pattern="#,#00.0#"/></a>
				</td>
				<td></td>
			</tr>
			<%--
			qtyfAmt
			dffyAmt
			yfkAmt

			wlysAmt--预收款
			 --%>
			<tr>
			<td  style="font-weight: bold;color: blue;">二.应付项目合计</td>
			<td colspan="2" style="color:${(datas["qtyfAmt"]+datas["dffyAmt"]+datas["wlysAmt"]+datas["yfkAmt"]-datas["ysflAmt"])>0?'blue':'red'}"><fmt:formatNumber value='${datas["qtyfAmt"]+datas["dffyAmt"]+datas["wlysAmt"]+datas["yfkAmt"]-datas["ysflAmt"]}' pattern="#,#00.0#"/></td>
			</tr>
			<tr>
			<td>1.其他应付往来款</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(6,'')"><fmt:formatNumber value='${datas["qtyfAmt"] }' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
				<td>2.预收款</td>
				<td>
					<a href="javascript:;;" style="color: black" onclick="showDetail('wlys','')"><fmt:formatNumber value='${datas["wlysAmt"] }' pattern="#,#00.0#"/></a>
				</td>
				<td></td>
			</tr>
			<tr>
			<td>2.待付费用款</td> 
			<td>
			<a href="javascript:;;" style="color: black" onclick="showDetail(7,'')"><fmt:formatNumber value='${datas["dffyAmt"] }' pattern="#,#00.0#"/></a>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>3.应付采购款</td> 
			<td>
			<fmt:formatNumber value='${datas["yfkAmt"]-datas["ysflAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td>
			应付款：<a href="javascript:;;" style="color: black" onclick="showDetail(8,'')"><fmt:formatNumber value='${datas["yfkAmt"]}' pattern="#,#00.0#"/></a>
			-
			应收返利：<a href="javascript:;;" style="color: black" onclick="showDetail(81,'')"><fmt:formatNumber value='${datas["ysflAmt"]}' pattern="#,#00.0#"/></a>
			</td>
			</tr>
			<tr>
			<td style="font-weight: bold;color: blue;">三.净资产合计</td>
			<td style="color:${(datas["accAmt"]+datas["wkaccAmt"]+datas["wlyfAmt"]+datas["yshkAmt"]-datas["yfflAmt"]+datas["qtysAmt"]+datas["gdzckcAmt"]+datas["dzyhkcAmt"]+datas["yfclkcAmt"]+datas["spkcAmt"]+datas["qtwzAmt"]+datas["ztkcAmt"]+datas["produceCostAmt"]+datas["pickUpCostAmt"]-(datas["qtyfAmt"]+datas["dffyAmt"]+datas["wlysAmt"]+datas["yfkAmt"]-datas["ysflAmt"]))>0?'blue':'red'}">
			<fmt:formatNumber value='${datas["accAmt"]+datas["wkaccAmt"]+datas["wlyfAmt"]+datas["yshkAmt"]-datas["yfflAmt"]+datas["qtysAmt"]+datas["gdzckcAmt"]+datas["dzyhkcAmt"]+datas["yfclkcAmt"]+datas["spkcAmt"]+datas["qtwzAmt"]+datas["ztkcAmt"]+datas["produceCostAmt"]+datas["pickUpCostAmt"]-(datas["qtyfAmt"]+datas["dffyAmt"]+datas["wlysAmt"]+datas["yfkAmt"]-datas["ysflAmt"])}' pattern="#,#00.0#"/>
			</td>
			<td></td>
			</tr>
			</table>
			<form action="manager/toFinAssetstatistics" name="toFinAssetstatisticsfrm" id="toFinAssetstatisticsfrm" method="post">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">刷新</a>
			</form>
		</div>
	</body>
	<script>
	function query(){
		document.getElementById("toFinAssetstatisticsfrm").submit();
	}
	
	
	function showDetail(type,costType,isType){
		var sdate = "";
		var edate = $("#edate").val();
		var url = "";
		var tabName ="";
		 //typeId:1 货币资金
		 //typeId:2 应收货款
		 //typeId:3 其他应收款
		 //typeId:4 商品库存
		 //typeId:5 其他物资
		 //typeId:6 其他应付往来款
		 //typeId:7 待付费用款
		 //typeId:8 应付采购款
		if(type==1){
			tabName = "货币资金";
			url =  'manager/toFinAssetCashMoney?sdate='+sdate+'&edate='+edate+'&costType='+costType+'&isType=' + isType;
		}else if(type==2){
			tabName = "应收货款";
			url =  'manager/toFinAssetYszkStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==21){
			tabName = "应付销售返利";
			url =  'manager/stkRebateOut/toRebateOutForAsset?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==3){
			tabName = "其他应收款";
			url =  'manager/toFinAssetOtherYszk?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==4){
			tabName = "商品库存";
			url =  'manager/toFinAsseWareCostStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type+"&isType="+isType;
		}else if(type==5){
			tabName = "其他物资";
		}else if(type==16){
			tabName = "在途库存";
			url =  'manager/toFinAsseWareZtCostStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}
		else if(type==6){
			tabName = "其他应付往来款";
			url =  'manager/toFinAssetOtherYfzk?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==7){
			tabName = "待付费用款";
			url =  'manager/toFinAssetNoPayStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==8){
			tabName = "应付采购款";
			url =  'manager/toFinAssetYfcgStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==81){
			tabName = "应收采购返利";
			url =  'manager/stkRebateIn/toRebateInForAsset?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type=='wlyf'){
			tabName = "往来预付款";
			url =  'manager/toFinPreOutUnitStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type=='wlys'){
			tabName = "往来预收款";
			url =  'manager/toFinPreInUnitStat?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}

		parent.closeWin('资产汇算表_' + tabName);
    	parent.add('资产汇算表_' + tabName,url);
	}
	
	</script>
</html>
