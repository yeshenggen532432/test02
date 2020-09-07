<%@ page language="java" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>公告管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="<%=request.getContextPath()%>/resource/WdatePicker.js" defer="defer"></script>
	</head>
	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true"
			singleSelect="false" url="manager/truePage" title="真心话管理"
			iconCls="icon-save" border="false" rownumbers="true"
			fitColumns="true" pagination="true" pageSize=20
			pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="trueId" width="50" align="center" hidden="true">
						trueId
					</th>
					<th field="memberNm" width="180" align="center">
						发表人
					</th>
					<th field="title" width="180" align="center">
						标题
					</th>
					<th field="content" width="180" align="center">
						内容
					</th>
					<th field="trueCount" width="180" align="center" formatter="ts">
						跟帖人数
					</th>
					<th field="trueTime" width="180" align="center">
						发表时间
					</th>
					<th field="opt" width="180" align="center" formatter="xq">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding: 5px; height: auto">
			<%--发表人:
			<select name="memberId" id="memberId">
				<option value="">--请选择--</option>
				<c:forEach items="${mem}" var="m">
				<option value="${m.memberId}">${m.memberNm}</option>
				</c:forEach>
			</select>--%>
			标题：
			<input name="title" id="title"
				style="width: 100px; height: 18px;" onkeydown="toQuery(event);" />
			发表时间：
			<input type="text" name="startTime" id="startTime" value=""
				class="inputBg" style="width: 82px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			-
			<input type="text" name="endTime" id="endTime" value=""
				class="inputBg" style="width: 83px;"
				onClick="WdatePicker({'dateFmt':'yyyy-MM-dd'});" class="shortTxt" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search"
				href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true"
				href="javascript:toadd();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true"
				href="javascript:toDel();">删除</a>
		</div>
<script type="text/javascript">
//查询用户
function query() {
	$("#datagrid").datagrid('load', {
		url : "manager/truePage",
		title : $("#title").val(),
		memberId : $("#memberId").val(),
		startTime : $("#startTime").val(),
		endTime : $("#endTime").val()
	});
}
//回车查询
function toQuery(e) {
	var key = window.event ? e.keyCode : e.which;
	if (key == 13) {
		query();
	}
}
function toadd() {
	//window.parent.add("添加信息","manager/toOperTrue");
	location.href="${base}/manager/toOperTrue";
}
function toDel() {
	var ids = [];
	var rows = $("#datagrid").datagrid("getSelections");
	for ( var i = 0; i < rows.length; i++) {
		ids.push(rows[i].trueId);
	}
	if (ids.length > 0) {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
			if (r) {
				$.ajax( {
					url : "manager/delTrue",
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
function xq(val,row){
	return '<a href="javascript:update('+row.trueId+')">修改</a>'+" "+
		   '<a href="javascript:detail('+row.trueId+')">详情</a>';
}
function detail(id){
	//window.parent.add("详细真心话信息","manager/detailTrue?id="+id);
	location.href="${base}/manager/detailTrue?id="+id;
 }
function update(id){
	//window.parent.add("修改真心话信息","manager/toOperTrue?id="+id);
	location.href="${base}/manager/toOperTrue?id="+id;
 }
function ts(val,row){
    if(val==null){
		return 0;
	}
	return val;
}
</script>
	</body>
</html>
