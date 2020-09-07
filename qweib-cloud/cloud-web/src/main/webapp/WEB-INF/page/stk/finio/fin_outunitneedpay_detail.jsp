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
	</head>

	<body >
	<input type = "hidden" id="billId" value="${billId}"/> 
	
			<input type="hidden" id="amtType" value="${amtType}"/>
			<input type="hidden" id="unitId" value="${unitId}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true"  pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		 
		</div>
		<script type="text/javascript">
		   //查询
		  
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true
							
											
					};
		    	    cols.push(col);
		    	    
		    	    
				  
		    	    var col = {
							field: 'proName',
							title: '往来单位',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'billTimeStr',
							title: '付款日期',
							width: 100,
							align:'center'
							
											
					};
				   cols.push(col);
		    	    
		    	    

				   var col = {
							field: 'accName',
							title: '付款账户',
							width: 100,
							align:'center'
							
											
					};
				   cols.push(col);
					
					
						
						var col = {
								field: 'totalAmt',
								title: '总金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
						
			    	    var col = {
								field: 'payAmt',
								title: '已回金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
			    	    var col = {
								field: 'needPay',
								title: '应回金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
					var col = {
							field: 'remarks',
							title: '备注',
							width: 150,
							align:'center'
							
							
											
					};
		    	    cols.push(col);
		    	    
		    	    
		    	    var col = {
							field: 'billStatus',
							title: '状态',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
					$('#datagrid').datagrid({
						url:"manager/queryFinOutPage1",
		    	    	queryParams:{							
		    	    		sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							
							isNeedPay:0,
							proId:'${unitId}'
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	  
			   }
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    
					parent.closeWin('往来借出开单' + rowData.id);
					parent.add('往来借出开单' + rowData.id,'manager/toFinOutEdit?billId=' + rowData.id);
		    }
			initGrid();
		</script>
	</body>
</html>
