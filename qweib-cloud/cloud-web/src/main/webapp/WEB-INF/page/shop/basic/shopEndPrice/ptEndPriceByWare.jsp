<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>会员分页</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@include file="/WEB-INF/page/include/source.jsp"%>
	<script type="text/javascript" src="resource/loadDiv.js"></script>
	<style type="text/css">
		table{
			padding-bottom: 60px;
		}
	</style>
</head>
<body>
<%--选择商品查看会员最终执行表--%>
<div id="tb11">
	<div>
		等级名称: <input name="gradeName" id="gradeName" style="width:156px;height: 20px;" />
		<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:query();">查询</a>
	</div>
</div>
<table id="dataGridMember" class="easyui-datagrid" fit="true" singleSelect="false"
	   url="manager/shopEndPrice/ptEndPriceByWare?wareId=${wareId}" border="false"
	   rownumbers="true" fitColumns="false" pagination="true" pagePosition="top"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb11">
	<thead>
	<tr>
		<%--<th field="id" checkbox="true"></th>--%>
		<%--<th field="name" width="80" align="center" >--%>
			<%--会员名称--%>
		<%--</th>--%>
		<%--<th field="mobile" width="100" align="center">--%>
			<%--电话--%>
		<%--</th>--%>
		<th field="gradeName" width="100" align="center">
			会员等级
		</th>
		<%--<th field="customerName" width="100" align="center">--%>
			<%--关联客户--%>
		<%--</th>--%>
		<th field="oper" width="150" align="center" formatter="formatterOper">
			操作
		</th>
		<th field="isJxc" width="120" align="center" formatter="formatterIsJxc">
			进销存客户会员使用
		</th>
		<%--<th field="shopWarePrice" width="120" align="center" styler=cellStyler1>--%>
		<%--商城批发价(大)--%>
		<%--</th>--%>
		<th field="shopWareLsPrice" width="120" align="center" styler=cellStyler2>
			商城零售价(大)
		</th>
		<%--<th field="shopWareCxPrice" width="120" align="center" styler=cellStyler3>
			商城大单位促销价
		</th>--%>
		<%--<th field="shopWareSmallPrice" width="120" align="center">--%>
			<%--商城批发价(小)--%>
		<%--</th>--%>
		<th field="shopWareSmallLsPrice" width="120" align="center" styler=cellStyler5 formatter="formatterMinPrice">
			商城零售价(小)
		</th>
		<%--<th field="shopWareSmallCxPrice" width="120" align="center" styler=cellStyler6 formatter="formatterMinPrice">
			商城小单位促销价
		</th>--%>
	</tr>
	</thead>
</table>

<script type="text/javascript">
	//查询会员
	function query(){
		$("#dataGridMember").datagrid('load',{
			url:"manager/shopEndPrice/ptEndPriceByWare?wareId=${wareId}",
			gradeName:$("#gradeName").val(),
		});
	}

	function formatterIsJxc(val,row){
		if(row.isJxc === 1){
			return '是';
		}
	}

	//-----------------设置风格start------------------------
	function cellStyler1(value,row){
		var source1 = row.shopWarePriceSource;
		switch (source1) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	function cellStyler2(value,row){
		var source2 = row.shopWareLsPriceSource;
		switch (source2) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	function cellStyler3(value,row){
		var source3 = row.shopWareCxPriceSource;
		switch (source3) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	function cellStyler4(value,row){
		var source4 = row.shopWareSmallPriceSource;
		switch (source4) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	function cellStyler5(value,row){
		var source5 = row.shopWareSmallLsPriceSource;
		switch (source5) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	function cellStyler6(value,row){
		var source6 = row.shopWareSmallCxPriceSource;
		switch (source6) {
			case 1:
				return 'color:orange;';
				break;
			case 2:
				return 'color:#333;';
				break;
			case 3:
				return 'color:blue;';
				break;
			case 4:
				return 'color:green;';
				break;
		}
	}
	//-----------------设置风格end------------------------
	function formatterMinPrice(val) {
		if(val!=null && val!=undefined && val!=""){
			val = val.toFixed(2)
		}
		return val;
	}
	function formatterOper(val,row){
		var id = row.id;
		var name = row.gradeName;
		return "<input value='商品最终执行价' type='button' onclick='queryEndPrice("+id+",\""+name+"\")' />";
	}

	function queryEndPrice(gradeId,name){
		parent.parent.closeWin(name+"_商品最终执行价");
		/*if(gradeId==null || gradeId == undefined || gradeId == '' || gradeId == 'undefined'){
			window.parent.parent.add(name+"_商品最终执行价","manager/shopEndPrice/toShopEndPriceByGrade");
		}else{*/
			window.parent.parent.add(name+"_商品最终执行价","manager/shopEndPrice/toShopEndPriceByGrade?gradeId="+gradeId);
		//}
	}
</script>
</body>
</html>
