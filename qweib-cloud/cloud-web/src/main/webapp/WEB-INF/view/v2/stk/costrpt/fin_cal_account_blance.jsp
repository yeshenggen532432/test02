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
		<form action="manager/calAccountBlance?_sticky=v2" name="toFinCalAccountBlancefrm" id="toFinCalAccountBlancefrm" method="post">
			日期:
            <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
			<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
			<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</form>
        <c:if test="${not empty datas}">
		<table width="95%" border="1"
			   cellpadding="0" cellspacing="1" >
			<tr style="font-size: 14px;font-weight: bold">
				<td rowspan="2" style="text-align: center">项目</td>
				<td colspan="2" style="text-align: center">
					期初余额
				</td>
				<td rowspan="2" style="text-align: center">
					本期增加
				</td>
				<td  rowspan="2" style="text-align: center">
					本期减少
				</td>
				<td colspan="2" style="text-align: center">
					期末余额
				</td>
			</tr>
			<tr style="font-size: 14px;font-weight: bold">
				<td style="text-align: center">资产类</td>
				<td style="text-align: center">负债类</td>
				<td style="text-align: center">资产类</td>
				<td style="text-align: center">负债类</td>
			</tr>

			<c:set var="accQcAmt" value='${
					datas["cashMap"]["qc_amt"]+
					datas["bankMap"]["qc_amt"]+
					datas["weixinMap"]["qc_amt"]+
					datas["aliPayMap"]["qc_amt"]+
					datas["noCashMap"]["qc_amt"]+
					datas["yszkMap"]["qc_amt"]+
					datas["qtysMap"]["qc_amt"]+
					datas["yfzkMap"]["qc_amt"]+
					datas["wareStockMap"]["qc_amt"]+
					datas["wareWayMap"]["qc_amt"]+
					datas["wareMaterMap"]["qc_amt"]+
					datas["wareOtherMap"]["qc_amt"]+
					datas["wareFixedMap"]["qc_amt"]
					}
			' />
			<c:set var="accOutAmt" value='${
					datas["cashMap"]["bq_out_amt"]+
					datas["bankMap"]["bq_out_amt"]+
					datas["weixinMap"]["bq_out_amt"]+
					datas["aliPayMap"]["bq_out_amt"]+
					datas["noCashMap"]["bq_out_amt"]+
					datas["yszkMap"]["bq_out_amt"]+
					datas["qtysMap"]["bq_out_amt"]+
					datas["yfzkMap"]["bq_out_amt"]+
					datas["wareStockMap"]["bq_out_amt"]+
					datas["wareWayMap"]["bq_out_amt"]+
					datas["wareMaterMap"]["bq_out_amt"]+
					datas["wareOtherMap"]["bq_out_amt"]+
					datas["wareFixedMap"]["bq_out_amt"]
					}' />
			<c:set var="accInAmt" value='${
					datas["cashMap"]["bq_in_amt"]+
					datas["bankMap"]["bq_in_amt"]+
					datas["weixinMap"]["bq_in_amt"]+
					datas["aliPayMap"]["bq_in_amt"]+
					datas["noCashMap"]["bq_in_amt"]+
					datas["yszkMap"]["bq_in_amt"]+
					datas["qtysMap"]["bq_in_amt"]+
					datas["yfzkMap"]["bq_in_amt"]+
					datas["wareStockMap"]["bq_in_amt"]+
					datas["wareWayMap"]["bq_in_amt"]+
					datas["wareMaterMap"]["bq_in_amt"]+
					datas["wareOtherMap"]["bq_in_amt"]+
					datas["wareFixedMap"]["bq_in_amt"]
					}'  />
			<c:set var="accQmAmt" value='${
					datas["cashMap"]["qm_amt"]+
					datas["bankMap"]["qm_amt"]+
					datas["weixinMap"]["qm_amt"]+
					datas["aliPayMap"]["qm_amt"]+
					datas["noCashMap"]["qm_amt"]+
					datas["yszkMap"]["qm_amt"]+
					datas["qtysMap"]["qm_amt"]+
					datas["yfzkMap"]["qm_amt"]+
					datas["wareStockMap"]["qm_amt"]+
					datas["wareWayMap"]["qm_amt"]+
					datas["wareMaterMap"]["qm_amt"]+
					datas["wareOtherMap"]["qm_amt"]+
					datas["wareFixedMap"]["qm_amt"]
					}' />


			<c:set var="fzQcAmt" value='${
					datas["qtyfMap"]["qc_amt"]+
					datas["yskxMap"]["qc_amt"]+
					datas["dffyMap"]["qc_amt"]+
					datas["yfcgMap"]["qc_amt"]
					}' />
			<c:set var="fzOutAmt" value='${
					datas["qtyfMap"]["bq_out_amt"]+
					datas["yskxMap"]["bq_out_amt"]+
					datas["dffyMap"]["bq_out_amt"]+
					datas["yfcgMap"]["bq_out_amt"]
					}' />
			<c:set var="fzInAmt" value='${
					datas["qtyfMap"]["bq_in_amt"]+
					datas["yskxMap"]["bq_in_amt"]+
					datas["dffyMap"]["bq_in_amt"]+
					datas["yfcgMap"]["bq_in_amt"]
					}' />
			<c:set var="fzQmAmt" value='${
					datas["qtyfMap"]["qm_amt"]+
					datas["yskxMap"]["qm_amt"]+
					datas["dffyMap"]["qm_amt"]+
					datas["yfcgMap"]["qm_amt"]
					}' />

			<tr style="font-size: 12px;font-weight: bold">
				<td >一.资产类</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQcAmt}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accInAmt}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accOutAmt}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQmAmt}' pattern="#,#00.0#"/>
				</td>
				<td>
				</td>

			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td style="padding-left: 40px">&nbsp;(一) 货币资金</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${
					datas["cashMap"]["qc_amt"]+
					datas["bankMap"]["qc_amt"]+
					datas["weixinMap"]["qc_amt"]+
					datas["aliPayMap"]["qc_amt"]
					}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${
					datas["cashMap"]["bq_in_amt"]+
					datas["bankMap"]["bq_in_amt"]+
					datas["weixinMap"]["bq_in_amt"]+
					datas["aliPayMap"]["bq_in_amt"]
					}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${
					datas["cashMap"]["bq_out_amt"]+
					datas["bankMap"]["bq_out_amt"]+
					datas["weixinMap"]["bq_out_amt"]+
					datas["aliPayMap"]["bq_out_amt"]
					}' pattern="#,#00.0#"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${
					datas["cashMap"]["qm_amt"]+
					datas["bankMap"]["qm_amt"]+
					datas["weixinMap"]["qm_amt"]+
					datas["aliPayMap"]["qm_amt"]
					}' pattern="#,#00.0#"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(11,0,'现金')">
				<td style="padding-left: 60px;">&nbsp;&nbsp;1.现金</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["cashMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["cashMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["cashMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["cashMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				</td>
			</tr>
			<tr ondblclick="showDetail(11,3,'银行存款')">
				<td style="padding-left: 60px;">&nbsp;&nbsp;2.银行存款</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["bankMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["bankMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["bankMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["bankMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(11,1,'微信')">
				<td style="padding-left: 60px;">&nbsp;&nbsp;3.微信</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["weixinMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["weixinMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["weixinMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["weixinMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(11,2,'支付宝')">
				<td style="padding-left: 60px;">&nbsp;&nbsp;4.支付宝</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["aliPayMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["aliPayMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["aliPayMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["aliPayMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td style="padding-left: 40px">&nbsp;(二) 现金等价物</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["noCashMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["noCashMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["noCashMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["noCashMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(11,4,'无卡账号')">
				<td style="padding-left: 60px;">&nbsp;&nbsp;1.无卡账号</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["noCashMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["noCashMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["noCashMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["noCashMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(13,0,'应收账款')">
				<td style="padding-left: 40px;">&nbsp;(三) 应收账款</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yszkMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["yszkMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yszkMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["yszkMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr  ondblclick="showDetail(14,0,'其它应收款')">
				<td style="padding-left: 40px;">&nbsp;(四) 其它应收款</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["qtysMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["qtysMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["qtysMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["qtysMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(15,0,'预付账款')">
				<td style="padding-left: 40px;">&nbsp;(五) 预付账款</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yfzkMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["yfzkMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yfzkMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right" >
                    <fmt:formatNumber value='${datas["yfzkMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(16,0,'商品库存')">
				<td style="padding-left: 40px;">&nbsp;(六) 商品库存</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareStockMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareStockMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareStockMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareStockMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(17,0,'在途商品')">
				<td style="padding-left: 40px;color: red">&nbsp;(七) 在途商品(数据有出入)</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareWayMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareWayMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareWayMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareWayMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(16,1,'原辅材料')">
				<td style="padding-left: 40px;">&nbsp;(八) 原辅材料</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareMaterMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareMaterMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareMaterMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareMaterMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(16,2,'其它物资')">
				<td style="padding-left: 40px;">&nbsp;(九) 其它物资</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareOtherMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareOtherMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareOtherMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td  style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareOtherMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td style="padding-left: 40px">&nbsp;(十) 在产品(未做)</td>
				<td >
                    -
				</td>
				<td >

				</td>
				<td >
                    -
				</td>
				<td >
                    -
				</td>
				<td>
                    -
				</td>
				<td>
				</td>
			</tr>
			<tr ondblclick="showDetail(16,3,'固定资产')">
				<td style="padding-left: 40px;">&nbsp;(十一) 固定资产</td>
				<td style="padding-right: 10px;text-align: right" >
					 <fmt:formatNumber value='${datas["wareFixedMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareFixedMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["wareFixedMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["wareFixedMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td>二.负债类</td>
				<td></td>
				<td style="padding-right: 10px;text-align: right"><fmt:formatNumber value='${fzQcAmt}' pattern="#,#00.00"/></td>
				<td style="padding-right: 10px;text-align: right"><fmt:formatNumber value='${fzOutAmt}' pattern="#,#00.00"/></td>
				<td style="padding-right: 10px;text-align: right"><fmt:formatNumber value='${fzInAmt}' pattern="#,#00.00"/></td>
				<td></td>
				<td style="padding-right: 10px;text-align: right"><fmt:formatNumber value='${fzQmAmt}' pattern="#,#00.00"/></td>
			</tr>
			<tr ondblclick="showDetail(21,0,'其它应付款')">
				<td style="padding-left: 40px;">&nbsp;(一) 其它应付款</td>

				<td >
				</td>
				<td style="padding-right: 10px;text-align: right" >
					<fmt:formatNumber value='${datas["qtyfMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right" >
					 <fmt:formatNumber value='${datas["qtyfMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right" >
                    <fmt:formatNumber value='${datas["qtyfMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>

				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["qtyfMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(22,0,'预收账款')">
				<td style="padding-left: 40px;">&nbsp;(二) 预收账款</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["yskxMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yskxMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["yskxMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right" >
					<fmt:formatNumber value='${datas["yskxMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(23,0,'待付费用款')">
				<td style="padding-left: 40px;">&nbsp;(三) 待付费用款</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["dffyMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right" >
					 <fmt:formatNumber value='${datas["dffyMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["dffyMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["dffyMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(24,0,'应付采购款')">
				<td style="padding-left: 40px;">&nbsp;(四) 应付采购款</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["yfcgMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yfcgMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
                    <fmt:formatNumber value='${datas["yfcgMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					 <fmt:formatNumber value='${datas["yfcgMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>

			<tr  style="font-size: 12px;font-weight: bold">
				<td >三.所有者权益类</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQcAmt-(datas["sszbMap"]["qc_amt"]+fzQcAmt)+datas["sszbMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accInAmt-(datas["sszbMap"]["bq_in_amt"]+fzInAmt)+datas["sszbMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accOutAmt-(datas["sszbMap"]["bq_in_out"]+fzOutAmt)+datas["sszbMap"]["bq_in_out"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQmAmt-(datas["sszbMap"]["qm_amt"]+fzQmAmt)+datas["sszbMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(31,0,'实收资本')">
				<td style="padding-left: 40px;">&nbsp;(一) 实收资本</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["sszbMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["sszbMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["sszbMap"]["bq_out_amt"]}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["sszbMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr >
				<td style="padding-left: 40px;">&nbsp;(二) 未分配利润</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQcAmt-(datas["sszbMap"]["qc_amt"]+fzQcAmt)}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accInAmt-(datas["sszbMap"]["bq_in_amt"]+fzInAmt)}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accOutAmt-(datas["sszbMap"]["bq_in_out"]+fzOutAmt)}' pattern="#,#00.00"/>
				</td>
				<td>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQmAmt-(datas["sszbMap"]["qm_amt"]+fzQmAmt)}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr >
				<td style="padding-left: 40px;">&nbsp;(三) 资本积累</td>
				<td >
				</td>
				<td >
					-
				</td>
				<td >
					-
				</td>
				<td >
					-
				</td>

				<td>
				</td>
				<td>
					-
				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td style="padding-left: 40px;">&nbsp; 合计</td>
				<td style="padding-right: 10px;text-align: right" >
					<fmt:formatNumber value='${accQcAmt}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right" >
					<fmt:formatNumber value='${fzQcAmt+accQcAmt-(datas["sszbMap"]["qc_amt"]+fzQcAmt)+datas["sszbMap"]["qc_amt"]}' pattern="#,#00.00"/>
				</td>
				<td >
				</td>
				<td >
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${accQmAmt}' pattern="#,#00.00"/>
				</td>
				<td style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${fzQmAmt+accQmAmt-(datas["sszbMap"]["qm_amt"]+fzQmAmt)+datas["sszbMap"]["qm_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr >
				<td style="text-align: center" colspan="8"></td>
			</tr>
			<c:set var="inMapSum"
				value='${
				datas["spxxsrMap"]["bq_in_amt"]+
				datas["qtxssrMap"]["bq_in_amt"]+
				datas["qtsrxmMap"]["bq_in_amt"]
				}'
			/>
			<c:set var="outMapSum" value='${
				datas["spxxcbMap"]["bq_in_amt"]+
				datas["spzkMap"]["bq_in_amt"]+
				datas["qtxscbMap"]["bq_in_amt"]+
				datas["glfyMap"]["bq_in_amt"]+
				datas["jyfyMap"]["bq_in_amt"]
			}'

			/>
			<tr style="font-size: 14px;font-weight: bold">
				<td style="text-align: center">项目</td>
				<td style="text-align: center" colspan="3">
					收入类
				</td>
				<td style="text-align: center"  colspan="3">
					成本类
				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td>四 收入类</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${inMapSum}' pattern="#,#00.00"/>
				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">

				</td>
			</tr>
			<tr ondblclick="showDetail(41,0,'商品销售收入')">
				<td style="padding-left: 40px;" >&nbsp;(一) 商品销售收入</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["spxxsrMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td colspan="3">

				</td>
			</tr>
			<tr ondblclick="showDetail(42,0,'其它销售收入')">
				<td style="padding-left: 40px;" >&nbsp;(二) 其它销售收入 </td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["qtxssrMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
				<td colspan="3">

				</td>
			</tr>
			<tr  ondblclick="showDetail(43,0,'其他收入项目')">
				<td style="padding-left: 40px;">&nbsp;(三) 其他收入项目</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">

					<fmt:formatNumber value='${datas["qtsrxmMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>

				<td colspan="3">

				</td>
			</tr>
			<tr style="font-size: 12px;font-weight: bold">
				<td>五 成本、费用类</td>
				<td colspan="3">


				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${outMapSum}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(51,0,'商品销售成本')">
				<td style="padding-left: 40px;">&nbsp;(一) 商品销售成本</td>
				<td colspan="3">

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["spxxcbMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(52,0,'商品折扣')">
				<td style="padding-left: 40px;">&nbsp;(二) 商品折扣</td>
				<td colspan="3">

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["spzkMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(53,0,'其他销售成本')">
				<td style="padding-left: 40px;">&nbsp;(三) 其他销售成本</td>

				<td colspan="3">

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["qtxscbMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(54,0,'经营费用')">
				<td style="padding-left: 40px;">&nbsp;(四) 经营费用</td>
				<td colspan="3">

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["jyfyMap"]["bq_in_amt"]}' pattern="#,#00.00"/>
				</td>
			</tr>
			<tr ondblclick="showDetail(55,0,'管理费用')">
				<td style="padding-left: 40px;">&nbsp;(五) 管理费用</td>
				<td colspan="3">

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${datas["glfyMap"]["bq_in_amt"]}' pattern="#,#00.00"/>

				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td style="padding-left: 40px;">&nbsp;本期利润</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">

					<c:if test="${inMapSum>=outMapSum}">
						(+)<fmt:formatNumber value='${inMapSum-outMapSum}' pattern="#,#00.00"/>
					</c:if>
					<c:if test="${inMapSum<outMapSum}">
						(-)<fmt:formatNumber value='${inMapSum-outMapSum}' pattern="#,#00.00"/>
					</c:if>

				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
				</td>
			</tr>
			<tr  style="font-size: 12px;font-weight: bold">
				<td style="padding-left: 40px;">&nbsp;合计</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${inMapSum}' pattern="#,#00.00"/>
				</td>
				<td colspan="3" style="padding-right: 10px;text-align: right">
					<fmt:formatNumber value='${outMapSum}' pattern="#,#00.00"/>
				</td>
			</tr>
		</table>
        </c:if>
	</div>
	</body>
	<%@include file="/WEB-INF/view/v2/include/script-kendo.jsp" %>
	<script>
		function query(){
			uglcw.ui.loading();
			document.getElementById("toFinCalAccountBlancefrm").submit();
		}
		function showDetail(rptType,typeId,tabName){
		var sdate = $("#sdate").val();;
		var edate = $("#edate").val();
		var url = "<%=basePath %>/manager/calAccountBlanceList?_sticky=v2&sdate="+sdate+"&edate="+edate+"&rptType="+rptType+"&typeId="+typeId;
		uglcw.ui.openTab('科目余额表_' + tabName,url);
	}

</script>
</html>
