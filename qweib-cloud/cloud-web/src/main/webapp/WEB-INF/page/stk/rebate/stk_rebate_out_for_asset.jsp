<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
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
		<table id="datagrid"  fit="true" singleSelect="false"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 80px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 80px;" value="${edate}" />
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
    
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		</div>
	
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		   //queryorder();
		    function initGrid()
		    {
		    	    var cols = new Array(); 
		    	    var col = {
							field: 'id',
							title: 'id',
							width: 50,
							align:'center',
							hidden:'true'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 135,
							align:'center',
							formatter:formatterEvent
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'khNm',
							title: '往来单位',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
					
		    	    var cols2 = new Array(); 
		    	    var col = {
							field: 'outDate',
							title: '单据日期',
							width: 120,
							align:'center'
											
					};
		    	    cols2.push(col);
		    	  
		    	   
		    	    var col = {
							field: 'disAmt1',
							title: '返利金额',
							width: 60,
							align:'center'
											
					};
		    	    cols2.push(col);

		    	    var col = {
							field: 'recAmt',
							title: '已付款',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols2.push(col);
		    	    var col = {
							field: 'freeAmt',
							title: '核销金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols2.push(col);
		    	    
		    	    var col = {
							field: 'needRec',
							title: '未付金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols2.push(col);
		    	    var col = {
							field: 'status',
							title: '单据状态',
							width: 60,
							align:'center',
							formatter:amtformatterStatus
											
					};
		    	    cols2.push(col);
		    	    var col = {
							field: 'recStatus',
							title: '付款状态',
							width: 60,
							align:'center'
											
					};
		    	    cols2.push(col);
			    	 
		    	
			    	isPay = 0;
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkRebateOut/stkRebateOutForPayPage",
		    	    	queryParams:{
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							recStatus:"-2",   //recStatus ==-2 排除暂存的单据
							status:1
			    	    	},
			    	    	frozenColumns:[
				    	    		  		cols
				    	    		  	],
		    	    		columns:[
		    	    		  		cols2
		    	    		  	]}
		    	    
		    	    );
			}
		  
			function queryorder(){
		    	var sts = $("#payStatus").val();
		    	isPay = 0;
				$("#datagrid").datagrid('load',{
					url:"manager/stkRebateOut/stkRebateOutForPayPage",
					memberNm:$("#memberNm").val(),					
					isPay:isPay,
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					recStatus:"-2",
					status:1
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			
			 function amtformatterStatus(v,row){
			    	if(v==-2){
			    		return "暂存";
			    	}
			    	if(v==1){
			    		return "已审批";
			    	}
			    	if(v==2){
			    		return "已作废";
			    	}
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
		    function onDblClickRow(rowIndex, rowData)
		    {
				showSourceBill(rowData.id);
		    }
		    function formatterEvent(v,row){
				 return '<a href="javascript:;;" onclick="showSourceBill('+row.id+')">'+v+'</a>';
			 }
		    function showSourceBill(sourceBillId){
				parent.closeWin('销售返利信息' + sourceBillId);
		    	parent.add('销售返利息' + sourceBillId,'manager/stkRebateOut/show?dataTp=1&billId=' + sourceBillId);
			 }
		   
		</script>
	</body>
</html>
