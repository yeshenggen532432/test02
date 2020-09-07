<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
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
		<title>货币资金初始化</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script type="text/javascript" src="<%=basePath %>/resource/jquery-1.8.0.min.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<script type="text/javascript" src="<%=basePath %>resource/WdatePicker.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/default/easyui.css">
		<script type="text/javascript" src="<%=basePath %>/resource/jquery.easyui.min.js"></script>
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/themes/icon.css">
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
		<form action="<%=basePath %>/manager/finInitMoney/update" name="savefrm" id="savefrm" method="post">
		<div class="center">
			
			<div class="pcl_lib_out">
				<p class="pcl_title">初始化资金导入-${billNo}</p>
				<div class="pcl_menu_box">
					<div class="menu_btn">
						<div class="item on" id="btnnew">
							<a href="javascript:newClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon1a.png"/>
								<p>新建</p>
							</a>
						</div>
						<!--  <div class="item" id="btnedit">
							<a href="javascript:editClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon2a.png"/>
								<p>编辑</p>
							</a>
						</div>
						<div class="item" id="btndelete">
							<a href="javascript:deleteClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon3a.png"/>
								<p>删除</p>
							</a>
						</div>
						  <div class="item" id="btnaudit">
							<a href="javascript:auditClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon4a.png"/>
								<p>审核</p>
							</a>
						</div>
						<div class="item" id="btncancel">
							<a href="javascript:cancelClick();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon5a.png"/>
								<p>作废</p>
							</a>
						</div>-->
						<div class="item" id="btnsave">
							<a href="javascript:submitStk();">
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6.png"/>
								<img src="<%=basePath %>/resource/stkstyle/img/nicon6a.png"/>
								<p>保存</p>
							</a>
						</div>
						<div class="pcl_right_edi">
							<div class="pcl_right_edi_w">
								<div>
									<c:if test="${model.status eq 0 }">
										<input type="text" id="billstatus"   style="color:red;width:80px" readonly="readonly" value="未审批"/>
									</c:if>
								    <c:if test="${model.status eq 1 }">
										<input type="text" id="billstatus"   style="color:red;width:80px" readonly="readonly" value="已审批"/>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</div>
				
				<input  type="hidden" name="id" id="billId" value="${model.id}"/>
				<input  type="hidden" name="status" id="status" value="${model.status}"/>
				<input  type="hidden" name="operator" id="operator" value="${model.operator}"/>
				<input  type="hidden" name="ioMark" id="ioMark" value="${model.ioMark}"/>
				<div class="pcl_fm">
					<table>
						<tbody>
							<tr>
								<td>单据号：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
								<input name="billNo" id="billNo" style="width: 140px;" value="${model.billNo}"  readonly="readonly"/>
								</div>
								</td>
								<td>初始化日期：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="billDate" id="billDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${model.billDate}"  readonly="readonly"/>
								</div>
								</td>
								<td>合计金额：</td>
								<td ><div class="pcl_input_box"><input type="text" id="totalamt" name="amt" readonly="readonly" value="${model.amt}"/></div></td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="3">
									<div class="pcl_txr">
										<textarea name="remarks" id="remarks" >${model.remarks}</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="pcl_ttbox clearfix">
					<div class="pcl_lfbox">
						<table id="more_list">
							<thead>
								<tr>
								<td>序号</td>
								<td>账号</td>
								<td>金额</td>
								<td><a href="javascript:;;" onclick="addTabRowData()">增行</td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${model.list}" var="item" varStatus="s">
  								<tr>
								<td style="padding-left: 20px;text-align: left;">
									${s.index+1 }
								</td>
								<td>
									<tag:select name="list[${s.index}].accId" id="accId" tableName="fin_account" value="${item.accId }"  headerKey="" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/>
								</td>
								<td><input name="list[${s.index}].amt" type="text" class="pcl_i2" value="${item.amt}" onchange="countAmt()"/></td>
								<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>
								</tr>
 								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		</form>
		<div style="display: none" id="copyAccIdDiv">
			<tag:select name="accId" id="accId" tableName="fin_account" headerKey="" headerValue="--请选择--" displayKey="id" displayValue="acc_name"/> 
		</div>
	</body>
	
	
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	var rowIndex=1000;
	var isModify = false;
	function addTabRowData(){
		var len = $("#chooselist").find("tr").length ;
		len = len+1;
		var copyAccIdDivHtml = document.getElementById("copyAccIdDiv").innerHTML;
		$("#more_list tbody").append(
				'<tr>'+
					'<td style="padding-left: 20px;text-align: left;">'+len+
					'</td>'+
					'<td>'+copyAccIdDivHtml+'</td>'+
					'<td><input type="text" class="pcl_i2" onchange="countAmt();"   style="width: 150px"  id="amt'+rowIndex+'" name="list['+(len-1)+'].amt"/></td>'+
					'<td><a href="javascript:;"onclick="deleteChoose(this);" class="pcl_del">删除</a></td>'+
				'</tr>'
			);
		var row = $("#chooselist tr").eq(len-1);
		/**********************商品行中下拉选中商品开始****************************/
		 $(row).find("select[name$='accId']").attr("name","list["+(len-1)+"].accId");
		rowIndex++;
		countAmt();
	}
	function countAmt(){
		var total = 0;
		var trList = $("#chooselist").children("tr");
		for (var i=0;i<trList.length;i++) {
		    var tr = trList.eq(i)
		    var amt = $(tr).find("input[name$='amt']").val();
		    if(amt==""){
		    	amt= 0;
		    }
		    total = parseFloat(total) + parseFloat(amt);
		}
		$("#totalamt").val(numeral(total).format("0.00"));
	}
	
	
	function deleteChoose(lineObj)
	{
		var status = $("#status").val();
		if(status > 0)return;
		if(confirm('确定删除？')){
			//alert(lineObj.innerHTML);
			$(lineObj).parents('tr').remove();
			//countAmt();
			resetTabIndex();
		}
	}
	
	function resetTabIndex(){
		var trList = $("#chooselist").children("tr");
		if(index<0){
			return;
		}
		for(var i=0;i<trList.length;i++){
			var tdArr = trList.eq(i);
			 $(tdArr).find("input[name$='amt']").attr("name","list["+i+"].amt");
			 $(tdArr).find("select[name$='accId']").attr("name","list["+i+"].accId");
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
		   
			var trList = $("#chooselist").children("tr");
			if(trList.length==0){
				alert("请添加明细!");
				return false;
			}
			for(var i=0;i<trList.length;i++){
				var tdArr = trList.eq(i);
				var accId=  $(tdArr).find("select[name$='accId']").val();
				if(accId==""){
					alert("第"+(i+1)+"行,请选择账号!");
					return;
				}
				var amt=  $(tdArr).find("input[name$='amt']").val();
				if(amt==""){
					alert("第"+(i+1)+"行,请输入金额!");
					return;
				}
			}
		if(!confirm('保存后将不能修改，是否确定保存？'))return;
		$("#savefrm").form('submit',{
			success:function(data){
				var json = eval("("+data+")");
				if(json.state){
	        		$("#billId").val(json.id);
	        		$("#billNo").val(json.billNo);
	        		$("#status").val(json.status);
	        		$("#billstatus").val("提交成功");
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
			        url: "<%=basePath %>/manager/finInitMoney/audit",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(1);
			        		$("#billstatus").val("审批成功");
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
			        url: "<%=basePath %>/manager/finInitMoney/cancel",
			        type: "POST",
			        data : {"billId":billId},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		$("#status").val(2);
			        		$("#billstatus").val("作废成功");
			        	}else{
			        		$("#billstatus").val(json.msg);
			        	}
			        }
			    });
			  }
		});
	}
	function newClick()
 {
 	location.href='<%=basePath %>/manager/finInitMoney/add';
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
		$("#billDate").val(dateStr);
		}
	})
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>