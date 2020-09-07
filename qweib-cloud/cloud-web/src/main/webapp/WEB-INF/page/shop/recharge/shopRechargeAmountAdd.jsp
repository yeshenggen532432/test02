<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>充值面额添加界面</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
		<div class="box">
  			<form action="manager/shopRechargeAmount/update" name="shopRechargeFrm" id="shopRechargeFrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${model.id}"/>
				<dl id="dl">
	      			<dt class="f14 b">充值面额信息</dt>
	      			<dd>
	      				<span class="title">充值面额：</span>
	        			<input class="reg_input" name="czAmount" id="czAmount" value="${model.czAmount}" style="width: 240px"/>
	        			<span id="czAmountTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title">赠送面额：</span>
	        			<input class="reg_input" name="zsAmount" id="zsAmount"  value="${model.zsAmount}" style="width: 240px"/>
	        			<span id="zsAmountTip" class="onshow"></span>
	        		</dd>
	        	</dl>
	        	  <div class="f_reg_but" style="clear:both">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	      			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
	  		</form>
		</div>
		
		<div id="choiceWindow" class="easyui-window" style="width:800px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		
		<!-- ===================================以下是：js===================================================-->
	    <script type="text/javascript">
	    	//表单验证
			$(function(){
			    $.formValidator.initConfig();
			    //$("#czAmount").formValidator({onShow:"请输入(1`10数字或小数)",onFocus:"请输入(1`10数字或小数)",onCorrect:"通过"}).inputValidator({min:1,max:1000,onError:"请输入(1`10数字或小数)"});
			    //$("#zsAmount").formValidator({onShow:"请输入(1`10数字或小数)",onFocus:"请输入(1`10数字或小数)",onCorrect:"通过"}).inputValidator({min:1,max:1000,onError:"请输入(1`10数字或小数)"});
			    $("#czAmount").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
			    $("#zsAmount").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
			});
			
	       //提交数据
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					$("#shopRechargeFrm").form('submit',{
						dataType: 'json',
						success:function(res){
							// data = eval("("+data+")");
							// if(data.state){
							// 	alert("保存成功");
							// 	toback();
							// }else{
							// 	alert("操作失败"+data.msg);
							// }

							if (res == '1') {
								alert('添加成功')
								toback();
							} else if (res == '2') {
								alert('修改成功')
								toback()
							}else {
								alert('操作失败')
							}
						}
					});
				}
			}
			
			//返回
			function toback(){
				location.href="${base}/manager/shopRechargeAmount/toPage";
			}
			
		</script>	
	</body>
</html>
