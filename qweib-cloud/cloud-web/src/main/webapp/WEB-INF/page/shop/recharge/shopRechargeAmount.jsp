<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>充值面额分页</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
  
  <body>
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/shopRechargeAmount/page" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" checkbox="true"></th>
					<th field="czAmount" width="80" align="center" >
						充值面额
					</th>
					<th field="zsAmount" width="100" align="center">
						赠送面额
					</th>
					<th field="sum" width="100" align="center" formatter="formatterSum">
						总面额
					</th>
					<th field="status" width="100" align="center" formatter="formatterStatus">
						状态
					</th>
					<%--<th field="_oper" width="150" align="center" formatter="formatterOper">--%>
						<%--操作--%>
					<%--</th>--%>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    <!-- 名称: <input name="gradeName" id="gradeName" style="width:156px;height: 20px;" /> -->
			<!-- <a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a> -->
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:toedit();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:todel();">删除</a>
		</div>
		
		
		<!-- ===================================以下是js========================================= -->
		<script type="text/javascript">
		    //查询
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopRechargeAmount/page",
				});
			}
			
			//添加
			function toadd(){
				  window.location.href="${base}/manager/shopRechargeAmount/add";
			}
			
			//删除
			function todel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的行吗?")){
						$.ajax({
							url:"manager/shopRechargeAmount/delete",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("删除成功");
								    query();
								}else{
								    alert("删除失败");
								    return;
								}
							}
						});
					}
				}
			}
			
			//修改
			function toedit(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
				    var id = row.id;
					window.location.href="${base}/manager/shopRechargeAmount/edit?id="+id;
				}else{
					alert("请选择行");
				}
			}
			
			//状态
			function formatterStatus(val,row){
				var html ="";
				if(row.status=='0'){
					html= "<input value='不启用' style='width:50px' type='button' onclick='updateStatus("+row.id+",1)'/>";
				}else if(row.status=='1'){
					html="<input value='启用' style='width:50px' type='button' onclick='updateStatus("+row.id+",0)'/>";
				}
				return html;
			}
			function formatterOper(val,row){

			}
			//总面额
			function formatterSum(val,row){
			    return parseFloat(row.czAmount)+parseFloat(row.zsAmount);
			} 
			
			
			function updateStatus(id,status){
					if(confirm("是否确定操作?")){
						$.ajax({
							url:"manager/shopRechargeAmount/updateStatus",
							data:"id="+id+"&status="+status,
							type:"post",
							success:function(json){
								if(json=="1"){
								    alert("操作成功!");
								    query();
								}else{
								    alert("操作失败");
								    return;
								}
							}
						});
					}
			}
			
		</script>
  </body>
</html>
