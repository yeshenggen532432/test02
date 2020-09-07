<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>科目余额表</title>

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
		<form action="manager/calAccountBlance" name="toFinCalAccountBlancefrm" id="toFinCalAccountBlancefrm" method="post">
			日期:
			<input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			</form>
			<table width="100%" border="1"
					cellpadding="0" cellspacing="1" >
				<tr>
					<td>科目项目</td>
					<td >
						期初余额
					</td>
					<td >
						本期增加
					</td>
					<td >
						本期减少
					</td>
					<td >
						期末余额
					</td>
				</tr>
				<tr>
					<td colspan="5">一.货币资金</td>
				</tr>
				<tr>
					<td>&nbsp;(一) 货币资金</td>
					<td >
					</td>
					<td >
					</td>
					<td >
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;1.现金</td>
					<td >
						${datas["cashMap"]["qc_amt"]}
					</td>
					<td >
						${datas["cashMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["cashMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["cashMap"]["qm_amt"]}
					</td>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;2.银行存款</td>
					<td >
						${datas["bankMap"]["qc_amt"]}
					</td>
					<td >
						${datas["bankMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["bankMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["bankMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;3.微信</td>
					<td >
						${datas["weixinMap"]["qc_amt"]}
					</td>
					<td >
						${datas["weixinMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["weixinMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["weixinMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;4.支付宝</td>
					<td >
						${datas["aliPayMap"]["qc_amt"]}
					</td>
					<td >
						${datas["aliPayMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["aliPayMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["aliPayMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(二) 现金等价物</td>
					<td >
					</td>
					<td >
					</td>
					<td >
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;1.无卡账号</td>
					<td >
						${datas["noCashMap"]["qc_amt"]}
					</td>
					<td >
						${datas["noCashMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["noCashMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["noCashMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(三) 应收账款</td>
					<td >
						${datas["yszkMap"]["qc_amt"]}
					</td>
					<td >
						${datas["yszkMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["yszkMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["yszkMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(四) 其它应收款</td>
					<td >
						${datas["qtysMap"]["qc_amt"]}
					</td>
					<td >
						${datas["qtysMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["qtysMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["qtysMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(五) 预付账款</td>
					<td >
						${datas["yfzkMap"]["qc_amt"]}
					</td>
					<td >
						${datas["yfzkMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["yfzkMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["yfzkMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(六) 商品库存</td>
					<td >
						${datas["wareStockMap"]["qc_amt"]}
					</td>
					<td >
						${datas["wareStockMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["wareStockMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["wareStockMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(七) 在途商品</td>
					<td >
						${datas["wareWayMap"]["qc_amt"]}
					</td>
					<td >
						${datas["wareWayMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["wareWayMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["wareWayMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(八) 原辅材料</td>
					<td >
						${datas["wareMaterMap"]["qc_amt"]}
					</td>
					<td >
						${datas["wareMaterMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["wareMaterMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["wareMaterMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(九) 其它物资</td>
					<td >
						${datas["wareOtherMap"]["qc_amt"]}
					</td>
					<td >
						${datas["wareOtherMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["wareOtherMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["wareOtherMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(十) 在产品</td>
					<td >
					</td>
					<td >
					</td>
					<td >
					</td>
					<td>
					</td>
				</tr>
				<tr>
					<td>&nbsp;(十一) 固定资产</td>
					<td >
						${datas["wareFixedMap"]["qc_amt"]}
					</td>
					<td >
						${datas["wareFixedMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["wareFixedMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["wareFixedMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td colspan="5">二.负债类</td>

				</tr>
				<tr>
					<td>&nbsp;(一) 其它应付款</td>
					<td >
						${datas["qtyf"]["qc_amt"]}
					</td>
					<td >
						${datas["qtyf"]["bq_in_amt"]}
					</td>
					<td >
						${datas["qtyf"]["bq_out_amt"]}
					</td>
					<td>
						${datas["qtyf"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(二) 预收账款</td>
					<td >
						${datas["yskxMap"]["qc_amt"]}
					</td>
					<td >
						${datas["yskxMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["yskxMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["yskxMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(三) 待付费用款</td>
					<td >
						${datas["dffyMap"]["qc_amt"]}
					</td>
					<td >
						${datas["dffyMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["dffyMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["dffyMap"]["qm_amt"]}
					</td>
				</tr>
				<tr>
					<td>&nbsp;(四) 应付采购款</td>
					<td >
						${datas["yfcgMap"]["qc_amt"]}
					</td>
					<td >
						${datas["yfcgMap"]["bq_in_amt"]}
					</td>
					<td >
						${datas["yfcgMap"]["bq_out_amt"]}
					</td>
					<td>
						${datas["yfcgMap"]["qm_amt"]}
					</td>
				</tr>
			</table>

		</div>
	</body>
	<script>
	function query(){
		document.getElementById("toFinCalAccountBlancefrm").submit();
	}
	
	
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
