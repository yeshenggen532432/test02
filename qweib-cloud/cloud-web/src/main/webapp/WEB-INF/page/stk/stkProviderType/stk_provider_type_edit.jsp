<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>供应商类别设置</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
	
		<div class="box">
  			<form action="manager/stkProviderType/save" name="voForm" id="voForm" method="post">
  			    <dl id="dl">
	      			<dt class="f14 b">供应商类别信息</dt>
	        		<dd>
	      				<span class="title">名称：</span>
						<input class="reg_input" type="hidden" name="id" id="id" value="${vo.id}" style="width: 120px"/>
	        			<input class="reg_input" name="name" id="name" value="${vo.name}" style="width: 120px"/>
	        		</dd>
	        		<dd>
	      				<span class="title">备注：</span>
	        			<textarea rows="4" cols="50" name="remark" id="remark">${vo.remark}</textarea>
	        		</dd>
	        	</dl>
	    		<div class="f_reg_but">
	    			<input type="button" value="保存" class="l_button" onclick="toSubmit();"/>
	     		</div>
	  		</form>
		</div>
		<script type="text/javascript">

			function toSubmit(){
				var name=$("#name").val();
				if(name==""){
					alert("请输入名称");
					return;
				}
				$("#voForm").form('submit',{
					success:function(data){
						var json = eval("("+data+")");
						if(json.state){
							alert(json.msg);
							$("#id").val(json.id);
						}else{
							alert("添加失败！");
						}
					}
				});
			}

		</script>
	</body>
</html>
