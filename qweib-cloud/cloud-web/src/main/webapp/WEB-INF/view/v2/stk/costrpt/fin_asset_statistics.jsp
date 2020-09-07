<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<title>资产汇算表</title>
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
	<form action="manager/toFinAssetstatistics" name="toFinAssetstatisticsfrm" id="toFinAssetstatisticsfrm" method="post">
	<div class="layui-card header">
		<div class="layui-card-body">
			<ul class="uglcw-query">

					<li>
					<input uglcw-model="edate" uglcw-role="datepicker" id="edate" value="${edate}">
					</li>
					<li>
					<button id="search" uglcw-role="button" class="k-button k-info">查询</button>
					</li>

			</ul>
		</div>
	</div>
	</form>
	<div class="layui-card">
		<div class="layui-card-body full" uglcw-role="resizable" uglcw-options="responsive:['.header', 75]" id="container">
			<table  border="1"
				   cellpadding="0" cellspacing="1">
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
					<td style="text-align: center;width: 150px">
						资产
					</td>
					<td style="text-align: center;width: 160px">
						累计数
					</td>


					<td style="text-align: center;width: 150px">
						负债
					</td>
					<td style="text-align: center;width: 160px">
						累计数
					</td>


				</tr>
				<c:set var="zchjAmt" value='${datas["accAmt"]+datas["wkaccAmt"]+datas["wlyfAmt"]+datas["yshkAmt"]-datas["yfflAmt"]+datas["qtysAmt"]+datas["gdzckcAmt"]+datas["dzyhkcAmt"]+datas["yfclkcAmt"]+datas["spkcAmt"]+datas["qtwzAmt"]+datas["ztkcAmt"]+datas["produceCostAmt"]+datas["pickUpCostAmt"]}'/>
				<tr>
					<td class="title_class">1.货币资金</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(1,'',1)"><fmt:formatNumber value='${datas["accAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">1.其他应付往来款</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(6,'')"><fmt:formatNumber value='${datas["qtyfAmt"] }' pattern="#,#00.0#"/></a>
					</td>
				</tr>
				<tr>
					<td class="title_class">2.现金等价物</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(1,'',4)"><fmt:formatNumber value='${datas["wkaccAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">2.预收款</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail('wlys','')"><fmt:formatNumber value='${datas["wlysAmt"] }' pattern="#,#00.0#"/></a>
					</td>
				</tr>
				<tr>
					<td class="title_class">3.应收货款</td>
					<td style="text-align: right;padding-right: 12px" title="其中应收账:<fmt:formatNumber value='${datas["yshkAmt"]}' pattern="#,#00.0#"/>,应付返利:<fmt:formatNumber value='${datas["yfflAmt"]}' pattern="#,#00.0#"/>">
						<fmt:formatNumber value='${datas["yshkAmt"]-datas["yfflAmt"]}' pattern="#,#00.0#"/>
					</td>

					<td class="title_class" title="其中应付款:<fmt:formatNumber value='${datas["yfkAmt"]}' pattern="#,#00.0#"/>,应收返利:<fmt:formatNumber value='${datas["ysflAmt"]}' pattern="#,#00.0#"/>">3.应付采购款</td>
					<td style="text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${datas["yfkAmt"]-datas["ysflAmt"]}' pattern="#,#00.0#"/>
					</td>

				</tr>
					<%--<tr>--%>
						<%--<td style="text-align: right;padding-right: 12px">--%>
							<%--其中应收账:<a href="javascript:;;" style="color: black" onclick="showDetail(2,'')"><fmt:formatNumber value='${datas["yshkAmt"]}' pattern="#,#00.0#"/></a>--%>
							<%--应付返利:<a href="javascript:;;" style="color: black" onclick="showDetail(21,'')"><fmt:formatNumber value='${datas["yfflAmt"]}' pattern="#,#00.0#"/></a>--%>
						<%--</td>--%>

						<%--<td style="text-align: right;padding-right: 12px">--%>
							<%--其中应付款:<a href="javascript:;;" style="color: black" onclick="showDetail(8,'')"><fmt:formatNumber value='${datas["yfkAmt"]}' pattern="#,#00.0#"/></a>--%>
							<%--应收返利:<a href="javascript:;;" style="color: black" onclick="showDetail(81,'')"><fmt:formatNumber value='${datas["ysflAmt"]}' pattern="#,#00.0#"/></a>--%>
						<%--</td>--%>
					<%--</tr>--%>
				<tr>
					<td class="title_class">4.其他应收款</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(3,'')"><fmt:formatNumber value='${datas["qtysAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">
						4.待付费用款
						</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(7,'')"><fmt:formatNumber value='${datas["dffyAmt"] }' pattern="#,#00.0#"/></a>

					</td>
				</tr>
				<tr>
					<td class="title_class">5.预付款</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail('wlyf','')"><fmt:formatNumber value='${datas["wlyfAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<c:set var="fzxjAmt" value='${datas["qtyfAmt"]+datas["dffyAmt"]+datas["wlysAmt"]+datas["yfkAmt"]-datas["ysflAmt"]}'/>
					<td class="title_class" style="font-weight: bold;">负债合计</td>
					<td colspan="2" style="color:${fzxjAmt>0?'blue':'red'};text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${fzxjAmt}' pattern="#,#00.0#"/>
					</td>

				</tr>
					<c:set var="wfplrAmt" value='${zchjAmt-fzxjAmt-datas["sszbAmt"]-datas["yfplyAmt"]}'/>
					<%--未分配利润 = 资产合计-负债合计-实收资本-已分配利润--%>
				<tr>
					<td class="title_class">6.商品库存</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',0)"><fmt:formatNumber value='${datas["spkcAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td  class="title_class" style="font-weight: bold">所有者权益</td>
					<td style="text-align: right;padding-right: 12px">

					</td>


				</tr>
				<tr>
					<td class="title_class">7.原辅材料</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',1)"><fmt:formatNumber value='${datas["yfclkcAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">&nbsp;&nbsp;实收资本</td>
					<td style="text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${datas["sszbAmt"]}' pattern="#,#00.0#"/>
					</td>

				</tr>
				<tr>
					<td class="title_class">8.其他物资</td><%--低值易耗--%>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',2)"><fmt:formatNumber value='${datas["dzyhkcAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">&nbsp;&nbsp;资本公积</td>
					<td  style="text-align: right;padding-right: 12px">
						--
					</td>
				</tr>
				<tr>
					<td class="title_class">9.在途库存</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(16,'')"><fmt:formatNumber value='${datas["ztkcAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class" >&nbsp;&nbsp;未分配利润</td>
					<td style="text-align: right;padding-right: 12px">

						<fmt:formatNumber value='${wfplrAmt}' pattern="#,#00.0#"/>
					</td>
				</tr>
				<tr>
					<td class="title_class" >10.在产品</td>
					<td style="text-align: right;padding-right: 12px" title="制造费用余：<fmt:formatNumber value='${datas["produceCostAmt"]}' pattern="#,#00.0#"/>&nbsp;领料结余成本:<fmt:formatNumber value='${datas["pickUpCostAmt"]}' pattern="#,#00.0#"/>">
						<fmt:formatNumber value='${datas["produceCostAmt"]+datas["pickUpCostAmt"]}' pattern="#,#00.0#"/>
					</td>

					<td class="title_class" >&nbsp;&nbsp;&nbsp;(已分配利润)</td>
					<td style="text-align: right;padding-right: 12px">
						(<fmt:formatNumber value='${datas["yfplyAmt"]}' pattern="#,#00.0#"/>)
					</td>
				</tr>
				<%--<tr>--%>
					<%--<td style="text-align: right;padding-right: 12px">--%>
						<%--制造费用余：<fmt:formatNumber value='${datas["produceCostAmt"]}' pattern="#,#00.0#"/>&nbsp;领料结余成本:<fmt:formatNumber value='${datas["pickUpCostAmt"]}' pattern="#,#00.0#"/>--%>
					<%--</td>--%>
					<%--<td></td>--%>
					<%--<td>--%>
					<%--</td>--%>
				<%--</tr>--%>
				<tr>
					<td class="title_class">11.固定资产</td>
					<td style="text-align: right;padding-right: 12px">
						<a href="javascript:;;" style="color: black" onclick="showDetail(4,'',3)"><fmt:formatNumber value='${datas["gdzckcAmt"]}' pattern="#,#00.0#"/></a>
					</td>
					<td class="title_class">所有者权益小计</td>
					<td  style="text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${datas["sszbAmt"]+wfplrAmt}' pattern="#,#00.0#"/>
					</td>
				</tr>
				<tr>
					<td class="title_class" style="font-weight: bold;color: blue;">资产合计</td>
					<td  style="color:${zchjAmt>0?'blue':'red'};text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${zchjAmt}'  pattern="#,#00.0#"></fmt:formatNumber>
					</td>
					<td class="title_class"  style="font-weight: bold;color: blue;">负债和所有者权益合计</td>
					<td  style="color:${(wfplrAmt+datas["sszbAmt"]+fzxjAmt)>0?'blue':'red'};text-align: right;padding-right: 12px">
						<fmt:formatNumber value='${wfplrAmt+datas["sszbAmt"]+fzxjAmt+datas["yfplyAmt"]}' pattern="#,#00.0#"/>
						<%--负债和所有者权益合计=未分配利润+实收资本+负债合计+已分配利润--%>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
<script>
	$(function () {
		uglcw.ui.init();

		uglcw.ui.get('#search').on('click', function () {   //搜索（查询）
			uglcw.ui.loading();
			document.getElementById("toFinAssetstatisticsfrm").submit();
		})
		uglcw.ui.loaded()
	})
	function showDetail(type,costType,isType){
		var sdate = "";
		var edate = $("#edate").val();
		var url = "";
		var tabName ="";

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
			url =  'manager/toFinOutTotal?dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type;
		}else if(type==4){
			tabName = "商品库存";
			url =  'manager/toFinAsseWareCostStat?_sticky=v1&dataTp=&sdate='+sdate+'&edate='+edate+'&costType='+costType+'&typeId=' + type+"&isType="+isType;
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
		uglcw.ui.openTab('资产汇算表_' + tabName,url);
	}
</script>
</body>
</html>
