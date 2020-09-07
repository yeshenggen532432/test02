<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>选择商品条码</title>
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
		<table id="datagrid"  fit="true" singleSelect="true"
			url="<%=basePath %>/manager/getWareByIds?ids=${ids}" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tbdata"  data-options="onDblClickRow: onDblClickRow">
			
		</table>
		
		<script type="text/javascript">
		    initGrid();
			   function initGrid()
			   {
				   var cols = new Array();
				   var col = {
							field: 'wareId',
							title: 'wareId',
							width: 100,
							align:'center',
							hidden:true
					};
				   cols.push(col);

				   var col = {
					   field: 'wareCode',
					   title: '商品代码',
					   width: 80,
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
					   field: 'wareDw',
					   title: '大单位',
					   width: 50,
					   align:'center'
				   };
				   cols.push(col);
				   var col = {
					   field: 'minUnit',
					   title: '小单位',
					   width: 50,
					   align:'center'
				   };
				   cols.push(col);
				   var col = {
					   field: 'packBarCode',
					   title: '大单位条码',
					   width: 100,
					   align:'center'
				   };
				   cols.push(col);

				   var col = {
					   field: 'beBarCode',
					   title: '小单位条码',
					   width: 100,
					   align:'center'
				   };
				   cols.push(col);


				   $('#datagrid').datagrid({
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
			function onDblClickRow(rowIndex, rowData)
		    {

				//window.setWareBatchNo(json);
				window.setWareCheckCode(rowData.wareCode);
				$('#wareBarDialog').dialog('close');
		    }
			
		</script>
	</body>
</html>
