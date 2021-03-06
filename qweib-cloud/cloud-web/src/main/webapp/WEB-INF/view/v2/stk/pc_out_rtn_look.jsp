<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
		<title>pc-退货查看</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<!-- <script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script> -->
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>/resource/login/js/jquery-ui.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
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
		<div class="center">
			<div class="pcl_lib_out">
			<p class="pcl_title">退货单-${stkSend.voucherNo}-<c:if test="${stkSend.status eq 2 }"><span style="color: red">作废单</span></c:if><c:if test="${stkSend.status ne 2 }"><span style="color: green">正常单</span></c:if></p>
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<!--  <div class="item" id="btncancel">
							<a href="javascript:cancelProc();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>-->
						<div class="item" id="btnprint" >
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8a.png"/>
								<p>打印</p>
							</a>
						</div>
						 
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
									<input type="hidden" id="billId" value="${stkSend.id }"/>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据单号：</td>
								<td>
								<table>
									<tr>
									<td width="180px"><div class="pcl_input_box pcl_w2" ><input type="text" id="csttel"   value="${stkSend.billNo}"/></div></td>
									<td><a href="javascript:;;" onclick="showBill('${stkSend.outId}')">查看</a></td>
									</tr>
								</table>
								</td>
								<td><font color="red">收库时间：</font></td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="sendTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${stkSend.sendTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>配送指定：</td>
								<td>
									<div class="selbox" >
										<span>${stkSend.pszd}</span>
										<select name="" class="pcl_sel" id="pszdsel">
										<option value=""></option>
											<option value="公司直送">公司直送</option>
											<option value="直供转单二批">直供转单二批</option>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td>客户名称：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${stkSend.khNm}</a></div>
									<input type="hidden" id="cstId" value="0"/>
								</td>
								<td>配送地址：</td>
								<td ><div class="pcl_input_box"><input type="text" id="cstaddress" value="${stkSend.address }"/></div></td>
								<td>联系电话：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="csttel" value="${stkSend.tel}"/></div></td>
								
							</tr>
							
							<tr>
								<td>收货仓库：</td>
								<td>
								<div class="selbox" id="stklist">
										<span id = "stkNamespan">${stkSend.stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
										</select>
									</div>
								</td>
									<td><font color="red">运输车辆：</font></td>
								<td>
									<div class="selbox" id="vehlist">
										<span id="vehspan">${stkSend.vehNo}</span>
										<select name="" class="pcl_sel" id = "vehsel">
										</select>
									</div>
								</td>
							<td><font color="red">司机：</font></td>
								<td>
									<div class="selbox" id="driverlist">
										<span id="driverspan">${stkSend.driverName}</span>
										<select name="" class="pcl_sel" id = "driversel">
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td valign="top"><font color="red">备注：</font></td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks" >${stkSend.remarks}</textarea>
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
									<td width="30px">序号</td>
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>销售类型</td>
									<td>单位</td>
									<td>单价</td>
									<td>单据数量</td>
									<td>已发数量</td>
									<td>本次退货</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${subList}" var="item" varStatus="s">
  								<tr>
  								<td>${s.index+1 }</td>
								<td style="padding-left: 20px;text-align: left;">
								<input type="hidden" name="wareId" value = "${item.wareId}"/> ${item.wareCode} </td>
								<td>${item.wareNm}<input type="hidden" name="subId" value = "${item.id}"/></td>
								<td>${item.wareGg}
								<td>${item.xsTp}
								
								</td>
								<td>${item.unitName}</td>
								<td><input name="edtprice" type="text" class="pcl_i2" value="${item.price}" readonly="readonly"/></td>
								<td><input name="edtqty" type="text" class="pcl_i2" value="${item.qty}" readonly="readonly"/></td>
								<td><input name="edtoutqty" type="text" class="pcl_i2" value="${item.outQty}" readonly="readonly"/></td>
								<td><input name="edtoutqty" type="text" class="pcl_i2" value="0"  style="color:red"/></td>
								<td style="display: none">
									<input id="beUnit${s.index}" name="beUnit" type="text" value="${item.beUnit}"/>
									<input id="hsNum${s.index}"  name="hsNum"  type="text" value="${item.hsNum}" />
								</td>
								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
		</div>
		
		<div class="chose_people pcl_chose_people" style="">
			<div class="mask"></div>
			<div class="cp_list">
				<div class="cp_src">
					<div class="cp_src_box">
						<img src="<%=basePath %>/resource/stkstyle/img/src_icon2.jpg"/>
						<input type="text" placeholder="搜索" id="searchcst" value=""/>
					</div>
					<input type="button" class="cp_btn" value="查询" onclick="searchCustomer();"/>
				</div>
				<table id="customerlist">
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</table>
			</div>
		</div>
		
	</body>
	
	
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		statuschg();
		$("#stksel").change(function(){
			var index = this.selectedIndex;
		    var stkId = this.options[index].value;
		    $("#stkId").val(stkId);
		    //alert(stkId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#vehsel").change(function(){
			var index = this.selectedIndex;
		    var vehId = this.options[index].value;
		    $("#vehId").val(vehId);
		    //alert(stkId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#driversel").change(function(){
			var index = this.selectedIndex;
		    var driverId = this.options[index].value;
		    $("#driverId").val(driverId);
		    //alert(stkId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#pszdsel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
		    $("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#ordersel").change(function(){
			var index = this.selectedIndex;
		    var id = this.options[index].value;
		    $("#orderId").val(id);
		    //alert(stkId);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
			queryOrderDetail();
		});
		function statuschg()
		{
			
				var billStatus = "${status}";
				if(billStatus != 2)
				{
				if(!$("#btnaudit").hasClass('on')){
					$("#btnaudit").addClass('on');
				}
				if(!$("#btncancel").hasClass('on')){
					$("#btncancel").addClass('on');
				}
				}
			else
				{
				if($("#btnaudit").hasClass('on')){
					$("#btnaudit").removeClass('on');
				}
				if($("#btncancel").hasClass('on')){
					$("#btncancel").removeClass('on');
				}
				}
				if(!$("#btnprint").hasClass('on')){
					$("#btnprint").addClass('on');
				}
				//$("#remarks").attr("readonly","readonly");
				$("#discount").attr("readonly","readonly");
				$("#outDate").attr("disabled",true);
				$("#pszdsel").attr("disabled","disabled");
				//$("#stksel").attr("disabled","disabled");
				$("#ordersel").attr("disabled","disabled");
				$("#csttel").attr("readonly","readonly");
				$("#cstaddress").attr("readonly","readonly");
				var edits = document.getElementsByName("edtprice");
				for(var i = 0;i<edits.length;i++)
					{
					$(edits[i]).attr("readonly","readonly");
					}
				var qtyedits =  document.getElementsByName("edtqty");
				for(var i = 0;i<qtyedits.length;i++)
				{
				$(qtyedits[i]).attr("readonly","readonly");
				}
		}

		var gEditState = 0;
		function printClick()
		{
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可打印的单据");
					return ;
				}
			window.location.href='showstksendprint?billId=' + billId;
		}
		function countAmt(){
			var total = 0;
			var trList = $("#chooselist").children("tr");
			for (var i=0;i<trList.length;i++) {
			    var tdArr = trList.eq(i).find("td");
			    var wareId = tdArr.eq(1).find("input").val();
			    var qty = tdArr.eq(7).find("input").val();
			    var price = tdArr.eq(5).find("input").val();
			    if(qty == "")break;
			    total = total + qty*price;
			    if(wareId == 0)continue;
			}
			$("#totalamt").val(total);
			var discount = $("#discount").val();
			var disamt = total - discount;
			$("#disamt").val(disamt);
		}
		
		function showBill(billId){
			parent.closeWin('销售单据信息' + billId);
	    	parent.add('销售单据信息' + billId,'manager/showstkout?dataTp=1&billId=' + billId);
		}
	</script>
</html>