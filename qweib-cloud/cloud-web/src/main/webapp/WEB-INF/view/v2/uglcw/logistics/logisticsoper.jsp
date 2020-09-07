<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/operlogistics" name="logisticsfrm" id="logisticsfrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${logistics.id}"/>
  				<dl id="dl">
	      			<dt class="f14 b">物流公司信息</dt>
	      			<dd>
	      				<span class="title">名称：</span>
	        			<input class="reg_input" name="wlNm" id="wlNm" value="${logistics.wlNm}" style="width: 200px"/>
	        			<span id="wlNmTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">代码：</span>
	        			<input class="reg_input" name="dcode" id="dcode" value="${logistics.dcode}" style="width: 100px"/>
	        			<span id="dcodeTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">联系人：</span>
	        			<input class="reg_input" name="linkman" id="linkman" value="${logistics.linkman}" style="width: 100px"/>
	        			<span id="linkmanTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">联系电话：</span>
	        			<input class="reg_input" name="tel" id="tel" value="${logistics.tel}" style="width: 100px"/>
	        			<span id="telTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">地址：</span>
	        			<input class="reg_input" name="address" id="address" value="${logistics.address}" style="width: 240px"/>
	        			<span id="addressTip" class="onshow"></span>
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
				if ($.formValidator.pageIsValid()==true){
					$("#logisticsfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/queryLogistics";
			}
			$(function(){
			    $.formValidator.initConfig();
				$("#wlNm").formValidator({onShow:"请输入名称",onFocus:"请输入名称",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入名称"});
				$("#dcode").formValidator({onShow:"请输入代码",onFocus:"请输入代码",onCorrect:"通过"}).inputValidator({min:1,max:10,onError:"请输入代码"});
				$("#linkman").formValidator({onShow:"请输入联系人",onFocus:"请输入联系人",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入联系人"});
				$("#tel").formValidator({onShow:"请输入联系电话",onFocus:"请输入联系电话",onCorrect:"通过"}).inputValidator({min:1,max:20,onError:"请输入联系电话"});
				$("#address").formValidator({onShow:"请输入地址",onFocus:"请输入地址",onCorrect:"通过"}).inputValidator({min:1,max:100,onError:"请输入地址"});
			});
		</script>
	</body>
</html>
