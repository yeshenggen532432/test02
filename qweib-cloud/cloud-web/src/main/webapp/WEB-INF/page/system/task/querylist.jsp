<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
			url="manager/taskpages?id=${taskId}" title="任务列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
			data-options="onDblClickRow: tochoice">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						idKey
					</th>
					<th field="taskTitle" width="280" align="center">
						任务标题
					</th>
					<th field="startTime" width="180" align="center">
						开始时间
					</th>
					<th field="endTime" width="180" align="center">
						结束时间
					</th>
					<th field="mNm" width="180" align="center" >
						发布人
					</th>
					<th field="status" width="180" align="center" formatter="vstatue">
						状态
					</th>
					<th field="memberNm" width="180" align="center" formatter="isnull">
						责任人
					</th>
					<th field="supervisor" width="180" align="center" formatter="isnull">
						关注人
					</th>
					<th field="actTime" width="180" align="center" formatter="isnull">
						实际完成时间
					</th>
					<th field="percent" width="180" align="center" formatter="isnull">
						完成进度
					</th>
					<th field="parentTitle" width="180" align="center" formatter="isnull">
						所属任务
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			任务名称: <input name="taskTitle" id="taskTitle" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<script type="text/javascript">
			function vstatue(val){
				if(val=="1"){
					return "未完成";
				}else if(val=="2"){
					return "完成";
				}else if(val=="3"){
					return "草稿";
				}
			}
			function isnull(val){
				if(val==""){
					return "—";
				}
				return val;
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/taskpages",
					taskTitle:$("#taskTitle").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			//双击选择
			function tochoice(index){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					window.parent.setMem(row.id,row.taskTitle);
				}
			}
		</script>
	</body>
</html>
