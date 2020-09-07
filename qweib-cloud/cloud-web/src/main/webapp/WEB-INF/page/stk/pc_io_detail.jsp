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
	<input type="hidden" id="wareId" value="${wareId}"/>
			<input type="hidden" id="billName" value="${billName}"/>
			<input type="hidden" id="stkId" value="${stkId}"/>
			<input type="hidden" id="billId" value="${billId}"/>
			<input type="hidden" id="sdate" value="${sdate}"/>
			<input type="hidden" id="edate" value="${edate}"/>
		
		<table id="datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false"
			toolbar="#tb" data-options="onDblClickRow: onDblClickRow,onLoadSuccess:onLoadSuccess">
			
		</table>
		<div id="tb" style="padding:5px;height:auto;">
		<div style="display: none">
		出入类型:<select name="xsTp" id="xsTp" value="${billName}">
	                  <option value="">全部</option>
					<option value="采购入库">采购入库</option>
					<option value="采购退货">采购退货</option>
					<option value="其它入库">其它入库</option>
					<option value="销售退货">销售退货</option>
					<option value="移库入库">移库入库</option>
					<option value="组装入库">组装入库</option>
					<option value="拆卸入库">拆卸入库</option>
					<option value="生产入库">生产入库</option>
					<option value="领料回库">领料回库</option>
					<option value="盘盈">盘盈</option>
				  <option value="销售退货">销售退货</option>
				  <option value="正常销售">正常销售</option>
				  <option value="促销折让">促销折让</option>
				  <option value="消费折让">消费折让</option>
				  <option value="费用折让">费用折让</option>
					<option value="其他销售">其他销售</option>
					<option value="其它出库">其它出库</option>
					<option value="移库出库">移库出库</option>
					<option value="组装出库">组装出库</option>
					<option value="拆卸出库">拆卸出库</option>
					<option value="领用出库">领用出库</option>
					<option value="领料出库">领料出库</option>
					<option value="报损出库">报损出库</option>
					<option value="借出出库">借出出库</option>
					<option value="盘亏">盘亏</option>
		</select>
		</div>
		</div>
		<div>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    //var database="${database}";
		    //queryBasestorage();
		    var billName = $("#billName").val();
		    $("#xsTp").val(billName);
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'stkId',
							title: 'stkId',
							width: 100,
							align:'center',
							hidden:true				
					};
				   cols.push(col);		
				   var col = {
							field: 'wareId',
							title: 'wareId',
							width: 100,
							align:'center',
							hidden:true
					};
				   cols.push(col);
				   
				   var col = {
							field: 'ioTimeStr',
							title: '日期',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 120,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'stkUnit',
							title: '往来单位',
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
							field: 'unitName',
							title: '单位',
							width: 50,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inQty',
							title: '入库数量',
							width: 80,
							align:'center',
							formatter:amtformatter
					};
		    	    cols.push(col);
	    	    
	    	    var col = {
						field: 'outQty',
						title: '出库数量',
						width: 80,
						align:'center',
						formatter:function(value,row,index){
							return  '<span style="color:blue">'+numeral(value).format("0,0.00");+'</span>';
							 }
				};
	    	    cols.push(col);
	    	    var col = {
						field: 'billName',
						title: '出入库类型',
						width: 100,
						align:'center'
				};
	    	    cols.push(col);
					
					$('#datagrid').datagrid({
						url:'manager/queryIoDetailList',
						queryParams:{
							wareId:$("#wareId").val(),
							stkId:$("#stkId").val(),
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							billName:$("#billName").val(),
							status:0
							},
	    	    		columns:[
	    	    		  		cols
	    	    		  	]}
	    	    );
				  //  $('#datagrid').datagrid('reload'); 
			   }
		    function onDblClickRow(rowIndex, rowData)
		    {
						var billName =rowData.billName;
						if("正常销售"==billName||"促销折让"==billName||"消费折让"==billName||"费用折让"==billName||"其他销售"==billName){
							parent.closeWin('销售出库详细' + rowData.billId);
							parent.add('销售出库详细' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
						}
						if("其它出库"==billName){
							parent.closeWin('其它出库详细' + rowData.billId);
							parent.add('其它出库详细' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="报损出库"){
							parent.closeWin('报损出库详细' + rowData.billId);
							parent.add('报损出库详细' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="借出出库"){
							parent.closeWin('借出出库详细' + rowData.billId);
							parent.add('借出出库详细' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="领用出库"){
							parent.closeWin('领用出库详细' + rowData.billId);
							parent.add('领用出库详细' + rowData.billId,'manager/showstkout?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="移库出库"){
							parent.closeWin('移库出库详细' + rowData.billId);
							parent.add('移库出库详细' + rowData.billId,'manager/stkMove/show?billId=' + rowData.billId);
						}else if("拆卸出库"==billName){
							parent.closeWin('拆卸出库详细' + rowData.billId);
							parent.add('拆卸出库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
						}else if("组装出库"==billName){
							parent.closeWin('组装出库详细' + rowData.billId);
							parent.add('组装出库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
						}
						else if("领料出库"==billName){
							parent.closeWin('领料出库详细' + rowData.billId);
							parent.add('领料出库详细' + rowData.billId,'manager/stkPickup/show?billId=' + rowData.billId);
						}
						else if("盘亏"==billName){
							parent.closeWin('盘亏出库详细' + rowData.billId);
							parent.add('盘亏出库详细' + rowData.billId,'manager/showStkcheck?billId=' + rowData.billId);
						}else if("销售退货"==billName){
							parent.closeWin('销售退货详细' + rowData.billId);
							parent.add('销售退货详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
						}else if(billName=="其它入库"){
							parent.closeWin('其它入库详细' + rowData.billId);
							parent.add('其它入库详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="采购入库"){
							parent.closeWin('采购入库详细' + rowData.billId);
							parent.add('采购入库详细' + rowData.billId,'manager/showstkin?dataTp=1&billId=' + rowData.billId);
						}
						else if(billName=="移库入库"){
							parent.closeWin('移库入库详细' + rowData.billId);
							parent.add('移库入库详细' + rowData.billId,'manager/stkMove/show?billId=' + rowData.billId);
						}else if("拆卸入库".indexOf(billName)!=-1){
							parent.closeWin('拆卸入库详细' + rowData.billId);
							parent.add('拆卸入库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
						}else if("组装入库"==billName){
							parent.closeWin('组装入库详细' + rowData.billId);
							parent.add('组装入库详细' + rowData.billId,'manager/stkZzcx/show?billId=' + rowData.billId);
						}
						else if("初始化入库"==billName){
							parent.closeWin('初始化入库详细' + rowData.billId);
							parent.add('初始化入库详细' + rowData.billId,'manager/showStkcheckInit?billId=' + rowData.billId);
						}else if("盘盈"==billName){
							parent.closeWin('盘盈入库详细' + rowData.billId);
							parent.add('盘盈入库详细' + rowData.billId,'manager/showStkcheck?billId=' + rowData.billId);
						}
						else if(billName=="生产入库"){
							parent.closeWin('生产入库详细' + rowData.billId);
							parent.add('生产入库详细' + rowData.billId,'manager/stkProduce/show?billId=' + rowData.billId);
						}
						else if(billName=="领料回库"){
							parent.closeWin('领料回库详细' + rowData.billId);
							parent.add('领料回库详细' + rowData.billId,'manager/showStkLlhkIn?billId=' + rowData.billId);
						}
		    }
		    function onLoadSuccess()
		    {
		    	

		    }
		    
		    function compute(colName) {

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
		</script>
	</body>
</html>
