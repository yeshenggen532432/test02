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
  			<form action="manager/opercustomer" name="customerfrm" id="customerfrm" method="post">
  			    
  			    <dl id="dl">
	      			<dt class="f14 b">客户信息</dt>
	      			<dd>
	      			  <table style="width: 100%;" id="tcmx">
		        		 <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">客户名称</td>
	        		         <td style="width:130px;"><input name="khNm" id="khNm" value="${customer.khNm}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">客户编码</td>
	        		         <td style="width:130px;"><input name="khCode" id="khCode" value="${customer.khCode}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">ERP编码</td>
	        		         <td style="width:130px;"><input name="erpCode" id="erpCode" value="${customer.erpCode}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right">客户类型</td>
	        		         <td style="width:130px;">
	        		           <select name="qdtpNm" id="qdtpNm" style="width: 125px;" onchange="arealist3();" ></select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">市场类型</td>
	        		         <td style="width:130px;">
	        		           <select name="sctpNm" id="sctpNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${sctypels}" var="sctypels">
			        			  <option value="${sctypels.sctpNm}" <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">销售阶段</td>
	        		         <td style="width:130px;">
	        		           <select name="xsjdNm" id="xsjdNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${xsphasels}" var="xsphasels">
			        			  <option value="${xsphasels.phaseNm}" <c:if test="${xsphasels.phaseNm==customer.xsjdNm}">selected</c:if>>${xsphasels.phaseNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">拜访频次</td>
	        		         <td style="width:130px;">
	        		           <select name="bfpcNm" id="bfpcNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${bfpcls}" var="bfpcls">
			        			  <option value="${bfpcls.pcNm}" <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">客户等级</td>
	        		         <td style="width:130px;">
	        		           <select name="khdjNm" id="khdjNm" style="width: 125px;"></select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">供货类型</td>
	        		         <td style="width:130px;">
	        		           <select name="ghtpNm" id="ghtpNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${ghtypels}" var="ghtypels">
			        			  <option value="${ghtypels.ghtpNm}" <c:if test="${ghtypels.ghtpNm==customer.ghtpNm}">selected</c:if>>${ghtypels.ghtpNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">供货经销商</td>
	        		         <td style="width:130px;"><input name="pkhNm" id="pkhNm" value="${customer.pkhNm}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">业务联系人</td>
	        		         <td style="width:130px;"><input name="linkman" id="linkman" value="${customer.linkman}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">电话</td>
	        		         <td style="width:130px;"><input name="tel" id="tel" value="${customer.tel}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		     </tr> 
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">手机</td>
	        		         <td style="width:130px;"><input name="mobile" id="mobile" value="${customer.mobile}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">手机支持彩信</td>
	        		         <td style="width:130px;"><input name="mobileCx" id="mobileCx" value="${customer.mobileCx}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">QQ</td>
	        		         <td style="width:130px;"><input name="qq" id="qq" value="${customer.qq}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">微信</td>
	        		         <td style="width:130px;"><input name="wxCode" id="wxCode" value="${customer.wxCode}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">是否有效</td>
	        		         <td style="width:130px;text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isYx" id="isYx1" value="1" checked="checked"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">开户日期</td>
	        		         <td style="width:130px;"><input name="openDate" id="openDate" value="${customer.openDate}" onClick="WdatePicker();" style="width: 125px;" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">闭户日期</td>
	        		         <td style="width:130px;"><input name="closeDate" id="closeDate" value="${customer.closeDate}" onClick="WdatePicker();" style="width: 125px;" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">是否开户</td>
	        		         <td style="width:130px;text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isOpen" id="isOpen1" value="1" checked="checked"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">审核状态</td>
	        		         <td style="width:130px;"><input name="shZt" id="shZt" value="${customer.shZt}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">省</td>
	        		         <td style="width:130px;"><input name="province" id="province" value="${customer.province}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">城市</td>
	        		         <td style="width:130px;"><input name="city" id="city" value="${customer.city}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">区县</td>
	        		         <td style="width:130px;"><input name="area" id="area" value="${customer.area}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">地址</td>
	        		         <td colspan="5" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="98" name="address" id="address" readonly="readonly">${customer.address}</textarea></td>
	        		         <td colspan="6" style="width:95px;text-align: left;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">备注</td>
	        		         <td colspan="11" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="98" name="remo" id="remo" readonly="readonly">${customer.remo}</textarea></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">业务员</td>
	        		         <td style="width:130px;"><input name="memberNm" id="memberNm" value="${customer.memberNm}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">部门</td>
	        		         <td style="width:130px;"><input name="branchName" id="branchName" value="${customer.branchName}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		        <td style="width:85px;text-align: right;">合作方式</td>
	        		         <td style="width:130px;">
	        		           <select name="hzfsNm" id="hzfsNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${hzfsls}" var="hzfsls">
			        			  <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;"></td>
	        		         <td style="width:130px;"></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		  </table>
	        	    </dd>
	        	</dl>
	    		
	  		</form>
		</div>
		
		<script type="text/javascript">
		   
			$(function(){
			    var isYx="${customer.isYx}";
			    var id="${customer.id}";
			    if(isYx==1){
			      document.getElementById("isYx1").checked=true;
			    }else{
			      if(id){
			         document.getElementById("isYx1").checked=false;
			      }
			    }
				var isOpen="${customer.isOpen}";
			    if(isOpen==1){
			      document.getElementById("isOpen1").checked=true;
			    }else{
			      if(id){
			        document.getElementById("isOpen1").checked=false;
			      }
			    }
			    arealist1();
				arealist2();
			});
			
			//获取上级
			function arealist1(){
			var qdtpNm="${customer.qdtpNm}";
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						        if(list[i].qdtpNm==qdtpNm){
						          img +='<option value="'+list[i].qdtpNm+'" selected="selected">'+list[i].qdtpNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						        }
						       }
						    }
						   $("#qdtpNm").html(img);
						 }
					}
				});
			}
			//获取下级(修改的时候刚进来调)
			function arealist2(){
			    var qdtpNm="${customer.qdtpNm}";
			    var khdjNm="${customer.khdjNm}";
				$.ajax({
					url:"manager/queryarealist2",
					type:"post",
					data:"qdtpNm="+qdtpNm,
					success:function(data){
						if(data){
						   var list = data.list2;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						       if(list[i].khdjNm==khdjNm){
						           img +='<option value="'+list[i].khdjNm+'" selected="selected">'+list[i].khdjNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].khdjNm+'">'+list[i].khdjNm+'</option>';
						        }
						    }
						   $("#khdjNm").html(img);
						 }
					}
				});
			}
			//获取下级
			function arealist3(){
			    var qdtpNm1=$("#qdtpNm").val();
			    var qdtpNm2="${customer.qdtpNm}";
			    var khdjNm="${customer.khdjNm}";
			    var qdtpNm="";
			    if(qdtpNm1==qdtpNm2){
			       qdtpNm=qdtpNm2;
			    }else{
			       qdtpNm=qdtpNm1;
			    }
			    $.ajax({
					url:"manager/queryarealist2",
					type:"post",
					data:"qdtpNm="+qdtpNm,
					success:function(data){
						if(data){
						   var list = data.list2;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						       if(list[i].khdjNm==khdjNm){
						           img +='<option value="'+list[i].khdjNm+'" selected="selected">'+list[i].khdjNm+'</option>';
						        }else{
						           img +='<option value="'+list[i].khdjNm+'">'+list[i].khdjNm+'</option>';
						        }
						    }
						   $("#khdjNm").html(img);
						 }
					}
				});
			}
		</script>
	</body>
</html>
