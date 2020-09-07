<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/toAutoFieldPage" title="费用名称列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="name" width="280" align="center">
						名称
					</th>
					<th field="fdWay" width="280" align="center" formatter="fmtFdWay">
						费用方式
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddAutoField();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="AutoFieldDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/updateAutoField" id="AutoFieldFrm" name="AutoFieldFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    
				    <tr height="30px">
						<td align="left">
						    费用名称：
							<input class="reg_input" name="name" id="name" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
					<tr height="30px">
						<td align="left">
							费用方式：
							<select id="fdWay" name="fdWay">
								<option value="00" selected>按销售数量</option>
								<option value="01">按销售收入</option>
								<option value="02">按销售毛利</option>
							</select>
						</td>
					</tr>
				    <tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addAutoField();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideRoleWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			
			function queryAutoField(){
				$("#datagrid").datagrid('load',{
					url:"manager/toAutoFieldPage"
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryAutoField();
				}
			}
			function toaddAutoField(){
			    $("#id").val("");
			    toreset('AutoFieldFrm');
			    showAutoFieldWin("添加费用名称");
			}
			function hideRoleWin(){
				$("#AutoFieldDiv").window('close');
			}
			//显示费用名称框
			function showAutoFieldWin(title){
				$("#AutoFieldDiv").window({title:title});
				$("#AutoFieldDiv").window('open');
			}
			//添加费用名称
			function addAutoField(){
			    var name = $("#name").val();
				if(!name){
					alert("名称不能为空");
					return;
				}
				$('#AutoFieldFrm').form('submit', {
					success:function(data){
						$("#AutoFieldDiv").window('close');
						if(data=="1" || data=="2"){
							queryAutoField();
						}else{
						    alert("操作失败");
					        return;
						}
					}
				});
			}
			//获取选中行的值
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					$.ajax({
						url:"manager/getAutoField",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(json.id);
								$("#name").val(json.name);
								$("#fdWay").val(json.fdWay);
								showAutoFieldWin("修改费用名称");
							}
						}
					});
				}else{
					alert("请选择行");
				}
			}
		
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的费用名称?")){
						$.ajax({
							url:"manager/deleteautoFieldById",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      queryAutoField();
								    }else{
								      alert("删除失败");
					                  return;
								    }
								}
							}
						});
					}
				}
			}
			
			function fmtFdWay(val,row) {
				if(val=='00'){
					return "按销售数量";
				}else if(val=='01') {
					return "按销售收入";
				}else{
					return "按销售毛利";
				}
			}
		</script>
	</body>
</html>
