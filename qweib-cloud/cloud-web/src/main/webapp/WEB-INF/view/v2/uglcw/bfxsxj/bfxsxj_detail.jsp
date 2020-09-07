<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
	</head>

	<body>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			url="manager/queryBfxsxjDetail?wid=${wid}&cid=${cid}&sdate=${sdate}&edate=${edate}" title="销售小结信息列表" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						销售小结id
					</th>
					<th field="xjdate" width="100" align="center">
						日期
					</th>
					<th field="wareNm" width="100" align="center">
						品项
					</th>
					<th field="dhNum" width="80" align="center">
						到货量
					</th>
					<th field="sxNum" width="80" align="center" >
						实销量
					</th>
					<th field="kcNum" width="80" align="center" >
						库存量
					</th>
					<th field="ddNum" width="80" align="center" >
						订单数
					</th>
					<th field="xstp" width="80" align="center" >
						售销类型
					</th>
					<th field=xxd width="80" align="center" formatter="formatterSt">
						新鲜度
					</th>
					<th field="remo" width="100" align="center" >
						备注
					</th>
				</tr>
			</thead>
		</table>
		<script type="text/javascript">
			function formatterSt(v,row){
				if(v>0){
				   return "临期("+v+")";
				}else{
				   return "正常";
				}
			}
		</script>
	</body>
</html>
