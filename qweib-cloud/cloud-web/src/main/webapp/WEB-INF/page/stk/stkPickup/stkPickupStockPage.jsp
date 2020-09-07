<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>领料库存</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<%@include file="/WEB-INF/page/include/source.jsp"%>
		<script type="text/javascript" src="${base}resource/WdatePicker.js"></script>
		<script src="<%=basePath %>/resource/stkstyle/js/numeral.min.js" type="text/javascript" charset="utf-8"></script>
	</head>

	<body >
		<table id="datagrid"  fit="true" singleSelect="false"
			 title=""  border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<div>
		   物料名称：<input name="wareNm" id="wareNm" />
	       车间：<tag:select name="proId" id="proId" tclass="pcl_sel" tableName="sys_depart" headerKey="" headerValue="" displayKey="branch_id" displayValue="branch_name"/>   
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:query();">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" plain="true" href="javascript:toBatchRtn();">领料回库</a>
		</div>
		</div>
		<div>
	  	</div>
		<script type="text/javascript">
			initGrid();
		    function initGrid()
		    {
		    	
		    	    var cols = new Array();
					var col = {
						field : 'ck',
						checkbox : true
					};
					cols.push(col);
		    	    var col = {
							field: 'pro_id',
							title: '车间',
							width: 135,
							align:'center',
							hidden:'true'	
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'pro_name',
							title: '车间',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'ware_nm',
							title: '物料名称',
							width: 135,
							align:'center'
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'ware_id',
							title: '物料名称',
							width: 135,
							align:'center',
							hidden:'true'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'ware_gg',
							title: '规格',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'cost_price',
							title: '平均成本价',
							width: 80,
							align:'center'	
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'qty',
							title: '领料数量',
							width: 80,
							align:'center',
							hidden:'true'	
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'out_qty',
							title: '已用数量',
							width: 80,
							align:'center',
							hidden:'true'	
					};
		    	    cols.push(col);
		    	    var col = {
							field: '_jcQty',
							title: '结存',
							width: 80,
							align:'center',
							formatter:formatterQty
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'cost_amt',
							title: '成本金额',
							width: 80,
							align:'center'
					};
		    	    cols.push(col);

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkPickup/stockpage",
		    	    	queryParams:{
							proId:$("#proId").val(),
							wareNm:$("#wareNm").val()
		    	    	},
	    	    		columns:[
		    	    		  		cols
		    	    		  	]
		    	    	}	  	
		    	    );
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkPickup/stockpage",
					proId:$("#proId").val(),
					wareNm:$("#wareNm").val()
				});
			}
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					query();
				}
			}
			
			function formatterQty(val,row){
				return parseFloat(row.qty)-parseFloat(row.out_qty);				
			}
			
			function formatterCost(val,row){
				var jcQty = parseFloat(row.qty)-parseFloat(row.out_qty);
				var costPrice = row.cost_price;
				var costAmt = parseFloat(jcQty)*parseFloat(costPrice);
				return costAmt.toFixed(2);				
			}
			
			 function onDblClickRow(rowIndex, rowData)
			    {
				 	var proId = rowData.pro_id;
				 	var wareId= rowData.ware_id;
			    	parent.closeWin("领料结存明细");
			    	parent.add("领料结存明细",'manager/stkPickup/tostockitempage?proId='+proId+'&wareIds='+wareId+'');
			    }

			 function toBatchRtn() {
				 var proId = "";
				 var proName = "";
				 var wareIds = "";
				 var rows = $("#datagrid").datagrid("getSelections");
				 if (rows && rows.length > 0) {
					 for (var i = 0; i < rows.length; i++) {
						 if(undefined==rows[i].pro_id){
							 alert("请勿选择合计行");
							 return false;
						 }
						 if (wareIds != "") {
							 wareIds = wareIds + ",";
						 }
						 if (proId == "") {
							 proId = rows[i].pro_id;
							 proName = rows[i].pro_name;
						 }
						 wareIds += rows[i].ware_id;
						 if (proId !== rows[i].pro_id) {
							 alert("请选择相同的车间回库！");
							 return;
						 }
					 }
					 parent.closeWin("领料回库制单");
					 parent.add("领料回库制单",'manager/pcllhkIn?proId='+proId+'&proName='+proName+'&wareIds='+wareIds);
				 }else{
					 alert('请勾选记录');
				 }
			 }
		</script>
	</body>
</html>
