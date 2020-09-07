<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>资产汇算表-其他应付往来款</title>
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
		<div>
			<input name="proName" id="proName" style="width:120px;height: 20px;display: none" onkeydown="toQuery(event);"/>
			<input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;display: none" readonly="readonly"/>
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<table id="datagrid" class="easyui-datagrid" style="width:500px;"
    data-options="fitColumns:true,singleSelect:true,onDblClickRow: onDblClickRow">
		<thead>
				<tr>
					
					<th field="costTimeStr" width="80" align="center">
						往来单位
					</th>
					<th field="proName" width="100" align="center">
						应还款金额
					</th>
				</tr>
			</thead>	
		</table>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    function initGrid()
		    {
		    	    var cols = new Array(); 
		    	    
		    	    var col = {
							field: 'proId',
							title: 'proId',
							width: 100,
							align:'center',
							hidden:'true'				
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
							field: 'needPay',
							title: '应还款金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryFinInTotal",
		    	    	queryParams:{
		    	    		jz:"1",
							proName:$("#proName").val(),
							isNeedPay:0,
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinInTotal?database="+database,
					jz:"1",
					proName:$("#proName").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			function onDblClickRow(rowIndex, rowData)
		    {
				var proId = rowData.proId;
				var proName = rowData.proName;
				var sdate = $('#sdate').val();
				var edate = $('#edate').val();
				if(proId==undefined){
					return;
				}
				parent.closeWin('应还款统计明细' + rowData.id);
		    	parent.add('应还款统计明细' + proId,'manager/toFinInTotalItem?proId='+proId+'&proName='+proName+'&sdate='+sdate+'&edate='+edate+'');
					
		    }
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			initGrid();
			
		</script>
	</body>
</html>
