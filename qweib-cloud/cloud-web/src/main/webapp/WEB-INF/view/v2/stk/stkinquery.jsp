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
		<title>入库管理</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="stkMain?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>采购单</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input type="text" placeholder="供应商或单号搜索" id="searchKey" onchange="queryData()"/>
			</div>
		</div>
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
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
							<a href="javascript:;" id = "choosestatus">未收货</a>
							<img src="<%=basePath %>/resource/stkstyle/img/icon22.png"/>
						</div>
					</td>
					<td width="25%">
						<div class="dtbox">
							<a href="javascript:;" id="warehouse">入库类型</a>
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
							<td align="" style = "WIDTH:100px;"><!--<input type="checkbox" class="sc_check"/>-->日期</td>
							<td align="center" style = "WIDTH:100px;">单号</td>
							<td align="center" style = "WIDTH:100px;">供应商</td>
							<td align="center" style = "WIDTH:80px;">金额</td>
							<td align="center" style = "WIDTH:80px;">已付款</td>
							<td align="center" style = "WIDTH:80px;">核销</td>
							<td align="center" style = "WIDTH:50px;">状态</td>
						</tr>
					</thead>
					<tbody id="dataList">
						<tr>
							<td><input type="checkbox" class="sc_check"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						
					</tbody>
					
				</table>
			</div>
		</div>
		
		<div class="bottom_bb">
			<div class="w">
				<p>单据总数：<i id = "totalqty">0</i> <span class="fr">总金额：<i id="totalamt">0元</i></span></p>
			</div>
			<div class="bt">
				<table>
					<tr>
					<td><a href="javascript:queryClick();">查询</a></td>
						<td><a href="javascript:showBillInfo();">查看</a></td>
						<td><a href="javascript:newBill();">采购</a></td>
						<td><a href="javascript:newOtherBill();">其它</a></td>						
						<td><a href="javascript:cancelProc();">作废</a></td>
						
					</tr>
				</table>
			</div>
			
		</div>
		
		<div class="had_box" id="warehouse_bhad">
			<div class="mask"></div>
			<div class="lib_box" id="stkdict">
				<ul>
					<li>全部</li>
					<li>采购入库</li>
					<li>其它入库</li>					
				</ul>
			</div>
		</div>
		
		<div class="had_box" id="bill_status">
			<div class="mask"></div>
			<div class="lib_box" id="statusList">
				<ul>
					<li>全部</li>
					<li>未收货</li>
					<li>已收货</li>
					<li>作废</li>
					
				</ul>
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
			
			var status = $("#choosestatus").text();
			var inType = $("#warehouse").text();
			var searchKey = $("#searchKey").val();
			var path = "stkinQueryDo";
			var token = $("#tmptoken").val();
			var billStatus = -1;
			if(status == "未收货")billStatus = 0;
			if(status == "已收货")billStatus = 1;
			if(status == "作废")billStatus = 2;
			if(inType == "全部")inType = "";
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"proName":searchKey,"sdate":startDate,"edate":endDate,"inType":inType,"status":billStatus,"page":pageIndex,"rows":20},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	lock = true;
		        	if(json.state){
		        		if(pageIndex ==1)$("#dataList").html("");
		        		var size = json.rows.length;
		        		var total = json.total;
		        		total_page = total/20;
		        		total_page = parseInt(total_page);
		        		if(total%20>0)total_page = total_page + 1;
		        	
		        		var text = "";
		        		for(var i = 0;i < size; i++)
		        			{
		        				text =  "<tr onmousedown = \"tronmousedown1(this)\" onclick=\"chooseBill(" + json.rows[i].id + ")\">";
		        				text += "<td><input type=\"checkbox\" class=\"sc_check\" name=\"chooseline\" value=\""  + json.rows[i].id + "\" /><input  type=\"hidden\" name=\"lineid\" value=\"" +json.rows[i].id +  "\"/>" + json.rows[i].inDate + "</td>";
		        				text += "<td>" +json.rows[i].billNo + "</td>";
								text += "<td>" + json.rows[i].proName + "</td>";
								text += "<td>" + json.rows[i].disAmt + "</td>";
								if(json.rows[i].payAmt>100)
								text += "<td>" + json.rows[i].payAmt + "</td>";
								else
									text += "<td>" + json.rows[i].payAmt + "&nbsp;&nbsp;&nbsp;</td>";
								if(json.rows[i].freeAmt>100)
									text += "<td>" + json.rows[i].freeAmt + "</td>";
									else
										text += "<td>" + json.rows[i].freeAmt + "&nbsp;&nbsp;&nbsp;</td>";
								var sts = "未收货";
								if(json.rows[i].status == 1)sts = "已收货";
								if(json.rows[i].status == 2)sts = "作废";
								text += "<td>" + sts + "</td>";
		        				text = text + "</tr>";
		        				$("#dataList").append(text);
		        			}
		        		
		        		if(pageIndex == total_page)
		        			{
		        				text = "<tr><td colspan='7'>没有更多数据</td></tr>"
		        					$("#dataList").append(text);
		        			}
		        		/*if(size>0)
		        		$("#dataList").html(text);
		        		else
		        		{
		        			text = "<tr>";
									text += "<td><input type=\"checkbox\" class=\"sc_check\"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
									text += "<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>";
								text += "</tr>";
								$("#dataList").html(text);
		        		}*/
		        		
		        		$("#totalqty").html(json.total);
		        		$("#totalamt").html(json.sumAmt);
		        		
		        	}
		        }
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
				//var stkId = $(this).find("input[name='stkId']").val();
				queryData();
				box.fadeOut(200);
			});
		}
		
		lib_hadstk($("#warehouse"),$("#warehouse_bhad")); // 出库-销售类型-按钮绑定
		lib_had($("#choosestatus"),$("#bill_status")); // 出库-销售类型-按钮绑定
		
		function showBillInfo()
		{
			var operateBox = document.getElementsByName("chooseline");
		    var operateBoxs = new Array();
		    var keys = "";
		    var j = 0;
		    for(var i=0;i<operateBox.length;i++){
		       if(operateBox[i].checked){
		          operateBoxs[j] = operateBox[i].value;
		          keys = operateBox[i].value;
		                       
		          j++;
		       }          
		    }
		    if(operateBoxs == null || operateBoxs.length == 0){
		        alert("请选择您要查看的记录");
		        return;
		    }
		    if(j> 1)
		    {
		    	alert("只能选择一张单据");
		        return;
		    }
		    //alert(keys);
		    
		    var token = $("#tmptoken").val();
		    window.location.href='stkinEdit?token=' + token + '&billId=' + keys;
		}

		function chooseBill(billId)
		{
			var operateBox = document.getElementsByName("chooseline");
			for(var i=0;i<operateBox.length;i++){
				if(operateBox[i].value== billId)operateBox[i].checked = true;
				else operateBox[i].checked = false;
			          
			    }
			//var token = $("#tmptoken").val();
		    //window.location.href='stkoutEdit?token=' + token + '&billId=' + billId;
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


		function newBill()
		{
			
			var token = $("#tmptoken").val();
		    window.location.href='stkin?token=' + token + '&lastPage=采购发票';
		}

		function newOtherBill()
		{
			var token = $("#tmptoken").val();
		    window.location.href='otherin?token=' + token + '&lastPage=采购发票';;
		}

	</script>
</html>