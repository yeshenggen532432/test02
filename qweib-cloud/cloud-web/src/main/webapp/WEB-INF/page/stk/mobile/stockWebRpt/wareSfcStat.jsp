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
		<title>收发存汇总表</title>
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
			<h1>收发存汇总表</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input id="wareNm" type="text"   placeholder="商品名称" />
			</div>
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
		<div class="order_btn_top" >
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
			<input  type="hidden" name="stkId" id="stkId" value="0"/>
			<table >
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
				
					<td width="25%" style="display: none">
						<div class="dtbox">
						   <a href="javascript:;" id="stockId">仓库</a>
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
							<td align="center" style="font-size: 11px">商品名称</td>
							<td align="center" style="font-size: 11px">单位</td>
							<td align="center" style="font-size: 11px">期初数量</td>
							<td align="center" style="font-size: 11px">本期入库</td>
							<td align="center" style="font-size: 11px">本期出库</td>
							<td align="center" style="font-size: 11px">期末数量</td>
						<tr >							
							<td align="center" style="font-size: 11px">合计</td>
							<td align="center" style="font-size: 11px"></td>
							<td align="center" style="font-size: 11px" id="totalQcQty"></td>
							<td align="center" style="font-size: 11px" id="bqInQty"></td>
							<td align="center" style="font-size: 11px" id="bqOutQty"></td>
							<td align="center" style="font-size: 11px" id="totalQmQty"></td>
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
	var	pageIndex = 1;
	function queryData(){
		    var startDate = $("#demo1").val();
	    	var endDate = $("#demo2").val();
			var path = "<%=basePath %>/web/stockWebRpt/wareSfcStat";
			var token = $("#tmptoken").val();
			var waretype = $("#waretype").val();
			var wareNm = $("#wareNm").val();
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"wareNm":wareNm,"startDate":startDate,"waretype":waretype,"stkId":0,"hideZero":1,"endDate":endDate,"page":pageIndex,"rows":20},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	if(json.state){
		        		var size = json.rows.length;
		        		var text = "";
		        		if(pageIndex==1){
	        				$("#dataList").html("");
							$("#totalQcQty").html("");
							$("#bqInQty").html("");
							$("#bqOutQty").html("");
							$("#totalQmQty").html("");
	        			}
		        		if(size>0){
		        			for(var i = 0;i < size-1; i++)
		        			{
		        				text +=  "<tr >";
								text += "<td>" + json.rows[i].wareNm + "</td>";
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + amtformatter(json.rows[i].initQty) + "</td>";
								text += "<td>" + amtformatter(json.rows[i].sumInQty) + "</td>";
								text += "<td>" + amtformatterBqck(json.rows[i]) + "</td>";
								text += "<td>" + amtformatter(json.rows[i].endQty) + "</td>";
		        				text = text + "</tr>";
		        			}
		        			$("#dataList").append(text);
		        			pageIndex++;
		        			var data = json.rows[size-1];
		        			if(size>1){
		        				$("#totalQcQty").html(amtformatter(data.initQty));
		        				$("#bqInQty").html(amtformatter(data.sumInQty));
            					$("#bqOutQty").html(amtformatter(data.sumOutQty));
	        					$("#totalQmQty").html(amtformatter(data.endQty));
		        			}
		        		}else{
		        			//text = "<tr><td colspan='11'>没有更多数据</td></tr>";
        					$("#dataList").append(text);
        					if(pageIndex<2){
        						$("#totalQcQty").html("");
            					$("#bqInQty").html("");
            					$("#bqOutQty").html("");
            					$("#totalQmQty").html("");
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
changeStock($("#stockId"),$("#stockList"));
function changeStock(bindId,sourceId){
	bindId.on('click',function(){
		sourceId.fadeIn(200);
	});
	sourceId.find('.mask').on('click',function(){
		sourceId.fadeOut(200);
	});
	sourceId.find('li').on('click',function(){
	/* 	var t = $(this).text();
		bindId.text(t);
		var stkId = $(this).find("input[name='stkId']").val();
		$("#stkId").val(stkId);
		sourceId.fadeOut(200); */
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


function amtformatterBqck(row){
	var outQty11 = row.outQty11==""?0:row.outQty11;
	//var otherTypeOutQty = row.otherTypeOutQty==""?0:row.otherTypeOutQty;
	var outQty12 = row.outQty12==""?0:row.outQty12;
	var outQty13 = row.outQty13==""?0:row.outQty13;
	var outQty14 = row.outQty14==""?0:row.outQty14;
	var outQty15 = row.outQty15==""?0:row.outQty15;
	var shopSaleQty = row.shopSaleQty==""?0:row.shopSaleQty;
	var otherOutQty = row.otherOutQty==""?0:row.otherOutQty;
	var purRtnQty = row.purRtnQty==""?0:row.purRtnQty;
	var transOutQty = row.transOutQty==""?0:row.transOutQty;
	var zzOutQty = row.zzOutQty==""?0:row.zzOutQty;
	var cxOutQty = row.cxOutQty==""?0:row.cxOutQty;
	var useQty = row.useQty==""?0:row.useQty;
	var lenOutQty = row.lenOutQty==""?0:row.lenOutQty;
	var lossQty = row.lossQty==""?0:row.lossQty;
	var lendQty = row.lendQty==""?0:row.lendQty;
	var checkOutQty = row.checkOutQty==""?0:row.checkOutQty;
	
	var totalQty =  parseFloat(outQty11)
	  +parseFloat(outQty12)
	  +parseFloat(outQty13)
	  +parseFloat(outQty14)
	  +parseFloat(outQty15)
	  +parseFloat(shopSaleQty)
	  +parseFloat(otherOutQty)
	  +parseFloat(purRtnQty)
	  +parseFloat(transOutQty)
	  +parseFloat(zzOutQty)
	  +parseFloat(cxOutQty)
	  +parseFloat(useQty)
	  +parseFloat(lenOutQty)
	  +parseFloat(lossQty)
	  +parseFloat(lendQty)
	  +parseFloat(checkOutQty)
	 ;
	return totalQty.toFixed(2);
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

function queryStorage(){
	var path = "<%=basePath %>/web/queryBaseStorage";
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
queryWareType();
queryData();
	</script>
</html>