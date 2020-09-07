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
	<input type="hidden" id = "sdate" value="${sdate}"/>
	<input type="hidden" id = "edate" value="${edate}"/>
	<input type="hidden" id = "inType" value="${ioType}"/>
	<input type="hidden" id = "unitId" value="${unitId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
		<thead>
				<tr>
				    <th field="id" width="50" align="center" hidden="true">
						出库单id
					</th>
					<th field="billNo" width="135" align="center">
						发票单号
					</th>
					
					<th field="inDate" width="80" align="center">
						发票日期
					</th>
					
					
					<th field="proName" width="100" align="center" >
						供应商
					</th>
					
					
					
					
				</tr>
			</thead>	
		</table>
		<div id="tb" style="padding:5px;height:auto">   
			
		</div>
		
	  	
		<script type="text/javascript">
		    var database="${database}";
		    initGrid();
		    
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
		    	var s = "";
		    	 //s = "[[";  
		    	    s = s + "{ field='id' title='入库id' width='50' align='center' hidden='true'},";
		    	    s = s + "{ field='billNo' title='单号' width='50' align='center'}";
		    	   // s = s + "]]"; 
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
							title: '发票单号',
							width: 135,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'inDate',
							title: '发票日期',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'inType',
							title: '入库类型',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	   

		    	    var col = {
							field: 'proName',
							title: '付款对象',
							width: 100,
							align:'center'
											
					};
		    	    cols.push(col);

		    	    
		    	    

		    	    if(${stkRight.amtFlag} == 1)
			    	    {
		    	    	var col = {
								field: 'disAmt',
								title: '发票金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    /* var col = {
								field: 'disAmt1',
								title: '实际入库金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);*/
			    	    

			    	    var col = {
								field: 'payAmt',
								title: '已付款',
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
								title: '未付金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    }
		    	    var col = {
							field: 'billStatus',
							title: '收货状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    
		    	    var col = {
							field: 'payStatus',
							title: '付款状态',
							width: 60,
							align:'center'
											
					};
		    	    cols.push(col);
		    	      	    

		    	    
					var inType = $("#inType").val();
			    	var isPay = 0;
			    	
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkInPage1",
		    	    	queryParams:{
		    	    		jz:"1",											
							isPay:isPay,
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							inType:inType,
							proId:$("#unitId").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    $('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(){
				
				var inType = $("#inType").val();
		    	var isPay = 0;
		    	
				$("#datagrid").datagrid('load',{
					url:"manager/stkInPage1?database="+database,
					jz:"1",									
					isPay:isPay,
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					inType:inType,
					proId:$("#unitId").val()
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
			function toPay(billId){
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("该单据已经作废");
							return;
						}
					
				}
				
				window.location.href='${base}/manager/stkpay?billId=' + billId;
			}
			
			function toFreePay(billId)
			{
				var rows = $("#datagrid").datagrid("getRows"); 
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
					{
						alert("该单据已经作废");
						return;
					}
					$("#freeAmt").val(rows[i].needPay);
					$("#chooseId").val(billId);
					
				}
				$('#dlg').dialog('open');
			}
			
			function freePay()
			{
				
				var billId = $("#chooseId").val();
				var rows = $("#datagrid").datagrid("getRows");
				var amt = 0;
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					/*if(rows[i].billStatus!='已收货'){
					   alert("该订单未审核，不可支付");
					   return;
					}*/
					amt = rows[0].disAmt - rows[0].payAmt - rows[0].freeAmt;
				}
				
				if(amt<= 0)
					{
						alert("该单已支付完成，不需要核销");
						return;
					}
				var freeAmt = $("#freeAmt").val();
				var msg = "是否确定核销?";
				$.messager.confirm('确认', msg, function(r) {
					if (r) {
						$.ajax( {
							url : "manager/updateFreeAmt",
							data : "billId=" + billId + '&freeAmt=' + freeAmt,
							type : "post",
							success : function(json) {
								if (json.state) {
									showMsg("核销成功");
									$('#dlg').dialog('close');
									$("#datagrid").datagrid("reload");
								} else{
									showMsg("核销失败" + json.msg);
								}
							}
						});
					}
				});
				
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
				parent.closeWin('采购入库'  + ids[0]);
				parent.add('采购入库'  + ids[0],'manager/showstkin?dataTp=1&billId=' + ids[0]);
			}

			function showCheck()
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
				/*if(rows[0].billStatus == "已审")
					{
						alert("该单据已经审核");
						return;
					}*/
					parent.closeWin('采购入库审核' + ids[0]);
				parent.add('采购入库审核' + ids[0],'manager/showstkincheck?dataTp=1&billId=' + ids[0]);
			}
			//作废
		    function toZf() {
				var ids = [];
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
					if(rows[i].orderZt=='未审核'){
					   alert("该订单未审核，不能作废");
					   return;
					}
					if(rows[i].orderZt=='已作废'){
					   alert("该订单已作废，不能再作废");
					   return;
					}
				}
				if (ids.length > 0) {
					$.messager.confirm('确认', '您确认想要作废该记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/updateOrderZf",
								data : "id=" + ids,
								type : "post",
								success : function(json) {
									if (json == 1) {
										showMsg("作废成功");
										$("#datagrid").datagrid("reload");
									} else if (json == -1) {
										showMsg("作废失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要作废的数据");
				}
			}
			
		    function newBill()
			{
				
		    	parent.closeWin('采购入库');
				parent.add('采购入库','manager/pcstkin');
			}
			
			function newOtherBill()
			{
				parent.closeWin('其它入库');
				parent.add('其它入库','manager/pcotherstkin');
			}
			
			
			
			function onDblClickRow(rowIndex, rowData)
		    {
				parent.closeWin('销售开票信息' + rowData.id);
				parent.add('销售开票信息' + rowData.id,'manager/showstkin?dataTp=1&billId=' + rowData.id);
		    	//parent.add('付款记录' + rowData.id,'manager/queryPayPageByBillId?dataTp=1&billId=' + rowData.id);
				
		    }
		    
		    function showPayList(billId)
		    {
		    	parent.closeWin('付款记录' + billId);
		    	parent.add('付款记录' + billId,'manager/queryPayPageByBillId?dataTp=1&billId=' + billId);
		    }
		    
		    function showPayStat()
		    {
		    	parent.closeWin('付款统计');
		    	parent.add('付款统计','manager/toPayStat?dataTp=1');
		    }
		    
		    function showNeedPayStat()
		    {
		    	parent.closeWin('付款统计');
		    	parent.add('付款统计','manager/toNeedPayStat?dataTp=1');
		    }
		    
		    
			function formatterSt3(val,row){
		     
		      	var ret = "<input style='width:60px;height:27px' type='button' value='查看明细' onclick='showPayList("+row.id+")'/>"
		      	 + "<input style='width:60px;height:27px' type='button' value='付款' onclick='toPay("+row.id+")'/>"
	      	        +"<input style='width:60px;height:27px' type='button' value='核销' onclick='toFreePay("+row.id+")'/>";
	      	        return ret;
		      		
		   } 
			
			
			
		</script>
		
	</body>
</html>
