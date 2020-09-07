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

	<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
	<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
</head>

<body onload="initGrid()">
<table id="datagrid"  fit="true" singleSelect="false"
	   iconCls="icon-save" border="false"
	   rownumbers="true" fitColumns="false" pagination="true"
	   pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"
	   data-options="onDblClickRow: onDblClickRow">

</table>
<div id="tb" style="padding:5px;height:auto">
	<input type="hidden" name="waretype" value="${waretype}" id="waretype" />
	<input type="hidden" name="isType" value="${isType}" id="isType" />
	商品名称: <input name="wareNm" id="wareNm" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
	仓库:
	<tag:select name="wareStk" id="stkId" tableName="stk_storage" headerKey="" headerValue="--请选择--" whereBlock="sale_Car=1" displayKey="id" displayValue="stk_name"/>
	<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querystorage();">查询</a>
	<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toBatchRtn();">车销回库</a>
</div>
<script type="text/javascript">
	function initGrid()
	{
		var cols = new Array();
		var col = {
			field : 'ck',
			checkbox : true
		};
		cols.push(col);
		var col = {
			field: 'stkId',
			title: 'stkId',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);
		var col = {
			field: 'wareId',
			title: 'wareId',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);
		var col = {
			field: 'hsNum',
			title: 'hsNum',
			width: 100,
			align:'center',
			hidden:true
		};
		cols.push(col);
		var col = {
			field: 'stkName',
			title: '仓库名称',
			width: 100,
			align:'center'


		};
		cols.push(col);
		var col = {
			field: 'wareNm',
			title: '商品名称',
			width: 100,
			align:'center'
		};
		cols.push(col);

		var col = {
			field: 'unitName',
			title: '大单位',
			width: 80,
			align:'center'


		};
		cols.push(col);

		var col = {
			field: 'sumQty',
			title: '库存数量',
			width: 80,
			align:'center',
			formatter:amtformatter
		};
		cols.push(col);

		var col = {
			field: '_sumQty',
			title: '大小数量',
			width: 120,
			align:'center',
			formatter:formatterQty
		};
		cols.push(col);

		var col = {
			field: 'sumAmt',
			title: '总金额',
			width: 100,
			align:'center',
			formatter:amtformatter,
			hidden:${!permission:checkUserFieldPdm("stk.storageWare.showamt")}
		};
		cols.push(col);

		var col = {
			field: 'avgPrice',
			title: '平均单价',
			width: 100,
			align:'center',
			formatter:amtformatter,
			hidden:${!permission:checkUserFieldPdm("stk.storageWare.showprice")}
		};
		cols.push(col);


		$('#datagrid').datagrid({
			url:"manager/queryStorageWareCarPage",
			queryParams:{
				waretype:"${waretype}"
			},
			columns:[
				cols
			]}
		);
	}
	function querystorage(wareType,isType){
		if(wareType!=undefined&&(wareType!=""||wareType==0)){
			$("#waretype").val(wareType)
		}
		if(isType!=undefined&&isType!=""||isType==0){
			$("#isType").val(isType)
		}
		$("#datagrid").datagrid('load',{
			url:"manager/queryStorageWareCarPage",
			wareNm:$("#wareNm").val(),
			stkId:$("#stkId").val(),
			waretype:$("#waretype").val(),
			isType:$("#isType").val()
		});
	}
	//回车查询
	function toQuery(e){
		var key = window.event?e.keyCode:e.which;
		if(key==13){
			querystorage();
		}
	}

	function formatterQty(v,row) {
		if(row.stkName=="合计："){
			return "";
		}
		var hsNum=row.hsNum;

		if(parseFloat(hsNum)>1){
			var str = row.sumQty+"";
			if(str.indexOf(".")!=-1){
				var nums = str.split(".");
				var num1 = nums[0];
				var num2 = nums[1];
				if(parseFloat(num2)>0){
					var minQty = parseFloat(0+"."+num2)*parseFloat(hsNum);
					minQty = minQty.toFixed(2);
					return num1+""+row.unitName+""+minQty+""+row.minUnitName;
				}
			}
		}
		return row.sumQty+row.unitName;

	}

	function amtformatter(v,row)
	{
		if(v==""){
			return "";
		}
		if(v=="0E-7"){
			return "0.00";
		}
		if (row != null) {
			return numeral(v).format("0,0.00");
		}
	}

	function toBatchRtn() {
		var stkId = "";
		var stkName = "";
		var wareIds = "";
		var rows = $("#datagrid").datagrid("getSelections");
		for ( var i = 0; i < rows.length; i++) {
			if(wareIds!=""){
				wareIds = wareIds +",";
			}
			if(stkId==""){
				stkId = rows[i].stkId;
				stkName = rows[i].stkName;
			}
			wareIds += rows[i].wareId;
			if(stkId!==rows[i].stkId){
				alert("请选择相同的仓库！");
				return;
			}
		}
		parent.parent.closeWin("移库开单");
		parent.parent.add("移库开单",'manager/stkMove/add?stkId='+stkId+'&stkName='+stkName+'&wareIds='+wareIds);
	}

	function onDblClickRow(rowIndex, rowData)
	{
		parent.parent.closeWin('库存明细' + rowData.wareId);
		parent.parent.add('库存明细' + rowData.wareId,'manager/toStkDetail?stkId=' + rowData.stkId + '&wareId=' + rowData.wareId);
	}
</script>
</body>
</html>
