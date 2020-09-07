<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="tag" tagdir="/WEB-INF/tags"%>
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
		<title>库存查询</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
		<style type="text/css">
		
		.sctb1 {
		  overflow-x: scroll;
		  background: #fff;
		  padding-bottom: 5rem;
		  padding-top: .2rem;
		}
		.sctb1 .sctbw {
		  width: 600px;
		}
		.sctb1 table td {
		  border: 1px solid #ddd;
		}
		.sctb1 table thead td {
		  padding: .1rem;
		}
		.sctb1 table tbody td {
		  padding: .1rem .1rem;
		  font-size: 11px;
		  white-space: nowrap;
		}
		.sctb1 .sc_check {
		  width: .36rem;
		  height: .36rem;
		  position: relative;
		  top: -2px;
		  background: url(../img/check_icon.png) no-repeat bottom;
		  background-size: 100%;
		  margin-right: .2rem;
		}
		.sctb1 .sc_check:checked {
		  background: url(../img/check_icon.png) no-repeat top;
		  background-size: 100%;
		}
		</style>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="<%=basePath %>/web/moblieWeb/toIndex?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>库存查询</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input id="wareNm" type="text"   placeholder="商品名称" />
			</div>
		</div>
		<div class="order_btn_top" style="display: none">
			<input  type="hidden" name="stkId" id="stkId" value="0"/>
			<table >
				<tr>
					<td width="25%">
						<div class="dtbox">
						   <a href="javascript:;" id="stockId">仓库</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>

				</tr>
			</table>
		</div>

		<div class="order_btn_top">
			<input  type="hidden" name="waretype" id="waretype" value="0"/>
			<table >
				<tr>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:;" id="waretypeId">商品类别</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>

				</tr>
			</table>
		</div>

		<div class="sctb1" touchmove="queryData()">
			<div class="sctbw" >
				<table width="100%">
					<thead>
						<tr >							
							<td align="center" style="font-size: 11px">仓库名称</td>
							<td align="center" style="font-size: 11px">商品名称</td>
							<td align="center" style="font-size: 11px">单位</td>
							<td align="center" style="font-size: 11px">库存数量</td>
							<td align="center" style="font-size: 11px">总金额</td>
							<td align="center" style="font-size: 11px">平均单价</td>
						<tr >							
							<td align="center" style="font-size: 11px">合计</td>
							<td align="center" style="font-size: 11px"></td>
							<td align="center" style="font-size: 11px"></td>
							<td align="center" style="font-size: 11px" id="totalQty">库存数量</td>
							<td align="center" style="font-size: 11px" id="totalAmt">总金额</td>
							<td align="center" style="font-size: 11px"></td>
						</tr>
					</thead>
					<tbody id="dataList">
					</tbody>
				</table>
			</div>
		</div>
		
		
		
		<div class="had_box" id="stockList">
			<div class="mask"></div>
			<div class="lib_box" id="stkdict">
				<ul>
				</ul>
			</div>
		</div>
		<div class="had_box" id="typeList">
			<div class="mask"></div>
			<div class="lib_box" id="typedict">
				<ul>
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
	
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		var winH = $(window).height(); //页面可视区域高度
		$(window).scroll(function() {
		 	var pageH = $(document.body).height();
			var scrollT = $(window).scrollTop(); //滚动条top
			var aa = (scrollT) / (pageH - winH);
			if(aa > 0.95) {
				queryData();
			} 
		});
		function queryClick()
		{
			pageIndex = 1;
			queryData();
		}
	
	    function loadPage(){
	    	queryData();
	    } 
		
	var	pageIndex = 1;
	function queryData(){
			var path = "<%=basePath %>/web/stockWebRpt/wareStockStat";
			var token = '${token}';
			var wareNm = $("#wareNm").val();
			var stkId = $("#stkId").val();
			var waretype = $("#waretype").val();
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"stkId":stkId,"waretype":waretype,"wareNm":wareNm,"page":pageIndex,"rows":20},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		var size = json.rows.length;
		        		var text = "";
		        		if(pageIndex==1){
	        				$("#dataList").html("");
	        			}
		        		if(size>0){
		        			
		        			for(var i = 0;i < size-1; i++)
		        			{
		        				text +=  "<tr >";
								text += "<td>" + json.rows[i].stkName + "</td>";
								text += "<td>" + json.rows[i].wareNm + "</td>";
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + amtformatter(json.rows[i].sumQty) + "</td>";
								text += "<td>" + amtformatter(json.rows[i].sumAmt) + "</td>";
								text += "<td>" + amtformatter(json.rows[i].avgPrice) + "</td>";
		        				text = text + "</tr>";
		        			}
		        			$("#dataList").append(text);
		        			pageIndex++;
		        			var data = json.rows[size-1];
        					$("#totalQty").html(amtformatter(json.rows[i].sumQty));
        					$("#totalAmt").html(amtformatter(json.rows[i].sumAmt));
		        			
		        		}else{
		        			//text = "<tr><td colspan='11'>没有更多数据</td></tr>";
        					$("#dataList").append(text);
        					if(pageIndex<2){
        						$("#totalQty").html("");
            					$("#totalAmt").html("");
        					}
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

function changeStock(bindId,sourceId){
	bindId.on('click',function(){
		sourceId.fadeIn(200);
	});
	sourceId.find('.mask').on('click',function(){
		sourceId.fadeOut(200);
	});
	sourceId.find('li').on('click',function(){
		var t = $(this).text();
		bindId.text(t);
		var stkId = $(this).find("input[name='stkId']").val();
		$("#stkId").val(stkId);
		sourceId.fadeOut(200);
	});
}


function changeType(bindId,sourceId){
	bindId.on('click',function(){
		sourceId.fadeIn(200);
	});
	sourceId.find('.mask').on('click',function(){
		sourceId.fadeOut(200);
	});
	sourceId.find('li').on('click',function(){
		var t = $(this).text();
		bindId.text(t);
		var waretype = $(this).find("input[name='waretype']").val();
		$("#waretype").val(waretype);
		sourceId.fadeOut(200);
	});
}

function amtformatter(v)
{
	if(v == null)return "";
   	if(v=="0E-7"){
   		return "0.00";
   	}
    return numeral(v).format("0,0.00");
}


function queryStorage(){
	var path = "<%=basePath %>/web/queryWebStkStorageList";
	var token = "${token}";
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
				changeStock($("#stockId"),$("#stockList"));
        	}
        }
    });
}


function queryWareType(){
	var path = "<%=basePath %>/web/queryWareTypeTree";
	var token = "${token}";
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
					text += "<li style='text-align: left;padding-left: 5px'>" + json.list[i].waretypeNm;
					text += "<input  type=\"hidden\" name=\"waretype\"  value=\"" + json.list[i].waretypeId + "\"/>";
					text +="</li>";
					var list2 = json.list[i].list2;
					if(list2){
						var len = list2.length;
						for(var j=0;j<len;j++){
							text += "<li style='text-align: left;padding-left: 5px'>|-" + list2[j].waretypeNm;
							text += "<input  type=\"hidden\" name=\"waretype\"  value=\"" + list2[j].waretypeId + "\"/>";
							text +="</li>";
						}
					}
				}
				text += "</ul>";
				$("#typedict").html(text);
				changeType($("#waretypeId"),$("#typeList"));
			}
		}
	});
}
queryStorage();
queryWareType();
queryData();
	</script>
</html>