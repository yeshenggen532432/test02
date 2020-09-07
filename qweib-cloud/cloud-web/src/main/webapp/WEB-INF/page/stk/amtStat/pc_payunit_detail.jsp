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

	<body onload="initGrid()">
	<input type = "hidden" id="billId" value="${billId}"/> 
	<input type="hidden" id="ioType" value="${ioType}"/>
			<input type="hidden" id="amtType" value="${amtType}"/>
			<input type="hidden" id="unitId" value="${unitId}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
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
							field: 'billId',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true
							
											
					};
		    	    cols.push(col);
				  
		    	    var col = {
							field: 'proName',
							title: '供应商',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'payTimeStr',
							title: '付款日期',
							width: 100,
							align:'center'
							
											
					};
				   cols.push(col);
		    	    
		    	    var col = {
							field: 'memberNm',
							title: '付款人',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);

		    	   
					
					if(${stkRight.amtFlag} == 1)
						{
						
						var col = {
								field: 'sumAmt',
								title: '总付款/核销金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
						
					var col = {
							field: 'cash',
							title: '现金',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'bank',
							title: '银行转账',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'wx',
							title: '微信',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zfb',
							title: '支付宝',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
						}
					var col = {
							field: 'remarks',
							title: '备注',
							width: 150,
							align:'center'
							
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billTypeStr',
							title: '类型',
							width: 100,
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
		    	    var ioType = $("#ioType").val();
					$('#datagrid').datagrid({
						url:"manager/queryPayDetailPage",
		    	    	queryParams:{							
		    	    		sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:ioType,
							amtType:$("#amtType").val(),
							proId:$("#unitId").val()
			    	    	},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
			function querypaydetail(){
				var ioType = $("#ioType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/queryPayDetailPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					ioType:ioType,
					amtType:$("#amtType").val(),
					cstId:$("#unitId").val()
				});
			}
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
		    
					parent.closeWin('采购开单信息' + rowData.billId);
					parent.add('采购开单信息' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
		    }
			
			
			
			
		</script>
	</body>
</html>
