<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html style="font-size: 50px;">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="format-detection" content="telephone=no" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no" />
<title>采购入库返利信息</title>
<meta name="description" content="">
<meta name="keywords" content="">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/stkstyle/css/style.css" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/stkstyle/css/lCalendar.css" />
<script type="text/javascript"
	src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
<script src="<%=basePath%>/resource/stkstyle/js/numeral.min.js"
	type="text/javascript" charset="utf-8"></script>
<script type="text/javascript"
	src="<%=basePath%>resource/WdatePicker.js"></script>
<script type="text/javascript"
	src="<%=basePath%>/resource/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/easyui/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/easyui/icon.css">
</head>
<body>

	<style type="text/css">
.menu_btn .item p {
	font-size: 12px;
}

.menu_btn .item img:last-of-type {
	display: none;
}

.menu_btn .item a {
	color: #00a6fb;
}

.menu_btn .item.on img:first-child {
	display: none;
}

.menu_btn .item.on img:last-of-type {
	display: inline;
}

.menu_btn .item.on a {
	color: #333;
}
</style>
	<form action="<%=basePath %>/manager/stkRebateIn/save" name="savefrm" id="savefrm" method="post">
	<div class="center">
		<div class="pcl_lib_out">
			<div class="pcl_menu_box">
					<div class="menu_btn">
						<c:if test="${rebateIn.status eq -2 }">
						<div class="item" id="btnsave" >
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>保存</p>
							</a>
						</div>
						<div class="item" id="btnsave" >
							<a href="javascript:audit();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>审批</p>
							</a>
						</div>
						</c:if>
						<c:if test="${rebateIn.status ne 2 }">
							<div class="item" id="btncancel" >
							<a href="javascript:cancel();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>
						</c:if>
					</div>
				</div>
			<div class="pcl_fm">
				<input type="hidden" id="id" name="id" value="${rebateIn.id }"/>
				<input type="hidden" id="billId" name="billId" value="${rebateIn.id }"/>
				<input type="hidden" id="status" name="status" value="${rebateIn.status }"/>
				<input type="hidden" id="inDate" name="inDate" value="${rebateIn.inDate }"/>
				<input type="hidden" id="proName" name="proName" value="${rebateIn.proName }"/>
				<input type="hidden" id="proId" name="proId" value="${rebateIn.proId }"/>
				<input type="hidden" id="inType" name="inType" value="${rebateIn.inType }"/>
				<table style="margin-top: 10px">
					<tbody>
						<tr>
							<td style="text-align: center;">单据号：</td>
							<td>
								<div class="pcl_input_box pcl_w2">
									${rebateIn.billNo} 
								</div>	
								<a href="javascript:;;" onclick="showRelateBill(${rebateIn.relateId})" >查看采购单</a>
							</td>
							<td style="text-align: center;">单据时间：</td>
							<td>
							<div class="pcl_input_box pcl_w2">
								${rebateIn.inDate}
							</div>
							</td>
							<td style="text-align: center;">收款状态：</td>
							<td>
							<div class="pcl_input_box pcl_w2" id="billstatus">
								${rebateIn.payStatus}
							</div>
							</td>
						</tr>
						<tr>
							<td style="text-align: center;">往来单位：</td>
							<td>
								<div class="pcl_input_box pcl_w2">
									${rebateIn.proName}
								</div>	
							</td>
							<td style="text-align: center;">返利金额：</td>
							<td>
							<div class="pcl_input_box pcl_w2" id="totalAmtDiv">
							${rebateIn.totalAmt}
							</div>
							<input type="hidden" name="totalAmt" id="totalAmt" value="${rebateIn.totalAmt}"/>
							</td>
							<td style="text-align: center;">单据状态</td>
							<td id="auditStatus">
								<c:if test="${rebateIn.status eq -2 }">
									暂存
								</c:if>
								<c:if test="${rebateIn.status eq 1 }">
									已审批
								</c:if>
								<c:if test="${rebateIn.status eq 2 }">
									已作废
								</c:if>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="tb" style="padding: 5px; height: auto">
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
									<td>采购数量</td>
									<td>单件返利</td>
									<td>返利金额</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${rebateIn.list}" var="item" varStatus="s">
									<tr>
										<td>${s.index+1 }</td>
										<td style="padding-left: 20px; text-align: left;">
											<input type="hidden" name="list[${s.index }].wareId" value="${item.wareId }"/>
											<input type="text" readonly="readonly" name="list[${s.index }].wareCode" value="${item.wareCode }"/>
										</td>
										<td>
											<input type="text" readonly="readonly" name="list[${s.index }].wareNm" value="${item.wareNm }"/>
										</td>
										<td>
											<input type="text" readonly="readonly" name="list[${s.index }].wareGg" value="${item.wareGg }"/>
										</td>
										<td>
										<input type="text" readonly="readonly" name="list[${s.index }].unitName" value="${item.unitName }"/>
										<input type="hidden" readonly="readonly" name="list[${s.index }].beUnit" value="${item.beUnit }"/>
										</td>
										<td>
										<input type="text" readonly="readonly"  name="list[${s.index }].qty" value="${item.qty }"/>
										</td>
										<td>
										<input type="text"  readonly="readonly" name="list[${s.index }].rebatePrice"  onclick="gjr_CellClick(this)"  value="${item.rebatePrice }" onchange="countAmt()"/>
										<input type="hidden"  name="list[${s.index }].price" value="${item.price }" />
										<input type="hidden"  name="list[${s.index }].inTypeCode" value="${item.inTypeCode }" />
										<input type="hidden"  name="list[${s.index }].inTypeName" value="${item.inTypeName }" />
										</td>
										<td>
										<input type="text" readonly="readonly" name="list[${s.index }].amt" value="${item.amt }"/>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	</form>	
</html>
<script>
function countAmt(){
	var total = 0;
	var trList = $("#chooselist").children("tr");
	for (var i=0;i<trList.length;i++) {
	    var tr = trList.eq(i)
	    var wareId = $(tr).find("input[name$='wareId']").val();
	    var qty = $(tr).find("input[name$='qty']").val();
	    var price = $(tr).find("input[name$='rebatePrice']").val();
	    if(qty == "")break;
	    $(tr).find("input[name$='amt']").val(numeral(qty*price).format("0.00"));
	    total = total + qty*price;
	}
	$("#totalAmtDiv").html(numeral(total).format("0,0.00"));
	$("#totalAmt").val(total);
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
   
	var trList = $("#chooselist").children("tr");
	if(trList.length==0){
		alert("请添加明细!");
		return false;
	}
if(!confirm('保存后将不能修改，是否确定保存？'))return;
	$("#savefrm").form('submit',{
	success:function(data){
		var json = eval("("+data+")");
		if(json.state){
    		$("#auditStatus").html("提交成功");
    	}else{
    		alert(json.msg);
    	}
	}
});
}

function audit(){
var billId = $("#billId").val();
var status = $("#status").val();
if(status==1){
	alert("单据已审批，不能在审批!");
	return;
}
if(status==2){
	alert("单据已作废，不能在审批!");
	return;
}
$.messager.confirm('确认', '是否确定审批?',function(r){
	if(r){
		$.ajax({
	        url: "<%=basePath %>/manager/stkRebateIn/audit",
	        type: "POST",
	        data : {"billId":billId},
	        dataType: 'json',
	        async : false,
	        success: function (json) {
	        	if(json.state){
	        		$("#status").val(1);
	        		$("#auditStatus").html("审批成功");
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
		alert("单据已作废!");
		return;
	}
	$.messager.confirm('确认', '是否确定作废?',function(r){
		if(r){
			$.ajax({
		        url: "<%=basePath %>/manager/stkRebateIn/cancel",
		        type: "POST",
		        data : {"billId":billId},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		$("#status").val(2);
		        		$("#auditStatus").html("作废成功");
		        	}else{
		        		alert(json.msg);
		        	}
		        }
		    });
		  }
	});
	}

function showRelateBill(realteId){
	parent.closeWin('采购发票单' + realteId);
	parent.add('采购发票单' + realteId,'manager/showstkin?billId=' + realteId);
}
	
function gjr_CellClick(o){
	o.select();
}
</script>