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
  			<form action="manager/opercustomer" name="customerfrm" id="customerfrm" method="post">
  			    <input type="hidden" name="id" id="id" value="${customer.id}"/>
  			    <input type="hidden" name="khTp" id="khTp" value="2"/>
  			    <input type="hidden" name="khPid" id="khPid" value="${customer.khPid}"/>
  			    <input type="hidden" name="shMid" id="shMid" value="${customer.shMid}"/>
  			    <input type="hidden" name="shTime" id="shTime" value="${customer.shTime}"/>
  			    <input type="hidden" name="longitude" id="longitude" value="${customer.longitude}"/>
  			    <input type="hidden" name="latitude" id="latitude" value="${customer.latitude}"/>
  			    <input type="hidden" name="memId" id="memId" value="${customer.memId}"/>
  			    <input type="hidden" name="branchId" id="branchId" value="${customer.branchId}"/>
  			    <input type="hidden" name="wlId" id="wlId" value="${customer.wlId}"/>
  			    <input type="hidden" name="createTime" id="createTime" value="${customer.createTime}"/>
  			    <input type="hidden" name="jxsflNm" id="jxsflNm" value="${customer.jxsflNm}"/>
  			    <input type="hidden" name="jxsjbNm" id="jxsjbNm" value="${customer.jxsjbNm}"/>
  			    <input type="hidden" name="jxsztNm" id="jxsztNm" value="${customer.jxsztNm}"/>
  			    <input type="hidden" name="fman" id="fman" value="${customer.fman}"/>
  			    <input type="hidden" name="ftel" id="ftel" value="${customer.ftel}"/>
  			    <input type="hidden" name="jyfw" id="jyfw" value="${customer.jyfw}"/>
  			    <input type="hidden" name="fgqy" id="fgqy" value="${customer.fgqy}"/>
  			    <input type="hidden" name="nxse" id="nxse" value="${customer.nxse}"/>
  			    <input type="hidden" name="ckmj" id="ckmj" value="${customer.ckmj}"/>
  			    <input type="hidden" name="dlqtpl" id="dlqtpl" value="${customer.dlqtpl}"/>
  			    <input type="hidden" name="dlqtpp" id="dlqtpp" value="${customer.dlqtpp}"/>
  			    <input type="hidden" name="isDb" id="isDb" value="${customer.isDb}"/>
  			    <input type="hidden" name="page" id="pageNo" value="${page}"/>
  			    <dl id="dl">
	      			<dt class="f14 b">客户信息</dt>
	      			<dd>
	      			  <table style="width: 100%;" id="tcmx">
		        		 <tr align="center" style="height: 30px;">
	        		         <td style="width:10%;text-align: right;">客户名称：</td>
	        		         <td style="width:15%;text-align: left;"><input name="khNm" id="khNm" value="${customer.khNm}" style="width: 125px" placeholder="必填"/></td>
	        		         <td style="width:10%;text-align: right;">客户编码：</td>
	        		         <td style="width:15%;text-align: left;"><input name="khCode" id="khCode" value="${customer.khCode}" style="width: 125px"/></td>
	        		         <td style="width:10%;text-align: right;">ERP编码：</td>
	        		         <td style="width:15%;text-align: left;"><input name="erpCode" id="erpCode" value="${customer.erpCode}" style="width: 125px"/></td>
	        		         <td style="width:10%;text-align: right;">客户类型：</td>
	        		         <td style="width:15%;text-align: left;">
	        		           <select name="qdtpNm" id="qdtpNm" style="width: 125px;" onchange="arealist3();"></select>
	        		         </td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">市场类型：</td>
	        		         <td style="text-align: left;">
	        		           <select name="sctpNm" id="sctpNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${sctypels}" var="sctypels">
			        			  <option value="${sctypels.sctpNm}" <c:if test="${sctypels.sctpNm==customer.sctpNm}">selected</c:if>>${sctypels.sctpNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="text-align: right;">销售阶段：</td>
	        		         <td style="text-align: left;">
	        		           <select name="xsjdNm" id="xsjdNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${xsphasels}" var="xsphasels">
			        			  <option value="${xsphasels.phaseNm}" <c:if test="${xsphasels.phaseNm==customer.xsjdNm}">selected</c:if>>${xsphasels.phaseNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="text-align: right;">拜访频次：</td>
	        		         <td style="text-align: left;">
	        		           <select name="bfpcNm" id="bfpcNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${bfpcls}" var="bfpcls">
			        			  <option value="${bfpcls.pcNm}" <c:if test="${bfpcls.pcNm==customer.bfpcNm}">selected</c:if>>${bfpcls.pcNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="text-align: right;">客户等级：</td>
	        		         <td style="text-align: left;">
	        		           <select name="khdjNm" id="khdjNm" style="width: 125px;"></select>
	        		         </td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">供货类型：</td>
	        		         <td style="text-align: left;">
	        		           <select name="ghtpNm" id="ghtpNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${ghtypels}" var="ghtypels">
			        			  <option value="${ghtypels.ghtpNm}" <c:if test="${ghtypels.ghtpNm==customer.ghtpNm}">selected</c:if>>${ghtypels.ghtpNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		         <td style="text-align: right;">供货经销商：</td>
	        		         <td style="text-align: left;"><input name="pkhNm" id="pkhNm" value="${customer.pkhNm}" style="width: 100px" readonly="readonly"/>
	        		           <input type="button" value="选择" onclick="javascript:choicecustomer();"/>
	        		        </td>
	        		         <td style="text-align: right;">业务联系人：</td>
	        		         <td style="text-align: left;"><input name="linkman" id="linkman" value="${customer.linkman}" style="width: 125px"/></td>
	        		         <td style="text-align: right;">电话：</td>
	        		         <td style="text-align: left;"><input name="tel" id="tel" value="${customer.tel}" style="width: 125px"/></td>
	        		     </tr> 
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">手机：</td>
	        		         <td style="text-align: left;"><input name="mobile" id="mobile" value="${customer.mobile}" style="width: 125px" placeholder="必填"/></td>
	        		         <td style="text-align: right;">手机支持彩信：</td>
	        		         <td style="text-align: left;"><input name="mobileCx" id="mobileCx" value="${customer.mobileCx}" style="width: 125px"/></td>
	        		         <td style="text-align: right;">QQ：</td>
	        		         <td style="text-align: left;"><input name="qq" id="qq" value="${customer.qq}" style="width: 125px"/></td>
	        		         <td style="text-align: right;">微信：</td>
	        		         <td style="text-align: left;"><input name="wxCode" id="wxCode" value="${customer.wxCode}" style="width: 125px"/></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">是否有效：</td>
	        		         <td style="text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isYx" id="isYx1" value="1" checked="checked"/></td>
	        		         <td style="text-align: right;">开户日期：</td>
	        		         <td style="text-align: left;"><input name="openDate" id="openDate" value="${customer.openDate}" onClick="WdatePicker();" style="width: 110px;" readonly="readonly"/>
	        		         <img onclick="WdatePicker({el:'openDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/></td>
	        		         <td style="text-align: right;">闭户日期：</td>
	        		         <td style="text-align: left;"><input name="closeDate" id="closeDate" value="${customer.closeDate}" onClick="WdatePicker();" style="width: 110px;" readonly="readonly"/><img onclick="WdatePicker({el:'closeDate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/></td>
	        		         <td style="text-align: right;">是否开户：</td>
	        		         <td style="text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isOpen" id="isOpen1" value="1" checked="checked"/></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">审核状态：</td>
	        		         <td style="text-align: left;"><input name="shZt" id="shZt" value="${customer.shZt}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="text-align: right;">省：</td>
	        		         <td style="text-align: left;"><input name="province" id="province" value="${customer.province}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="text-align: right;">城市：</td>
	        		         <td style="text-align: left;"><input name="city" id="city" value="${customer.city}" style="width: 125px" readonly="readonly"/></td>
	        		         <td style="text-align: right;">区县：</td>
	        		         <td style="text-align: left;"><input name="area" id="area" value="${customer.area}" style="width: 125px" readonly="readonly"/></td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">业务员：</td>
	        		         <td style="text-align: left;"><input name="memberNm" id="memberNm" value="${customer.memberNm}" style="width: 125px" readonly="readonly" placeholder="必填"/>
	        		         <input type="button" value="选择" onclick="javascript:choicemember();"/>
	        		         </td>
	        		         <td style="text-align: right;">部门：</td>
	        		         <td style="text-align: left;"><input name="branchName" id="branchName" value="${customer.branchName}" style="width: 125px" readonly="readonly"/></td>
	        		        <td style="text-align: right;">合作方式：</td>
	        		         <td style="text-align: left;">
	        		           <select name="hzfsNm" id="hzfsNm" style="width: 125px;">
	        		              <option value="">请选择</option>
			        			 <c:forEach items="${hzfsls}" var="hzfsls">
			        			  <option value="${hzfsls.hzfsNm}" <c:if test="${hzfsls.hzfsNm==customer.hzfsNm}">selected</c:if>>${hzfsls.hzfsNm}</option>
			        			 </c:forEach>
			        		   </select>
	        		         </td>
	        		          <td style="text-align: right;">是否二批：</td>
	        		         <td style="text-align: left;">&nbsp;&nbsp;<input type="checkbox" name="isEp" id="isEp" value="1" checked="checked"/></td>
	        		     </tr>
	        		      <tr align="center" style="height: 30px;">
	        		       <td style="text-align: right;">社会信用统一代码：</td>
	        		         <td style="text-align: left;">&nbsp;&nbsp;<input name="uscCode" style="width: 200px" id="uscCode" value="${customer.uscCode}"/>
	        		         </td>
	        		      	 <td style="text-align: right;">所属二批：</td>
	        		         <td colspan="5"  style="text-align: left;">
	        		         <input type="hidden"  name="epCustomerId" id="epCustomerId" value="${customer.epCustomerId }"/>
	        		         <input name="epCustomerName" id="epCustomerName" value="${customer.epCustomerName}" style="width: 125px" readonly="readonly"/>
	        		          <input type="button" value="选择" onclick="javascript:choiceEpCustomer();"/>
	        		        </td>
	        		        
	        		     </tr>
	        		       <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">地址：</td>
	        		         <td colspan="7" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="98" name="address" id="address">${customer.address}</textarea>
	        		         <input type="button" value="标注" onclick="javascript:showMap();"/>
	        		         </td>
	        		     </tr>
	        		     <tr align="center" style="height: 30px;">
	        		         <td style="text-align: right;">备注：</td>
	        		         <td colspan="7" style="text-align: left;">&nbsp;&nbsp;<textarea rows="2" cols="98" name="remo" id="remo">${customer.remo}</textarea></td>
	        		     </tr>
	        		     <tr>
	        		     <td></td>
	        		     <td> <input type="hidden" value="设置价格" class="c_button" onclick="setTranPrice();"/>
	        		         </td><td>
	        		         <input type="hidden" value="设置单位提成费用" class="c_button" onclick="setTcPrice();"/>
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
		           alert("客户名称不能为空");
		           return;
		        }
		        if(!memberNm){
		           alert("业务员不能为空");
		           return;
		        }
		        if(!mobile){
		           alert("手机不能为空");
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
								alert("该客户编码已存在");
								return;
							}else if(data=="-3"){
								alert("该客户名称已存在");
								return;
							}else{
								alert("操作失败");
							}
						}
				});
			}
			function toback(){
				//location.href="${base}/manager/querycustomer2?page=" + $("#pageNo").val();
				window.parent.$('#editdlg').dialog('close');
				window.parent.reloadCustomer();
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
			    var isEp="${customer.isEp}";
			    if(isEp==1){
				      document.getElementById("isEp").checked=true;
				    }else{
				      if(id){
				        document.getElementById("isEp").checked=false;
				      }
				    }
			    arealist1();
				arealist2();
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
			//选择经销商
			function choicecustomer(){
				document.getElementById("windowifrm").src="manager/choicecustomer1";
				showWindow("选择经销商");
			}
			//选择二批客户
			function choiceEpCustomer(){
				document.getElementById("windowifrm").src="manager/choiceEpCustomer";
				showWindow("选择二批客户");
			}
			function setEpCustomer(id,khNm){
				   $("#epCustomerId").val(id);
				   $("#epCustomerName").val(khNm);
				   $("#choiceWindow").window('close');
			}
			//设置物经销商
			function setCustomer(id,khNm){
			   $("#khPid").val(id);
			   $("#pkhNm").val(khNm);
			   $("#choiceWindow").window('close');
			}
			//选择渠道类型
			function choiceQdtype(){
				document.getElementById("windowifrm").src="manager/choiceQdtype";
				showWindow("选择渠道类型");
			}
			//设置渠道类型
			function setQdtype(id,qdtpNm){
			   $("#qdtpNm").val(qdtpNm);
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
