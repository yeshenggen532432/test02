<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="permission" uri="/WEB-INF/tlds/permission.tld" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html style="font-size: 50px;">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>生产入库管理</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/Map.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript">
		var map = new Map();
		var combMap = new Map();
		</script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
	</head>
	<body>

		<style type="text/css">
			.menu_btn .item p{
				font-size: 12px;
			}
			.menu_btn .item img:last-of-type{
				display: none;
			}
			.menu_btn .item a{
				color: #00a6fb;
			}
			.menu_btn .item.on img:first-child{
				display: none;
			}
			.menu_btn .item.on img:last-of-type{
				display: inline;
			}
			.menu_btn .item.on a{
				color: #333;
			}
		</style>
		<form action="<%=basePath %>/manager/stkProduce/save" name="savefrm" id="savefrm" method="post">
		<div class="center">
			<div class="pcl_lib_out">
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<%--<div class="item on" id="btnnew">--%>
							<%--<a href="javascript:newClick();">--%>
								<%--<img src="<%=basePath %>/resource/stkstyle/img/nicon7.png"/>--%>
								<%--<img src="<%=basePath %>/resource/stkstyle/img/nicon7a.png"/>--%>
								<%--<p>新建</p>--%>
							<%--</a>--%>
						<%--</div>--%>
						<div class="item" id="btnSave" style="display:${(stkProduce.status eq -2)?'':'none' }">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>暂存</p>
							</a>
						</div>
						<div class="item" id="btnAudit" style="display:${(stkProduce.status eq -2 and not empty stkProduce.id)?'':'none' }">
							<a href="javascript:audit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>审批</p>
							</a>
						</div>
						<div class="item" id="btnAuditSh" style="display:${(stkProduce.status eq 0)?'':'none' }">
							<a href="javascript:auditSh();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>确认入库</p>
							</a>
						</div>
						<div class="item" id="btncancel" style="display:${(stkProduce.id eq 0 or stkProduce.status eq 2)?'none':'' }">
							<a href="javascript:cancel();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>
						<%--
						<div class="item" id="btnprint">
							<a href="javascript:print();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
								<p>打印</p>
							</a>
						</div>
						--%>
						<div class="pcl_right_edi" style="width: 500px;">
							<div class="pcl_right_edi_w">
								<div>
								<span style="color:green">${stkProduce.billName}</span>
								<input type="text" id="billNo" name="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${stkProduce.billNo}"/>
								  <c:choose>
								  	<c:when test="${stkProduce.status eq -2}"><input type="text" id="billstatus"  value="暂存"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkProduce.status eq 0}"><input type="text" id="billstatus"  value="未入库"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkProduce.status eq 1}"><input type="text" id="billstatus"  value="已入库"   style="color:red;width:60px" readonly="readonly"/></c:when>
								  	<c:when test="${stkProduce.status eq 2}"><input type="text" id="billstatus"  value="已作废"   style="color:red;width:60px" readonly="readonly"/></c:when>
									  <c:otherwise>
									  	<input type="text" id="billstatus"  value="新建"   style="color:red;width:70px" readonly="readonly"/>
									  </c:otherwise>
								    </c:choose>
								<input type="text" id="billstatus"    style="color:red;width:60px" readonly="readonly"/>
								</div>
							</div>
						</div>
					</div>
				</div>
				<input  type="hidden" name="id" id="billId" value="${stkProduce.id}"/>
				<input  type="hidden" name="bizType" id="bizType" value="${stkProduce.bizType}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkProduce.stkName}"/>
				<input  type="hidden" name="proName" id="proName" value="${stkProduce.proName}"/>
				<input  type="hidden" name="proType" id="proType" value="5"/>
				<input  type="hidden" name="status" id="status" value="${stkProduce.status}"/>
				<input  type="hidden" name="ioMark" id="ioMark" value="${stkProduce.ioMark}"/>
				<input  type="hidden" name="billName" id="billName" value="${stkProduce.billName}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="inDate" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${stkProduce.inDate}"  readonly="readonly"/>
								</div>
								</td>
								<td>仓&nbsp;&nbsp;&nbsp;&nbsp;库：</td>
								<td>
								<div class="selbox">
								<span id="stkNamespan">${stkProduce.stkName}</span>
									<tag:select name="stkId" id="stkId" tclass="pcl_sel"  tableName="stk_storage" value="${stkProduce.stkId }"  displayKey="id" displayValue="stk_name"/>
								</div>
								</td>
								<td>车&nbsp;&nbsp;&nbsp;&nbsp;间：</td>
								<td>
								<div class="selbox">
								<span id="stkProNamespan">${stkProduce.proName}</span>
									<tag:select name="proId" id="proId" tclass="pcl_sel" tableName="sys_depart" value="${stkProduce.proId }"  displayKey="branch_id" displayValue="branch_name"/>
								</div>
								</td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="3">
									<div class="pcl_txr">
										<textarea name="remarks" id="remarks" value="${stkProduce.remarks}"></textarea>
									</div>
								</td>
								<td colspan="2">
									<table>
										<tr>
										<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2 )?'':'none' }">
										制造费用:
										</td>
										<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2 )?'':'none' }">
										<table>
											<td>
											<div class="pcl_input_box pcl_w2">
												<input  type="text" name="referCostAmt" readonly="readonly"  id="referCostAmt" value="${stkProduce.referCostAmt}"/>
												</div>
											</td>
											<td>
												<c:if test="${stkProduce.status eq 0}">
												<a class="easyui-linkbutton"  iconCls="icon-add" plain="true" href="javascript:getCostSumForProduce();">加载费用</a>
												</c:if>
											</td>
										</table>
										</td>
										</tr>
										<tr>
											<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2 )?'':'none' }">本次分摊:</td>
											<td  style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2 )?'':'none' }">
												<div class="pcl_input_box pcl_w2">
												<input  type="text" name="costAmt" onchange="calProduceCostAmt()" id="costAmt" value="${stkProduce.costAmt}"/>
												</div>
											</td>
										</tr>
									 </table>


								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div id="easyTabs" class="easyui-tabs" style="width:auto;height:auto;">
			    <div title="入库产品" style="padding:10px;">
				<div id="tb" style="padding:5px;height:auto">
				<c:if test="${stkProduce.status eq -2}">
			 <a class="easyui-linkbutton"  iconCls="icon-add" plain="true" href="javascript:dialogSelectWare(0);">添加产品</a>
				</c:if>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td>生产数量</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">单位生产单价</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">直接成本</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">制造费用</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">总成本</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${stkProduce.subList}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="subList[${s.index }].id" value = "${item.id}"/>
								<input type="hidden" name="subList[${s.index }].mastId" value = "${item.mastId}"/>
								<input id="wareId${s.index }" type="hidden" name="subList[${s.index }].wareId" value = "${item.wareId}"/>
							    <input id="wareCode${s.index }" name="subList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td>
								 <input id="wareNm${s.index }" name="subList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
								</td>
								<td>
								 <input id="wareGg${s.index }" name="subList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<%--<td>--%>
								<%--<select id="beUnit${s.index }" name="subList[${s.index }].beUnit" class="pcl_sel2" onchange="changeRelaUnit(this,${s.index })">--%>
        						<%--<option value="${item.maxUnitCode}">${item.wareDw}</option>--%>
        						<%--<option value="${item.minUnitCode}">${item.minUnit}</option>--%>
        						<%--</select>--%>
        						<%--<script type="text/javascript">--%>
										<%--document.getElementById("beUnit${s.index}").value='${item.beUnit}';--%>
								<%--</script>--%>
								<%--</td>--%>

								<td >
									<input id="beUnit${s.index }" type="hidden" name="subList[${s.index }].beUnit" value = "${item.beUnit}"/>
									<input id="unitName${s.index }" name="subList[${s.index }].unitName" readonly="readonly" type="text" class="pcl_i2" value="${item.unitName}" />
								</td>
								<td >
								<input id="qty${s.index }" name="subList[${s.index }].qty" type="text" "${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'readonly':''}" class="pcl_i2" value="${item.qty}" onchange="countAmt(),resetStkWareTplList(${item.wareId},this)"/>
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="price${s.index }" name="subList[${s.index }].price" readonly="readonly" type="text" class="pcl_i2" value="${item.price}" onchange="countAmt()"/>
								</td>

								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="orgAmt${s.index }" name="subList[${s.index }].orgAmt" readonly="readonly" type="text" class="pcl_i2" value="${item.orgAmt}" />
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="productAmt${s.index }" name="subList[${s.index }].productAmt" type="text" class="pcl_i2" value="${item.productAmt}" onchange="countProductAmt()" />
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="amt${s.index }" name="subList[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="subList[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<input id="orgPrice${s.index }" name="subList[${s.index }].orgPrice" type="hidden" class="pcl_i2" value="${item.orgPrice}" />
								</td>
								<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del" style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'none':''}">删除</a></td>
								</tr>
								<script>
									map.put('${item.wareId}','${item.wareNm}');
								</script>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</div>

				 <div title="原料总消耗" style="padding:10px;">
				 <div id="tb2" style="padding:5px;height:auto">
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1" >
						<table id="more_list_comb">
							<thead>
								<tr>
									<td>原料编号</td>
									<td>原料名称</td>
									<td>原料规格</td>
									<td>单位</td>
									<td>计划数量</td>
									<td>实际消耗数</td>
									<td>领用数</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">直接成本价</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">直接成本金额</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${combItems}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input id="wareId${s.index }" type="hidden" name="itemCombList[${s.index }].wareId" value = "${item.wareId}"/>
							    <input id="wareCode${s.index }" name="itemCombList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td>
								 <input id="wareNm${s.index }" name="itemCombList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
								</td>
								<td>
								 <input id="wareGg${s.index }" name="itemCombList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<td >
									<input id="beUnit${s.index }" type="hidden" name="itemCombList[${s.index }].beUnit" value = "${item.beUnit}"/>
									<input id="unitName${s.index }" name="itemCombList[${s.index }].unitName" readonly="readonly" type="text" class="pcl_i2" value="${item.unitName}" />
								</td>
								<td >
								<input id="planQty${s.index }" readonly="readonly" name="itemCombList[${s.index }].planQty" type="text" class="pcl_i2" value="${item.planQty}" onchange="countRelaCombAmt()"/>
								</td>
								<td >
								<input id="qty${s.index }" name="itemCombList[${s.index }].qty" type="text" class="pcl_i2" onchange="countRelaQty(this)" value="${item.qty}"/>
								</td>
								<td >
									<input id="jyQty${s.index }" name="itemCombList[${s.index }].jyQty" readonly type="text" class="pcl_i2" value="${item.jyQty}"/>
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="price${s.index }" name="itemCombList[${s.index }].price" readonly="readonly" type="text" class="pcl_i2" value="${item.price}" />
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input  id="amt${s.index }" name="itemCombList[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="itemCombList[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>

								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</div>
				 <div title="各产品材料消耗" style="padding:10px;">
				 <div id="tb2" style="padding:5px;height:auto">
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
							<table id="more_list1">
							<thead>
								<tr>
									<td>入库产品</td>
									<td>原料编号</td>
									<td>原料名称</td>
									<td>原料规格</td>
									<td>单位</td>
									<td>计划数量</td>
									<td>实际消耗数</td>
									<td>领用数</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">成本单价</td>
									<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">成本金额</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${stkProduce.itemList}" var="item" varStatus="s">
  								<tr>
  								<td>
									<select  id="relaWareId${s.index }" name="itemList[${s.index }].relaWareId" class="pcl_sel2">
										<c:forEach items="${stkProduce.subList}" var="sub">
											<option value="${sub.wareId}"}>${sub.wareNm}</option>
										</c:forEach>
									</select>
									<script>
										document.getElementById("relaWareId${s.index}").value='${item.relaWareId}';
									</script>
								</td>
								<td style="padding-left: 20px;text-align: left;">
								<input id="wareId${s.index }" type="hidden" name="itemList[${s.index }].wareId" value = "${item.wareId}"/>
							    <input id="wareCode${s.index }" name="itemList[${s.index }].wareCode" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareCode}"/>
								 </td>
								<td>
								 <input id="wareNm${s.index }" name="itemList[${s.index }].wareNm" readonly="readonly" type="text" style="width: 150px" class="pcl_i2" value="${item.wareNm}"/>
								</td>
								<td>
								 <input id="wareGg${s.index }" name="itemList[${s.index }].wareGg" readonly="readonly" type="text" class="pcl_i2" value="${item.wareGg}"/>
								</td>
								<td >
									<input id="beUnit${s.index }" type="hidden" name="itemList[${s.index }].beUnit" value = "${item.beUnit}"/>
									<input id="unitName${s.index }" name="itemList[${s.index }].unitName" readonly="readonly" type="text" class="pcl_i2" value="${item.unitName}" />
								</td>
								<td >
								<input id="planQty${s.index }" readonly="readonly" name="itemList[${s.index}].planQty" type="text" class="pcl_i2" value="${item.planQty}" onchange="countRelaAmt()"/>
								</td>
								<td >
								<input id="qty${s.index }" name="itemList[${s.index }].qty" type="text" class="pcl_i2" value="${item.qty}" onchange="countRelaAmt()"/>
								</td>
								<td >
									<input id="jyQty${s.index }" name="itemList[${s.index }].jyQty" type="text" class="pcl_i2" readonly value="${item.jyQty}"/>
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input id="price${s.index }" name="itemList[${s.index }].price" readonly="readonly" type="text" class="pcl_i2" value="${item.price}" onchange="countRelaAmt()"/>
								</td>
								<td style="display:${(stkProduce.status eq 0 or stkProduce.status eq 1 or stkProduce.status eq 2)?'':'none'}">
								<input  id="amt${s.index }" name="itemList[${s.index }].amt" readonly="readonly" type="text" class="pcl_i2" value="${item.amt}" />
								</td>
								<td style="display:none"><input id="hsNum${s.index }" name="itemList[${s.index }].hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
								<td style="display:none"><input id="unitName${s.index }" name="itemList[${s.index }].unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
								</tr>
 								</c:forEach>
							</tbody>
							</table>
					</div>
				</div>
				</div>

			</div>

		</div>
		 <div id="wareDlg" closed="true" class="easyui-dialog" style="width:800px; height:400px;" title="商品选择" iconCls="icon-edit">
		 	<iframe name="wareDialogfrm" id="wareDialogfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
        </div>
        </form>
	</body>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">

	var isModify = false;
	Array.prototype.remove = function(s) {
		for (var i = 0; i < this.length; i++) {
			if (s == this[i])
				this.splice(i, 1);
		}
	}
	$("#stkId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify = true;
	});
	$("#proId").change(function(){
		var index = this.selectedIndex;
		var this_val = this.options[index].text;
		$("#stkProName").val(this_val);
		$("#proName").val(this_val);
		$(this).siblings('span').text(this_val);
		isModify = true;
	});

	var flag=0;
	function dialogSelectWare(t){
		   flag = t;
		   var  stkId = $("#stkId").val();
			if(stkId == ""){
				alert("请选择仓库!");
				return;
			}
			var url = "<%=basePath %>/manager/stkProduceWareTpl/toSelectProduceWareList";
			document.getElementById("wareDialogfrm").src=url;
	    	/* $('#wareDlg').dialog({
	            title: '商品选择',
	            iconCls:"icon-edit",
	            width: 800,
	            height: 400,
	            modal: true,
	            href: url,
	            onClose: function(){
	            }
	        }); */
	    	$('#wareDlg').dialog('open');
	  }

	function callBackFun(json){
		var size = json.list.length;
		if(size>0){
			for(var i=0;i<size;i++){
				if(flag==1){
					setRelaTabRowData(json.list[i]);
				}else{
				setTabRowData(json.list[i]);
				}
			}
		}
	}
	var rowIndex=1000;
	function setTabRowData(json){
		if(map.containsKey(json.wareId)){
			return;
		}else{
			map.put(json.wareId,json.wareNm);
			var trList = $("#more_list1 #chooselist").children("tr");
			if(trList.length>0){
				  $("select[name$='relaWareId']").append("<option value='"+json.wareId+"'>"+json.wareNm+"</option>");;
			}
		}
		var wareId = json.wareId;
		var wareCode = json.wareCode;
		var wareName = json.wareNm;
		var wareGg = json.wareGg;
		var unitName = json.wareDw;
		var minUnit = json.minUnit;
		var maxUnitCode = json.maxUnitCode;
		var minUnitCode = json.minUnitCode;
		var price  = json.price;
		var hsNum = json.hsNum;
		var beUnit = json.beUnit;
		if(beUnit==minUnitCode){
			unitName = minUnit;
		}
		var sunitFront = json.sunitFront;
		var down = $("#more_list").find("tr").length ;
		down = down-1;
		$("#more_list tbody").append(
				'<tr>'+
					'<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="subList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="subList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="subList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="subList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					// '<td>' +
					// '<select id="beUnit'+rowIndex+'" name="subList['+down+'].beUnit" class="pcl_sel2" onchange="changeUnit(this,'+rowIndex+')">'+
					// '<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					// '<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					// '</select>'
					// + '</td>'+
				    '<td><input name="subList['+down+'].beUnit" type="hidden" value="'+beUnit+'"/><input id="unitName'+rowIndex+'" name="subList['+down+'].unitName" type="text" readonly="readonly"  class="pcl_i2" value="'+unitName+'" /></td>'+
					'<td><input id="qty'+rowIndex+'" name="subList['+down+'].qty" type="text" class="pcl_i2" value="1" onchange="countAmt(),resetStkWareTplList('+wareId+',this)"/></td>'+
					'<td style="display:none"><input id="price'+rowIndex+'"  name="subList['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countAmt()"/></td>'+
					'<td style="display:none"><input id="amt'+rowIndex+'" readonly="readonly" name="subList['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="subList['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
					'<td><a href="javascript:;" onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
			);
		rowIndex++;
		countAmt();
		var len = $("#more_list").find("tr").length ;
		var row = $("#more_list tbody tr").eq(len-2);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		// if(sunitFront=="1"){
		// 	$(row).find("select[name$='beUnit']").val(minUnitCode);
		// 	$(row).find("select[name$='beUnit']").trigger("change");
		// }
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
		getStkWareTplList(wareId);
	}


	function setRelaTabRowData(json){
		var wareId = json.wareId;
		var wareCode = json.wareCode;
		var wareName = json.wareNm;
		var wareGg = json.wareGg;
		var unitName = json.wareDw;
		var minUnit = json.minUnit;
		var maxUnitCode = json.maxUnitCode;
		var minUnitCode = json.minUnitCode;
		var price  = json.price;
		var hsNum = json.hsNum;
		var sunitFront = json.sunitFront;
		var relaWareId = json.relaWareId;
		var beUnit = json.beUnit;
        if(beUnit==minUnitCode){
			unitName = minUnit;
		}
		var qty=1;
		if(relaWareId!=undefined&&relaWareId!=""){
			qty = json.stkQty;
		}
		var jyQty=json.stkQty;

		var down = $("#more_list1").find("tr").length ;
		down = down-1;
		var op = "";
		var k = 0;
	    for(var o in map.keys){
	    	var key = map.keys[o];
	    	 var checked = '';
	    	 if(k==0&&relaWareId==undefined){
	    		 checked = 'selected="selected"';
	    	 }
	    	 if(relaWareId!=undefined&&relaWareId!=""&&key==relaWareId){
	    		 checked = 'selected="selected"';
	    	 }
	    	 if(key==undefined||map.get(key)==undefined){
	    		 continue;
	    	 }
			 op+="<option value="+key+" "+checked+">"+map.get(key)+"</option>";
		}
		$("#more_list1 tbody").append(
				'<tr>'+
				'<td>' +
				'<select id="relaWareId'+rowIndex+'" name="itemList['+down+'].relaWareId" class="pcl_sel2" >'+
				op
				+ '</td>'+
					'<td style="padding-left: 20px;text-align: left;">'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="itemList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="itemList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="itemList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="itemList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					'<td><input name="itemList['+down+'].beUnit" type="hidden" value="'+beUnit+'"/><input id="unitName'+rowIndex+'" name="itemList['+down+'].unitName" type="text" readonly="readonly"  class="pcl_i2" value="'+unitName+'" /></td>'+
					'<td><input id="planQty'+rowIndex+'" readonly="readonly" name="itemList['+down+'].planQty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaAmt()"/></td>'+
					'<td><input id="qty'+rowIndex+'" name="itemList['+down+'].qty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaAmt()"/></td>'+
					'<td><input id="jyQty'+rowIndex+'" name="itemList['+down+'].jyQty" type="text" class="pcl_i2" value="'+jyQty+'" readonly/></td>'+
					'<td style="display:none"><input id="price'+rowIndex+'"  name="itemList['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countRelaAmt()"/></td>'+
					'<td style="display:none"><input id="amt'+rowIndex+'" readonly="readonly" name="itemList['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="itemList['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
				'</tr>'
			);
		rowIndex++;
		countRelaAmt();
		var len = $("#more_list1").find("tr").length ;
		var row = $("#more_list1 tbody tr").eq(len-2);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		// if(sunitFront=="1"){
		// 	$(row).find("select[name$='beUnit']").val(minUnitCode);
		// 	$(row).find("select[name$='beUnit']").trigger("change");
		// }
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
		setCombRelaTabRowData(json);
	}

	/*原料合计计算*/
	function setCombRelaTabRowData(json){
		var wareId = json.wareId;
		var wareCode = json.wareCode;
		var wareName = json.wareNm;
		var wareGg = json.wareGg;
		var unitName = json.wareDw;
		var minUnit = json.minUnit;
		var maxUnitCode = json.maxUnitCode;
		var minUnitCode = json.minUnitCode;
		var price  = json.price;
		var hsNum = json.hsNum;
		var beUnit = json.beUnit;
		if(beUnit==minUnitCode){
			unitName = minUnit;
		}
		var sunitFront = json.sunitFront;
		var relaWareId = json.relaWareId;
		var qty=1;
		if(relaWareId!=undefined&&relaWareId!=""){
			qty = json.stkQty;
		}
		var jyQty=json.stkQty;
		var down = $("#more_list_comb").find("tr").length ;
		down = down-1;
		if(combMap.containsKey(wareId)){
			calCombCount();
			getPickupStockList(wareId);
			return;
		}
		combMap.put(wareId,wareName);
		$("#more_list_comb tbody").append(
				'<tr>'+
					'<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg" class="pcl_ic"/>'+
					'<input type="hidden" id="wareId'+rowIndex+'" name="itemCombList['+down+'].wareId" value = "' + wareId + '"/>'+
					'<input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareCode'+rowIndex+'" name="itemCombList['+down+'].wareCode" value = "' + wareCode + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" style="width: 150px"  id="wareNm'+rowIndex+'" name="itemCombList['+down+'].wareNm" value = "' + wareName + '"/></td>'+
					'<td><input type="text" class="pcl_i2" readonly="readonly" id="wareGg'+rowIndex+'" name="itemCombList['+down+'].wareGg" value = "' + wareGg + '"/></td>'+
					// '<td>' +
					// '<select id="beUnit'+rowIndex+'" name="itemCombList['+down+'].beUnit" class="pcl_sel2" onchange="changeRelaUnit(this,'+rowIndex+')">'+
					// '<option value="'+maxUnitCode+'" checked>'+unitName+'</option>'+
					// '<option value="'+minUnitCode+'">'+minUnit+'</option>'+
					// '</select>'
					// + '</td>'+
				    '<td><input name="itemCombList['+down+'].beUnit" type="hidden" value="'+beUnit+'"/><input id="unitName'+rowIndex+'" name="itemCombList['+down+'].unitName" type="text" readonly="readonly"  class="pcl_i2" value="'+unitName+'" /></td>'+
					'<td><input id="planQty'+rowIndex+'" readonly="readonly" name="itemCombList['+down+'].planQty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaQty(this)"/></td>'+
					'<td><input id="qty'+rowIndex+'" name="itemCombList['+down+'].qty" type="text" class="pcl_i2" value="'+qty+'" onchange="countRelaQty(this)"/></td>'+
					'<td><input id="jyQty'+rowIndex+'" name="itemCombList['+down+'].jyQty" type="text" class="pcl_i2" value="'+jyQty+'" readonly/></td>'+
					'<td style="display:none"><input id="price'+rowIndex+'"  name="itemCombList['+down+'].price" type="text" class="pcl_i2" value="' + price + '" onchange="countRelaQty(this)"/></td>'+
					'<td style="display:none"><input id="amt'+rowIndex+'" readonly="readonly" name="itemCombList['+down+'].amt" type="text" class="pcl_i2" value="1" value="' + price + '"/></td>'+
					'<td style="display:none"><input id="hsNum'+rowIndex+'" name="itemCombList['+down+'].hsNum" type="hidden" class="pcl_i2" value="'+hsNum+'"/></td>'+
					'<td style="display:none"><input id="unitName'+rowIndex+'" name="itemCombList['+down+'].unitName" type="hidden" class="pcl_i2" value="'+unitName+'" /></td>'+
				'</tr>'
			);
		rowIndex++;
		countRelaAmt();
		var len = $("#more_list_comb").find("tr").length ;
		var row = $("#more_list_comb tbody tr").eq(len-2);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 开始***********/
		// if(sunitFront=="1"){
		// 	$(row).find("select[name$='beUnit']").val(minUnitCode);
		// 	$(row).find("select[name$='beUnit']").trigger("change");
		// }
		getPickupStockList(wareId);
		/************如果商品信息中有设置默认选中辅助单位，那么就选中设置选中辅助 结束***********/
	}


	function countAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#more_list #chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var wareId = $(tr).find("input[name$='wareId']").val();
		    var qty = $(tr).find("input[name$='qty']").val();
		    var price = $(tr).find("input[name$='price']").val();
		    if(qty == "")break;
		    $(tr).find("input[name$='amt']").val(numeral(qty*price).format("0.00"));
		    total = total + qty*price;
		    sumQty = sumQty + qty*1;
		    if(wareId == 0)continue;
		}
		$("#totalamt").val(numeral(total).format("0.00"));
		var discount = $("#discount").val();
		var disamt = total - discount;
		$("#disamt").val(numeral(disamt).format("0.00"));
	}

	function countProductAmt(){
		var trList = $("#more_list #chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var qty = $(tr).find("input[name$='qty']").val();
		    var productAmt = $(tr).find("input[name$='productAmt']").val();
		    var orgAmt = $(tr).find("input[name$='orgAmt']").val();
		    if(productAmt==""){
		    	productAmt=0;
		    }
		    if(orgAmt==""){
		    	orgAmt = 0;
		    }
		    var amt = parseFloat(orgAmt)+parseFloat(productAmt)
		    var price = parseFloat(amt)/parseFloat(qty);
		    $(tr).find("input[name$='amt']").val(numeral(amt).format("0.00"));
		    $(tr).find("input[name$='price']").val(numeral(price).format("0.00"));
		}
		isModify = true;
	}

	function countRelaAmt(){
		var total = 0;
		var sumQty = 0;
		var trList = $("#more_list1 #chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var wareId = $(tr).find("input[name$='wareId']").val();
		    var qty = $(tr).find("input[name$='qty']").val();
		    var price = $(tr).find("input[name$='price']").val();
		    if(qty == "")break;
		    $(tr).find("input[name$='amt']").val(numeral(qty*price).format("0.00"));
		    total = total + qty*price;
		    sumQty = sumQty + qty*1;
		    if(wareId == 0)continue;
		}
		isModify = true;
	}
	function changeRelaUnit(o,index){
		var trList = $("#more_list1 #chooselist").children("tr");
		if(index<0){
			return;
		}
		var hsNum = document.getElementById("hsNum"+index).value;
		var bePrice = document.getElementById("price"+index).value;
		var k= o.selectedIndex;
		bePrice = bePrice==''?0:bePrice;
		hsNum = hsNum==''?1:hsNum;
		var tempAmt = 0;
		if(o.value=='B'){//包装单位
			tempAmt = bePrice*hsNum;
			document.getElementById("price"+index).value=tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value= o.options[k].text;
		}
		if(o.value=='S'){//计量单位
			tempAmt = bePrice/hsNum;
			tempAmt = parseFloat(tempAmt);
			document.getElementById("price"+index).value = tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value=o.options[k].text;
		}
		countAmt();
	}
	function changeUnit(o,index){
		var trList = $("#more_list #chooselist").children("tr");
		if(index<0){
			return;
		}
		var hsNum = document.getElementById("hsNum"+index).value;
		var bePrice = document.getElementById("price"+index).value;
		var k= o.selectedIndex;
		bePrice = bePrice==''?0:bePrice;
		hsNum = hsNum==''?1:hsNum;
		var tempAmt = 0;
		if(o.value=='B'){//包装单位
			tempAmt = bePrice*hsNum;
			document.getElementById("price"+index).value=tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value= o.options[k].text;
		}
		if(o.value=='S'){//计量单位
			tempAmt = bePrice/hsNum;
			tempAmt = parseFloat(tempAmt);
			document.getElementById("price"+index).value = tempAmt.toFixed(2);
			document.getElementById("unitName"+index).value=o.options[k].text;
		}
		countAmt();
	}

	function checkWare(wareId){
		var trList = $("#more_list1 #chooselist").children("tr");
		var bool = false;
		if(trList.length>0){
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
				if(rwId==wareId){
					bool = true;
					break;
				}
			}
		}
		return bool;
	}


	function deleteChoose(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			 var wareId = $(lineObj).parents('tr').find("input[name$='wareId']").val();
			 if(map.containsKey(wareId)){
				 map.remove(wareId);
			 }
			var trList = $("#more_list1 #chooselist").children("tr");
			if(trList.length>0){
				for(var i=0;i<trList.length;i++){
					var tdArr = trList.eq(i);
					var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
					if(rwId==wareId){
						$(tdArr).remove();
					}
				}
			    $("select[name$='relaWareId'] option").each(function(){
			    	   if($(this).val() == wareId){
			    	   	 $(this).remove();
			    	   }
			   });
			    resetTabRelaIndex();
			}
			$(lineObj).parents('tr').remove();
			countAmt();
			resetTabIndex();
			delCombCount();
		}
	}
	function deleteChooseRela(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			resetTabRelaIndex();
		}
	}

	function resetTabIndex(){
		var trList = $("#more_list #chooselist").children("tr");
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='id']").attr("name","subList["+i+"].id");
			 $(tdArr).find("input[name$='mastId']").attr("name","subList["+i+"].mastId");
			 $(tdArr).find("input[name$='wareId']").attr("name","subList["+i+"].wareId");
			 $(tdArr).find("input[name$='wareCode']").attr("name","subList["+i+"].wareCode");
			 $(tdArr).find("input[name$='wareNm']").attr("name","subList["+i+"].wareNm");
			 $(tdArr).find("input[name$='wareGg']").attr("name","subList["+i+"].wareGg");
			 $(tdArr).find("input[name$='beUnit']").attr("name","subList["+i+"].beUnit");
			 $(tdArr).find("input[name$='qty']").attr("name","subList["+i+"].qty");
			 $(tdArr).find("input[name$='price']").attr("name","subList["+i+"].price");
			 $(tdArr).find("input[name$='amt']").attr("name","subList["+i+"].amt");
			 $(tdArr).find("input[name$='hsNum']").attr("name","subList["+i+"].hsNum");
			 $(tdArr).find("input[name$='unitName']").attr("name","subList["+i+"].unitName");
			 $(tdArr).find("input[name$='orgPrice']").attr("name","subList["+i+"].orgPrice");
			 $(tdArr).find("input[name$='productAmt']").attr("name","subList["+i+"].productAmt");
			 $(tdArr).find("input[name$='orgAmt']").attr("name","subList["+i+"].orgAmt");

		}
	}

	function resetTabRelaIndex(){
		var trList = $("#more_list1 #chooselist").children("tr");
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='wareId']").attr("name","itemList["+i+"].wareId");
			 $(tdArr).find("input[name$='wareCode']").attr("name","itemList["+i+"].wareCode");
			 $(tdArr).find("input[name$='wareNm']").attr("name","itemList["+i+"].wareNm");
			 $(tdArr).find("input[name$='wareGg']").attr("name","itemList["+i+"].wareGg");
			 $(tdArr).find("input[name$='beUnit']").attr("name","itemList["+i+"].beUnit");
			 $(tdArr).find("input[name$='qty']").attr("name","itemList["+i+"].qty");
			 $(tdArr).find("input[name$='price']").attr("name","itemList["+i+"].price");
			 $(tdArr).find("input[name$='amt']").attr("name","itemList["+i+"].amt");
			 $(tdArr).find("input[name$='hsNum']").attr("name","itemList["+i+"].hsNum");
			 $(tdArr).find("input[name$='unitName']").attr("name","itemList["+i+"].unitName");
			 $(tdArr).find("select[name$='relaWareId']").attr("name","itemList["+i+"].relaWareId");
			 $(tdArr).find("input[name$='planQty']").attr("name","itemList["+i+"].planQty");
		}
	}

	function submitStk(){
		    var status = $("#status").val();
		    if(status==1){
		    	alert("该单据已审批，不能保存!");
		    	return;
		    }
		    if(status==2){
		    	alert("该单据已作废，不能保存!");
		    	return;
		    }
		    var  stkId = $("#stkId").val();
			if(stkId == ""){
				alert("请选择仓库!");
				return false;
			}
			var trList = $("#more_list #chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var wareNm= $(tdArr).find("input[name$='wareNm']").val();
				if(wareNm==""){
					alert("第"+(i+1)+"行请输入商品!");
				}
				var wareId=  $(tdArr).find("input[name$='wareId']").val();
				var bool = checkWare(wareId);
		    	if(!bool){
		    		alert("商品"+wareNm+"未关联原料!不能保存！");
		    		return;
		    	}

				$("select[name$='relaWareId']").each(function(){
				if($(this).val() == wareId){
					var currRow=this.parentNode.parentNode;
					var qty= $(currRow).find("input[name$='qty']").val();
					var itemWareNm= $(currRow).find("input[name$='wareNm']").val();
					if(qty==""||qty=="0"){
						alert("关联原料商品["+itemWareNm+"]，数量必须大于0");
						return;
					}

				}});

		    	if('${stkProduce.ioMark}'=='-1'){
		    		var amt = $(tdArr).find("input[name$='amt']").val();
			    	var totalSubAmt = 0;
			    	 $("select[name$='relaWareId']").each(function(){
				    	   if($(this).val() == wareId){
				    		   var currRow=this.parentNode.parentNode;
				 		 	   var subAmt= $(currRow).find("input[name$='amt']").val();
				 		 	   totalSubAmt = totalSubAmt + parseFloat(subAmt);
				    	   }});
			    	 if(amt!=totalSubAmt){
			    		 alert("商品"+wareNm+"的金额，不等于关联原料的金额");
			    		 return;
			    	 }
		    	}
			}
		if(!confirm('是否确定暂存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
					$("#btnAudit").show();
	        		$("#billId").val(json.id);
	        		$("#billNo").val(json.billNo);
	        		$("#status").val(json.status);
	        		$("#billstatus").val("提交成功");
					isModify = false;
	        	}else{
	        		alert(json.msg);
	        	}
			}
		});
	}

	function audit(){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(status==0){
			alert("单据已审批，不能在审批!");
			return;
		}
		if(status==1){
			alert("单据已收货，不能在审批!");
			return;
		}
		if(status==2){
			alert("单据已作废，不能在审批!");
			return;
		}
		if(isModify){
			$.messager.alert('消息','单据已修改，请先保存!','info');
			return;
		}
		$.messager.confirm('确认', '是否确定审批?',function(r){
			if(r){
				$.ajax({
			        url: "<%=basePath %>/manager/stkProduce/audit",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(0);
			        		$("#billstatus").val("审批成功");
			        		/*
			        		$("#btnSave").hide();
			        		$("#btnAuditSh").show();*/
			        		alert("审批成功");
			        		window.location.href="<%=basePath %>/manager/stkProduce/show?billId="+ billId;
			        	}else{
			        		alert(json.msg);
			        	}
			        }
			    });
			  }
		});
	}
	function auditSh(){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(status==-2){
			alert("单据未审批，不能在入库!");
			return;
		}
		if(status==1){
			alert("单据已收货，不能在入库!");
			return;
		}
		if(status==2){
			alert("单据已作废，不能在入库!");
			return;
		}
		 var produceAmt = 0;
		 $("#more_list #chooselist input[name$='productAmt']").each(function(){
			 	var amt = $(this).val();
			 	if(amt==""){
			 		amt = 0;
			 	}
			 	produceAmt = parseFloat(produceAmt)+parseFloat(amt);
		});
		 var costAmt = $("#costAmt").val();
		 if(costAmt==""){
			 costAmt=0;
		 }
		 if(produceAmt!=costAmt){
			 alert("入库产品中制造费用必须等于"+costAmt);
			 return;
		 }
		$.messager.confirm('确认', '是否确定入库?',function(r){
			if(r){
				document.savefrm.action="<%=basePath %>/manager/stkProduce/auditSh";
				$("#savefrm").form('submit',{
					success:function(data){
						var json = eval("("+data+")");
						if(json.state){
			        		$("#billId").val(json.id);
			        		$("#billNo").val(json.billNo);
			        		$("#status").val(json.status);
			        		$("#billstatus").val("入库成功");
			        		window.location.href="<%=basePath %>/manager/stkProduce/show?_sticky=v1&billId="+ billId;
			        	}else{
			        		alert(json.msg);
			        	}
					}
				});
			  }
		});
	}

	function cancel(){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(status==2){
			alert("单据已作废，不能在审批!");
			return;
		}
		$.messager.confirm('确认', '是否确定作废?',function(r){
			if(r){
				$.ajax({
			        url: "<%=basePath %>/manager/stkProduce/cancel",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(2);
			        		alert(json.msg);
			        		$("#billstatus").val("作废成功");
			        	}else{
							alert(json.msg);
							$("#billstatus").val("作废失败");
			        	}
			        }
			    });
			  }
		});
	}
	function newClick()
    {
    	location.href='<%=basePath %>/manager/stkProduce/add?bizType=${stkProduce.bizType}';
    }
	function print()
    {
    	location.href='<%=basePath %>/manager/stkProduce/print?billId='+'${stkProduce.id}';
    }
	$(function (){
		var billId = $("#billId").val();
		var status = $("#status").val();
		if(billId == 0)
		{
		var myDate = new Date();
		var seperator1 = "-";

	    var month = myDate.getMonth() + 1;
	    var strDate = myDate.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var hour = myDate.getHours();
	    if(hour < 10)hour = '0' + hour;
	    var minute = myDate.getMinutes();
	    if(minute<10)minute = '0' + minute;
		var dateStr = myDate.getFullYear() + seperator1 + month + seperator1 + strDate + " " + hour + ":" + minute;
		$("#inDate").val(dateStr);
		}
		$("#stkId").trigger("change");
		$("#proId").trigger("change");
		isModify=false;
	})


	function getStkWareTplList(relaWareId){
		$.ajax({
	        url: "<%=basePath %>/manager/stkProduceWareTpl/getProduceWareTplList",
	        type: "POST",
	        data:{"relaWareId":relaWareId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        		if(json.list!=undefined){
	        			var size = json.list.length;
	        			for(var i=0;i<size;i++){
	        				var row = json.list[i];
	        				var data = {
	        						wareId:row.wareId,
	        						wareNm:row.wareNm,
	        						wareGg:row.wareGg,
	        						wareCode:row.wareCode,
	        						wareDw:row.wareDw,
	        						minUnit:row.minUnit,
	        						minUnitCode:row.minUnitCode,
	        						maxUnitCode:row.maxUnitCode,
	        						hsNum:row.hsNum,
	        						stkQty:row.stkQty,
	        						price:row.inPrice,
	        						sunitFront:row.sunitFront,
	        						relaWareId:relaWareId,
								    beUnit:row.beUnit
	        				};
	        				setRelaTabRowData(data);
	        			}
	        		}
	        }
	    })
	}

	function resetStkWareTplList(relaWareId,o){
		var qty = o.value;
		if(qty==""){
			qty=0;
		}
		$.ajax({
	        url: "<%=basePath %>/manager/stkProduceWareTpl/getProduceWareTplList",
	        type: "POST",
	        data:{"relaWareId":relaWareId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        		if(json.list!=undefined){
	        			var size = json.list.length;
	        			for(var i=0;i<size;i++){
	        				var row = json.list[i];
	        				var trList = $("#more_list1 #chooselist").children("tr");
	        				if(trList.length>0){
	        					for(var j=0;j<trList.length;j++){//计算原料细项
	        						var tdArr = trList.eq(j);
	        						var wareId =  $(tdArr).find("input[name$='wareId']").val();
	        						var rwId =  $(tdArr).find("select[name$='relaWareId']").val();
	        						if(rwId==relaWareId&&wareId==row.wareId){
	        							var totalQty = parseFloat(qty)*parseFloat(row.stkQty);
	        							$(tdArr).find("input[name$='qty']").val(totalQty.toFixed(2));
	        							$(tdArr).find("input[name$='planQty']").val(totalQty.toFixed(2));
	        						}
	        					}
	        				}
	        			}
	        			countRelaAmt();
	        			calCombCount();
	        		}
	        }
	    })
	}



	/**
		获取物料库存
	**/
	function getPickupStockList(wareId){
		var proId = $("#proId").val();
		$.ajax({
	        url: "<%=basePath %>/manager/stkPickup/getPickupCurrStockList",
	        type: "POST",
	        data:{"wareIds":wareId,"proId":proId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        		if(json!=undefined){
	        			//alert(json.data.qty);
	        				 $("#more_list_comb #chooselist input[name$='wareId']").each(function(){
						    	  if($(this).val() == wareId){
						    		   var currRow=this.parentNode.parentNode;
									  var qty = json.data.qty;
									  var beUnit =	$(currRow).find("input[name$='beUnit']").val();
									  var hsNum = $(currRow).find("input[name$='hsNum']").val();
									  if(beUnit=="S"){
										  qty = parseFloat(qty)*parseFloat(hsNum);
										  qty = parseFloat(qty);
									  }
						    		   // $(currRow).find("input[name$='qty']").val(qty);
						    		   // countRelaQty(this);

									  $(currRow).find("input[name$='jyQty']").val(qty);
									  countRelaQty(this);

						    	   }
						    });

	        			//countRelaQty
	        		}
	        }
	    })
	}

	/**
		通过计算组合产品实际耗材数量，自动计算对应明细耗材的数量；
	**/
	function countRelaQty(o){
		 var combRow = o.parentNode.parentNode;
		 var combWareId = $(combRow).find("input[name$='wareId']").val();
		 var combQty = $(combRow).find("input[name$='qty']").val();
		 var combPlanQty = $(combRow).find("input[name$='planQty']").val();
		var combJyQty = $(combRow).find("input[name$='jyQty']").val();

		 $("#more_list1 #chooselist input[name$='wareId']").each(function(){
	    	   if($(this).val() == combWareId){
	    		   var currRow=this.parentNode.parentNode;
	 		 	  //var itemQty= $(currRow).find("input[name$='qty']").val();
	 		 	   var itemPlanQty= $(currRow).find("input[name$='planQty']").val();
	 		 	   var itemQty = (parseFloat(itemPlanQty)*parseFloat(combQty))/parseFloat(combPlanQty);
	 		 	   $(currRow).find("input[name$='qty']").val(itemQty);
				   $(currRow).find("input[name$='jyQty']").val(combJyQty);
	    	   }
	    });
	}


	/**
		根据原料明细计算原料组合
	**/
	function calCombCount(){
		var trCombList= $("#more_list_comb #chooselist").children("tr");//计算原料合计
		for(var i=0;i<trCombList.length;i++){
			var tdArr = trCombList.eq(i);
			var wareId =  $(tdArr).find("input[name$='wareId']").val();
				var sumQty = 0;
				var sumPlanQty = 0;
				 $("#more_list1 #chooselist input[name$='wareId']").each(function(){
			    	   if($(this).val() == wareId){
			    		   var currRow=this.parentNode.parentNode;
			 		 	   var itemQty= $(currRow).find("input[name$='qty']").val();
			 		 	   var itemPlanQty= $(currRow).find("input[name$='planQty']").val();
			 		 	   sumQty = parseFloat(sumQty)+parseFloat(itemQty);
			 		 	   sumPlanQty = parseFloat(sumPlanQty)+parseFloat(itemPlanQty);

			    	   }
			    });
				$(tdArr).find("input[name$='qty']").val(sumQty);
				$(tdArr).find("input[name$='planQty']").val(sumPlanQty);
		}
	}

	function delCombCount(){
		var trCombList= $("#more_list_comb #chooselist").children("tr");//计算原料合计
		for(var i=0;i<trCombList.length;i++){
			var tdArr = trCombList.eq(i);
			var wareId =  $(tdArr).find("input[name$='wareId']").val();
				var sumQty = 0;
				var sumPlanQty = 0;
				 $("#more_list1 #chooselist input[name$='wareId']").each(function(){
			    	   if($(this).val() == wareId){
			    		   var currRow=this.parentNode.parentNode;
			 		 	   var itemQty= $(currRow).find("input[name$='qty']").val();
			 		 	   var itemPlanQty= $(currRow).find("input[name$='planQty']").val();
			 		 	   sumQty = parseFloat(sumQty)+parseFloat(itemQty);
			 		 	   sumPlanQty = parseFloat(sumPlanQty)+parseFloat(itemPlanQty);
			    	   }
			    });
				$(tdArr).find("input[name$='qty']").val(sumQty);
				$(tdArr).find("input[name$='planQty']").val(sumPlanQty);
		}
		var len = trCombList.length;
		for(var i=(len-1);i>0;i--){
			var tdArr = trCombList.eq(i);
			var planQty = $(tdArr).find("input[name$='planQty']").val();
			var combWareId = $(tdArr).find("input[name$='wareId']").val();
			if(planQty==0){
				//$(tdArr)
				$(tdArr).remove();
				combMap.remove(combWareId);
			}
		}
	}

	/**
	自动加载配置好的产品
**/
function getStkRelaWareTplList(){
	$.ajax({
        url: "<%=basePath %>/manager/stkProduceWareTpl/getProduceRelaWareTplList",
        type: "POST",
        dataType: 'json',
        async : false,
        success: function (json) {
        		if(json.list!=undefined){
        			var size = json.list.length;
        			for(var i=0;i<size;i++){
        				var row = json.list[i];
        				var data = {
        						wareId:row.wareId,
        						wareNm:row.wareNm,
        						wareGg:row.wareGg,
        						wareCode:row.wareCode,
        						wareDw:row.wareDw,
        						minUnit:row.minUnit,
        						minUnitCode:row.minUnitCode,
        						maxUnitCode:row.maxUnitCode,
        						hsNum:row.hsNum,
        						stkQty:1,
        						price:row.inPrice,
        						sunitFront:row.sunitFront
        				};
        				setTabRowData(data);
        			}
        		}else{
        			alert("生产材料标准配置表未设置，将前往配置");
        			parent.closeWin("生产材料标准配置表未设置");
			    	parent.add("生产材料标准配置表未设置",'<%=basePath %>/manager/stkProduceWareTpl/edit');
        		}
        }
    })
}

function queryCost(){
	//window.location.href='${base}/manager/stkrec?billId=' + billId;
	var proId=$("#proId").val();
	document.getElementById("costfrm").src='<%=basePath %>/manager/toFinCostPageForProduce?branchId2='+proId;
	$('#costdlg').dialog('open');
}


function getCostSumForProduce(){
	var proId=$("#proId").val();
	$.ajax({
        url: "<%=basePath %>/manager/getCostSumForProduce?proId="+proId,
        type: "POST",
        dataType: 'json',
        async : false,
        success: function (json) {
        		if(json.state){
        			$("#costAmt").val(json.sumAmt);
        			$("#referCostAmt").val(json.sumAmt);
        		}else{
        			alert("获取费用失败！");
        			$("#costAmt").val(0);
        			$("#referCostAmt").val(0);
        		}
        		calProduceCostAmt();
        }
    })

}

function callBackFunCost(data){
	if(data!=undefined){
		var size = data.list.length;
		for(var i=0;i<size;i++){
			setCostTabRowData(data.list[i]);
		}
	}
	$('#costdlg').dialog('close');
	calProduceCostAmt();
}

/**
 * 按入库的数量的比例分摊制造费用
 */
function calProduceCostAmt(){
		 var costAmt = $("#costAmt").val();
		 var productTotalQty = 0
		 $("#more_list #chooselist input[name$='wareId']").each(function(){
	  		   var currRow=this.parentNode.parentNode;
			 	   var qty= $(currRow).find("input[name$='qty']").val();
			 	  productTotalQty = parseFloat(productTotalQty)+parseFloat(qty);
	    });

		 $("#more_list #chooselist input[name$='wareId']").each(function(){
			   var currRow=this.parentNode.parentNode;
			 	  //var itemQty= $(currRow).find("input[name$='qty']").val();
			 	   var qty= $(currRow).find("input[name$='qty']").val();
			 	   var produceAmt = (parseFloat(costAmt)*parseFloat(qty))/parseFloat(productTotalQty);
			 	   $(currRow).find("input[name$='productAmt']").val(produceAmt);
	});
		 countProductAmt();
}

function getUnAuthWareTplList(){
		$.ajax({
			url: "<%=basePath %>/manager/stkProduceWareTpl/getUnAuthWareTplList",
			type: "get",
			dataType: 'json',
			async : false,
			success: function (json) {
				if(json.state){
					var len = json.rows.length;
					for(var i=0;i<len;i++){
						var data = json.rows[i];
						var relaWareId = data.relaWareId;
						$("#more_list #chooselist input[name$='wareId']").each(function(){
							var currRow=this.parentNode.parentNode;
							if(relaWareId==$(this).val()){
								$(currRow).hide();
							}
						});

						$("#more_list1 #chooselist input[name$='wareId']").each(function(){
								var currRow=this.parentNode.parentNode;
								var rwId= $(currRow).find("input[name$='relaWareId']").val();
								if(rwId==relaWareId){
									$(currRow).hide();
								}
						});

					}
					isModify = false;
				}
			}
		})
	}

if('${stkProduce.id}'!=''){
	getUnAuthWareTplList();
}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>