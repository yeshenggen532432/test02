<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>发货明细</title>

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
	<input type="hidden" id="typeId" value="${typeId}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
			<input type="hidden" id="staff" value="${staff}"/>
			<input type="hidden" id="xsTp" value="${xsTp}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"
			toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		
			
			  
			
		</div>
		
		<script type="text/javascript">
		    var database="${database}";
		    //queryBasestorage();
		    
		    //initGrid();
		    //querydata;
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'billId',
							title: 'billId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);	
				   	
				   
				   var col = {
							field: 'billNo',
							title: '单号',
							width: 130,
							align:'center'
					};
		    	    cols.push(col);
				   var col = {
							field: 'billTime',
							title: '日期',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);		    	    
		    	    
		    	    
		    	    var col = {
							field: 'billNo',
							title: '发票单号',
							width: 130,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'khNm',
							title: '往来单位',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'wareNm',
							title: '商品名称',
							width: 80,
							align:'center'
							
											
					};
		    	    var col = {
							field: 'unitName',
							title: '单位',
							width: 80,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'price',
							title: '价格',
							width: 80,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'sumQty',
							title: '销售数量',
							width: 80,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'freeQty',
							title: '赠送数量',
							width: 80,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'sumAmt',
							title: '销售金额',
							width: 80,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);
				   
		    	    
	    	    var col = {
						field: 'billType',
						title: '类型',
						width: 80,
						align:'center'
						
						
										
				};
	    	    cols.push(col);			
	    	   
					
					
					
	    	    $('#datagrid').datagrid({
	    	    	url:"manager/queryWareTypeDetail",
					queryParams:{
						typeId:$("#typeId").val(),
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						staff:$("#staff").val(),
						xsTp:$("#xsTp").val()
						},
						
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    	);
			   }
			   
			   function queryData(){
				   
				   $('#datagrid').datagrid({
						url:"manager/queryWareTypeDetail",
						queryParams:{
							typeId:$("#typeId").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							staff:$("#staff").val(),
							xsTp:$("#xsTp").val()
							}
							}
	   	   			 );
			   }
			   function amtformatter(v,row)
				{
					if(v == null)return "";
				   	if(v=="0E-7"){
				   		return "0.00";
				   	}
				   	if (row != null) {
				           return numeral(v).format("0,0.00");
				    } 
				}
		    function onDblClickRow(rowIndex, rowData)
		    {
		    //alert(rowData.inQty);
				if(rowData.billType == "销售发票")
					{
					parent.closeWin('发票信息' + rowData.billId);
			    	parent.add('发票信息' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
					}
				else
					{
					//parent.closeWin('其它发货单信息' + rowData.outId);
					//parent.add('其它发货单信息' + rowData.outId,'manager/lookstkoutcheck?dataTp=1&billId=' + rowData.outId+'&sendId='+rowData.id);
					}
		    }

		   
		</script>
	</body>
</html>
