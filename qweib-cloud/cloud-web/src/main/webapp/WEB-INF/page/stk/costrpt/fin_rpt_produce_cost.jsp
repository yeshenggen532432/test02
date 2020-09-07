<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>制造费用一览表</title>

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
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
		</div>
		<table id="datagrid" class="easyui-datagrid" style="width:800px;"
    data-options="fitColumns:true,singleSelect:true,onDblClickRow: onDblClickRow">
		<thead>
				
		</thead>	
		</table>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    function initGrid()
		    {
		    	    var cols = new Array(); 
		    	    
		    	    var col = {
							field: 'pro_id',
							title: 'pro_id',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	  
		    	    var col = {
							field: 'pro_name',
							title: '部门',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'qc_amt',
							title: '期初余额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);

		    	   
		    	    var col = {
							field: 'in_amt',
							title: '本期增加',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'out_amt',
							title: '本期减少',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'qm_amt',
							title: '期末余额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/finRptProduceCost",
		    	    	queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function query(){
				var typeId = $("input[name='typeId']:checked").val();
				$("#datagrid").datagrid('load',{
					url:"manager/finRptProduceCost",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					typeId:typeId
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
				var accId = rowData.acc_id;
				var sdate = $('#sdate').val();
				var edate = $('#edate').val();
				if(accId==undefined){
					return;
				}
				parent.closeWin('账户明细');
		    	parent.add('账户明细','manager/toFinAccIo?sdate='+sdate+'&edate='+edate+'&accId=' + accId);
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
