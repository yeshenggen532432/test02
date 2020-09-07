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
  			    <input type="hidden" name="id" id="id" value="${customer.id}"/>
  			    <input type="hidden" name="khTp" id="khTp" value="1"/>
  			    <input type="hidden" name="qdtpNm" id="qdtpNm" value="${customer.qdtpNm}"/>
  			    <input type="hidden" name="khdjNm" id="khdjNm" value="${customer.khdjNm}"/>
  			    <input type="hidden" name="xsjdNm" id="xsjdNm" value="${customer.xsjdNm}"/>
  			    <input type="hidden" name="ghtpNm" id="ghtpNm" value="${customer.ghtpNm}"/>
  			    <input type="hidden" name="khPid" id="khPid" value="${customer.khPid}"/>
  			    <input type="hidden" name="qq" id="qq" value="${customer.qq}"/>
  			    <input type="hidden" name="wxCode" id="wxCode" value="${customer.wxCode}"/>
  			    <input type="hidden" name="shMid" id="shMid" value="${customer.shMid}"/>
  			    <input type="hidden" name="shTime" id="shTime" value="${customer.shTime}"/>
  			    <input type="hidden" name="province" id="province" value="${customer.province}"/>
  			    <input type="hidden" name="city" id="city" value="${customer.city}"/>
  			    <input type="hidden" name="area" id="area" value="${customer.area}"/>
  			    <input type="hidden" name="longitude" id="longitude" value="${customer.longitude}"/>
  			    <input type="hidden" name="latitude" id="latitude" value="${customer.latitude}"/>
  			    <input type="hidden" name="memId" id="memId" value="${customer.memId}"/>
  			    <input type="hidden" name="branchId" id="branchId" value="${customer.branchId}"/>
  			    <input type="hidden" name="wlId" id="wlId" value="${customer.wlId}"/>
  			    <input type="hidden" name="createTime" id="createTime" value="${customer.createTime}"/>
  			    <input type="hidden" name="isDb" id="isDb" value="${customer.isDb}"/>
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
	        		         <td style="width:130px;"><input name="mobile" id="mobile" value="${customer.mobile}" style="width: 125px" placeholder="必填"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">手机支持彩信</td>
	        		         <td style="width:130px;"><input name="mobileCx" id="mobileCx" value="${customer.mobileCx}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">收货地址</td>
	        		         <td style="width:130px;"><input name="address" id="address" value="${customer.address}" style="width: 125px"/></td>
	        		         <td style="width:95px;text-align: left;"><a class="easyui-linkbutton" href="javascript:showMap();">标注</a></td>
	        		         <td style="width:85px;text-align: right;">物流公司</td>
	        		         <td style="width:130px;"><input name="wlNm" id="wlNm" value="${customer.wlNm}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"><a class="easyui-linkbutton" iconCls="icon-search" href="javascript:choicelogistics();">查询</a></td>
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
	        		         <td style="width:130px;"><input name="khCode" id="khCode" value="${customer.khCode}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">ERP编码</td>
	        		         <td style="width:130px;"><input name="erpCode" id="erpCode" value="${customer.erpCode}" style="width: 125px"/></td>
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
	        		         <td style="width:130px;"><input name="fman" id="fman" value="${customer.fman}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">负责人电话</td>
	        		         <td style="width:130px;"><input name="ftel" id="ftel" value="${customer.ftel}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">经营范围</td>
	        		         <td style="width:130px;"><input name="jyfw" id="jyfw" value="${customer.jyfw}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">覆盖区域</td>
	        		         <td style="width:130px;"><input name="fgqy" id="fgqy" value="${customer.fgqy}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">年销售额</td>
	        		         <td style="width:130px;"><input name="nxse" id="nxse" value="${customer.nxse}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;text-align: right;">仓库面积</td>
	        		         <td style="width:130px;"><input name="ckmj" id="ckmj" value="${customer.ckmj}" style="width: 125px"/></td>
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
	        		         <td style="width:95px;text-align: left;"><img onclick="WdatePicker({el:'openDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/></td>
	        		         <td style="width:85px;text-align: right;">闭户日期</td>
	        		         <td style="width:130px;"><input name="closeDate" id="closeDate" value="${customer.closeDate}" onClick="WdatePicker();" style="width: 125px;" readonly="readonly"/></td>
	        		         <td style="width:95px;text-align: left;"><img onclick="WdatePicker({el:'closeDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/></td>
	        		         <td style="width:85px;text-align: right;">备注</td>
	        		         <td style="width:130px;"><input name="remo" id="remo" value="${customer.remo}" style="width: 125px"/></td>
	        		         <td style="width:95px;"></td>
	        		         <td style="width:85px;"></td>
	        		         <td style="width:130px;"></td>
	        		         <td style="width:95px;"></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">代理其他品类</td>
	        		         <td colspan="11" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="100" name="dlqtpl" id="dlqtpl">${customer.dlqtpl}</textarea></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="width:85px;text-align: right;">代理其他品牌</td>
	        		         <td colspan="11" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="100" name="dlqtpp" id="dlqtpp">${customer.dlqtpp}</textarea></td>
	        		     </tr>
	        		         <tr>
	        		     <td></td>
	        		     <td> <input type="hidden" value="设置价格" class="c_button" onclick="setTranPrice();"/>
	        		         </td><td>
	        		         <input type="hidden"  value="设置单位提成费用" class="c_button" onclick="setTcPrice();"/>
	        		         </td></tr>
	        		  </table>
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
		    function toSubmit(){
		        var khNm=$("#khNm").val();
		        var memberNm=$("#memberNm").val();
		        var mobile=$("#mobile").val();
		        if(!khNm){
		           alert("经销商名称不能为空");
		           return;
		        }
		        if(!memberNm){
		           alert("业务员不能为空");
		           return;
		        }
		        if(!mobile){
		           alert("联系手机不能为空");
		           return;
		        }
				$("#customerfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="-2"){
								alert("该经销商编码已存在");
								return;
							}else if(data=="-3"){
								alert("该经销商名称已存在");
								return;
							}else{
								alert("操作失败");
							}
						}
				});
			}
			function toback(){
				location.href="${base}/manager/querycustomer1";
			}
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
			//选择业务员
			function choicemember(){
				document.getElementById("windowifrm").src="manager/querychoicemember";
				showWindow("选择业务员");
			}
			//设置业务员
			function setMember(memberId,branchId,memberNm,branchName){
			   $("#memId").val(memberId);
			   $("#branchId").val(branchId);
			   $("#memberNm").val(memberNm);
			   $("#branchName").val(branchName);
			   $("#choiceWindow").window('close');
			}
			//选择物流公司
			function choicelogistics(){
				document.getElementById("windowifrm").src="manager/querychoicelogistics";
				showWindow("选择物流公司");
			}
			//设置物流公司
			function setLogistics(id,wlNm,linkman,tel,address){
			   $("#wlId").val(id);
			   $("#wlNm").val(wlNm);
			   $("#wllinkman").val(linkman);
			   $("#wltel").val(tel);
			   $("#wladdress").val(address);
			   $("#choiceWindow").window('close');
			}
			//显示地图
			function showMap(){
				var city = $("#city").val();
				var oldLng = $("#longitude").val();
				var oldLat = $("#latitude").val();
				var zoom = $("#zoom").val();
				var address = $("#address").val();
				document.getElementById("windowifrm").src="${base}/manager/getmap?oldLng="+oldLng+"&oldLat="+oldLat+"&zoom="+zoom+"&searchCondition="+address+"&city="+city;
				showWindow("标注(提示：右键选择获取标注。)");
			}
			//设置标注
			function setCoordinate(longitude,latitude,zoom,province,city,area){
			    $("#longitude").val(longitude);
				$("#latitude").val(latitude);
				$("#province").val(province);
				$("#city").val(city);
				$("#area").val(area);
				$("#choiceWindow").window('close');
			}
			//显示弹出窗口
			function showWindow(title){
				$("#choiceWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#choiceWindow").window('open');
			}
			function setTranPrice(){
				 var customerId="${customer.id}";
				 window.parent.add("设置价格","manager/customerwaretype?customerId=" + customerId);
			}
			function setTcPrice(){
				 var customerId="${customer.id}";
				 window.parent.add("设置单位提成费用","manager/customersaletype?customerId=" + customerId);
			}
		</script>
	</body>
</html>
