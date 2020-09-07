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
		<a href="stkMain?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>入库</h1>
		</header>
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="proId" id="proId" value="0"/>  
		<input  type="hidden" name="stkId" id="stkId" value="0"/>  
		<input  type="hidden" name="orderId" id="orderId" value="0"/>
		<div class="from_tb">
			<table>
				<tr>
					<td width="25%">供应商</td>
					<td><a href="javascript:;" style="display: inline-block;width: 90%;" class="color_999" id="lib_supplier">请点击</a></td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">出货仓库</td>
					<td>
						<a href="javascript:;" class="color_999" id="warehouse">请点击</a>
					</td>
				</tr>
				
				<tr class="ftb_hd">
					<td width="25%">收货时间</td>
					<td>
						<input id="demo1" type="text" readonly="readonly" name="input_date" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" />
					</td>
				</tr>
				<tr class="ftb_hd">
					<td width="25%">备注</td>
					<td><input type="text" placeholder="请点击输入" id="remarks"/></td>
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
								<td style="padding-left: 0;padding-right: 0;"></td>
								<td>品项+</td>
								
								<td>数量</td>
								<td>单位</td>
								<td>单价</td>
							</tr>
						</thead>
						<tbody id = "subList">
							<tr class="initial_rest">
								<td><a href="javascript:;" class="delete_beer">删除</a></td>
								<td><a href="javascript:;" class="beer">点击选择</a></td>
								
								<td><input type="number" class="bli"/></td>
								<td><input type="text" class="bli"/></td>
								<td><input type="number" class="bli"/></td>
							</tr>
						</tbody>
					</table>
				</div>
				
			</div>
			
			<div class="from_tb">
				<table>
					<tr>
						<td width="25%">合计金额</td>
						<td><p id="totalamt">0.00</p></td>
					</tr>
					<tr>
						<td width="25%">整单折扣</td>
						<td><p><input type="number" id="discount" class="bli" value = "0" onchange="countAmt()"/></p></td>
					</tr>
					<tr>
						<td width="25%">发票金额</td>
						<td><p id = "disamt">0.00</p></td>
					</tr>
					<tr>
						<td width="25%">状态</td>
						<td><p id = "billStatus">${billstatus }</p></td>
					</tr>
				</table>
			</div>
			
		</div>
		
		<div class="interval"></div>
		
		<div class="sub_box">
			<input type="submit" name="" id="" value="提交11" class="library_submit" onclick="submitStk();"/>
			
		</div>
		
		<div class="had_box" id="lib_chose_sale_had">
			<div class="mask"></div>
			<div class="lib_box">
				<ul>
					<li>正常销售</li>
					<li>促销折让</li>
					<li>消费折让</li>
					<li>费用折让</li>
					<li>其他</li>
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
	<script src="<%=basePath %>/resource/stkstyle/js/stkin.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		// 日历绑定
		var calendar = new lCalendar();
		calendar.init({
			'trigger': '#demo1',
			'type': 'date'
		});
		// 解决苹果 readonly 失效问题
		$("input[name='input_date']").focus(function(){
			$(this).blur();
		});
	</script>
</html>