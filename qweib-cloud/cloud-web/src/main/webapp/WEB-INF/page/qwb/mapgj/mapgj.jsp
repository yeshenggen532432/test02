<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>卡宝包</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryMapGjPage?dataTp=${dataTp }" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="userId" width="10" align="center" hidden="true">
						用户id
					</th>
					<th field="userNm" width="100" align="center">
						业务员名称
					</th>
					<th field="userTel" width="80" align="center">
						电话
					</th>
					<th field="times" width="100" align="center">
						时间
					</th>
					<th field="address" width="120" align="center">
						地址
					</th>
					<th field="zt" width="60" align="center">
						状态
					</th>
					<th field="userHead" width="60" align="center" formatter="formatterSt">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		</div>
		<script type="text/javascript">
		    function formatterSt(v,row){
				return '<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:todetail(\''+row.userNm+'\','+row.userId+');">轨迹回放</a>';
			}
			function todetail(title,id){
				window.parent.add(title,"manager/queryMapGjOne?mid="+id);
			}
		</script>
	</body>
</html>
