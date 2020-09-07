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
		
	</head>

	<body >
	<input type="hidden" id="accId" value="${accId}" />
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						id
					</th>
					
					
					
				</tr>
			</thead>	
		</table>
		
		<div id="tb" style="padding:5px;height:auto">	
		<div style="margin-bottom:5px">   
		
		</div>	
		<div>
		  		
			
			日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	  
	           
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder();">查询</a>
			
			  <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>
			<!--  <a class="easyui-linkbutton" iconCls="icon-print" href="javascript:myexport();">导出</a>-->
			<!--<a class="easyui-linkbutton" iconCls="icon-redo" plain="true" href="javascript:toLoadExcel();">导出</a>-->
			</div>
		</div>
		<div>
		  	<form action="manager/orderExcel" name="loadfrm" id="loadfrm" method="post">
		  		<input type="text" name="orderNo2" id="orderNo2"/>
				<input type="text" name="khNm2" id="khNm2"/>
				<input type="text" name="memberNm2" id="memberNm2"/>
				<input type="text" name="sdate2" id="sdate2"/>
				<input type="text" name="edate2" id="edate2"/>
				<input type="text" name="orderZt2" id="orderZt2"/>
				<input type="text" name="pszd2" id="pszd2"/>
		  	</form>
	  	</div>
		<%@include file="/WEB-INF/page/export/export.jsp"%>
		<script type="text/javascript">
		    var database="${database}";
		   //$("#billStatus").val("未收货");
		    //initGrid();
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
							field: 'billId',
							title: 'billId',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'status',
							title: 'status',
							width: 50,
							align:'center',
							hidden:'true'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'remarks',
							title: '类型',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'billNo',
							title: '单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'accTimeStr',
							title: '日期',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'objName',
							title: '往来单位',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'inAmt',
							title: '收入金额',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outAmt',
							title: '支出金额',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'leftAmt',
							title: '余额',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'remarks1',
							title: '备注',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'operator',
							title: '操作员',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	     	    
		    	    
		    	    
		    	   

		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryAccIoPage",
		    	    	queryParams:{		    	    		
							accId:$("#accId").val(),							
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
			    	    	
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	],
	    	    		  	 rowStyler:function(index,row){    
			    	    		  	 if (row.status==2){      
			   	    		             return 'color:blue;text-decoration:line-through;font-weight:bold;';      
			   	    		         } 
			   	    		         if (row.status==3){      
			   	    		             return 'color:#FF00FF;font-weight:bold;';      
			   	    		         }  
			   	    		         if (row.status==4){      
			   	    		             return 'color:red;font-weight:bold;';      
			   	    		         }
	    	    		     }   	
		    	    		  	
			    	    	}
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
			}
			function queryorder(){
				$("#datagrid").datagrid('load',{
					url:"manager/queryAccIoPage?database="+database,					
					accId:$("#accId").val(),									
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			//导出
			
			
			
			
			function amtformatter(v,row)
			{
				if (row != null) {
                    return toThousands(v);//numeral(v).format("0,0.00");
                }
			}	    

		    
			
			function onDblClickRow(rowIndex, rowData)
		    {
				var billName = "";
				var path = "";
				if(rowData.remarks == "销售收入")
					{
						billName = "销售发票";
						//path = "showstkout";
						path ="showstkoutNo";
					}
				if(rowData.remarks == "收货款单")
				{
					billName = "收货款单";
					//path = "showstkout";
					path ="showstkoutNo";
				}
				if(rowData.remarks == "收货货款")
				{
					billName = "收货货款";
					//path = "showstkout";
					path ="showStkpay";
				}
				if(rowData.remarks == "付货货款")
				{
					billName = "付货货款";
					//path = "showstkout";
					path ="showstkoutNo";
				}
				if(rowData.remarks == "付货款单")
				{
					billName = "付货款单";
					//path = "showstkout";
					path ="showstkoutNo";
				}
				
				if(rowData.remarks == "采购支出")
					{
						billName = "采购发票";
						path = "showstkin";
					}
				if(rowData.remarks == "销售退货支出")
				{
					billName = "销售退货发票";
					path = "showstkin";
				}
				if(rowData.remarks == "往来预收")
				{
					billName = "往来预收";
					path = "showFinPreInEdit";
				}
				if(rowData.remarks == "往来预付")
				{
					billName = "往来预付";
					path = "showFinPreOutEdit";
				}
				if(rowData.remarks == "往来借出")
					{
						billName = "往来借出单";
						path = "showFinOutEdit";
					}
				if(rowData.remarks == "往来借入")
					{
						billName = "往来借入单";
						path = "showFinInEdit";
					}
				if(rowData.remarks == "借款收回")
					{
					billName = "往来借出单";
					path = "showFinOutEdit";
					}
				if(rowData.remarks == "还款支出")
				{
					billName = "往来借入单";
					path = "finaccio1";
				}
				if(rowData.remarks == "支出")
				{
					billName = "付款单";
					path = "showFinPayEdit";
				}
				if(rowData.remarks == "费用支付")
				{
					billName = "费用支付";
					path = "showFinPayEdit";
				}
				if(rowData.remarks == "收入")
				{
					billName = "收款单";
					path = "showFinRecEdit";
				}
				if(rowData.remarks == "其它收款")
				{
					billName = "其它收款";
					path = "showFinRecEdit";
				}
				if(rowData.remarks == "转入"||rowData.remarks == "转出")
				{
					billName = "内部转存";
					path = "showFinTransEdit";
				}
				if(rowData.remarks == "内部转入"||rowData.remarks == "内部转出")
				{
					billName = "内部转存";
					path = "showFinTransEdit";
				}
				if(rowData.remarks == "资金初始化")
				{
					billName = "资金初始化";
					path = "finInitMoney/edit";
					var url = 'manager/' + path + '?id=' + rowData.billId;
					parent.closeWin(billName);
					parent.add(billName,url);
					return;
				}
				if(path != "")
					{
					parent.closeWin(billName);
					var url = 'manager/' + path + '?billId=' + rowData.billId;
					if(rowData.remarks == "销售收入"){
						url = 'manager/' + path + '?billNo=' + rowData.billNo;
					}
					if(rowData.remarks == "还款支出"){
						url = 'manager/' + path + '?remarks=还款支出&billId=' + rowData.billId;
					}
		    		parent.add(billName,url);
				  }
					
		    }
			
			initGrid();
		   
		</script>
	</body>
</html>
