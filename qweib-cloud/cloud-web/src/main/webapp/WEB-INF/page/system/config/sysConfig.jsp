<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>系统参数配置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>
	<body>
		<div class="box">
		  <dl id="dl">
		  <dd>
			<table style="margin-top: 10px;border:1px solid teal;">
				<c:forEach items="${datas }" var="data" varStatus="s">
				<tr style="height: 25px;border:1px solid teal;">
	      				<td style="text-align: right;border:1px solid teal;">${data.name}：</td>
	      				<td width="200px" style="padding-left: 5px">
	      				<input type="checkbox" name="${data.code}" onclick="updateConfig(this,'${data.code}','${data.id}','${data.name}')" id="${data.code}" ${data.status eq '1'?'checked':'' }>
	      				</td>
	        	</tr>
				</c:forEach>
			</table>
			</dd>
			</dl>	
		</div>
		<script type="text/javascript">
		   function updateConfig(o,code,id,name){
			   var status = "0";
			   if(o.checked){
				   status = "1";
			   }
			   $.ajax( {
					url : "manager/sysConfig/updateConfig",
					data :  {id:id,code:code,status:status,name:name},
					type : "post",
					success : function(json) {
						if (json.state) {
							 $.messager.alert('消息','操作成功!','info');
						} else{
							$.messager.alert('消息','操作失败!','info');
						}
					}
				});
		   }
		   function addConfig(){
				$('#configFrm').form('submit', {
					success:function(data){
						
					}
				});
		  }
			
		</script>
	</body>
</html>
