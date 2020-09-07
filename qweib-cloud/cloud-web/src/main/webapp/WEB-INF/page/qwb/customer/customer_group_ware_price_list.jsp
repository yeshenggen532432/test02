<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>客户价格档案</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
</head>
<body>
<table id="datagrid"   fit="true" class="easyui-datagrid" singleSelect="false"
	   border="false"
	   url="manager/customerGroupWarePriceList?wareId=${sysWare.wareId}&wareDj=${sysWare.wareDj}&lsPrice=${sysWare.lsPrice}&fxPrice=${sysWare.fxPrice}
			&cxPrice=${sysWare.cxPrice}
			&sunitPrice=${sysWare.sunitPrice}
			&minLsPrice=${sysWare.minLsPrice}
			&minFxPrice=${sysWare.minFxPrice}
			&minCxPrice=${sysWare.minCxPrice}"
	   rownumbers="true" fitColumns="false" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
	<thead >
	<tr>
		<th field="ck" checkbox="true"></th>
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

	</tr>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	<%--
	<input name="wareId" id="wareId" value="${sysWare.wareId}" type="hidden"/>
	<input name="wareDj" id="wareDj" value="${sysWare.wareDj}" type="hidden"/>
	<input name="lsPrice" id="lsPrice" value="${sysWare.lsPrice}" type="hidden"/>
	<input name="fxPrice" id="fxPrice" value="${sysWare.fxPrice}" type="hidden"/>
	<input name="cxPrice" id="cxPrice" value="${sysWare.cxPrice}" type="hidden"/>
	<input name="sunitPrice" id="sunitPrice" value="${sysWare.sunitPrice}" type="hidden"/>
	<input name="minLsPrice" id="minLsPrice" value="${sysWare.minLsPrice}" type="hidden"/>
	<input name="minFxPrice" id="minFxPrice" value="${sysWare.minFxPrice}" type="hidden"/>
	<input name="minCxPrice" id="minCxPrice" value="${sysWare.minCxPrice}" type="hidden"/>
	--%>
	<%--
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
	--%>
</div>

<script type="text/javascript">

</script>
</body>
</html>
