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
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onClickCell: onClickCell">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">		     
			
			订单日期: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'sdate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         			-
	         		  <input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         		  <img onclick="WdatePicker({el:'edate'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	        			  
	        	
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder(0);">查询</a>
			<a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryorder(1);">查询所有</a>
			
		</div>
		
	  	
		
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		   //queryorder();
		   var queryType = 0;
		    function initGrid()
		    {
			    /*if(${stkRight.auditFlag} == 0)
				    {
			    		document.getElementById("auditBtn").style.display="none";
			    		document.getElementById("cancelBtn").style.display="none";
				    }
			    if(${stkRight.amtFlag} == 0)
				    {
			    		document.getElementById("payBtn").style.display="none";
			    		document.getElementById("freeBtn").style.display="none";
				    }*/
		    	
		    	    var cols = new Array(); 
		    	   
		    	    
		    	   
		    	    
		    	    var col = {
							field: 'amt1',
							title: '总应回款',
							width: 120,
							align:'center',
							formatter:function(value,row,index){
								return  '<u style="color:blue;cursor:pointer">'+numeral(value).format("0,0.00")+'</u>';
							 }
											
					};
		    	    cols.push(col);
		    	        	    

		    	    
			    	
			    	
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/queryFinOutNeedPayStat",
		    	    	queryParams:{							
							sdate:$("#sdate").val(),
							edate:$("#edate").val()
							
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	   // $('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(type){
		    	
		    	var outType = $("#inType").val();
		    	queryType = type;
		    	if(type == 0)
			    	{
				$("#datagrid").datagrid('load',{
					url:"manager/queryFinOutNeedPayStat?database="+database,					
					sdate:$("#sdate").val(),
					edate:$("#edate").val()
				});
			    	}
		    	else
			    	{
		    		$("#datagrid").datagrid('load',{
						url:"manager/toFinOutNeedPayStat?database="+database,					
						sdate:"",
						edate:"",
						inType:""
					});
			    	}
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryorder();
				}
			}
			
			
			
			function amtformatter(v,row,index)
			{
				if (row != null) {
					
						if(index == 0)
							{
							
							return '<u style="color:blue;cursor:pointer">'+numeral(v).format("0,0.00")+'</u>';
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
				
				parent.closeWin('销售发票');
				parent.add('销售发票','manager/pcstkout?orderId=0');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它出库');
				parent.add('其它出库','manager/pcotherstkout');
			}
			
		    
		    
		    function showPayList(billId)
		    {
		    	parent.closeWin('收款记录' + billId);
		    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
		    }

		    function onClickCell(index, field, value){
		    	var rows = $("#datagrid").datagrid("getRows");
		    	var row = rows[index];
		    	var sdate = $("#sdate").val();
		    	var edate = $("#edate").val();
		    	
		    	if(queryType != 0)
			    	{
			    	sdate="";
			    	edate="";
			    	outType="";
			    	}
		    	parent.closeWin('往来应收款统计');
		    	
		    	
		    	
		    	parent.add('往来应收款统计','manager/toFinOutNeedPayUnitStat?sdate=' + sdate + '&edate=' + edate );
			    
		    	
		    }


		    
		    
		</script>
	</body>
</html>
