<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>选择人员</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="falseaaa"
			url="manager/memberPage" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
					<th field="ck" checkbox="true">

					</th>
				    <th field="memberId" width="50" align="center" hidden="true">
						memberId
					</th>
					 <th field="branchId" width="50" align="center" hidden="true">
						branchId
					</th>
					<th field="memberNm" width="120" align="center">
						姓名
					</th>
					<th field="memberMobile" width="120" align="center" >
						手机号码
					</th>
					<th field="branchName" width="100" align="center" >
						部门
					</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:5px;height:auto">
		    姓名: <input name="memberNm" id="memberNm" style="width:100px;height: 20px;" onkeydown="toQuery(event);"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querymember();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:tochoice();">确定选择</a>
		</div>
		<script type="text/javascript">
		    //查询物流公司
			function querymember(){
				$("#datagrid").datagrid('load',{
					url:"manager/memberPage",
					memberNm:$("#memberNm").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					querymember();
				}
			}
			//选择确定
			function tochoice(){
			    var row = $('#datagrid').datagrid('getSelected');
				var ids = "";
				var names = "";
				var rows = $("#datagrid").datagrid("getSelections");
				for (var i = 0; i < rows.length; i++) {
					if (ids != "") {
						ids += ",";
						names+=",";
					}
					ids += rows[i].memberId;
					names += rows[i].memberNm;
				}
				if(ids==""){
					alert("请选择人员!");
				}
				window.parent.setMember(ids,names);
			}
		</script>
	</body>
</html>
