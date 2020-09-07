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
	<input type="hidden" id="sdate" value="${sdate}"/>
	<input type="hidden" id="edate" value="${edate}"/>
	<input type="hidden" id="ioType" value="${ioType}"/>
	<input type="hidden" id="unitId" value="${unitId}"/>
		<table id="datagrid" class="easyui-datagrid" fit="true" singleSelect="true"
			 title="" iconCls="icon-save" border="false"
			rownumbers="true" fitColumns="false" pagination="true" 
			pageSize=20 pageList="[10,20,50,100,200,500,1000]" toolbar="#tb" data-options="onDblClickRow: onDblClickRow">
			
		</table>
		<div id="tb" style="padding:5px;height:auto">			
			
		</div>	  	
		
		<script type="text/javascript">
		    var database="${database}";
		    //initGrid();
		   //queryorder();
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
							field: 'outDate',
							title: '发票日期',
							width: 120,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'outType',
							title: '出库类型',
							width: 80,
							align:'center'
											
					};
		    	    cols.push(col);
		    	    var col = {
							field: 'khNm',
							title: '收款对象',
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
			    	   
			    	    /*var col = {
								field: 'disAmt',
								title: '成交金额',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);*/

			    	    var col = {
								field: 'recAmt',
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
								field: 'needRec',
								title: '未收金额',
								width: 60,
								align:'center',
								formatter:amtformatter
												
						};
			    	    cols.push(col);
			    	    }
			    	    var col = {
								field: 'billStatus',
								title: '发货状态',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	    
			    	    var col = {
								field: 'recStatus',
								title: '收款状态',
								width: 60,
								align:'center'
												
						};
			    	    cols.push(col);
			    	    

		    	    
			    	var outType = $("#ioType").val();
			    	var isPay = 0;			    	
			    	
		    	    $('#datagrid').datagrid({
		    	    	url:"manager/stkOutPage1",
		    	    	queryParams:{
		    	    		jz:"1",											
							isPay:isPay,							
							sdate:$("#sdate").val(),
							edate:$("#edate").val(),
							outType:outType,
							cstId:$("#unitId").val()
			    	    	},
		    	    		columns:[
		    	    		  		cols
		    	    		  	]}
		    	    );
		    	    //$('#datagrid').datagrid('reload'); 
			}
		    //查询物流公司
			function queryorder(){
		    	var sts = $("#payStatus").val();
		    	var outType = $("#outType").val();
		    	var isPay = -1;
		    	if(sts == "已收款")isPay = 1;
		    	if(sts == "未收款")isPay = 0;
		    	if(sts == "作废")isPay = 2;
				$("#datagrid").datagrid('load',{
					url:"manager/stkOutPage1?database="+database,
					jz:"1",
					billNo:$("#orderNo").val(),
					khNm:$("#khNm").val(),
					memberNm:$("#memberNm").val(),					
					isPay:isPay,
					pszd:$("#pszd").val(),
					sdate:$("#sdate").val(),
					edate:$("#edate").val(),
					outType:outType,
					cstId:$("#unitId").val()
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
			
			function toRec(billId){
				
				var rows = $("#datagrid").datagrid("getRows");
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能收款");
							return;
						}
						
						
					
				}
				
				window.location.href='${base}/manager/stkrec?billId=' + billId;
			}
			
			function toFreePay(billId)
			{
				var rows = $("#datagrid").datagrid("getRows"); 
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id != billId)continue;
					if(rows[i].billStatus == "作废")
						{
							alert("作废单据不能核销");
							return;
						}
					$("#freeAmt").val(rows[i].needRec);
					$("#chooseId").val(billId);
					
				}
				$('#dlg').dialog('open');
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


			function freePay()
			{
				var billId = $("#chooseId").val();
				var rows = $("#datagrid").datagrid("getRows");
				var amt = 0;
				for ( var i = 0; i < rows.length; i++) {
					if(rows[i].id!= billId)continue;
					amt = rows[i].disAmt - rows[i].recAmt - rows[i].freeAmt;
					
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
							url : "manager/updateOutFreeAmt",
							data : "billId=" + billId + "&freeAmt=" +freeAmt,
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
		    //修改审核
		    function updateOrderSh(_this,id){
		      $.messager.confirm('确认', '您确认要审核吗？', function(r) {
			  if (r) {
				$.ajax({
					url:"manager/updateOrderSh",
					type:"post",
					data:"id="+id+"&sh=审核",
					success:function(data){
						if(data=='1'){
						    alert("操作成功");
							queryorder();
						}else{
							alert("操作失败");
							return;
						}
					}
				});
			  }
			 });
			 }
			 //导出成excel
		    function toLoadExcel(){
		        $('#orderNo2').val($('#orderNo').val());
				$('#khNm2').val($('#khNm').val());
				$('#memberNm2').val($('#memberNm').val());   
				$('#sdate2').val($('#sdate').val()); 
				$('#edate2').val($('#edate').val());
				$('#orderZt2').val($('#orderZt').val());  
				$('#pszd2').val($('#pszd').val()); 
				$('#loadfrm').form('submit',{
					success:function(data){
						alert(data);
					}
				});
			}
			//删除
		    function toDel() {
				var ids = "";
				var rows = $("#datagrid").datagrid("getSelections");
				for ( var i = 0; i < rows.length; i++) {
					if(ids == "")ids = rows[i].id;
					else ids = ids + "," + rows[i].id;
					
					if(rows[i].billStatus=='已审'||rows[i].billStatus=='作废'){
					   alert("该单不能删除");
					   return;
					}
				}
				if (ids != "") {
					$.messager.confirm('确认', '您确认想要删除记录吗？', function(r) {
						if (r) {
							$.ajax( {
								url : "manager/deleteStkOut",
								data : "ids=" + ids,
								type : "post",
								success : function(json) {
									if (json.state) {
										showMsg("删除成功");
										$("#datagrid").datagrid("reload");
									} else {
										showMsg("删除失败");
									}
								}
							});
						}
					});
				} else {
					showMsg("请选择要删除的数据");
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
				parent.add('采购入库审核' + ids[0],'manager/showstkoutcheck?dataTp=1&billId=' + ids[0]);
			}
		    function onDblClickRow(rowIndex, rowData)
		    {
		    	//parent.add('收款记录' + rowData.id,'manager/queryRecPageByBillId?dataTp=1&billId=' + rowData.id);
		    	//if(rowData.outType == "销售出库")
		    	parent.closeWin('销售开票信息' + rowData.id);
		    	parent.add('销售开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    	//else
		    	//	parent.add('其它出库开票信息' + rowData.id,'manager/showstkout?dataTp=1&billId=' + rowData.id);
		    }
		    function showPayList(billId)
		    {
		    	parent.closeWin('收款记录' + billId);
		    	parent.add('收款记录' + billId,'manager/queryRecPageByBillId?dataTp=1&billId=' + billId);
		    }

		    
		    
		   
		</script>
	</body>
</html>
