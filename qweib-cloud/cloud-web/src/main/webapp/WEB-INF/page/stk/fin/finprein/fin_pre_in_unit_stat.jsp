<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>往来单位预收款统计</title>

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
			<input type="hidden" id="ioType" value="${ioType}"/>
			<input type="hidden" id="amtType" value="${amtType}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]"
			toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			往来单位: <input name="unitName" id="unitName" style="width:120px;height: 20px;" onkeydown="toQuery(event);"/>
			收款日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
			<img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			-
			<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
			<img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata(0);">查询</a>
		</div>
		<script type="text/javascript">
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
							title: '剩余预收金额',
							width: 120,
							align:'center',
							formatter:amtformatter
							
											
					};
		    	    cols.push(col);   	    
					var ioType = $("#ioType").val();
					$('#datagrid').datagrid({
						url:'manager/queryFinPreInUnitStat',
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							ioType:ioType,
							amtType:$("#amtType").val(),
							unitName:$("#unitName").val()
							
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
			   }
			function querydata(){			
		    	
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinPreInUnitStat",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					amtType:$("#amtType").val(),
					unitName:$("#unitName").val()
				});
			}
			function amtformatter(v,row,index)
			{
				if (row != null) {
					return numeral(v).format("0,0.00");
                }
			} 

		    function onDblClickRow(rowIndex, rowData)
		    {
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				var amtType = $("#amtType").val();
				parent.closeWin('往来单位预收明细');
		    	parent.add('往来单位预收明细','manager/toFinPreInUnitDetail?sdate=' + sdate + '&edate=' + edate  + '&unitName=' + rowData.unitName + '&amtType=' + amtType);
					
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
