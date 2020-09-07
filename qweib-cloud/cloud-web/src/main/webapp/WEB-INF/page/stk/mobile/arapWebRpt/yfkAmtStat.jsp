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
		<title>应付货款统计表</title>
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
		  width: 100%;
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
			<h1>应付货款统计表</h1>
		</header>
		<div class="src_box">
			<div class="src" style="display: none">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input id="khNm" type="text"   placeholder="客户名称" />
			</div>
		</div>
		<div class="order_btn_top" style="display: none">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
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
		</div>
		
		
		<div class="sctb1" touchmove="queryData()">
			<div class="sctbw" >
				<table width="100%">
					<thead>
						<tr >							
							<td align="center" style="font-size: 11px">往来单位</td>
							<td align="center" style="font-size: 11px">应付金额</td>
							
						</tr>
						<tr >							
							<td align="center" style="font-size: 11px">合计</td>
							<td align="center" style="font-size: 11px" id="totalAmt"></td>
						</tr>
					</thead>
					<tbody id="dataList">
					</tbody>
				</table>
			</div>
		</div>
		
		
		
		<div class="had_box" id="timeTypeList">
			<div class="mask"></div>
			<div class="lib_box" id="stkdict">
				<ul>
					<li>发票时间</li>
					<li>发货时间</li>
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
		
	var	pageIndex = 1;
	function queryData(){
		    var startDate = $("#demo1").val();
	    	var endDate = $("#demo2").val();
			var path = "<%=basePath %>/web/arapWebRpt/yfkAmtStat";
			var token = $("#tmptoken").val();
			var khNm = $("#khNm").val();
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"sdate":startDate,"edate":endDate,"khNm":khNm,"page":pageIndex,"rows":20},
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
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + amtformatter(json.rows[i].sumAmt) + "</td>";
		        				text = text + "</tr>";
		        			}
		        			$("#dataList").append(text);
		        			pageIndex++;
		        			
		        			var data = json.rows[size-1];
        					$("#totalAmt").html(amtformatter(json.rows[i].sumAmt));
		        			
		        		}else{
		        			//text = "<tr><td colspan='11'>没有更多数据</td></tr>";
        					$("#dataList").append(text);
        					if(pageIndex<2){
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
changeTimeType($("#timeType"),$("#timeTypeList"));
function changeTimeType(bindId,sourceId){
	bindId.on('click',function(){
		sourceId.fadeIn(200);
	});
	sourceId.find('.mask').on('click',function(){
		sourceId.fadeOut(200);
	});
	sourceId.find('li').on('click',function(){
		var t = $(this).text();
		bindId.text(t);
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
queryData();
	</script>
</html>