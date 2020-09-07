<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>驰用T3</title>
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
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" >
		<thead>
				<tr>
				</tr>
			</thead>	
		</table>
		<div id="tb" style="padding:5px;height:auto">
			单据日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;"  />
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" />
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
		</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    initGrid();
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
							title: '返利单号',
							width: 135,
							align:'center',
							formatter:formatterEvent
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '单据日期',
							width: 120,
							align:'center'
											
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
							field: 'disAmt',
							title: '返利金额',
							width: 60,
							align:'center',
							formatter:amtformatter
											
					};
		    	    cols.push(col);
			    	 
			    	    var col = {
								field: 'payAmt',
								title: '已收金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    var col = {
								field: 'freeAmt',
								title: '核销金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    
			    	    var col = {
								field: 'needPay',
								title: '未收金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);

			    	isPay = 0;
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkRebateIn/stkRebateInForRecPage",
		    	    	queryParams:{
		    	    		jz:"1",
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							status:1
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload'); 
			}
		   
			function queryorder(){
				var sts = $("#payStatus").val();
		    	isPay = 0;
				$("#datagrid").datagrid('load',{
					url:"manager/stkRebateIn/stkRebateInForRecPage",
					jz:"1",
					isPay:isPay,
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					status:1
				});
			}

			 function formatterEvent(v,row){
				 return '<a href="javascript:;;" onclick="showSourceBill('+row.id+')">'+v+'</a>';
			 }
		    function showSourceBill(sourceBillId){
				parent.closeWin('采购返利信息' + sourceBillId);
		    	parent.add('采购返利信息' + sourceBillId,'manager/stkRebateIn/show?dataTp=1&billId=' + sourceBillId);
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
			
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
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
		
			
		</script>
		
	</body>
</html>
