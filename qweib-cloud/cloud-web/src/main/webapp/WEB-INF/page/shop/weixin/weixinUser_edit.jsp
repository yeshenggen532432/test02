<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员界面</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
		<div class="box">
  			<form action="/manager/weixinMemberEditInfoSubmit" name="shopMemberFrm" id="shopMemberFrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${model.id}"/>
				<dl id="dl">
	      			<dt class="f14 b">会员信息</dt>
	      			<dd>
	      				<span class="title">会员名称：</span>
	        			<input class="reg_input" name="name" id="name" value="${model.name}" style="width: 240px"/>
	        			<span id="nameTip" class="onshow"></span>
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
	    <script type="text/javascript">
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					$("#shopMemberFrm").form('submit',{
						dataType: 'json',
						success:function(data){
							data = eval("("+data+")");
							if(data.state){
								alert("保存成功");
								toback();
							}else{
								alert("操作失败"+data.msg);
							}
						}
					});
				}
			}
			function toback(){
				location.href="${base}/manager/shopMember/toPage";
			}
			
			//选择客户
			function choicecustomer(){
				document.getElementById("windowifrm").src="manager/choicecustomer2";
				showWindow("选择客户");
			}
			//设置客户
			function setCustomer(id,khNm){
			   $("#customerId").val(id);
			   $("#customerName").val(khNm);
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
			$(function(){
			    $.formValidator.initConfig();
			    $("#name").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(25个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(25个字以内)"});
			    $("#mobile").formValidator({onShow:"请输入(20个字符以内)",onFocus:"请输入(20个字符以内)",onCorrect:"通过"}).inputValidator({min:11,max:20,onError:"请输入(11个字符以上)"});
			});
		</script>	
	</body>
</html>
