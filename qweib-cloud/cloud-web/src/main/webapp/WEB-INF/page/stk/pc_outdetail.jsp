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
	<input type="hidden" id="sdate" value="${sdate}" />
	<input type="hidden" id="edate" value="${edate}" />
	<input type="hidden" id="stkId" value="${stkId}" />
	<input type="hidden" id="wareId" value="${wareId}" />
	<input type="hidden" id="khNm" value="${khNm}" />
	<input type="hidden" id="timeType" value="${timeType}" />
	<input type="hidden" id="xsTp" value="${xsTp}" />
	<input type="hidden" id="outType" value="${outType}" />
		<table id="datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="true" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" showFooter="true" 
			data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
	
		</div>
		<script type="text/javascript">
		   //查询
		   //querystorage();
		   //initGrid();
		   function initGrid()
		   {
			   var cols = new Array(); 
			   
			   var col = {
						field: 'billId',
						title: 'billId',
						width: 100,
						align:'center',
						hidden:true
						
										
				};
	    	    cols.push(col);
			   
	    	    <%--
	    	    var col = {
						field: 'stkUnit',
						title: '往来单位',
						width: 100,
						align:'center'
						
										
				};--%>
	    	    cols.push(col);
	    	     var col = {
						field: 'billNo',
						title: '单号',
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
						field: 'billName',
						title: '销售类型',
						width: 80,
						align:'center'
				};
	    	    cols.push(col);

	    	    var col = {
						field: 'unitName',
						title: '单位',
						width: 80,
						align:'center'
						
										
				};
	    	    cols.push(col);
				

	    	    var col = {
						field: 'outQty',
						title: '发货数量',
						width: 80,
						align:'center',
						formatter:amtformatter
				};
	    	    cols.push(col);
					
				
				var col = {
						field: 'price',
						title: '单价',
						width: 80,
						align:'center',
						formatter:priceformatter,
						hidden:${!permission:checkUserFieldPdm("stk.wareOutStat.showprice")}
				};
	    	    cols.push(col);
				
				
	    	    var col = {
						field: 'amt',
						title: '发货金额',
						width: 80,
						align:'center',
						hidden:${!permission:checkUserFieldPdm("stk.wareOutStat.showamt")}
						
										
				};
	    	    cols.push(col);
					
				$('#datagrid').datagrid({
					url:"manager/stkOutSubDetailPage",
					queryParams:{
						sdate:$("#sdate").val(),
						edate:$("#edate").val(),
						xsTp:$("#xsTp").val(),						
						stkUnit:$("#khNm").val(),
						stkId:$("#stkId").val(),
						wareId:$("#wareId").val(),
						timeType:$("#timeType").val(),
						outType:$("#outType").val(),
						ioType:1
						},
    	    		columns:[
    	    		  		cols
    	    		  	]}
    	    );
		   }
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					//querycpddtj();
				}
			}
		
			function onDblClickRow(rowIndex, rowData)
		    {
				var billName = rowData.billName;
				if("销售出库"==billName){
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
				}
		    }
			
			
			function priceformatter(v,row)
			{
				 var price = "";
				 var amt = row.outAmt;
				 var qty = row.outQty;
			    if(qty!=0){
			    	price = parseFloat(amt)/parseFloat(qty);
			    }
				 return  numeral(price).format("0,0.00");
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
