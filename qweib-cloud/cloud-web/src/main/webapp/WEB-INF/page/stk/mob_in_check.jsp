<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta name="format-detection" content="telephone=no" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, user-scalable=no"/>
		<title>出库</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>
<script type="text/javascript">
var basePath = '<%=basePath %>';

</script>
	<body class="bg1">
		
		<header class="fixed_top">
		<a href="stkinMng?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>确认收货</h1>
		</header>
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="proId" id="proId" value="${proId}"/>  
		<input  type="hidden" name="stkId" id="stkId" value="${stkId}"/>  
		<input  type="hidden" name="orderId" id="orderId" value="0"/>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
		<input  type="hidden" name="opeType" id="opeType" value="${opeType}"/>
		<div class="from_tb">
			<table>
				<tr>
					<td width="25%">供应商</td>
					<td><a href="javascript:;" style="display: inline-block;width: 90%;" class="color_999" id="lib_supplier">${proName}</a></td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">出货仓库</td>
					<td>
						<a href="javascript:;" class="color_999" id="warehouse">${stkName}</a>
					</td>
				</tr>
				
				<tr class="ftb_hd">
					<td width="25%">收货时间</td>
					<td>
						<input id="demo1" type="text" readonly="readonly" name="input_date" id="outTime" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" value="${inTime}" />
					</td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">备注</td>
					<td><input type="text" placeholder="请点击输入" id="remarks" value="${remarks}"/></td>
				</tr>
				
			</table>
		</div>
		
		<div class="interval"></div>
		
		<div class="library_total">
			<div class="tbox">
				<p class="tl1">合计</p>
				<div class="tbbb">
					<table id="more_list">
						<thead>
							<tr>
								<td>品项</td>
								
								<td>数量</td>
								<td>单位</td>
								<td>已收</td>
								<td>本次收货</td>
								
							</tr>
						</thead>
						<tbody id = "subList">
						<c:forEach items="${warelist}" var="item" >
						<tr>
						<td><a href="javascript:;" class="beer">${item.wareNm}</a><input  type="hidden" name="wareId"  value="${item.wareId}"/></td>
						
						<td>${item.qty}<input type="hidden" name="subId" value = "${item.id}"/></td>
						<td>${item.unitName}</td>
						<td>${item.inQty}</td>
						<td><input type="number" class="bli" value="${item.inQty1}" /></td>
						
						
  						</tr>
 						</c:forEach>
							
						</tbody>
					</table>
				</div>
				
			</div>
			
			<div class="from_tb">
				<table>
					<tr>
						<td width="25%">总金额</td>
						<td><p id="totalamt">${totalamt}</p></td>
					</tr>
					<tr>
						<td width="25%">整单折扣</td>
						<td><p><input type="number" id="discount" class="bli" value = "${discount}"/></p></td>
					</tr>
					<tr>
						<td width="25%">成交金额</td>
						<td><p id = "disamt">${disamt}</p></td>
					</tr>
					<tr>
						<td width="25%">状态</td>
						<td><a id = "billStatus" style="color:red;width:60px">${billstatus}</a>&nbsp;&nbsp; <a id="payStatus" style="color:red;width:60px">${paystatus}</a></td>
					</tr>
				</table>
			</div>
			
		</div>
		
		<div class="interval"></div>
		
		<div class="sub_box">
			<input type="submit" name="" id="btnsubmit" value="确认收货" class="library_submit" onclick="submitClick();"/>
			
		</div>
		
		<div class="had_box" id="lib_chose_sale_had">
			<div class="mask"></div>
			<div class="lib_box">
				<ul>
					<li>正常销售</li>
					<li>促销折让</li>
					<li>消费折让</li>
					<li>费用折让</li>
					<li>其他销售</li>
				</ul>
			</div>
		</div>
		<div class="had_box" id="warehouse_bhad">
			<div class="mask"></div>
			<div class="lib_box" id = "basestk">
				<ul>
					
				</ul>
			</div>
		</div>
		<div class="had_box" id="order_had">
			<div class="mask"></div>
			<div class="lib_box">
				<ul>
					
				</ul>
			</div>
		</div>
		<div class="had_box has_sub_menu" id="beer_box">
			<div class="mask"></div>
			<div class="lib_box" id = "wareList">
				<ul>
					<li>
						
					</li>
					<li>
						
					</li>
					<li>
						
					</li>
					<li><p class="lib_title">喜力啤酒<img src="<%=basePath %>/resource/stkstyle/img/arrow.png"/></p></li>
					<li><p class="lib_title">其他<img src="<%=basePath %>/resource/stkstyle/img/arrow.png"/></p></li>
				</ul>
			</div>
		</div>
		
		
		
		<div class="chose_people" style="display: none;">
			<div class="src_box">
				<div class="src">
					<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
					<input type="text" placeholder="搜索" onchange="querycustomer(this.value)"/>
				</div>
			</div>
			<div class="people_list" id="customerList">
				<ul>
					
					
					
					
				</ul>
			</div>
		</div>
		
		
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		// 日历绑定
		
		$("#remarks").attr("readonly","readonly");
		$("#discount").attr("readonly","readonly");
		$("#demo1").attr("disabled",true);
		var status =$("#status").val();
		var opeType = $("#opeType").val();
		
		if(status > 0)
		{
		
			$("#btnsubmit").attr("disabled", true);
		
		}
		
		
		
		var calendar = new lCalendar();
		calendar.init({
			'trigger': '#demo1',
			'type': 'date'
		});
		// 解决苹果 readonly 失效问题
		$("input[name='input_date']").focus(function(){
			$(this).blur();
		});
		
		
		
		function submitClick()
		{
			var opeType = $("#opeType").val();
			if(opeType == 0)submitCheck();
			else cancelProc();
		}
		
		function submitCheck(){
			
			var billId = $("#billId").val();
			
			var wareList = new Array();
			var trList = $("#subList").children("tr");
			for (var i=0;i<trList.length;i++) {
			    var tdArr = trList.eq(i).find("td");
			    var wareId = tdArr.eq(0).find("input").val();
			    var qty = 0;//
			    var subId = tdArr.eq(1).find("input").val();
			    var inQty = tdArr.eq(4).find("input").val();
			    var unit = "";
			    var price = "0";			    
			    if(wareId == 0)break;
			    if(wareId == "")break;
			    if(price == "")break;
			    var subObj = {
			    		id:subId,
						wareId: wareId,
						qty: qty,
						inQty:inQty,
						unitName: unit,
						price: price					
				};
			    wareList.push(subObj);
			    
			    
			}
			//alert(JSON.stringify(wareList));
			if(!confirm('是否确认收货？'))return;
			var path = "auditProc";
			var token = $("#tmptoken").val();
			//alert(outTime);
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"billId":billId,"wareStr":JSON.stringify(wareList)},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		alert("收货成功");
		        		//window.location.href='stkinQuery?token=' + token;
		        		if(json.isfinish == 1)
	        			$("#billstatus").val("已收货");
		        		$("#btnsubmit").attr("disabled", true);
		        	}
		        	else
		        	{
		        		alert("审核失败:" + json.msg);	
		        	}
		        }
		    });
		}
		
		
	</script>
</html>