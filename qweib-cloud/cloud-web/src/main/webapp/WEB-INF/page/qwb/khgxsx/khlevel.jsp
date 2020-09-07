<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
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
			url="manager/toKhlevelPage" title="客户等级列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" pagePosition=3
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="id" width="50" align="center" hidden="true">
						id
					</th>
					<th field="qdtpNm" width="280" align="center">
						客户类型名称
					</th>
					<th field="khdjNm" width="280" align="center">
						客户等级名称
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
			客户等级名称: <input name="khdjNm" id="khdjNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryKhlevel();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:toaddKhlevel();">添加</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:getSelected();">修改</a>
			<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" href="javascript:setLevelPrice();">按客户等级设置商品销售价格</a>
			<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" href="javascript:toDel();">删除</a>
		</div>
		<div id="KhlevelDiv" class="easyui-window" style="width:400px;height:150px;padding:10px;" 
			minimizable="false" maximizable="false" collapsible="false" closed="true">
			<form action="manager/operKhlevel" id="KhlevelFrm" name="KhlevelFrm" method="post">
				<input type="hidden" name="id" id="id"/>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr height="30px">
						<td align="center">
						    客户类型名称: 
						    <c:if test="${!empty list}">
						    <select name="qdId" id="qdId" style="width:120px;">
							<c:forEach items="${list}" var="list">
							<option value="${list.id}">${list.qdtpNm}</option>
							</c:forEach>
						    </select>
					        </c:if>
						</td>
					</tr>
				    <tr height="30px">
						<td align="center">
						    客户等级名称：
							<input class="reg_input" name="khdjNm" id="khdjNm2" 
								style="width:120px;height: 20px;" />
						</td>
					</tr>
				    <tr height="40px">
						<td align="center">
							<a class="easyui-linkbutton" href="javascript:addKhlevel();">保存</a>
							<a class="easyui-linkbutton" href="javascript:hideRoleWin();">关闭</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<script type="text/javascript">
			
			//查询客户等级
			function queryKhlevel(){
				$("#datagrid").datagrid('load',{
					url:"manager/toKhlevelPage",
					khdjNm:$("#khdjNm").val()
					
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryKhlevel();
				}
			}
			function toaddKhlevel(){
			    $("#id").val("");
			    toreset('KhlevelFrm');
			    showKhlevelWin("添加客户等级");
			}
			function hideRoleWin(){
				$("#KhlevelDiv").window('close');
			}
			//显示客户等级框
			function showKhlevelWin(title){
				$("#KhlevelDiv").window({title:title});
				$("#KhlevelDiv").window('open');
			}
			//添加客户等级
			function addKhlevel(){
			    var khdjNm = $("#khdjNm2").val();
				if(!khdjNm2){
					alert("客户等级名称不能为空");
					return;
				}
				$('#KhlevelFrm').form('submit', {
					success:function(data){
						$("#KhlevelDiv").window('close');
						if(data=="1" || data=="2"){
							queryKhlevel();
						}else{
						    alert("操作失败");
					        return;
						}
					}
				});
			}
			//获取选中行的值
			function getSelected(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					$.ajax({
						url:"manager/getKhlevel",
						data:"id="+row.id,
						type:"post",
						success:function(json){
							if(json){
							    $("#id").val(json.id);
								$("#qdId").val(json.qdId);
								$("#khdjNm2").val(json.khdjNm);
								showKhlevelWin("修改客户等级");
							}
						}
					});
				}else{
					alert("请选择行");
				}
			}
			function setLevelPrice(){
					window.parent.add("按客户等级设置商品销售价格","manager/levelpricewaretype");
			}
			//删除
			function toDel(){
				var row = $('#datagrid').datagrid('getSelected');
				if (row){
					if(confirm("是否要删除选中的客户等级?")){
						$.ajax({
							url:"manager/deletekhlevelById",
							data:"id="+row.id,
							type:"post",
							success:function(json){
								if(json){
								    if(json=='1'){
								      alert("删除成功");
								      queryKhlevel();
								    }else{
								      alert("删除失败");
					                  return;
								    }
								}
							}
						});
					}
				}
			}
		</script>
	</body>
</html>
