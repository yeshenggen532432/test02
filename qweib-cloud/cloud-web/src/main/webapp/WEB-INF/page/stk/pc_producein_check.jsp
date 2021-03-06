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
		<title>收货确认</title>
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
			<input  type="hidden" name="auditFlag" id="auditFlag" value="${auditFlag}"/>
			<div class="pcl_lib_out">
				<p class="pcl_title">采购收货单-${billNo}</p>
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<c:if test="${permission:checkUserFieldPdm('stk.stkCome.save')}">
						<div class="item" id="btnaudit">
							<a href="javascript:submitCheck();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4a.png"/>
								<p>确认收货</p>
							</a>
						</div>
						</c:if>
						<!--  <div class="item" id="btncancel">
							<a href="javascript:cancelProc();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>-->
						
						<c:if test="${permission:checkUserFieldPdm('stk.stkCome.print')}">
						<div class="item" id="btnprint">
							<a href="javascript:printClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon8a.png"/>
								<p>打印</p>
							</a>
						</div>
						</c:if>
						<div class="pcl_right_edi">
							<div class="pcl_right_edi_w">
								<div>
									<input type="hidden" id="billstatus"   style="color:red;width:60px" readonly="readonly" value="${billstatus}"/>
									&nbsp;&nbsp;
									<!--  <input type="text" id="paystatus"   style="color:red;width:60px" readonly="readonly" value="${paystatus}"/>-->
								</div>
							</div>
							
						</div>
						
					</div>
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<input  type="hidden" name="billId" id="billId" value="${billId}"/>
				<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>
				<input  type="hidden" name="stkId" id="stkName" value="${stkName}"/>
				<input  type="hidden" name="status" id="status" value="${status}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>供应商：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${proName}</a></div>
									<input type="hidden" id="proId" value="0"/>
								</td>
								<td>发票单号:</td>
								<td>
								<table>
									<tr>
									<td width="180px"><div class="pcl_input_box pcl_w2" ><input name="text" id="billNo"  style="width: 120px;" value="${billNo}"  readonly="readonly"/></div></td>
									<td><a href="javascript:;;" style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}" onclick="showBill('${billId}')">查看</a></td>
									</tr>
								</table>
								</td>
								<td></td>
								<td>
								</td>
							</tr>
							<tr>
								<td>收货仓库：</td>
								<td>
									
									<div class="selbox" id="stklist">
										<span>${stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
											
										</select>
									</div>
								</td>
								<td>收货时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${inTime}"  readonly="readonly"/>
								</div>
								</td>
								<td></td>
								<td>
								</td>
							</tr>
							
							<tr style="display: none">
								<td>总 金 额：</td>
								<td ><div class="pcl_input_box"><input type="text" id="totalamt" readonly="readonly" value="${totalamt}"/></div></td>
								<td>整单折扣：</td>
								<td><div class="pcl_input_box pcl_w2"><input type="text" id="discount" value="${discount}" onchange="countAmt()"/></div></td>
								<td>成交金额：</td>
								<td ><div class="pcl_input_box"><input type="text" id="disamt" readonly="readonly" value="${disamt}"/></div></td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks" value="${remarks}"></textarea>
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
									<td >产品编号</td>
									<td >产品名称</td>
									<td >产品规格</td>
									<td >单位</td>
									<td style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}">单价</td>
									<td >生产日期</td>
									<td >发票数量</td>
									<td >已收数量</td>
									<td >本次收货</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/>${item.wareCode}</td>
								<td>${item.wareNm}<input type="hidden" name="subId" value = "${item.id}"/></td>
								<td>${item.wareGg}</td>
								<td>${item.unitName}</td>
								<td style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}"><input name="edtprice" type="text" class="pcl_i2" value="${item.price}" readonly="readonly"/></td>
								<td><input name="productDate" type="text" class="pcl_i2" style="width: 100px" value="${item.productDate}" readonly="readonly"/></td>
								<td><input name="edtqty" type="text" class="pcl_i2" value="${item.qty}" readonly="readonly"/></td>
								<td><input name="edtinQty" type="text" class="pcl_i2" value="${item.inQty}"  readonly="readonly" /></td>
								<td><input name="edtinQty1" type="text" class="pcl_i2" value="${item.inQty1}" style="color:red"/></td>
								<!--  <td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>-->
								<td style="display: none">
								<input id="beUnit${s.index}" type="text" value="${item.beUnit}"/>
								<input id="hsNum${s.index}" type="text" value="${item.hsNum}" />
								<input id="inTypeCode${s.index}" type="text" value="${item.inTypeCode}" />
								<input id="inTypeName${s.index}" type="text" value="${item.inTypeName}" />
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
						<input type="text" placeholder="搜索" id="querytext"/>
					</div>
					<input type="button" class="cp_btn" value="查询" onclick="queryClick()"/>
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
		/*$(".pcl_sel").change(function(){
			var index = this.selectedIndex;
		       
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});*/
		var editstatus = 0;
		
		statuschg();
		$("#stksel").change(function(){
			var index = this.selectedIndex;
		    var stkId = this.options[index].value;
		    $("#stkId").val(stkId);
		    
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
		
		function statuschg()
		{
			var billStatus = $("#status").val();
			
			if(billStatus != 2)
			{
				if(!$("#btncancel").hasClass('on')){
					$("#btncancel").addClass('on');
				}
				if(!$("#btnaudit").hasClass('on')){
					$("#btnaudit").addClass('on');
				}
			}		
			else
			{
				if($("#btncancel").hasClass('on')){
					$("#btncancel").removeClass('on');
				}
				if($("#btnaudit").hasClass('on')){
					$("#btnaudit").removeClass('on');
				}
			}
			
			if(!$("#btnprint").hasClass('on')){
				$("#btnprint").addClass('on');
			}
			//$("#remarks").attr("readonly","readonly");
			$("#discount").attr("readonly","readonly");
			//$("#inDate").attr("disabled",true);
			
			$("#stksel").attr("disabled","disabled");
			
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
		function submitCheck()
		{
		if(gEditState == 1)return;
		var billId = $("#billId").val();
		if(billId == 0)
			{
				alert("没有可收货的单据");
				return;
			}
		var status = $("#status").val();
		
		if(status == 1)
			{
			  alert("该单已经完成收货");
			  return;
			}
		var inDate = $("#inDate").val();
		var remarks = $("#remarks").val();
		var wareList = new Array();
		var trList = $("#chooselist").children("tr");
		var flag = 0;
		for (var i=0;i<trList.length;i++) {
		    var tdArr = trList.eq(i).find("td");
		    var wareId = tdArr.eq(0).find("input").val();
		    var subId = tdArr.eq(1).find("input").val();
		    //alert(xsTp);
		    var qty = tdArr.eq(6).find("input").val();
		    var productDate = tdArr.eq(5).find("input").val();
		    var inQty = tdArr.eq(8).find("input").val();
		    var unit = tdArr.eq(3).text();
		    var price = tdArr.eq(4).find("input").val();
		    var beUnit = $("#beUnit"+i).val();
		    var hsNum = $("#hsNum"+i).val();
		    var inTypeCode = $("#inTypeCode"+i).val();
		    var inTypeName = $("#inTypeName"+i).val();
		    if(qty == "")break;
		    if(wareId == 0)continue;
		    if(inQty> 0)flag = 1;
		    var subObj = {
		    		id:subId,
					wareId: wareId,				
					qty: qty,
					inQty:inQty,
					unitName: unit,
					price: price,
					beUnit:beUnit,
					hsNum:hsNum,
					productDate:productDate,
					inTypeCode:inTypeCode,
					inTypeName:inTypeName
			};
		    wareList.push(subObj);
		}
		if(flag == 0)
			{
			alert("请输入收货数量");
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
		if(proId == 0)
			{
			  alert("请选择供应商");
			  return;
			}
		 if(!confirm('是否确定收货？'))return;
		var path = "auditProc";
		var token = $("#tmptoken").val();
		//alert(JSON.stringify(wareList));
		$.ajax({
	        url: path,
	        type: "POST",
	        data : {"token":token,"billId":billId,"inDate":inDate,"remarks":remarks,"wareStr":JSON.stringify(wareList)},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        	if(json.state){
	        		alert("确认收货成功");
	        		if(json.isfinish == 1)
	        		$("#billstatus").val("已收货");
	        		if($("#btnaudit").hasClass('on')){
						$("#btnaudit").removeClass('on');
					}
	        		$("#btnaudit").attr("disabled","disabled");
	        		gEditState = 1;
	        	}
	        	else
	        	{
	        		alert("确认收化失败:" + json.msg);
	        		//alert( JSON.stringify(json));
	        	}
	        }
	    });
		}

		function countAmt(){
			var total = 0;
			
			
			var trList = $("#chooselist").children("tr");
			
			for (var i=0;i<trList.length;i++) {
			    var tdArr = trList.eq(i).find("td");
			    var wareId = tdArr.eq(0).find("input").val();
			    
			    var qty = tdArr.eq(6).find("input").val();
			    
			    var price = tdArr.eq(3).find("input").val();
			    if(qty == "")break;
			    total = total + qty*price;
			    if(wareId == 0)continue;
			}
			
			$("#totalamt").val(total);
			var discount = $("#discount").val();
			var disamt = total - discount;
			$("#disamt").val(disamt);
			
		}

		function cancelProc()
		{
			
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可作废的单据");
					return;
				}
		    if(!confirm('确定作废？'))return;
		    var path = "cancelProc";
		    
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
			if(editstatus != 0)
				{
				  alert("请先保存");
				  return;
				}
			
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可打印的单据");
					return ;
				}
			window.location.href='showstkinprint?billId=' + billId;
		}
	</script>
</html>