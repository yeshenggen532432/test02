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
		<title>采购退货-退货信息</title>
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
				<p class="pcl_title">采购退货出货单-${come.voucherNo}</p>
				<div class="pcl_menu_box">
					
				</div>
				
				<!--<p class="odd_num">单号：</p>-->
				<div class="pcl_fm">
					<table>
						<tbody>
						
						    <tr>
								<td>退货对象：</td>
								<td>
									<div class="pcl_chose_peo"><a href="javascript:;" id="pc_lib">${come.proName}</a></div>
									<input type="hidden" id="proId" value="0"/>
								</td>
								<td>退货单号:</td>
								<td>
								<table>
									<tr>
									<td width="180px"><div class="pcl_input_box pcl_w2" ><input name="text" id="billNo"  style="width: 120px;" value="${come.billNo}"  readonly="readonly"/></div></td>
									<td><a href="javascript:;;" style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}" onclick="showBill('${come.inId}')">查看</a></td>
									</tr>
								</table>
								</td>
								<td></td>
								<td>
								</td>
							</tr>
							<tr>
								<td>退货仓库：</td>
								<td>
									<div class="selbox" id="stklist">
										<span>${come.stkName}</span>
										<select name="" class="pcl_sel" id = "stksel">
										</select>
									</div>
								</td>
								<td>发货时间：</td>
								<td>
								<div class="pcl_input_box pcl_w2">
									<input name="text" id="inDate"  onClick="WdatePicker({skin:'whyGreen',dateFmt: 'yyyy-MM-dd HH:mm'});" style="width: 100px;" value="${come.comeTime}"  readonly="readonly"/>
								</div>
								</td>
								<td></td>
								<td>
								</td>
							</tr>
							<tr>
								<td valign="top">备注：</td>
								<td colspan="5">
									<div class="pcl_txr">
										<textarea name="" id="remarks">${come.remarks}</textarea>
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
									<td>产品名称</td>
									<td>产品规格</td>
									<td>单位</td>
									<td style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}">单价</td>
									<td>生产日期</td>
									<td>退货数量</td>
									<td>本次退货</td>
									<td></td>
								</tr>
							</thead>
							<tbody id="chooselist">
								<c:forEach items="${warelist}" var="item" varStatus="s">
								
  								<tr>
								<td style="padding-left: 20px;text-align: left;"><img src="<%=basePath %>/resource/stkstyle/img/icon19.jpg"class="pcl_ic"/>
								<input type="hidden" name="wareId" value = "${item.wareId}"/> ${item.wareCode} </td>
								<td>${item.wareNm}<input type="hidden" name="subId" value = "${item.id}"/></td>
								<td>${item.wareGg}</td>
								<td>${item.unitName}</td>
								<td style="display:${permission:checkUserFieldDisplay('stk.stkCome.lookprice')}"><input name="edtprice" type="text" class="pcl_i2" value="${item.price}" /></td>
								<td><input name="productDate" type="text" class="pcl_i2" style="width: 100px" value="${item.productDate}" readonly="readonly"/></td>
								<td><input name="edtqty" readonly="readonly" type="text" class="pcl_i2" value="${item.qty*(-1)}" /></td>
								<td><input name="edtinQty" readonly="readonly" type="text" class="pcl_i2" value="${item.inQty*(-1)}" /></td>
								<td style="display: none">
								<input id="beUnit${s.index}" type="text" value="${item.beUnit}"/>
								</td>
								<td ></td>
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
						<input type="text" placeholder="搜索"/>
					</div>
					<input type="button" class="cp_btn" value="查询"/>
				</div>
				<table id="customerlist">
					
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
		statuschg();
		$("#stksel").change(function(){
			var index = this.selectedIndex;
		    var stkId = this.options[index].value;
		    $("#stkId").val(stkId);
		    
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		
		$("#intypesel").change(function(){
			var index = this.selectedIndex;
		    var selObj = this.options[index].value;
		    //$("#pszd").val(selObj);
		    //alert(selObj);
			var this_val = this.options[index].text;
			$(this).siblings('span').text(this_val);
		});
		function statuschg()
		{
			var billStatus = "${status}";
			
			if(billStatus == 0)
			{
				
				if(!$("#btnaudit").hasClass('on')){
					$("#btnaudit").addClass('on');
				}
			
			}
			if(billStatus != 2)
			{
				if(!$("#btncancel").hasClass('on')){
					$("#btncancel").addClass('on');
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
			var billStatus = $("#billstatus").val();
			if(billStatus == "作废")
			{
			  alert("该单据已经作废");
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
			var billStatus = $("#billstatus").val();
			
			var billId = $("#billId").val();
			if(billId == 0)
				{
					alert("没有可打印的单据");
					return ;
				}
			window.location.href='showstkinprint?billId=' + billId;
		}
		/*
		查看采购退货发票单信息
		*/
		function showBill(billId){
			parent.closeWin('采购退货信息' + billId);
	    	parent.add('采购退货信息' + billId,'manager/showstkin?dataTp=1&billId=' + billId);
		}
	</script>
	<%@include file="/WEB-INF/page/include/handleFile.jsp"%>
</html>