<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
			url="manager/corporationPage" title="公司列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="deptId" width="50" align="center" hidden="true">
						deptId
					</th>
					<th field="deptNm" width="150" align="center">
						公司名称
					</th>
					<th field="tpNm" width="80" align="center" >
						公司类型
					</th>
					<!--  <th field="deptPhone" width="120" align="center" >
						电话
					</th>
					<th field="deptNum" width="80" align="center" >
						规模
					</th>-->
					<th field="datasource" width="120" align="center" >
						数据库
					</th>
					<!--  <th field="deptAddr" width="180" align="center" >
						地址
					</th>-->
					<th field="memberNm" width="80" align="center" >
						创建人
					</th>
					<th field="addTime" width="100" align="center" >
						创建时间
					</th>
					<th field="endDate" width="100" align="center" >
						到期日期
					</th>
					<th field="oper1" width="120" align="center" formatter="formatterSt">
						操作
					</th>
					<th field="oper" width="200" align="center" formatter="formaterrmenu">
						分配权限
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			公司名称: <input name="deptNm" id="deptNm" style="width:156px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querycorporation();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" href="javascript:addcorporation();">创建</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" href="javascript:delcorporation();">删除</a>
		</div>
		<div id="addDiv" class="easyui-window" style="width:500px;height:250px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/addCorporation" id="addFrm" method="post">
				<input type="hidden" name="deptId" id="deptId"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100px" align="right">公司名称：</td>
						<td>
							<input class="reg_input" name="deptNm" id="deptNm"
								style="width:156px;height: 20px;"/>
							<span id="deptNmTip" class="onshow"></span>
						</td>
					</tr>
					<!--<tr>
						<td width="100px" align="right">公司规模：</td>
						<td>
							<select id="deptNum" name="deptNum">
								<option value="10-100人">10-100人</option>
								<option value="100-1000人">100-1000人</option>
								<option value="1万以内">1万以内</option>
							</select>
						</td>
					</tr>-->
					<tr>
						<td width="100px" align="right">公司类型：</td>
						<td>
							<select id="tpNm" name="tpNm">
								<c:forEach items="${list}" var="list">
			        			  <option value="${list.tpNm}">${list.tpNm}</option>
			        			 </c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td width="100px" align="right">联系人：</td>
						<td>
							<input class="reg_input" name="memberNm" id="memberNm"
								style="width:156px;height: 20px;"/>
						</td>
					</tr>
					<tr>
						<td width="100px" align="right">手机号：</td>
						<td>
							<input class="reg_input" name="mobile" id="mobile"
								style="width:156px;height: 20px;"/>
						</td>
					</tr>
					<!--<tr>
						<td width="100px" align="right">所属行业：</td>
						<td>
							<input class="reg_input" name="deptTrade" id="deptTrade"
								style="width:156px;height: 20px;"/>
						</td>
					</tr>-->
					<tr height="40px">
						<td align="center" colspan="2">
							<a class="easyui-linkbutton" href="javascript:toAdd();" >保存</a>
							<a class="easyui-linkbutton" href="javascript:hideAddWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="addDiv2" class="easyui-window" style="width:450px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/addCorporationRenew" id="addFrm2" method="post">
				<input type="hidden" name="deptsId" id="deptsId"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100px" align="right">续费时间：</td>
						<td>
							<input type="radio" name="renewTime" value="一个月" class="radio" checked="checked" />一个月
						    <input type="radio" name="renewTime" value="一季度" class="radio" />一季度
						    <input type="radio" name="renewTime" value="半年" class="radio" />半年
						    <input type="radio" name="renewTime" value="一年" class="radio" />一年
						    <input type="radio" name="renewTime" value="二年" class="radio" />二年
						    <input type="radio" name="renewTime" value="三年" class="radio" />三年
						</td>
					</tr>
					<tr height="40px">
						<td align="center" colspan="2">
							<a class="easyui-linkbutton" href="javascript:toAdd2();" >保存</a>
							<a class="easyui-linkbutton" href="javascript:hideAddWin2();">关闭</a>
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
				$("#deptNm").formValidator({onShow:"4-10个字符",onFocus:"4-10个字符",onCorrect:"通过"}).inputValidator({min:4,max:10,onError:"公司名称输入有误"});
			}
			//查询公司
			function querycorporation(){
				$("#datagrid").datagrid('load',{
					url:"manager/corporationPage",
					deptNm:$("#deptNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querycorporation();
				}
			}
			function delcorporation(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否删除该公司?")){
						$.ajax({
							url:"manager/deleteCorporation",
							data:"id="+row.deptId+"&datasource="+row.datasource,
							type:"post",
							success:function(data){
								if(data=='1'){
									alert("删除成功");
									$("#datagrid").datagrid("reload");
								}else{
									alert("删除失败");
								}
							}
						});
					}
				}else{
					alert("请选择行");
				}
			}
			//添加按钮事件
			function addcorporation(){
				toreset('addFrm');
				showAddWin("创建公司");
				toformyz();
			}
			//显示框
			function showAddWin(title){
				$("#addDiv").window({title:title});
				$("#addDiv").window('open');
			}
			function hideAddWin(){
				$("#addDiv").window('close');
			}
			function toAdd(){
			   var memberNm=$("#memberNm").val();
			   var mobile=$("#mobile").val();
			   if(!memberNm){
			     alert("联系人不能为空");
			     return;
			   }
			   if(!mobile){
			     alert("手机号不能为空");
			     return;
			   }
					$('#addFrm').form('submit', {
						success:function(data){
							if(data=="1"){
								$("#addDiv").window('close');
								$("#datagrid").datagrid("reload");
							}else if(data=="-2"){
								alert("该手机号已存在");
							}else if(data=="-3"){
								alert("该公司已存在，不能重复创建");
							}else{
								alert("创建公司失败");
							}
						}
					});
			}
			function formatterSt(val,row){
			    return "<input style='width:60px;height:27px' type='button' value='续费' onclick='updateRenew(this, "+row.deptId+")'/>";
			}
			//添加按钮事件
			function updateRenew(_this,deptId){
			     toreset('addFrm2');
				showAddWin2("续费");
				$("#deptsId").val(deptId);
			}
			//显示框
			function showAddWin2(title){
				$("#addDiv2").window({title:title});
				$("#addDiv2").window('open');
			}
			function hideAddWin2(){
				$("#addDiv2").window('close');
			}
			function toAdd2(){
			   $('#addFrm2').form('submit', {
					success:function(data){
						if(data=="1"){
							hideAddWin2();
							$("#datagrid").datagrid("reload");
						}else{
							alert("续费失败");
						}
					}
				});
			} 
			//分配菜单与应用
			//格式分配菜单应用
			function formaterrmenu(val,row){
				var hml;
				hml = '<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:tocompanymenuapply('+row.deptId+',1);"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配菜单</span></span></a>';
				hml+='<a class="easyui-linkbutton l-btn l-btn-plain" iconcls="icon-add" plain="true" href="javascript:tocompanymenuapply('+row.deptId+',2);"><span class="l-btn-left"><span class="l-btn-text icon-add l-btn-icon-left">分配APP应用</span></span></a>';
				return hml;
			}
			//分配权限
			function tocompanymenuapply(idKey, tp){
				window.parent.tocompanymenuapply(idKey, tp);
			}
		</script>
	</body>
</html>
