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
			singleSelect="false" url="manager/pnoticePage" title="公告管理"
			iconCls="icon-save" border="false" rownumbers="true"
			fitColumns="true" pagination="true" pageSize=20
			pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true"></th>
					<th field="noticeId" width="50" align="center" hidden="true">
						noticeId
					</th>
					<th field="memberNm" width="180" align="center">
						发表人
					</th>
					<th field="noticeTitle" width="180" align="center">
						标题
					</th>
					<th field="noticeTp" width="180" align="center" formatter="tp">
						通知类型
					</th>
					<th field="noticeTime" width="180" align="center">
						通知时间
					</th>
					<th field="isPush" width="180" align="center" formatter="ts">
						是否推送
					</th>
					<th field="opt" width="180" align="center" formatter="xg">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding: 5px; height: auto">
			标题：
			<input name="noticeTitle" id="noticeTitle"
				style="width: 100px; height: 18px;" onkeydown="toQuery(event);" />
			通知时间：
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
		url : "manager/pnoticePage",
		noticeTitle : $("#noticeTitle").val(),
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
	//window.parent.add("添加信息","manager/toOperNotice");
	location.href="${base}/manager/ptoOperNotice";
}
function toDel() {
	var ids = [];
	var rows = $("#datagrid").datagrid("getSelections");
	for ( var i = 0; i < rows.length; i++) {
		ids.push(rows[i].noticeId);
	}
	if (ids.length > 0) {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
			if (r) {
				$.ajax( {
					url : "manager/pdelNotice",
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
function xg(val,row){
	return '<a href="javascript:update('+row.noticeId+')">修改</a>'+" "+
		   '<a href="javascript:push('+row.noticeId+','+row.noticeTp+')">推送</a>'+" "+
		   '<a href="javascript:detail('+row.noticeId+')">详情</a>';
}
function detail(id){
	//window.parent.add("详细公告信息","manager/detailNotice?id="+id);
	 location.href="${base}/manager/pdetailNotice?id="+id;
 }
function update(id){
	//window.parent.add("修改公告信息","manager/toOperNotice?id="+id);
	 location.href="${base}/manager/ptoOperNotice?id="+id;
 }
function push(id,noticeTp){
	if (id) {
		$.ajax( {
			url : "manager/pisPush",
			data : "id=" + id+"&noticeTp="+noticeTp,
			type : "post",
			success : function(json) {
				if (json == 1) {
					showMsg("推送成功");
					$("#datagrid").datagrid("reload");
				} else if (json == -1) {
					showMsg("推送失败");
				}else if(json ==2){
					showMsg("已推送");
				}
			}
		});
	}
}
function ts(val,row){
    if(val=="1"){
		return "是";
	}
	else if(val=="2"){
		return "否";
	}			
	return "";
}
function tp(val,row){
	if(val=="3"){
		return "园区公告";
	}else if(val=="2"){
		return "企业公告";
	}else if(val=="1"){
		return "系统公告";
	}else if(val=="4"){
		return "购划算";
	}
	return "";
}
</script>
	</body>
</html>
