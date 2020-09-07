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
		<title>销售发票</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="stkMain?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>销售发票</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input type="text" placeholder="客户名称" id="searchKey" onchange="queryData()"/>
			</div>
		</div>
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
			<table>
				<tr>
					<td width="25%">
						<div class="dtbox">
							<input id="demo1" type="text" readonly="readonly" name="input_date" value="${sdate}" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" />
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<input id="demo2" type="text" readonly="readonly" name="input_date" value="${edate }" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" />
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:queryData();" id = "choosestatus">查询</a>
							
						</div>
					</td>
					
				</tr>
			</table>
		</div>
		
		
		<div class="people_list" id="orderList">
				<ul>
					
					
					
					
				</ul>
		</div>
		
		<div class="bottom_bb">
			<div class="w">
				<p>订单总数：<i id = "totalqty">0</i> <span class="fr">总金额：<i id="totalamt">0元</i></span></p>
			</div>
			<div class="bt">
				<table>
					<tr>
						<td><a href="javascript:toHisList();">历史发票</a></td>
						<td><a href="javascript:newBill();">销售</a></td>
						<td><a href="javascript:newOtherBill();">其它</a></td>
						
					</tr>
				</table>
			</div>
			
		</div>
		
		
		
		
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
	var basePath = '<%=basePath %>';
		var calendar = new lCalendar();
		var calendar2 = new lCalendar();
		calendar.init({
			'trigger': '#demo1',
			'type': 'date'
		});
		calendar2.init({
			'trigger': '#demo2',
			'type': 'date'
		});
		queryData();
		function queryData(){
			
			var path = "willOutList";
			var token = $("#tmptoken").val();
			var sdate = $("#demo1").val();
			var edate = $("#demo2").val();
			var khNm = $("#searchKey").val();
			//alert(token);
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"dataTp":"1","khNm":khNm,"sdate":sdate,"edate":edate},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		lock = true;
		        		var size = json.rows.length;		        		
		        		var text = "<ul>";
		        		for(var i = 0;i < size; i++)
		        			{
		        				text += "<li onmousedown = \"lionmousedown1(this)\" onclick=\"chooseOrder(" +json.rows[i].id + ")\">" ;
		        					text += "	<input  type=\"hidden\" name=\"orderId\" value=\"" + json.rows[i].id + "\"/>";  
		        				text += "<div class=\"pl_wrap\">";
								text += "<div class=\"pl_box\"><img src=\"" + basePath + "/resource/stkstyle/img/icon8.png\" class=\"list_icon\"/></div>";
								text += "<div class=\"pl_box\">";
								text += "<p class=\"top_title\">" + json.rows[i].khNm + "</p>";
								//text += "<p class=\"pl_mes1\">" + json.rows[i].khNm + "<span class=\"color_blue\"></span></p>";
								text += "<p class=\"pl_mes1\"><img src=\"" + basePath + "/resource/stkstyle/img/icon9.png\"/><i class=\"p1\">" + json.rows[i].tel + "</i></p>";
								text += "<p class=\"pl_mes1\"><img src=\"" + basePath + "/resource/stkstyle/img/icon10.png\"/><i class=\"p2\">" + json.rows[i].address + "</i></p>";
								text += "</div>";
								text += "</div>";
						
								text += "<div class=\"bottom_mes\">单号：" + json.rows[i].orderNo + "</div>";
		        				text +="</li>";
		        				
		        			}
						
		        		text += "</ul>";
		        		
		        		$("#orderList").html(text);
		        	}
		        }
		    });
		}
		function lionmousedown1(obj)
		{
			obj.style.backgroundColor = '#DFEBF2';
		}
		
		function chooseOrder(orderId)
		{
			var token = $("#tmptoken").val();
			window.location.href='stkout?token=' + token + '&orderId=' + orderId;
		}
		
		function newBill()
		{
			var token = $("#tmptoken").val();
			 window.location.href='stkout?token=' + token + '&orderId=0&lastPage=销售发票';
		}
		
		function newOtherBill()
		{
			var token = $("#tmptoken").val();
			 window.location.href='otherout?token=' + token + '&orderId=0&lastPage=销售发票';
		}
		
		function toHisList()
		{
			var token = $("#tmptoken").val();
			 window.location.href='stkoutQuery?token=' + token;
		}
		
	</script>
</html>