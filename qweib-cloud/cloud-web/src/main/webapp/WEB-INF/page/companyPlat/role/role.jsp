<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>公司角色管理</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/rolepages_company" title="公司角色列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="idKey" width="50" align="center" hidden="true">
						idKey
					</th>
					<th field="roleNm" width="280" align="center">
						角色名称
					</th>
					<th field="oper" width="180" align="center" formatter="formaterrmenu">
						分配权限
					</th>
					<th field="areaName" width="180" align="center" formatter="formaterrusr">
						分配用户
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			角色名称: <input name="roleNm" id="roleNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryRole();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddrole();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="roleDiv" class="easyui-window" style="width:500px;height:260px;padding:10px;"
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/operCompanyrole_company" id="roleFrm" method="post">
				<input type="hidden" name="idKey" id="idKey"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="70px" align="right">角色名称：</td>
						<td>
							<input class="reg_input" name="roleNm" id="roleName"
								style="width:156px;height: 20px;"/>
							<span id="roleNameTip" class="onshow"></span>
							<input type="button" onclick="" value="用户"/>
						</td>
					</tr>
					<tr height="130px">
						<td align="right">角色描述：</td>
						<td style="margin-top: 10px;">
							<textarea class="reg_input" name="remo" id="remo" style="width:200px;height:80px;"></textarea>
							<span id="remoTip" class="onshow"></span>
						</td>
					</tr>
					<tr height="40px">
						<td align="center" colspan="2">
							<a class="easyui-linkbutton" href="javascript:addRole();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideRoleWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			$(function(){
				$.formValidator.initConfig();
				toformyz();
			});
			//表单验证
			function toformyz(){
				$("#roleName").formValidator({onShow:"4-40个字符",onFocus:"4-40个字符",onCorrect:"通过"}).inputValidator({min:4,max:40,onError:"角色名称输入有误"});
				$("#remo").formValidator({onShow:"100个字符以内",onFocus:"100个字符以内",onCorrect:"通过"}).inputValidator({max:100,onError:"100个字符以内"});
			}
			//格式分配用户
			function formaterrusr(val,row){
			  	if(row.roleCd == "company_creator"){//公司创建者
                    return '创建者：${companyCreator.name}';
				}else{
			  	    if(row.roleCd == "company_admin"){//公司管理员
                        return '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:toRoleManager('+row.idKey+');"><span class="l-btn-left"><span class="l-btn-text icon-remove l-btn-icon-left">移除管理员</span></span></a>&nbsp;&nbsp;&nbsp;<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:toRoleTransferManager('+row.idKey+');"><span class="l-btn-left"><span class="l-btn-text icon-redo l-btn-icon-left">转移管理员</span></span></a>';

					}else{
                        return '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:toroleusr('+row.idKey+');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配用户</span></span></a>';
					}
				}
			}
			//分配用户
			function toroleusr(idKey){
				window.parent.toroleusr(idKey);
			}
            //移除创建者
            function toRoleCreator(idKey){
				$.ajax( {
					url : "manager/member/has_creator",
					type : "GET",
					dataType: "json",
					success : function(response) {
						if (response.code == 200) {
							window.parent.toRoleCreator(idKey);
						} else {
							alert(response.message);
						}
					}
				});
            }
            //移除管理员
            function toRoleManager(idKey){
				$.ajax( {
					url : "manager/member/has_admin",
					type : "GET",
					dataType: "json",
					success : function(response) {
						if (response.code == 200) {
							window.parent.toRoleManager(idKey);
						} else {
							alert(response.message);
						}
					}
				});
            }
            //转移管理员
            function toRoleTransferManager(idKey){
				$.ajax( {
					url : "manager/member/has_admin",
					type : "GET",
					dataType: "json",
					success : function(response) {
						if (response.code == 200) {
							window.parent.toRoleTransferManager(idKey);
						} else {
							alert(response.message);
						}
					}
				});
            }
			//格式分配权限
			function formaterrmenu(val,row){
				var hml='';
				if(row.roleCd == "company_creator") {
					hml += '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',1, \'company_creator\');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配菜单</span></span></a>';
					hml+='<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',2, \'company_creator\');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配应用</span></span></a>';
				} else if (row.roleCd == "company_admin") {
					hml += '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',1, \'company_admin\');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配菜单</span></span></a>';
					hml+='<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',2, \'company_admin\');"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配应用</span></span></a>';
				} else {
					hml += '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',1);"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配菜单</span></span></a>';
					hml+='<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:torolemenuapply('+row.idKey+',2);"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配应用</span></span></a>';
				}
				return hml;
			}
			//分配权限
			function torolemenuapply(idKey, tp, creatorAndAdmin){
				window.parent.torolemenuapply(idKey, tp, creatorAndAdmin);
			}
			//查询角色
			function queryRole(){
				$("#datagrid").datagrid('load',{
					url:"manager/rolepages_company",
					roleNm:$("#roleNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryRole();
				}
			}
			function toaddrole(){
				toreset('roleFrm');
				$("#idKey").val("");
				showRoleWin("添加公司角色");
				toformyz();
			}
			//显示角色框
			function showRoleWin(title){
				$("#roleDiv").window({title:title,modal:true});
				$("#roleDiv").window('open');
			}
			function hideRoleWin(){
				$("#roleDiv").window('close');
			}
			//添加角色
			function addRole(){
				if ($.formValidator.pageIsValid()==true){
					$('#roleFrm').form('submit', {
						success:function(data){
							$("#roleDiv").window('close');
							showMsg(data);
							if(data=="1" || data=="2"){
								queryRole();
							}
						}
					});
				}
			}
			//获取选中行的值
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					var roleCd =row.roleCd;
					if (roleCd == 'company_creator' || roleCd == 'company_admin') {
						alert("系统角色不可删除");
						return;
					}
					$.ajax({
						url:"manager/getrole_company",
						data:"id="+row.idKey,
						type:"post",
						success:function(json){
							if(json){
								$("#idKey").val(json.idKey);
								$("#roleName").val(json.roleNm);
								$("#remo").val(json.remo);
								toformyz();
								showRoleWin("修改角色");
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
					var roleCd =row.roleCd;
					if (roleCd == 'company_creator' || roleCd == 'company_admin') {
						alert("系统角色不可删除");
						return;
					} else {
						if(confirm("是否删除该角色?")){
							$.ajax({
								url:"manager/delrole_company",
								data:"id="+row.idKey,
								type:"post",
								success:function(response){
									showMsg(response.message);
									if(response.code == 200){
										queryRole();
									}
								}
							});
						}
					}
				}
			}
		</script>
	</body>
</html>
