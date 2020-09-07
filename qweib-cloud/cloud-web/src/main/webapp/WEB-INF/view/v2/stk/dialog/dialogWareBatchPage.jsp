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
		<table id="datagrid"  fit="true" singleSelect="true"
			url="<%=basePath %>/manager/dialogWareBatchPage?stkId=${stkId}&wareId=${wareId}" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tbdata"  data-options="onDblClickRow: onDblClickRow">
			
		</table>
		
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'sswId',
							width: 100,
							align:'center',
							hidden:true				
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
							field: 'wareNm',
							title: '商品名称',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'unitName',
							title: '单位',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'qty',
							title: '数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);
						
					// var col = {
					// 		field: 'inTimeStr',
					// 		title: '入库日期',
					// 		width: 130,
					// 		align:'center'
					// };
		    	    // cols.push(col);
		    		var col = {
							field: 'productDate',
							title: '生产日期',
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
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var json = {};
				if(rowData.productDate==""){
					 $.messager.alert('消息','生产日期为空，不能选择!','info');
					return;
				}
				var data = {
						sswId:rowData.id,
						productDate:rowData.productDate
				};
				json = data;
				window.setWareBatchNo(json);
		    }
			
		</script>
	</body>
</html>
