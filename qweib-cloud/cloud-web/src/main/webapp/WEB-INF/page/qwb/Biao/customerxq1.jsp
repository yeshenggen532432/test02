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
	      			<dt class="f14 b">经销商信息</dt>
	      			<dd>
	      			  <table style="width: 100%;" id="tcmx">
		        		 <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">经销商名称</td>
	        		         <td style="width:130px;"><input name="khNm" id="khNm" value="${customer.khNm}" style="width: 125px" placeholder="必填"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">业务员</td>
	        		         <td style="width:130px;"><input name="memberNm" id="memberNm" value="${customer.memberNm}" style="width: 125px" readonly="readonly" placeholder="必填"/></td>
	        		         <td style="width:95px;text-align: left;"><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:choicemember();">查询</a></td>
	        		         <td style="width:85px;text-align: right;">部门</td>
	        		         <td style="width:130px;"><input name="branchName" id="branchName" value="${customer.branchName}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">经销商分类</td>
	        		         <td style="width:130px;">
	        		           <select name="jxsflNm" id="jxsflNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${jxsflls}" var="jxsflls">
			        			  <option value="${jxsflls.flNm}" <c:if test="${jxsflls.flNm==customer.jxsflNm}">selected</c:if>>${jxsflls.flNm}</option>
			        			 </c:forEach>
			        		   </select>
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
	        		         <td style="width:85px;text-align: right;">经销商级别</td>
	        		         <td style="width:130px;">
	        		           <select name="jxsjbNm" id="jxsjbNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${jxsjbls}" var="jxsjbls">
			        			  <option value="${jxsjbls.jbNm}" <c:if test="${jxsjbls.jbNm==customer.jxsjbNm}">selected</c:if>>${jxsjbls.jbNm}</option>
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
	        		         <td style="width:85px;text-align: right;">经销商状态</td>
	        		         <td style="width:130px;">
	        		           <select name="jxsztNm" id="jxsztNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${jxsztls}" var="jxsztls">
			        			  <option value="${jxsztls.ztNm}" <c:if test="${jxsztls.ztNm==customer.jxsztNm}">selected</c:if>>${jxsztls.ztNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">联系人</td>
	        		         <td style="width:130px;"><input name="linkman" id="linkman" value="${customer.linkman}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">联系电话</td>
	        		         <td style="width:130px;"><input name="tel" id="tel" value="${customer.tel}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">联系手机</td>
	        		         <td style="width:130px;"><input name="mobile" id="mobile" value="${customer.mobile}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">手机支持彩信</td>
	        		         <td style="width:130px;"><input name="mobileCx" id="mobileCx" value="${customer.mobileCx}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">收货地址</td>
	        		         <td style="width:130px;"><input name="address" id="address" value="${customer.address}" style="width: 125px"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">物流公司</td>
	        		         <td style="width:130px;"><input name="wlNm" id="wlNm" value="${customer.wlNm}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">物流联系人</td>
	        		         <td style="width:130px;"><input name="wllinkman" id="wllinkman" value="${customer.wllinkman}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">物流联系电话</td>
	        		         <td style="width:130px;"><input name="wltel" id="wltel" value="${customer.wltel}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">物流公司地址</td>
	        		         <td style="width:130px;"><input name="wladdress" id="wladdress" value="${customer.wladdress}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">经销商编码</td>
	        		         <td style="width:130px;"><input name="khCode" id="khCode" value="${customer.khCode}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">ERP编码</td>
	        		         <td style="width:130px;"><input name="erpCode" id="erpCode" value="${customer.erpCode}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">审核状态</td>
	        		         <td style="width:130px;"><input name="shZt" id="shZt" value="${customer.shZt}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        	      </table>
	        		</dd>
	        		<dt class="f14 b">基本</dt>
	      			<dd>
	      			  <table style="width: 100%;" id="tcmx2">
		        		 <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">负责人/法人</td>
	        		         <td style="width:130px;"><input name="fman" id="fman" value="${customer.fman}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">负责人电话</td>
	        		         <td style="width:130px;"><input name="ftel" id="ftel" value="${customer.ftel}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">经营范围</td>
	        		         <td style="width:130px;"><input name="jyfw" id="jyfw" value="${customer.jyfw}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">覆盖区域</td>
	        		         <td style="width:130px;"><input name="fgqy" id="fgqy" value="${customer.fgqy}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">年销售额</td>
	        		         <td style="width:130px;"><input name="nxse" id="nxse" value="${customer.nxse}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">仓库面积</td>
	        		         <td style="width:130px;"><input name="ckmj" id="ckmj" value="${customer.ckmj}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">是否有效</td>
	        		         <td style="width:130px;text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isYx" id="isYx1" value="1" checked="checked"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">是否开户</td>
	        		         <td style="width:130px;text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isOpen" id="isOpen1" value="1" checked="checked"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">开户日期</td>
	        		         <td style="width:130px;"><input name="openDate" id="openDate" value="${customer.openDate}" onClick="WdatePicker();" style="width: 125px;" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">闭户日期</td>
	        		         <td style="width:130px;"><input name="closeDate" id="closeDate" value="${customer.closeDate}" onClick="WdatePicker();" style="width: 125px;" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"></td>
	        		         <td style="width:85px;text-align: right;">备注</td>
	        		         <td style="width:130px;"><input name="remo" id="remo" value="${customer.remo}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;"></td>
	        		         <td style="width:130px;"></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">代理其他品类</td>
	        		         <td colspan="11" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="100" name="dlqtpl" id="dlqtpl" readonly="readonly">${customer.dlqtpl}</textarea></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">代理其他品牌</td>
	        		         <td colspan="11" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="100" name="dlqtpp" id="dlqtpp" readonly="readonly">${customer.dlqtpp}</textarea></td>
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
			});
		</script>
	</body>
</html>
