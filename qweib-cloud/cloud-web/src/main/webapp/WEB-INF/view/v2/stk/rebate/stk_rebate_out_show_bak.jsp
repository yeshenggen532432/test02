<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="format-detection" content="telephone=no" />
<meta HTTP-EQUIV="pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<meta HTTP-EQUIV="expires" CONTENT="0">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no" />
<title>销售出库返利</title>
<link rel="stylesheet"
	href="<%=basePath%>/resource/select/css/main.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/stkstyle/css/style.css" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/resource/stkstyle/css/lCalendar.css" />
<script type="text/javascript"
	src="<%=basePath%>/resource/jquery-1.8.0.min.js"></script>
<script type="text/javascript"
	src="<%=basePath%>/resource/login/js/jquery-ui.min.js"></script>
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
<style>
tr {
	cursor: pointer;
}

.newColor {
	background-color: skyblue
}

::selection {
	background: yellow;
	color: #555;
}

::-moz-selection {
	background: yellow;
	color: #555;
}

::-webkit-selection {
	background: yellow;
	color: #555;
}

.tip-wrap {
	position: absolute;
	display: none;
}

.tip-arr-a, .tip-arr-b {
	position: absolute;
	width: 0;
	height: 0;
	line-height: 0;
	border-style: dashed;
	border-color: transparent;
}
</style>
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
<form action="<%=basePath %>/manager/stkRebateOut/save" name="savefrm" id="savefrm" method="post">
	<div class="center">
	<div class="pcl_lib_out">
	
			<div class="pcl_menu_box">
					<div class="menu_btn">
						<c:if test="${rebateOut.status eq -2 }">
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
						<c:if test="${rebateOut.status ne 2 }">
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
		<input type="hidden" id="id" name="id" value="${rebateOut.id }"/>
				<input type="hidden" id="billId" name="billId" value="${rebateOut.id }"/>
				<input type="hidden" id="status" name="status" value="${rebateOut.status }"/>
				<input type="hidden" id="recAmt" name="recAmt" value="${rebateOut.recAmt }"/>
		<table style="margin-top: 10px">
			<tbody>
				<tr>
					<td style="text-align: center;">单据号：</td>
					<td>
						<div class="pcl_input_box pcl_w2">
							${rebateOut.billNo} 
						</div><a href="javascript:;;" onclick="showRelateBill(${rebateOut.relateId})">查看销售单</a>
					</td>
					<td width="80px" style="text-align: center;">单据日期：</td>
					<td>
						<div class="pcl_input_box pcl_w2">${rebateOut.outDate}</div>
					</td>
					<td style="text-align: center;">付款状态：</td>
					<td>
						<div class="pcl_input_box pcl_w2" id="billstatus">${rebateOut.recStatus}</div>
					</td>
				</tr>
				<tr>
					<td style="text-align: center;">往来单位：</td>
					<td>
						<div class="pcl_input_box pcl_w2">
							${rebateOut.khNm}
						</div>
					</td>
					<td style="text-align: center;">返利金额：</td>
					<td>
						<div class="pcl_input_box pcl_w2" id="totalAmtDiv">${rebateOut.totalAmt}</div>
						<input type="hidden" name="totalAmt" id="totalAmt" value="${rebateOut.totalAmt}"/>
					</td>
					<td style="text-align: center;">单据状态</td>
					<td id="auditStatus">
						<c:if test="${rebateOut.status eq -2 }">
							暂存
						</c:if>
						<c:if test="${rebateOut.status eq 1 }">
							已审批
						</c:if>
						<c:if test="${rebateOut.status eq 2 }">
							已作废
						</c:if>
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
						<td class="index">序号</td>
						<td style="width: 130px">产品编号</td>
						<td>产品名称</td>
						<td>产品规格</td>
						<td style="display: none">销售类型</td>
						<td>单位</td>
						<td>销售数量</td>
						<td>返利单价</td>
						<td>返利金额</td>
					</tr>
				</thead>
				<tbody id="chooselist">
					<c:forEach items="${rebateOut.list}" var="item" varStatus="s">
						<tr>
							<td class="index">${s.index+1 }</td>
							<td>
							<input type="hidden" name="list[${s.index }].wareId" value="${item.wareId }"/>
							<input type="text" readonly="readonly" name="list[${s.index }].wareCode" value="${item.wareCode }"/>
							</td>
							<td><input type="text" readonly="readonly" name="list[${s.index }].wareNm" value="${item.wareNm }"/></td>
							<td><input type="text" readonly="readonly" name="list[${s.index }].wareGg" value="${item.wareGg }"/></td>
							<td style="display: none">
							<input type="hidden" readonly="readonly" name="list[${s.index }].xsTp" value="${item.xsTp }"/>
							</td>
							<td>
								<input type="text" readonly="readonly" name="list[${s.index }].unitName" value="${item.unitName }"/>
								<input type="hidden" readonly="readonly" name="list[${s.index }].beUnit" value="${item.beUnit }"/>
							</td>
							<td><input type="text" readonly="readonly" name="list[${s.index }].qty" value="${item.qty }"/></td>
							<td><input type="text"   name="list[${s.index }].rebatePrice" value="${item.rebatePrice }" onclick="gjr_CellClick(this)" onchange="countAmt()"/>
							<input type="hidden"  name="list[${s.index }].price" value="${item.price }" />
							</td>
							<td><input type="text" readonly="readonly" name="list[${s.index }].amt" value="${item.amt }"/></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</div>
	</div>
</form>	
</body>
</html>
<script type="text/javascript">
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
    		$("#billId").val(json.id);
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
	        url: "<%=basePath %>/manager/stkRebateOut/audit",
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
		        url: "<%=basePath %>/manager/stkRebateOut/cancel",
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
	parent.closeWin('销售单' + realteId);
	parent.add('销售单' + realteId,'manager/showstkout?billId=' + realteId);
}
	
function gjr_CellClick(o){
	o.select();
}
</script>