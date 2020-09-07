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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<div>
			<input type="hidden" name="proId" id="proId" value="${proId }"/>
			<input type="hidden" name="wareIds" id="wareIds" value="${wareIds }"/>
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
							field: 'ware_gg',
							title: '规格',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'cost_price',
							title: '成本价',
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

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkPickup/stockitempage",
		    	    	queryParams:{
							proId:$("#proId").val(),
							wareIds:$("#wareIds").val()
		    	    	},
	    	    		columns:[
		    	    		  		cols
		    	    		  	]
		    	    	}	  	
		    	    );
			}
			function query(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkPickup/stockitempage",
					proId:$("#proId").val(),
					wareIds:$("#wareIds").val()
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
		</script>
	</body>
</html>
