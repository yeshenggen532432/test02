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
	<input type="hidden" id="sdate" value="${sdate}"/>
	<input type="hidden" id="edate" value="${edate}"/>
	<input type="hidden" id="stkUnit" value="${stkUnit}"/>
	<input type="hidden" id="outType" value="${outType}"/>
	<input type="hidden" id="wtype" value="${wtype}"/>
	<input type="hidden" id="regionId" value="${regionId}"/>
	<input type="hidden" id="timeType" value="${timeType}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" >
			
		</table>
		
		<script type="text/javascript">
		   //查询
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
			   /*var col = {
						field: 'unitId',
						title: 'unitId',
						width: 100,
						align:'center',
						hidden:true
						
						
										
				};
	    	    cols.push(col);*/
			   
	    	   var col = {
						field: 'stkUnit',
						title: '客户名称',
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
						field: 'sumQty',
						title: '销售数量',
						width: 80,
						align:'center',
						formatter:amtformatter,
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'sumAmt',
						title: '销售收入',
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'avgPrice',
						title: '平均单位售价',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    
	    	    
	    	    var col = {
						field: 'sumCost',
						title: '销售成本',
						width: 80,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    /*var col = {
						field: 'sumFree',
						title: '其它促销赠送',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);*/
					
	    	    var col = {
						field: 'disAmt',
						title: '销售毛利',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'avgAmt',
						title: '平均单位毛利',
						width: 100,
						align:'center',
						formatter:amtformatter
						
										
				};
	    	    cols.push(col);

			   var col = {
				   field: 'epCustomerName',
				   title: '所属二批',
				   width: 100,
				   align:'center'


			   };
			   cols.push(col);
				
				
				$('#datagrid').datagrid({
					url:"manager/queryCstStatDetailPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						outType:$("#outType").val(),
						stkUnit:$("#stkUnit").val(),
						timeType:$("#timeType").val(),
						regionId:$("#regionId").val()
						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
    	   // $('#datagrid').datagrid('reload'); 
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
			//回车查询
			
			
			
		</script>
	</body>
</html>
