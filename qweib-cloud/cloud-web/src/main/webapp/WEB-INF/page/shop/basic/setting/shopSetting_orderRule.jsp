<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>自动收货时长设置</title>
	<%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<div class="box">
	<form action="manager/shopSetting/edit" name="shopRechargeFrm" id="shopRechargeFrm" method="post">
		<input  type="hidden" name="name" id="name" value="${name}"/>
		<dl id="dl">
			<dt class="f14 b">自动收货时长设置</dt>
			<dd>
				<span class="title">自动收货：</span>
				<input class="reg_input" name="automatic_delivery" id="automatic_delivery" value="${model.automatic_delivery}" style="width: 240px" maxlength="5"/>天(默认7天)
				<span id="automatic_deliveryTip" class="onshow"></span>
			</dd>
		</dl>
		<div class="f_reg_but" style="clear:both">
			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
			<input type="reset" value="重置" class="b_button"/>
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
		$("#automatic_delivery").formValidator({ onShow: "请输入数字", onCorrect: "通过" }).regexValidator({ regExp: "num", dataType: "enum", onError: "数字格式不正确" });
	});

	//提交数据
	function toSubmit(){
		if ($.formValidator.pageIsValid()==true){
			$("#shopRechargeFrm").form('submit',{
				dataType: 'json',
				success:function(data){
					if(data)
					alert(JSON.parse(data).msg)
				}
			});
		}
	}
</script>
</body>
</html>
