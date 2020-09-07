<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>企微宝</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/logisticsPage" title="物流公司列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						物流公司id
					</th>
					<th field="wlNm" width="100" align="center">
						名称
					</th>
					<th field="dcode" width="80" align="center" >
						代码
					</th>
					<th field="linkman" width="80" align="center" >
						联系人
					</th>
					<th field="tel" width="80" align="center" >
						联系电话
					</th>
					<th field="address" width="120" align="center" >
						地址
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			名称: <input name="wlNm" id="wlNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querylogistics();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddlogistics();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
		</div>
		<script type="text/javascript">
		    //查询物流公司
			function querylogistics(){
				$("#datagrid").datagrid('load',{
					url:"manager/logisticsPage",
					wlNm:$("#wlNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querylogistics();
				}
			}
			//添加
			function toaddlogistics(){
				location.href="${base}/manager/tooperlogistics";
			}
			//修改
			function getSelected(){
			  var rows = $("#datagrid").datagrid("getSelections");
			  if(rows.length<=1){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/tooperlogistics?Id="+row.id;
				}else{
					alert("请选择要修改的行！");
				}
			  }else{
			       alert("不能选择多行");
			  }	
			}
		</script>
	</body>
</html>
