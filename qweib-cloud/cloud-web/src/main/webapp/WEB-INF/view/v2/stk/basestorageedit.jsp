<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>驰用T3</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script type="text/javascript" src="resource/md5.js"></script>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/savestk" name="stkfrm" id="stkfrm" method="post">
  			<input  type="hidden" name="id" id="id" value="${stk.id}"/>    
  				
  				
  			    <dl id="dl">
	      			<dt class="f14 b">仓库信息</dt>
	      			<dd>
	      				<span class="title">仓库编码：</span>
	        			<input class="reg_input" name="stkNo" id="stkNo" value="${stk.stkNo}" style="width: 120px"/>
	        			<span id="stkNoTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">仓库名称：</span>
	        			<input class="reg_input" name="stkName" id="stkName" value="${stk.stkName}" style="width: 120px"/>
	        			<span id="stkNameTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">管理员：</span>
	        			<input class="reg_input" name="stkManager" id="stkManager" value="${stk.stkManager}" style="width: 120px"/>
	        			
	        		</dd>
	        		<dd>
	      				<span class="title">联系电话：</span>
	        			<input class="reg_input" name="tel" id="tel" value="${stk.tel}" style="width: 120px"/>
	        			<span id="memberMobileTip" class="onshow"></span>
	        		</dd>
	        		<dd>
		      			<span class="title">仓库类型：</span>
						<select id="saleCar">
							<option value="0" selected>正常仓库</option>
							<option value="1">车销仓库</option>
							<option value="2">门店仓库</option>
						</select>
		        	</dd>
	        		<dd>
	      				<span class="title">地址：</span>
	        			<input class="reg_input" name="address" id="address" value="${stk.address}" style="width: 200px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remarks" id="remarks">${stk.remarks}</textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		<script type="text/javascript">
		
		    $(function(){
				$.formValidator.initConfig();
				$("#stkName").formValidator({onShow:"请输入(15个字符以内)",onFocus:"请输入(15个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:15,onError:"请输入(15个字符以内)"});
			});

		    
			function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					//验证手机号码
					var reg=new RegExp("^(13|15|18|14|17)[0-9]{9}$");
					var tel = $("#").val();
					if(tel!=""){
						/* if(!reg.test(tel)){
							alert("请输入正确的电话号码格式");
							return;
						} */
					}
					$("#stkfrm").form('submit',{
						success:function(data){
							if(data=="1"){
								alert("添加成功");
								toback();
							}else if(data=="2"){
								alert("修改成功");
								toback();
							}else if(data=="3"){
								alert("该手机号码已存在");
								return;
							}else{
								alert("操作失败");
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/querybasestk";
			}
			if('${stk.saleCar}'!=''){
				document.getElementById("saleCar").value='${stk.saleCar}';
			}
		</script>
	</body>
</html>
