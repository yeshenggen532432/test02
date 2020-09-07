<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body onload="load();">
	
		<div class="box">
  			<form action="manager/kqrule/saveKqRule" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${ruleId}"/>   
  			<input  type="hidden" name="status" id="status" value="${status}"/>    
  				<dl id="dl">
  				<dt class="f14 b">规律班信息</dt>
	        	<dd>
	      				<span class="title">规律名称：</span>
	        			<input class="reg_input" name="ruleName" id="ruleName"  style="width: 120px"/>
	        	</dd>
	        	<dd>
			  					<span class="title" >周期单位：</span>
			  					<select id="ruleUnit" name="ruleUnit" >			  					  
			  					  <option value="0">天</option>
			  					  <option value="1">周</option>
			  					  <option value="2">月</option>
			  					</select>
				</dd>
				<dd>
	      				<span class="title">天数：</span>
	        			<input class="reg_input" name="days" id="days"  style="width: 120px" />天
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">备注：</span>
	        			<input class="reg_input" name="remarks" id="remarks"  style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	        	<div class="datagrid-toolbar"></div> 
	        	
	        	</dd>
	        	<dd>
	        	<table style="width: 100%;" id="bctable">
	        	<tr>
	        	<td align="center">星期一</td>
	        	<td align="center">星期二</td>
	        	<td align="center">星期三</td>
	        	<td align="center">星期四</td>
	        	<td align="center">星期五</td>
	        	<td align="center">星期六</td>
	        	<td align="center">星期天</td>
	        	</tr>
	        	<tr>
	        	<td align="center">
	        	<select id="bc0" name="bc1">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	<td align="center">
	        	<select id="bc2" name="bc2">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
				</td>
	        	<td align="center">
	        	<select id="bc3" name="bc3">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	<td align="center">
	        	<select id="bc4" name="bc4">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	<td align="center">
	        	<select id="bc5" name="bc5">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	<td align="center">
	        	<select id="bc6" name="bc6">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	<td align="center">
	        	<select id="bc7" name="bc7">
			  					  <option value="">请选班次</option>
			  					  <option value="0">休息</option>			  					  
			  					</select>
	        	</td>
	        	</tr>
	        	</table>
	        	</dd>
	      		<dd>
	        	<div class="datagrid-toolbar"></div> 
	        	
	        	</dd>	
                </dl>
               
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	      		</div>
	  		</form>
		</div>
		
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<script type="text/javascript">
		   //var gBcList = "${subList}";
		   
		   //alert(gBcList.length);
		  
		   
		  
		   function toSubmit(){
			   
					$("#BonusSharfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("保存成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				
			}
			function toback(){
				location.href="${base}/manager/kqrule/toBaseKqRule";
			}
		   
			
			var gBcList ;
			function loadKqBc(){
				
				var path = "manager/bc/queryKqBcPage";
				$.ajax({
			        url: path,
			        type: "POST",
			        data : {"status":1},
			        dataType: 'json',
			        async : false,
			        success: function (json) {
			        	if(json.state){
			        		var size = json.rows.length;
			        		gBcList = json.rows;
			        		for(var i = 0;i<size;i++)
			        		$("#bc1").append("<option value='"+json.rows[i].id+"'>"+json.rows[i].bcName+"</option>");  //.options.add( new Option(json.rows[i].bcName,json.rows[i].id));
			        		
			        	}
			        }
			    });
				
			}
			
			function reLoadKqBc()
			{
				var size = gBcList.length;
				var days = $("#days").val();
				for(var j = 0;j< days;j++)
					{
				for(var i = 0;i<size;i++)
	        		$("#bc" + j).append("<option value='"+gBcList[i].id+"'>"+gBcList[i].bcName+"</option>");
					}
			}
			$("#ruleUnit").change(function(){
				if($("#ruleUnit").val() == 0)
					{
					$("#days").val(1);
					$("#days").removeAttr("readonly");
					initDate();
					}
				if($("#ruleUnit").val() == 1)
				{
				$("#days").val(7);
				$("#days").attr("readonly","readonly");
				initWeek();
				}
				if($("#ruleUnit").val() == 2)
				{
				$("#days").val(31);
				$("#days").attr("readonly","readonly");
				initMonth();
				}
				reLoadKqBc();
				});
			function initWeek()
			{
				var html = "";
				html += '<tr>';
				html += '<td align="center">星期一</td>';
				html += '<td align="center">星期二</td>';
				html += '<td align="center">星期三</td>';
				html += '<td align="center">星期四</td>';
				html += '<td align="center">星期五</td>';
				html += '<td align="center">星期六</td>';
				html += '<td align="center">星期天</td>';
				html += '</tr>';
				html += '<tr>';
				for(var i = 0;i<7;i++)
					{
				html += '<td align="center">';
				html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
				html +=	'<option value="">请选班次</option>';
				html +=	'<option value="0">休息</option>';			  					  
				html +=	'</select>';
				html +=	'</td>';
					}
	        	
	        	html += '</tr>';
	        	$("#bctable").html(html);
			}
			function initDate()
			{
				var days = $("#days").val();
				if(days == 0)return;
				var html = "";
				html += '<tr>';
				for(var i = 0;i<days;i++)
					{
					var n = i + 1;
					html += '<td align="center">' + n + '</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 0;i<days;i++)
					{
					html += '<td align="center">';
					html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
					html +=	'<option value="">请选班次</option>';
					html +=	'<option value="0">休息</option>';			  					  
					html +=	'</select>';
					html +=	'</td>';
					}
				html += '</tr>';
				$("#bctable").html(html);
			}
			function initMonth()
			{
				var html = "";
				html += '<tr>';
				for(var i = 0;i<10;i++)
					{
					var n = i + 1;
					html += '<td align="center">' + n + '</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 0;i<10;i++)
					{
					html += '<td align="center">';
					html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
					html +=	'<option value="">请选班次</option>';
					html +=	'<option value="0">休息</option>';			  					  
					html +=	'</select>';
					html +=	'</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 10;i<20;i++)
					{
					var n = i + 1;
					html += '<td align="center">' + n + '</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 10;i<20;i++)
					{
					html += '<td align="center">';
					html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
					html +=	'<option value="">请选班次</option>';
					html +=	'<option value="0">休息</option>';			  					  
					html +=	'</select>';
					html +=	'</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 20;i<30;i++)
					{
					var n = i + 1;
					html += '<td align="center">' + n + '</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 20;i<30;i++)
					{
					html += '<td align="center">';
					html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
					html +=	'<option value="">请选班次</option>';
					html +=	'<option value="0">休息</option>';			  					  
					html +=	'</select>';
					html +=	'</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 30;i<31;i++)
					{
					var n = i + 1;
					html += '<td align="center">' + n + '</td>';
					}
				html += '</tr>';
				html += '<tr>';
				for(var i = 30;i<31;i++)
					{
					html += '<td align="center">';
					html += '<select id="bc' + i + '" name="subList[' + i + '].bcId">';
					html +=	'<option value="">请选班次</option>';
					html +=	'<option value="0">休息</option>';			  					  
					html +=	'</select>';
					html +=	'</td>';
					}
				html += '</tr>';
				$("#bctable").html(html);
			}
			$("#days").change(function(){
				if($("#ruleUnit").val() == 0)
					{
					
					initDate();
					reLoadKqBc();
					}
				
				  
				});
			
				function load(){
					loadKqBc();
				var id = $("#id").val();
				if(id > 0)
					{
					 var kqRuleObj= eval('(' + '${kqRule}' + ')');
						$("#ruleName").val(kqRuleObj.ruleName);
						$("#ruleUnit").val(kqRuleObj.ruleUnit);
						$("#days").val(kqRuleObj.days);
						$("#remarks").val(kqRuleObj.remarks);
						if(kqRuleObj.ruleUnit == 0)initDate();
						if(kqRuleObj.ruleUnit == 1)initWeek();
						if(kqRuleObj.ruleUnit == 2)initMonth();
						reLoadKqBc();
						for(var i = 0;i<kqRuleObj.subList.length;i++)
							{
							$("#bc" + i).val(kqRuleObj.subList[i].bcId);
							}
						
					}
				else
					{
					$("#ruleUnit").val(1);
					$("#days").val(7);
					$("#days").attr("readonly","readonly");
					initWeek();
					reLoadKqBc();
					}
				
				
			}
		</script>
	</body>
</html>

