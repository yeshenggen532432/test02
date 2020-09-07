<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>分类列表</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js"></script>
	</head>
	<body>
		<table  id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
			url="manager/sortPage?groupId=${groupId }" title="分类列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="sortId" width="50" align="center" hidden="true">
						sortId
					</th>
					<th field="sortNm" width="280" align="center">
						分类名称
					</th>
					<th field="createTime" width="280" align="center">
						创建时间
					</th>
					<th field="memberNm" width="280" align="center">
						创建人
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			分类名称:<input name="sortNm" id="sortNm" style="width:76px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search"  href="javascript:querySorts();">查询</a>
			<input type="hidden" value="${groupId }" id="groupId"/>
			<!--圈群主、圈管理员具有添加删除权限  -->
			<c:if test="${(!empty usrRole) && usrRole=='1' || usrRole=='2' }">
				<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddsort();">添加</a>
				<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
			</c:if>
		</div>
		<!-- 增加分类弹窗 -->
		<div id="win" class="easyui-window" title="添加分类" style="width:350px;height:180px;" closed="true">  
		    <form id="frm" method="post" action="manager/addSort" style="padding:10px 20px 10px 40px;">  
		        <p>类别名称: <input type="text" name="sortNm" id="snm">
		        	<span style="color: red" id="nmspan">*</span>
		        </p> 
				<input type="hidden" name="groupId" id="gId"/>
		        </br> 
		        <div style="padding:5px;text-align:center;">  
		            <a href="javascript:addSort();" class="easyui-linkbutton" icon="icon-ok">确定</a>  
		            <a href="javascript:closeWin();" class="easyui-linkbutton" icon="icon-cancel">取消</a>  
		        </div>  
		    </form>  
		</div> 
		<script type="text/javascript">
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querySorts();
				}
			}
			//查询
			function querySorts(){
				$("#datagrid").datagrid('load',{
					url:"manager/sortPage",
					groupId:$("#groupId").val(),
					method:"post",
					sortNm:$("#sortNm").val()
				});
			}
			//添加
			function toaddsort(){
				$('#win').window('open');
				var groupId=$("#groupId").val();
				$("#gId").val(groupId);
			}
			function addSort(){
				var sortNm = $('#snm').val();
				if(sortNm.trim()==''){
					$("#nmspan").html("请填写类名");
					return;
				}
				$("#frm").form('submit',{
					success:function(data){
						if(data=='1'){
							alert("添加成功");
							document.getElementById('frm').reset();//重置表单
							$('#win').window('close');
							$("#datagrid").datagrid("reload");
						}else if(data=='-2'){
							alert("分类名已存在");
						}else if(data=='1'){
							alert("添加失败");
						}
					}
				});
			}
			function closeWin(){
				$('#win').window('close');
			}
			//删除
		    function toDel() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].sortId);
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/delSort",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
		</script>
	</body>
</html>
