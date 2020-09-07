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
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="stkMain?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>入库明细表</h1>
		</header>
		
		
		
		
		
		<div class="sctb">
		
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		
		<input type= "hidden" id = "wareId" value="${wareId}"/>
		 <input type= "hidden" id = "sdate" value="${sdate}"/>
		 <input type= "hidden" id = "edate" value="${edate}"/>
		 <input type= "hidden" id = "stkId" value="${stkId}"/>
		 <input type= "hidden" id = "proId" value="${proId}"/>
		 <input type= "hidden" id = "memberNm" value="${memberNm}"/>
		 <input type= "hidden" id = "inType" value="${inType}"/>
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							<td align="center" style = "WIDTH:100px;">往来单位</td>
							<td align="center" style = "WIDTH:100px;">单号</td>
							<td align="center" style = "WIDTH:100px;">产品名称</td>
							<td align="center" style = "WIDTH:50px;">单位</td>
							<td align="center" style = "WIDTH:80px;">发票数量</td>
							<td align="center" style = "WIDTH:80px;">收货数量</td>
							<td align="center" style = "WIDTH:80px;">单价</td>
							<td align="center" style = "WIDTH:80px;">金额</td>
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
					<li>全部状态</li>
					<li>未审</li>
					<li>已审</li>
					<li>作废</li>
					
				</ul>
			</div>
		</div>
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		queryStorage();
		queryDict();
		queryData();
		lib_hadstk($("#warehouse"),$("#warehouse_bhad"));
		lib_had($("#inType"),$("#inTypeBox"));
		function queryStorage(){
			var path = "queryBaseStorage";
			var token = $("#tmptoken").val();
			
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		
		        		var size = json.list.length;
		        		var text = "<ul>";
		        		for(var i = 0;i < size; i++)
		        			{
		        				text += "<li>" + json.list[i].stkName;
		        				text += "<input  type=\"hidden\" name=\"stkId\"  value=\"" + json.list[i].id + "\"/>";
		        				text +="</li>";
		        			}
						
		        		text += "</ul>";
		        		$("#stkdict").html(text);
		        		
		        	}
		        }
		    });
		}
		
		function queryDict(){
			var path = "querystkdict";
			var token = $("#tmptoken").val();
			//alert(token);
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"ioType":0},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		var text = "<ul>";
		        		for(var i = 0;i < size; i++)
		        			{
		        				text += "<li>" + json.rows[i].typeName;
		        				
		        				text +="</li>";
		        			}
						
		        		text += "</ul>";
		        		$("#inTypeList").html(text);
		        		
		        	}
		        }
		    });
		}
		
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
			
	
			
			var path = "stkinQueryDetailDo";
			var token = $("#tmptoken").val();
			var sdate = $("#sdate").val();
			var edate = $("#edate").val();
			var inType = $("#inType").val();
			var stkId = $("#stkId").val();
			//var proId = $("#proId").val();
			
			var wareId = $("#wareId").val();
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"sdate":sdate,"edate":edate,"stkId":stkId,"wareId":wareId,"inType":inType},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		var text = "";
		        		
		        		for(var i = 0;i < size; i++)
		        			{
		        				text = text + "<tr>";
		        				text += "<td>" + json.rows[i].proName + "</td>";
		        				text += "<td>" + json.rows[i].billNo + "</td>";
		        				text += "<td>";
		        				
		        				text += json.rows[i].wareNm + "</td>";
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + json.rows[i].qty + "</td>";
								text += "<td>" + json.rows[i].inQty + "</td>";
								text += "<td>" + json.rows[i].price + "</td>";
								text += "<td>" + json.rows[i].amt + "</td>";
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