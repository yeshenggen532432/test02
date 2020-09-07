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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true">
		</table>
		<div id="tb" style="padding:5px;height:auto;display: none">
		 	 <input type="hidden" name="id" id="id" value="${id }"/>
		</div>
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
	    	    var col = {
						field: 'customerName',
						title: '销售客户',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'wareNm',
						title: '品项',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'billName',
						title: '销售类型',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'unitName',
						title: '单位',
						width: 80,
						align:'left'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'outQty',
						title: '发货数量',
						width: 100,
						align:'right'
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'unitAmt',
						title: '单位配送费用',
						width: 100,
						align:'right'
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'sumAmt',
						title: '配送费用',
						width: 80,
				};
	    	    cols.push(col);
				$('#datagrid').datagrid({
					url:"manager/querySaveRptDataStatItemPage",
					queryParams:{
						id:$("#id").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]
						}
    	    );
		   }
			
		</script>
	</body>
</html>
