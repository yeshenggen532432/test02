<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/pos/savePosShopInfo" name="BonusSharfrm" id="BonusSharfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${shop.id}"/>  
  			<input  type="hidden" name="canInput" id="canInput" value="${shop.canInput}"/>    
  			<input  type="hidden" name="canCost" id="canCost" value="${shop.canCost}"/>  
  				<dl id="dl">
  				<dt class="f14 b">门店信息</dt>
  				
	        	<dd>
	      				<span class="title">店号：</span>
	        			<input class="reg_input" name="shopNo" id="shopNo" value="${shop.shopNo}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">店名：</span>
	        			<input class="reg_input" name="shopName" id="shopName" value="${shop.shopName}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">联系人：</span>
	        			<input class="reg_input" name="contact" id="concact" value="${shop.contact}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">联系电话：</span>
	        			<input class="reg_input" name="tel" id="tel" value="${shop.tel}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">地址：</span>
	        			<input class="reg_input" name="address" id="address" value="${shop.address}" style="width: 120px"/>
	        			
	        	</dd>
	        	<dd>
			  					<span class="title" >仓库：</span>
			  					<select id="stkId" name="stkId" >			  					  
			  					 <option value="">请选择</option>
			        			 <c:forEach items="${stkList}" var="stkList">
			        			  <option value="${stkList.id}" <c:if test="${stkList.stkName==shop.stkName}">selected</c:if>>${stkList.stkName}</option>
			        			 </c:forEach> 
			  					</select>
				</dd>
				<dd>
	      				<span class="title">可充值否：</span>
	        			<input name="chkInput" id="chkInput" type="checkbox" onclick="isCheck1(this)"/>
	        			
	        	</dd>
	        	<dd>
	      				<span class="title">可消费否：</span>
	        			<input name="chkCost" id="chkCost" type="checkbox" onclick="isCheck2(this)"/>
	        			
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
			  
			  if($("#shopNo").val() == "")
				  {
				  alert("请输入店号");
				  return;
				  }
			  if($("#shopName").val() == "")
			  {
			  alert("请输入店名");
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
				location.href="${base}/manager/pos/toPosShopInfo";
			}
			
			function isCheck1(oCtl){
				
				if(oCtl.checked == true)
					{
					$("#canInput").val(1);
					
					}
				else $("#canInput").val(0);
			}

			function isCheck2(oCtl){
				if(oCtl.checked == true)$("#canCost").val(1);
				else $("#canCost").val(0);
			}
			
			
			if($("#canInput").val() == 1)$("#chkInput").attr("checked","checked");
			else $("#chkInput").attr("checked",false); 
			
			if($("#canCost").val() == 1)$("#chkCost").attr("checked","checked");
			else $("#chkCost").attr("checked",false); 
			
		</script>
	</body>
</html>

