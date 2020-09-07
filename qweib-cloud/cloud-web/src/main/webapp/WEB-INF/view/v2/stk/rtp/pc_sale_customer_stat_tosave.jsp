<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body >
		
		<div id="tb" style="padding:5px;height:auto">
			<span style="display: none">
		   时间: <input name="stime" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="etime" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
		 	 业务员: <input name="driverName" id="driverName" value="${driverName }" style="width:120px;height: 20px;"/>
	         客户名称: <input name="customerName" id="customerName"  style="width:120px;height: 20px;" />
		 	 品名: <input name="wareNm" id="wareNm" value="${wareNm }" style="width:120px;height: 20px;" />
		 	 <br/>
		 	 销售类型:<select name="billName" id="billName">
	                   <option value="">全部</option>
	                   <option value="正常销售">正常销售</option>
	                   <option value="促销折让">促销折让</option>
	                   <option value="消费折让">消费折让</option>
	                   <option value="费用折让">费用折让</option>
	                   <option value="其他销售">其他销售</option>
				       <option value="其它出库">其它出库</option>
						<option value="借用出库">借用出库</option>
						<option value="领用出库">领用出库</option>
						<option value="报损出库">报损出库</option>
	                   <option value="销售退货">销售退货</option>
	               </select>
	               <script type="text/javascript">
	               if('${billName}'!=''){
	            	   document.getElementById("billName").value='${billName}';
	               }
	               </script>
	           </span>    
	               <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:updateSubmit();">保存</a>
			<form action="manager/saveVehicleCustomerStat" name="saveSaleCustomerStatfrm" id="saveSaleCustomerStatfrm" method="post">
			<input type="hidden" name="rptType" value="2"/>
			报表标题：<input name="rptTitle" value="${sdate}-${edate}业务员销售客户统计表" size="80"/>
			<br/>
			备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：
			<textarea name="remark" rows="5" cols="90">报表参数--时间:${sdate}-${edate},业务员:${driverName },品名:${wareNm},销售类型:${billName}
			</textarea>
			<br/>
			是否同步更新价格：
			<input type="radio" name="updatePrice" value="1" >是
			<input type="radio" name="updatePrice" value="0" checked="checked">否
			<table >
			<tr>
			<td>序号</td>
			<td>&nbsp;&nbsp;业务员</td> 
			<td>&nbsp;&nbsp;销售客户</td> 
			<td>品项</td> 
			<td>销售类型</td> 
			<td>单位 </td>
			<td>发货数量</td>
			<td>单位提成费用</td> 
			<td>提成额</td> 
			</tr>
			<c:forEach items="${datas }" var="d" varStatus="s">
			<tr>
			<td>
			${s.index+1 }
			</td> 
			<td>
			<input type="hidden" name="items[${s.index}].driverId" value="${d.driverId }"/>
			<input readonly="readonly" name="items[${s.index}].driverName" value="${d.driverName }"/>
			</td> 
			<td>
			<input type="hidden" name="items[${s.index }].customerId" value="${d.customerId }"/>
			<input readonly="readonly" name="items[${s.index}].customerName" value="${d.customerName }"/>
			</td> 
			<td>
			<input type="hidden" name="items[${s.index}].wareId" value="${d.wareId }"/>
			<input readonly="readonly"  name="items[${s.index}].wareNm" value="${d.wareNm }"/>
			</td> 
			<td>
			<input readonly="readonly"  name="items[${s.index}].billName" value="${d.billName }"/>
			</td> 
			<td>
			<input readonly="readonly"  name="items[${s.index}].unitName" value="${d.unitName }"/>
			 </td>
			<td>
			<input readonly="readonly"  name="items[${s.index}].outQty" class="beQty-imput" id="items${s.index}outQty" value="${d.outQty }"/>
			</td>
			<td>
			<input name="items[${s.index}].unitAmt" onchange="changSumAmt(this,${s.index})" id="items[${s.index}].unitAmt" value="${d.tcAmt }"/>
			</td> 
			<td>
			<input readonly="readonly"  name="items[${s.index}].sumAmt" class="beMny-imput" id="items${s.index}sumAmt" value="${d.ioPrice }"/>
			</td> 
			</tr>
			</c:forEach>
			<tr>
			<td>
			
			</td> 
			<td>
				合计
			</td> 
			<td>
			</td> 
			<td>
			</td> 
			<td>
			 </td>
			 <td>
			 </td>
			<td>
			<input readonly="readonly"  name="items[${fn:length(datas)}].outQty"  id="totalQty" />
			</td>
			<td>
			</td> 
			<td>
			<input readonly="readonly" name="items[${fn:length(datas)}].sumAmt"  id="totalAmt" />
			</td> 
			</tr>
			</table>
			</form>
		</div>
		<script type="text/javascript">
		  
		 
		 function changSumAmt(obj,index){
	    	 var amt = obj.value;
	    	 var qty =  document.getElementById("items"+index+"outQty").value;
	    	 if(amt==''){
	    		 amt = 0;
	    	 }
	    	 if(qty==''){
	    		 qty = 0;
	    	 }
	    	 var sumAmt = parseFloat(amt)*parseFloat(qty);
	    	 document.getElementById("items"+index+"sumAmt").value=sumAmt.toFixed(2);
	    	 calMny();
	     }
	
	     function calMny(){
	     	var mnyTotal=0;
	     	var qtyTotal=0;
		     $(".beMny-imput").each(function() {
		         var thisValue = $(this).val();
		         if (thisValue != '' ) {
		        	 mnyTotal += parseFloat(thisValue);
		         };
		     });
		     $(".beQty-imput").each(function() {
		         var thisValue = $(this).val();
		         if (thisValue != '' ) {
		        	 qtyTotal += parseFloat(thisValue);
		         };
		     });
		     mnyTotal = mnyTotal.toFixed(2);
		     qtyTotal = qtyTotal.toFixed(2);
		     
		     $("#totalQty").val(qtyTotal);
		     $("#totalAmt").val(mnyTotal);
	     }
	     calMny();
			 function updateSubmit(){
				 $("#saveSaleCustomerStatfrm").form('submit',{
						success:function(data){
							data = eval(data);
							if(parseInt(data)>0){
								alert("保存成功！");
							}else{
								alert("保存失败！");
							}
							
						}
				});
			   }
		</script>
	</body>
</html>
