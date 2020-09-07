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
<table id="datagrid"  class="easyui-datagrid"  fit="true" singleSelect="false"
	   url="manager/customerPage"
	   iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="false" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
	<thead frozen="true">
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
		<th field="_operater" width="140" align="center" formatter="formatterOper">
			操作
		</th>
	</tr>
	</thead>
	<thead>
	<tr>
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
		<th field="qdtpNm" width="80" align="center" >
			客户类型
		</th>
		<th field="memberNm" width="120" align="center" >
			业务员
		</th>
		<th field="memberMobile" width="120" align="center" >
			业务员手机号
		</th>
		<th field="longitude" width="100" align="center" >
			经度
		</th>
		<th field="latitude" width="100" align="center" >
			纬度
		</th>

	</tr>
	</thead>
</table>
<div id="tb" style="padding:5px;height:auto">
	<select name="qdtpNm" id="qdtpNm" style="display: none" ></select>
	客户名称: <input name="khNm" id="khNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	业务员: <input name="memberNm" id="memberNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>

	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:selectWareGroup();">按商品查询</a>
</div>

<script type="text/javascript">
	function query() {
		$("#datagrid").datagrid('load', {
			url: "manager/customerPage",
			khTp:2,
			dataTp:$("#dataTp").val(),
			qdtpNm:$("#qdtpNm").val(),
			khNm:$("#khNm").val(),
			memberNm:$("#memberNm").val(),
			isDb:2
		});
	}

	function formatterSt2(val,row){
		if(val=='1'){
			return "有效";
		}else{
			return "无效";
		}
	}
	//回车查询
	function toQuery(e){
		var key = window.event?e.keyCode:e.which;
		if(key==13){
			querycustomer();
		}
	}
	function formatterOper(val,row){
		return "<a href='javascript:;;' onclick='showWarePrice(\""+row.id+"\",\""+row.khNm+"\")'>商品最终执行价<a/>";
	}

	function showWarePrice(id,name){
		window.parent.close(name+"_商品最终执行价");
		window.parent.add(name+"_商品最终执行价","manager/toCustomerExecWarePriceTree?customerId="+id);
	}

	function selectWareGroup() {
		window.parent.close("按商品查询");
		window.parent.add("按商品查询","manager/toCustomerGroupWarePrice");
	}
</script>
</body>
</html>
