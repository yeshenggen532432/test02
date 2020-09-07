<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
		<title>pc-发货单详细</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
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
				<p class="pcl_title">发货单-${stkSend.voucherNo}-<c:if test="${stkSend.status eq 2 }"><span style="color: red">作废单</span></c:if><c:if test="${stkSend.status ne 2 }"><span style="color: green">正常单</span></c:if></p>
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<!--  <div class="item" id="btncancel">
							<a href="javascript:cancelProc();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>-->
						<c:if test="${permission:checkUserFieldPdm('stk.stkSend.print')}">
						<div class="item" id="btnprint">
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8a.png"/>
								<p>打印</p>
							</a>
						</div>
						</c:if>
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
									<input type="text" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
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
								<td>发票单号：</td>
								<td>
								<table>
									<tr>
									<td width="180px"><div class="pcl_input_box pcl_w2" ><input type="text" id="csttel"   value="${stkSend.billNo}"/></div></td>
									<td><a href="javascript:;;" onclick="showBill('${stkSend.outId}')">查看</a></td>
									</tr>
								</table>
								</td>
								<td>发货时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="sendTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 120px;" value="${stkSend.sendTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>配送指定：</td>
								<td>
									<table>
									<tr>
										<td width="80px">
											<div class="selbox" style="width: 80px">
											<span id="pszdspan">${stkSend.pszd}</span> 
											 <select name="" class="pcl_sel" id="pszdsel">
												<option value="公司直送">公司直送</option>
												<option value="直供转单二批">直供转单二批</option>
											</select>
										     </div>
									     </td>
										<td>
											<div class="pcl_input_box pcl_w2" id="epCustomerDiv" style="width: 70px;display: none">
											<input type="hidden" id="epCustomerId"  name="epCustomerId" value="${stkSend.epCustomerId }"/>
											<input type="text" id="epCustomerName"  name="epCustomerName" required="required" placeholder="单击选择客户" value="${stkSend.epCustomerName }" readonly="readonly"/>
											</div>
										</td>
									</tr>
								</table>
								</td>
							</tr>
							<tr>
								<td>客户名称：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${stkSend.khNm}</a></div>
									<input type="hidden" id="cstId" value="0"/>
								</td>
								<td>联系电话：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="csttel" value="${stkSend.tel}"/></div></td>
								<td>配送地址：</td>
								<td ><div class="pcl_input_box"><input type="text" id="cstaddress" value="${stkSend.address }"/></div></td>
							</tr>
							<tr>
								<td>出货仓库：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${stkSend.stkName}</a></div>
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
							<c:if test="${stkSend.saleType eq '003'}">
								<tr>
									<td>物流名称：</td>
									<td>
										<div class="pcl_input_box pcl_w2">${stkSend.transportName}</div>
									</td>
									<td>物流单号：</td>
									<td>
										<div class="pcl_input_box pcl_w2">${stkSend.transportCode}</div>
									</td>
									<td></td>
									<td></td>
								</tr>
							</c:if>
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
									<td>产品编号</td>
									<td>产品名称</td>
									<td>产品规格</td>
									<td>销售类型</td>
									<td>单位</td>
									<td style="display: ${permission:checkUserFieldDisplay('stk.stkSend.lookprice')}">单价</td>
									<td>发票数量</td>
									<td>发货数量</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${subList}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/> ${item.wareCode} </td>
								<td>${item.wareNm}<input type="hidden" name="subId" value = "${item.id}"/></td>
								<td>${item.wareGg}</td>
								<td>${item.xsTp}</td>
								<td>${item.unitName}</td>
								<td style="display: ${permission:checkUserFieldDisplay('stk.stkSend.lookprice')}"><input name="edtprice" type="text" class="pcl_i2" value="${item.price}" readonly="readonly"/></td>
								<td><input name="edtqty" type="text" class="pcl_i2" value="${item.qty}" readonly="readonly"/></td>
								<td><input name="edtoutqty" type="text" class="pcl_i2" value="${item.outQty}" readonly="readonly"/></td>
								<td style="display: none">
								<input id="beUnit${s.index}" type="text" value="${item.beUnit}"/>
								<input id="hsNum${s.index}" type="text" value="${item.hsNum}" />
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
						<td><span id="pc_lib_name">供应商</span></td>
						<td>上次拜访：2017-08-04</td>
						<td><span id="pc_lib_mes">小叶：14577889911</span></td>
						<td>福建省厦门市集美区沈海高速</td>
						<td>35.7公里</td>
						<td>林丽萍/综合部</td>
						<td><span class="bule_col">正常</span></td>
					</tr>
					<tr>
						<td><span id="pc_lib_name">供应商</span></td>
						<td>上次拜访：2017-08-04</td>
						<td><span id="pc_lib_mes">小叶：14577889911</span></td>
						<td>福建省厦门市集美区沈海高速</td>
						<td>35.7公里</td>
						<td>林丽萍/综合部</td>
						<td><span class="bule_col">正常</span></td>
					</tr>
					<tr>
						<td><span id="pc_lib_name">供应商</span></td>
						<td>上次拜访：2017-08-04</td>
						<td><span id="pc_lib_mes">小叶：14577889911</span></td>
						<td>福建省厦门市集美区沈海高速</td>
						<td>35.7公里</td>
						<td>林丽萍/综合部</td>
						<td><span class="bule_col">正常</span></td>
					</tr>
					<tr>
						<td><span id="pc_lib_name">供应商</span></td>
						<td>上次拜访：2017-08-04</td>
						<td><span id="pc_lib_mes">小叶：14577889911</span></td>
						<td>福建省厦门市集美区沈海高速</td>
						<td>35.7公里</td>
						<td>林丽萍/综合部</td>
						<td><span class="bule_col">正常</span></td>
					</tr>
					<tr>
						<td><span id="pc_lib_name">供应商</span></td>
						<td>上次拜访：2017-08-04</td>
						<td><span id="pc_lib_mes">小叶：14577889911</span></td>
						<td>福建省厦门市集美区沈海高速</td>
						<td>35.7公里</td>
						<td>林丽萍/综合部</td>
						<td><span class="bule_col">正常</span></td>
					</tr>
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
		//queryvehicle();
		//querydriver();
		function queryvehicle(){
			var path = "queryVehicleList";
			//var token = $("#tmptoken").val();
			//alert(token);
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token11":""},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		
		        		var size = json.list.length;
		        		gstklist = json.list;
		        		var objSelect = document.getElementById("vehsel");
		        		objSelect.options.add(new Option(''),'');
		        		for(var i = 0;i < size; i++)
		        			{
		        				objSelect.options.add( new Option(json.list[i].vehNo,json.list[i].id));
		        				if(i == 0)
		    					{
		    						$("#vehId").val(json.list[i].id);
		    						$("#vehspan").text(json.list[i].vehNo);
		    					}
		        			}
		        		$("#vehId").val(json.list[i].id);
						$("#vehspan").text(json.list[i].vehNo);
		        		
		        	}
		        }
		    });
		}
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

		var gEditState = 0;
		function cancelProc()
		{
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可作废的单据");
					return;
				}
			var billStatus = $("#billstatus").val();
			if(billStatus == "作废")
			{
			  alert("该单据已经作废");
			  return;
			}
		    if(!confirm('确定作废？'))return;
		    var path = "cancelStkOut";
		    
		    $.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":"","billId":billId},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		alert("作废成功");
		        		$("#billstatus").val("作废");
		        		
		        	}
		        	else
		        	{
		        		alert("作废失败");
		        	}
		        	//queryData();
		        }
		    });
		}

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
			    var wareId = tdArr.eq(0).find("input").val();
			    
			    var qty = tdArr.eq(6).find("input").val();
			    
			    var price = tdArr.eq(4).find("input").val();
			    if(qty == "")break;
			    total = total + qty*price;
			    if(wareId == 0)continue;
			}
			
			$("#totalamt").val(total);
			var discount = $("#discount").val();
			var disamt = total - discount;
			$("#disamt").val(disamt);
			
		}
		function querydriver(){
			var path = "queryDriverList";
			//var token = $("#tmptoken").val();
			//alert(token);
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token11":""},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		
		        		var size = json.list.length;
		        		gstklist = json.list;
		        		var objSelect = document.getElementById("driversel");
		        		objSelect.options.add(new Option(''),'');
		        		for(var i = 0;i < size; i++)
		        			{
		        				objSelect.options.add( new Option(json.list[i].driverName,json.list[i].id));
		        				if(i == 0)
		    					{
		    						$("#driverId").val(json.list[i].id);
		    						$("#driverspan").text(json.list[i].vehNo);
		    					}
		        				
		        			}
						
		        		
		        	}
		        }
		    });
		}
		
		
		/**
			查看销售发票单信息
		*/
		function showBill(billId){
			parent.closeWin('销售发票信息' + billId);
	    	parent.add('销售发票信息' + billId,'manager/showstkout?dataTp=1&billId=' + billId);
		}
		 if("${stkSend.pszd}"=="直供转单二批"){
			 $("#epCustomerDiv").show();
		 }
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>