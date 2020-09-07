<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>选择批次号</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body>
	<table id="datagrid"  class="easyui-datagrid"  fit="true" singleSelect="false"
		   url="manager/customerPage"
		   iconCls="icon-save" border="false"
		   rownumbers="true" fitColumns="false" pagination="true"
		   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead >
		<tr>
			<th field="id" width="50" align="center" hidden="true">
				客户id
			</th>
			<th field="khCode" width="80" align="center" >
				客户编码
			</th>
			<th field="khNm" width="120" align="center" >
				客户名称
			</th>
			<th field="linkman" width="100" align="center" >
				负责人
			</th>
			<th field="tel" width="120" align="center" >
				负责人电话
			</th>
			<th field="mobile" width="120" align="center" >
				负责人手机
			</th>
			<th field="address" width="275" align="center" >
				地址
			</th>
			<th field="memberNm" width="120" align="center" >
				业务员
			</th>
			<th field="memberMobile" width="120" align="center" >
				业务员手机号
			</th>
		</tr>
		</thead>
	</table>
	<div id="tb" style="padding:5px;height:auto">
		客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
		<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
	</div>
		<script type="text/javascript">
			function query() {
				$("#datagrid").datagrid('load', {
					url: "manager/customerPage",
					khTp:2,
					khNm:$("#khNm").val(),
					isDb:2
				});
			}
			function onDblClickRow(rowIndex, rowData)
		    {
				window.parent.setMember(rowData.id+"",rowData.khNm+"");
		    }
		</script>
	</body>
</html>
