<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
		<title>退货入库</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" href="<%=basePath %>/resource/select/css/main.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/pcxsthin.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/easyui.css">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/easyui/icon.css">
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';

</script>
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
		
		<div class="center">
			
			<div class="pcl_lib_out">
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item" id="btnnew">
							操作人：${reauditDesc} &nbsp;操作时间：${relaTime}
						</div>
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
								  <input type="text" id="billNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${billNo}"/>
								  <input type="text" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
                                    <c:if test="${not empty verList}">
                                        <a onclick="show('billVersion')">查看版本</a>
                                    </c:if>
								</div>
							</div>
							
						</div>
						
					</div>
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				<input  type="hidden" name="orderId" id="orderId" value="${orderId}"/>
				<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
				<input  type="hidden" name="stkName" id="stkName" value="${stkName}"/>
				<input  type="hidden" name="proId" id="proId" value="${proId}"/>
				<input  type="hidden" name="proType" id="proType" value="${proType}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>退货单位：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib" style="padding-right: 30px;">${proName}</a></div>
								</td>
								<td>退货时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${inTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>入库仓库：</td>
								<td>
									<div class="selbox" id="stklist">
										<span id = "stkNamespan">${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
											
										</select>
									</div>
								</td>
							</tr>
							<tr>
							<td >业   务   员：</td>
								<td >
								<div class="pcl_chose_peo" >
										<a href="javascript:;" id="empNm" style="padding-right: 30px;">${empNm}</a>
										<input type="hidden" name="empId" id="empId" value="${empId }"/>
								</div>
								</td>
								<td>车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;辆：</td>
								<td>
									<div class="selbox">
									<span id="vehNospan">${vehNo}</span>
									<tag:select name="vehId" id="vehId" tclass="pcl_sel"  value="${vehId }" headerKey="" headerValue="" tableName="stk_vehicle" displayKey="id" displayValue="veh_no"/>
									</div>
								</td>
								<td>司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;机：</td>
								<td>
									<div class="selbox">
									<span id="driverNamespan">${driverName}</span>
									<tag:select name="driverId" id="driverId" tclass="pcl_sel"  value="${driverId }" headerKey="" headerValue="" tableName="stk_driver" displayKey="id" displayValue="driver_name"/>
									</div>
								</td>
							</tr>
							<tr>
								<td>合计金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="totalamt" readonly="readonly" value="${totalamt}"/></div></td>
								<td>单据金额：</td>
								<td ><div class="pcl_input_box pcl_w2"><input type="text" id="disamt" readonly="readonly" value="${disamt}"/></div></td>
								<td>订&nbsp;单&nbsp;号：</td>
								<td><div class="pcl_input_box pcl_w2"><input name="text" id="orderNo" value="${orderNo}"  readonly="readonly"/></div></td>
								<td style="display:none">整单折扣：</td>
								<td style="display:none"><div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${discount}" onchange="countAmt()"/></div></td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks">${remarks}</textarea>
									</div>
								</td>
							</tr>
							
						</tbody>
					</table>
				</div>
				<div class="pcl_ttbox1 clearfix">
					<div class="pcl_lfbox1">
						<table id="more_list">
							<thead>
								<tr>
									<td>序号</td>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td>退货数量</td>
									<td>退货单价</td>
									<td>退货金额</td>
									<td>生产日期</td>
									<td><a class="easyui-linkbutton" iconCls="icon-add" plain="true"
										   href="javascript:addTabRow(1);">增行</a></td>
								</tr>
							</thead>
							<tbody id="chooselist">
							<c:forEach items="${warelist}" var="item" varStatus="s">
								<tr>
									<td>${s.index+1 }</td>
									<td style="padding-left: 20px;text-align: left;" onkeydown="gjr_toNextRow(this,'edtqty')">
										<input type="hidden" name="wareId" value = "${item.wareId}"/>
										<input type="text" class="pcl_i2" value="${item.wareCode}" readonly="true"/>
									<td onkeydown="gjr_toNextRow(this,'edtqty')">
										<tag:autocompleter name="wareNm" id="wareNm${s.index }" value="${item.wareNm}"
														   tclass="pcl_i2" onclick="wareAutoClick(this)"
														   placeholder="输入商品名称、商品代码、商品条码"
														   onkeydown="gjr_forAuto_toNextCell(this,'edtqty')" width="200px"
														   onblur="checkWareExists(this)" ></tag:autocompleter>
									</td>
									<td onkeydown="gjr_toNextRow(this,'edtprice')"><input type="text" class="pcl_i2"
																						  value="${item.wareGg}"
																						  style="width: 80px;" readonly="true"
																						  id="wareGg${s.index}" name="wareGg"/></td>
									<td>
										<select id="beUnit${s.index }" name="beUnit" class="pcl_sel2" onchange="changeUnit(this,${s.index })">
											<option value="${item.maxUnitCode}" ${(item.maxUnitCode eq item.beUnit)?'selected=selected':''}>${item.wareDw}</option>
											<option value="${item.minUnitCode}" ${(item.minUnitCode eq item.beUnit)?'selected=selected':''}>${item.minUnit}</option>
										</select>
									</td>
									<td onkeydown="gjr_toNextRow(this,'edtqty')"><input id="edtqty${s.index}"  name="edtqty" type="text"  onkeydown="gjr_toNextCell(this,'edtprice')" class="pcl_i2" value="${item.qty}" onchange="countAmt()"/></td>
									<td  onkeydown="gjr_toNextRow(this,'edtprice')"><input id="edtprice${s.index}" name="edtprice" type="text" onkeydown="gjr_toNextCell(this,'productDate')" class="pcl_i2" value="${item.price}" onchange="countAmt()"/></td>
									<td ><input name="amt" type="text" class="pcl_i2" value="${item.amt}" onchange="countPrice()"/></td>
									<td style="display:none"><input id="hsNum${s.index }" name="hsNum" type="hidden" class="pcl_i2" value="${item.hsNum}"/></td>
									<td style="display:none"><input id="unitName${s.index }" name="unitName" type="hidden" class="pcl_i2" value="${item.unitName}" /></td>
									<td onkeydown="gjr_toNextRow(this,'wareNm','1','gjrRowOperFun')"><input name="productDate" type="text" class="pcl_i2" style="width: 90px;"  readonly="readonly" value="${item.productDate}" onClick="WdatePicker({skin:'whyGreen',dateFmt:'yyyy-MM-dd'});"/></td>
									<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
							</c:forEach>
							</tbody>
							<tfoot>
							<tr  align="center">
								<td>合计:</td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td id="edtSumQty" >0</td>
								<td style="display: ${permission:checkUserFieldDisplay('stk.stkIn.lookprice')}"></td>
								<td id="edtSumAmt">0.00</td>
								<td></td>
								<td></td>
							</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">

		function countSum(){
			var sumQty = 0;
			var sumAmt = 0;
			$("#more_list #chooselist input[name='edtqty']").each(function(){
				sumQty +=parseFloat($(this).val());
			});
			$("#more_list #chooselist input[name='amt']").each(function(){
				sumAmt +=parseFloat($(this).val());
			});
			$("#edtSumQty").html(parseFloat(sumQty.toFixed(2)));
			$("#edtSumAmt").html(parseFloat(sumAmt.toFixed(2)));
		}

        if(${billId}!=0){
			countSum();
		}


	</script>

	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>