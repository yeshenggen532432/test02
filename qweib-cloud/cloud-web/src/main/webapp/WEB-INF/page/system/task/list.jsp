<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>任务列表</title>
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3" />
		<meta http-equiv="description" content="This is my page" />
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true" 
			url="manager/taskpages?parentId=${parentId }" title="任务列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						idKey
					</th>
					<th field="ck" checkbox="true"></th>
					<th field="taskTitle" width="280" align="center">
						任务标题
					</th>
					<th field="createTime" width="220" align="center">
						创建时间
					</th>
					<th field="startTime" width="220" align="center">
						开始时间
					</th>
					<th field="endTime" width="220" align="center">
						结束时间
					</th>
					<th field="status" width="150" align="center" formatter="vstatue">
						状态
					</th>
					<th field="createName" width="150" align="center" formatter="isnull">
						发布人
					</th>
					<th field="memberNm" width="150" align="center" formatter="isnull">
						执行人
					</th>
					<th field="supervisor" width="150" align="center" formatter="isnull">
						关注人
					</th>
					<th field="actTime" width="220" align="center" formatter="isnull">
						实际完成时间
					</th>
					<th field="percent" width="100" align="center" formatter="isnull2">
						完成进度
					</th>
					
					<th field="child" width="180" align="center"  formatter="ischild">
						任务节点
					</th> 
					<th field="cz" width="300" align="center" formatter="vcz">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			任务名称: <input name="taskTitle" id="taskTitle" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toadd();">添加</a>
			<c:if test="${type==2}">
				<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			</c:if>
		</div>
		
		<!--查看主/子任务详情弹窗 -->
		<div id="showWindow" class="easyui-window" style="width:1100px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowifrm" id="windowifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		<!--子任务修改页面弹窗-->
		<div id="choiceUpdateWindow" class="easyui-window" style="width:1100px;height:400px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true" modal="true">
			<iframe name="windowUpdateifrm" id="windowUpdateifrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
		</div>
		
		<script type="text/javascript">
			function nmvate(val){
				alert(val);
				return val;
			}
			function vstatue(val){
				if(val=="1"){
					return "<span style='color:blue'>进行中</span>";
				}else if(val=="2"){
					return "<span style='color:green'>完成</span>";
				}else if(val=="3"){
					return "<span style='color:red'>草稿</span>";
				}
			}
			//任务节点
			function ischild(val,row){
				if(row.parentId>0){
					return "<span><a href='javascript:showtask(1,"+row.id+");' title='查看主任务' style='text-decoration:none;'>子</></span>";
				}else{
					if(row.child==1){
						return "<span><a href='javascript:showtask(2,"+row.id+");' title='查看子任务' style='text-decoration:none;color: red;'>主</></span>";
					}else{
						return "<span><a title='无子任务' style='text-decoration:none;color: black;'>主</></span>";
					}
				}
			}
			// 查询主子任务 type=1查看主任务 2 查看子任务
			function showtask(type,taskId){
				if(type=="1"){
					showWindow("查看主任务");
				}else if(type=="2"){
					showWindow("查看子任务");
				}
				document.getElementById("windowifrm").src="<%=request.getContextPath()%>/manager/topctaskdetail?type="+type+"&taskId="+taskId;
			}
			//显示弹出窗口
			function showWindow(title){
				$("#showWindow").window({
					title:title,
					top:getScrollTop()+50
				});
				$("#showWindow").window('open');
			}
			function isnull(val){
				if(val==""|| typeof(val)=="undefined"){
					return "—";
				}else{
					return val;
				}
			}
			function isnull2(val){
				if(val==""|| typeof(val)=="undefined"){
					return "—";
				}else{
					return val+"%";
				}
			}
			function vcz(val,row){		
				var str='';
				if (row.status == 3) {//草稿无进度历史
					str = '<span style="color:grey;">进度历史</span>';
					//if (typeof(row.parentId) == "undefined" || row.parentId=="") {
						//str += '&nbsp;|&nbsp;<a href="javascript:toIssue();">发布</a>'
					//}
					str+='&nbsp;|&nbsp;<a href="javascript:toupdate(\''+row.taskTitle+'\','+row.id+','+row.parentId+')" style="text-decoration:none;">任务修改</a>';
				} else {
					var percent = row.percent;
					if(typeof(percent)=="undefined"){
						percent=0;
					}
					str = '<a href="javascript:detail(\''+row.taskTitle+'\','+row.id+','+percent+')" style="text-decoration:none;">进度历史</a>';
					str+='&nbsp;|&nbsp;<a href="javascript:mod(\''+row.taskTitle+'\','+row.id+')" style="text-decoration:none;">任务详情</a>';
					if(row.status == 1){//进行中增加催办操作
						str+='&nbsp;|&nbsp;<a href="javascript:cuiban('+row.id+')" style="text-decoration:none;">催办</a>';
					}
				}
				return str;
			}
			//催办
			function cuiban(tid){
				$.ajax({
					url:"manager/taskcbMsg",
					data:"tid="+tid,
					type:"post",
					success:function(data){
						alert(data.info);
					}
				});
			}
			//修改任务
			function toupdate(title,id,parentId){
				if (parentId > 0) {//子任务弹窗修改
					showUpdateWindow(title+"：修改子任务");
					document.getElementById("windowUpdateifrm").src="<%=request.getContextPath()%>/manager/toUpdateChild?taskId="+id;
				} else {//主任务
					//window.parent.add(title+"：修改主任务","manager/toupdatetask?id="+id);
					location.href="${base}/manager/toupdatetask?id="+id;
				}
			}
			//显示弹出窗口
			function showUpdateWindow(title){
				$("#choiceUpdateWindow").window({
					title:title,
					top:getScrollTop()+30
				});
				$("#choiceUpdateWindow").window('open');
			}
			//修改子任务后子窗口调用方法
			function closeUpdateWindow(taskTitle,id){
				$("#choiceUpdateWindow").window('close');
				query();
			}
			function detail(title,id,percent){
				window.parent.add(title+"：进度详情","manager/detailtaskfedd?id="+id+"&percent="+percent+"&title="+title);
			}
			function mod(title,id){
				window.parent.add(title+"：任务详情","manager/totaskbyid?id="+id);
			}
			function toadd(){
				location.href="${base}/manager/totaskadd";
				//var parentId = '${parentId}';
				//var parentName = '${parentName}';
				//if(parentId==""){
					//window.parent.add("任务添加","manager/totaskadd");
				//}else{
					//window.parent.add(parentName+"子任务添加","manager/totaskadd?parentId="+parentId);
				//}
			}
			function query(){
				var parentIds = '${parentId}';
				$("#datagrid").datagrid('load',{
					url:"manager/taskpages",
					taskTitle:$("#taskTitle").val(),
					parentId:parentIds
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			function toDel(){
				if(confirm("是否删除该任务以及子任务?")){
					var ids = [];
					var rows = $("#datagrid").datagrid("getSelections");
					for(var i=0;i<rows.length;i++){
						ids.push(rows[i].id);
					}
					if(ids.length>0){
					   $.ajax({
							url:"manager/deltasks",
							data:"ids="+ids,
							type:"post",
							success:function(json){
								if(json==1){	
									alert("删除成功");
									query();
								}else{
									alert("删除失败");
								}
							}
						});
				    }else{
				    	alert("请选择行");
				    }
			    }
			}
		</script>
	</body>
</html>
