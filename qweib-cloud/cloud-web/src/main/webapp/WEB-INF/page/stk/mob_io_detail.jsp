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
		<title>入库统计表</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="querystksummary?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>出入库明细表</h1>
		</header>
		
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="token" id="stkId" value="0"/>
			<table>
				<tr>
					
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:;" id = "ioType">全部</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:queryData();" id="queryBtn">查询</a>
							
						</div>
					</td>
					
				</tr>
			</table>
		</div>
		
		
		
		<div class="sctb">
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>	
		<input type= "hidden" id = "wareId" value="${wareId}"/>
		 <input type= "hidden" id = "sdate" value="${sdate}"/>
		 <input type= "hidden" id = "edate" value="${edate}"/>
		 <input type= "hidden" id = "stkId" value="${stkId}"/>	
		 <input type= "hidden" id = "billName" value="${billName}"/>		 
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							<td align="center" style = "WIDTH:100px;">日期</td>							
							<td align="center" style = "WIDTH:100px;">单号</td>
							<td align="center" style = "WIDTH:100px;">往来单位</td>
							<td align="center" style = "WIDTH:100px;">产品名称</td>
							<td align="center" style = "WIDTH:50px;">单位</td>
							<td align="center" style = "WIDTH:80px;">入库数量</td>
							<td align="center" style = "WIDTH:80px;">出库数量</td>
							<td align="center" style = "WIDTH:80px;">类型</td>							
						</tr>
					</thead>
					<tbody id="dataList">
						<tr>
							
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
						
						
					</tbody>
					
				</table>
			</div>
		</div>
		
		
		
		<div class="had_box" id="warehouse_bhad">
			<div class="mask"></div>
			<div class="lib_box" id="stkdict">
				<ul>
					<li>一号仓库</li>
					<li>二号仓库</li>
					<li>三号仓库</li>
					<li>四号仓库</li>
					<li>五号仓库</li>
				</ul>
			</div>
		</div>
		
		<div class="had_box" id="inTypeBox">
			<div class="mask"></div>
			<div class="lib_box" id="inTypeList">
				<ul>
					<li>全部</li>
					<li>采购入库</li>
					<li>其它入库</li>
					<li>正常销售</li>
					<li>促销折让</li>
					<li>消费折让</li>
					<li>其他销售</li>
					<li>其它出库</li>					
					
				</ul>
			</div>
		</div>
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		
		queryData();
		
		lib_had($("#ioType"),$("#inTypeBox"));	
		
		
		function lib_hadstk(btn,box){
			btn.on('click',function(){
				
				box.fadeIn(200);
			});
			box.find('.mask').on('click',function(){
				box.fadeOut(200);
			});
			box.find('li').on('click',function(){
				var t = $(this).text();
				btn.text(t);
				var stkId = $(this).find("input[name='stkId']").val();
				$("#stkId").val(stkId);
				queryData();
				box.fadeOut(200);
			});
		}
		
		function lib_had(btn,box){
			btn.on('click',function(){
				box.fadeIn(200);
			});
			box.find('.mask').on('click',function(){
				box.fadeOut(200);
			});
			box.find('li').on('click',function(){
				var t = $(this).text();
				btn.text(t);
				queryData();
				box.fadeOut(200);
			});
		}
		
function queryData(){
			
	
			
			var path = "queryIoDetailList";
			var token = $("#tmptoken").val();
			var sdate = $("#sdate").val();
			var edate = $("#edate").val();			
			var stkId = $("#stkId").val();		
			
			var wareId = $("#wareId").val();
			var billName = $("#ioType").text();
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"sdate":sdate,"edate":edate,"stkId":stkId,"wareId":wareId,"billName":billName},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		var text = "";
		        		
		        		for(var i = 0;i < size; i++)
		        			{
		        				text = text + "<tr>";
		        				text += "<td>" + json.rows[i].ioTimeStr + "</td>";
		        				text += "<td>" + json.rows[i].billNo + "</td>";
		        				text += "<td>" + json.rows[i].stkUnit + "</td>";
		        				
		        				text += "<td>";
		        				
		        				text += json.rows[i].wareNm + "</td>";
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + numeral(json.rows[i].inQty).format("0,0.00") + "</td>";
								text += "<td>" + numeral(json.rows[i].outQty).format("0,0.00") + "</td>";
								text += "<td>" + json.rows[i].billName + "</td>";								
		        				text = text + "</tr>";
		        			}
		        		if(size>0)
		        		$("#dataList").html(text);
		        		else
		        		{
		        			text = "<tr>";
									
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									
								text += "</tr>";
								$("#dataList").html(text);
		        		}
		        		
		        		
		        		
		        	}
		        }
		    });
			
			
		}
		
	</script>
</html>