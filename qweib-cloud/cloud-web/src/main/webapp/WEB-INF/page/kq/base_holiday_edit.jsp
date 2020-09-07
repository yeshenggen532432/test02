<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/kqholiday/saveHoliday" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${day.id}"/>    
  				<dl id="dl">
  				<dt class="f14 b">节假日信息</dt>
  				
	        	<dd>
	      				<span class="title">节假日名称：</span>
	        			<input class="reg_input" name="dayName" id="dayName" value="${day.dayName}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
			  					<span class="title" >开始日期：</span>
			  					<input name="startDate" id="startDate"  onClick="WdatePicker();" style="width: 100px;" value="${day.startDate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
				</dd>
				<dd>
	      				<span class="title" >结束日期：</span>
			  					<input name="endDate" id="endDate"  onClick="WdatePicker();" style="width: 100px;" value="${day.endDate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        			
	        	</dd>
	        	
	        	
	      			
                </dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	      		</div>
	  		</form>
		</div>
		
		<script type="text/javascript">
		   
		   function toSubmit(){
			  
			  if($("#dayName").val() == "")
				  {
				  alert("请输入名称");
				  return;
				  }
			  if($("#startDate").val() == "")
				  {
				  alert("请输入开始日期");
				  return;
				  }
			  if($("#endDate").val() == "")
			  {
			  alert("请输入结束日期");
			  return;
			  }
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
				location.href="${base}/manager/kqholiday/toBaseHoliday";
			}
			
			
			
		</script>
	</body>
</html>

