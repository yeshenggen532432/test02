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
		<title>收款查询</title>
		<meta name="description" content="">
		<meta name="keywords" content="">
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/style.css"/>		
		<link rel="stylesheet" type="text/css" href="<%=basePath %>/resource/stkstyle/css/lCalendar.css"/>
		<script src="<%=basePath %>/resource/stkstyle/js/resize.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body class="bg1">
		<header class="fixed_top">
		<a href="stkMain?token=${token}" class="arrow2"><img src="<%=basePath %>/resource/stkstyle/img/arrow2.png"/></a>
			<h1>收款查询</h1>
		</header>
		<div class="src_box">
			<div class="src">
				<img src="<%=basePath %>/resource/stkstyle/img/src_icon.png"/>
				<input type="text" placeholder="客户名称" id="searchKey" onchange="queryData()"/>
			</div>
		</div>
		<div class="order_btn_top">
		<input  type="hidden" name="token" id="tmptoken" value="${token}"/>
		<input  type="hidden" name="stkId" id="stkId" value="0"/>
		<input  type="hidden" name="billId" id="billId" value="${billId}"/>
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
					
				</tr>
			</table>
		</div>
		
		
		<div class="sctb">
			<div class="sctbw">
				<table>
					<thead>
						<tr>
							
							<td align="center" style = "WIDTH:80px;">收款日期</td>
							<td align="center" style = "WIDTH:100px;">客户</td>
							<td align="center" style = "WIDTH:80px;">收款人</td>
							<td align="center" style = "WIDTH:80px;">收款金额</td>
							<td align="center" style = "WIDTH:80px;">类型</td>
							<td align="center" style = "WIDTH:80px;">状态</td>
							<td align="center" style = "WIDTH:120px;">备注</td>
						</tr>
					</thead>
					<tbody id="dataList">
						<tr>
							
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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
							
						</tr>
						<tr>
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
						<td><a href="javascript:cancelPay();">作废</a></td>	
						
						
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
		queryData();
		
function queryData(){
			
	var startDate = $("#demo1").val();
	var endDate = $("#demo2").val();
	var billId = $("#billId").val();
			var searchKey = $("#searchKey").val();
			var path = "stkRecQueryDo";
			var token = $("#tmptoken").val();			
			$.ajax({
		        url: path,
		        type: "POST",
		        data : {"token":token,"sdate":startDate,"edate":endDate,"khNm":searchKey,"billId":billId},
		        dataType: 'json',
		        async : false,
		        success: function (json) {
		        	
		        	if(json.state){
		        		
		        		var size = json.rows.length;
		        		var text = "";
		        		
		        		for(var i = 0;i < size; i++)
		        			{
		        			text = text + "<tr onmousedown = \"tronmousedown1(this)\" onclick=\"chooseBill(" + json.rows[i].id + ")\">";
	        				text += "<td><input type=\"checkbox\" class=\"sc_check\" name=\"chooseline\" value=\""  + json.rows[i].id + "\" /><input  type=\"hidden\" name=\"lineid\" value=\"" +json.rows[i].id +  "\"/>" + json.rows[i].recTimeStr + "</td>";
		        				
		        				
								text += "<td>" + json.rows[i].khNm + "</td>";
								text += "<td>" + json.rows[i].memberNm + "</td>";
								text += "<td>" + json.rows[i].sumAmt + "</td>";
								text += "<td>" + json.rows[i].billTypeStr + "</td>";
								text += "<td>" + json.rows[i].billStatus + "</td>";
								text += "<td>" + json.rows[i].remarks + "</td>";
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
								text += "</tr>";
								$("#dataList").html(text);
		        		}
		        		
		        		
		        		
		        	}
		        }
		    });
			
			
		}
		
function cancelPay()
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
    
	
    if (confirm('是否确定作废？')){
				$.ajax( {
					url : "cancelRec",
					data : "id=" + keys + '&token=' + token,
					type : "post",
					success : function(json) {
						if (json.state) {
							alert("作废成功");
							queryData();
						} else{
							alert("作废失败:" + json.msg);
						}
					}
				});
			};
		

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

		
	</script>
</html>