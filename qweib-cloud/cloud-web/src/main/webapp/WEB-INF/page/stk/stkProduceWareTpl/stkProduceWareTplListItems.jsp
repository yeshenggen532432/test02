<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>单个生产产品对应配料比</title>
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
<div>
	<%--
	<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:edit();">调整配置表</a>
	<a class="easyui-linkbutton" iconCls="icon-edit" href="javascript:quick();">快速领料</a>
	--%>
</div>
<table id="datagrid" style="width:700px;">
	<thead>
	</thead>
</table>
<div id="quickDialog" closed="true" class="easyui-dialog" style="width:370px; height:400px;" title="快速领料"
	 data-options="
				buttons: [{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						toSaveQuick();
					}
				},{
					text:'取消',
					handler:function(){
						$('#quickDialog').dialog('close');
					}
				}]
			"
>
	<iframe name="quickDialogfrm" id="quickDialogfrm" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%"></iframe>
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
			field: 'id',
			title: 'id',
			width: 100,
			align:'center',
			hidden:'true'
		};
		cols.push(col);
		var col = {
			field: 'relaWareNm',
			title: '主产品',
			width: 100,
			align:'center'

		};
		cols.push(col);
		var col = {
			field: 'relaUnitName',
			title: '主产品单位',
			width: 100,
			align:'center'

		};
		cols.push(col);

		var col = {
			field: 'wareNm',
			title: '关联材料',
			width: 100,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'unitName',
			title: '关联材料单位',
			width: 100,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'wareGg',
			title: '规格',
			width: 100,
			align:'center'
		};
		cols.push(col);
		var col = {
			field: 'qty',
			title: '配比数量',
			width: 100,
			align:'center'
		};
		cols.push(col);

		$('#datagrid').datagrid({
			url:"manager/stkProduceWareTpl/listItems",
			queryParams:{
				relaWareId:'${relaWareId}'
			},
			columns:[
				cols
			]}
		);
	}

	function edit(bizType)
	{
		window.location.href="manager/stkProduceWareTpl/edit";
	}

	function quick(){
		var billName="快速领料";
		parent.closeWin(billName);
		parent.add(billName,'<%=basePath%>manager/stkProduceWareTpl/mainWareList');
	}

	initGrid();
</script>
</body>
</html>
