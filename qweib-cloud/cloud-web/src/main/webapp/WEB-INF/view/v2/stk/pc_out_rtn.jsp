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
		<title>pc-进销存</title>
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
						<div class="item" id="btnaudit">
							<a href="javascript:auditProc();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4a.png"/>
								<p>确认退货</p>
							</a>
						</div>
						<!--  <div class="item" id="btncancel">
							<a href="javascript:cancelProc();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>-->
						<div class="item" id="btnprint" style="display: none">
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8a.png"/>
								<p>打印</p>
							</a>
						</div>
						 
						<div class="pcl_right_edi" style="width: 400px;">
							<div class="pcl_right_edi_w">
								<div>
								    <input type="text" id="voucherNo"   style="color:green;width:160px;font-size: 14px" readonly="readonly" value="${voucherNo}"/>
									<input type="text" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
									&nbsp;&nbsp;
									<input type="text" id="paystatus"   style="color:red;width:60px" readonly="readonly" value="${paystatus}"/>
								</div>
							</div>
							
						</div>
						
					</div>
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
				<input  type="hidden" name="stkId" id="stkName" value="${stkName}"/>
				<input  type="hidden" name="orderId" id="orderId" value="${orderId}"/>
				<input  type="hidden" name="pszd" id="pszd" value="${pszd}"/>
				<input  type="hidden" name="vehId" id="vehId" value="${vehId}"/>
				<input  type="hidden" name="driverId" id="driverId" value="${driverId}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据单号：</td>
								<td>
								<table>
									<tr>
									<td width="180px"><div class="pcl_input_box pcl_w2" ><input type="text" id="csttel"   value="${billNo}"/></div></td>
									<td><a href="javascript:;;" onclick="showBill('${billId}')">查看</a></td>
									</tr>
								</table>
								</td>
								<td><font color="red">收库时间：</font></td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="sendTime"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${sendTime}"  readonly="readonly"/>
								</div>
								</td>
								<td>配送指定：</td>
								<td>
									<div class="selbox" >
										<span>${pszd}</span>
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
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${khNm}</a></div>
									<input type="hidden" id="cstId" value="0"/>
								</td>
								<td>配送地址：</td>
								<td ><div class="pcl_input_box"><input type="text" id="cstaddress" value="${address }"/></div></td>
								<td>联系电话：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="csttel" value="${tel}"/></div></td>
								
							</tr>
							<tr style="display: none" >
								<td colspan="4" class="pcl_stl">
									<span>总金额：</span><input type="text" class="pcl_sinput" id="totalamt" readonly="readonly" value="${totalamt}"/><span>整单折扣：</span><input type="text" class="pcl_sinput" id="discount" onchange="countAmt()" value="${discount}"/><span>成交金额：</span><input type="text" class="pcl_sinput" id="disamt" readonly="readonly" value="${disamt}"/>
								</td>
									<td>销售订单：</td>
								<td>
									<div class="selbox">
										<span>${orderNo}</span>
										<select name="" class="pcl_sel" id="ordersel">
										</select>
									</div>
								</td>
								<td>单据时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="outDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${outTime}"  readonly="readonly"/>
								</div>
								</td>
							</tr>
							<tr>
								<td>收货仓库：</td>
								<td>
								<div class="selbox" id="stklist">
										<span id = "stkNamespan">${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
										</select>
									</div>
								</td>
									<td><font color="red">运输车辆：</font></td>
								<td>
									<div class="selbox" id="vehlist">
										<span id="vehspan">${vehNo}</span>
										<select name="" class="pcl_sel" id = "vehsel">
										</select>
									</div>
								</td>
							<td><font color="red">司机：</font></td>
								<td>
									<div class="selbox" id="driverlist">
										<span id="driverspan">${driverName}</span>
										<select name="" class="pcl_sel" id = "driversel">
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<td valign="top"><font color="red">备注：</font></td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks" >${remarks}</textarea>
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
									<td><input type="checkbox" id="checkAllBox" onclick="chkbox(this)" name="checkAllBox"/><a href="javascript:;;" onclick="deleteChoose('');" class="pcl_del">删除</a></td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" varStatus="s">
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
								<td>
									<input type="checkbox" name="chkbox"/><a href="javascript:;;" onclick="deleteChoose(this);" class="pcl_del">删除</a>
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
		queryvehicle();
		querydriver();
		querystorage();
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
		function auditProc()
		{
			if(gEditState == 1)return;
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可发货的单据");
					return;
				}
			var billStatus = $("#status").val();
			if(billStatus == 2)
				{
				  alert("该单据已经作废 ");
				  return;
				}
			var flag = 0;
			var stkId = $("#stkId").val();
			if(stkId == "")
				{
				alert("请选择收货仓库 ");
				  return;
				}
			var sendTime = $("#sendTime").val();
			var wareList = new Array();
			var trList = $("#chooselist").children("tr");
			for (var i=0;i<trList.length;i++) {
			    var tdArr = trList.eq(i).find("td");
			    var wareId = tdArr.eq(1).find("input").val();
			    var subId = tdArr.eq(2).find("input").val();
			    var xsTp =tdArr.eq(4).text();
			    var qty = tdArr.eq(7).find("input").val();
			    var unit = tdArr.eq(5).text();
			    var price = tdArr.eq(6).find("input").val();
			    var outQty = tdArr.eq(9).find("input").val();
			    //var beUnit = $("#beUnit"+i).val();
			    //var hsNum = $("#hsNum"+i).val();
			    var beUnit = trList.eq(i).find("input[name='beUnit']").val();
			    var hsNum = trList.eq(i).find("input[name='hsNum']").val();
			    if(qty == "")break;
			    if(wareId == 0)continue;
			    if(outQty>0)flag = 1;
			    var subObj = {
			    		id:subId,
						wareId: wareId,
						xsTp: xsTp,
						qty: qty,
						rtnQty:outQty,
						unitName: unit,
						price: price,
						beUnit:beUnit,
						hsNum:hsNum					
				};
			    wareList.push(subObj);
			    
			    
			}
			if(flag == 0)
			{
			alert("请输入退货数量");
			return;
			}
			if(wareList.length == 0)
				{
					alert("请选择商品");
					return;
				}
			if(stkId == 0)
				{
					alert("请选择仓库");
					return;
				}
			if(cstId == 0)
				{
				  alert("请选择客户");
				  return;
				}
		    if(!confirm('确定退货？'))return;
		    var path = "addStkOutRtn";
		    var vehId = $("#vehId").val();
		    var driverId = $("#driverId").val();
		    var remarks = $("#remarks").val();
		    $.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":"","billId":billId,"stkId":stkId,"sendTimeStr":sendTime,"vehId":vehId,"driverId":driverId,"remarks":remarks,"wareStr":JSON.stringify(wareList)},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		alert("退货成功");
		        		if(json.isfinish == 1)
			        		$("#billstatus").val("已退货");
		        		if($("#btnaudit").hasClass('on')){
							$("#btnaudit").removeClass('on');
							
						}
		        		$("#btnaudit").attr("disabled","disabled");
		        		$("#voucherNo").val(json.voucherNo);
		        		gEditState = 1;
		        	}
		        	else
		        	{
		        		alert("发货失败:" + json.msg);
		        	}
		        }
		    });
		    
		}
				
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
			window.location.href='showstkoutprint?billId=' + billId;
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
		        	}
		        }
		    });
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
		function querystorage(){
			var path = "queryBaseStorage";
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
		        		var objSelect = document.getElementById("stksel");
		        		objSelect.options.add(new Option(''),'');
		        		for(var i = 0;i < size; i++)
		        			{
		        				objSelect.options.add( new Option(json.list[i].stkName,json.list[i].id));
		        				if(i == 0)
		    					{
		        					var billId = $("#billId").val();
		        					
		    						if(billId == 0)
		    							{
		    						$("#stkId").val(json.list[i].id);
		    						$("#stkNamespan").text(json.list[i].stkName);
		    							}
		    					}
		        			}
		        	}
		        }
		    });
		}
		function chkbox(obj){
			var chkbox = document.getElementsByName("chkbox");
			for(var i=0;i<chkbox.length;i++){
				chkbox[i].checked=obj.checked;
			}
		}
		function deleteChoose(lineObj)
		{
			$.messager.confirm('删除', '确定删除？',function(r){
				if(r){
					if(lineObj!=""){
						$(lineObj).parents('tr').remove();
						countAmt();
						var len = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
				        for (var i = 1; i < len; i++) {
				         $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
				        }
					   }else{
						var chkbox = document.getElementsByName("chkbox");
						var len = chkbox.length;
						 len = len-1;
						for(var i=len;i>=0;i--){
							if(chkbox[i].checked){
								var o = chkbox[i];
								$(o).parents('tr').remove();
							}
						} 
						var l = $("#more_list").find("tr").length;  //#tb为Table的id  获取所有行
				        for (var i = 1; i < l; i++) {
				         $("#more_list tr").eq(i).children("td").eq(0).html(i);  //给每行的第一列重写赋值
				        }
					}
				}});
		}
		function showBill(billId){
			parent.closeWin('销售单据信息' + billId);
	    	parent.add('销售单据信息' + billId,'manager/showstkout?dataTp=1&billId=' + billId);
		}
	</script>
</html>