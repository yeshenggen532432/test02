<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员等级添加界面</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style type="text/css">
			.title2{
				width: 160px;
				display: inline-block;
				text-align: right;
				padding-right: 10px;
			}
		</style>
	</head>
	<body>
		<div class="box">
  			<form action="manager/shopMemberGrade/update" name="shopMemberGradeFrm" id="shopMemberGradeFrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${model.id}"/>
				<dl id="dl">
	      			<dt class="f14 b">会员等级信息</dt>
	      			<dd>
	      				<span class="title2">等级名称：</span>
	        			<input class="reg_input" name="gradeName" id="gradeName"  value="${model.gradeName}" style="width: 240px"/>
	        			<span id="gradeNameTip" class="onshow"></span>
	        		</dd>
	        		<dd>
	      				<span class="title2">等级级别：</span>
	        			<input class="reg_input" name="gradeNo" id="gradeNo"  value="${model.gradeNo}" style="width: 240px"/>
	        			<span id="gradeNoTip" class="onshow"></span>
	        		</dd>
					<dd>
						<span class="title2">进销存客户会员使用：</span>
						<div style="display: inline-block;margin-right: 10px">
							<label for="isJxc_1">是:</label>
							<input type="radio" name="isJxc" value="1" id="isJxc_1" <c:if test="${model.isJxc eq 1}">checked="checked" </c:if>>
						</div>
						<div style="display: inline-block;margin-right: 10px">
							<label for="isJxc_0">不是:</label>
							<input type="radio" name="isJxc" value="0" id="isJxc_0" <c:if test="${model.isJxc eq 0}">checked="checked" </c:if>>
						</div>
						<span style="color: #FF5722;font-size: 12px">(备注:会员等级价格设置有显示批发价,被使用后不可修改为是)</span>
					</dd>
					<dd>
						<span class="title2">线下支付：</span>
						<div style="display: inline-block;margin-right: 10px">
							<label for="isXxzf_1">显示:</label>
							<input type="radio" name="isXxzf" value="1" id="isXxzf_1" <c:if test="${model.isXxzf eq 1}">checked="checked" </c:if>>
						</div>
						<div style="display: inline-block;margin-right: 10px">
							<label for="isXxzf_0">不显示:</label>
							<input type="radio" name="isXxzf" value="0" id="isXxzf_0" <c:if test="${model.isXxzf eq 0}">checked="checked" </c:if>>
						</div>
						<%--<div style="display: inline-block;margin-right: 10px">--%>
							<%--<label for="isXxzf_w">无:</label>--%>
							<%--<input type="radio" name="isXxzf" value="" id="isXxzf_w">--%>
						<%--</div>--%>
						<span style="color: #FF5722;font-size: 12px">(备注:会员下单选择支付方式是否显示“线下支付”)</span>
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
		   function toSubmit(){
				if ($.formValidator.pageIsValid()==true){
					$("#shopMemberGradeFrm").form('submit',{
						dataType: 'json',
						success:function(res){
							if (res == '1') {
								alert('添加成功')
								toback();
							} else if (res == '2') {
								alert('修改成功')
								toback();
							} else if (res == '3') {
								alert('会员等级名称已存在')
							} else if (res === '4') {
								alert('会员等级已被使用不可修改进销存客户会员使用');
							} else {
								alert('操作失败')
							}
						}
					});
				}
			}
			//返回
			function toback(){
				location.href="${base}/manager/shopMemberGrade/toPage";
			}
			
			$(function(){
			    $.formValidator.initConfig();
			    $("#gradeName").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(25个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:25,onError:"请输入(25个字以内)"});
			    $("#gradeNo").formValidator({onShow:"请输入(1`100之内的整数)",onFocus:"请输入(1`100之内的整数)",onCorrect:"通过"}).inputValidator({min:1,max:3,onError:"请输入(1`100之内的整数)"});
			});
		</script>	
	</body>
</html>
