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
  			<form action="manager/pos/savePosGroup" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${group.id}"/>  
  			<input  type="hidden" name="isSupper" id="isSupper" value="${group.isSupper}"/>    
  			
  				<dl id="dl">
  				<dt class="f14 b">门店信息</dt>
  				
	        	<dd>
	      				<span class="title">门店角色名称：</span>
	        			<input class="reg_input" name="groupName" id="groupName" value="${group.groupName}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">备注：</span>
	        			<input class="reg_input" name="remarks" id="remarks" value="${group.remarks}" style="width: 120px"/>
	        			
	        	</dd>
	        	
	        	
				<dd>
	      				<span class="title">超级用户否：</span>
	        			<input name="chkSupper" id="chkSupper" type="checkbox" onclick="isCheck1(this)"/>
	        			
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
			  
			  if($("#goupName").val() == "")
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
				location.href="${base}/manager/pos/toPosGroup";
			}
			
			function isCheck1(oCtl){
				
				if(oCtl.checked == true)
					{
					$("#isSupper").val(1);
					
					}
				else $("#isSupper").val(0);
			}

			
			
			
			if($("#isSupper").val() == 1)$("#chkSupper").attr("checked","checked");
			else $("#chkSupper").attr("checked",false); 
			
			
			
		</script>
	</body>
</html>

