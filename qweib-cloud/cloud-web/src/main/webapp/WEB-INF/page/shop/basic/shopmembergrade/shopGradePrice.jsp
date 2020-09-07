<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>会员等级价格设置</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="resource/loadDiv.js"></script>
	</head>
  
  <body>
  <%--data-options="onDblClickRow: onDblClickRow"--%>
    <table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="false"
		url="manager/shopMemberGrade/page?status=1" border="false"
		rownumbers="true" fitColumns="false" pagination="true"
		pageSize=20 pageList="[10,20,50,100,200,500,1000]"   toolbar="#tb" >
		<thead>
			<tr>
				<%--<th  field="id" checkbox="true"></th>--%>
				<th field="gradeName" width="80" align="center" >
					名称
				</th>
				<th field="oper" width="150" align="center" formatter="formatterOper">
					操作
				</th>
				<th field="gradeNo" width="100" align="center">
					级别
				</th>
				<th field="status" width="100" align="center" formatter="formatterStatus">
					状态
				</th>
				<th field="isJxc" width="120" align="center" formatter="formatterIsJxc">
					进销存客户会员使用
				</th>
			</tr>
		</thead>
	</table>

	<div id="tb" style="padding:5px;height:auto">
		等级名称: <input name="gradeName" id="gradeName" style="width:156px;height: 20px;" />
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>
	</div>
		<!-- ===================================以下是js========================================= -->
		<script type="text/javascript">
			//查询
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/shopMemberGrade/page",
					gradeName:$("#gradeName").val(),
				});
			}

			function formatterStatus(val,row){
		      	if(val=='0'){
		             return "未启用";
		        }else if(val=='1'){
		             return "启用";
		        }
			}
			function formatterIsJxc(val,row){
				if(row.isJxc === 1){
					return '是';
				}
			}

			function formatterOper(val,row){
				var id = row.id;
				var gradeName = row.gradeName;
				return "<input value='设置商品价格' type='button' onclick='setPrice("+id+",\""+gradeName.toString()+"\")' />";
			}

			function setPrice(id,gradeName){
				parent.closeWin("等级价格设置_"+gradeName);
				window.parent.add("等级价格设置_"+gradeName,"manager/shopMemberGrade/gradePriceWaretype?gradeId="+id);
			}

		</script>
  </body>
</html>
