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

	<body onload="initGrid()">
	<div id="tb" style="padding:5px;height:auto">
		   时间: <input name="sdate" id="sdate"  onClick="WdatePicker();" style="width: 100px;" value="${sdate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'stime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         	   -
	         	<input name="edate" id="edate"  onClick="WdatePicker();" style="width: 100px;" value="${edate}" readonly="readonly"/>
	         	   <img onclick="WdatePicker({el:'etime'})" src="resource/skin/datePicker.gif" width="16" height="22" align="absmiddle" style="cursor: pointer;"/>
	         <select name="outType" id="outType" style="display: none">
                   <option value="1">非返利收款</option>
                   <option value="2">返利收款</option>
               </select>		   
	        收款单号: <input name="billNo" id="billNo" style="width:120px;" onkeydown="toQuery(event);"/>
	        往来单位: <input name="proName" id="proName" style="width:120px;" onkeydown="toQuery(event);"/>
		    收款人: <input name="memberNm" id="memberNm" style="width:120px;" onkeydown="toQuery(event);"/> 
	               <br/>
	          发票单号: <input name="sourceBillNo" id="sourceBillNo" style="width:120px;" value="${sourceBillNo}" onkeydown="toQuery(event);"/>
	           单据状态:  <select name="status" id="status">
	                    <option value="">全部</option>
	                    <option value="0">正常单</option>
	                    <option value="2">作废单</option>
	                    <option value="3">被冲红单</option>
	                    <option value="4">冲红单</option>
	                </select>
	            类型:  <select name="billType" id="billType">
	                    <option value="">全部</option>
	                    <option value="0">收款</option>
	                    <option value="1">核销</option>
	                </select>    
	            <a class="easyui-linkbutton" iconCls="icon-search" href="javascript:queryrecdetail();">查询</a> 
	             <a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:cancelPay();">作废</a> 
	            
	              <span style="background-color:#FF00FF;border: 1;color:white ">&nbsp;被冲红单&nbsp;</span>&nbsp;<span style="background-color:red;border: 1;color:white">&nbsp;&nbsp;&nbsp;冲红单&nbsp;&nbsp;&nbsp;</span>&nbsp;<span style="background-color:blue;border: 1;color:white">&nbsp;&nbsp;&nbsp;作废单&nbsp;&nbsp;&nbsp;</span>
		</div>
	<input type = "hidden" id="billId" value="0"/>
		<table id="datagrid"  fit="true" singleSelect="true"
			iconCls="icon-save" border="false"
			rownumbers="true"  pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb"   showToper="true" data-options="onDblClickRow: onDblClickRow">
		</table>
		
		<script type="text/javascript">
				$("#outType").val('${outType}');
			   function initGrid()
			   {
				   var cols = new Array(); 
				   var col = {
							field: 'id',
							title: 'id',
							width: 100,
							align:'center',
							hidden:true
					};
		    	    cols.push(col);
				  
		    	    var col = {
							field: 'billNo',
							title: '单据号',
							width: 140,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'sourceBillNo',
							title: '发票据号',
							width: 140,
							align:'center',
							formatter:formatterEvent
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
							field: 'recTimeStr',
							title: '收款日期',
							width: 100,
							align:'center'
					};
				   cols.push(col);

		    	    var col = {
							field: 'memberNm',
							title: '收款人',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

		    	   

						
						var col = {
								field: 'sumAmt',
								title: '总收款/核销金额',
								width: 100,
								align:'center'
								
												
						};
			    	    cols.push(col);
					var col = {
							field: 'cash',
							title: '现金',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'bank',
							title: '银行转账',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'wx',
							title: '微信',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'zfb',
							title: '支付宝',
							width: 100,
							align:'center'
							
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'preAmt',
							title: '抵扣预收款',
							width: 100,
							align:'center'
					};
		    	    cols.push(col);

		    	    var col = {
							field: 'billTypeStr',
							title: '类型',
							width: 100,
							align:'center'
							
							
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'status',
							title: '状态',
							width: 80,
							align:'center',
							formatter:formatterStr
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'itemName',
							title: '费用项目',
							width: 150,
							align:'center'
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'remarks',
							title: '备注',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   
		    	    var outType=$("#outType").val();
		    	    var sourceBillNo=$("#sourceBillNo").val();
					$('#datagrid').datagrid({
						url:"manager/stkRecPage?billId=${billId}&sourceBillNo="+sourceBillNo+"&outType="+outType+"&dataTp=${dataTp}",
						height:90,		
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
			   }
			function queryrecdetail(){
				$("#datagrid").datagrid('load',{
					url:"manager/stkRecPage",
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					billId:$("#billId").val(),
					khNm:$("#proName").val(),
					memberNm:$("#memberNm").val(),
					billNo:$("#billNo").val(),
					status:$("#status").val(),
					billType:$("#billType").val(),
					sourceBillNo:$("#sourceBillNo").val()
				});
			}
			//回车查询
			function toQuery(e){
				var key = window.event?e.keyCode:e.which;
				if(key==13){
					queryrecdetail();
				}
			}
			
			
			
			function cancelPay()
			{
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					/* if(rows[i].billStatus=='作废'){
					   alert("该单已经作废");
					   return;
					} */
					if(rows[i].status!=0){
						   alert("非正常单，不能作废");
						   return;
						}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '是否确认作废收款单？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/cancelRec",
								data : "id=" + ids[0],
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else{
										showMsg("作废失败:" + json.msg);
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
				}
			}
			
			 function formatterStr(v,row){
				   if(v==0){
					   return "正常";
				   }else if(v==2){
					   return "作废";
				   }else if(v==3){
					   return "被冲红单";
				   }else if(v==4){
					   return "冲红单";
				   }
				   
			   }
			 
			 function formatterEvent(v,row){
				 if(row.billNo=='合计:'){
					 return "";
				 }else
				 return "<a href='javascript:;;' onclick='showSourceBill("+row.billId+",\""+row.sourceBillNo+"\")'>"+v+"</a>";
			 }
			 
			 function showSourceBill(sourceBillId,sourceBillNo){
			    	if(sourceBillNo.indexOf("CSH")!=-1){
						//parent.closeWin('应收初始化发票信息' + sourceBillId);
						//parent.add('应收初始化发票信息' + sourceBillId,'manager/showstkout?dataTp=1&billId=' + sourceBillId);
					}else{
						parent.closeWin('发票信息' + sourceBillId);
						parent.add('发票信息' + sourceBillId,'manager/showstkout?dataTp=1&billId=' + sourceBillId);
					}

			 }
			 function onDblClickRow(rowIndex, rowData)
			    {
				    var outType = $("#outType").val();
				 	parent.closeWin('收货款单信息');
			    	parent.add('收货款单信息','manager/showStkpay?dataTp=1&outType='+outType+'&billId=' + rowData.id);
			    }
		</script>
	</body>
</html>
