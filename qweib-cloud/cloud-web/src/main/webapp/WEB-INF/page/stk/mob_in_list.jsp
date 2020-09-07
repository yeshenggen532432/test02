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
	<input type="hidden" id="tmptoken" value="${token}"/>
		<header class="fixed_top">
		<a href="stkinMng?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>收货明细</h1>
		</header>		
		<div class="sctb">
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							<td align="center" style = "WIDTH:80px;">日期</td>
							<td align="center" style = "WIDTH:100px;">单号</td>
							<td align="center" style = "WIDTH:100px;">往来单位</td>
							<td align="center" style = "WIDTH:80px;">单品名称</td>
							<td align="center" style = "WIDTH:80px;">单位</td>
							<td align="center" style = "WIDTH:80px;">收货数量</td>
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
			
			<div class="bt">
				<table>
					<tr>
						<td><a href="javascript:cancelProc();">作废</a></td>	
						
						
					</tr>
				</table>
			</div>
			
	  </div>
		
		
		
	</body>
	
	<script src="<%=basePath %>/resource/stkstyle/js/jquery-2.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/stkinquery.js" type="text/javascript" charset="utf-8"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/lCalendar.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		
		var a = $(".sctbw table").width();
		$(".sctbw").width(a);
		
		queryData();
		
		
		
		function queryData(){
			
			var path = "queryOutDetailList";
			var token = $("#tmptoken").val();
			
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"billId":${billId}},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		var text = "";
		        		for(var i = 0;i < size; i++)
		        			{
		        				text = text + "<tr onmousedown = \"tronmousedown1(this)\" onclick=\"chooseBill(" + json.rows[i].id + ")\">";
		        				text += "<td><input type=\"checkbox\" class=\"sc_check\" name=\"chooseline\" value=\""  + json.rows[i].id + "\" /><input  type=\"hidden\" name=\"lineid\" value=\"" +json.rows[i].id +  "\"/>" + json.rows[i].ioTimeStr + "</td>";
		        				text += "<td>" +json.rows[i].billNo + "</td>";
								text += "<td>" + json.rows[i].stkUnit + "</td>";
								text += "<td>" + json.rows[i].wareNm + "</td>";
								
								text += "<td>" + json.rows[i].unitName + "</td>";
								text += "<td>" + json.rows[i].inQty + "</td>";
								var sts = "正常";
								
								if(json.rows[i].status == 2)sts = "作废";
								text += "<td>" + sts + "</td>";
		        				text = text + "</tr>";
		        			}
		        		if(size>0)
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
		        		}
		        		
		        		
		        		
		        	}
		        }
		    });
			
			
		}
		
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
		    var token = $("#tmptoken").val();
		    var path = "getStkInInfo";
		    var pass = 1;
		    $.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"billId":operateBoxs[0]},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		if(json.status == 1)
		        			{
		        				alert("该单据已经收货");
		        				pass = 0;
		        				return;
		        			}
		        		if(json.status == 2)
		        			{
		        			 	alert("该单据已经作废");
		        			 	pass = 0;
		        			 	return;
		        			}
		        		pass = 1;
		        		
		        	}
		        	else
		        		{
		        			alert(json.msg);
		        			return;
		        		}
		        }
		    });
		    
		    if(pass == 0)return;
		    window.location.href='stkinCheck?token=' + token + '&billId=' + operateBoxs[0];
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
		
		function cancelProc()
		{
			
			var operateBox = document.getElementsByName("chooseline");
		    var operateBoxs = new Array();
		    var keys = "";
		    var j = 0;
		    for(var i=0;i<operateBox.length;i++){
		       if(operateBox[i].checked){
		          operateBoxs[j] = operateBox[i].value;
		          keys += operateBox[i].value;
		          if(i < operateBox.length - 1){
		             keys += ",";
		          }               
		          j++;
		       }          
		    }
		    if(operateBoxs == null || operateBoxs.length == 0){
		        alert("请选择您要作废的记录");
		        return;
		    }
		    if(operateBoxs.length > 1)
		    	{
		    		alert("只能选择一条单据");
		    		return;
		    	}
			var token = $("#tmptoken").val();
			if (operateBoxs.length > 0) {
				
					if (confirm('是否确定作废？')) {
						$.ajax( {
							url : "cancelStkIn",
							data : "billId=" + operateBoxs[0] + "&token=" + token,
							type : "post",
							success : function(json) {
								if (json.state) {
									alert("作废成功");
									queryData();
								} else  {
									alert("作废失败" + json.msg);
								}
							}
						});
					};
			} else {
				showMsg("请选择要作废的数据");
			}
		}

	</script>
</html>