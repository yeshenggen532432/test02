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

	<body>
	
			<input type="hidden" id="ioType" value="${ioType}"/>
			<input type="hidden" id="amtType" value="${amtType}"/>
			<input type="hidden" id="titleName" value="${titleName}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
			
			<div id="tb" style="padding:5px;height:auto">
			往来单位: <input name="khNm" id="khNm" style="width:120px;height: 20px;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
			</div>
		
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"
			toolbar="#tb" data-options="onDblClickRow: onDblClickRow,onLoadSuccess:onLoadSuccess">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">			
		</div>
		
		
		<script type="text/javascript">
		    //var database="${database}";
		    //queryBasestorage();
		    
		    initGrid();		   
		    
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'unitId',
							title: 'unitId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);		
				   
				   
				   var col = {
							field: 'unitName',
							title: '往来单位',
							width: 200,
							align:'center'
							
											
					};
		    	    cols.push(col);		    	   
		    	    var col = {
							field: 'sumAmt',
							title: '欠款金额',
							width: 120,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);   	    
					var ioType = $("#ioType").val();
					$('#datagrid').datagrid({
						url:'manager/queryNeedRecUnitStat',
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:ioType
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
	    	    $('#datagrid').datagrid('reload'); 
			   }
			function querydata(){			
				var ioType = $("#ioType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/queryNeedRecUnitStat",					
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:ioType,
					unitName:$("#khNm").val()
				});
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
				var outType = $("#ioType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var khNm = $("#khNm").val();
				//var amtType = $("#amtType").val();
				parent.closeWin('客户应收款明细');
		    	parent.add('客户应收款明细','manager/toNeedRecUnitDetail?sdate=' + sdate + '&edate=' + edate + '&ioType=' + outType + '&unitId=' + rowData.unitId );
					
		    }
		    function onLoadSuccess()
		    {
		    	
		    	/*$('#datagrid').datagrid('appendRow',{
		    		unitName: '<span class="subtotal">合计:</span>',
	                sumAmt: '<span class="subtotal">' + compute("sumAmt") + '</span>'
	              
		    		
		    	});*/
		    }
		    
		    function compute(colName) {
	            var rows = $('#datagrid').datagrid('getRows');
	            var total = 0;
	            for (var i = 0; i < rows.length; i++) {
	                total += parseFloat(rows[i][colName]);
	            }
	            return total;
	        }

		   
		</script>
	</body>
</html>
