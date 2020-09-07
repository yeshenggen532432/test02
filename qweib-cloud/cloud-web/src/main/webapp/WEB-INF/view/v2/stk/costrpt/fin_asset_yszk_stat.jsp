<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>资产汇算表-应收账款</title>
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
			<div id="tb" style="padding:5px;height:auto;">
		
			 <select name="outType" id="outType"  style="width: 120px;display: none">
	                    <option value="">全部</option>
	                    <option value="销售出库">销售单</option>
	                    <option value="其它出库">其它出库单</option>
	                </select>	
	       <select name="customerType" id="customerType" style="width: 100px;display: none"></select>       
			<input class="easyui-textbox" name="khNm" id="khNm" style="width:120px;display: none" onkeydown="querydata();"/>
			<input class="easyui-textbox" name="epCustomerName" id="epCustomerName" style="width:120px;display: none" onkeydown="querydata();"/>
	        <input class="easyui-textbox" name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;display: none"  />
	        <input class="easyui-textbox" name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
	        <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         		  <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:querydata();">查询</a>
			</div>
		<table id="datagrid" fit="true" singleSelect="true"
			 title=""  border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" 
			data-options="onDblClickRow: onDblClickRow" toolbar="#tb">
		</table>
		<script type="text/javascript">
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'unitid',
							title: 'unitid',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);		
				   
				   var col = {
							field: 'unitname',
							title: '往来单位',
							width: 200,
							align:'center'
					};
		    	    cols.push(col);	
		    	    var col = {
							field: 'epcustomername',
							title: '所属二批',
							width: 150,
							align:'center'
					};
		    	    cols.push(col);	
		    	    var col = {
							field: 'disamt',
							title: '销售金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	   
		    	    var col = {
							field: 'disamt1',
							title: '发货金额',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'recamt',
							title: '已收金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'freeamt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'sumamt',
							title: '欠款金额',
							width: 120,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);   	    
					var outType = $("#outType").val();
					$('#datagrid').datagrid({
						url:'manager/queryYskUnitStat',
						fitColumns:false,
			            rownumbers:true,
			            pagination:true, 
						queryParams:{
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:outType,
							epCustomerName:$("#epCustomerName").val(),
							unitName:$("#khNm").val(),
							customerType:$("#customerType").val()
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]
							/*,
	    	    		  	toolbar: [
	    	    		                { text: '收款纪录',iconCls:'icon-redo', handler: function () { showPayList();} },
	    	    		                { text: '待收款单据',iconCls:'icon-redo', handler: function () {toUnitRecPage(); } },
	    	    		                { text: '收款货统计',iconCls:'icon-redo', handler: function () {showRecStat(); } },
	    	    		                '-',
	    	    		                { text: '查询', iconCls: 'icon-search', handler: function () { querydata(); } }]*/
							}
	    	    );
			   }
			   
			function querydata(){			
				var outType = $("#outType").val();
				$("#datagrid").datagrid('load',{
					url:"manager/queryYskUnitStat",	
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:outType,
					unitName:$("#khNm").val(),
					epCustomerName:$("#epCustomerName").val(),
					customerType:$("#customerType").val()
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
				var outType = $("#outType").val();
				var sdate = $("#sdate").val();
				var edate = $("#edate").val();
				parent.closeWin('待收款单据');
		    	parent.add('待收款单据','manager/toUnitRecPage?sdate=' + sdate + '&edate=' + edate + '&outType=' + outType + '&unitName=' + rowData.unitname+'&epCustomerName='+rowData.epcustomername );
					
		    }
		   
		    function compute(colName) {
	            var rows = $('#datagrid').datagrid('getRows');
	            var total = 0;
	            for (var i = 0; i < rows.length; i++) {
	                total += parseFloat(rows[i][colName]);
	            }
	            return total;
	        }
		    
		    function loadCustomerType(){
				$.ajax({
					url:"manager/queryarealist1",
					type:"post",
					success:function(data){
						if(data){
						   var list = data.list1;
						    var img="";
						     img +='<option value="">--请选择--</option>';
						    for(var i=0;i<list.length;i++){
						      if(list[i].qdtpNm!=''){
						           img +='<option value="'+list[i].qdtpNm+'">'+list[i].qdtpNm+'</option>';
						       }
						    }
						   $("#customerType").html(img);
						 }
					}
				});
			}
	 loadCustomerType();
		</script>
	</body>
</html>
