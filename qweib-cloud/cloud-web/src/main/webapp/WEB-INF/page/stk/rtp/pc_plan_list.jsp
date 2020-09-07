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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
		<a class="easyui-linkbutton" iconCls="icon-add" plain="true" href="javascript:newBill();">开单</a>
			
		</div>
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        		    		  
	        	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			
		</div>
		<script type="text/javascript">
		    var database="${database}";
		   
		   //queryorder();
		    function initGrid()
		    {
			    
		    	
		    	    var cols = new Array(); 
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 150,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    
		    	   
		    	    
		    	    var col = {
							field: 'planTimeStr',
							title: '日期',
							width: 150,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 150,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    
					
		    	    var col = {
							field: 'operator',
							title: '操作员',
							width: 180,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	   
		    	    
		    	    

		    	    
			    	
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryPlanList",
		    	    	queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
							
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(){
		    	
				$("#datagrid").datagrid('load',{
					url:"manager/queryPlanList?database="+database,
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			
			
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return numeral(v).format("0,0.00");
                }
			}
			
			
			
			function formatterSt2(val,row){
			  if(row.list.length>0){
			    if(val=='未审核'){
		            return "<input style='width:60px;height:27px' type='button' value='未审核' onclick='updateOrderSh(this, "+row.id+")'/>";
			     }else{
			        return val;   
			     }
			  }
		    } 


			
			 
			
			function showInfo()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					
				}
				if(ids.lenth > 1)
					{
					 	alert("只能选择一条记录");
					 	return;
					}
				if(ids.length == 0)
					{
					alert("请选择要查看的记录");
				 	return;
					}
				parent.closeWin('销售出库' + ids[0]);
				parent.add('销售出库' + ids[0],'manager/showstkout?dataTp=1&billId=' + ids[0]);
			}
			
			function newBill()
			{
				
				parent.closeWin('产品计划毛利统计开单');
				parent.add('产品计划毛利统计开单','manager/queryPlanWare');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它出库');
				parent.add('其它出库','manager/pcotherstkout');
			}
			

		    
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	//parent.add('收款记录' + rowData.id,'manager/queryRecPageByBillId?dataTp=1&billId=' + rowData.id);
		    	//if(rowData.outType == "销售出库")
		    	parent.closeWin('产品计划毛利' + rowData.id);
		    	parent.add('产品计划毛利' + rowData.id,'manager/showplan?dataTp=1&billId=' + rowData.id);
		    	//else
		    	//	parent.add('其它出库开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    }
		    
		    
		    
		    function formatterSt3(val,row){
		     
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+")'/>"
		      	        + "<input style='width:60px;height:27px' type='button' value='收款' onclick='toRec("+row.id+")'/>"
		      	        +"<input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+")'/>";
		      	        return ret;
		      		
		   } 
		</script>
	</body>
</html>
