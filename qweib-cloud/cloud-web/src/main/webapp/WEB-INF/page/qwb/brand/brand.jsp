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
			url="manager/toBrandPage" title="品牌列表" iconCls="icon-save" border="false"
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
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			品牌名称: <input name="name" id="name" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryBrand();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddBrand();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="brandDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/operBrand" id="brandFrm" name="brandFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr height="30px">
						<td align="center">
						    品牌名称：
							<input class="reg_input" name="name" id="name2" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addBrand();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideBrandWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			function queryBrand(){
				$("#datagrid").datagrid('load',{
					url:"manager/toBrandPage",
					name:$("#name").val()
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryBrand();
				}
			}
			function toaddBrand(){
			    $("#id").val("");
			    toreset('brandFrm');
			    showBrandWin("添加品牌名称");
			}
			function hideBrandWin(){
				$("#brandDiv").window('close');
			}
			function showBrandWin(title){
				$("#brandDiv").window({title:title});
				$("#brandDiv").window('open');
			}
			function addBrand(){
			    var name = $("#name2").val();
				if(!name){
					alert("品牌名称不能为空");
					return;
				}

				$('#brandFrm').form('submit', {
					success:function(data){
						$("#brandDiv").window('close');
						if(data=="1" || data=="2"){
							queryBrand();
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
						url:"manager/getBrand",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(json.id);
								$("#name2").val(json.name);
								showBrandWin("修改品牌名称");
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
					if(confirm("是否要删除选中的品牌名称?")){
						$.ajax({
							url:"manager/deleteBrandById",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      queryBrand();
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
