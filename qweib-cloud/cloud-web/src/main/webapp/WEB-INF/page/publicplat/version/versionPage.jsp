<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>系统客户端版本管理</title>
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<style>
		.file-box{position:relative;width:70px;height: auto;}
		.uploadBtn{background-color:#FFF; border:1px solid #CDCDCD;height:22px;line-height: 22px;width:70px;}
		.uploadFile{ position:absolute; top:0; right:0; height:22px; filter:alpha(opacity:0);opacity: 0;width:70px;}
	</style>
	</head>
	<body>
		<table  id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryVersionPage" title="系统客户端版本列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="versionName" width="150" align="center">
						版本名称
					</th>
					<th field="versionTime" width="280" align="center">
						版本更新时间
					</th>
					<th field="memberNm" width="280" align="center">
						版本更新发布人
					</th>
					<th field="versionType" width="280" align="center" formatter="formatterLX">
						版本系统类型
					</th>
					<th field="isQz" width="280" align="center" formatter="formatter1">
						是否强制更新
					</th>
					<th field="opt" width="180" align="center" formatter="xg">
						操作
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			版本名称:<input name="versionName" id="versionName" style="width:76px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search"  href="javascript:queryVersion();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddVersion();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<script type="text/javascript">
			//推送按钮
			function xg(val,row){
				return '<a href="javascript:push('+row.id+')">推送</a>'+" "
			}
			//推送
			function push(id){
				if (id) {
					$.ajax( {
						url : "manager/verpush",
						data : "id=" + id,
						type : "post",
						success : function(json) {
							if (json == 1) {
								showMsg("推送成功");
								$("#datagrid").datagrid("reload");
							} else if (json == -1) {
								showMsg("推送失败");
							}
						}
					});
				}
			}
			//是否强制更新
			function formatter1(val,row){
				if(val=="1"){
					return "是";
				}else{
					return "否";
				}
			}
			//版本系统类型
			function formatterLX(val,row){
				if(val=="0"){
					return "Android版本";
				}else if(val=="1"){
					return "IOS版本";
				}else if(val=="2"){
					return "IOS市场版本";
				}else if(val=="4"){
					return "Android市场版本";
				}
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryVersion();
				}
			}
			//查询版本
			function queryVersion(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryVersionPage",
					versionName:$("#versionName").val()
				});
			}
			//添加会员
			function toaddVersion(){
				window.location.href="<%=request.getContextPath()%>/manager/toOperVersion";
			}
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否删除该成员?")){
						$.ajax({
							url:"manager/delVersion",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
									queryVersion();
									showMsg(json);
								}
							}
						});
					}
				}else{
					alert("请选择行");
				}
			}
			//获取选中行的值(修改)
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					window.location.href="${base}/manager/toOperVersion?id="+row.id;
				}else{
					alert("请选择行");
				}
			}
		</script>
	</body>
</html>
