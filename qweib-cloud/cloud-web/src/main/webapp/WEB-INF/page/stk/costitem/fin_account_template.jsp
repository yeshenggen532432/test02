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

	<body onload="initData()">
	<input type="hidden" id="accId" value="${accId}"/>
			
		
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"
			>
			
		</table>
		<script type="text/javascript">
		    var database="${database}";
		    function initData()
		    {
		    	initGrid();
		    }
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
							field: 'accTypeName',
							title: '账号类型',
							width: 80,
							align:'center'
										
					};
				   cols.push(col);		
				   
				   
				   var col = {
							field: 'accNo',
							title: '账号',
							width: 150,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    
		    	    var col = {
							field: 'bankName',
							title: '其它',
							width: 120,
							align:'center'
							
											
					};
		    	    cols.push(col);
				   
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 120,
							align:'center'
							
											
					};
		    	    cols.push(col);
	    	    $('#datagrid').datagrid(
	    	    		{
	    	    	url:"manager/queryAccountListTemplate",
	    	    	queryParams:{
	    	    		jz:"1"
		    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			   }
			
			function queryList(){
		    	    $('#datagrid').datagrid(
		    	    		{
		    	    	url:"manager/queryAccountListTemplate",
		    	    	queryParams:{
		    	    		jz:"1"
			    	    	}}
		    	    );
		    }
		</script>
	</body>
</html>
