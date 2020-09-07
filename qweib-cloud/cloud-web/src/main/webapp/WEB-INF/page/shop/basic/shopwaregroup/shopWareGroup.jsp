<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>商品分组界面</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
		<div class="box">
  			<form action="manager/shopWareGroup/update" name="shopWareGroupFrm" id="shopWareGroupFrm" method="post">
  			    <input  type="hidden" name="id" id="id" value="${model.id}"/>
				<dl id="dl">
	      			<dt class="f14 b">商品分组信息</dt>
	      			<dd>
	      				<span class="title">分组名称：</span>
	        			<input class="reg_input" name="name" id="name"  value="${model.name}" style="width: 240px"/>
	        			<span id="nameTip" class="onshow"></span>
	        		</dd>
					<%--<dd>
						<span class="title">样式模版：</span>
						<select name="groupStyleId">
							<c:forEach items="${groupStyleList}" var="groupStyle">
							<option value="${groupStyle.groupStyleId}" <c:if test="${groupStyle.groupStyleId==model.groupStyleId}">selected</c:if> >${groupStyle.groupStyleName}</option>
							</c:forEach>
						</select>
						<span id="nameTip" class="onshow"></span>
					</dd>--%>
					<dd>
						<span class="title">排序：</span>
						<input class="reg_input number" name="sort" id="sort"  value="${model.sort}" style="width: 240px" maxlength="5"/>
						<span id="nameTip" class="onshow"></span>
					</dd>
		        	<dd>
	      				<span class="title">备&nbsp;&nbsp;&nbsp;&nbsp;注：</span>
	        			<input class="reg_input" name="remark" id="remark" value="${model.remark}" style="width: 240px"/>
	        			<span id="remarkTip" class="onshow"></span>
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
					$("#shopWareGroupFrm").form('submit',{
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
				location.href="${base}/manager/shopWareGroup/toPage";
			}
			
			$(function(){
			    $.formValidator.initConfig();
			    $("#name").formValidator({onShow:"请输入(25个字以内)",onFocus:"请输入(50个字以内)",onCorrect:"通过"}).inputValidator({min:1,max:50,onError:"请输入(50个字以内)"});
			});
		</script>	
	</body>
</html>
