<%@ page language="java" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>真心话管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>		
<div class="box" >
			<form action="manager/operTrue" name="usrFrm" id="usrFrm" method="post" enctype="multipart/form-data">
				<dl>
					<dd>
						<input type="hidden"  name="trueId" id="trueId" value="${bsctrue.trueId }"/>
						<input type="hidden" name="memberId" id="memberId" value="${bsctrue.memberId}"/>
	      				<input type="hidden" id="trueTime" name="trueTime" value="${bsctrue.trueTime}"/>
	      				<input type="hidden" id="trueCount" name="trueCount" value="${bsctrue.trueCount}"/>
	        		</dd>
	        		<dd>
	      				<span class="title">标题：</span>
		      				<input class="reg_input" name="title" id="title" value="${bsctrue.title}" style="width: 156px; height: 20px;" />
							<span id="titleTip" class="onshow"></span>
	        		</dd>
	        		<dt class="f14 b"></dt>	        		
					<dd>
	        			<textarea name="content" id="content" class="reg_input"
								style="width: 350px; height: 290px;padding-left: 50px;">${bsctrue.content}</textarea>
	 				</dd>	 				
				</dl>			
				<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="save();"/>
	    			<input type="button" value="返回" class="b_button" onclick="toback();"/>
	     		</div>
			</form>
	</div>
<script type="text/javascript">
$(function() {	
	$.formValidator.initConfig();
	$("#title").formValidator( {
		onShow : "请输入标题",
		onFocus : "2-40个字符",
		onCorrect : "（正确）"
	}).inputValidator( {
		min : 2,
		max : 40,
		onError : "标题在2-40个字符之间"
	});
	addEditor("content","usrFrm","<%=request.getContextPath()%>");
});

//添加用户
function save() {
	kindEditor.sync();
	if ($.formValidator.pageIsValid() == true) {
		$('#usrFrm').form('submit', {
			success : function(data) {
				if (data == "1") {
					alert("添加成功");
					//window.location.reload();
					toback();
				} else if (data == "2") {
					alert("修改成功");
				} else {
					alert("操作失败");
					return;
				}
			}
		});
	}
}
function toback(){
	location.href="${base}/manager/totrue";
}
</script>
	</body>
</html>
