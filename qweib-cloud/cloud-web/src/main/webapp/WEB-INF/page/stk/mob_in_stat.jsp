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
			<h1>入库统计表</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input type="text" placeholder="产品名称" id="searchKey" onchange="queryData()"/>
			</div>
		</div>
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="stkId" id="stkId" value="0"/>
			<table>
				<tr>
					<td width="25%">
						<div class="dtbox">
							<input id="demo1" type="text" readonly="readonly" name="input_date" value="${sdate}" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" onchange="queryData();" />
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<input id="demo2" type="text" readonly="readonly" name="input_date" value="${edate}" placeholder="请点击" data-lcalendar="2011-01-1,2019-12-31" onchange="queryData();"/>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:;" id = "warehouse">仓库</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:;" id="inType">入库类型</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		
		<div class="sctb">
			<div class="sctbw">
				<table>
					<thead>
						<tr>							
							<td align="center" style = "WIDTH:100px;">产品名称</td>
							<td align="center" style = "WIDTH:50px;">单位</td>
							<td align="center" style = "WIDTH:80px;">发票数量</td>
							<td align="center" style = "WIDTH:80px;">收货数量</td>
							
							<td align="center" style = "WIDTH:80px;">采购金额</td>
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
		
		<div class="bottom_bb">
			
			<div class="bt">
				<table>
					<tr>
						<td><a href="javascript:queryClick();">查询</a></td>	
						
						
					</tr>
				</table>
			</div>
			
	  </div>
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
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
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		queryStorage();
		queryDict();
		
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
				queryClick();
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
				queryClick();
				box.fadeOut(200);
			});
		}
		var winH = $(window).height(); //页面可视区域高度
		var pageNo = 1; //设置当前页数
		var lock = true;
		var total_page = 0;//总页数
		$(window).scroll(function() {
			var pageH = $(document.body).height();
			var scrollT = $(window).scrollTop(); //滚动条top
			//alert('sT=' + scrollT);
			//var aa = (pageH - winH - scrollT) / winH;
			var aa = (scrollT) / (pageH - winH);
			//alert('aa=' + aa);
			//alert('pageH=' + pageH);
			//alert('winH=' + winH);
			if(aa > 0.95 && lock && pageNo < total_page) {
				
				lock = false;
				pageNo++;
				queryData(pageNo);
				
				
			}
			
		});
		queryClick();
		function queryClick()
		{
			pageNo = 1;
			queryData(1);
		}
	function queryData(pageIndex){
			
	var startDate = $("#demo1").val();
	var endDate = $("#demo2").val();
			var searchKey = $("#searchKey").val();
			var path = "stkInSubStatList";
			var token = $("#tmptoken").val();
			var stkId = $("#stkId").val();
			var inType = $("#inType").text();
			
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"sdate":startDate,"edate":endDate,"stkId":stkId,"wareNm":searchKey,"inType":inType,"page":pageIndex,"rows":20},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	lock = true;
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		if(pageIndex ==1)$("#dataList").html("");
		        		var total = json.total;
		        		total_page = total/20;
		        		total_page = parseInt(total_page);
		        		if(total%20>0)total_page = total_page + 1;
		        		var text = "";
		        		
		        		for(var i = 0;i < size; i++)
		        			{
		        				text =  "<tr onmousedown = \"tronmousedown1(this)\" onclick=\"chooseBill(this)\">";
		        				//text += "<td><input type='hidden' name='unitId' value='" + json.rows[i].unitId + "' \>";
		        				
		        				//text += json.rows[i].stkUnit + "</td>";
		        				text += "<td>" + json.rows[i].wareNm + "<input type='hidden' name='wareId' value='" + json.rows[i].wareId + "' \></td>";
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + json.rows[i].sumQty + "</td>";
								text += "<td>" + json.rows[i].sumQty1 + "</td>";
								text += "<td>" + json.rows[i].sumAmt + "</td>";
		        				text = text + "</tr>";
		        				$("#dataList").append(text);
		        			}
		        		if(pageIndex == total_page)
	        			{
	        				text = "<tr><td colspan='6'>没有更多数据</td></tr>";
	        					$("#dataList").append(text);
	        			}
		        		
		        		
		        		
		        	}
		        }
		    });
			
			
		}
		
function tronmousedown1(obj){  
	var trs = document.getElementById('dataList').getElementsByTagName('tr');  
    for( var o=0; o<trs.length; o++ ){  
     if( trs[o] == obj ){  
      trs[o].style.backgroundColor = '#DFEBF2';  
     }  
     else{  
      trs[o].style.backgroundColor = '';  
     }  
    }  
   }  
   
function chooseBill(trobj)
{
	
	
	var wareId = $(trobj.cells[0]).find("input[name='wareId']").val();
	//var unitId = $(trobj.cells[0]).find("input[name='unitId']").val();
	
	var startDate = $("#demo1").val();
	var endDate = $("#demo2").val();
	
	var token = $("#tmptoken").val();
	var stkId = $("#stkId").val();
	var inType = $("#inType").text();
	window.location.href='stkinQueryDetail?token=' + token + '&sdate=' + startDate + '&edate=' + endDate + '&wareId=' + wareId  + '&inType=' + inType + '&stkId=' + stkId;
}
		
	</script>
</html>