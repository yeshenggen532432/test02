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
			url="manager/toQdtypePage" title="客户类型列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="coding" width="280" align="center">
						编码
					</th>
					<th field="qdtpNm" width="280" align="center">
						客户类型名称
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			客户类型名称: <input name="qdtpNm" id="qdtpNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryQdtype();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddQdtype();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="QdtypeDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/operQdtype" id="QdtypeFrm" name="QdtypeFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr height="30px">
						<td align="center">
						    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						    编码：
							<input class="reg_input" name="coding" id="coding" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="30px">
						<td align="center">
						    客户类型名称：
							<input class="reg_input" name="qdtpNm" id="qdtpNm2" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addQdtype();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideRoleWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			
			//查询渠道类型
			function queryQdtype(){
				$("#datagrid").datagrid('load',{
					url:"manager/toQdtypePage",
					qdtpNm:$("#qdtpNm").val()
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryQdtype();
				}
			}
			function toaddQdtype(){
			    $("#id").val("");
			    toreset('QdtypeFrm');
			    showQdtypeWin("添加客户类型");
			}
			function hideRoleWin(){
				$("#QdtypeDiv").window('close');
			}
			//显示渠道类型框
			function showQdtypeWin(title){
				$("#QdtypeDiv").window({title:title});
				$("#QdtypeDiv").window('open');
			}
			//添加渠道类型
			function addQdtype(){
			    var qdtpNm = $("#qdtpNm2").val();
				if(!qdtpNm){
					alert("客户类型名称不能为空");
					return;
				}
				var coding = $("#coding").val();
				if(!coding){
					alert("编码不能为空");
					return;
				}
				$('#QdtypeFrm').form('submit', {
					success:function(data){
						$("#QdtypeDiv").window('close');
						if(data=="1" || data=="2"){
							queryQdtype();
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
						url:"manager/getQdtype",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(json.id);
								$("#qdtpNm2").val(json.qdtpNm);
								$("#coding").val(json.coding);
								showQdtypeWin("修改客户类型");
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
					if(confirm("是否要删除选中的客户类型?")){
						$.ajax({
							url:"manager/deleteQdtypeById",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      queryQdtype();
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
		</script>
	</body>
</html>
