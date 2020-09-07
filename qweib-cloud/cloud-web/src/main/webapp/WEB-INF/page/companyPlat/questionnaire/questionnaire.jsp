<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>企微宝管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/questionnairepages" title=" 问卷列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pageSize=20 pageList="[10,20,50,100,200]" toolbar="#tb">
			<thead>
				<tr>
					<th field="qid" hidden="true" width="50"> 
						qid
					</th>
					<th field="title" width="150" align="center">
						标题
					</th>
					<th field="dsck" width="80" align="center" formatter="formatterSt">
						单多选项
					</th>
					<th field="stime" width="120" align="center">
						发布时间
					</th>
					<th field="memberNm" width="80" align="center">
						发布者
					</th>
					<th field="etime" width="120" align="center">
						截止时间
					</th>
					<th field="branchName" width="120" align="center">
						部门
					</th>
					<th field="opt" width="80" align="center" formatter="tj">
						操作
					</th>
				</tr>
				
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			标题:<input name="title" id="title" style="width:150px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryquestionnaire();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddquestionnaire();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-tip" plain="true" href="javascript:toxq();">详情</a>
			<!--  <a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>-->
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		
		<script type="text/javascript">
		   function formatterSt(val,row){
				if(val==0){
					return "不限制";
				}else if(val==1){
					return "单选项";
				}else{
				   return val+"选项";
				}
				
			}
			
			//查询问卷
			function queryquestionnaire(){
				$("#datagrid").datagrid('load',{
					url:"manager/questionnairepages",
					title:$("#title").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryquestionnaire();
				}
			}
			//添加
			function toaddquestionnaire(){
				location.href="${base}/manager/tooperquestionnaire";
			}
			//获取选中行的值（详情）
			function toxq(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/tooperquestionnaire?qid="+row.qid+"&tp=1";
				}else{
					alert("请选择要查看的行！");
				}
			}
			//获取选中行的值（修改）
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					location.href="${base}/manager/tooperquestionnaire?qid="+row.qid;
				}else{
					alert("请选择要修改的行！");
				}
			}
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除该问卷?")){
						$.ajax({
							url:"manager/delquestionnaire",
							data:"qid="+row.qid,
							type:"post",
							success:function(data){
							   if(data=="1"){
							       alert("删除成功");
							       queryquestionnaire();
							   }else{
							       alert("删除失败");
							       return;
							   }	
								
							}
						});
					}
				}else{
				   alert("请选择要删除的行！");
				}
			}
			function tj(val,row){
				return '<a href="javascript:count('+row.qid+')">投票统计</a>';
			}
			function count(qid){
				location.href="${base}/manager/counting?qid="+qid;
			}
		</script>
	</body>
</html>
