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
  			<form action="manager/saveHzfs" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${hzfs.id}"/>    
  				<dl id="dl">
  				<dt class="f14 b">合作方式</dt>
  				
	        	<dd>
	      				<span class="title">合作方式名称：</span>
	        			<input class="reg_input" name="hzfsNm" id="hzfsNm" value="${hzfs.hzfsNm}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
			  	
	        	
	        	
	      			
                </dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	      		</div>
	  		</form>
		</div>
		
		<script type="text/javascript">
		   
		   function toSubmit(){
			  
			  if($("#hzfsNm").val() == "")
				  {
				  alert("请输入名称");
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
				location.href="${base}/manager/toCustomerHzfs";
			}
			
			
			
		</script>
	</body>
</html>

