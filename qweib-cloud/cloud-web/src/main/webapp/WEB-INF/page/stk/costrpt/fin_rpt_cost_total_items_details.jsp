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
		<div>
			<input name="typeId" id="typeId" type="hidden" value="${typeId }"/>
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
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
		    var database="${database}";
		    function initGrid()
		    {
		    	    
		    	    var cols = new Array(); 
		    	    var col = {
							field: 'main_id',
							title: 'mainid',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'bill_no',
							title: '单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'cost_time',
							title: '费用日期',
							width: 100,
							align:'center',
							formatter:DateTimeFormatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'pro_name',
							title: '报销人员',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:'true'				
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'item_name',
							title: '科目名称',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'amt',
							title: '金额',
							width: 100,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
					
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryCostItemsDetails",
		    	    	queryParams:{
							isNeedPay:0,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							costType:$("#typeId").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryCostItemsDetails?database="+database,
					jz:"1",
					costType:$("#typeId").val(),
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
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			function DateTimeFormatter(v,row) {
			    if (v == undefined) {
			        return "";
			    }
			    var date = new Date(v);
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate();
                return y + '-' +m + '-' + d+ " "+date.getHours()+":"+date.getMinutes();
			}
			function onDblClickRow(rowIndex, rowData)
		    {
				parent.closeWin('费用报销' + rowData.main_id);
		    	parent.add('费用报销' + rowData.main_id,'manager/showFinCostEdit?billId=' + rowData.main_id);
					
		    }
			initGrid();
			
		</script>
	</body>
</html>
