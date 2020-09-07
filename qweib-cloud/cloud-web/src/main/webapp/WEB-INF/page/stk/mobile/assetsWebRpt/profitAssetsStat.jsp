<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
		<title>利润分析表</title>
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
			<h1>利润分析表</h1>
		</header>
		<div class="order_btn_top" >
			<form action="<%=basePath %>/web/assetsWebRpt/toProfitAssetsStat" name="toFinProfitstatisticsfrm" id="toFinProfitstatisticsfrm" method="post">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="sdate" id="sdate" value="${sdate}"/>
		<input  type="hidden" name="edate" id="edate" value="${edate}"/>
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
				</tr>
			</table>
			</form>
		</div>
		
		<div class="sctb1" >
			<div class="sctbw" >
				<table width="100%" border="1" 
					cellpadding="0" cellspacing="1" >
			<tr>
			<td style="font-weight: bold;color: blue;">一.销售毛利</td>
			<td colspan="2" style="color: red">
			<fmt:formatNumber value='${datas["saleMargin"]}'  pattern="#,#00.0#"></fmt:formatNumber></td>
			</tr>
			<tr>
			<td width="150px">1.产品销售收入</td> 
			<td width="150px">
			<fmt:formatNumber value='${datas["saleAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>2.产品销售成本</td> 
			<td>
			<fmt:formatNumber value='${datas["saleCostAmt"]}' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>3.产品折扣</td> 
			<td>
			<fmt:formatNumber value='${datas["saleDiscount"]}' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<c:set var="costAmtSum" value="0"/>
			<tr>
			<td  style="font-weight: bold;color: blue;">二.费用合计</td>
			<td colspan="2" style="color:red;"><span id="costSumAmt"></span></td>
			</tr>
			<c:forEach items="${datas['costOut'] }" var="items" varStatus="s">
			<tr>
				<td>${s.index+1 }.${items['type_name'] }</td>
				<td >
				<fmt:formatNumber value='${items["total_amt"] }' pattern="#,#00.0#"/>
				</td>
				<c:set var="costAmtSum" value="${costAmtSum+items['total_amt']}"/>
				<td></td>
			</tr>
			</c:forEach>
			<script>
				document.getElementById("costSumAmt").innerHTML="<fmt:formatNumber value='${costAmtSum}' pattern='#,#00.0#'/>";
			</script>
			<tr>
			<td  style="font-weight: bold;color: blue;">三.其他净收入</td>
			<td colspan="2" style="color: red"><fmt:formatNumber value='${datas["qtSaleMargin"]+datas["qtSlSumAmt"]}' pattern="#,#00.0#"/></td>
			</tr>
			<tr>
			<td>1.其它销售收入</td> 
			<td>
			<fmt:formatNumber value='${datas["qtSaleAmt"] }' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>2.其它销售成本</td> 
			<td>
			<fmt:formatNumber value='${datas["qtCostAmt"] }' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td>3.其它销售净收入</td> 
			<td>
			<fmt:formatNumber value='${datas["qtSaleMargin"]}' pattern="#,#00.0#"/>
			</td> 
			<td>其它销售收入-其它销售成本</td>
			</tr>
			<tr>
			<td>4.其他收入项目</td> 
			<td>
			<fmt:formatNumber value='${datas["qtSlSumAmt"] }' pattern="#,#00.0#"/>
			</td> 
			<td></td>
			</tr>
			<tr>
			<td style="font-weight: bold;color: blue;">四.经营毛利</td>
			
			<td style="color: red">
			<fmt:formatNumber value='${datas["saleMargin"]+datas["qtSaleMargin"]+datas["qtSlSumAmt"]-costAmtSum}' pattern="#,#00.0#"/>
			</td>
			<td>销售收入+其它销售净收入+其他收入项目-费用报销</td>
			</tr>
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
		<div class="bottom_bb">
			
			<div class="bt">
				<table>
					<tr>
						<td><a href="javascript:query();">查询</a></td>	
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
			} 
		});
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

function query(){
	  var startDate = $("#demo1").val();
  	var endDate = $("#demo2").val();
  	 $("#sdate").val(startDate);
  	 $("#edate").val(endDate);
	document.getElementById("toFinProfitstatisticsfrm").submit();
}

function amtformatter(v)
{
	if(v == null)return "";
   	if(v=="0E-7"){
   		return "0.00";
   	}
    return numeral(v).format("0,0.00");
}
	</script>
</html>